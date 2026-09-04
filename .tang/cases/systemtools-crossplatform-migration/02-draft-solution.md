# 02 方案草案 — SystemTools 跨平台功能迁移清单

案卷号：`systemtools-crossplatform-migration` · 量级 large · 本阶段不写代码

## 0. 结论速览

SystemTools 的功能可迁移性呈明显三分：

- **A 档（可直接迁移，≈ 20 项）**：纯 ClassIsland SDK / Avalonia / .NET BCL，改工程 TargetFramework 与包引用后即可在新插件中原样保留。
- **B 档（轻改后迁移，≈ 7 项）**：功能逻辑本身跨平台，但含少量 Windows 专属调用，替换为宿主平台抽象或等价实现即可。
- **C 档（不建议迁移，≈ 33 项）**：深度绑定 Win32/WMI/WinRT/Windows 认证/Windows 截图模型，或功能语义在 Linux/macOS 上不成立。

下文先给"Windows 依赖审计"，再给逐功能分类与证据。

---

## 1. Windows 依赖审计（决定分类的事实基础）

| 依赖 | 证据位置 | 受影响功能 | 跨平台结论 |
| --- | --- | --- | --- |
| `System.Windows.Forms`（`UseWindowsForms=true`） | `SystemTools.csproj`；14 个文件 | 屏幕截图、热键、行动流确认、关机监视、内存清理、USB 触发器、模拟键鼠设置控件 | 无 Linux/macOS 等价，需替换 |
| CsWin32 P/Invoke（`Windows.Win32`） | `NativeMethods.txt`（39 项 API）；29 个文件 | 输入模拟、全局热键、窗口枚举/操作、歌词截图、桌面/显示器/电源、壁纸/主题色、剪贴板写、悬浮窗钩子 | 逐项替换为宿主抽象，工作量大 |
| `System.Management`（WMI） | 3 个文件 | 亮度调节、U 盘自动打开、USB 触发器 | 无等价，需换 udev/DBus 等 |
| `System.Speech`（SAPI） | `Services\KeywordSpeechService.cs` | 关键词触发器、AI 听写、语音唤醒 | 仅 Windows，需换 Vosk/宿主语音 |
| `Windows.Media.Control`（SMTC） | `Rules\Handlers\MediaMusicPlayingRuleHandler.cs` | 媒体播放中规则 | WinRT 专属，需换 MPRIS(macOS/Linux) |
| `Windows.Media.Ocr`（WinRT OCR） | `Services\MainWindowTextOcclusionService.cs` | 遮挡文字隐藏主界面 | WinRT 专属 |
| `Windows.Security`（Windows Hello） | `Services\WindowsHelloService.cs` | Windows Hello 验证器 | Windows 专有 |
| `Microsoft.Win32`（注册表） | 8 个文件 | 壁纸、主题色、自启动、内存清理 | Linux/macOS 无注册表，需换机制 |
| `System.Drawing` + GDI（`CopyFromScreen`/`PrintWindow`/`Graphics`） | `MainWindowBackgroundCaptureService.cs`、`LyricsDisplayComponent` | 悬浮窗液态玻璃、自适应背景、歌词截图、OCR 截图 | Windows GDI 模型，需换截图方案 |
| `user32.dll` 全局钩子（`SetWindowsHookEx`/`SetWinEventHook`） | `FloatingWindowService.cs`、`MainWindowClickService.cs` | 悬浮窗拖动/自动隐藏、点击主界面触发器、禁用鼠标 | 无等价，需换平台级监听 |
| `RegisterHotKey`/`GetLastInputInfo` | `HotkeyService.cs`、`LongIdleTrigger.cs` | 热键触发器、长时空闲触发器 | 需换 X11/macOS 全局键与空闲 API |
| DlibDotNet / OpenCvSharp4.runtime.win | `SystemTools.csproj`、`FaceRecognitionService.cs` | 人脸识别验证器 | 原生库仅 win，需换模型/运行时 |
| `SystemTools.VoskWorker.exe`（NAudio.Wasapi，win-x64 自包含） | `VoskWorker\*`、`DependencyPaths.cs` | AI 语音输入、语音唤醒 | 需重编译/重写音频捕获为跨平台 |
| `ffmpeg.exe` 依赖 | `DependencyPaths.cs` | 摄像头抓拍 | ffmpeg 本身跨平台，但摄像头抓拍用 Windows 设备 |
| `System.Diagnostics.Process` | `ProcessRunningRuleHandler.cs`、`KillProcessAction.cs` | 进程规则、退出进程 | ✅ .NET 跨平台（仅 `.exe` 后缀需小改） |

