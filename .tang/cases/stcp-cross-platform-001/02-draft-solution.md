# 02 方案草案（修订版 v2）— SystemTools 跨平台功能迁移清单

案卷号：`stcp-cross-platform-001` · 量级 large · 本阶段不写代码

> 本版依据门下省 `03-review.md` 与 `04-spec.md` 修订（会签结论：接受 R-1…R-10 与 U3/U4/U5 建议），并落实一处事实勘误（行动文件数 63→62）。与 `04-spec.md` 不一致处以 spec 为准。

## 0. 结论速览

| 档 | 含义 | 数量（功能项，去重口径） |
| --- | --- | --- |
| **A 直接迁移** | 纯 ClassIsland SDK / Avalonia / FluentAvalonia / .NET BCL，改工程 TFM 与包引用后原样保留 | **33**（主题 3 + 组件 6 + 规则 4 + 触发器 1 + 行动 15 + 服务/设置 4） |
| **B 稍加修改** | 逻辑跨平台，1–2 处 Windows 调用替换为宿主抽象或等价 OS 命令 | **19**（触发器 1 + 行动 14 + 服务 4） |
| **C 不迁移** | 深度绑定 Win32/WMI/WinRT/Windows 认证/截图输入模型，或语义不成立 | **46**（组件 1 + 规则 1 + 触发器 5 + 行动 32 + 服务 7） |

- **合计 98 功能项**；其中行动 62 个 `.cs` 文件 → **61 功能项**（`ClickSimulationAction.cs` 整文件被注释、为死代码未注册，不计入）。
- A+B 为跨平台版纳入范围；C 留在原 SystemTools（「语音链路跨平台化 / 屏幕截图 / 系统音量」标立项候选）。

---

## 1. Windows 依赖审计（分类的事实基础）

