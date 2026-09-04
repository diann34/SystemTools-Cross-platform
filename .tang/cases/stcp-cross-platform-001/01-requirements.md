# 01 需求 — SystemTools 跨平台功能迁移分析

- 案卷号：`stcp-cross-platform-001`
- 量级：**large**（跨 6 大功能域、约 200+ 源文件、Windows 原生依赖面广；本阶段仅产出分析 + 决策级方案，不写代码）
- 阶段：需求澄清已完成（3 项阻塞决定已由用户答复）→ 本文件为需求定稿

## 1. 目标

以现有 Windows 专用插件 **SystemTools**（`E:\My Github Projects\SystemTools`，v3.0.0.0，依赖 ClassIsland 插件 API 2.2.0.0，宿主 `E:\ClassIsland-git-misha`）为蓝本，遍历其全部用户可见功能，逐功能给出三档迁移结论：

1. **A 档 — 可直接迁移**：仅依赖 ClassIsland SDK / Avalonia / .NET BCL，零或近乎零 Windows 原生依赖；
2. **B 档 — 稍加修改即可跨平台**：功能逻辑跨平台，但含少量 Windows 专属调用，替换为宿主跨平台抽象或等价 OS 命令后即可；
3. **C 档 — 不迁移（或需独立立项）**：深度绑定 Win32/WMI/WinRT/Windows 认证/Windows 截图与输入模型，或功能语义在 Linux/macOS 上不成立。

产出物为新建插件 **SystemTools-Cross-platform** 的**功能迁移决策清单**（`02-draft-solution.md`，不是代码）。

## 2. 范围

### 2.1 盘点范围（覆盖 SystemTools 全部用户可见功能域）

| 功能域 | 来源 | 数量 |
| --- | --- | --- |
| 主题 | `Themes\*`（Card-type Component、ClassWidgets 2 Style、Notch Style） | 3 |
| 组件 | `Controls\Components\*` | 7 |
| 规则集 | `Rules\*` | 5 |
| 触发器 | `Triggers\*` | 7 |
| 行动 | `Actions\*`（含实验性、FFmpeg、AI、悬浮窗子类） | 约 60 |
| AI 功能 | `Services\*Ai*` + `VoskWorker\*` + AI 设置/对话窗口 | 若干 |
| 设置页面 | `SettingsPage\*`（主设置、更多功能选项、AI 对话、悬浮窗编辑、关于、插件调试） | 6 |
| 悬浮窗 | `Services\FloatingWindowService.cs` + `ThirdParty\LiquidGlassAvaloniaUI\*` | 1 域 |
| 更多功能选项 | 主题自动切换、遮挡文字隐藏、内存清理、U 盘自动打开、虚拟放学等 | 若干 |

### 2.2 目标平台（已决）

- **Windows + Linux + macOS 三平台并存**：新插件在三平台均能构建运行；**原 SystemTools 继续独立维护**，Windows 用户可在两者间任选。
- 因此新插件**不需要**承载原插件全部 Windows 专用功能以替代原插件；它只包含 A/B 两档可迁移功能，C 档 Windows 专属功能**留在原 SystemTools**。
- Linux 受宿主约束：ClassIsland 仅支持 X11（AGENTS.md 明确 "Linux requires X11; Wayland/XWayland not supported"）。

### 2.3 迁移范围（已决）

- **A 档 + B 档均纳入本期范围**：B 档「稍加修改即可跨平台」功能需在本期做适配改造后纳入新插件（如用宿主窗口抽象替换 Win32、用 OS 命令/DBus/pmset 替换电源与锁定、替换 Windows 语音与截图路径）。

### 2.4 命名与配置（已决）

- **独立 ID 与全新配置**：新插件采用独立命名空间/功能 ID 与全新配置结构，**不与并存的原 SystemTools 冲突**，也不复用原功能 ID。
- 推断（供门下省确认）：新插件 manifest `id` 建议 `SystemTools.CrossPlatform`（或 `SystemToolsX`），功能 ID 前缀建议 `SystemTools.X.*`，避免与原 `SystemTools.*` 撞车。

### 2.5 非目标（本阶段明确不做）

- 不编写任何实现代码、不创建工程、不迁移文件。
- 不设计六部职责或执行阶段（本阶段只有需求 + 决策级方案）。
- 不给出函数级补丁或文件级实施步骤。
- C 档中「可独立立项」项（语音链路跨平台化、屏幕截图、系统音量）本期不实施，仅记录。

## 3. 约束

