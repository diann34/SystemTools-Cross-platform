# p2-05 证据：阶段 2 B 档落点核对与共享类型增补清单（吏部 repository-governance / analysis，先于实施）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-05 · 吏部 personnel · repository-governance / analysis（先于兵部三批实施） |
| 权威输入 | p0-03 §3.2 B 清单（B1–B14 行动 + 1 触发器 + 4 服务 = 19 项，逐项 file:line）；06 B 档清单条目 34–49；p1-05 规范（含修订 R1：落点/命名/注册面/共享类型增补流程）；p1-03 §1.3 共享类型现状（FloatingWindowProfile/Manager、MainConfigData 裁剪形、GlobalConstants）；p1-10 §12.5 双分支 API 漂移约束；p1-01 §7.4/7.5 双分支核对方法；p1-06 §9 报备事项（§9-3/§9-4/§9-6）；04-spec §S4.2；05 合同阶段 2 行 |
| 本文件性质 | 阶段 2 落点核对表 + 共享增补预判（文档性产出）：供兵部 p2-01/p2-02/p2-03 遵照、供尚书省对 EmptyWorkingSet 处置裁决；不预写函数体、不改 04-spec/05/06 已批决议 |
| 写入范围 | 仅本证据文件；源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读；零产品文件改动 |
| 结论 | **succeeded** —— B19 各项落点唯一归属、兵部三批互斥零冲突（§1）；共享类型增补清单带源锚点（§2）；EmptyWorkingSet 合规预判含可行方案集 A/B/C/D（§3）；双分支 API 核对齐备、缺位项 4 个已标注"须护栏或上报"（§4）；p1-06 报备恢复点归属确认（§5） |

---

## 1. B19 落点核对（兵部三批互斥表）

### 1.1 文件存在性实测（只读源插件，逐文件 Test-Path 核实）

14 个行动主文件、全部附属（Settings/Controls/Views 对话框）、触发器三件套、4 个服务文件、SystemShutdownMonitor 与 SystemMotionPreferences 均**实测存在**（本任务执行时逐个核实，含 `Views\AdvancedShutdownDialog.axaml(+.cs)`、`Views\ExtendShutdownDialog.axaml(+.cs)`、`Services\SystemShutdownMonitor.cs`、`Views\SystemMotionPreferences.cs`）。B6–B10 中 CancelShutdown/LockScreen 共用共享控件 `ShortcutKeyNotificationSettingsControl`（源 Plugin.cs:378-379），ImmediateRestart/ImmediateShutdown/Sleep 无设置控件（源 Plugin.cs:380-382 无泛型对）。

### 1.2 兵部三批落点互斥表（19 项 + 非计数附属，逐项唯一归属）

**p2-01 电源族 7 + 内存 GC（8 项）**

| 项 | 功能名 | 行动主文件落点 | 附属文件落点 | 源锚点（p0-03/06） | 注册面/接线注记（源 Plugin.cs） |
| --- | --- | --- | --- | --- | --- |
| B4 | 计时关机 | `Actions\ShutdownAction.cs` | `Settings\ShutdownSettings.cs`、`Controls\ShutdownSettingsControl.cs` | ShutdownAction.cs:15（:32 shutdown、:43 SendKeys，06 条目 37） | :375 |
| B5 | 高级计时关机 | `Actions\AdvancedShutdownAction.cs` | `Settings\AdvancedShutdownSettings.cs`、`Controls\AdvancedShutdownSettingsControl.cs`、`Views\AdvancedShutdownDialog.axaml(.cs)`、`Views\ExtendShutdownDialog.axaml(.cs)` | AdvancedShutdownAction.cs:22（:33 对话框字段、:558 ExtendShutdownDialog，06 条目 38） | :376；对话框基类 MyWindow 双分支可用（§4） |
| B6 | 取消关机计划 | `Actions\CancelShutdownAction.cs` | 无（控件=共享 ShortcutKeyNotificationSettingsControl，随 p1-03 已交付，仅引用） | CancelShutdownAction.cs:14（:29-30 shutdown /a，06 条目 39） | :379 |
| B7 | 锁定屏幕 | `Actions\LockScreenAction.cs` | 无（控件=共享 ShortcutKeyNotificationSettingsControl） | LockScreenAction.cs:14（:29-30 rundll32，06 条目 40） | :378 |
| B8 | 立即重启 | `Actions\ImmediateRestartAction.cs` | 无 | ImmediateRestartAction.cs:12（:16-17 ntdll DllImport、:28 ExitWindowsEx，06 条目 41） | :380（无控件对） |
| B9 | 立即关机 | `Actions\ImmediateShutdownAction.cs` | 无 | ImmediateShutdownAction.cs:12（同 B8 形态，06 条目 42） | :381（无控件对） |
| B10 | 睡眠 | `Actions\SleepAction.cs` | 无 | SleepAction.cs:10（:23-24 powrprof，06 条目 43） | :382（无控件对） |
| 49 | ClassIsland 内存自动清理 | —（服务项） | `Services\ClassIslandMemoryAutoCleanupService.cs`（EmptyWorkingSet 合规预判见 §3） | ClassIslandMemoryAutoCleanupService.cs:13（:22-23 psapi DllImport、:96-99 守卫、:103-120 GC 链，06 条目 49） | :122 注册、:218 ApplyConfig()、:1045 Stop |