| 依赖 | 证据位置 | 受影响功能 | 跨平台结论 |
| --- | --- | --- | --- |
| TFM `net10.0-windows10.0.19041.0` + `UseWindowsForms=true` | `SystemTools.csproj` | 全插件 | 改为 `net10.0`（或宿主 CrossPlatformProps 模式），移除 WinForms |
| `System.Windows.Forms` | **10 个文件**（`HotkeyService`/`IHotkeyService`/`SystemShutdownMonitor`/`ScreenShotAction`/`ShutdownAction`/`UsbDeviceTrigger`/`MainWindowBackgroundCaptureService`/`ClickSimulationSettingsControl`/`SimulateKeyboardSettingsControl`/`SimulateKeyCombinationSettingsControl`） | 见 C/B 档 | 无 Linux/macOS 等价，逐项替换 |
| CsWin32 P/Invoke（`Windows.Win32`，`NativeMethods.txt` 39 项） | **23 个文件** `using Windows.Win32`/`PInvoke.` + **13 个文件**活跃 `[DllImport]`（并集 33） | 输入模拟、全局热键、窗口枚举/操作、歌词截图、桌面/显示器/电源、壁纸/主题色、剪贴板写、悬浮窗层 | 逐项替换为宿主抽象，工作量大 |
| `System.Management`（WMI） | 3 个文件（亮度、U 盘自动播放、USB 触发器） | 亮度、USB | 无等价，需 udev/DBus/IOKit |
| `System.Speech`（SAPI） | `Services\KeywordSpeechService.cs` | 关键词触发器、AI 听写、语音唤醒 | 仅 Windows，需换 Vosk/宿主语音 |
| `Windows.Media.Control`（SMTC，WinRT） | `Rules\Handlers\MediaMusicPlayingRuleHandler.cs` | 媒体播放中规则 | 需换 MPRIS（Linux）/Now Playing（macOS） |
| `Windows.Media.Ocr`（WinRT OCR） | `Services\MainWindowTextOcclusionService.cs` | 遮挡文字隐藏 | WinRT 专属，需换 OCR |
| `Windows.Security`（Windows Hello） | `Services\WindowsHelloService.cs` | Windows Hello 验证器 | Windows 专有 |
| `Microsoft.Win32`（注册表） | 8 个文件（壁纸、主题色、自启动、内存清理） | 壁纸/主题色/强调色/自启动 | Linux/macOS 无注册表 |
| GDI（`CopyFromScreen`/`PrintWindow`/`Graphics`） | `MainWindowBackgroundCaptureService.cs`、`LyricsDisplayComponent`、`ScreenShotAction` | 液态玻璃背景、歌词截图、自适应背景、OCR 截图、屏幕截图 | Windows GDI 模型，需换截图方案 |
| `SetWindowsHookEx`/`SetWinEventHook`（user32） | `FloatingWindowService.cs`、`MainWindowClickService.cs` | 悬浮窗自动隐藏/前台重排、点击主界面触发器、禁用鼠标 | 无等价，需平台级监听 |
| `RegisterHotKey`/`GetLastInputInfo` | `HotkeyService.cs`、`LongIdleTrigger.cs` | 热键触发器、长时空闲触发器 | 需 X11/macOS 全局键与空闲 API |
| Windows Core Audio（`IMMDevice`/`IAudioEndpointVolume` COM） | `Actions\SetVolume.cs` | 设置系统音量 | 需 CoreAudio/PipeWire/PulseAudio |
| `ExitWindowsEx`/`RtlAdjustPrivilege`/`rundll32`/`shutdown` | `ImmediateRestartAction.cs`、`SleepAction.cs`、`LockScreenAction.cs`、`ShutdownAction.cs` | 电源七项 | 换 OS 命令/DBus(logind)/pmset |
| `robocopy.exe`/`cmd.exe`（文件夹复制/移动/删除） | `CopyAction.cs`、`MoveAction.cs`、`DeleteAction.cs` | 文件操作（文件夹子路径） | 换 .NET 递归实现或 per-OS 命令 |
| `NtSetSystemInformation`/`EmptyWorkingSet`（ntdll/kernel32） | `SystemMemoryCleanupService.cs`、`ClassIslandMemoryAutoCleanupService.cs` | 内存清理 | 前者 C，后者仅 GC 部分可迁移（B） |
| DlibDotNet / OpenCvSharp4.runtime.win | `SystemTools.csproj`、`FaceRecognitionService.cs` | 人脸识别验证器 | 原生库仅 win |
| `SystemTools.VoskWorker.exe`（NAudio.Wasapi，win-x64 自包含） | `VoskWorker\*`、`DependencyPaths.cs` | AI 语音输入、语音唤醒 | 需重编译音频捕获为跨平台 |
| `ffmpeg.exe` 依赖 | `DependencyPaths.cs` | 摄像头抓拍 | ffmpeg 跨平台，但摄像头设备访问需 per-OS |
| `System.Diagnostics.Process` | `KillProcessAction.cs`、`ProcessRunningRuleHandler.cs` | 退出进程、进程规则 | ✅ .NET 跨平台 |
| `ClassIsland.Platforms.Abstractions`（宿主） | `ShowToastAction.cs`、`VersionCheckService.cs` | 通知、打开 URL | ✅ 已跨平台，直接复用 |

---

## 2. A 档 — 可直接迁移（33 项）

> 判定标准：全部源码路径仅依赖 ClassIsland SDK（`ClassIsland.Core.Abstractions`）、Avalonia/FluentAvalonia、`System.*` BCL（File/Http/Net/Process），不含 §1 表中任何 Windows 专属符号。

### 2.1 主题（3/3）

`Themes\CardTypeComponent`、`Themes\ClassWidgets`、`Themes\NotchStyle` 均为 Avalonia XAML 资源（`Styles.axaml` + `Theme.axaml.txt` + 样式类），无平台依赖 → ✅ 全部直接迁移。

### 2.2 组件（6/7）

| 组件 | 证据 | 结论 |
| --- | --- | --- |
| 网络延迟检测 | `NetworkStatusComponent.axaml.cs`：`HttpClient` + `System.Net.NetworkInformation.Ping` | ✅ A（附注：Ping/ICMP 模式在 Linux 需 `cap_net_raw`，HTTP 模式无此问题，文档注明即可） |
| 显示剪切板内容 | `ClipboardContentComponent.axaml.cs`：Avalonia `TopLevel.Clipboard` + `ClipboardExtensions.TryGetTextAsync` | ✅ A |
| 本地一言 | `LocalQuoteComponent.axaml.cs`：`File` + Avalonia 动画 | ✅ A |
| 下节课是 | `NextClassDisplayComponent.axaml.cs`：`ILessonsService`/`IProfileService`/`IExactTimeService` | ✅ A |
| 更好的轮播容器 | `BetterCarouselContainerComponent.axaml.cs`：组件设置 + `IRulesetService` + Avalonia | ✅ A |
| LED 文本仿真显示框 | `ScrollingTextComponent.axaml.cs`：Avalonia 画布/动画 | ✅ A |

