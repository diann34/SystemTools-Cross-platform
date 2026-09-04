# p1-03 证据：A 档行动 15 项抽取（兵部 war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-03 · 兵部 war · application-code / implementation（依赖 p1-05，已 succeeded） |
| 权威输入 | p0-03 §3.1 A1–A15 清单（范围权威）、p1-05 落位规范（结构权威）、04-spec §S4.2/R-*/U4/U5、05 阶段合同阶段 1、p0-01 宿主契约（U3）、源插件目录（只读参照） |
| 交付范围 | 新增 44 个文件：`Actions\` 15 + `Settings\` 11 + `Controls\` 平铺 11 + `ConfigHandlers\` 6（§2.3-2 共享类型）+ `Shared\GlobalConstants.cs`（§2.3-2 共享类型） |
| 结论 | **succeeded** —— 15/15 行动 + 附属与共享类型逐文件落位；S4.2 扫描 5 落点 + 全树现状 6/6 PASS（exit=0，GateHits=0）；macOS 自检表 0 项"不适用"；系统命令/进程启动类降级处置 3 项 + 死代码注释清理 1 项 + 阶段 1 架构适配 3 项 + 共享类型存储根适配 1 项 + 守卫分支保留声明 2 处；未改 Plugin.cs / manifest.yml / csproj / global.json / slnx |
| 修复记录 | p1-10 构建复验暴露 CS1061（D10，Avalonia 12.1.1 API 面差异），已修复并复验：Roslyn 批级自检 44 文件 error=0；S4.2 修复后复跑 PASS（详见 §2 D10 与 §5 修复轮记录） |

---

## 1. 逐项源对照与落点清单（新文件与 A 档 15 项一一对应）

### 1.1 行动主文件（Actions\ 平铺 15，文件名随源；命名空间 `SystemTools.CrossPlatform.Actions`）

| 项 | 功能名 | 源文件:行（ActionInfo 注册锚） | 新落点 | 适配 |
| --- | --- | --- | --- | --- |
| A1 | 退出进程 | `Actions\KillProcessAction.cs:15` | `Actions\KillProcessAction.cs` | D3（见 §2：源内 taskkill 注释死代码清理）；提醒路径跨批依赖 |
| A2 | 拉起自定义Windows通知 | `Actions\ShowToastAction.cs:11` | `Actions\ShowToastAction.cs` | 无（宿主抽象原样） |
| A3 | 切换悬浮窗配置方案 | `Actions\ToggleFloatingWindowProfileAction.cs:17` | `Actions\ToggleFloatingWindowProfileAction.cs` | D5 |
| A4 | 切换悬浮窗主题 | `Actions\SwitchFloatingWindowThemeAction.cs:15` | `Actions\SwitchFloatingWindowThemeAction.cs` | D7 |
| A5 | 后台播放音频 | `Actions\BackgroundPlayAudioAction.cs:15` | `Actions\BackgroundPlayAudioAction.cs` | D9-1（`:89` Windows 守卫分支保留）；删除源未使用的 `using SystemTools.Services;` |
| A6 | 行动流执行确认 | `Actions\ActionFlowExecutionConfirmationAction.cs:18` | `Actions\ActionFlowExecutionConfirmationAction.cs` | 无 |
| A7 | 触发指定触发器 | `Actions\TriggerCustomTriggerAction.cs:13` | `Actions\TriggerCustomTriggerAction.cs` | 无（auto.json 对端为 p1-02 ActionInProgressTrigger） |
| A8 | 开关自动化 | `Actions\ToggleWorkflowAction.cs:15` | `Actions\ToggleWorkflowAction.cs` | 无 |
| A9 | 显示AI对话框 | `Actions\ShowAiChatDialogAction.cs:9` | `Actions\ShowAiChatDialogAction.cs` | 无（DI 依赖 AiChatWindowService = p1-04，已落盘） |
| A10 | 沉浸式时钟 | `Actions\FullscreenClockAction.cs:10` | `Actions\FullscreenClockAction.cs` | D1 |
| A11 | 清除全部提醒 | `Actions\ClearAllNotificationsAction.cs:14` | `Actions\ClearAllNotificationsAction.cs` | 提醒路径跨批依赖 |
| A12 | 加载临时课表 | `Actions\LoadTemporaryClassPlanAction.cs:15` | `Actions\LoadTemporaryClassPlanAction.cs` | 提醒路径跨批依赖 |
| A13 | 打开应用设置 | `Actions\OpenAppSettingsAction.cs:14` | `Actions\OpenAppSettingsAction.cs` | 提醒路径跨批依赖 |
| A14 | 打开档案编辑 | `Actions\OpenProfileEditorAction.cs:14` | `Actions\OpenProfileEditorAction.cs` | 提醒路径跨批依赖 |
| A15 | 打开换课窗口 | `Actions\OpenClassSwapWindowAction.cs:14` | `Actions\OpenClassSwapWindowAction.cs` | 提醒路径跨批依赖 |

15 项功能 ID 逐一按前缀规则 `SystemTools.<Name>` → `SystemTools.CrossPlatform.<Name>` 变换（显示名/图标参数随源不改），清单见 §4。

### 1.2 附属文件（p1-05 §2.3-1：随功能项走，源→新落点映射）

| 功能项 | 源文件（源锚） | 新落点 | 说明 |
| --- | --- | --- | --- |
| A1 | `Settings\KillProcessSettings.cs:5` | `Settings\KillProcessSettings.cs` | 设置类型 |
| A1 | `Controls\KillProcessSettingsControl.cs:14` | `Controls\KillProcessSettingsControl.cs` | 设置控件；D3 适配 |
| A2 | `Settings\ShowToastSettings.cs:5` | `Settings\ShowToastSettings.cs` | |
| A2 | `Controls\ShowToastSettingsControl.cs:8` | `Controls\ShowToastSettingsControl.cs` | |
| A3 | `Settings\ToggleFloatingWindowProfileSettings.cs:8` | `Settings\ToggleFloatingWindowProfileSettings.cs` | |
| A3 | `Controls\ToggleFloatingWindowProfileSettingsControl.cs:12` | `Controls\ToggleFloatingWindowProfileSettingsControl.cs` | D6 适配 |
| A4 | `Settings\SwitchFloatingWindowThemeSettings.cs:8` | `Settings\SwitchFloatingWindowThemeSettings.cs` | |
| A4 | `Controls\SwitchFloatingWindowThemeSettingsControl.cs:10` | `Controls\SwitchFloatingWindowThemeSettingsControl.cs` | |
| A5 | `Settings\BackgroundPlayAudioSettings.cs:5` | `Settings\BackgroundPlayAudioSettings.cs` | |
| A5 | `Controls\BackgroundPlayAudioSettingsControl.cs:12` | `Controls\BackgroundPlayAudioSettingsControl.cs` | D9-2（`:149` 守卫分支保留） |
| A6 | `Settings\ActionFlowExecutionConfirmationSettings.cs:5` | `Settings\ActionFlowExecutionConfirmationSettings.cs` | |
| A6 | `Controls\ActionFlowExecutionConfirmationSettingsControl.cs:8` | `Controls\ActionFlowExecutionConfirmationSettingsControl.cs` | |
| A7 | `Settings\TriggerCustomTriggerSettings.cs:5` | `Settings\TriggerCustomTriggerSettings.cs` | |
| A7 | `Controls\TriggerCustomTriggerSettingsControl.cs:8` | `Controls\TriggerCustomTriggerSettingsControl.cs` | |
| A8 | `Settings\ToggleWorkflowSettings.cs:8` | `Settings\ToggleWorkflowSettings.cs` | |
| A8 | `Controls\ToggleWorkflowSettingsControl.cs:16` | `Controls\ToggleWorkflowSettingsControl.cs` | |
| A9 | （源无附属：`ActionBase` 无设置类型/无控件） | — | |
| A10 | `Settings\FullscreenClockSettings.cs:5` | `Settings\FullscreenClockSettings.cs` | 空设置类（随源）；删除源自引用 using |
| A10 | `Controls\FullscreenClockSettingsControl.cs:8` | `Controls\FullscreenClockSettingsControl.cs` | D2 适配 |
| A11/A13/A14/A15 | `Settings\ShortcutKeyNotificationSettings.cs:5` | `Settings\ShortcutKeyNotificationSettings.cs` | **共享类型**（4 项行动共用；后续批次复用） |
| A11/A13/A14/A15 | `Controls\ShortcutKeyNotificationSettingsControl.cs:7` | `Controls\ShortcutKeyNotificationSettingsControl.cs` | **共享类型**（同上；源中亦被不迁移的 C 档行动使用） |
| A12 | `Settings\LoadTemporaryClassPlanSettings.cs:5` | `Settings\LoadTemporaryClassPlanSettings.cs` | |
| A12 | `Controls\LoadTemporaryClassPlanSettingsControl.cs:15` | `Controls\LoadTemporaryClassPlanSettingsControl.cs` | |

### 1.3 共享类型（p1-05 §2.3-2：首个需要者 = 本批，标注"共享，后续批次复用"）

| 源文件（源锚） | 新落点（命名空间 `SystemTools.CrossPlatform.ConfigHandlers` / `.Shared`） | 引入缘由 | 形态 |
| --- | --- | --- | --- |
| `ConfigHandlers\FloatingWindowProfile.cs:12` | `ConfigHandlers\FloatingWindowProfile.cs` | A3 所需（悬浮窗配置方案状态类型，尚书省派工预期） | 逐行随源，仅命名空间/依赖引用改写 |
| `ConfigHandlers\FloatingWindowProfileManager.cs:13` | `ConfigHandlers\FloatingWindowProfileManager.cs` | A3 所需（方案管理器，B11 阶段 2 将复用） | 唯一适配点 D8（存储根），其余逐行随源（含 `MigrateFromLegacyConfig`） |
| `ConfigHandlers\ButtonRulesetConfig.cs:10` | `ConfigHandlers\ButtonRulesetConfig.cs` | `FloatingWindowProfile` 依赖闭包 | 逐行随源 |
| `ConfigHandlers\RowRulesetConfig.cs:10` | `ConfigHandlers\RowRulesetConfig.cs` | `FloatingWindowProfile` 依赖闭包 | 逐行随源 |
| `ConfigHandlers\MainConfigData.cs:11` | `ConfigHandlers\MainConfigData.cs` | A3/A4/A6 所需（§2.3-4 聚合配置根） | **A 档成员裁剪形**（见下） |
| `ConfigHandlers\MainConfigHandler.cs:9` | `ConfigHandlers\MainConfigHandler.cs` | A4/A6 所需（配置句柄 + GlobalConstants 接线） | 逐行随源 |
| `Shared\GlobalConstants.cs:8` | `Shared\GlobalConstants.cs` | A4/A6 所需（配置根句柄/目录常量） | **A 档成员裁剪形**（见下） |

**MainConfigData 裁剪口径**（p1-05 §2.3-4"仅当 A 档功能确需时引入，内嵌选项只允许 A 档成员"）：
- 引入成员：`FloatingWindowTheme`（A4）、`CurrentFloatingWindowProfile`（A3）、`ActionFlowExecutionConfirmation/Delay PositionX/Y` 4 个可空 int（A6 对话框位置记忆）、`FloatingWindowHorizontal/ButtonOrder/ButtonRows/ButtonRulesets/RowRulesets` 5 个悬浮窗布局成员（`FloatingWindowProfileManager.MigrateFromLegacyConfig` 编译闭包，"不改写其行为"要求）、`EnabledActions/EnabledTriggers/EnabledComponents/EnabledRules` 4 个功能开闭字典 + `Is*Enabled` 辅助方法（阶段 1 注册面先例 `RegisterActionIfEnabled` 的配置面，供礼部 p1-06 复用）。
- 未引入：全部 B/C 选项成员（LiquidGlass*、人脸/Hello、语音、USB、内存清理、AI 链配置、悬浮窗外观细节等，源文件 784 行中其余成员）——阶段 2/3 按需增补；`RestartPropertyChanged` 事件随其消费成员一并延后。
- JSON 属性名与源同名成员逐字一致（配置文件格式兼容语义）。
- **落点待决登记（§2.3-3）→ 已裁决**：MainConfigData 为跨批共享聚合根，p1-04（AI 链配置成员）等后续批次需增补成员时，建议由尚书省明确"共享配置根成员增补"的归属流程（本批已按需引入最小闭包；p1-04 本轮未改本文件）。**尚书省结案裁决（p1-03 确认函第 2 条）**：共享配置根成员增补流程定为——①需求批在交付证据登记增补需求（成员清单+A 档依据+源锚点）；②经尚书省调度确认后由需求批直接增补、文件内留痕注释、双方证据互相注记；③阶段 1 收口后共享类型维护权随当期派工归属。据此追认 p1-04 对 GlobalConstants 的 PluginVersion/ShowChangelogOnOpen 增补有效（与本批上文复核结论一致）。
- **GlobalConstants 裁剪口径**：引入 `PluginConfigFolder`、`MainConfig`、`Information.PluginFolder`（本批 A3/A4/A6 闭包）；p1-04 已按需增补 `Information.PluginVersion`、`ShowChangelogOnOpen`（文件内留痕注释），形态一致无冲突。

---

## 2. 降级/隔离处置逐项记录（系统命令/进程启动类 + 适配记录）

| # | 位置 | 源实现 | 处置 | 依据/说明 |
| --- | --- | --- | --- | --- |
| D1 | A10 `FullscreenClockAction`（源 `:24-30` `Process.Start(UseShellExecute=true)` 打开 URL） | 进程启动 + Shell 语义 | **跨平台替代（已批降级口径）**：改经宿主 `ILauncherService.LaunchUrl(ClockUrl)`（p0-01 §3 #4，三平台全平台注册）；获取失败时与源失败路径一致（记日志、抛行动错误） | p0-03 §3.1 A10（"建议改 ILauncherService.LaunchUrl，02 §2.5"）+ 04-spec 已批口径 |
| D2 | A10 附属 `FullscreenClockSettingsControl`（源 `:38-43` `Process.Start` 打开仓库 URL） | 同上 | **跨平台替代（同 D1 口径）**：`ILauncherService.LaunchUrl`；获取/打开失败仅静默（不阻断设置界面，源为无异常处理路径的等价弱化） | 同 D1 |
| D3 | A1 附属 `KillProcessSettingsControl.ShowProcessList`（源 `:99-113` 启动 `tasklist /fo table /nh` 命令行进程） | Windows 专属命令行工具 | **跨平台替代**：BCL `Process.GetProcesses()` 枚举（进程名 + PID 定宽文本列表），沿用源"查看正在运行的进程"窗口/复制/失败弹窗 UI 与错误提示文案（"获取进程列表失败"）；源 tasklist 输出中的桌面会话/内存列不迁移（Windows 专属字段） | S4.2 无 tasklist 字面条款，但属 Windows 专属进程启动 → 按 04-spec 已批"跨平台替代"口径处理并留痕；同时满足 macOS 硬约束 |
| D4 | A1 `KillProcessAction`（源 `:61-85` 注释死代码块） | 注释掉的 taskkill 进程启动实现 | **删除**（不迁入）：Windows 专属工具死代码注释，随"注释从严清理"口径移除；不影响活动代码行为 | p1-05 §5.2-2；源文件未编译注释块（p0-03 口径同 ClickSimulation 死代码处理精神） |
| D5 | A3 `ToggleFloatingWindowProfileAction`（源 `:29/:41/:51` 经 `FloatingWindowService`） | 服务面切换方案 | **阶段 1 架构适配**：改以本批共享类型 `FloatingWindowProfileManager`（保存当前方案→加载目标方案→更新 `CurrentFloatingWindowProfile`→落盘）+ `GlobalConstants.MainConfig` 执行等价状态迁移，恢复快照/`OnRevert` 语义逐行保留；窗口刷新路径（`Dispatcher.UIThread.Post`）随悬浮窗服务（阶段 2 B11）交付后恢复——该服务为 B 档交付物，阶段 1 不存在 | 派工预期"A3/A4 以 FloatingWindowProfile/Manager 为共享类型引入"；p1-05 §2.3-2；阶段 2 可回归服务调用面 |
| D6 | A3 附属 `ToggleFloatingWindowProfileSettingsControl.LoadProfiles`（源 `:58` 经 `FloatingWindowService().ProfileManager`） | 服务面取方案列表 | **同 D5**：`IAppHost.GetService<FloatingWindowProfileManager>()` 直取 `GetProfileNames()`，列表行为与源一致 | 同 D5 |
| D7 | A4 `SwitchFloatingWindowThemeAction`（源 `:27/:37/:47` 经 `FloatingWindowService.SetWindowTheme/ToggleWindowTheme`） | 服务面设置主题 | **阶段 1 架构适配**：以 `GlobalConstants.MainConfig` 配置状态面执行等价设置（取值归一化 0-3 语义与源服务实现逐行一致，含"相同值跳过"），`OnRevert` 快照语义保留；窗口刷新随阶段 2 B11 恢复 | 同 D5 |
| D8 | 共享类型 `FloatingWindowProfileManager` 构造器（源 `:30` `DependencyPaths.GetDependencyRoot()` = 跨插件共享 `Cache\SystemTools` 目录） | 方案存储根 | **存储根适配（唯一改写点，逐行其余随源）**：改为本插件独立配置目录 `GlobalConstants.PluginConfigFolder\FloatingWindowProfiles`（未初始化时显式抛错，对应源 `GetDependencyRoot` 的空参守卫语义） | 04-spec S7/R5 双插件独立配置决议：源存储根为跨插件共享缓存目录，同装时与源插件方案文件冲突（同名 `Default.json` 等），违反独立配置；`DependencyPaths` 其余成员（语音/人脸/原生依赖解析）属 C 档服务域且含 S4.2 禁用符号，不迁入——故本批不引入该类型 |
| D9 | A5 `BackgroundPlayAudioAction.cs:89`（源）与 `BackgroundPlayAudioSettingsControl.cs:149`（源）的 `OperatingSystem.IsWindows()` 守卫分支 | Windows 盘符 URI 形态归一化 | **原样保留**（非隔离新增、非分叉）：04-spec §S4.2 明示该守卫分支"可原样保留或删除，不影响分档" | 04-spec §S4.2 允许项；macOS/Linux 分支不执行，语义写实见 §5 |
| D10 | A1 附属 `KillProcessSettingsControl.cs`（p1-10 构建复验 CS1061，:178,42；工部日志 p1-10-build-fallback-win-rerun.log:87/140） | 源适配时误删 `using Avalonia.Input.Platform;`（源文件 :9 原有）；Avalonia 12.1.1 中 `IClipboard` 接口已不含 `SetTextAsync`（接口仅 `ClearAsync/SetDataAsync/FlushAsync/TryGetDataAsync/TryGetInProcessDataAsync`，经 12.1.1 ref 程序集反射核实），字符串便捷方法移为 `Avalonia.Input.Platform.ClipboardExtensions.SetTextAsync(this IClipboard, string)` 扩展方法，需该 using 才能解析 | **恢复 `using Avalonia.Input.Platform;`（一行，最小改动）**：与宿主权威用例形态一致（宿主 3 处 `Clipboard?.SetTextAsync` 均带该 using，如 `ClassIsland\Views\AppLogsWindow.axaml.cs:9,108`）；剪贴板写入语义与用户能力零变化 | 目标框架 API 面差异（Avalonia 11→12 接口方法→扩展方法），非行为改写；同型消费点核查：p1-02 `ProcessRunningRuleSettingsControl.cs:9,148` 与 p1-04 `Views\AiChatFloatingWindow.axaml.cs:10,321` 均自带该 using、无同类缺陷（树内仅本批此一处） |

统计：系统命令/进程启动类降级/替代 **3 项**（D1/D2/D3）+ 死代码注释清理 **1 项**（D4）+ 阶段 1 架构适配 **3 项**（D5/D6/D7）+ 共享类型存储根适配 **1 项**（D8）+ 守卫分支保留声明 **2 处**（D9）+ 目标框架 API 面适配 **1 项**（D10，p1-10 修复轮）。无任何 Windows-only 调用直接混入共享路径；无 `#if Platforms_*` 分叉（p1-05 §5.1-2 阶段 1 零平台分叉）。