**p2-02 文件夹递归 3 + 零散行动 2 + 其服务 2（7 项）**

| 项 | 功能名 | 行动主文件落点 | 附属文件落点 | 源锚点 | 注册面/接线注记 |
| --- | --- | --- | --- | --- | --- |
| B1 | 复制（文件/文件夹） | `Actions\CopyAction.cs` | `Settings\CopySettings.cs`、`Controls\CopySettingsControl.cs` | CopyAction.cs:12（:96-109 robocopy 文件夹分支，06 条目 34） | :385 |
| B2 | 移动（文件/文件夹） | `Actions\MoveAction.cs` | `Settings\MoveSettings.cs`、`Controls\MoveSettingsControl.cs` | MoveAction.cs:12（:96-110 robocopy /move，06 条目 35） | :386 |
| B3 | 删除（文件/文件夹） | `Actions\DeleteAction.cs` | `Settings\DeleteSettings.cs`、`Controls\DeleteSettingsControl.cs` | DeleteAction.cs:12（:69-80 cmd rmdir，06 条目 36） | :387 |
| B13 | 自动切换 ClassIsland 主题 | `Actions\AutoSwitchClassIslandThemeAction.cs` | `Settings\AutoSwitchClassIslandThemeActionSettings.cs`、`Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs`（控件名含 Action 段，随源不改，p1-05 §3.4-1）、`Services\AdaptiveThemeSyncService.cs` | AutoSwitchClassIslandThemeAction.cs:14（:30-32 写配置+ApplyConfig，06 条目 47；服务 :44 读配置） | :431 / 服务 :119 注册、:215 Start、:1041 Stop |
| B14 | 遮挡文字时隐藏主界面 | `Actions\AutoHideMainWindowWhenOccludedAction.cs` | `Settings\AutoHideMainWindowWhenOccludedActionSettings.cs`、`Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs`、`Services\MainWindowTextOcclusionService.cs` | AutoHideMainWindowWhenOccludedAction.cs:14（:30-32，06 条目 48；服务 :102/:108 读配置） | :433 / 服务 :120 注册、:216 Start、:1043 Shutdown |

**p2-03 悬浮窗服务群 + SystemShutdownMonitor + 触发器（4 项 + 非计数附属）**