（音乐软件歌词显示 → C，见 §4。）

### 2.3 规则集（4/5）

| 规则 | 证据 | 结论 |
| --- | --- | --- |
| 程序正在运行 | `ProcessRunningRuleHandler.cs`：`Process.GetProcessesByName` | ✅ A |
| 正在使用某课程表 | `UsingClassPlanRuleHandler.cs`：`IProfileService` | ✅ A |
| 正在使用某时间表 | `UsingTimeLayoutRuleHandler.cs`：`IProfileService` | ✅ A |
| 是否在某时间段 | `InTimePeriodRuleHandler.cs`：`IExactTimeService` | ✅ A |

（正在播放媒体音乐 → C。）

### 2.4 触发器（1/7）

- **行动进行时** `ActionInProgressTrigger`：自动化 SDK + `auto.json`（File/Timer）→ ✅ A。

### 2.5 行动（A 档，15 项）

| 行动 | 证据 | 说明 |
| --- | --- | --- |
| 退出进程 | `KillProcessAction.cs`：`Process.GetProcessesByName`+`Kill()`（`.exe` 后缀剥离为非 Windows 上的无害 no-op） | ✅ 纯 BCL |
| 拉起自定义通知 | `ShowToastAction.cs:31`：`PlatformServices.DesktopToastService.ShowToastAsync`（宿主跨平台抽象） | ✅ 已跨平台（旧草案误判为 C，已校正） |
| 切换悬浮窗配置方案 | `ToggleFloatingWindowProfileAction`：悬浮窗配置管理器（纯配置） | ✅ 纯配置 |
| 切换悬浮窗主题 | `SwitchFloatingWindowThemeAction`：主题切换（纯配置） | ✅ 纯配置 |
| 后台播放音频 | `BackgroundPlayAudioAction.cs`：宿主 `IAudioService.PlayAudioAsync`（仅含 `OperatingSystem.IsWindows()` 路径归一化分支，可删） | ✅ A（删 Windows 分支即可） |
| 行动流执行确认 | `ActionFlowExecutionConfirmationAction.cs:8`：`FluentAvalonia.UI.Controls.FATaskDialog` + Avalonia `owner.Screens`/`Topmost` | ✅ A（无任何 WinForms 引用） |
| 触发指定触发器 | `TriggerCustomTriggerAction.cs`：写 `auto.json` + SDK | ✅ A |
| 开关自动化 | `ToggleWorkflowAction.cs`：`IAutomationService` | ✅ A |
| 显示 AI 对话框（AI 文本对话核心） | `ShowAiChatDialogAction` + `OpenAiCompatibleService`（HTTP）+ `AiChatFloatingWindow`（Avalonia） | ✅ A（自适应背景子特性随 U5 降级，见 §3 附注） |
| 沉浸式时钟 | `FullscreenClockAction.cs`：`Process.Start(url, UseShellExecute=true)` | ✅ A（建议改用 `ILauncherService.LaunchUrl` 更规范） |
| 清除全部提醒 | `ClearAllNotificationsAction.cs`：`INotificationHostService` 反射调用 | ✅ A（跨平台成立；反射调用属观察点） |
| 加载临时课表 | `LoadTemporaryClassPlanAction.cs`：`IProfileService` | ✅ A |
| 打开应用设置 | `OpenAppSettingsAction`：`IUriNavigationService.NavigateWrapped("classisland://…")` | ✅ A |
| 打开档案编辑 | `OpenProfileEditorAction`：同上 | ✅ A |
| 打开换课窗口 | `OpenClassSwapWindowAction`：同上 | ✅ A |

### 2.6 AI 服务与设置页（A 档）