---

## 3. p1-05 §4.2 结构化注册清单（兵部批 → 礼部 p1-06）

**说明**：15 个 ActionInfo ID 均为字符串前缀形态，本批交付文件中**无 GUID 形态注册身份**（无 NotificationProviderInfo/NotificationChannelInfo 等），尚书省"新 GUID 零重合"规则不触发、无映射留痕需求；提醒路径依赖的提供方 GUID 由 p1-04 承载（其新 GUID `44BB7B21-9831-4446-B3B6-3A4D7D1BE402`，与源 `7E9A3D5C-…` 零重合，已核）。

| 项 | 类型全名 | 功能 ID | 注册目标 | 设置类型全名 | 提醒路径依赖 | 源锚点（p0-03 §3.1） |
| --- | --- | --- | --- | --- | --- | --- |
| A1 | SystemTools.CrossPlatform.Actions.KillProcessAction | SystemTools.CrossPlatform.KillProcess | ActionInfo + 设置控件 KillProcessSettingsControl | SystemTools.CrossPlatform.Settings.KillProcessSettings | 是（p1-04） | A1 / KillProcessAction.cs:15 |
| A2 | SystemTools.CrossPlatform.Actions.ShowToastAction | SystemTools.CrossPlatform.ShowToast | ActionInfo + 设置控件 ShowToastSettingsControl | SystemTools.CrossPlatform.Settings.ShowToastSettings | 无 | A2 / ShowToastAction.cs:11 |
| A3 | SystemTools.CrossPlatform.Actions.ToggleFloatingWindowProfileAction | SystemTools.CrossPlatform.ToggleFloatingWindowProfile | ActionInfo + 设置控件 ToggleFloatingWindowProfileSettingsControl | SystemTools.CrossPlatform.Settings.ToggleFloatingWindowProfileSettings | 是（p1-04） | A3 / ToggleFloatingWindowProfileAction.cs:17 |
| A4 | SystemTools.CrossPlatform.Actions.SwitchFloatingWindowThemeAction | SystemTools.CrossPlatform.SwitchFloatingWindowTheme | ActionInfo + 设置控件 SwitchFloatingWindowThemeSettingsControl | SystemTools.CrossPlatform.Settings.SwitchFloatingWindowThemeSettings | 是（p1-04） | A4 / SwitchFloatingWindowThemeAction.cs:15 |
| A5 | SystemTools.CrossPlatform.Actions.BackgroundPlayAudioAction | SystemTools.CrossPlatform.BackgroundPlayAudio | ActionInfo + 设置控件 BackgroundPlayAudioSettingsControl | SystemTools.CrossPlatform.Settings.BackgroundPlayAudioSettings | 无 | A5 / BackgroundPlayAudioAction.cs:15 |
| A6 | SystemTools.CrossPlatform.Actions.ActionFlowExecutionConfirmationAction | SystemTools.CrossPlatform.ActionFlowExecutionConfirmation | ActionInfo + 设置控件 ActionFlowExecutionConfirmationSettingsControl | SystemTools.CrossPlatform.Settings.ActionFlowExecutionConfirmationSettings | 无 | A6 / ActionFlowExecutionConfirmationAction.cs:18 |
| A7 | SystemTools.CrossPlatform.Actions.TriggerCustomTriggerAction | SystemTools.CrossPlatform.TriggerCustomTrigger | ActionInfo + 设置控件 TriggerCustomTriggerSettingsControl | SystemTools.CrossPlatform.Settings.TriggerCustomTriggerSettings | 无 | A7 / TriggerCustomTriggerAction.cs:13 |
| A8 | SystemTools.CrossPlatform.Actions.ToggleWorkflowAction | SystemTools.CrossPlatform.ToggleWorkflow | ActionInfo + 设置控件 ToggleWorkflowSettingsControl | SystemTools.CrossPlatform.Settings.ToggleWorkflowSettings | 无 | A8 / ToggleWorkflowAction.cs:15 |
| A9 | SystemTools.CrossPlatform.Actions.ShowAiChatDialogAction | SystemTools.CrossPlatform.ShowAiChatDialog | ActionInfo（无设置控件） | 无（ActionBase 无设置泛型） | 无 | A9 / ShowAiChatDialogAction.cs:9 |
| A10 | SystemTools.CrossPlatform.Actions.FullscreenClockAction | SystemTools.CrossPlatform.FullscreenClock | ActionInfo + 设置控件 FullscreenClockSettingsControl | SystemTools.CrossPlatform.Settings.FullscreenClockSettings（随控件；行动本体无设置泛型，对齐源 Plugin.cs:427 配对先例） | 无 | A10 / FullscreenClockAction.cs:10 |
| A11 | SystemTools.CrossPlatform.Actions.ClearAllNotificationsAction | SystemTools.CrossPlatform.ClearAllNotifications | ActionInfo + 设置控件 ShortcutKeyNotificationSettingsControl（共享） | SystemTools.CrossPlatform.Settings.ShortcutKeyNotificationSettings（共享） | 是（p1-04） | A11 / ClearAllNotificationsAction.cs:14 |
| A12 | SystemTools.CrossPlatform.Actions.LoadTemporaryClassPlanAction | SystemTools.CrossPlatform.LoadTemporaryClassPlan | ActionInfo + 设置控件 LoadTemporaryClassPlanSettingsControl | SystemTools.CrossPlatform.Settings.LoadTemporaryClassPlanSettings | 是（p1-04） | A12 / LoadTemporaryClassPlanAction.cs:15 |
| A13 | SystemTools.CrossPlatform.Actions.OpenAppSettingsAction | SystemTools.CrossPlatform.OpenAppSettings | ActionInfo + 设置控件 ShortcutKeyNotificationSettingsControl（共享） | SystemTools.CrossPlatform.Settings.ShortcutKeyNotificationSettings（共享） | 是（p1-04） | A13 / OpenAppSettingsAction.cs:14 |
| A14 | SystemTools.CrossPlatform.Actions.OpenProfileEditorAction | SystemTools.CrossPlatform.OpenProfileEditor | ActionInfo + 设置控件 ShortcutKeyNotificationSettingsControl（共享） | SystemTools.CrossPlatform.Settings.ShortcutKeyNotificationSettings（共享） | 是（p1-04） | A14 / OpenProfileEditorAction.cs:14 |
| A15 | SystemTools.CrossPlatform.Actions.OpenClassSwapWindowAction | SystemTools.CrossPlatform.OpenClassSwapWindow | ActionInfo + 设置控件 ShortcutKeyNotificationSettingsControl（共享） | SystemTools.CrossPlatform.Settings.ShortcutKeyNotificationSettings（共享） | 是（p1-04） | A15 / OpenClassSwapWindowAction.cs:14 |

