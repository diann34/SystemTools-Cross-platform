# p0-03 证据：源插件只读范围基线与 62→61 映射（Actions 域）

| 项 | 值 |
| --- | --- |
| 案件 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p0-03 · 吏部 personnel · repository-governance / analysis |
| 源插件 | `E:\My Github Projects\SystemTools`（**全程只读**：未修改、未迁移、未创建工程） |
| 权威输入 | 04-spec §S4.1（规范计数）＞ 02-draft-solution v2（分档结论）＞ 06-migration-details-proposal（C50–C87 阅读索引）；冲突时源代码事实优先 |
| 本文件写入范围 | 仅本证据文件（案卷 evidence 目录） |
| 结论速览 | 实测 Actions\*.cs = **62**（无子目录）；`ClickSimulationAction.cs` 整文件注释死代码（1 个死代码注记，不计项）；活动功能项 **61 = A15 + B14 + C32**；全案 **A33 + B19 + C46 = 98** 与 §S4.1 一致；**计数零漂移**，登记 2 项勘误（E-1 阅读索引级、E-2 依据注记级，均不改档位不改计数） |

---

## 1. 实测清单：源插件 `Actions\*.cs` 共 62 个文件

重放命令（门下省可直接复跑）：

```powershell
Get-ChildItem 'E:\My Github Projects\SystemTools\Actions' -Filter '*.cs' -File | Sort-Object Name
# 实测结果：62 个文件；Actions 目录下无子目录
```

注册锚点重放：`Select-String -Path 'E:\My Github Projects\SystemTools\Actions\*.cs' -Pattern '\[ActionInfo'` → **62 处命中，每文件恰 1 处**；其中 `ClickSimulationAction.cs:11` 的命中位于整文件注释块**内部**（见 §2），故活动注册锚点 = 61。

> 行数列为非空行统计（`Get-Content | Measure-Object -Line`，空行不计）；所有证据行号以逐文件读取的 1-based 行号为准。