---

## 2. A 档 — 可直接迁移（保留原逻辑）

> 判定标准：仅依赖 ClassIsland SDK（`ClassIsland.Core.Abstractions`）、Avalonia、`System.*` BCL（File/Http/Net），无 Win32/WMI/WinRT/注册表/Windows 专属包。

### 2.1 组件（6/7 可直接）

| 组件 | 证据 | 说明 |
| --- | --- | --- |
| 网络延迟检测 | `NetworkStatusComponent.axaml.cs`：`HttpClient` + `System.Net.NetworkInformation.Ping` | ✅ 纯 BCL，可直接迁移 |
| 显示剪切板内容 | `ClipboardContentComponent.axaml.cs`：`Avalonia.Input.Platform.Clipboard` + `ClipboardExtensions.TryGetTextAsync` | ✅ 用 Avalonia 剪贴板抽象，跨平台 |
| 本地一言 | `LocalQuoteComponent.axaml.cs`：`File` + Avalonia 动画 + `ILessonsService` | ✅ 纯 BCL/Avalonia |
| 下节课是 | `NextClassDisplayComponent.axaml.cs`：`ILessonsService`/`IProfileService`/`IExactTimeService` | ✅ 纯 ClassIsland SDK |
| 更好的轮播容器 | `BetterCarouselContainerComponent.axaml.cs`：`ComponentSettings`/`IRulesetService` + Avalonia | ✅ 纯 SDK/Avalonia |
| LED 文本仿真显示框 | `ScrollingTextComponent.axaml.cs`：Avalonia 动画/画布 | ✅ 纯 Avalonia |

### 2.2 规则集（4/5 可直接）

| 规则 | 证据 | 说明 |
| --- | --- | --- |
| 程序正在运行 | `ProcessRunningRuleHandler.cs`：`Process.GetProcessesByName` | ⚠️ 主体跨平台，`.exe` 后缀判断需小改（见 B 档） |
| 正在使用某课程表 | `UsingClassPlanRuleHandler.cs`：`IProfileService` | ✅ 纯 SDK |
| 正在使用某时间表 | `UsingTimeLayoutRuleHandler.cs`：`IProfileService` | ✅ 纯 SDK |
| 是否在某时间段 | `InTimePeriodRuleHandler.cs`：`IExactTimeService` | ✅ 纯 SDK |
| 正在播放媒体音乐 | `MediaMusicPlayingRuleHandler.cs`：`Windows.Media.Control`（SMTC） | ❌ C 档 |

### 2.3 行动（ClassIsland 域 / 文件操作 / 高级自动化，可直接）

| 行动 | 证据 | 说明 |
| --- | --- | --- |
| 复制 / 移动 / 删除（文件/文件夹） | `CopyAction.cs`/`MoveAction.cs`/`DeleteAction.cs`（`System.IO`） | ✅ 纯 BCL |
| 清除全部提醒 | `ClearAllNotificationsAction.cs`：`INotificationHostService` 反射调用 | ✅ SDK（反射调用宿主内部方法，跨平台成立，属轻改观察点） |
| 加载临时课表 | `LoadTemporaryClassPlanAction.cs` | ✅ SDK |
| 打开应用设置 / 档案编辑 / 换课窗口 | 三个 Open 行动：`IUriNavigationService.NavigateWrapped("classisland://…")` | ✅ SDK |
| 触发指定触发器 | `TriggerCustomTriggerAction.cs`：写 `auto.json` + SDK | ✅ SDK/BCL |
| 开关自动化 | `ToggleWorkflowAction.cs`：`IAutomationService` | ✅ SDK |
| 行动流执行确认 | `ActionFlowExecutionConfirmationAction.cs`：纯 Avalonia（`FATaskDialog` + `owner.Screens`），顶部 `using System.Windows.Forms` 为残留可删除 | ✅ 直接迁移 |
| 沉浸式时钟 | `FullscreenClockAction.cs`：`Process.Start(url, UseShellExecute=true)` | ✅ 直接迁移（建议改用 `ILauncherService.LaunchUrl` 更规范） |

