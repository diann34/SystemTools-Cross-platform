# p2-09 证据：B19 纳入后的映射基线维护（吏部 personnel / repository-governance / analysis）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-09 · 吏部 personnel · repository-governance / analysis（阶段 2 映射基线维护；依赖 p2-01/p2-02/p2-03/p2-06 均已记录 succeeded） |
| 权威输入 | p0-03-scope-mapping-baseline.md（§3.2 B 清单 B19 = 行动 14 + 触发器 1 + 服务 4、§3.3 C 清单、§4.2 计数）；p1-09-personnel-mapping-update.md（A33 基线，2026-09-03 终态）；p2-05 §1 落点表与 §2 共享增补清单；p2-01/p2-02/p2-03 各批证据（逐项锚点/降级处置 A2-A10、AD1-AD10、D1-D15）；p2-06 §2（B19 注册行）与 §5（菜单组）；p1-05 §4.2/§8 |
| 文件性质 | **p0-03 §3.2 B 档映射的阶段 2 收口更新版**，与 p1-09（A33 基线）并列作为阶段 3/4 映射基线；本文件只更新映射状态，不重写 A 档明细（A33 引 p1-09，仅做零改动复核与注册行坐标重映射） |
| 结论速览 | **succeeded** —— B19 逐项更新闭合 **19/19**（源锚点 → 新落点实测 file:line → 交付批 → 注册状态实测）；**A33 零改动**（行动 15/15 ActionInfo 行与 p1-09 基线逐一相等，规则/触发器/主题/组件/服务抽查全一致，仅注册行随 Plugin.cs 480→742 行整体位移，坐标已重映射）；**C46 零提前迁入**（全树特征名检索非零命中 11 行、全部为注记留痕并逐条引证豁免口径，续 p1-09 九类口径并增 2 类）；计数闭合 98=A33+B19+C46，域分布与实测一致；p1-05 §8 六步复核重放（阶段 2 扩展口径）全过；登记 2 项勘误（E-3 计数聚合、E-4 锚点记录）与 1 项结构规范修订建议（§4.2 菜单树列） |
| 写入范围 | 仅本证据文件；`src\` 产品文件、源插件检出、宿主检出全程只读（本轮全部操作为只读检索/读取/扫描/哈希）；零改动 Plugin.cs / manifest.yml / csproj / MainConfigData / 任何批次交付文件 |

---

## 1. B19 逐项更新映射表（19/19，源锚点 → 新落点实测 → 交付批 → 注册状态实测）

口径：源锚点引 p0-03 §3.2 与各批证据（1-based 行号）；新落点为本轮对实际文件的**实测**锚点（批证据交付后无内容性改动，个别注记行号与批证据存在 ±1–11 行微漂，见 §7 勘误表，均零行为差异）；注册状态为本轮对 742 行 Plugin.cs 的实测行号并与 p2-06 §2 对照行逐行核实一致。源→新 ID 变换 = `SystemTools.<Name>` → `SystemTools.CrossPlatform.<Name>`（前缀段随源不改，p1-05 §3.3）。

### 1.1 行动 14 项（落点 `Actions\` + 附属；p2-01 / p2-02 / p2-03）

| 项 | 功能项 | 源锚点（p0-03 §3.2） | 新落点（实测 ActionInfo 行） | 批 | 注册状态（实测 Plugin.cs · p2-06 §2 对照） | 特殊处置注记 |
| :-: | --- | --- | --- | :-: | --- | --- |
| B1 | 复制（文件/文件夹） | CopyAction.cs:12 | `Actions\CopyAction.cs:11`（+ `Settings\CopySettings.cs`、`Controls\CopySettingsControl.cs`） | p2-02 | :289 · §2.1 B1 行 | AD5 BCL 递归复制（实测 :111，自递归 guard 实测 :129）；AD6 跨平台路径（:31-32）；AD8 元数据差异注记 |
| B2 | 移动（文件/文件夹） | MoveAction.cs:12 | `Actions\MoveAction.cs:11`（+ Settings/Controls 同名对） | p2-02 | :290 · §2.1 B2 行 | AD5 `Directory.Move` 同卷优先（实测 :94）+ 跨卷回退；AD6（:31-32）；AD9 源笔误文案逐字保留 |
| B3 | 删除（文件/文件夹） | DeleteAction.cs:12 | `Actions\DeleteAction.cs:11`（+ Settings/Controls 同名对） | p2-02 | :291 · §2.1 B3 行 | AD5 BCL 递归删除（实测 :66）；AD6（:30）；AD9 |
| B4 | 计时关机 | ShutdownAction.cs:15 | `Actions\ShutdownAction.cs:26`（+ `Settings\ShutdownSettings.cs`、`Controls\ShutdownSettingsControl.cs`） | p2-01 | :276-277 · §2.1 B4 行 | A4 SendKeys 删除（ShowPrompt 保留兼容）；A9/A10 执行器收敛至条件文件 `Actions\SystemPowerCommandWindows.cs`（R-2 双形态合格，guard 实测 `#if Platforms_Windows`）；D1 通知面随源 |
| B5 | 高级计时关机 | AdvancedShutdownAction.cs:22 | `Actions\AdvancedShutdownAction.cs:45`（+ Settings/Controls 对 + `Views\AdvancedShutdownDialog.axaml(.cs)`、`Views\ExtendShutdownDialog.axaml(.cs)`） | p2-01 | :278-279 · §2.1 B5 行 | A2/A3 计划载体改写；A5 看门狗移除；A6/A7 取消/延长可见化；D2 经典构造函数；静态取消路径 `CancelPlanOnAppStopping(bool)` 实测 :78（与 p2-06 §3-1 #6 一致）；对话框基类 MyWindow 双分支 PRESENT |
| B6 | 取消关机计划 | CancelShutdownAction.cs:14 | `Actions\CancelShutdownAction.cs:24` | p2-01 | :282-283 · §2.1 B6 行 | A8 退出码语义区分（0/1116/其余）；共享控件 `ShortcutKeyNotificationSettingsControl` 仅引用不复制 |
| B7 | 锁定屏幕 | LockScreenAction.cs:14 | `Actions\LockScreenAction.cs:25` | p2-01 | :280-281 · §2.1 B7 行 | 随源 rundll32 形态保持（裁决 1）；执行器调用实测 :51（`SystemPowerCommand.RunLockWorkstation`）；共享控件仅引用 |
| B8 | 立即重启 | ImmediateRestartAction.cs:12 | `Actions\ImmediateRestartAction.cs:22` | p2-01 | :284 · §2.1 B8 行 | A2 命令等价 `/g /t 0`（尚书省裁决 1，与 06-41 `/r` 表述差异已留痕 p2-01 §9-4）；单参形态随源 |
| B9 | 立即关机 | ImmediateShutdownAction.cs:12 | `Actions\ImmediateShutdownAction.cs:22` | p2-01 | :285 · §2.1 B9 行 | A2 `/s /t 0`；单参形态随源 |
| B10 | 睡眠 | SleepAction.cs:10 | `Actions\SleepAction.cs:23` | p2-01 | :286 · §2.1 B10 行 | D7 同步调用有界等待 1500ms（-2=未确认，不伪造成功）；单参形态随源 |
| B11 | 显示悬浮窗 | ShowFloatingWindowAction.cs:15 | `Actions\ShowFloatingWindowAction.cs:20`（+ `Settings\ShowFloatingWindowSettings.cs`、`Controls\ShowFloatingWindowSettingsControl.cs`） | p2-03 | :303-304，处于 `if (config.EnableFloatingWindowFeature)` 门内（:301）· §2.1 B11 行 | 恢复点 ①（p1-06 §9-4）随 A3/A4 同门；服务 D1-D11 降级（钩子/液态玻璃/手动鼠标拖拽移除等）；W12 A3/A4 回归注记 |
| B12 | 切换悬浮窗层级 | ToggleFloatingWindowLayerAction.cs:18 | `Actions\ToggleFloatingWindowLayerAction.cs:20`（+ Settings/Controls 同名对） | p2-03 | :305-306，同 B11 门内 · §2.1 B12 行 | D3 `SetWindowPos` → 宿主 `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)`（双分支 PRESENT 实证） |
| B13 | 自动切换 ClassIsland 主题 | AutoSwitchClassIslandThemeAction.cs:14 | `Actions\AutoSwitchClassIslandThemeAction.cs:14`（+ `Settings\AutoSwitchClassIslandThemeActionSettings.cs`、`Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs`，控件名含 Action 段随源不改） | p2-02 | :336-337 · §2.1 B13 行 | AD1 采样链降级（写配置实测 :30、ApplyConfig :31；06-47 偏差注记）；AD10 配置成员 `AutoSwitchClassIslandTheme`（MainConfigData.cs 增补段 :240-277，JSON 名 :251） |
| B14 | 遮挡文字时隐藏主界面 | AutoHideMainWindowWhenOccludedAction.cs:14 | `Actions\AutoHideMainWindowWhenOccludedAction.cs:14`（+ `Settings\AutoHideMainWindowWhenOccludedActionSettings.cs`、`Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs`） | p2-02 | :338-339 · §2.1 B14 行 | AD2 检测链降级 + 零条件文件（写配置实测 :30、ApplyConfig :31；06-48 偏差注记）；AD4；AD10 配置成员（MainConfigData.cs :262-275，JSON 名 :265） |