- **AI 文本对话链**（`OpenAiCompatibleService`/`AiChatWindowService`/`AiConversationStore`/`AiPromptService`/`AiAttachmentService`/`AiAttachmentDropService`/`ClassIslandActionAiService`/`ClassIslandProfileAiService`/`AiChatOperationGate`）：HTTP + ClassIsland SDK + Avalonia → ✅ A。
- **虚拟放学** `VirtualAfterSchoolService.cs`：`ILessonsService`/`IExactTimeService` + `DispatcherTimer` + 反射写状态 → ✅ A。
- **版本检查** `VersionCheckService.cs`：HTTP + `PlatformServices.DesktopToastService` → ✅ A。
- **设置页框架（6 页）**：`SystemToolsSettingsPage` / `MoreFeaturesOptionsSettingsPage` / `AiChatSettingsPage` / `FloatingWindowEditorSettingsPage` / `AboutSettingsPage` / `PluginDebugSettingsPage` 的页面骨架与控件为 Avalonia/FluentAvalonia；`MoreFeaturesOptionsSettingsPage` 内嵌选项按归属分档（自动切换主题/遮挡隐藏/内存自动清理 = B，U 盘自动打开 = C），「FFmpeg/人脸/VoskWorker 依赖下载管理」随对应 C 档功能裁剪。

---

## 3. B 档 — 稍加修改即可跨平台（19 项，含三元组）

> B 档三元组：Windows 专属点（文件:行）→ 替换目标 → 降级行为。

| 功能 | Windows 专属点 | 替换目标 | 降级行为 |
| --- | --- | --- | --- |
| 复制（文件/文件夹） | 文件夹分支 `CopyAction.cs:96-97` `robocopy.exe`（文件分支 `:65` 为 BCL `File.Copy`） | 跨平台 .NET 递归复制或 per-OS 命令 | 失败时记录日志并抛行动错误（与现行为一致） |
| 移动（文件/文件夹） | 文件夹分支 `MoveAction.cs:96-98` `robocopy.exe /move`（文件分支 `:65` BCL `File.Move`） | 跨平台 .NET 递归移动或 per-OS 命令 | 同上 |
| 删除（文件/文件夹） | 文件夹分支 `DeleteAction.cs:29,69` `cmd /c rmdir /s /q`（文件分支 `:51` BCL `File.Delete`） | 跨平台 `Directory.Delete(recursive)` 或 per-OS 命令 | 同上 |
| 计时关机 | `ShutdownAction.cs:32,43` `shutdown -s -t` + `SendKeys.SendWait` | Linux `systemd-run`/`shutdown`；macOS `pmset schedule shutdown` | U4：预检命令/权限，无权限时 `IDesktopToastService` 通知降级，不抛未处理异常 |
| 高级计时关机 | `AdvancedShutdownAction.cs:207,395` 倒计时 UI（Avalonia）+ `shutdown` 进程 | UI 保留；关机/取消换 OS 命令 | 同上（U4） |
| 取消关机计划 | `CancelShutdownAction.cs:29` `shutdown /a` | Linux `shutdown -c`；macOS `pmset schedule cancelall` | 同上（U4） |
| 锁定屏幕 | `LockScreenAction.cs:29-30` `rundll32 user32.dll,LockWorkStation` | Linux `loginctl lock-session`/`xdg-screensaver lock`；macOS `pmset displaysleepnow` 或 `osascript` 锁屏 | 同上（U4） |
| 立即重启 | `ImmediateRestartAction.cs:16-28` `RtlAdjustPrivilege`+`ExitWindowsEx(EWX_REBOOT)` | Linux `systemctl reboot`/`shutdown -r now`；macOS `osascript` restart | 同上（U4） |
| 立即关机 | `ImmediateShutdownAction.cs:16-28` `ExitWindowsEx(EWX_SHUTDOWN)` | Linux `systemctl poweroff`/`shutdown -h now`；macOS `osascript` shut down | 同上（U4） |
| 睡眠 | `SleepAction.cs:23-24` `rundll32 powrprof.dll,SetSuspendState` | Linux `systemctl suspend`；macOS `pmset sleepnow` | 同上（U4） |
| 显示悬浮窗 | 依赖悬浮窗本体（见下行） | 经典外观保留；层控制换宿主抽象 | 见悬浮窗子特性分解 |
| 切换悬浮窗层级 | `FloatingWindowService.cs:2332,2337` `SetWindowPos(HWND_BOTTOM/HWND_TOPmost)` | `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)` | 宿主特性不可用时保持默认层级 |
| 从悬浮窗触发 | 依赖悬浮窗本体 | 经典外观可迁移 | 同上 |
| 自动切换 ClassIsland 主题 | `AdaptiveThemeSyncService` 亮度采样依赖 GDI `CopyFromScreen` | 背景采样换宿主方案；无采样退化为「跟随宿主明暗主题/手动」 | U5：采样路径降级为 C 候选 |
| 遮挡文字时隐藏主界面 | `MainWindowTextOcclusionService.cs` WinRT `Windows.Media.Ocr` + GDI 截图 | 截图换宿主方案、OCR 换 tesseract/系统 OCR | 降级为手动开关 |
| ClassIsland 内存自动清理 | `ClassIslandMemoryAutoCleanupService.cs:118` `EmptyWorkingSet`（kernel32）；`:113-115` `GC.Collect` 为跨平台 | 保留 `GC.Collect`；`EmptyWorkingSet` 仅 Windows 执行 | 非 Windows 跳过 `EmptyWorkingSet`，仅 GC |