| # | 文件 | 功能 ID（ActionInfo） | 功能名（源码原文） | ActionInfo 行 | 非空行数 | 档位 |
| --: | --- | --- | --- | --: | --: | :-: |
| 1 | ActionFlowExecutionConfirmationAction.cs | SystemTools.ActionFlowExecutionConfirmation | 行动流执行确认 | :18 | 341 | A |
| 2 | AdjustScreenBrightnessAction.cs | SystemTools.AdjustScreenBrightness | 调整屏幕亮度 | :15 | 128 | C |
| 3 | AdvancedShutdownAction.cs | SystemTools.AdvancedShutdown | 高级计时关机 | :22 | 505 | B |
| 4 | AltF4Action.cs | SystemTools.AltF4 | 按下 Alt+F4 | :11 | 42 | C |
| 5 | AltTabAction.cs | SystemTools.AltTab | 按下 Alt+Tab | :11 | 42 | C |
| 6 | AutoHideMainWindowWhenOccludedAction.cs | SystemTools.AutoHideMainWindowWhenOccluded | 遮挡文字时隐藏主界面 | :14 | 45 | B |
| 7 | AutoOpenUsbDriveOnInsertAction.cs | SystemTools.AutoOpenUsbDriveOnInsert | 自动播放 | :14 | 45 | C |
| 8 | AutoSwitchClassIslandThemeAction.cs | SystemTools.AutoSwitchClassIslandTheme | 自动切换 ClassIsland 主题 | :14 | 45 | B |
| 9 | BackgroundPlayAudioAction.cs | SystemTools.BackgroundPlayAudio | 后台播放音频 | :15 | 97 | A |
| 10 | BlackScreenHtmlAction.cs | SystemTools.BlackScreenHtml | 黑屏html | :17 | 75 | C |
| 11 | CameraCaptureAction.cs | SystemTools.CameraCapture | 摄像头抓拍 | :13 | 84 | C |
| 12 | CancelShutdownAction.cs | SystemTools.CancelShutdown | 取消关机计划 | :14 | 46 | B |
| 13 | ChangeWallpaperAction.cs | SystemTools.ChangeWallpaper | 切换壁纸 | :18 | 165 | C |
| 14 | ClearAllNotificationsAction.cs | SystemTools.ClearAllNotifications | 清除全部提醒 | :14 | 37 | A |
| 15 | **ClickSimulationAction.cs** | SystemTools.ClickSimulation | 模拟点击 | :11（**注释块内**） | 45 | **死代码** |
| 16 | CloneDisplayAction.cs | SystemTools.CloneDisplay | 复制屏幕 | :17 | 60 | C |
| 17 | CopyAction.cs | SystemTools.Copy | 复制 | :12 | 105 | B |
| 18 | CtrlZAction.cs | SystemTools.CtrlZ | 按下 Ctrl+Z | :11 | 42 | C |
| 19 | DeleteAction.cs | SystemTools.Delete | 删除 | :12 | 81 | B |
| 20 | DisableDeviceAction.cs | SystemTools.DisableDevice | 禁用硬件设备 | :15 | 73 | C |
| 21 | DisableMouseAction.cs | SystemTools.DisableMouse | 禁用鼠标 | :11 | 63 | C |
| 22 | EnableDeviceAction.cs | SystemTools.EnableDevice | 启用硬件设备 | :15 | 73 | C |
| 23 | EnableMouseAction.cs | SystemTools.EnableMouse | 启用鼠标 | :11 | 63 | C |
| 24 | EnableVoiceWakeAiAction.cs | SystemTools.EnableVoiceWakeAi | 启用语音唤醒 AI | :14 | 60 | C |
| 25 | EnterKeyAction.cs | SystemTools.EnterKey | 按下 Enter 键 | :11 | 35 | C |
| 26 | EscAction.cs | SystemTools.EscKey | 按下 Esc 键 | :11 | 32 | C |
| 27 | ExtendDisplayAction.cs | SystemTools.ExtendDisplay | 扩展屏幕 | :17 | 60 | C |
| 28 | ExternalDisplayAction.cs | SystemTools.ExternalDisplay | 仅第二屏幕 | :17 | 60 | C |
| 29 | F11Action.cs | SystemTools.F11Key | 按下 F11 键 | :11 | 32 | C |
| 30 | FullscreenClockAction.cs | SystemTools.FullscreenClock | 沉浸式时钟 | :10 | 34 | A |
| 31 | ImmediateRestartAction.cs | SystemTools.ImmediateRestart | 立即重启 | :12 | 52 | B |
| 32 | ImmediateShutdownAction.cs | SystemTools.ImmediateShutdown | 立即关机 | :12 | 52 | B |
| 33 | InternalDisplayAction.cs | SystemTools.InternalDisplay | 仅电脑屏幕 | :17 | 60 | C |
| 34 | KillProcessAction.cs | SystemTools.KillProcess | 退出进程 | :15 | 84 | A |
| 35 | LoadTemporaryClassPlanAction.cs | SystemTools.LoadTemporaryClassPlan | 加载临时课表 | :15 | 68 | A |
| 36 | LockScreenAction.cs | SystemTools.LockScreen | 锁定屏幕 | :14 | 46 | B |
| 37 | MoveAction.cs | SystemTools.Move | 移动 | :12 | 106 | B |
| 38 | OpenAppSettingsAction.cs | SystemTools.OpenAppSettings | 打开应用设置 | :14 | 30 | A |
| 39 | OpenClassSwapWindowAction.cs | SystemTools.OpenClassSwapWindow | 打开换课窗口 | :14 | 30 | A |
| 40 | OpenProfileEditorAction.cs | SystemTools.OpenProfileEditor | 打开档案编辑 | :14 | 30 | A |
| 41 | RestartAsAdminAction.cs | SystemTools.RestartAsAdmin | 重启应用为管理员身份 | :13 | 56 | C |
| 42 | ScreenShotAction.cs | SystemTools.ScreenShot | 屏幕截图 | :17 | 63 | C |
| 43 | SetVolume.cs | SystemTools.SetVolume | 设置系统音量 | :15 | 183 | C |
| 44 | ShowAiChatDialogAction.cs | SystemTools.ShowAiChatDialog | 显示AI对话框 | :9 | 18 | A |
| 45 | ShowDesktopAction.cs | SystemTools.ShowDesktop | 显示桌面 | :15 | 45 | C |
| 46 | ShowFloatingWindowAction.cs | SystemTools.ShowFloatingWindow | 显示悬浮窗 | :15 | 78 | B |
| 47 | ShowToastAction.cs | SystemTools.ShowToast | 拉起自定义Windows通知 | :11 | 39 | A |
| 48 | ShutdownAction.cs | SystemTools.Shutdown | 计时关机 | :15 | 51 | B |
| 49 | SimulateKeyboardAction.cs | SystemTools.SimulateKeyboard | 模拟键盘 | :15 | 99 | C |
| 50 | SimulateKeyCombinationAction.cs | SystemTools.SimulateKeyCombination | 模拟组合键 | :17 | 70 | C |
| 51 | SimulateMouseAction.cs | SystemTools.SimulateMouse | 模拟鼠标 | :17 | 225 | C |
| 52 | SleepAction.cs | SystemTools.Sleep | 睡眠 | :10 | 36 | B |
| 53 | SwitchFloatingWindowThemeAction.cs | SystemTools.SwitchFloatingWindowTheme | 切换悬浮窗主题 | :15 | 88 | A |
| 54 | SwitchSystemAccentColorAction.cs | SystemTools.SwitchSystemAccentColor | 切换系统强调色 | :14 | 86 | C |
| 55 | SwitchThemeAction.cs | SystemTools.SwitchTheme | 切换主题色 | :15 | 41 | C |
| 56 | ToggleFloatingWindowLayerAction.cs | SystemTools.ToggleFloatingWindowLayer | 切换悬浮窗层级 | :18 | 86 | B |
| 57 | ToggleFloatingWindowProfileAction.cs | SystemTools.ToggleFloatingWindowProfile | 切换悬浮窗配置方案 | :17 | 81 | A |
| 58 | ToggleWorkflowAction.cs | SystemTools.ToggleWorkflow | 开关自动化 | :15 | 156 | A |
| 59 | TriggerCustomTriggerAction.cs | SystemTools.TriggerCustomTrigger | 触发指定触发器 | :13 | 46 | A |
| 60 | TypeContentAction.cs | SystemTools.TypeContent | 键入内容 | :16 | 116 | C |
| 61 | WakeUpVoiceConversationAiAction.cs | SystemTools.WakeUpVoiceConversationAi | 唤醒语音对话 AI | :9 | 21 | C |
| 62 | WindowOperationAction.cs | SystemTools.WindowOperation | 窗口操作 | :15 | 71 | C |