### 1.2 触发器 1 项（三件套；p2-03）

| 项 | 功能项 | 源锚点 | 新落点（实测） | 批 | 注册状态（实测 Plugin.cs） | 特殊处置注记 |
| :-: | --- | --- | --- | :-: | --- | --- |
| B-触发 | 从悬浮窗触发 | FloatingWindowTrigger.cs:12（源 Triggers\；:25-44 服务联动、:46-62 触发） | `Triggers\FloatingWindowTrigger.cs:18`（TriggerInfo 实测）+ **`Config\FloatingWindowTriggerConfig.cs`**（源侧唯一落 `Triggers\` 的触发器配置，按 p2-05 §1.2 权威表归 `Config\`，与源目录差异已登记 p2-03 §1.3）+ `Settings\FloatingWindowTriggerSettings.cs` | p2-03 | :364-365，处于 `if (config.EnableFloatingWindowFeature)` 门内（:362）· §2.2 行 | 恢复点 ②；auto.json 对端 = A7（p1-03 已落地）；W10/W11 交接逐项落实 |

### 1.3 服务 4 项（B19 计数；DI + lifecycle；p2-01 / p2-02 / p2-03）

| 项 | 功能项 | 源锚点 | 新落点（实测） | 批 | 注册状态（实测 Plugin.cs） | 特殊处置注记 |
| :-: | --- | --- | --- | :-: | --- | --- |
| S-浮 | 悬浮窗经典外观（FloatingWindowService，B11 服务面） | Services\FloatingWindowService.cs:30（源 2478 行单文件） | `Services\FloatingWindowService.cs`（实测 49,628 字节；窗口代码内创建无 axaml） | p2-03 | DI `AddSingleton<FloatingWindowService>()` :127（紧随 FloatingWindowProfileManager :123，随源相对序）；AppStarted Start :197-200（EnableFloatingWindowFeature == true 门）；OnAppStopping Stop :245-248 | D1-D11 已批降级（R-3 钩子、U5/R-6 液态玻璃、D5 自适应主题回退宿主明暗、D6 手动鼠标拖拽）；`EnsureRulesetPatrol`/`RemoveRulesetPatrol` 为钩子内规则集巡检的重命名保留面；W1-W4 接线全落实 |
| S-主题 | 自适应主题同步（AdaptiveThemeSyncService，B13 服务面） | Services\AdaptiveThemeSyncService.cs:10 | `Services\AdaptiveThemeSyncService.cs`（Start :21 / Stop :27 / ApplyConfig :33 / 配置开关门 :38 / 降级通知 :46-52 实测） | p2-02 | DI `AddSingleton<AdaptiveThemeSyncService>()` :128；AppStarted Start :202；OnAppStopping Stop :230 | AD1/AD3 降级形（无计时器/捕获租约，Start 直呼 ApplyConfig）；源 :44 非 Windows 分支随降级删除 |
| S-遮挡 | 遮挡检测（MainWindowTextOcclusionService，B14 服务面） | Services\MainWindowTextOcclusionService.cs:19 | `Services\MainWindowTextOcclusionService.cs`（Start :28 / Suspend :39 / Shutdown :58 / Stop :68 / ApplyConfig :74 / 配置开关门 :91 实测；:39-56/:109-135 生命周期逐行随源） | p2-02 | DI `AddSingleton<MainWindowTextOcclusionService>()` :129；AppStarted Start :203；OnAppStopping `Shutdown(restoreMainWindow: true)` :232 | AD2/AD4 检测面降级（从不隐藏主界面，恢复为结构真值）；`Shutdown(bool restoreMainWindow = false)` 新签名与 p2-06 §3-2 #5 核实一致 |
| S-内存 | ClassIsland 内存自动清理（项 49） | Services\ClassIslandMemoryAutoCleanupService.cs:13（:22-23 psapi、:96-99 守卫、:103-120 GC 链） | `Services\ClassIslandMemoryAutoCleanupService.cs` + p2-01 §1.3 六新造文件：`Actions\SystemPowerCommandWindows.cs`/`SystemPowerCommandStub.cs`、`Services\IProcessMemoryMaintenanceService.cs`/`ProcessMemoryMaintenanceService.cs`/`ProcessMemoryMaintenanceNativeWindows.cs`/`ProcessMemoryMaintenanceNativeNoOp.cs` | p2-01 | DI 对 :130（`AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`，顺序约束满足）+ `AddSingleton<ClassIslandMemoryAutoCleanupService>()` :131；AppStarted ApplyConfig :206（MainConfig 赋值后，p2-05 §2.1 #10）；OnAppStopping Stop :234 | A1 裁决 3：插件本地抽象 + Windows 条件适配器（`*Windows.cs` 全文件 guard 实测首行 `#if Platforms_Windows`）+ 非 Windows no-op 留痕（守卫位置校正：GC 链三平台执行、工作集修剪仅 Windows）；D4 using 释放、D5 WorkingSetTrimmed 日志字段 |