**B 档服务（4 项，随上表功能）**：`FloatingWindowService`（经典外观）、`AdaptiveThemeSyncService`、`MainWindowTextOcclusionService`、`ClassIslandMemoryAutoCleanupService`。

**B 档附带改造点（不另计功能项）**：
- **SystemShutdownMonitor**（`SystemShutdownMonitor.cs:8-77` WinForms `NativeWindow`，WM_QUERYENDSESSION/WM_ENDSESSION，`Plugin.cs:56,125,1034`）：换宿主 `ISystemEventsService`（若提供会话结束事件）或非 Windows no-op，并入关机族改造。
- **悬浮窗子特性分解（R-3）**：Avalonia 窗口 + 拖拽 + 按钮编排 + 多方案 + 规则隐藏 = B（保留）；置顶/置底 = B（换 `IWindowPlatformService`）；**低级鼠标钩子自动隐藏（`FloatingWindowService.cs:1952`）与 WinEvent 前台/重排响应（`:2213/:2230`）→ 降级为 Avalonia 内部指针/激活事件近似或本期不支持**；液态玻璃/自适应背景 = C 候选（U5）。
- **AI 对话浮窗自适应背景（R-6）**：`AiChatFloatingWindow.axaml.cs:410-416` 调用 `BackgroundLuminanceCalculator` + 捕获帧（GDI `MainWindowBackgroundCaptureService.cs:141,250`）→ 随 U5 一并降级；「显示 AI 对话框」A 档主结论不变。

---

## 4. C 档 — 不迁移（或需独立立项，46 项）

### 4.1 输入模拟（Win32 `keybd_event`/`mouse_event`/`SendInput`/剪贴板写入）

- 常用模拟键：Alt+F4 / Alt+Tab / Ctrl+Z / Enter / Esc / F11
- 模拟键盘 / 模拟组合键 / 模拟鼠标 / 键入内容 / 窗口操作
- 实验性：禁用鼠标 / 启用鼠标（`SetWindowsHookEx` 全局钩子）
- **理由**：Win32 输入注入在 Linux（X11 可用 XTest 但受限）与 macOS（需辅助功能权限）语义与权限模型完全不同，非「稍加修改」。

### 4.2 显示 / 桌面（`SetDisplayConfig`/`SystemParametersInfo`/`keybd_event`/WMI）

- 复制屏幕 / 扩展屏幕 / 仅电脑屏幕 / 仅第二屏幕（显示器拓扑）
- 黑屏 html（`cmd /c start` + `keybd_event F11`）
- 显示桌面（`keybd_event Win+D`）
- 调整屏幕亮度（WMI `\\.\root\wmi`；Linux `/sys/class/backlight`、macOS 私有 API，碎片化）

### 4.3 系统个性化（注册表 + Win32）

- 切换壁纸（注册表 + `SystemParametersInfo`）
- 切换主题色（注册表 `AppsUseLightTheme`）
- 切换系统强调色（注册表 DWM `AccentColor`）

### 4.4 硬件与设备（WMI / Win32 设备通知）