### 2.4 主题（全部可直接）

`Themes\*`（Card-type Component / ClassWidgets 2 Style / Notch Style / Vertical Sidebar）均为 Avalonia XAML 资源（`Theme.axaml.txt` + `Styles.axaml`），无平台依赖 → ✅ 全部直接迁移。

### 2.5 设置页与"关于/调试"UI（主体可直接）

`SettingsPage\*` 与 `AboutSettingsPage`、`PluginDebugSettingsPage` 的框架与大部分控件为 Avalonia。但**内嵌的功能开关与依赖下载（FFmpeg/人脸/VoskWorker 下载）需随功能取舍**（见 C 档依赖下载部分）。

---

## 3. B 档 — 轻改后迁移

| 功能 | Windows 专属点 | 轻改方案 | 证据 |
| --- | --- | --- | --- |
| 程序正在运行（规则） | 仅 `.exe` 后缀剥离 | 非 Windows 不剥离后缀，或同时匹配进程名 | `ProcessRunningRuleHandler.cs` |
| 后台播放音频 | 路径归一化分支 `OperatingSystem.IsWindows()`（`/X:` 转 `X:`） | 删除该 Windows 分支即可；播放走宿主 `IAudioService` | `BackgroundPlayAudioAction.cs`（已含 `IsWindows()` 分支，天然可裁剪） |
| 悬浮窗（经典外观部分） | 悬浮窗本体为 Avalonia `Window`，但液态玻璃/自适应背景/自动隐藏依赖 GDI `CopyFromScreen`+全局钩子 | 保留经典外观（拖拽、层级、主题、规则隐藏、按钮编排），**移除/降级液态玻璃与自适应背景**；自动隐藏改用宿主前台窗口抽象 | `FloatingWindowService.cs`（大量 user32 钩子仅在液态玻璃/自动隐藏路径） |
| AI 文本对话（核心） | 无（`OpenAiCompatibleService` 走 HTTP） | ✅ 可直接；仅需去掉语音入口 | `OpenAiCompatibleService.cs`、`AiChatFloatingWindow` |
| 网络延迟检测·ICMP 模式 | `Ping` 在 Linux 需要 `cap_net_raw`/ICMP socket | ✅ 可用，但文档注明 Linux 权限；HTTP 模式无此问题 | `NetworkStatusComponent` |
| 更多功能选项·主题自动切换 | `AdaptiveThemeSyncService` 有 `IsWindows()` 分支 | 亮度计算依赖截图（`MainWindowBackgroundCaptureService`），需换宿主背景采样；无截图时退化为手动/跟随宿主主题 | `AdaptiveThemeSyncService.cs` |
| 主界面文字遮挡隐藏 | WinRT `Windows.Media.Ocr` + GDI 截图 | 截图换宿主方案、OCR 换 tesseract/系统 OCR | `MainWindowTextOcclusionService.cs` |

> B 档总体特征：**代码骨架和交互可用，只需把 1–2 处"平台查询/原生调用"换成宿主抽象或删去 Windows 分支**。

---

## 4. C 档 — 不建议迁移（或迁移成本高/语义不成立）

### 4.1 输入模拟（Win32 `keybd_event`/`mouse_event`/`SendInput`）

- 常用模拟键：Alt+F4 / Alt+Tab / Ctrl+Z / Enter / Esc / F11
- 键入内容 / 模拟鼠标 / 模拟组合键 / 模拟键盘 / 窗口操作
- 实验性：禁用/启用鼠标
- **理由**：Win32 输入注入在 Linux(X11 可用 XTest 但受限) 与 macOS（需辅助功能权限）语义不同，跨平台实现与权限模型完全不同，不建议首批迁移。