---

## 2. 死代码注记（1 个，不计活动功能项）

**`Actions\ClickSimulationAction.cs`（清单 #15）——整文件块注释，未编译、未注册。**

- 整文件包裹证据：第 1 行以 `/*using ClassIsland.Core.Abstractions.Automation;` 开始，第 55 行以 `*/` 结束；第 1–55 行全部内容位于同一对块注释符内，无任何有效代码。
- `:11` 的 `[ActionInfo("SystemTools.ClickSimulation", "模拟点击", ...)]` 与 `:12` 的类声明均在注释块内部 → 编译器不产出该类型，框架无法经 ActionInfo 反射发现它（ClassIsland 行动注册机制依赖活动 ActionInfo 特性）。
- 全仓库引用重放（排除 bin/obj/.git）：`ClickSimulation` 仅出现在本文件（注释内）与 `Controls\ClickSimulationSettingsControl.cs:9,14`、`Settings\ClickSimulationSettings.cs:5`——后两者引用的是 **Settings 配置类型**（非 Action 类），不构成对该行动类的编译引用或注册。
- 与规范口径一致：04-spec §S4.1 行动行、§S5.1、02 v2 计数映射（:251）、06（:14、:359、:377、:527）均记此文件为整文件注释死代码、不计项。**映射表保留 1 条死代码注记，活动项 = 62 − 1 = 61。**

---

## 3. 62 文件 → 61 活动功能项映射表

口径说明：

1. 每个活动文件恰 1 个活动 ActionInfo 注册锚点 → **文件与功能项一一对应（61↔61），无重复、无遗漏**。
2. 「常用模拟键」6 个行动（Alt+F4/Alt+Tab/Ctrl+Z/Enter/Esc/F11）：06 L345–347 的阅读条目按 1 组合并，但规范行动计数必须展开为 6 个（06 L522/L527/L537 的「+5 展开差项」）。本表按规范展开为 **6 个源文件映射**。
3. 分档依据口径：A = 无 S4.2 禁用符号（纯 BCL/ClassIsland SDK/Avalonia/FluentAvalonia/宿主跨平台抽象）；B = 存在 Windows 专属点但可单点替换（电源/锁屏 7 项随 U4 降级策略）；C = Win32 注入/注册表/WMI 或等价 Windows 专属机制，无统一跨平台语义，本期不迁移。

### 3.1 A 档 · 可直接迁移（15 项）