| 项 | 功能名 | 行动/触发器主文件落点 | 附属文件落点 | 源锚点 | 注册面/接线注记 |
| --- | --- | --- | --- | --- | --- |
| B11 | 显示悬浮窗 | `Actions\ShowFloatingWindowAction.cs` | `Settings\ShowFloatingWindowSettings.cs`、`Controls\ShowFloatingWindowSettingsControl.cs`、`Services\FloatingWindowService.cs`（单文件服务，窗口代码内创建无 axaml） | ShowFloatingWindowAction.cs:15（:16-21 注入服务，06 条目 44） | :416 / 服务 :115 注册、:212 Start、:1063 Stop、:1106 UpdateWindowState |
| B12 | 切换悬浮窗层级 | `Actions\ToggleFloatingWindowLayerAction.cs` | `Settings\ToggleFloatingWindowLayerSettings.cs`、`Controls\ToggleFloatingWindowLayerSettingsControl.cs` | ToggleFloatingWindowLayerAction.cs:18（:46-57 调服务，06 条目 45；服务侧 :450/:2180/:2274 消费层级配置） | :418 |
| B-触发 | 从悬浮窗触发 | `Triggers\FloatingWindowTrigger.cs` + `Config\FloatingWindowTriggerConfig.cs` + `Settings\FloatingWindowTriggerSettings.cs`（三件套随源先例） | 服务依赖同 B11 | FloatingWindowTrigger.cs:12-34/:46-62（06 条目 46） | :477-478 RegisterTriggerIfEnabled |
| （非计数附属 1） | SystemShutdownMonitor | — | `Services\SystemShutdownMonitor.cs`（源 :8 `NativeWindow` 子类；WinForms 面属 B 档「Windows 专属点」候选，非 Windows no-op 降级 = 04-spec S3-R4/G2 既定分支） | Plugin.cs:56/:125-127 注册与 Start | 消费面：Plugin.cs:1034-1035 IsSessionEnding → :1048 `AdvancedShutdownAction.CancelPlanOnAppStopping(bool)`（礼部 lifecycle 接线，p2-01 行动静态方法仅收 bool，与 p2-03 文件无编译耦合） |
| （非计数附属 2） | SystemMotionPreferences | — | `Views\SystemMotionPreferences.cs`（源 :27-31 user32 `SystemParametersInfo` DllImport + `OperatingSystem.IsWindows()` 守卫非 Windows 返回 false；04-spec §S4.2 已注记该守卫形态可保留） | FloatingWindowService.cs:1388 ShouldReduceMotion() 消费 | 随 B11 服务批交付；C 档消费方（AiVoiceConversationOverlayWindow/VoiceWaveformControl）不迁 |

### 1.3 零冲突声明

