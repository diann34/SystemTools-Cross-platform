# 01 需求 — SystemTools 跨平台功能迁移分析

- 案卷号：`systemtools-crossplatform-migration`
- 量级：**large**（跨 6 大功能域、约 200+ 源文件、涉及 Windows 原生依赖面广，但当前仅产出分析与方案，不写代码）
- 阶段：需求澄清已完成 → 本文件为需求定稿

## 1. 目标

以现有 Windows 专用插件 **SystemTools**（`E:\My Github Projects\SystemTools`，v3.0.0.0，依赖 ClassIsland 插件 API 2.2.0.0，宿主 `E:\ClassIsland-git-misha`）为蓝本，评估其全部用户可见功能，识别出

1. **可直接迁移**（纯 ClassIsland SDK / Avalonia / .NET BCL，零或近乎零 Windows 原生依赖）；
2. **轻改后迁移**（功能逻辑跨平台，但存在少量 Windows 专属调用，需替换为宿主平台抽象或等价实现）；
3. **不建议迁移**（深度绑定 Windows 专有能力，跨平台实现成本高或语义不成立）。

产出物为一个新的跨平台插件 **SystemTools-Cross-platform** 的**功能迁移决策清单**（不是代码）。

## 2. 范围

### 2.1 盘点范围（覆盖 SystemTools 全部用户可见功能域）

| 功能域 | 来源 |
| --- | --- |
| 主题 | `Themes\*`（Card-type Component、ClassWidgets 2 Style、Notch Style、Vertical Sidebar） |
| 组件 | `Controls\Components\*`（7 个：网络延迟、歌词显示、剪切板、本地一言、下节课是、更好轮播容器、LED 文本） |
| 规则集 | `Rules\*`（5 个：进程运行、课程表、时间表、时间段、媒体播放） |
| 触发器 | `Triggers\*`（7 个：悬浮窗、USB、热键、行动进行时、长时空闲、关键词、点击主界面） |
| 行动 | `Actions\*`（约 60 个，见 02 详表） |
| AI 功能 | `Services\*Ai*` + `VoskWorker\*` + AI 设置/对话窗口 |
| 设置页面 | `SettingsPage\*`（主设置、更多功能、AI 对话、悬浮窗编辑、关于、插件调试） |
| 悬浮窗 | `Services\FloatingWindowService.cs` + `ThirdParty\LiquidGlassAvaloniaUI\*` |
| 更多功能选项 | 主题自动切换、遮挡文字隐藏、内存清理、U 盘自动打开、虚拟放学等 |

### 2.2 目标平台

- **Linux**（ClassIsland 要求 X11；AGENTS.md 明确 "Linux requires X11; Wayland/XWayland not supported"）与 **macOS**。
- 是否同时保留 Windows 作为第三个目标（即"跨平台版同时支持三平台"），本需求按**默认只面向 Linux/macOS** 处理，Windows 继续由原 SystemTools 承载；若用户希望三平台合一，需作为后续澄清项确认（见 §6）。

### 2.3 非目标（本阶段明确不做）

- 不编写任何实现代码、不创建工程、不迁移文件。
- 不设计六部职责或执行阶段（本阶段只有需求 + 决策级方案）。
- 不给出函数级补丁或文件级实施步骤。

## 3. 约束

1. **宿主事实**：ClassIsland 本体是 Avalonia 跨平台应用（Win/macOS/Linux），`ClassIsland.Platforms.Abstractions` 提供 `IWindowPlatformService / IDesktopService / ISystemEventsService / IDesktopToastService / ILauncherService / ILocationService / IPlatformFilePickerService` 等跨平台抽象；但 SystemTools 当前几乎没有使用这些抽象，而是直接 P/Invoke。
2. **插件现状**：`SystemTools.csproj` 目标 `net10.0-windows10.0.19041.0`，`UseWindowsForms=true`，`Platforms=x64`，引用 `CsWin32 / System.Management / System.Speech / DlibDotNet / OpenCvSharp4.runtime.win`，并捆绑 win-x64 自包含的 `VoskWorker`。
3. **宿主平台边界**：Linux 仅 X11（无 Wayland 原生支持），会限制"全局热键 / 前台窗口枚举 / 桌面背景/显示器切换"等能力的可移植深度。
4. **结论必须可复核**：每个"可直接迁移/轻改/不建议"结论都要指向具体源码证据（文件 + 关键依赖）。

## 4. 风险（初步，细化见 02）

- **R1 原生依赖广泛**：CsWin32 P/Invoke 遍布 29 个文件，输入模拟、全局热键、窗口枚举、截图、桌面/显示器/电源、壁纸/主题色均依赖 Win32/WMI/WinRT。
- **R2 语音链路双引擎且均为 Windows 专属**：`KeywordSpeechService`=System.Speech(SAPI)，`VoskSpeechService`=外挂 `SystemTools.VoskWorker.exe`（NAudio.Wasapi + win-x64 自包含）。
- **R3 悬浮窗/液态玻璃依赖 GDI `CopyFromScreen` + `SetWindowDisplayAffinity`**，属 Windows 独有截图模型。
- **R4 人脸/Windows Hello 为 Windows 专有认证**，跨平台需换用宿主认证体系。
- **R5 功能语义在 Linux/macOS 上可能不成立**（如"仅第二屏幕""锁定屏幕""以管理员重启"），迁移需重新定义。

## 5. 验收标准

1. 产出一份覆盖全部功能域、逐功能三档分类的迁移清单（02-draft-solution.md）。
2. 清单对每个功能给出：平台依赖证据、可迁移性结论、轻改点或不可迁移理由。
3. 识别出跨平台版需要新增/依赖的宿主抽象清单（哪些 ClassIsland 平台服务可用、哪些需自建）。
4. 识别出工程级改造要点（TFM、包引用、VoskWorker、目录结构）。
5. 本阶段结束即可进入"方案评审"（门下省），不进入编码。

## 6. 未决项（非阻塞，记录备查）

- **U1 三平台 vs 仅 Linux/macOS**：跨平台版是否也支持 Windows。默认：仅 Linux/macOS。
- **U2 "轻改即可"的采纳边界**：哪些 B 档功能应纳入跨平台版首批范围（建议由门下省在评审中收敛）。
- **U3 目标 ClassIsland API 版本**：沿用 2.2.0.0，还是随本地 develop/v2 分支升级。