| # | 功能项 | 源文件:行证据 | 分档依据 |
| --: | --- | --- | --- |
| A1 | 退出进程 | `KillProcessAction.cs:15`（注册）；`:41` `Process.GetProcessesByName`；`:52` `.Kill()` | 纯 BCL，无 S4.2 符号 |
| A2 | 拉起自定义通知 | `ShowToastAction.cs:11`；`:31` `PlatformServices.DesktopToastService.ShowToastAsync` | 宿主跨平台抽象 |
| A3 | 切换悬浮窗配置方案 | `ToggleFloatingWindowProfileAction.cs:17`；`:18-21` 纯配置状态（`PreviousProfiles` 字典） | 纯配置，无平台符号 |
| A4 | 切换悬浮窗主题 | `SwitchFloatingWindowThemeAction.cs:15`；`:16-19` 纯配置状态 | 纯配置，无平台符号 |
| A5 | 后台播放音频 | `BackgroundPlayAudioAction.cs:15`；`:41` `IAppHost.TryGetService<IAudioService>`；`:89` `OperatingSystem.IsWindows()` 路径归一化分支 | 宿主抽象；`:89` 为 S4.2 允许的守卫分支（可删） |
| A6 | 行动流执行确认 | `ActionFlowExecutionConfirmationAction.cs:18`；`:8` `using FluentAvalonia.UI.Controls`；`:32-33,99` `FATaskDialog` | Avalonia/FluentAvalonia，无 WinForms 引用 |
| A7 | 触发指定触发器 | `TriggerCustomTriggerAction.cs:13`；`:38` 写 `auto.json`；`:42-43` `JsonSerializer.Serialize` + `File.WriteAllTextAsync` | BCL + 自动化 SDK |
| A8 | 开关自动化 | `ToggleWorkflowAction.cs:15`；`:34` `IAppHost.TryGetService<IAutomationService>` | SDK 服务抽象 |
| A9 | 显示 AI 对话框（AI 文本对话核心） | `ShowAiChatDialogAction.cs:9`；`:10-12` 注入 `AiChatWindowService`；`:17` `aiChatWindowService.ShowAsync()` | Avalonia 浮窗 + HTTP 文本链（自适应背景子特性随 U5 降级，R-6，不改主结论） |
| A10 | 沉浸式时钟 | `FullscreenClockAction.cs:10`；`:30` `Process.Start(psi)` | 纯 BCL（建议改 `ILauncherService.LaunchUrl`，02 §2.5） |
| A11 | 清除全部提醒 | `ClearAllNotificationsAction.cs:14`；`:23` `IAppHost.GetService<INotificationHostService>` | SDK 服务（反射调用为观察点，02 §2.5） |
| A12 | 加载临时课表 | `LoadTemporaryClassPlanAction.cs:15`；`:18,22` `IProfileService` 注入；`:35,44` 使用 | SDK 服务抽象 |
| A13 | 打开应用设置 | `OpenAppSettingsAction.cs:14`；`:17,20` `IUriNavigationService`；`:25` `NavigateWrapped(new Uri("classisland://app/settings"))` | SDK URI 导航抽象 |
| A14 | 打开档案编辑 | `OpenProfileEditorAction.cs:14`；`:25` `NavigateWrapped(new Uri("classisland://app/profile"))` | 同上 |
| A15 | 打开换课窗口 | `OpenClassSwapWindowAction.cs:14`；`:25` `NavigateWrapped(new Uri("classisland://app/class-swap"))` | 同上 |

### 3.2 B 档 · 稍加修改即可跨平台（14 项）

| # | 功能项 | Windows 专属点（文件:行） | 分档依据（替换目标 / 降级） |
| --: | --- | --- | --- |
| B1 | 复制（文件/文件夹） | `CopyAction.cs:12`；文件分支 `:65` BCL `File.Copy`；文件夹分支 `:96-98` `robocopy.exe` | A→B 改判（02 勘误① / R-1）；→ 跨平台递归复制或 per-OS 命令；失败记日志抛行动错误 |
| B2 | 移动（文件/文件夹） | `MoveAction.cs:12`；`:65` `File.Move`；`:96-98` `robocopy.exe /move` | 同 B1 |
| B3 | 删除（文件/文件夹） | `DeleteAction.cs:12`；文件分支 `:51` `File.Delete`；文件夹分支 `:29` `cmd.exe` + `:69` `rmdir /s /q` | 同 B1 |
| B4 | 计时关机 | `ShutdownAction.cs:15`；`:32` `FileName="shutdown"`；`:43` `SendKeys.SendWait`（WinForms） | U4：预检命令/权限，`IDesktopToastService` 通知降级，不抛未处理异常 |
| B5 | 高级计时关机 | `AdvancedShutdownAction.cs:22`；`:33` `AdvancedShutdownDialog`（Avalonia UI 保留）；`:35` `DispatcherTimer`；`:207,:395` `FileName="shutdown"` 进程 | UI 保留、关机/取消换 OS 命令；U4 |
| B6 | 取消关机计划 | `CancelShutdownAction.cs:14`；`:29-30` `shutdown` + `-a` | U4（Linux `shutdown -c` / macOS `pmset cancelall`） |
| B7 | 锁定屏幕 | `LockScreenAction.cs:14`；`:29-30` `rundll32.exe` + `user32.dll,LockWorkStation` | U4（`loginctl lock-session` / `osascript`） |
| B8 | 立即重启 | `ImmediateRestartAction.cs:12`；`:16-17` `[DllImport ntdll RtlAdjustPrivilege]`；`:23` 提权；`:28` `ExitWindowsEx(EWX_REBOOT)` | U4（`systemctl reboot` / `osascript restart`） |
| B9 | 立即关机 | `ImmediateShutdownAction.cs:12`；`:16-17` 同上；`:28` `ExitWindowsEx(EWX_SHUTDOWN|EWX_POWEROFF)` | U4（`systemctl poweroff` / `shutdown -h now`） |
| B10 | 睡眠 | `SleepAction.cs:10`；`:23-24` `rundll32.exe` + `powrprof.dll,SetSuspendState` | U4（`systemctl suspend` / `pmset sleepnow`） |
| B11 | 显示悬浮窗 | `ShowFloatingWindowAction.cs:15`；`:16-21` 注入 `FloatingWindowService`（悬浮窗本体/经典外观；Windows 钩子点在服务侧，见 02 §3 R-3 附注） | 经典外观保留（悬浮窗「服务」子特性，S3-R3 口径）；钩子自动隐藏/前台重排降级 |
| B12 | 切换悬浮窗层级 | `ToggleFloatingWindowLayerAction.cs:18`；`:19-22` 层级状态；服务侧 `Services\FloatingWindowService.cs:2332,2337` `PInvoke.SetWindowPos(HwndBottom/HwndTopmost)`（已验证） | → `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)`；宿主特性不可用保持默认层级 |
| B13 | 自动切换 ClassIsland 主题 | `AutoSwitchClassIslandThemeAction.cs:14`；`:30` `config.AutoSwitchClassIslandTheme = Settings.Enable`（开关 `AdaptiveThemeSyncService`；亮度采样 GDI 依赖在服务侧，02 §3 行 132） | 采样换宿主方案；无采样退化「跟随宿主明暗/手动」；U5 采样路径为 C 候选 |
| B14 | 遮挡文字时隐藏主界面 | `AutoHideMainWindowWhenOccludedAction.cs:14`；`:31` `IAppHost.GetService<MainWindowTextOcclusionService>().ApplyConfig()`（WinRT OCR + GDI 捕获在服务侧，02 §3 行 133） | 截图/OCR 换宿主或 tesseract；不可用降级手动开关（U4 同款预检） |