### 1.4 非计数附属 2 项（不占 B19 计数，p2-05 §1.2 口径）

| 项 | 源锚点 | 新落点（实测） | 批 | 注册状态（实测 Plugin.cs） | 处置注记 |
| --- | --- | --- | :-: | --- | --- |
| SystemShutdownMonitor | Services\SystemShutdownMonitor.cs:8（NativeWindow 子类，源 88 行） | `Services\SystemShutdownMonitor.cs`（R-2 形态 a：首/末非空行实测 `#if Platforms_Windows` / `#endif`） | p2-03 | W5：字段 :54 + new/Start/AddSingleton :133-135；W6：IsSessionEnding :221-222 → `CancelPlanOnAppStopping(isSessionEnding)` :239 → Dispose :241；W7：RegisterShutdownRequestedHandler :253-267 + 双调用点 :193/:213 + 退订 :224-228 | D12：Windows 分支逐行随源 + 非 Windows no-op 护栏（G2 实证宿主无会话结束事件，ISystemEventsService 仅 TimeChanged）；`WindowCaption` 常量按 ID 前缀精神变换（非注册 ID） |
| SystemMotionPreferences | Views\SystemMotionPreferences.cs:6（源 :27-31 user32 互操作） | `Views\SystemMotionPreferences.cs`（R-2 形态 a，实测同上） | p2-03 | W13：注册面零引用（B 档唯一消费点已随 U5 降级移除，p2-06 §10-6 兑现） | 编译期分支承载源运行时守卫语义（`ShouldReduceMotion()` 非 Windows 恒 false）；C 档消费方（AiVoice 覆盖层）不迁 |