### 4.2 显示/桌面/电源（`SetDisplayConfig`/`SystemParametersInfo`/`ExitWindowsEx`/WMI）

- 复制/扩展/仅电脑/仅第二屏幕、黑屏 html、显示桌面、调整屏幕亮度
- 计时关机 / 高级计时关机 / 取消关机 / 锁定屏幕 / 立即重启 / 立即关机 / 睡眠
- **理由**：显示器拓扑与电源管理在 Linux(DE 差异大)/macOS(pmset) 无统一 API，且"重启为管理员"等语义不成立。

### 4.3 系统个性化（注册表 + Win32）

- 切换壁纸、切换主题色、切换系统强调色
- **理由**：注册表机制不存在，需换 GNOME/KDE/macOS 各自机制，且桌面环境差异大。

### 4.4 硬件与设备（WMI/Win32 设备通知）

- 禁用/启用硬件设备、U 盘插入自动打开、USB 设备插入触发器
- **理由**：Linux 需 udev，macOS 需 IOKit，触发语义不同。

### 4.5 窗口/屏幕/全局输入挂钩

- 点击主界面触发器（低层鼠标钩子）、全局热键触发器（`RegisterHotKey`）、长时空闲触发器（`GetLastInputInfo`）、音乐软件歌词显示（`FindWindow`+`PrintWindow`）、拉起自定义 Windows 通知（`ShowToastAction` 若走 Windows toast）
- **理由**：全局钩子/窗口枚举/桌面通知在 X11/macOS 无对等实现或需完全不同机制。

### 4.6 语音与 AI 语音（双引擎均为 Windows 专属）

- 关键词触发器（SAPI）、AI 语音输入（VoskWorker + NAudio.Wasapi）、语音唤醒（SAPI/Vosk）、AI 唤醒相关行动
- **理由**：`KeywordSpeechService`=System.Speech(SAPI)；`VoskSpeechService` 依赖 win-x64 自包含 `SystemTools.VoskWorker.exe`（NAudio.Wasapi）。迁移需：VoskWorker 改跨平台音频捕获（如 NAudio→PortAudio/ALSA/CoreAudio）+ 重编译 Linux/macOS 原生库 + 模型下载改造。属于**独立子项目级工作量**，不建议与功能提取混在一起。

### 4.7 认证（人脸 / Windows Hello）

- 人脸识别验证器（DlibDotNet + OpenCvSharp win 原生）、Windows Hello 验证器（`Windows.Security`）
- **理由**：Windows 专有认证，需换宿主认证体系。

### 4.8 依赖下载与管理

- 主设置中的 FFmpeg/人脸模型/VoskWorker 下载管理：ffmpeg 本身跨平台，但当前下载的是 `ffmpeg.exe` 与 win 原生库 → 需整体改造为 per-OS 依赖清单，属工程级工作。

---

## 5. 关键证据速查（文件 → 结论）