- 禁用硬件设备 / 启用硬件设备（WMI）
- U 盘插入自动打开（`UsbAutoPlayService` WMI + `RegisterDeviceNotification`）
- USB 设备插入触发器（`UsbDeviceTrigger.cs:224-263` WMI + `RegisterDeviceNotification`）
- **理由**：Linux 需 udev，macOS 需 IOKit，触发语义不同。

### 4.5 窗口 / 屏幕 / 全局输入挂钩

- 点击主界面触发器（`SetWindowsHookEx` 低层鼠标钩子）
- 全局热键触发器（`RegisterHotKey`）
- 长时间未操作触发器（`GetLastInputInfo`）
- 音乐软件歌词显示（`LyricsDisplayComponent.axaml.cs:130-243` `FindWindow`/`PrintWindow`/`EnumWindows`/`SetWindowPos(HWND_BOTTOM)` + SMTC 音乐源集成）
- **理由**：全局钩子/窗口枚举/前台窗口查询在 X11/macOS 无对等实现，且各 DE 差异大。

### 4.6 语音与 AI 语音（双引擎均为 Windows 专属）【立项候选】

- 关键词触发器（`KeywordSpeechService` = System.Speech SAPI）
- AI 语音输入（`VoskSpeechService` 依赖 win-x64 自包含 `SystemTools.VoskWorker.exe`，NAudio.Wasapi）
- 语音唤醒 / 启用语音唤醒 / 唤醒语音对话（`EnableVoiceWakeAiAction`/`WakeUpVoiceConversationAiAction`）
- **理由**：迁移需 VoskWorker 改跨平台音频捕获（NAudio→PortAudio/ALSA/CoreAudio）+ 重编译 Linux/macOS 原生库 + per-OS 模型下载。属**独立子项目级工作量**，候选后续单独立项。

### 4.7 认证（人脸 / Windows Hello）

- 人脸识别验证器（`FaceRecognitionService`：DlibDotNet + OpenCvSharp win 原生 + `FaceRecognitionAuthorizer`）
- Windows Hello 验证器（`WindowsHelloService.cs:158` winbio DllImport + `WindowsHelloAuthorizer`）
- **理由**：Windows 专有认证，需换宿主认证体系；服务与验证器为同一功能，只计 1 次（去重）。

### 4.8 屏幕截图与系统音量【立项候选】

- 屏幕截图（`ScreenShotAction.cs:53` WinForms `CopyFromScreen`；全屏截图需 per-OS 后端）
- 设置系统音量（`SetVolume.cs` Windows Core Audio COM；Linux 需 PipeWire/PulseAudio/ALSA 分叉，macOS 需 CoreAudio 脚本）

### 4.9 内存清理（系统级）

- 系统内存清理（`SystemMemoryCleanupService.cs:600-641` `NtSetSystemInformation` ntdll 调用 + 管理员权限；Linux/macOS 无对等语义）

### 4.10 摄像头抓拍与依赖下载

- 摄像头抓拍（`CameraCaptureAction`：FFmpeg + OpenCvSharp4.runtime.win；FFmpeg 本身跨平台，但 win 运行时 + 摄像头设备访问需 per-OS）
- 主设置中的 FFmpeg/人脸模型/VoskWorker 下载管理：当前下载 `ffmpeg.exe` 与 win 原生库 → 需整体改造为 per-OS 依赖清单（随 C 档功能裁剪）

### 4.11 管理员重启

- 重启应用为管理员身份（`RestartAsAdminAction`：Windows UAC 提权语义在 Linux/macOS 上不成立）

---

## 5. 逐功能总表（功能 → 档位）