1. **逐文件唯一归属**：上表每个文件仅出现于一个批次；`Actions\`、`Controls\`、`Settings\`、`Services\`、`Views\` 均为共享容器目录，按 p1-05 §2.2 判定规则"文件随其功能项所属批次"归属，无同名/同文件跨批。
2. **与既有目录体系相容**：阶段 2 零新增目录类型——全部落点均落在 p1-05 §2.1 已建立目录（Actions/Controls/Settings/Services/Views/Triggers/Config）内；Triggers\Config 两目录由 p1-02 建立，p2-03 仅追加文件。预期零 csproj 接线需求（阶段 1 Views\AiChatFloatingWindow.axaml 无 csproj 改动且双分支构建通过的先例；若构建期出现例外，按 p1-05 §4.4-2 接线需求流程上报，批内不自改）。
3. **共享类型只引用不复制**：`ShortcutKeyNotificationSettings(+Control)`（p1-03 共享交付）、`SystemToolsNotificationProvider`（p1-04）、`FloatingWindowProfile/Manager`、`MainConfigData`、`GlobalConstants`（p1-03/p1-04/p1-06）均仅引用；`Ruleset`（SDK 类型，p1-02 已消费）供 FloatingWindowRuleset 成员使用，无需新引入。
4. **跨批依赖仅 1 处且无编译耦合**：SystemShutdownMonitor（p2-03 文件）的 B5 看门狗消费经礼部 lifecycle 接线传递 bool（Plugin.cs:1034-1035/:1048 先例），p2-01 与 p2-03 互不引用对方类型；p2-01/p2-02 各自注册清单按 p1-05 §4.2 格式交接礼部。
5. **p1-05 §2.2 阶段 1 批次行不构成永久独占**：`Views\` 阶段 1 归 p1-04 是阶段 1 派工事实；阶段 2 按 05 合同与本表归属，容器约定（§2.2 判定规则、§3 命名空间规则）逐字延续。
6. **B19 全集闭合**：14 行动（B1–B14）+ 1 触发器 + 4 服务（FloatingWindowService/AdaptiveThemeSyncService/MainWindowTextOcclusionService/ClassIslandMemoryAutoCleanupService）= 19 = p2-01(8) + p2-02(7) + p2-03(4)；SystemShutdownMonitor/SystemMotionPreferences 为非计数附属，不重复计入 B19。与 04-spec §S4.1、p0-03 §4.2 计数一致。

## 2. 共享类型增补清单（按 p1-05 §2.3-4 与 p1-03 确认函第 2 条增补流程）

> 流程：需求批在交付证据登记增补需求（成员清单 + B 档依据 + 源锚点）→ 尚书省调度确认 → 需求批直接增补、文件内留痕注释、双方证据互相注记。本节即"需求登记 + 预批建议"，消费批据此登记。

### 2.1 MainConfigData B 档成员增补（现裁剪形 269 行，源文件 784 行）

| # | 成员（源 MainConfigData.cs 锚点） | JSON 名（随源逐字） | 消费点（源锚点） | 消费批 | 预批建议 |
| --- | --- | --- | --- | --- | --- |
| 1 | `EnableFloatingWindowFeature` :54-65（默认 true） | enableFloatingWindowFeature | 悬浮窗行动菜单组门 源 Plugin.cs:671-677；编辑页注册门 源 :182-185（见 §5） | p2-03 增补；注册面消费=礼部 | **预批**（B11 门成员，§5 恢复归属） |
| 2 | `ShowFloatingWindow` :428-439（默认 true） | showFloatingWindow | FloatingWindowService :1198 | p2-03 | 预批 |
| 3 | `FloatingWindowScale` :466 / `FloatingWindowTextSize` :481 / `FloatingWindowIconSize` :496 / `FloatingWindowOpacity` :511 / `FloatingWindowShadowEnabled` :524-534 / `FloatingWindowDragHandleAlwaysVisible` :654-660 | 同名 camelCase | FloatingWindowService :624-633（PropertyChanged 响应面 + 经典外观） | p2-03 | 预批（B11 经典外观 R-3 保留面） |
| 4 | `FloatingWindowPositionX` :556 / `FloatingWindowPositionY` :563 | floatingWindowPositionX/Y | FloatingWindowService :2104-2124（位置记忆） | p2-03 | 预批 |
| 5 | `FloatingWindowLayer` :596-604 | floatingWindowLayer | ToggleFloatingWindowLayerAction :19-22 + FloatingWindowService :450/:2180/:2274 | p2-03 | 预批（B12 层级状态） |
| 6 | `FloatingWindowLayerRecheckMode` :611-619 | floatingWindowLayerRecheckMode | FloatingWindowService :2180/:2274（自动重检模式；R-3 降级口径下自动重检停用，成员建议仍随源引入保持配置兼容，运行时按已批降级不启用） | p2-03 | 预批（随降级口径注记） |
| 7 | `FloatingWindowRulesetEnabled` :637-647 / `FloatingWindowRuleset` :666 | floatingWindowRulesetEnabled / floatingWindowRuleset | FloatingWindowService（规则隐藏，:1198 `_rulesetHidingWindow` 联动；R-3 保留面"规则隐藏"） | p2-03 | 预批；`Ruleset` 为 SDK 类型零新引入 |
| 8 | `AutoSwitchClassIslandTheme` :116-124 | autoSwitchClassIslandTheme | AutoSwitchClassIslandThemeAction :30-32（写）+ AdaptiveThemeSyncService :44（读） | p2-02 | 预批 |
| 9 | `AutoHideMainWindowWhenOccluded` :233-241 | autoHideMainWindowWhenOccluded | AutoHideMainWindowWhenOccludedAction :30-32 + MainWindowTextOcclusionService :102/:108 | p2-02 | 预批 |
| 10 | `AutoCleanupClassIslandMemory` :190-198 | autoCleanupClassIslandMemory | ClassIslandMemoryAutoCleanupService :27（经 `GlobalConstants.MainConfig?.Data`） | p2-01 | 预批；注册顺序注记：ApplyConfig 调用须在 `GlobalConstants.MainConfig` 赋值之后（源 Plugin.cs:70 先例已由 p1-06 落实） |

**明确不增补（B 档零消费）**：`FloatingWindowAppearanceStyle` :709、`FloatingWindowLiquidGlass` :721、`FloatingWindowGlassButtonScaleDip` :741（U5/R-6 液态玻璃排除面）；`EnableExperimentalFeatures` :26、`EnableFfmpegFeatures` :41、`LyricifyLiteWarningDismissed` :72、`EnableFaceRecognition` :86、`EnableWindowsHello` :101、`AutoOpenUsbDriveOnInsert` :130、`AutoCleanupSystemMemory` :204、`SystemMemoryCleanupThresholdPercent` :218、AI 语音成员 :385-399（全部 C 档）。设置页绑定面其余 B/C 选项属阶段 3（05 合同），不随阶段 2 增补。

**决策注记（报尚书省）**：`RestartPropertyChanged` 事件——源 `EnableFloatingWindowFeature` :65 触发该事件；阶段 1 裁剪形无此事件，p1-06 §9-7 已立"开关切换后直接 RequestRestart()"等价口径先例。建议 p2-03 增补成员时**二选一并留痕**：①随源逐行引入事件（若有阶段 3 设置页重启提示消费）；②沿用 p1-06 §9-7 等价口径不引入事件。默认建议 ②（当前 B 档消费面为注册门，无事件消费方）。

### 2.2 GlobalConstants 增补面：**零增补**

B19 全部消费点仅需既有成员：`MainConfig`（现 :15，ClassIslandMemoryAutoCleanupService :27 经其读配置；FloatingWindowService 走 DI 注入 MainConfigHandler，源 :54/:133-138）、`PluginConfigFolder`、`Information.PluginFolder/PluginVersion`。源 GlobalConstants 其余成员（`HostInterfaces.PluginLogger`、`Assets.AsciiLogo`、公告注释）B19 零消费，不引入。若 p2 批次实施中发现新的常量需求，按 §2.1 同流程登记，不得私自增补。

### 2.3 FloatingWindowProfile / FloatingWindowProfileManager：**零增成员**

新插件 `ConfigHandlers\FloatingWindowProfileManager.cs` 已具备 B11 服务所需全部成员（本任务实测）：`MigrateFromLegacyConfig` :48、`CurrentProfile` :84、`CurrentProfileName` :86、`GetProfileNames` :100、`LoadProfile` :124、`SaveProfile` :151；`FloatingWindowProfile` 经 p1-03 逐行引入。B11 服务按 p1-05 §2.3-2 **引用不重复定义**；p1-03 D8 存储根适配（独立配置目录）在服务消费下继续有效。**接线注记**：`MigrateFromLegacyConfig` 调用属阶段 2 B11 接线路径（源 Plugin.cs:207 先例，p1-03 §3.1 预留）→ 由 p2-03 注册清单承载、礼部在 Plugin.cs 落实。p1-03 D5-D7 的 A3/A4 窗口刷新路径回归（p1-03 §7-5）随 B11 服务落地，由 p2-03 注册清单一并注记。

## 3. EmptyWorkingSet 合规预判（重点，供尚书省裁决）

### 3.1 源实现实测（只读源插件 `Services\ClassIslandMemoryAutoCleanupService.cs`，全 127 行）

- **:22-23** `[DllImport("psapi.dll", SetLastError = true)] private static extern bool EmptyWorkingSet(IntPtr hProcess);` —— **R13 命中**（S4.2-(8) DllImport，psapi 在禁用清单；R14 同族禁 LibraryImport）。
- **:20** `ThresholdBytes = 500MB`；**:103-110** `Process.GetCurrentProcess()` + `PrivateMemorySize64` 阈值测量（BCL，跨平台）；**:112-116** GC 链 `GC.GetTotalMemory(true)` → `GC.Collect(GC.MaxGeneration, GCCollectionMode.Aggressive, true)` + `GC.WaitForPendingFinalizers()` ×2（**BCL，跨平台**）；**:118** `_ = EmptyWorkingSet(process.Handle)`；**:120** LogInformation；**:122-125** catch-all LogDebug（周期 30s 重试，:79 PeriodicTimer）。
- **:96-99** 守卫为 `RuntimeInformation.IsOSPlatform(OSPlatform.Windows)`，**位于 GC 块之前** —— 即源实现非 Windows 上**整体不执行（含 GC）**。
- **事实校正（重要）**：02 v2 §3 表（02-draft-solution.md 行 134）"非 Windows 跳过 EmptyWorkingSet，仅 GC"与源码不符——源守卫先于 GC 块返回。若按 06 条目 49 替换目标"保留跨平台托管 GC 的低风险部分"，p2-01 须**调整守卫位置**（GC/测量移出 Windows 判断）实现"GC 三平台 + 工作集仅 Windows"，并留痕该与 02 表述的差异；此为实现决策面，不改变 06 已批口径。
- `ApplyConfig` :25-35 读 `AutoCleanupClassIslandMemory`；服务生命周期接线见 §1.2 p2-01 行。

### 3.2 S4.2 口径与平台语义基线

- 04-spec §S4.2 行 61：A 档不得出现禁用符号；**B 档仅允许在其「Windows 专属点」字段声明的位置出现**。行 77 实现期门禁：三平台 TFM 构建通过为最终证据。p1-05 §5.1-3：平台条件文件组织（`#if Platforms_*` / `*Windows.cs` 命名 + csproj 条件编译项）为**阶段 2 B 档结构面，"届时另立规范"**——本表列方案，规范建立归尚书省调度。
- `EmptyWorkingSet` 语义：修剪进程工作集（物理驻留统计），不归还私有内存；**macOS 无用户态等价 API**（无"清空工作集"系统调用；madvise/malloc-zone 语义不同），**Linux 无直接等价**（`madvise(MADV_PAGEOUT)` 需内核 5.4+ 且语义不同）。06 条目 49"Linux/macOS 默认不执行等价强制工作集清理"与平台现实一致。