| 文件 | 关键依赖 | 结论 |
| --- | --- | --- |
| `NetworkStatusComponent.axaml.cs` | HttpClient/Ping | A |
| `ClipboardContentComponent.axaml.cs` | Avalonia Clipboard | A |
| `LocalQuoteComponent.axaml.cs` | File + Avalonia | A |
| `NextClassDisplayComponent.axaml.cs` | ILessonsService 等 | A |
| `BetterCarouselContainerComponent.axaml.cs` | ComponentSettings/IRulesetService | A |
| `ScrollingTextComponent.axaml.cs` | Avalonia 动画 | A |
| `LyricsDisplayComponent.axaml.cs` | `PInvoke.FindWindow`/`PrintWindow`/`System.Drawing` | C |
| `UsingClassPlan/UsingTimeLayout/InTimePeriod` handlers | IProfileService/IExactTimeService | A |
| `ProcessRunningRuleHandler.cs` | Process（`.exe` 后缀） | B |
| `MediaMusicPlayingRuleHandler.cs` | `Windows.Media.Control` | C |
| `ActionInProgressTrigger` | 自动化 SDK + auto.json（File/Timer） | A |
| `UsbDeviceTrigger.cs` | WMI + `RegisterDeviceNotification` | C |
| `HotkeyTrigger.cs`/`HotkeyService.cs` | `RegisterHotKey` + WinForms | C |
| `LongIdleTrigger.cs` | `GetLastInputInfo` | C |
| `KeywordTrigger.cs`/`KeywordSpeechService.cs` | System.Speech | C |
| `MainWindowClickTrigger.cs`/`MainWindowClickService.cs` | `SetWindowsHookEx` | C |
| `FloatingWindowTrigger.cs`/`FloatingWindowService.cs` | Avalonia 本体 + user32 钩子 + GDI 截图 | B（仅经典外观） |
| `Copy/Move/Delete` | System.IO | A |
| `ClearAllNotifications/LoadTemporaryClassPlan/Open*` | ClassIsland SDK | A |
| `TriggerCustomTrigger/ToggleWorkflow` | SDK/BCL | A |
| `ActionFlowExecutionConfirmation` | 纯 Avalonia（FATaskDialog） | A |
| `FullscreenClock` | Process.Start(URL) | A（建议改用 ILauncherService） |
| `BackgroundPlayAudio` | IAudioService（含 IsWindows 分支） | B |
| 模拟键鼠/窗口操作/显示/电源/壁纸/主题色/亮度/硬件/截图/音量/桌面/摄像头/禁用鼠标 | Win32/WMI/WinRT/注册表 | C |
| `OpenAiCompatibleService` 等 AI 文本 | HTTP + SDK | A（语音除外） |
| `VoskSpeechService`/`VoskWorker` | NAudio.Wasapi + win-x64 自包含 | C（需独立改造） |
| `FaceRecognitionService`/`WindowsHelloService` | Dlib/OpenCv/Windows.Security | C |
| `Themes\*` | Avalonia XAML | A |

---

## 6. 工程级改造要点（决策级，非实施步骤）

1. **TargetFramework**：`net10.0-windows10.0.19041.0` → `net10.0`（跨平台），移除 `UseWindowsForms`、`Platforms=x64` 限定。
2. **包引用裁剪**：移除/条件化 `CsWin32`、`System.Management`、`System.Speech`、`DlibDotNet`、`OpenCvSharp4*`、`OpenCvSharp4.runtime.win`。
3. **VoskWorker**：独立跨平台化（音频捕获后端替换 + per-OS 原生依赖 + 发布矩阵），不在首期功能提取范围。
4. **宿主抽象采用**：优先使用 `ClassIsland.Platforms.Abstractions` 的 `IWindowPlatformService`（前台窗口/窗口特性）、`IDesktopToastService`（通知）、`ILauncherService`、`IPlatformFilePickerService`；全局热键/空闲检测/输入注入/桌面背景等宿主未提供的，需自建平台服务（或明确不支持）。
5. **目录结构**：新插件独立工程 `SystemTools-Cross-platform`，从 SystemTools 抽取 A/B 档文件，C 档留在原插件；共享的配置模型/工具类可复用。

---

## 7. 风险与回滚（决策级）

- **R1** 直接 P/Invoke 面广 → 抽取 A/B 档时必须逐文件剔除 `using Windows.Win32`，否则编译即失败（可作为迁移的强制门禁）。
- **R2** Linux 仅 X11 → 依赖 X11 的全局键/窗口枚举需评估是否首期支持，否则降级为"仅应用内触发"。
- **R3** 悬浮窗液态玻璃 → 首期建议经典外观，液态玻璃作为后续可选增强。
- **回滚**：本阶段纯分析，无代码变更；进入实现后，新插件独立于原插件，可整体卸载/不启用，不影响 SystemTools。

---

## 8. 待门下省评审点

1. 三档分类边界（尤其 B 档 7 项的取舍）是否接受。
2. U1（是否三平台合一）与 U2（B 档首批范围）的收敛。
3. 语音/AI 语音是否单独立项（而非并入功能提取）。
4. 宿主平台抽象缺口（全局热键/空闲/输入注入/壁纸/OCR）的承担方与优先级。