| 域 | 功能 | 档 |
| --- | --- | --- |
| 主题 | Card-type Component / ClassWidgets 2 Style / Notch Style | A |
| 组件 | 网络延迟检测 / 剪切板显示 / 本地一言 / 下节课是 / 更好轮播容器 / LED 文本 | A |
| 组件 | 音乐软件歌词显示 | C |
| 规则 | 程序运行 / 某课程表 / 某时间表 / 某时间段 | A |
| 规则 | 正在播放媒体音乐 | C |
| 触发器 | 行动进行时 | A |
| 触发器 | 从悬浮窗触发 | B |
| 触发器 | USB 插入 / 热键 / 长时空闲 / 关键词 / 点击主界面 | C |
| 行动·文件 | 复制 / 移动 / 删除（文件与文件夹） | B |
| 行动·实用 | 退出进程 / 拉起自定义通知 | A |
| 行动·实用 | 屏幕截图 / 禁用设备 / 启用设备 | C |
| 行动·悬浮窗 | 切换配置方案 / 切换主题 | A |
| 行动·悬浮窗 | 显示悬浮窗 / 切换层级 | B |
| 行动·媒体 | 后台播放音频 | A |
| 行动·媒体 | 设置系统音量 / 摄像头抓拍 | C |
| 行动·高级自动化 | 行动流确认 / 触发指定触发器 / 开关自动化 | A |
| 行动·AI | 显示 AI 对话框（文本对话） | A |
| 行动·AI | 启用语音唤醒 / 唤醒语音对话 | C |
| 行动·其他 | 沉浸式时钟 | A |
| 行动·ClassIsland | 清除提醒 / 加载临时课表 / 打开设置 / 打开档案编辑 / 打开换课窗口 | A |
| 行动·ClassIsland | 重启为管理员 | C |
| 行动·模拟操作 | 常用模拟键 ×6 / 模拟键盘 / 组合键 / 鼠标 / 键入内容 / 窗口操作 | C |
| 行动·显示 | 复制/扩展/仅内/仅外屏 / 黑屏html / 显示桌面 / 亮度 | C |
| 行动·电源 | 计时/高级计时/取消关机 / 锁屏 / 立即重启 / 立即关机 / 睡眠 | B |
| 行动·个性化 | 切换壁纸 / 切换主题色 / 切换系统强调色 | C |
| 行动·更多选项 | 自动切换主题 / 遮挡隐藏 | B |
| 行动·更多选项 | U 盘自动打开 | C |
| 行动·实验 | 禁用鼠标 / 启用鼠标 | C |
| 服务 | 虚拟放学 / 版本检查 / AI 文本链 | A |
| 服务 | 悬浮窗经典外观 / 自适应主题 / 遮挡 OCR / ClassIsland 内存 GC | B |
| 服务·认证 | 系统内存清理 / U 盘自动播放 / 语音(SAPI+Vosk) / 人脸识别(服务+验证器) / Windows Hello(服务+验证器) / 背景截图采样 | C |

> 计数映射：行动 62 个 `.cs` 文件 → 61 功能项（`ClickSimulationAction.cs` 整文件注释、死代码不注册）；61 = A15 + B14 + C32；总功能项 98 = A33 + B19 + C46。

---

## 6. 工程级改造要点（决策级，非实施步骤）

1. **TargetFramework**：`net10.0-windows10.0.19041.0` → 宿主 `CrossPlatformProps.props` 三平台模式（基础 `net10.0`，按平台切 TFM），移除 `UseWindowsForms`、`Platforms=x64` 限定。
2. **包引用裁剪**：移除 `CsWin32`、`System.Management`、`System.Speech`、`DlibDotNet`、`OpenCvSharp4*`、`OpenCvSharp4.runtime.win`；**保留 `ClassIsland.PluginSdk`（`net10.0` 跨平台版，随 misha/v2 检出）+ `Microsoft.Extensions.DependencyInjection` + `FluentAvalonia`**（`FATaskDialog`、6 个设置页与组件设置控件直接依赖，跨平台，通常经宿主 `ClassIsland.Core` 传递提供）。
3. **宿主抽象采用**：优先复用 `ClassIsland.Platforms.Abstractions` 的 `IWindowPlatformService`（窗口特性/前台窗口/鼠标位置）、`IDesktopToastService`（通知）、`ILauncherService`（打开 URL/路径）、`IPlatformFilePickerService`、`ISystemEventsService`（会话结束）。宿主未提供的缺口（全局热键/空闲检测/输入注入/壁纸/截图/OCR/音量）本期**不支持或自建平台服务**，对应功能留在 C 档。
4. **VoskWorker**：本期不跨平台化；跨平台版不含语音输入/唤醒。
5. **独立命名与 manifest**：新插件 `id` 独立命名（如 `SystemTools.CrossPlatform`）、功能 ID 采用独立前缀（如 `SystemTools.X.*`）、`supportedOSPlatforms` 置为三平台、`apiVersion` 随 U3 决议；配置类/目录全新，不与原 SystemTools 冲突。
6. **目录结构**：新插件独立工程 `SystemTools-Cross-platform`，从 SystemTools 抽取 A/B 档文件，C 档留在原插件；共享的纯 .NET 工具类/配置模型可复用。
7. **迁移门禁**：抽取 A/B 档时逐文件对照 §1 Windows 依赖符号清单（`using Windows.Win32`/`System.Windows.Forms`/`Microsoft.Win32`/`System.Management`/`System.Speech`/`DllImport` 等），否则三平台编译即失败（以「三平台构建通过」为最终门禁证据）。
8. **子特性降级处理**：`SystemShutdownMonitor`（→ `ISystemEventsService` 或 no-op）、悬浮窗钩子自动隐藏与前台重排（→ Avalonia 内部事件近似或本期不支持）、AI 浮窗自适应背景（随 U5 降级）——详见 §3 附注。