### 3.3 可行处置方案集（按 p1-10 §12.5 双分支约束 + S4.2 逐方案判定）

| 方案 | 内容 | S4.2 合规性 | macOS 语义 | 判定 |
| --- | --- | --- | --- | --- |
| **A. 纯托管 GC 等价（推荐）** | 保留 :103-116 阈值测量 + GC 链（三平台），删除 :22-23 DllImport 与 :118 调用；守卫位置按 §3.1 校正移至工作集调用点（或随方案 A 整体无 Windows 判断，直接三平台 GC） | **零禁用符号**，S4.2 扫描天然 PASS；无平台分叉、无需新规范先行；macOS 自检表 0 项"不适用" | 与 Windows 相同（GC+测量+日志） | 与 06 条目 49 降级行为"只跳过工作集操作并保留 GC/测量"完全相容；实现最简、门禁风险最低；代价=Windows 放弃工作集压缩 |
| **B. 插件本地抽象 + Windows 条件隔离适配器（保留能力的完整形态）** | 新建插件本地接口（如 06 所述 `IProcessMemoryMaintenanceService`，落 `SystemTools.CrossPlatform.Services`，p1-05 §3.2 命名）+ `#if Platforms_Windows`/`*Windows.cs` 条件文件承载 EmptyWorkingSet P/Invoke；Linux/macOS 适配器 no-op | DllImport 落条件编译「Windows 专属点」= B 档允许位；**前置条件**：须先按 p1-05 §5.1-3 建立阶段 2 平台条件文件规范，且 p0-07 扫描器对条件文件的门禁判定语义须确认（该扫描器现行对 .cs 全文计命中，`#if` 分支不豁免——需尚书省明确扫描豁免位或扫描口径扩展） | no-op（仅 GC），写实"不适用→降级为 no-op"注记 | 功能最完整；依赖链最长（新规范 + 扫描口径），若尚书省要求保留 Windows 工作集压缩则选此并先立规范 |
| **C. 源形态直迁 + 声明专属点（不推荐）** | :22-23/:96-99 原样保留（运行时守卫 + DllImport 同文件），该文件整体登记为 B 档「Windows 专属点」 | 静态扫描必命中 R13 → 须逐处声明豁免；与 p1-05 §5.2"GateHits=0"批级基线及阶段收口"全目录零命中"口径张力最大；非 Windows 语义=整体不执行（含 GC），与 06 降级目标不符 | guard 返回，无 GC | 合规依据最弱、与既定门禁基线冲突，仅留档备查 |
| **D. 宿主既有能力** | 依赖宿主进程内存维护 API | **不可行**：U3 检出全 1006 .cs 对 `IProcessMemoryMaintenanceService` 等零命中；NuGet Core 2.1.1.1 与 Platforms.Abstractions 2.1.1.1 字节检索均 ABSENT（§4） | — | 上报缺位，不得假托宿主接口名义（p1-05 §5.3-3 禁止发明宿主接口） |