### 3.3 C 档 · 本期不迁移（32 项，按 8a–8e 阅读分组展开）

**8a 输入模拟（13 项）**

| # | 功能项 | 源文件:行证据 | C 档依据摘要 |
| --: | --- | --- | --- |
| C1 | 按下 Alt+F4 | `AltF4Action.cs:11`；`:26-30` `PInvoke.keybd_event(VK_MENU/VK_F4)` | Win32 键盘注入 + Windows 虚拟键码模型 |
| C2 | 按下 Alt+Tab | `AltTabAction.cs:11`；`:26-30` `keybd_event(VK_MENU/VK_TAB)` | 同上 |
| C3 | 按下 Ctrl+Z | `CtrlZAction.cs:11`；`:26-30` `keybd_event(VK_CONTROL/VK_Z)` | 同上 |
| C4 | 按下 Enter 键 | `EnterKeyAction.cs:11`；`:25-31` `keybd_event(VK_RETURN)` | 同上 |
| C5 | 按下 Esc 键 | `EscAction.cs:11`；`:24-26` `keybd_event(VK_ESCAPE)` | 同上 |
| C6 | 按下 F11 键 | `F11Action.cs:11`；`:24-27` `keybd_event(VK_F11)` | 同上；**勘误 E-1：06 阅读索引误记 F11 源码位于 BlackScreenHtmlAction，源码为独立活动文件**（见 §5） |
| C7 | 模拟键盘 | `SimulateKeyboardAction.cs:15`；`:11` `using Windows.Win32`；`:51-55` `keybd_event` 注入录制序列 | 录制键序列依赖 Windows 键码与全局注入 |
| C8 | 模拟组合键 | `SimulateKeyCombinationAction.cs:17`；`:12-13` `Windows.Win32`；`:48,:64` `keybd_event` 及释放状态 | 组合顺序/拦截/权限绑定 Windows 注入模型 |
| C9 | 模拟鼠标 | `SimulateMouseAction.cs:17`；`:13` `Windows.Win32`；`:57-66` `PInvoke.mouse_event` | user32 鼠标注入；X11/macOS 权限与坐标语义不一致 |
| C10 | 键入内容 | `TypeContentAction.cs:16`；`:35` `SetClipboardText`；`:38-42` `keybd_event` Ctrl+V | 剪贴板写入 + 全局键盘注入双依赖 |
| C11 | 窗口操作 | `WindowOperationAction.cs:15`；`:11` `Windows.Win32`；`:26-27` `PInvoke.GetForegroundWindow` | HWND 前台/激活/最小化语义，无跨平台对等 |
| C12 | 禁用鼠标 | `DisableMouseAction.cs:11`；`:29` 启动 `jinyongshubiao.bat`（设置控件侧另有 `SetWindowsHookEx` 低级钩子） | 批处理 + 全局钩子均为 Windows 专属 |
| C13 | 启用鼠标 | `EnableMouseAction.cs:11`；`:29` 启动 `huifu.bat` | 与 C12 成对的 Windows 恢复路径 |

**8b 显示/桌面（7 项）**