**闭合校验：14（§1.1）+ 1（§1.2）+ 4（§1.3）= 19/19**，与 p2-05 §1.3-6 分批口径（p2-01 8 + p2-02 7 + p2-03 4）及 p2-06 §2（19 项逐项）一致；每项注册形态均经本轮对 742 行 Plugin.cs 实测重放（§5-6）。

---

## 2. A33 零改动复核（p1-09 基线 → 当前终态）

### 2.1 落点行抽查（实际文件，对照 p1-09 §1 实测列）

| 域 | 抽查项与结果 | 结论 |
| --- | --- | --- |
| 行动 15 项 | A1 KillProcessAction.cs **:14**、A2 ShowToastAction.cs **:11**、A3 ToggleFloatingWindowProfileAction.cs **:20**、A4 SwitchFloatingWindowThemeAction.cs **:16**、A5 BackgroundPlayAudioAction.cs **:13**（守卫分支 :87 同 p1-09）、A6 ActionFlowExecutionConfirmationAction.cs **:18**、A7 TriggerCustomTriggerAction.cs **:13**、A8 ToggleWorkflowAction.cs **:15**、A9 ShowAiChatDialogAction.cs **:9**、A10 FullscreenClockAction.cs **:11**、A11 ClearAllNotificationsAction.cs **:14**、A12 LoadTemporaryClassPlanAction.cs **:15**、A13 OpenAppSettingsAction.cs **:14**、A14 OpenProfileEditorAction.cs **:14**、A15 OpenClassSwapWindowAction.cs **:14** —— 15/15 与 p1-09 §1.5 实测列逐一相等 | ✅ 零改动 |
| 规则 4 项 | ProcessRunningRuleSettings.cs / UsingClassPlanRuleSettings.cs / UsingTimeLayoutRuleSettings.cs / InTimePeriodRuleSettings.cs 类型声明行全部 **:5**（= p1-09 §1.3） | ✅ 零改动 |
| 触发器 1 项 | ActionInProgressTrigger.cs TriggerInfo 实测 **:20**；p1-09 §1.4 记 :18 —— **勘误 E-4**（记录级 2 行漂移，文件内容与 p1-02 声明形状一致：CS0104 消歧注记在位、全 98 行，零代码改动；新基线以 :20 为准） | ✅ 零改动（勘误 E-4 登记） |
| 主题 3 项 | `Themes\*\manifest.yml` id 实测 `SystemTools.CrossPlatform.Card-type-component` / `.classwidgets` / `.notch-style`（= p1-09 §1.1；Themes\ 目录仍 21 文件，阶段 2 零触碰） | ✅ 零改动 |
| 组件 6 项 | 6 GUID 实测与 p1-09 §1.2 逐一相等（056130C1…/F3A18AE1…/885F26B9…/0182775C…/E6FC9A28…/E02A4DC6…），两两互异 | ✅ 零改动 |
| 服务/设置页 4 项 | S1 AiChatWindowService.cs ShowAsync **:21**（= p1-09 §1.6）；S2 VirtualAfterSchoolService.cs ApplyConfig **:62**（同上）；S3 VersionCheckService.cs **:94** 导航 URI 逐字符同 p1-09；S4 SettingsPage\ 14 文件在位（目录计数不变） | ✅ 零改动 |

**A33 零改动结论**：阶段 2 各批（p2-01/p2-02/p2-03/p2-05/p2-06）均书面声明零改动 A 档落点文件，本轮抽查 29 项锚点无一漂移（仅 E-4 一处 p1-09 记录级行号勘误），证实 A33 产品文件在阶段 2 保持冻结。

### 2.2 注册行坐标重映射（Plugin.cs 480 行 → 742 行，本轮实测）

A33 注册形态与启用开闭门未变；阶段 2 B 档接线使行号整体位移，A3/A4 与悬浮窗编辑页另恢复入源组门（注册语义变化 = p2-06 §4 已批恢复点，非漂移）：

| 项 | p1-09/p1-06 基线（480 行态） | 当前实测（742 行态） | 语义变化 |
| :-: | --- | --- | --- |
| T1-T3 主题 | :65-76 / :77-88 / :89-100（Id :69/:81/:93） | :84-95 / :96-107 / :108-119（Id :88/:100/:112） | 无（仅位移） |
| S1 AI 链 DI | :106-115 + 去重注册 :119-126 | EnableAiService 门 :138-146 + 通知提供方 :148-157 | 无（仅位移） |
| S2 虚拟放学 | :105 DI + :151-154 Start + :163 Stop | :136 + :208 + :236 | 无 |
| S3 版本检查 | :156 | :211 | 无 |
| S4 设置页 | :129-138 | 组 :160；6 页 :161/:162/:165/:171/:173/:174；aiChat 门 :163-166；**悬浮窗编辑页门 :169-172（恢复点 ③）** | 编辑页改条件注册（随源） |
| G1 触发器 | :228-229 | :358-359 | 无 |
| R1-R4 规则 | :237-259（双参 AddRule） | :374-396（R1 :376-377 / R2 :382-383 / R3 :388-389 / R4 :394-395） | 无 |
| C1-C6 组件 | :266-277 | :403-414 | 无 |
| A1/A2 | :177-178 / :179-180 | :294-295 / :296-297 | 无 |
| A3/A4 | :184-185 / :186-187（无门常规注册） | :307-308 / :309-310（**入 `if (config.EnableFloatingWindowFeature)` 门 :301-311，恢复点 ①**） | 组门恢复（p2-06 §4-1） |
| A5-A8 | :190-191 / :194-195 / :196-197 / :198-199 | :314-315 / :318-319 / :320-321 / :322-323 | 无 |
| A9 | :202-204（EnableAiService 门） | :326-329（门 :326） | 无 |
| A10 | :208-209 | :332-333 | 无 |
| A11-A15 | :212-213 / :214-215 / :216-217 / :218-219 / :220-221 | :342-343 / :344-345 / :346-347 / :348-349 / :350-351 | 无 |