**建议**：首选 **A**；如用户/尚书省要求保留 Windows 工作集压缩能力，则 **B**（先立阶段 2 平台条件规范 + 扫描口径确认，再派 p2-01 实施）。C/D 否决。无论何案，p2-01 均须在 macOS 自检表对内存 GC 项写实际语义（A=可用三平台；B=no-op 降级写实），并按 §2.1 登记 `AutoCleanupClassIslandMemory` 增补。

## 4. 双分支 API 漂移影响面核对清单（p1-10 §12.5 约束）

方法（p1-01 §7.4/7.5 先例）：U3 本地检出源码 grep（全检出 1006 .cs，排除 bin/obj/.git）+ NuGet 包二进制元数据字节检索（Latin1 解码 Contains；本任务实测于执行当日）。NuGet 面 = `classisland.core 2.1.1.1\lib\net10.0\ClassIsland.Core.dll`（3,671,040 B）与 `classisland.platforms.abstractions 2.1.1.1\lib\net10.0\ClassIsland.Platforms.Abstractions.dll`（24,064 B）。基线事实（p1-10 §12.5）：**发布面以 NuGet 包二进制实际暴露 API 为准**；仅存于本地检出的 API 一律视为缺位。

| 宿主 API / 符号 | U3 检出源码 | NuGet 2.1.1.1 | B 档消费批 | 结论 |
| --- | --- | --- | --- | --- |
| `IWindowPlatformService` | PRESENT（`ClassIsland.Platforms.Abstractions\Services\IWindowPlatformService.cs:12`） | **PRESENT**（Platforms.Abstractions.dll 字节检索） | p2-03（B12） | ✓ 双分支可用 |
| `SetWindowFeature(TopLevel, WindowFeatures, bool)` / `GetWindowFeatures` | PRESENT（:20/:27） | PRESENT（字节检索） | p2-03（B12） | ✓ |
| `WindowFeatures` 枚举（`Topmost`/`Bottommost`；p0-01：Topmost=4 :24、Bottommost=2 :20） | PRESENT（`Enums\WindowFeatures.cs:7-37`） | PRESENT（`WindowFeatures`/`Topmost`/`Bottommost` 字节检索均 PRESENT） | p2-03（B12） | ✓ 三平台实装（Windows :122/Linux :128/macOS :118，p0-01 §3） |
| `ISystemEventsService`（仅 `TimeChanged` :11） | PRESENT（契约面）；运行时仅 Windows 实装 + Stub（p0-01 G1） | PRESENT（契约面字节检索） | p2-03（SystemShutdownMonitor 关联面） | ⚠ 契约可用但**无会话结束/关机事件（G2）**→ 须护栏：SystemShutdownMonitor 走 S3-R4 既定"非 Windows no-op 降级"；B5 看门狗按 06 条目 38 改宿主生命周期事件语义，不假定会话结束事件存在 |
| `IDesktopToastService` / `ILauncherService` / `IDesktopService` | PRESENT（p0-01 §3 #3/#4/#5） | PRESENT（Platforms.Abstractions.dll 字节检索） | U4 降级通知（p2-01/p2-02/p2-03）；IDesktopService 注意 G3（macOS Stub） | ✓（B19 无 IDesktopService 直接消费点） |
| `MyWindow`（`ClassIsland.Core.Controls`，:35 `: FAAppWindow`） | PRESENT | **PRESENT**（Core.dll 字节检索） | p2-01（B5 两对话框基类，阶段 1 零消费、首个消费批） | ✓ 双分支可用（派工单若引 AiVoice 系 View 无关项已排除——C 档不迁） |
| `MainWindowStylesAssist.IsBackgroundMaterialEnabled` | PRESENT（:56-60） | **ABSENT**（已知漂移点，p1-01 §7.4） | —（U5 排除面） | B 档零消费，无影响；**B19 全部交付文件禁引用**（批内 S4.2/横查按 p1-01 §7.5 复扫） |
| `ISystemPowerService`（06 条目 37-43 替换目标：ScheduleShutdown/CancelScheduledShutdown/RestartNow/ShutdownNow/LockSession/Suspend） | **ABSENT**（全检出对 6 名字及 Shutdown/PowerService 关键字零命中） | **ABSENT**（两 DLL 字节检索） | p2-01（电源族 7 项） | **缺位项 → 须护栏或上报**：宿主 SDK 无此接口；06 表述只能按**插件本地抽象**落地（per-OS 命令适配器在插件内，Windows 侧命令启动属 B 档「Windows 专属点」声明位），或上报尚书省修订 06 表述；禁止按 `ClassIsland.*` 命名空间引用该名（p1-05 §5.3-3） |
| `IThemePlatformService`（06 条目 47） | **ABSENT** | **ABSENT** | p2-02（B13） | **缺位项** → 同上：插件本地主题探测抽象，或按 06 降级"跟随宿主明暗/手动" |
| `ITextOcclusionDetectionService`（06 条目 48） | **ABSENT** | **ABSENT** | p2-02（B14） | **缺位项** → 插件本地抽象；Windows OCR 链（WinRT `Windows.Media.*` 禁用符号）落声明专属点；Linux/macOS 关闭检测保持主界面可见（06 降级） |
| `IProcessMemoryMaintenanceService`（06 条目 49） | **ABSENT** | **ABSENT** | p2-01（内存 GC） | **缺位项** → §3 方案 B 之接口即此；方案 A 则无需该接口 |