| # | 功能项 | 源文件:行证据 | C 档依据摘要 |
| --: | --- | --- | --- |
| C14 | 复制屏幕 | `CloneDisplayAction.cs:17`；`:30,:53` `DisplaySwitch.exe` | Windows `SetDisplayConfig`/DisplaySwitch 拓扑语义 |
| C15 | 扩展屏幕 | `ExtendDisplayAction.cs:17`；`:30,:53` `DisplaySwitch.exe` | 同上 |
| C16 | 仅电脑屏幕 | `InternalDisplayAction.cs:17`；`:30,:53` `DisplaySwitch.exe` | 同上 |
| C17 | 仅第二屏幕 | `ExternalDisplayAction.cs:17`；`:30,:53` `DisplaySwitch.exe` | 同上 |
| C18 | 黑屏 html | `BlackScreenHtmlAction.cs:17`；`:47-48` `cmd /c start` 打开 black.html；`:64-67` `keybd_event(VK_F11)` 自动全屏 | `cmd/start` + Win32 键盘注入 + 浏览器焦点语义 |
| C19 | 显示桌面 | `ShowDesktopAction.cs:15`；`:20-21` `VK_LWIN/VK_D`；`:29-32` `keybd_event` Win+D | Windows Shell 快捷键，无统一等价 |
| C20 | 调整屏幕亮度 | `AdjustScreenBrightnessAction.cs:15`；`:5` `using System.Management`；`:75-79` WMI `ManagementScope(@"\\.\root\wmi")` + `ManagementObjectSearcher` | WMI root\wmi；Linux/macOS 背光接口碎片化 |

**8c 个性化/硬件（6 项）**

| # | 功能项 | 源文件:行证据 | C 档依据摘要 |
| --: | --- | --- | --- |
| C21 | 切换壁纸 | `ChangeWallpaperAction.cs:18`；`:119-127,:135` 注册表 `Control Panel\Desktop`/`Colors` + `SystemParametersInfo` | 注册表 + Win32 个性化接口 |
| C22 | 切换主题色 | `SwitchThemeAction.cs:15`；`:30-32` 注册表 `...Themes\Personalize` 写 `AppsUseLightTheme` | Windows 注册表个性化键 |
| C23 | 切换系统强调色 | `SwitchSystemAccentColorAction.cs:14`；`:36` 注册表 `Software\Microsoft\Windows\DWM`（AccentColor） | DWM 注册表专属键 |
| C24 | 禁用硬件设备 | `DisableDeviceAction.cs:15`；`:35-47` 动态生成 `{id后6位}.bat`+`.ps1`（`:40` `net session` 提权检查、`:42` `RunAs`）；`:49-52` `Get-PnpDevice`/`Disable-PnpDevice` | **勘误 E-2：依据为 Windows PowerShell PnP cmdlet + UAC 提权，非 02 §4.4 所称 WMI**；档位不变（Windows 专属提权语义） |
| C25 | 启用硬件设备 | `EnableDeviceAction.cs:15`；`:35` `Enable_{id后6位}.bat`；`:40,:42` 同上；`:49-52` `Get-PnpDevice`/`Enable-PnpDevice` | 与 C24 对称；同 E-2 |
| C26 | U 盘插入自动打开（自动播放） | `AutoOpenUsbDriveOnInsertAction.cs:14`；`:30` `config.AutoOpenUsbDriveOnInsert = Settings.Enable`（开关 `UsbAutoPlayService`：WMI + `RegisterDeviceNotification` 在服务侧） | Linux udev / macOS IOKit 触发语义不同；服务侧 UsbAutoPlayService 另计服务域 C 项 |

**8d 语音行动（2 项）**

| # | 功能项 | 源文件:行证据 | C 档依据摘要 |
| --: | --- | --- | --- |
| C27 | 启用语音唤醒 AI | `EnableVoiceWakeAiAction.cs:14`；`:30` `config.EnableVoiceWakeAi = Settings.Enable` | 依赖语音族（SAPI/Vosk 服务另计服务域 2 项）；win-x64 VoskWorker 本期不跨平台 |
| C28 | 唤醒语音对话 AI | `WakeUpVoiceConversationAiAction.cs:9`；`:10-12` 注入 `AiVoiceConversationService`；`:18` `TryStartVoiceConversation()` | 同上（VoskSpeechService / NAudio.Wasapi 依赖在服务侧） |

**8e 截图/音量/摄像头/提权（4 项）**

| # | 功能项 | 源文件:行证据 | C 档依据摘要 |
| --: | --- | --- | --- |
| C29 | 屏幕截图【立项候选】 | `ScreenShotAction.cs:17`；`:6` `using System.Windows.Forms`；`:53` `graphics.CopyFromScreen` | WinForms GDI 截屏，需 per-OS 后端 |
| C30 | 设置系统音量【立项候选】 | `SetVolume.cs:15`；`:56-77` 自定义 Core Audio COM 接口（`IMMDeviceEnumerator`/`IMMDevice`/`IAudioEndpointVolume`） | Windows Core Audio COM；Linux PipeWire/PulseAudio、macOS CoreAudio 分叉 |
| C31 | 摄像头抓拍 | `CameraCaptureAction.cs:13`；`:48-52` `DependencyPaths.GetFfmpegPath()` + `找不到 ffmpeg.exe` 校验；`:57` 启动 | win 原生运行时与摄像头设备访问需 per-OS 改造 |
| C32 | 重启应用为管理员身份 | `RestartAsAdminAction.cs:13`；`:33` `Verb="runas"`；`:63-64` `WindowsIdentity`/`WindowsPrincipal` | Windows UAC 提权语义在 Linux/macOS 不成立 |