---

## 3. C46 零提前迁入反向核对（p0-03 §3.3 C 清单特征名 → 实际文件树）

方法：对 `src\SystemTools.CrossPlatform\` 全树 199 个源面文件（163 .cs + 29 .axaml + 4 .yml + 3 .txt，排除 bin/obj）按 C 档 46 项**类型/文件特征名**分 14 组检索，全部命中逐条人工归类。与阶段 1（p1-09 §3）的关键差异：B19 类型/文件/成员现在**合法存在**（阶段 2 交付），故本轮以 C 档特征名为唯一反向检索对象，B19 命名面不再计入"零迁入"判据。

### 3.1 检索结果

| 组 | 覆盖 C 条目 | 特征关键词 | 命中 |
| --- | --- | --- | --: |
| C1-C6 常用模拟键 | Alt+F4/Alt+Tab/Ctrl+Z/Enter/Esc/F11 | AltF4、AltTab、CtrlZ、EnterKey、EscKey、F11Key | **0** |
| C7-C11 输入/窗口 | 模拟键盘/组合键/鼠标/键入内容/窗口操作 | SimulateKeyboard、SimulateKeyCombination、SimulateMouse、TypeContent、WindowOperation | **0** |
| C12-C13 鼠标禁用/启用 | jinyongshubiao、huifu.bat、DisableMouse、EnableMouse | **0** |
| C14-C17 显示拓扑 | CloneDisplay、ExtendDisplay、InternalDisplay、ExternalDisplay、DisplaySwitch | **0** |
| C18-C19 黑屏/显示桌面 | BlackScreenHtml、black.html、ShowDesktop | **0** |
| C20 亮度 | AdjustScreenBrightness | **0** |
| C21-C23 个性化 | ChangeWallpaper、SwitchSystemAccentColor | **0** |
| C24-C26 设备/USB | DisableDevice、EnableDevice、AutoOpenUsbDriveOnInsert | **3**（全部注记，§3.2-e） |
| C27-C28 语音 | EnableVoiceWakeAi、WakeUpVoiceConversationAi、AiVoiceConversation | **1**（注记，§3.2-c） |
| C29-C32 截图/音量/摄像头/提权 | ScreenShot、SetVolume、CameraCapture、RestartAsAdmin | **1**（注记，§3.2-e） |
| C 组件/规则 | LyricsDisplay、MediaMusicPlaying | **0** |
| C 触发器 5 | HotkeyTrigger、HotkeyService、HotkeyRecorder、KeywordTrigger、LongIdleTrigger、MainWindowClick、UsbDeviceTrigger | **0** |
| C 服务/认证 7 | UsbAutoPlayService、KeywordSpeech、Vosk、FaceRecognition、WindowsHello、SystemMemoryCleanup、MainWindowBackgroundCapture、BackgroundLuminance | **0** |
| 死代码/U5/其他未迁 | ClickSimulation、LiquidGlass、AiChatGlassSurface、ThirdParty、DependencyPaths、InjectServices、ThemeBannerCache、AboutTitleImageCache、ClassIslandSettingsService、MainWindowAreaService、ExperimentalBadge、SettingsPageLazy | **7 行**（注记，§3.2-a/c/d） |

**C 档类型/文件/注册身份实体：0。** 全部非零命中（11 个不同行）均为「说明 C 档面不迁入」的文档性注记：

- **a. Plugin.cs:82**（ThemeBannerCacheService 缓存路径置空注记，p1-06 §9-2 先例延续）；
- **b. Plugin.cs:187-189**（AppStarted 处理器头注：源 C 档行 ThemeBannerCacheService/AboutTitleImageCacheService/ClassIslandActionAiService.StartWarmup/**AiVoiceConversationService**/UsbAutoPlayService/SystemMemoryCleanupService 不随入，p2-06 §10-5 逐项列名留痕）；
- **c. ConfigHandlers\MainConfigData.cs:93**（p1-04 液态玻璃三成员不增补注记）与 **:325-326**（p2-03 增补段内 FloatingWindowAppearanceStyle/FloatingWindowLiquidGlass/FloatingWindowGlassButtonScaleDip 明确不增补注记 = p2-05 §2.1「明确不增补」清单兑现）；
- **d. SettingsPage\AboutSettingsPage.axaml:11 与 .axaml.cs:24**（AboutTitleImageCacheService 题图/Lyricify Lite 帮助 B/C 面不迁注记，p1-09 §3.3-c 同款）；
- **e. Plugin.cs:335/:517-518/:637**（AutoOpenUsbDriveOnInsert 属 C 档不迁 + 更多功能选项组门按 p1-06 §2.7 裁剪先例仅呈现 B13/B14 + 源 :931-932 菜单项不呈现注记 = p2-06 §5-4/§11 微修 1 复核 3 处注释行同值）；Plugin.cs:518（**RestartAsAdmin** 同口径注记）。

### 3.2 B13/B14 降级服务与 C 档采样面边界（AD1/AD2 论证复核）

- C 采样面特征（**BackgroundLuminance**、**MainWindowBackgroundCapture**）全树 **0 命中**：B13/B14 降级服务（AdaptiveThemeSyncService / MainWindowTextOcclusionService）内**不含**采样/捕获/OCR 实体，其检测/采样方法体按 AD1/AD2 不迁——p2-02 §2 AD1/AD2 的"C 档采样面未随任何 B 批迁移 → 降级形无输入链"边界论证经本轮独立检索证实。
- B14 服务内 `AutoHideMainWindowWhenOccluded`（B 档配置成员）与 Suspend/Resume 生命周期面为合法 B19 面；`MainWindowTextOcclusion` 命名与 C 档 `MainWindowBackgroundCapture`（背景截图采样，服务域 C 项）为不同实体，后者 0 命中。

### 3.3 机制符号与资产面（阶段 2 增量口径）

- **条件文件收敛**：Win32/互操作符号文本本轮实测仅出现于 7 个文件——4 个 R-2 条件文件（`SystemPowerCommandWindows.cs`（shutdown/rundll32 族命令与 ExitWindowsEx/RtlAdjustPrivilege/LockWorkStation/SetSuspendState 文本，全部处于 `#if Platforms_Windows` guard 内 = 扫描器 CONDITIONAL 载体）、`ProcessMemoryMaintenanceNativeWindows.cs`（EmptyWorkingSet psapi，guard 内）、`SystemShutdownMonitor.cs`、`SystemMotionPreferences.cs`（SystemParametersInfo，guard 内））+ 2 个对称存根/执行器消费面（`SystemPowerCommandStub.cs` `#if !Platforms_Windows` 内 no-op 方法名、`ImmediateRestartAction.cs`/`ImmediateShutdownAction.cs`/`LockScreenAction.cs` 文件头「源 Windows 专属点声明」注释与插件本地执行器方法名调用）——均为 B 档「Windows 专属点」声明位（04-spec:61）或其文档/调用面，非 C 档实体；扫描器权威判定 GateHits=0（§5-5）。
- **资产**：树中 .bat/.ps1/.exe/.html 文件实体 **0**（扩展名普查证）；禁止目录（VoskWorker\、ThirdParty\、Platforms\*）**0**。
- **MainConfigData C 成员**：EnableFfmpegFeatures/EnableFaceRecognition/EnableWindowsHello/AutoOpenUsbDriveOnInsert/AutoCleanupSystemMemory/SystemMemoryCleanupThresholdPercent/LyricifyLiteWarningDismissed 全部 **0 命中**（p2-05 §2.1「明确不增补」清单全部兑现）；液态玻璃 3 成员仅存于 :325-326 不增补注记。
- 续 p1-09 九类豁免口径中不受阶段 2 影响的三类：资源键随源（Theme.axaml.txt `SystemAccentColor`，Themes\ 阶段 2 零触碰）、字体写实 2 处（KillProcessSettingsControl.cs:52 / AiChatSettingsPage.axaml:38，文件未触碰）、附件类型过滤常量（AiAttachmentService.cs:54，文件未触碰）；`runas` 子串误报口径（RunAsync）继续适用。