### 3.1 DI/初始化接线需求（供 p1-06 注册面落实；源先例 Plugin.cs）

| 需求 | 源先例 | 说明 |
| --- | --- | --- |
| `GlobalConstants.PluginConfigFolder` / `Information.PluginFolder` / `Information.PluginVersion` 赋值 | 源 Plugin.cs:67-68 | 插件初始化期赋值（PluginVersion 为 p1-04 增补成员） |
| `GlobalConstants.MainConfig = new MainConfigHandler(PluginConfigFolder)` + `services.AddSingleton(GlobalConstants.MainConfig)` | 源 Plugin.cs:70/:111 | 配置根构造与 DI 注册（构造期自挂 `GlobalConstants.MainConfig`，逐行随源） |
| `services.AddSingleton<FloatingWindowProfileManager>()` | 源 Plugin.cs:114 | A3 行动/控件消费 |
| `MigrateFromLegacyConfig` 调用 | 源 Plugin.cs:207 | 属阶段 2 B11 接线路径，阶段 1 不需要调用 |
| 行动设置控件按行动 ID keyed 注册 | 源 RegisterActionIfEnabled 先例；SDK `ActionSettingsControlBase.GetInstance` 经 `GetKeyedService<ActionSettingsControlBase>(actionItem.Id)` 解析 | 上表"设置控件"配对需以行动 ID 为 key 注册 |
| `SystemToolsNotificationProvider` / `AiChatWindowService` 等 AI 链注册 | 源 Plugin.cs:141-149/:137 | **p1-04 注册清单承载**（尚书省已确认调度），本批 8 项行动仅消费其公共方法 |
| auto.json 对端 | 源 TriggerCustomTrigger ↔ ActionInProgressTrigger | A7 写 `auto.json`（程序集目录），p1-02 触发器为读方 |