**C 档小计校验：8a 13 + 8b 7 + 8c 6 + 8d 2 + 8e 4 = 32 ✓（与 06 L522/L533 行动展开一致）**

---

## 4. 逐域汇总与计数闭合

### 4.1 行动域

```
62 个实测 .cs 文件 = 61 活动功能项 + 1 死代码注记（ClickSimulationAction.cs）
61 活动项 = A 15 + B 14 + C 32   ✓（与 04-spec §S4.1 行动行、02 :251、06 :14/:550 一致）
```

### 4.2 全案功能域展开（规范计数 A33 + B19 + C46 = 98）

| 功能域 | A | B | C | 小计 | 说明 |
| --- | --: | --: | --: | --: | --- |
| 主题 | 3 | 0 | 0 | **3** | Card-type / ClassWidgets 2 Style / Notch Style（全 A） |
| 组件 | 6 | 0 | 1 | **7** | C = 音乐软件歌词显示 |
| 规则集 | 4 | 0 | 1 | **5** | C = 正在播放媒体音乐 |
| 触发器 | 1 | 1 | 5 | **7** | A=行动进行时；B=从悬浮窗触发；C=USB 插入/热键/长时空闲/关键词/点击主界面 |
| 行动 | 15 | 14 | 32 | **61** | 本文件 §3 映射表（62 文件 − 1 死代码） |
| 服务 / 设置页（A 聚合） | 4 | — | — | **4** | AI 文本链 / 虚拟放学 / 版本检查 / 设置页骨架（6 页，02 §2.6） |
| 服务（B 聚合） | — | 4 | — | **4** | 悬浮窗经典外观 / 自适应主题 / 遮挡 OCR / ClassIsland 内存 GC（02 §3 行 136） |
| 服务 / 认证（C） | — | — | 7 | **7** | `UsbAutoPlayService`、`KeywordSpeechService`(SAPI)、`VoskSpeechService`(VoskWorker)、人脸服务+验证器(合并 1)、Hello 服务+验证器(合并 1)、`SystemMemoryCleanupService`、`MainWindowBackgroundCaptureService` 背景截图采样（06 L523） |
| **合计** | **33** | **19** | **46** | **98** | A: 3+6+4+1+15+4=33 ✓；B: 1+14+4=19 ✓；C: 1+1+5+32+7=46 ✓ |

去重口径（引用 06「38 与 46 的差项说明」）：

- 人脸 / Windows Hello：服务与验证器为同一实体，各合并计 1 项（R-7）。
- 「C 档依赖下载管理（FFmpeg/人脸模型/VoskWorker/语音模型）」是设置页聚合/裁剪说明，**不产生新增功能项**（06 L538、L511）。
- 常用模拟键合并阅读条目（06 C50）按规范展开为 6 个行动文件（+5 差项，06 L537）；本表已展开。
- 8d 语音条目拆分：触发器（关键词）归触发器域、SAPI/Vosk 两服务归服务/认证域、行动仅 2 项（06 L530）。
- `MainWindowBackgroundCaptureService` 背景截图采样与屏幕截图行动（C29）不是同一功能，分别计服务域与行动域各 1 项（06 L539）。

### 4.3 与 04-spec §S4.1 逐行一致性核对

| S4.1 行 | S4.1 要求 | 实测/映射结果 | 结论 |
| --- | --- | --- | --- |
| 主题 | 3（构建内），全 A | 3，全 A | ✅ 一致 |
| 组件 | 7 = 6 A + 1 C（歌词） | 6 A + 1 C | ✅ 一致 |
| 规则集 | 5 = 4 A + 1 C（媒体播放） | 4 A + 1 C | ✅ 一致 |
| 触发器 | 7 = 1 A + 1 B（悬浮窗触发）+ 5 C | 1 A + 1 B + 5 C | ✅ 一致 |
| 行动 | 61 活动功能项 / 62 文件映射表；`ClickSimulationAction.cs` 整文件注释死代码不计项；15 A + 14 B + 32 C | 62 实测；61 = 15+14+32；死代码已确认（§2） | ✅ 一致 |
| 设置页 | 6；骨架 A；内嵌选项按功能分档，依赖下载管理随 C 裁剪 | 6 页骨架 A（计入 A 聚合 4）；内嵌选项归行动/服务对应档（自动切换主题 B / 遮挡隐藏 B / 内存 GC B / U 盘自动打开 C）；依赖下载管理为聚合说明不计项 | ✅ 一致 |
| AI 服务 | 文本链 A；语音族 C（SAPI + Vosk 2 项） | 文本链 A（计入 A 聚合 4）；SAPI + Vosk 各 1 项 C（计入服务/认证 7） | ✅ 一致 |
| 悬浮窗/更多功能选项 | 全部子特性按 S3-R3 分解 | 已分解并分别落入行动域（悬浮窗 2A+2B、更多选项 2B+1C）与服务域（悬浮窗经典外观 B），无重复计项 | ✅ 一致 |
| 总计 | A33 + B19 + C46 = 98，与逐域之和一致 | 33 + 19 + 46 = 98 | ✅ 一致 |