**结论：C46 零提前迁入成立（阶段 2 终态）。** 全部非零命中可逐条追溯至已批注记/裁剪/降级口径；无「未申报迁入」需上报事项。

---

## 4. 计数与结构一致性（与 04-spec §S4.1 闭合）

### 4.1 规范计数

| 校验项 | 规范要求（04-spec §S4.1） | 本更新版实测 | 结论 |
| --- | --- | --- | --- |
| 主题 | 3，全 A | §2.1 = 3 落盘+注册（A33 基线） | ✅ |
| 组件 | 7 = 6 A + 1 C（歌词） | 6 A 落盘+注册；LyricsDisplay 零落点（§3.1） | ✅ |
| 规则集 | 5 = 4 A + 1 C | 4 A 落盘+注册；MediaMusicPlaying 零落点 | ✅ |
| 触发器 | 7 = 1 A + 1 B + 5 C | **1+1 落盘+注册**（G1 :358-359 + B-触发 :364-365）；5 C 零落点 | ✅ |
| 行动 | 61 = 15 A + 14 B + 32 C；死代码不计项 | **15+14 落盘+注册**（29 行动注册实测）；32 C 零落点；死代码 ClickSimulation 0 命中 | ✅ |
| 服务/设置页（A 聚合） | 4 | S1-S4 落盘+注册（§2.2 坐标表） | ✅ |
| 服务（B 聚合） | 4 | **S-浮/S-主题/S-遮挡/S-内存 4 项 DI+lifecycle 落实**（§1.3） | ✅ |
| 服务/认证（C） | 7 | 7 项 C 服务特征名零落点（§3.1） | ✅ |
| **总计** | **A33 + B19 + C46 = 98** | 已纳 33+19=**52**；C 46 零迁入；**98 闭合** | ✅ |