---

## 4. macOS 兼容自检表（p1-05 §5.3 五列格式；覆盖本批全部新文件外部依赖点）

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `ShowToastAction.cs:31` | `PlatformServices.DesktopToastService.ShowToastAsync` | 宿主抽象（保留，p0-01 §3 #3） | 可用（macOS DesktopToastService 实装） |
| 2 | `BackgroundPlayAudioAction.cs:41` | `IAudioService.PlayAudioAsync`（ClassIsland SDK 服务） | SDK 服务抽象（保留） | 可用（宿主三平台提供的服务接口，平台无关） |
| 3 | `BackgroundPlayAudioAction.cs:89` | `OperatingSystem.IsWindows()` 守卫分支 | 保留（04-spec §S4.2 允许项） | 可用（macOS 分支不执行；仅影响 Windows 盘符 URI 归一化） |
| 4 | `BackgroundPlayAudioSettingsControl.cs:149`（源） | 同上 | 同上 | 同上 |
| 5 | `ActionFlowExecutionConfirmationAction.cs:8,99,32-33` | FluentAvalonia `FATaskDialog`/`FAFontIconSource` | 跨平台 UI 库（保留） | 可用（Avalonia/FluentAvalonia 三平台） |
| 6 | `ActionFlowExecutionConfirmationAction.cs:267,344,363,377` | `GlobalConstants.MainConfig`（共享配置根，本批引入） | 共享类型引入（BCL 文件 IO） | 可用（配置写本插件独立目录） |
| 7 | `FullscreenClockAction.cs:30`（源 `Process.Start` 打开 URL） | 进程启动 + Shell 语义 | 按已批降级口径：宿主 `ILauncherService.LaunchUrl`（p0-01 §3 #4） | 可用（三平台实装，全平台注册） |
| 8 | `FullscreenClockSettingsControl.cs:38`（源） | 同上 | 同 D1 口径 | 可用（失败仅静默，不阻断设置界面） |
| 9 | `KillProcessSettingsControl.cs:99-113`（源 tasklist 命令行） | Windows 专属命令行进程 | 跨平台替代：BCL `Process.GetProcesses()`（D3） | 可用（BCL 进程枚举三平台） |
| 10 | `KillProcessAction.cs:41,52` | `Process.GetProcessesByName` / `.Kill` | BCL（保留） | 可用（BCL 跨平台；对无权限进程按源逻辑记日志继续；`.exe` 后缀剥离仅影响 Windows 风格输入，其余平台为无操作后缀） |
| 11 | `ToggleFloatingWindowProfileAction.cs:29,41,51`（源经 FloatingWindowService） | 悬浮窗服务面（阶段 2 B11 交付物） | 阶段 1 适配：`FloatingWindowProfileManager`（共享类型）+ MainConfig 状态面（D5） | 可用（纯 BCL 文件 IO + 配置状态，无平台 API） |
| 12 | `ToggleFloatingWindowProfileSettingsControl.cs:58`（源） | 同上 | 同 D5/D6 | 可用（同上） |
| 13 | `SwitchFloatingWindowThemeAction.cs:27,37,47`（源） | 同上 | 阶段 1 适配：MainConfig 状态面（D7） | 可用（主题值 3 为配置状态；背景采样渲染按 U5 不迁） |
| 14 | `FloatingWindowProfileManager.cs:30`（源 DependencyPaths 共享缓存根） | 跨插件共享 `Cache\SystemTools` 目录 | 存储根适配：本插件独立配置目录（D8） | 可用（独立目录，BCL IO；不与源插件同装冲突） |
| 15 | `ClearAllNotificationsAction.cs:23-33` | 反射调用 `INotificationHostService.CancelAllNotifications`（SDK internal 成员，宿主实例） | 保留源实现（02 §2.5 观察点） | 可用（宿主服务反射调用，平台无关；该方法为 internal 的事实与源一致） |
| 16 | A1/A3/A4/A11/A12/A13/A14/A15 NotifyOnExecute 8 处调用点 | `SystemToolsNotificationProvider.ShowNotification`（`NotificationProviderBase` 公共方法，SDK 唯一公共通知入口） | 跨批依赖（p1-04 交付，新 GUID 零重合） | 可用（提醒为宿主 Avalonia UI 层，三平台渲染） |
| 17 | `ShowAiChatDialogAction.cs:10-17` | `AiChatWindowService.ShowAsync`（p1-04 交付） | 跨批依赖 | 可用（Avalonia 浮窗三平台；R-6 自适应背景采样不迁，U5） |
| 18 | `KillProcessSettingsControl.cs:53`（源） | `"Segoe Fluent Icons,Segoe MDL2 Assets"` 字体引用 | 保留源文案 | 降级（写实）：macOS 无该字体时警告字形回退为默认字形/缺字框，仅视觉提示，不影响功能 |
| 19 | 本批 ConfigHandlers/Settings/Controls 全部文件 | ClassIsland SDK（`ActionSettingsControlBase`/`ActionBase`/`IAppHost`/`ConfigureFileHelper`/`Ruleset`/`NotificationRequest`/`IAudioService`/`IProfileService`/`IExactTimeService`/`IUriNavigationService`/`IAutomationService`/`IActionService` 等） | SDK（保留） | 可用（U3 基线 net10.0 类库接口，无平台 API） |
| 20 | `FloatingWindowProfile`/`ButtonRulesetConfig`/`RowRulesetConfig` | CommunityToolkit.Mvvm 8.2.1（经宿主 Shared/Core 链传递可达） | 依赖保留 | 可用（纯托管库） |
| 21 | 其余 | BCL 纯 .NET API（IO/JSON/LINQ/Threading/Process/Reflection 等） | BCL | 可用（按 p1-05 §5.3 规则不逐项列） |