---

## 5. 一致性核对结论与勘误项

**总结论：计数闭合、无漂移。** 实测 62 = 规范 62；61 = A15+B14+C32；98 = A33+B19+C46；文件↔功能项一一对应，无重复、无遗漏；档位结论全部与 02 v2 / 04-spec §S4.1 一致。以下 2 项勘误为**索引/依据注记级修正**，均不改变任何功能项的档位或计数，按 S6 处理原则登记，供门下省增量复核与 06 索引维护方修订：

- **E-1（06 阅读索引 · F11 映射）**：06 L346 与 L527 称「F11 的源码仍在 `BlackScreenHtmlAction`（:64-67）」。源代码事实：**`F11Action.cs` 是独立的活动注册行动**（`:11` `[ActionInfo("SystemTools.F11Key", "按下 F11 键", ...)]`，`:24-27` `PInvoke.keybd_event(VK_F11)`），与 `AltF4/AltTab/CtrlZ/EnterKey/Esc` 同构。`BlackScreenHtmlAction.cs:64-67` 的 F11 注入是「黑屏 html」行动自身打开页面后自动全屏的行为，不承担常用模拟键 F11 的职责。**常用模拟键 6 个源文件映射修正为：`AltF4Action.cs`、`AltTabAction.cs`、`CtrlZAction.cs`、`EnterKeyAction.cs`、`EscAction.cs`、`F11Action.cs`。** 展开后 8a 仍为 13 项、常用模拟键仍为 6 项 → 计数与档位零影响。
- **E-2（02 §4.4 依据注记 · 禁用/启用硬件设备）**：02 §4.4 记「禁用硬件设备 / 启用硬件设备（WMI）」。源代码事实：两行动**不经 WMI**，而是运行时动态生成 `{id后6位}.bat`/`Enable_{id后6位}.bat` 与同名 `.ps1`（`DisableDeviceAction.cs:35-47`、`EnableDeviceAction.cs:35-58`），bat 内 `net session` 检查并以 `-Verb RunAs` UAC 提权后执行 PowerShell `Get-PnpDevice` + `Disable-PnpDevice` / `Enable-PnpDevice`（`DisableDeviceAction.cs:49-52`、`EnableDeviceAction.cs:49-52`）。真实 Windows 专属点 = Windows PowerShell PnP cmdlet + UAC 管理员提权。**C 档结论不变**（Windows 专属设备管理语义，Linux 需 udev、macOS 无对等），仅依据注记需修正。

### 抽查覆盖声明（对照 04-spec §S5.2：抽样 ≥10 项，含全部 7 项电源 B 档与全部 A→B 改判项）

本轮已在源码行级重放验证（证据行与本表一致）：

- 电源/锁屏 B 档 7 项全部：B4（:32/:43）、B5（:207/:395 实测命中 `FileName="shutdown"`）、B6（:29-30）、B7（:29-30）、B8（:16-17/:23/:28）、B9（:16-17/:28）、B10（:23-24）。
- A→B 改判 3 项全部：B1（:65/:96-98）、B2（:65/:96-98）、B3（:29/:51/:69）。
- B 档悬浮窗/更多选项 4 项：B11–B14（含 `Services\FloatingWindowService.cs:2332,2337` `SetWindowPos` 交叉证据）。
- A 档 8 项：A1、A2（:31）、A5（:41/:89）、A6（:8/:99）、A7（:38/:42-43）、A8（:34）、A11（:23）、A13–A15（:25）。
- C 档代表 12 项：8a 的 C1–C6、C7、C9–C11；8b 的 C14、C18、C19、C20；8c 的 C21–C25；8e 的 C29–C32（含 E-2 两文件全文读取）。
- 全量注册锚点重放：62 个 ActionInfo（61 活动 + 1 注释块内）。

其余未逐行展开的活动项，其功能名与注册锚点已全量实测（§1 表），行为证据沿用 02 v2 / 06 中已被本轮抽样证实可靠的引用体系。

---

## 6. 只读声明与复核指引

- 源插件 `E:\My Github Projects\SystemTools` 本任务**零写入**；全部操作为只读列举、只读检索与只读读取。本任务唯一产出即本证据文件。
- 快速复核命令：
  1. 计数：`Get-ChildItem 'E:\My Github Projects\SystemTools\Actions' -Filter '*.cs' -File`（应 62）。
  2. 死代码：读取 `Actions\ClickSimulationAction.cs` 全文（55 行均处 `/* */` 内）。
  3. 锚点：`Select-String -Path 'E:\My Github Projects\SystemTools\Actions\*.cs' -Pattern '\[ActionInfo'`（应 62，其中 1 处在注释块内）。
  4. E-1/E-2：读取 `Actions\F11Action.cs`、`Actions\DisableDeviceAction.cs`、`Actions\EnableDeviceAction.cs`。