**缺位项计数：4**（ISystemPowerService、IThemePlatformService、ITextOcclusionDetectionService、IProcessMemoryMaintenanceService——均为 06 替换目标表述中的接口名，宿主双分支均无）。统一护栏要求：①p2 批次如采用同名抽象，必须落**插件命名空间**并在交付证据注明"插件本地抽象，非宿主 API"；②或在批交付报告中上报尚书省修订 06 对应条目表述后再实施。其余 8 项核对面双分支一致，零缺位。

## 5. p1-06 §9-3/§9-4 报备恢复点确认（B 档面恢复归属）

| 报备点（p1-06 §9） | 阶段 1 处置（留痕） | B 档恢复归属 | 依赖 |
| --- | --- | --- | --- |
| §9-4 悬浮窗行动菜单组门（源 Plugin.cs:671-677 组门 `EnableFloatingWindowFeature`） | 阶段 1 不建悬浮窗菜单组；A3/A4 行动本体按 IsActionEnabled 常规注册 | **成员增补归 p2-03**（§2.1 #1）；菜单组建组+组门恢复归**礼部注册面**（源 :671-677 形态），调度时点建议随 p2-03 注册清单交接（阶段 2 注册接线或阶段 3 设置整合，由尚书省在阶段计划中定） | §2.1 #1 预批 |
| §9-6 悬浮窗编辑页注册门（源 :182-185 以 `EnableFloatingWindowFeature` 为门；阶段 1 无条件注册骨架页） | FloatingWindowEditorSettingsPage 无条件注册 | 同一成员（p2-03）+ 注册面改回条件门（礼部）；页面骨架本身阶段 1 已交付，B 档零新文件 | 同上 |
| §9-3 设置页分组机制（宿主 `AddSettingsPageGroup` + `[Group]`） | 阶段 1 已采用宿主原生 API，未新建注册辅助文件 | B 档恢复**不改变该机制**；行动菜单组门（§9-4）与设置页分组正交，互不影响 | 无 |
| 附带确认：`EnableFloatingWindowFeature` 源默认值 true（:54） | — | 恢复后默认行为与源一致（悬浮窗特性默认启用）；其 `RestartPropertyChanged` 触发语义按 §2.1 决策注记处置 | §2.1 注记 |

## 6. 边界声明与复核指引

- 本任务唯一写入 = 本证据文件；源插件与宿主检出全程只读（文件存在性 Test-Path、Select-String 检索、Get-Content 读取、NuGet DLL 字节检索，零写入零触碰）；`src\` 零改动。
- 复核重放（吏部落点核对面）：
  1. B19 文件存在性：对 §1.2 表逐行 `Test-Path 'E:\My Github Projects\SystemTools\<源文件>'` 应全 OK；
  2. 双分支字节检索：按 §4 方法重放两 DLL 的 Contains 检索，结果应与 §4 表一致；
  3. EmptyWorkingSet 实测：读源 `Services\ClassIslandMemoryAutoCleanupService.cs` :22-23/:96-99/:112-118 应与 §3.1 一致；
  4. 互斥性：§1.2 全表文件名两两比对应零重复；19 项计数应闭合（8+7+4）。
- 本文件不推进、不审批全局工作流；EmptyWorkingSet 方案取舍与 4 个缺位接口的护栏/上报处置、RestartPropertyChanged 决策注记，均报尚书省裁决；门下省终验。

## 7. 修订记录

- 初版（p2-05 派工交付）。