**结论：21 项依赖点中 0 项"不适用"**（无阻塞项，无需触发 S6 分档复核）；宿主抽象引用与 p0-01 §3 接口清单一致（`IDesktopToastService`/`ILauncherService`），未发明新接口；缺口 G1–G3（`ISystemEventsService`/`IDesktopService`）本批无消费点。

---

## 5. S4.2 扫描自检（p1-05 §5.2）

- 输出留档：`.tang/cases/stcp-cross-platform-001/evidence/p1-03-s42-scan-output.txt`（原始输出，含每段 VERDICT 与执行说明）。
- 执行方式：在单一 pwsh 进程内以 `&` 直接调用 p0-07-s42-scan.ps1，对 5 个交付落点分别 `-Scope Source` 扫描（嵌套 pwsh 子进程受沙箱命名管道边界限制，属宿主文档化边界；PowerShell 自身重定向捕获，扫描逻辑与判定语义不变）。
- 结果：**5/5 落点 `VERDICT: PASS (zero gate hits)`，每次调用进程 exit=0，GateHits=0，InfoHits=0**（Actions 15 文件 / Controls 26 / Settings 12 / ConfigHandlers 6 / Shared 1；Controls/Settings 计数含并行批次同时已落盘文件，本批 44 文件全部在其中且零命中）。
- 补充段：对 `src\SystemTools.CrossPlatform` 全树现状（含并行批次 p1-01/p1-02/p1-04 文件）复跑同命令，`VERDICT: PASS`、GateHits=0——为本批与相邻批文件共存状态的即时交叉佐证（阶段 1 收口全量复跑仍归礼部 p1-06，§5.2-4）。
- 注释清理核对：本批 .cs 注释零禁用符号（含从源带注释抽取的文件，D4 已清理 taskkill 死代码注释块）。
- **p1-10 修复轮复跑**（D10 之后）：①`KillProcessSettingsControl.cs` 单文件直扫 `VERDICT: PASS`（GateHits=0，exit=0）；②`Controls\` 目录重放 `VERDICT: PASS`（GateHits=0，exit=0）。两段真实输出已追加至 p1-03-s42-scan-output.txt 尾部"p1-10 修复后复跑段"。

### 5.1 批内补充编译自检 v2（p1-10 修复轮，方法先例 p1-02-supplementary-compile-check.ps1）

- 脚本/输出：`evidence\p1-03-supplementary-compile-check.ps1` / `evidence\p1-03-supplementary-compile-check-output.txt`（非官方构建门禁；官方三平台 dotnet build 仍属阶段级验证，p1-05 §5.2-3）。
- 语境等效性（三项升级）：①引用集 323 个直接提取自工部 `p1-10-build-fallback-win-rerun.log` 的 csc `/reference:` token（与报错构建完全相同，含 `avalonia\12.1.1\ref` 链，逐一路径核在）；②预处理符号取自同日志 `/define:` 集（`Platforms_Windows` 等 24 项）；③检查专用存根 3 棵（非交付文件）：隐式全局 using（SDK 隐式集 7 项）、跨批依赖消费面存根（`SystemToolsNotificationProvider` 继承真实 SDK `NotificationProviderBase`；`AiChatWindowService.ShowAsync` 签名对照 p1-04 真实交付 :21）、MVVM 生成成员存根（本检查无 CommunityToolkit.Mvvm 8.2.1 源生成器管线，按生成器命名映射补齐 `[ObservableProperty]` 等价属性——先例同 p1-02 的 InitializeComponent 存根）。
- 结果：**COMPILE OK（error=0, warning=112）**——44 个交付 .cs 语义级编译通过；112 个警告全部为 CS1701/CS1702 程序集统一化噪声（真实构建经 /nowarn:1701,1702 抑制），本批零实质警告。批内无第二个 Avalonia 12.1.1 API 面错误（与工部"csc 单遍报全部错误、本轮仅此一处"的判断一致）。
- 过程留痕（检查方法失真，非交付代码缺陷）：第一轮 8 个错误均为 MVVM 生成属性缺失（FloatingWindowProfileManager.cs 消费 `Name/FloatingWindowHorizontal`）——反证：真实构建 p1-10 rerun csc 单遍仅报 D10 一处错误，证明真实构建中生成器已产出上述成员；补生成成员存根后归零。存根拆分修复一次 CS8954（单文件多 file-scoped namespace，同 p1-02 v1 教训）。

## 6. 结构自检记录（p1-05 §8 复核指引重放）

1. 落点核对：本批 44 文件逐一落入 §2.2 归属表允许落点（Actions\、Controls\ 平铺、Settings\、ConfigHandlers\、Shared\）；未创建禁止目录（VoskWorker\、ThirdParty\、平台子目录）；零 .bat/.ps1/.exe/原生资产。
2. 命名空间核对：全部新 .cs `namespace` 以 `SystemTools.CrossPlatform.` 开头且镜像目录（Select-String 重放零命中；唯一例外形态为工程根 Plugin.cs 的根命名空间，属既有脚手架正确形态，非本批文件）。
3. ID 前缀核对：`Select-String -Pattern '"SystemTools\.'` 对 Actions\*.cs 命中 15 行，全部为 `SystemTools.CrossPlatform.*` 形态（§3 表）；源插件 ID 字符串零出现。
4. 禁用 using 核对：`using\s+SystemTools\.(?!CrossPlatform)` 全树零命中；本批 using 面仅 ClassIsland.*、Avalonia.*、FluentAvalonia.*、Microsoft.Extensions.*、BCL 与本插件 `SystemTools.CrossPlatform.*`。
5. 文件名随源核对：15 个行动文件 + 22 个附属文件 + 7 个共享类型文件名与源逐一相同（含"一文件一主类型"；阶段 1 零新造文件名——全部为源同名文件的直接落位，无命名备案需求）。

## 7. 跨批依赖与交接项汇总

| # | 事项 | 状态 |
| --- | --- | --- |
| 1 | 提醒路径 `SystemToolsNotificationProvider`（A1/A3/A4/A11–A15 共 8 项） | 跨批依赖成立；尚书省已调度归 p1-04（新 GUID 零重合），**该文件已由 p1-04 落盘**（命名空间/类名/基类已核，`Services\SystemToolsNotificationProvider.cs:7,9,12`），本批按现形态引用 |
| 2 | A9 → `AiChatWindowService`（p1-04） | 已落盘（`Services\AiChatWindowService.cs`），命名空间 `SystemTools.CrossPlatform.Services` |
| 3 | DI/初始化接线（§3.1 表） | 待礼部 p1-06 在唯一注册面落实 |
| 4 | MainConfigData/GlobalConstants 后续批次成员增补流程 | **已裁决**（尚书省 p1-03 确认函第 2 条，流程见 §1.3 注记；p1-04 增补被追认有效） |
| 5 | D5–D7 窗口刷新路径回归 | 阶段 2 B11（悬浮窗服务）交付后，A3/A4 可回归服务调用面（共享 manager/config 复用） |

## 8. 边界声明

- 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读（只读列举/检索/读取；ShortcutKeyNotificationSettingsControl.cs 源文件非 UTF-8，按 GB18030 只读解码读取）。
- 本任务写入仅限本批落点（`src\SystemTools.CrossPlatform\{Actions,Controls,Settings,ConfigHandlers,Shared}` 下 44 个新文件，其中 p1-10 修复轮仅触碰 `Controls\KillProcessSettingsControl.cs` 一行 using）+ 本案 evidence\（本文件、p1-03-s42-scan-output.txt、p1-03-supplementary-compile-check.ps1/.txt）；未改 `Plugin.cs`、`manifest.yml`、csproj、global.json、slnx 及任何并行批次文件（`Shared\GlobalConstants.cs` 的 p1-04 增补为对方批次留痕写入，本批复核确认无冲突）。
- 本文件不推进、不审批全局工作流；属批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验。