---

## 7. 风险与回滚（决策级）

- **R1** 直接 P/Invoke 面广（CsWin32 23 文件 + DllImport 13 文件）→ 以 §6.7 禁用符号门禁为抽取强制校验。
- **R2** Linux 仅 X11 → 依赖 X11 的全局键/窗口枚举本期不做（C 档）。
- **R3** 悬浮窗液态玻璃/背景采样 → 首期交付经典外观（B），液态玻璃/自适应背景为 C 候选（U5）。
- **R4** 电源选项需提权 → U4 默认降级策略（预检 + 通知 + 不抛未处理异常）+ per-OS 提权记录。
- **R5** 独立 ID 后与并存的原插件无冲突，但两插件同装时功能 ID 不同、设置不互通，需在文档中说明「同装差异」。
- **R6** 静态证据门禁若放空，A 档可能再次混入 Windows 调用（本次 Copy/Move/Delete 漏判即此门禁缺失的直接例证）→ 以 §6.7 符号清单作为可测试门禁闭环。
- **回滚**：本阶段纯分析，丢弃文档即回滚；实现期新插件独立工程/ID/配置，可整体卸载/不启用，不影响 SystemTools。

---

## 8. 未决项收敛与待评审点

| 未决项 | 会签结论（门下省建议，中书省接受；最终以用户审批门确认为准） |
| --- | --- |
| **U3 目标 API 版本** | 以 misha/v2 本地检出（`E:\ClassIsland-git-misha`）的 `ClassIsland.PluginSdk`/`ClassIsland.Platforms.Abstractions` 为目标基线；发布包 2.1.1.1 仅作后备。已验证该检出含 B 档所需 `IWindowPlatformService.SetWindowFeature` 三平台实现与 `ISystemEventsService`/`ILauncherService`/`IDesktopToastService`/`IDesktopService` |
| **U4 电源提权降级** | B 档电源/锁屏/睡眠项：执行前预检（命令/权限），无权限或命令缺失时不抛未处理异常，经 `IDesktopToastService` 通知降级结果；记录 per-OS 提权要求（Linux polkit/logind、macOS osascript/pmset） |
| **U5 液态玻璃** | 首期交付悬浮窗经典外观（B）；液态玻璃 + 自适应背景采样（含悬浮窗、AI 对话浮窗、自适应主题采样路径三个消费方）为 C 候选增强 |

**待评审点（转交下一阶段，不再阻塞）**：三档边界最终确认；「同装差异」文档要求；C 档立项候选（语音/截图/音量）是否后续单独立项。

**勘误记录（v2）**：① `Copy/Move/Delete` 由 A 改判 B（R-1，文件夹子路径用 robocopy/cmd）；② `ActionFlowExecutionConfirmation` 删除「using System.Windows.Forms 残留」错误表述（R-9a）；③ 审计表数字更正（WinForms 14→10 文件、CsWin32 29→23+13）；④ 设置页补 `MoreFeaturesOptionsSettingsPage`；⑤ 包清单补 FluentAvalonia；⑥ 计数口径 A33/B19/C46=98；⑦ C 档人脸/Hello 服务与验证器去重；⑧ 行动文件数 63→62（`ClickSimulationAction.cs` 整文件注释、死代码）。