1. **宿主事实**：ClassIsland 本体（misha/v2 分支）是 Avalonia 跨平台应用（Win/macOS/Linux），基础 TFM `net10.0`，另按 `CrossPlatformProps.props` 切到 `net10.0-windows10.0.19041.0` / `net10.0-macos26.5` / Linux（X11）。`ClassIsland.Platforms.Abstractions` 提供 `IWindowPlatformService / IDesktopToastService / ILauncherService / IPlatformFilePickerService / ISystemEventsService / IDesktopService / ILocationService / IAppLifetimeService` 等跨平台抽象；但 SystemTools 目前几乎不使用这些抽象，而是直接 P/Invoke。
2. **插件现状**：`SystemTools.csproj` 目标 `net10.0-windows10.0.19041.0`、`UseWindowsForms=true`、`Platforms=x64`，引用 `CsWin32 / System.Management / System.Speech / DlibDotNet / OpenCvSharp4.runtime.win`，并捆绑 win-x64 自包含 `VoskWorker`。**全仓库无任何 `#if` 编译期平台条件**，绝大多数 Windows 调用为硬编码，个别已有 `OperatingSystem.IsWindows()` 运行时守卫先例（`SystemMotionPreferences.cs:12-15`、`BackgroundPlayAudioAction.cs:89`）。
3. **宿主平台边界**：Linux 仅 X11（无 Wayland 原生），限制「全局热键 / 全局鼠标钩子 / 前台窗口枚举 / 显示器拓扑 / 桌面背景 / 输入注入」等能力的可移植深度。
4. **结论必须可复核**：每个 A/B/C 结论都要指向具体源码证据（文件 + 关键依赖），见 `02-draft-solution.md`。

## 4. 风险（初步，细化见 02）

- **R1 原生依赖广泛**：CsWin32 `using Windows.Win32`/`PInvoke.` 遍布 23 个文件，另有 13 个文件含活跃 `[DllImport]`（并集 33）；输入模拟、全局热键、窗口枚举、截图、桌面/显示器/电源、壁纸/主题色均依赖 Win32/WMI/WinRT。
- **R2 语音链路双引擎且均为 Windows 专属**：`KeywordSpeechService`=System.Speech(SAPI)；`VoskSpeechService`=外挂 `SystemTools.VoskWorker.exe`（NAudio.Wasapi + win-x64 自包含）。跨平台化属独立子项目级工作量。
- **R3 悬浮窗/液态玻璃背景采样依赖 GDI `CopyFromScreen`**：经典外观（Avalonia 窗口 + 拖拽 + 层级 + 主题 + 规则隐藏）可迁移，但液态玻璃与自适应背景需宿主背景采样方案。
- **R4 人脸 / Windows Hello 为 Windows 专有认证**：跨平台需换用宿主认证体系，不在本期范围。
- **R5 部分功能语义在 Linux/macOS 上可能不成立**（如「仅第二屏幕」「以管理员重启」「禁用/启用硬件设备」），归 C 档并注明理由。
- **R6 电源选项在 Linux/macOS 需提权**（polkit/sudo/pmset），B 档适配需明确权限与失败回退。

## 5. 验收标准

1. 产出一份覆盖全部功能域、逐功能 A/B/C 三档分类的迁移清单（`02-draft-solution.md`）。
2. 清单对每个功能给出：平台依赖证据、可迁移性结论、B 档轻改点或 C 档不可迁移理由。
3. 识别出跨平台版需要复用/新增的**宿主抽象清单**（哪些 ClassIsland 平台服务可用、哪些缺口需自建或降级）。
4. 识别出**工程级改造要点**（TFM、包引用、VoskWorker、目录结构、独立 ID 命名）。
5. 本阶段结束即可进入门下省评审，不进入编码。

## 6. 未决项（已会签收敛，最终以用户审批门确认为准）

- **U3 目标 ClassIsland API 版本**（会签：随 misha/v2 检出）：以 `E:\ClassIsland-git-misha` 本地检出的 `ClassIsland.PluginSdk`/`ClassIsland.Platforms.Abstractions` 为目标 API 基线，发布包 2.1.1.1 仅作后备。已证实该检出含 B 档所需 `IWindowPlatformService.SetWindowFeature` 三平台实现与 `ISystemEventsService`/`ILauncherService`/`IDesktopToastService`/`IDesktopService`。
- **U4 电源提权降级**（会签：接受降级默认）：B 档电源/锁屏/睡眠项执行前预检（命令/权限），无权限或命令缺失时不抛未处理异常，经 `IDesktopToastService` 通知降级结果；记录 per-OS 提权要求（Linux polkit/logind、macOS osascript/pmset）。
- **U5 液态玻璃**（会签：首期仅经典外观）：首期交付悬浮窗经典外观（B）；液态玻璃 + 自适应背景采样（含悬浮窗、AI 对话浮窗、自适应主题采样路径三个消费方）为 C 候选增强。