### 4.2 域分布与实际一致

行动 15+14=**29**（29 个 `RegisterActionIfEnabled` 调用实测，§5-6）/ 触发器 1+1=**2** / 服务 3+4=**7**（S1 聚合 DI 门 :138-146 + S2 :136 + S3 静态 :211 + S-浮 :127 + S-主题 :128 + S-遮挡 :129 + S-内存 :131）/ 主题 **3** / 组件 **6**（:403-414）/ 规则 **4**（:374-396）/ 设置页 **6**（:160-174）——与 04-spec §S4.1 及 p0-03 §4.2 全表逐行吻合。

### 4.3 树清点与批次归账（阶段 1 + 阶段 2 实测）

- **全树 203 文件**（排除 bin/obj）：163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj；Source 面（扫描器口径 .cs/.csproj/.yml）= **168**。
- 阶段 1 基线 152 文件 + 阶段 2 新增 **51 文件** = 203：p2-01 = **22**（Actions 9 = 7 行动 + 执行器对；Services 5 = GC 服务 + 抽象/实现/条件对 4；Views 4 = 两对话框对；Settings 2；Controls 2）、p2-02 = **17**（Actions 5 + Settings 5 + Controls 平铺 5 + Services 2）、p2-03 = **12**（Actions 2 + Settings 3 + Controls 2 + Services 2 + Config 1 + Triggers 1 + Views 1）。
- **勘误 E-3（计数聚合，登记不改档）**：p2-01 报告头/§5.1/§10 称「23 个交付文件（21 .cs + 2 .axaml）」，其 §1 逐表枚举与本轮实测均为 **22 文件（20 .cs + 2 .axaml）**——Services 计 6 实为 5（IProcessMemoryMaintenanceService 对 2 件 + 条件对 2 件 + GC 服务 1 件），Roslyn 入检树算式（21+4+1+1=27≠26）同源 +1。逐文件交付集完整无缺（p2-05 §1.2 权威落点表全部兑现），仅聚合计数行勘误；p2-02（17）与 p2-03（12）计数与实测一致。
- **注册面/共享面增量**：Plugin.cs 480→**742** 行（主批 684 + 微修 1 +58，p2-06 §5-5）；MainConfigData.cs 269→**553** 行，增补段界标实测有序：p1-04 末 :199 → p1-06 末 :237 → **p2-02 末 :277 → p2-01 末 :302 → p2-03 末 :520**（三批段互斥零冲突，p2-01 §9-5 / p2-03 §1.6 声明与实测一致）。

---

## 5. p1-05 §8 六步复核重放（阶段 2 扩展口径）

### 5-1 树核对
全树 203 文件逐目录实测（§4.3），每个阶段 2 新文件唯一归入 p2-05 §1.2 一个批次行；`Actions\`/`Controls\`/`Settings\`/`Services\`/`Views\` 共享容器按「文件随功能项批次」归属，零同名跨批。✅

### 5-2 命名空间核对
`namespace\s+SystemTools\.(?!CrossPlatform)` 对 163 个 .cs 全树检索：**0 命中**（含裸 `SystemTools.` 前缀 0 命中）✅（p1-05 §8-2 / p1-09 §4-2 同口径）。

### 5-3 ID 前缀核对
`"SystemTools\.` 全树（.cs/.axaml/.yml）命中 202 行，全部为 `SystemTools.CrossPlatform.*` 形态；仅有的 3 处无尾段形态（`"SystemTools.CrossPlatform"` 整串）为 AiConversationStore.cs:27 回退目录名 + AiChatSettingsPage.axaml.cs:51 + SystemToolsSettingsPage.axaml.cs:42 插件目录路径——与 p1-09 §4-3 已登记的 3 处完全同值。**源插件形态 ID 字符串零出现** ✅（前缀空间不相交前提保持）。

### 5-4 注册面核对（内容级，git 不可用同 p1-09 §4-4）
1. Plugin.cs 742 行逐段读取：内容与 p2-06 §1-§5 声明逐段一致（37 注册 + DI/lifecycle + 4 组门 + 11 组节点/29 菜单项），零兵部批注册痕迹混入（兵部三批证据均书面声明零写注册面）；
2. manifest.yml SHA256 实测 `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC` = p0-05 基线逐字符一致（阶段 2 全程字节不变，p2-06 §8 复测同值）✅；
3. MainConfigData 仅含 p2-05 §2.1 预批的三批增补段（§4.3 界标序），p2-06 零触碰（只读消费，门成员 EnableFloatingWindowFeature 属性实测 :332 与 p2-06 §3-3 W11 引用一致）；
4. csproj/主题/SettingsPage/A 档落点：阶段 2 各批零写入声明 + 本轮树普查/抽查佐证。
**结论：注册面唯一写入者 = 礼部 p2-06 成立（证据级核验）。**

### 5-5 门禁重放
p2-08 尚未在案卷留下证据文件（本任务先于其收口），故按派工口径引 **p2-06 收口复跑为权威基线**（全树 168 文件、GateHits=0、CONDITIONAL=13、INFO=2、PASS、exit=0），并**本轮独立复跑证实终态不变**：`p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source` → **SourceFiles=168、GateHits=0、ConditionalHits=13（SystemPowerCommandWindows R21×5+R17×3 / ProcessMemoryMaintenanceNativeWindows R13+X04 / SystemShutdownMonitor R03 / SystemMotionPreferences R13+X04，与兵部三批登记零新增）、InfoHits=2（I04）、CommentOnly=6（csproj 既有注释）、VERDICT: PASS、exit=0**。✅

### 5-6 A33+B19 闭合清点
注册面机器复核重放：`Register*IfEnabled` 调用 **37**（注册区 271-416 行内逐调用提取 ID）→ **37 唯一 / 0 重复 / 0 非前缀**；构成 = 行动 29（A15+B14）+ 组件 6 + 触发器 2（G1 + B-触发）。B 档 15 个注册 ID 逐一命中各恰 1 次；4 服务 DI + SystemShutdownMonitor 实例 + 维护接口对逐一在位（§1.3/§1.4）。**33 + 19 = 52/52** ✅（A33 逐项见 p1-09 §1 + 本文件 §2.1 复核；B19 逐项见 §1）。

---

## 6. 结构规范修订建议登记（p1-05 §4.2 格式缺口，供后续批与阶段 3 遵照）

**缺口事实**：p1-05 §4.2「注册清单交接格式」表列（项/类型全名/功能 ID/注册目标/设置类型全名/源锚点）**不含「行动菜单树」列**——p2-02 交接据此遗漏文件操作/更多功能选项两组菜单组织面（p2-06 §10-1 根因留痕）；p2-01 §8 与 p2-03 §4 W11 因含显式菜单交接行而未遗漏。微修 1 已由礼部按源先例补齐（p2-06 §5-3/§5-4），但格式缺口本身未修订。

**修订建议（吏部登记，报尚书省纳入 p1-05 §4.2 修订或阶段 3 派工约束）**：§4.2 表增补可选列 **「行动菜单树（如有）」**，要求功能项进入行动菜单树时显式交接：①所属组与组门成员（含组门裁剪口径）；②组节点名称/图标字符（随源锚点）；③菜单项文案/图标/树内相对序（随源锚点）。或等效要求：凡 `RegisterActionIfEnabled` 交接行均须附一行菜单归属声明（无则写「不入菜单树」），使菜单组织面成为显式交接义务，杜绝「注册有、菜单无」类缺口。阶段 3 设置页/菜单整合批派工时应引用本条。

---

## 7. 勘误与微漂登记（全部为记录/注记级，零档位、零计数、零行为差异）

| # | 类型 | 内容 | 处置 |
| :-: | --- | --- | --- |
| E-3 | 聚合计数勘误 | p2-01 头/§5.1/§10「23 个交付文件（21 .cs + 2 .axaml）」vs 枚举/实测 22（20 .cs + 2 .axaml）；Services 6→5；Roslyn 树算式同源 +1。逐文件集完整（p2-05 §1.2 全兑现） | 本文件 §4.3 以实测为准归账；报尚书省/门下省知悉 |
| E-4 | 基线锚点勘误 | p1-09 §1.4 记 G1 TriggerInfo :18，实测 :20（文件头 XML doc 注记区 2 行记录漂移；文件内容与 p1-02 声明一致，零代码改动） | 新基线以 :20 为准（§2.1） |
| W-1 | 锚点微漂 | 批证据交付时点 vs 当前终态的注记/微修行号差：B13/B14 写配置+ApplyConfig 记 :31-32 → 实测 :30-31；CopyAction 自递归 guard 记 :118 → 实测 :129；p2-01 所记各文件行数（如 Shutdown 93）与当前总行/非空行统计（89/78 等）不逐一对齐（统计口径与微修订时点差异） | 本文件 §1 一律以本轮实测值为阶段 3/4 基线；行为面经各批 Roslyn/扫描/注册复核背书，零差异发现 |

---

## 8. 边界声明与复核指引

- 本任务唯一写入 = 本证据文件；`src\` 产品文件、源插件检出（`E:\My Github Projects\SystemTools`）、宿主检出全程零改动（源侧事实全部取自 p0-03/p2-05 已固化证据，新插件侧全部为只读检索/扫描/哈希，与 p1-09 §6 口径一致）。
- 本文件不推进、不审批全局工作流；仅向尚书省回报 p2-09 结果，供门下省终验，并作为阶段 3/4 的映射基线（与 p1-09 并列）。
- 快速复核重放：
  1. 树清点：`Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object FullName -notmatch '\\(bin|obj)\\'`（应 203；Source 面 168）；
  2. 门禁：`& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source`（应 168/0/13/PASS/exit 0）；
  3. 注册面：对本文件 §1/§2.2 各行号重放 `Select-String -Path src\SystemTools.CrossPlatform\Plugin.cs -Pattern <ID>`；37 调用/37 唯一复核口径见 §5-6；
  4. manifest：`(Get-FileHash src\SystemTools.CrossPlatform\manifest.yml -Algorithm SHA256).Hash`（应 142CD419…AAC）；
  5. C46：按 §3.1 关键词组重放，非零命中应恰为 §3.1 所列 11 行注记。

## 9. 修订记录

- 初版（p2-09 执行交付；基于 2026-09-03 案卷工作区终态实测）。
