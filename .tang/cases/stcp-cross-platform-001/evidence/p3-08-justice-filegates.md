# p3-08 证据：闸门故障恢复 plan 验证收尾——整合后全树权威逐文件门禁与回归（刑部 quality-security / verification）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-08 · 刑部 justice · quality-security / verification（阶段 3 验证收尾；依赖 none——整合面 p3-05/01/02/03/06 已于旧 plan succeeded 落盘，本任务仅验证） |
| 权威输入 | p0-07-quality-gates.md §11（R-2 条件文件口径 + R-2a 勘误 guard=`Platforms_Windows`）；p0-07-s42-scan.ps1（R-2 版扫描器，本任务**零改动**直用）；p2-08-justice-filegates.md（阶段 2 权威基线：168 文件/GateHits=0/CONDITIONAL=13/InfoHits=2/CommentOnly=6 逐条对应）；p1-08-justice-filegates.md（阶段 1 基线 119 文件）；p3-01 §4/§9（共享 VM p3-01 两段申报 + IRulesetService 缺陷上报）；p3-02 §5/§6（共享 VM p3-02 三段 + 段外守卫修订 + D1-D4 修复申报 + W9 15-50）；p3-03 §3/§6（X1/X2 裁决先例 + 零调整认证口径）；p3-06 §3.1/§6（6 页 Binding 重放方法） |
| 工作区 | `E:\My Github Projects\SystemTools-Cross-platform`（写入面 = 本案 evidence/ 下 p3-08-* 文件，§7） |
| 只读面 | `src\SystemTools.CrossPlatform` 全树（**零改动**）；原插件与宿主检出（未触碰）；扫描器 `p0-07-s42-scan.ps1`（字节未动） |
| 结论 | **succeeded** —— (a) 全树 Source 面 **168/168 文件逐文件矩阵全 PASS**（GateHits=0、ConditionalHits=**13**、InfoHits=2、CommentOnly=6，exit=0；与 p2-08 基线逐值一致；§2）；(b) **CONDITIONAL=13 逐条与 p2-08 §3.1 逐字节一致**（file:line:rule 全同），阶段 3 整合/裁剪/命名空间三批**零新增条件面**（7 个 p3 交付文件 `#if`=0，§2.5）；(c) 共享 VM 887 行终态**五段界标逐段核验全过**（成员申报一致 + 45 声明零重名 + 收口花括号 :887 + 段外守卫修订 :166-191 在位；§3）；(d) **4 项修复 D1-D4 现态全部在位**，全树 grep 无同类错置残留（1 项观察级上报：阶段 1 骨架面 SystemToolsSettingsPage.axaml.cs:197 无参 `ShowAsync()`，§3.4）；(e) C1-C21 全树代码面 **0 命中**（19 处命中全部为已登记注记行）、D6 **零真实拖拽符号**（17 原始命中全分类：子串误匹配 5 + 登记注记 2 + A 面附件拖放 10；§4）；(f) **回归全过**：阶段 1 基线 119/119 零回退、168=119+49 精确闭合、文件集与 p2-08/p3-03 差集=0、注册面 37 调用/45 唯一 ID 不回退、Plugin.cs 零触碰（mtime 11:17:15 与 p3-01 开工基线一致）；阶段 3 时段产品文件改动集 = 申报整合面逐文件吻合（§5）；(g) 结构抽核：6 页 Binding 独立抽验 **16 处全解析**、禁用 using/namespace 镜像现态 E1=0/E2=0/163 文件镜像 0 违规（§6） |

---

## 1. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | 全树矩阵可重放 | Source 面 168 文件逐文件矩阵（§2.4，行行取自留档原始输出）；重放命令与原始输出留档齐备（§2.1/§8） | ✅ |
| 2 | GateHits=0 / CONDITIONAL=13 不变或差异上报 | GateHits=**0**；ConditionalHits=**13**，逐条与 p2-08 §3.1 file:line:rule 逐字节一致，**零差异、零超范围、零新增条件面**（§2.5） | ✅ |
| 3 | 共享 VM 887 行终态逐段核验 | 两批 5 段界标行号与申报完全一致；段内成员逐一在位；45 个声明零重名；:887 单一收口花括号；段外守卫修订 :166-191 在位（§3.1-3.3） | ✅ |
| 4 | 4 项修复现态 + 无同类错置残留 | D1-D4 全部在位；全树 grep 各修复符号全部落于带正确 using/形态的文件（§3.4） | ✅（附 1 项观察上报） |
| 5 | 裁剪面 C1-C21 全树 0 命中（注记豁免口径）+ D6 | 代码面 0 命中；19 处命中逐条=已登记注记行（p2-09/p3-01/p3-02 口径续登记）；D6 零真实拖拽符号（§4） | ✅ |
| 6 | 回归（119/168 + 注册面 37/45 + Plugin.cs 零触碰） | 119/119 零回退；168=119+49；vs p2-08/p3-03 文件集差=0；37 调用/45 唯一 ID；Plugin.cs mtime/行数/`#if` 与阶段 2 现态一致（§5） | ✅ |
| 7 | 批次自检一致性 | p3-01/p3-02 扫描输出 vs 本次直扫逐值一致；p3-03 复跑时点（04:37:58Z）早于 p3-02 收口（12:52:32 本地），差异解释在案（§5.4） | ✅ |
| 8 | 6 页 Binding 抽核 ≥10 处 | 独立抽验 **16 处**（3 方法重放 p3-06 §6-3），全部解析到真实成员（§6.1） | ✅ |

---

## 2. 全树权威逐文件门禁（R-2 口径）

### 2.1 方法与重放

- 扫描器：`.tang/cases/stcp-cross-platform-001/evidence/p0-07-s42-scan.ps1`（**R-2 版**，输出自证 `ScannerRev: R-2 (2026-09-03: R-1 single-file fix + R-2 PLATFORMS_WINDOWS conditional files…)`），本任务**零改动**使用（执行前后未做任何字节修改；§2.5 的 13 处 CONDITIONAL 逐字节一致性本身即扫描器未动的旁证）。
- 执行形态：本会话 pwsh 进程内以调用运算符 `&` 直接运行（嵌套 `pwsh -File` 受宿主命名管道边界限制——p0-07 §10.3 / p1-08 §2.1 / p2-08 §2.1 既有口径；扫描逻辑、判定语义、退出码不变）。
- 重放命令（复核方常规用法）：

  ```powershell
  pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
       -Path src\SystemTools.CrossPlatform -Scope Source
  # 实测：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、
  #       VERDICT: PASS (zero gate hits) [CONDITIONAL=13 R-2: …]、exit=0
  ```

- 原始输出留档（evidence/，均为 `&` 直跑 + `*>` 留档，无 harness 非零退出标记即 exit=0）：
  - `p3-08-s42-fulltree-source-output.txt`（权威主扫描，2026-09-04T05:50:13Z）
  - `p3-08-s42-fulltree-all-output.txt`（-Scope All 资产面回归）
  - `p3-08-s42-settingspage-replay-output.txt`（SettingsPage 目录直扫，对 p3-02 批命令原样重放）
  - `p3-08-file-matrix-rows.txt`（逐文件矩阵生成留档）、`p3-08-tree-source-filelist.txt`（树内 Source 面文件独立盘点清单）、`p3-08-plugin-unique-ids.txt`（45 唯一 ID 清单）

### 2.2 全树摘要

```
SourceFiles    : 168
AssetFiles     : 0    （-Scope Source 面；-Scope All 实测 AssetFiles=12、GateHits=0，§5.4）
GateHits       : 0
CommentOnly    : 6    （全部为 SystemTools.CrossPlatform.csproj:79，P01–P06 各 1 处——p0-04 §10 决策留痕注释，与 p0-07 §3 起逐阶段同值，未漂移）
InfoHits       : 2    （Views\SystemMotionPreferences.cs I04 :28/:43——SystemParametersInfo 机制观察规则，非门禁，R-2 §11.2 语义）
ConditionalHits: 13   （R-2 非门禁；逐文件清单见 §2.4 粗体行，逐条授权链对应见 §2.5）
VERDICT        : PASS (zero gate hits) [CONDITIONAL=13 R-2: verify against 06 documented items]   exit=0
```

GATE-HIT FILES = (none)。独立盘点（`Get-ChildItem -Recurse` 排 bin/obj/\.git，.cs/.csproj/.yml/.yaml）实测树内 Source 面文件 **168**，与扫描器计数一致（清单留档 `p3-08-tree-source-filelist.txt`）。

### 2.3 逐目录汇总

| 目录 | Source 面文件数 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | 结论 |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| （根）Plugin.cs / manifest.yml / csproj | 3 | 0 | 0 | 6（仅 csproj:79） | 0 | PASS |
| Actions\ | 31 | 0 | 8（SystemPowerCommandWindows） | — | 0 | PASS |
| Config\ | 2 | 0 | 0 | — | 0 | PASS |
| ConfigHandlers\ | 6 | 0 | 0 | — | 0 | PASS |
| Controls\ 平铺 | 26 | 0 | 0 | — | 0 | PASS |
| Controls\Components\ | 12 | 0 | 0 | — | 0 | PASS |
| Controls\Notifications\ | 1 | 0 | 0 | — | 0 | PASS |
| Converters\ | 1 | 0 | 0 | — | 0 | PASS |
| Models\ + Models\ComponentSettings\ | 8 | 0 | 0 | — | 0 | PASS |
| Rules\ + Rules\Handlers\ | 8 | 0 | 0 | — | 0 | PASS |
| Services\ | 21 | 0 | 3（ProcessMemoryMaintenanceNativeWindows 2、SystemShutdownMonitor 1） | — | 0 | PASS |
| Settings\ | 22 | 0 | 0 | — | 0 | PASS |
| SettingsPage\ | 8 | 0 | 0 | — | 0 | PASS |
| Shared\ | 1 | 0 | 0 | — | 0 | PASS |
| Themes\（3 主题目录） | 11 | 0 | 0 | — | 0 | PASS |
| Triggers\ | 2 | 0 | 0 | — | 0 | PASS |
| Version\ | 1 | 0 | 0 | — | 0 | PASS |
| Views\ | 4 | 0 | 2（SystemMotionPreferences） | — | 2（I04） | PASS |
| **合计** | **168** | **0** | **13** | **6** | **2** | **PASS** |

矩阵闭合核对：3+31+2+6+26+12+1+1+8+8+21+22+8+1+11+2+1+4 = **168** = 扫描器 SourceFiles 实测；与 p2-08 §2.3 逐目录逐值一致（阶段 3 零文件增删，§5.2）。

### 2.4 逐文件门禁矩阵（文件 × GateHits × CONDITIONAL × COMMENT-ONLY × INFO × VERDICT）

全部 168 行取自留档原始输出 `p3-08-s42-fulltree-source-output.txt` 的 CONDITIONAL/ZERO-HIT/COMMENT-ONLY/INFO 节（行序即原始输出 ZERO-HIT 节序，可重放核对）。164 个零命中文件 VERDICT 均 **PASS**；4 个条件文件 GateHits 亦为 0（guard 内命中计 CONDITIONAL，R-2 §11.2），VERDICT 同为 **PASS**。按 p3-03 X1/X2 裁决先例的逐文件标记：`Services\SystemShutdownMonitor.cs`、`Views\SystemMotionPreferences.cs` 两文件命名空间为同值双声明块（R-2 形态 a 条件文件 `#if/#else` 双分支同值承载）→ **X1 例外**；`Controls\InTimePeriodRuleSettingsControl.cs` code-behind 为 `<basename>.cs` 形态（阶段 1 先例）→ **X2 记录**（三文件在矩阵中以 ✎ 标注）。

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- | --- |
| Actions\ActionFlowExecutionConfirmationAction.cs | 0 | 0 | — | — | PASS |
| Actions\AdvancedShutdownAction.cs | 0 | 0 | — | — | PASS |
| Actions\AutoHideMainWindowWhenOccludedAction.cs | 0 | 0 | — | — | PASS |
| Actions\AutoSwitchClassIslandThemeAction.cs | 0 | 0 | — | — | PASS |
| Actions\BackgroundPlayAudioAction.cs | 0 | 0 | — | — | PASS |
| Actions\CancelShutdownAction.cs | 0 | 0 | — | — | PASS |
| Actions\ClearAllNotificationsAction.cs | 0 | 0 | — | — | PASS |
| Actions\CopyAction.cs | 0 | 0 | — | — | PASS |
| Actions\DeleteAction.cs | 0 | 0 | — | — | PASS |
| Actions\FullscreenClockAction.cs | 0 | 0 | — | — | PASS |
| Actions\ImmediateRestartAction.cs | 0 | 0 | — | — | PASS |
| Actions\ImmediateShutdownAction.cs | 0 | 0 | — | — | PASS |
| Actions\KillProcessAction.cs | 0 | 0 | — | — | PASS |
| Actions\LoadTemporaryClassPlanAction.cs | 0 | 0 | — | — | PASS |
| Actions\LockScreenAction.cs | 0 | 0 | — | — | PASS |
| Actions\MoveAction.cs | 0 | 0 | — | — | PASS |
| Actions\OpenAppSettingsAction.cs | 0 | 0 | — | — | PASS |
| Actions\OpenClassSwapWindowAction.cs | 0 | 0 | — | — | PASS |
| Actions\OpenProfileEditorAction.cs | 0 | 0 | — | — | PASS |
| Actions\ShowAiChatDialogAction.cs | 0 | 0 | — | — | PASS |
| Actions\ShowFloatingWindowAction.cs | 0 | 0 | — | — | PASS |
| Actions\ShowToastAction.cs | 0 | 0 | — | — | PASS |
| Actions\ShutdownAction.cs | 0 | 0 | — | — | PASS |
| Actions\SleepAction.cs | 0 | 0 | — | — | PASS |
| Actions\SwitchFloatingWindowThemeAction.cs | 0 | 0 | — | — | PASS |
| Actions\SystemPowerCommandStub.cs | 0 | 0 | — | — | PASS |
| Actions\SystemPowerCommandWindows.cs | 0 | **8**（R21 :48，R17 :50，R21 :56，R21 :60，R21 :64，R21 :68，R17 :72，R17 :77） | — | — | PASS |
| Actions\ToggleFloatingWindowLayerAction.cs | 0 | 0 | — | — | PASS |
| Actions\ToggleFloatingWindowProfileAction.cs | 0 | 0 | — | — | PASS |
| Actions\ToggleWorkflowAction.cs | 0 | 0 | — | — | PASS |
| Actions\TriggerCustomTriggerAction.cs | 0 | 0 | — | — | PASS |
| Config\ActionInProgressTriggerConfig.cs | 0 | 0 | — | — | PASS |
| Config\FloatingWindowTriggerConfig.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\ButtonRulesetConfig.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfile.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfileManager.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\MainConfigData.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\MainConfigHandler.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\RowRulesetConfig.cs | 0 | 0 | — | — | PASS |
| Controls\ActionFlowExecutionConfirmationSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AdvancedShutdownSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AiAttachmentDropConfirmation.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\AiAttachmentDropOverlay.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\BackgroundPlayAudioSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\Components\BetterCarouselContainerComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\BetterCarouselContainerSettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\ClipboardContentComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\ClipboardContentSettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\LocalQuoteComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\LocalQuoteSettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\NetworkStatusComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\NetworkStatusSettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\NextClassDisplayComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\NextClassDisplaySettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\ScrollingTextComponent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\Components\ScrollingTextSettingsControl.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\CopySettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\DeleteSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\FullscreenClockSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\InTimePeriodRuleSettingsControl.cs ✎X2 | 0 | 0 | — | — | PASS |
| Controls\KillProcessSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\LoadTemporaryClassPlanSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\MoveSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\Notifications\AiReplyNotificationContent.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\ProcessRunningRuleSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ShortcutKeyNotificationSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ShowFloatingWindowSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ShowToastSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ShutdownSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\SwitchFloatingWindowThemeSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ToggleFloatingWindowLayerSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ToggleFloatingWindowProfileSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\ToggleWorkflowSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\TriggerCustomTriggerSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\UsingClassPlanRuleSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\UsingTimeLayoutRuleSettingsControl.cs | 0 | 0 | — | — | PASS |
| Converters\EnumDescriptionConverter.cs | 0 | 0 | — | — | PASS |
| manifest.yml | 0 | 0 | — | — | PASS |
| Models\AiAttachment.cs | 0 | 0 | — | — | PASS |
| Models\AiConversation.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\BetterCarouselContainerSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\ClipboardContentSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\LocalQuoteSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\NetworkStatusSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\NextClassDisplaySettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\ScrollingTextSettings.cs | 0 | 0 | — | — | PASS |
| Plugin.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\InTimePeriodRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\ProcessRunningRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\UsingClassPlanRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\UsingTimeLayoutRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\InTimePeriodRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\ProcessRunningRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\UsingClassPlanRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\UsingTimeLayoutRuleSettings.cs | 0 | 0 | — | — | PASS |
| Services\AdaptiveThemeSyncService.cs | 0 | 0 | — | — | PASS |
| Services\AiAttachmentDropService.cs | 0 | 0 | — | — | PASS |
| Services\AiAttachmentService.cs | 0 | 0 | — | — | PASS |
| Services\AiChatOperationGate.cs | 0 | 0 | — | — | PASS |
| Services\AiChatWindowService.cs | 0 | 0 | — | — | PASS |
| Services\AiConversationStore.cs | 0 | 0 | — | — | PASS |
| Services\AiPromptService.cs | 0 | 0 | — | — | PASS |
| Services\ClassIslandActionAiService.cs | 0 | 0 | — | — | PASS |
| Services\ClassIslandMemoryAutoCleanupService.cs | 0 | 0 | — | — | PASS |
| Services\ClassIslandProfileAiService.cs | 0 | 0 | — | — | PASS |
| Services\FloatingWindowService.cs | 0 | 0 | — | — | PASS |
| Services\IOpenAiCompatibleService.cs | 0 | 0 | — | — | PASS |
| Services\IProcessMemoryMaintenanceService.cs | 0 | 0 | — | — | PASS |
| Services\MainWindowTextOcclusionService.cs | 0 | 0 | — | — | PASS |
| Services\OpenAiCompatibleService.cs | 0 | 0 | — | — | PASS |
| Services\ProcessMemoryMaintenanceNativeNoOp.cs | 0 | 0 | — | — | PASS |
| Services\ProcessMemoryMaintenanceNativeWindows.cs | 0 | **2**（R13 :25，X04 :25） | — | — | PASS |
| Services\ProcessMemoryMaintenanceService.cs | 0 | 0 | — | — | PASS |
| Services\SystemShutdownMonitor.cs ✎X1 | 0 | **1**（R03 :5） | — | — | PASS |
| Services\SystemToolsNotificationProvider.cs | 0 | 0 | — | — | PASS |
| Services\VirtualAfterSchoolService.cs | 0 | 0 | — | — | PASS |
| Settings\ActionFlowExecutionConfirmationSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ActionInProgressTriggerSettings.cs | 0 | 0 | — | — | PASS |
| Settings\AdvancedShutdownSettings.cs | 0 | 0 | — | — | PASS |
| Settings\AutoHideMainWindowWhenOccludedActionSettings.cs | 0 | 0 | — | — | PASS |
| Settings\AutoSwitchClassIslandThemeActionSettings.cs | 0 | 0 | — | — | PASS |
| Settings\BackgroundPlayAudioSettings.cs | 0 | 0 | — | — | PASS |
| Settings\CopySettings.cs | 0 | 0 | — | — | PASS |
| Settings\DeleteSettings.cs | 0 | 0 | — | — | PASS |
| Settings\FloatingWindowTriggerSettings.cs | 0 | 0 | — | — | PASS |
| Settings\FullscreenClockSettings.cs | 0 | 0 | — | — | PASS |
| Settings\KillProcessSettings.cs | 0 | 0 | — | — | PASS |
| Settings\LoadTemporaryClassPlanSettings.cs | 0 | 0 | — | — | PASS |
| Settings\MoveSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ShortcutKeyNotificationSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ShowFloatingWindowSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ShowToastSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ShutdownSettings.cs | 0 | 0 | — | — | PASS |
| Settings\SwitchFloatingWindowThemeSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ToggleFloatingWindowLayerSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ToggleFloatingWindowProfileSettings.cs | 0 | 0 | — | — | PASS |
| Settings\ToggleWorkflowSettings.cs | 0 | 0 | — | — | PASS |
| Settings\TriggerCustomTriggerSettings.cs | 0 | 0 | — | — | PASS |
| SettingsPage\AboutSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsViewModel.cs | 0 | 0 | — | — | PASS |
| SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\PluginDebugSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsViewModel.cs | 0 | 0 | — | — | PASS |
| Shared\GlobalConstants.cs | 0 | 0 | — | — | PASS |
| SystemTools.CrossPlatform.csproj | 0 | 0 | P01–P06 @ :79（6 处） | — | PASS |
| Themes\CardTypeComponent\CardTypeComponentStyles.cs | 0 | 0 | — | — | PASS |
| Themes\CardTypeComponent\manifest.yml | 0 | 0 | — | — | PASS |
| Themes\ClassWidgets\ClassWidgetsCard.axaml.cs | 0 | 0 | — | — | PASS |
| Themes\ClassWidgets\ClassWidgetsStyles.cs | 0 | 0 | — | — | PASS |
| Themes\ClassWidgets\manifest.yml | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\manifest.yml | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\NotchClipControl.cs | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\NotchFrameControl.cs | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\NotchMaterialControl.cs | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\NotchShapeGeometry.cs | 0 | 0 | — | — | PASS |
| Themes\NotchStyle\NotchStyleStyles.cs | 0 | 0 | — | — | PASS |
| Triggers\ActionInProgressTrigger.cs | 0 | 0 | — | — | PASS |
| Triggers\FloatingWindowTrigger.cs | 0 | 0 | — | — | PASS |
| Version\VersionCheckService.cs | 0 | 0 | — | — | PASS |
| Views\AdvancedShutdownDialog.axaml.cs | 0 | 0 | — | — | PASS |
| Views\AiChatFloatingWindow.axaml.cs | 0 | 0 | — | — | PASS |
| Views\ExtendShutdownDialog.axaml.cs | 0 | 0 | — | — | PASS |
| Views\SystemMotionPreferences.cs ✎X1 | 0 | **2**（R13 :41，X04 :41） | — | I04 :28/:43（2 处） | PASS |

✎X1 = p3-03 §3 X1 例外先例（R-2 形态 a 条件文件 `#if/#else` 双分支同值命名空间承载）；✎X2 = p3-03 §3 X2 先例（code-behind `<basename>.cs` 配对形态）。矩阵生成留档：`p3-08-file-matrix-rows.txt`。

### 2.5 CONDITIONAL=13 逐条授权链对应（发现差异 = 上报；本节判定：**零差异、零超范围**）

13 处命中与 p2-08 §3.1 权威基线**逐条 file:line:rule 逐字节一致**（本次主扫描 CONDITIONAL 节原文逐行比对），授权链沿用 p2-08 §3.1 已判定结论：

| # | 文件:行 | 规则 | 授权链锚点（p2-08 §3.1 判定） | 本次一致性 |
| --- | --- | --- | --- | --- |
| 1-8 | Actions\SystemPowerCommandWindows.cs :48/:50/:56/:60/:64/:68/:72/:77 | R21×5 + R17×3 | 06 条目 37/38/39/40/41/42/43 明示 shutdown/rundll32 命令族（04-spec U4 预检） | ✅ 逐字节一致 |
| 9-10 | Services\ProcessMemoryMaintenanceNativeWindows.cs :25 | R13 + X04 | 06 条目 49 明示 `psapi.dll!EmptyWorkingSet` P/Invoke | ✅ 逐字节一致 |
| 11 | Services\SystemShutdownMonitor.cs :5 | R03 | p2-05 §1.2 非计数附属 1 + p0-07 §11.1 R-2 裁定（06 条目 46 引用偏差注记见 p2-08 §3.3，维持原上报） | ✅ 逐字节一致 |
| 12-13 | Views\SystemMotionPreferences.cs :41 | R13 + X04 | 04-spec §S4.2:76 点名 + p2-05 §1.2 非计数附属 2 | ✅ 逐字节一致 |

**阶段 3 三批零新增条件面确证**：

| 批 | 申报 | 本次独立复核 |
| --- | --- | --- |
| p3-01（整合批 A） | "S4.2 扫描 GateHits=0 / CONDITIONAL=0；零 `#if` 写入"（§6.1/§7-②） | 其 3 交付 .cs（SystemToolsSettingsPage.axaml.cs / MoreFeaturesOptionsSettingsPage.axaml.cs / SystemToolsSettingsViewModel.cs）本次 `#if` 计数均 **0**，矩阵均 0/0 PASS |
| p3-02（整合批 B） | "零新增条件面：`#if\s+Platforms` grep=0；ConditionalHits=0"（§4-②） | 其 5 交付 .cs 本次 `#if` 计数均 **0**，SettingsPage 目录 8 文件直扫 0/0/0/0 PASS（`p3-08-s42-settingspage-replay-output.txt`） |
| p3-03（命名空间认证） | "S4.2 复跑 168/0/13 与 p2-08 逐项一致"（§4） | 本次全树 168/0/13 逐值一致，CONDITIONAL 集合差 = 0（§2.5 表） |

严格标记口径：4 个条件文件形态合规判定沿用 p2-08 §3.2（首个非空行裸 `#if Platforms_Windows` / 末行裸 `#endif` / `*Windows.cs` 双形态），guard 符号全部为编译生效形态 `Platforms_Windows`（R-2a 勘误）；两个 `#if !Platforms_Windows` 取反存根（SystemPowerCommandStub.cs、ProcessMemoryMaintenanceNativeNoOp.cs）零符号零命中。整树 CONDITIONS 落点未发生任何漂移——**差异 = 0，无需逐条上报授权链增量**。

---

## 3. 整合面专项：共享 VM 887 行终态逐段核验

对象：`src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs`——mtime 2026-09-04 12:52:32（= p3-01 §4.1 收口复读终版时点/p3-02 末笔写入时点），行数 **887**。本任务对全文件 887 行逐行读取核验（非抽样）。

### 3.1 两批 5 段界标与成员申报一致性（逐段核对）

| 段 | 申报区间（p3-01 §4 / p3-02 §5-1） | 实测界标行号 | 申报成员 → 实测定义行 | 一致性 |
| --- | --- | --- | --- | --- |
| p3-02 增补 I（页属类型段） | :25-66 | 开始 :25 / 结束 :66 | `FloatingTriggerItem`（_buttonId/_icon/_buttonName/_config 字段 + `IconSource` 计算属性 :43 + `OnIconChanged` :52）:33；`FloatingTriggerRow`（_buttons/_rowIndex/_rowRuleset，**D6 口径零拖拽状态**）:59 | ✅ |
| p3-01 增补（条目类型段） | :68-100 | 开始 :68 / 结束 :100 | `FeatureItemType` 枚举 :73（Action/Trigger/Component/Rule）；`UnifiedFeatureItem` :82（_id/_displayName/_isEnabled/_itemType/_groupName + `TypeDisplayName` :90） | ✅ |
| p3-02 增补 II（构造与订阅段） | :113-139 | 开始 :113 / 结束 :139 | `_floatingWindowService` :117、`_entriesChangedHandler` :118 字段；三参构造 :123-137（注入 FloatingWindowService，订阅 EntriesChanged → UIThread.Post(RefreshFloatingTriggers) :133-135）；两参构造 :107-111 保持 p1-06 原签名原函数体 | ✅ |
| p3-02 增补 III（页属成员段） | :193-690 | 开始 :193 / 结束 :690 | 17 成员逐一在位：`CurrentFloatingWindowProfile` :199、`FloatingWindowProfilesDirectory` :204、`AddFloatingWindowProfile` :207、`RemoveFloatingWindowProfile` :220、`FloatingTriggerRows` :242、`HasFloatingTriggerEntries` :245、`RefreshFloatingTriggers` :251、`OnButtonConfigPropertyChanged` :431、`OnRowRulesetPropertyChanged` :444、`NotifyRulesetStatusChanged` :457、`IsRulesetStateProperty` :462、`AddFloatingTriggerRow` :470、`InsertFloatingTriggerRow` :496、`RemoveFloatingTriggerRow` :530、`PersistFloatingTriggerRows` :573、`AreRowsEqual` :658、`Dispose` :682 | ✅ |
| p3-01 增补（主页功能管理抽屉消费面段） | :693-886 | 开始 :693 / 结束 :886 | `_featureItems` :700、`_featureSearchResults` :701、`IsFeatureSearchEmpty` :703、`_isFeatureDrawerOpen` :706、`_featureDrawerContent` :707、`InitializeFeatureItems` :720、`UpdateFeatureSearchResults` :840、`MatchesFeatureSearch` :853、`SaveFeatureSettings` :862 | ✅ |

段界标注释自declaration 与 p3-01/p3-02 证据互注齐备（:25-28/:68-70/:113-115/:193-196/:690-691/:693-698，含 :695-697 的 p3-08 交叉核对口径行——p3-01 段自declaration，p3-02 §5-1 互验引用）；抽屉枚举白名单计数独立复点：组件 6（:726-731）+ 触发器 2（:747/:752）+ 规则 4（:768-771）+ 行动 24 固定（:787-810）+ 条件行动 5（ShowAiChatDialog :815 + 悬浮窗族 4 :820-823）= **41 项**，与 p3-01 §1.1 / p3-06 §3.3 申报一致。

### 3.2 零重名 + 语法完整

- **零重名**：声明级提取 45 个成员名（方法/属性/字段），`Group-Object` 重复计数 = **0**（生成留证于本任务复核过程；声明清单与 §3.1 实测行号互证）；唯一同名称 = 两参/三参构造重载（C# 合法重载，p3-01 §4.2 / p3-02 §5-1 均已申报）。两批成员集合互斥：p3-02 段（2 类型 + 2 字段 + 3 参构造 + 17 成员）与 p3-01 段（2 类型 + 5 属性字段 + 4 方法）零同名定义——尚书省裁决③"零同名冲突、零定义重叠"在终态复核成立。
- **语法完整**：类体 :102 开启、:887 单一 `}` 收口（文件恰 887 行，末行为收口花括号）；全 887 行通读花括号配平、无截断/无重复闭合；p3-02 批收口后 Roslyn 语义级编译自检（输出 mtime 12:57:52，**晚于本文件全部末笔写入 12:52:51**）实测"本批 5 个交付 .cs error=0（warning=6 均为检查语境 [ObservableProperty] 字段伪影）、COMPILE OK"——即 **887 行终态已被语义级编译覆盖**（p3-02-supplementary-compile-check-output.txt 末行原文）。

### 3.3 段外守卫修订（SelectFloatingWindowProfile :166-191）

独立读取现态确证 p3-02 §5-2 申报：

| 核对点 | 实测 | 结论 |
| --- | --- | --- |
| 修订标记注释 | :173-176 明示"p3-02 修订（本批申报的悬浮窗方案面内）：当前方案文件存在性守卫，对齐 A3 行动…修订前骨架版此处误判目标方案文件存在性" | ✅ 在位 |
| 守卫形态 | :177 `if (_profileManager.ProfileFileExists(_profileManager.CurrentProfileName))` → :179 `SaveProfile()` + :180 `LoadProfile(profileName)`；else 分支 :184 仅 `LoadProfile(profileName)` | ✅ 与申报语义一致（只在当前方案文件还存在时才保存，防止被删方案复活；对齐 `Actions\ToggleFloatingWindowProfileAction.cs` 同款守卫） |
| 属性联动 | :189 `OnPropertyChanged(nameof(CurrentFloatingWindowProfileName))` + :190 `OnPropertyChanged(nameof(CurrentFloatingWindowProfile))` | ✅ 两条通知均在位（CurrentFloatingWindowProfile 属性 :199 定义于 p3-02 段内） |

### 3.4 4 项修复现态复核（D1-D4）+ 同类错置残留全树 grep

| # | 修复（p3-02 §6 申报） | 现态复核（本次 grep/读取） | 残留检查 |
| --- | --- | --- | --- |
| D1 | VM 文件头 + FloatingWindowEditorSettingsPage.axaml.cs 补 `using ClassIsland.Core.Abstractions.Services;` | VM **:6**、页 **:13** 均在位 | 全树 `IRulesetService` 使用点 11 处（VM:459、页:134/:141/:153/:453、FloatingWindowService:554/:573/:632/:919、BetterCarouselContainerComponent:25/:92）——4 个使用文件全部带该 using（VM:6 / 页:13 / FloatingWindowService.cs:10 / BetterCarouselContainerComponent.axaml.cs:14）。**零同类错置残留** |
| D2 | AiChatSettingsPage.axaml.cs 补 `using Avalonia.Input.Platform;` | **:9** 在位 | 全树 `SetTextAsync` 4 处（AiChatSettingsPage:161、AiChatFloatingWindow:321、KillProcessSettingsControl:179、ProcessRunningRuleSettingsControl:148）——4 个使用文件全部带该 using（:9/:10/:2/:9）。**零同类错置残留** |
| D3 | `LoadAndConfirmAsync(this)` → `TopLevel.GetTopLevel(this)` + 守卫 | AiChatSettingsPage.axaml.cs **:242** `var owner = TopLevel.GetTopLevel(this)`（守卫抛 InvalidOperationException）→ :244 传 `owner` | 全树 `LoadAndConfirmAsync` 调用 2 处：设置页（owner 形态）+ 浮窗先例 AiChatFloatingWindow:280（Window 直传 `this` 合法，Window 即 TopLevel）。**零同类错置残留** |
| D4 | FAContentDialog 无参 `ShowAsync()` → `ShowAsync(topLevel)` + TopLevel 守卫 | FloatingWindowEditorSettingsPage.axaml.cs **:208** `await dialog.ShowAsync(topLevel)` 在位 | 全树 FAContentDialog `.ShowAsync(` 12 处：p3 交付面（AiChat :321/:463/:540、悬浮窗编辑页 :208、主页 :184）全部 `ShowAsync(TopLevel)` 形态；其余为 `ShowAsync(owner)`（AiAttachmentDropService:39）、`ShowAsync(topLevel)`（FloatingWindowTriggerSettings:103、浮窗 :504/:581）与 `ShowAsync(showHosted: false)` bool 重载（ActionFlowExecutionConfirmationAction:142/:233，p1-06 先例，非无参弃用形态）。**观察级残留 1 处**，见下方上报 |

**观察级上报（不改判门禁、不属 p3-02 申报修复面）**：`SettingsPage\SystemToolsSettingsPage.axaml.cs:197`（`ShowAiMessageAsync` 静态辅助方法内）存在 `await dialog.ShowAsync();` 无参形态——该行位于 **p1-06 阶段 1 骨架段**（:206 p3-01 界标之前），非 p3-01/p3-02 交付段；该形态绑定 `ShowAsync(bool showHosted = false)` 合法重载、可编译（p3-01 批 Roslyn Round-W/N 判定面 error=0 含此文件），仅与 p3-02 D4 统一后的 `ShowAsync(TopLevel)` 形态不一致（潜在弃用告警面）。按派工边界"需订正处仅上报不自行改"：留证上报尚书省/门下省裁量是否随阶段 4 收口统一，本任务**零触碰**。

### 3.5 W9 图标大小范围 15-50 现态（权威输入随附核对）

`FloatingWindowEditorSettingsPage.axaml:199-201` 实测 `Minimum="15" / Maximum="50" / TickFrequency="1"`（申报落点 :193-212 区间内）；`MainConfigData.cs:395` `Math.Clamp(value, 15, 50)` 钳制面同值——与 p3-02 §1-W9/§7-3 "按『范围随源』取源实测 15-50"申报一致，p3-05 §2.2 W9 行的勘误修订请求现态成立。

---

## 4. 裁剪面终验

### 4.1 C1-C21 全树 0 命中复核（注记行豁免口径续 p2-09/p3-01/p3-02 登记）

方法：对 `src\` 全树（排 bin/obj，*.cs + *.axaml）按 p3-01 §2 / p3-02 §2 登记的特征符号组逐项 grep，命中行逐条人工分类（代码面 / 注记行）。

| 项 | 特征符号组 | 代码面命中 | 全部命中明细（含注记分类） |
| --- | --- | :-: | --- |
| C1 | EnableExperimentalFeatures / IsExperimentalModeActivated / ExperimentalBadge | **0** | 1 注记 = 共享 VM :718「EnableExperimentalFeatures 门随 C1 裁剪整块移除」（p3-01 §2 登记行） |
| C2 | EnableFfmpegFeatures | **0** | 无 |
| C3 | DownloadFfmpeg / IsFfmpegDownloadEnabled / OnDownloadFfmpegClick | **0** | 无 |
| C4 | EnableFaceRecognition / FaceRecognitionCredentialCleanup | **0** | 无 |
| C5 | DownloadFaceModels / IsFaceModelsDownloadEnabled | **0** | 无 |
| C6 | EnableWindowsHello / WindowsHelloService / WindowsHelloSupportStatus | **0** | 无 |
| C7 | DownloadVoskWorker / IsVoskWorkerDownloadEnabled / OnDownloadVoskWorkerClick | **0** | 无 |
| C8 | SpeechRecognitionDownloadOption / SelectedSpeechRecognitionModel / ConfirmSpeechRecognitionModelDownload | **0** | 无 |
| C9 | ShowDownloadProgress / DownloadStatusText / DownloadProgress | **0** | 无 |
| C10 | EnableVoiceWakeAi | **0** | 无 |
| C11 | AiWakeWord | **0** | 无 |
| C12 | AiConversationFloatingWindowStyle | **0** | 1 注记 = MainConfigData.cs:93「源 AI 液态玻璃成员…不增补」（p1-04/p2-05 既有登记） |
| C13 | DependencyPaths / TryBeginDownload / FindSpeechRecognitionModelDirectory / ShowMd5ErrorDialogAsync | **0** | 1 注记 = SystemToolsSettingsPage.axaml:255「DependencyPaths，C13 不迁」（p3-01 §1.4 A2 适配注记） |
| C14 | AutoCleanupSystemMemory / SystemMemoryCleanupThresholdPercent / SystemMemoryCleanupService / CleanSystemMemoryNow | **0** | 1 注记 = Plugin.cs:189「SystemMemoryCleanupService 与日志面——不随入」（阶段 2 裁剪注记先例） |
| C15 | AutoOpenUsbDriveOnInsert / UsbAutoPlayService | **0** | 4 注记 = Plugin.cs :188/:335/:517/:637「C 档未迁」注记（p3-01 §2 登记同清单） |
| C16 | FloatingWindowAppearanceStyle | **0** | 1 注记 = MainConfigData.cs:325（U5/R-6 降级决议注记） |
| C17 | FloatingWindowLiquidGlass / FloatingWindowGlassButtonScaleDip | **0** | 2 注记 = MainConfigData.cs :325/:326（同上注记块） |
| C18 | 行拖拽机制（单列见 §4.2 D6） | **0** | 见 §4.2 逐条分类 |
| C19 | VoiceInput / CanToggleVoiceInput / IsVoiceInputActive / VoiceInputToolTip | **0** | 无 |
| C20 | AboutTitleImageCacheService / Lyricify | **0** | 4 注记 = AboutSettingsPage.axaml:11、AboutSettingsPage.axaml.cs:24/:25（p3-02 §2-C20 更新后核验口径注记）、Plugin.cs:187（阶段 2 裁剪注记块） |
| C21 | PluginDebug 整页选项体 | **0** | 页面维持零绑定占位：`{Binding}` 计数 = **0**（p1-06 §4.1 + p3-02 §2-C21 收口文案现态） |

**结论：C1-C21 代码/UI/绑定/配置面全部 0 命中**；19 处注记级命中逐条对应 p2-09/p3-01/p3-02 已登记清单，零未登记残留、零功能面残留，无需移除动作。

### 4.2 D6 零真实拖拽符号复核

全树 grep `MoveFloatingTrigger|AddTriggerFromPool|DoDragDrop|_floatingDrag|FloatingTriggerRowDragOver|FloatingTriggerItemDrag|DragDrop\.`（大小写不敏感）：原始命中 **17 处**，逐条分类：

| 分类 | 处数 | 明细 | 判定 |
| --- | :-: | --- | --- |
| 大小写不敏感子串误匹配（`RemoveFloatingTriggerRow` 含子串 `moveFloatingTrigger`） | 5 | FloatingWindowEditorSettingsPage.axaml:114、.axaml.cs:264/:276、VM :529/:530——实为 W7「删除行」合法 API（p3-02 §2-C18 ① 同口径） | ✅ 非拖拽符号 |
| VM 内 D6 注记行（"MoveFloatingTrigger·AddTriggerFromPool 不迁"文字） | 2 | VM :195/:239（p3-02 §2-C18 ② 登记行） | ✅ 注记豁免 |
| DragDrop.* 附件拖放 A 面（p3-02 §3-2 + p1-04 浮窗先例） | 10 | AiChatSettingsPage.axaml:14-18、AiChatFloatingWindow.axaml:60-64（AllowDrop + DragEnter/Over/Leave/Drop） | ✅ A 面合法拖放，非 D6 行拖拽 |
| **真实拖拽机制符号（DoDragDrop/_floatingDrag*/FloatingTriggerRowDragOver/FloatingTriggerItemDrag/AddTriggerFromPool 代码）** | **0** | — | ✅ **D6 零真实存在复核通过** |

### 4.3 双分支 API 漂移红线 6 符号随附复扫

`MainWindowStylesAssist.IsBackgroundMaterialEnabled` 全树 **0 命中**；`FloatingWindowAppearanceStyle`/`FloatingWindowLiquidGlass`/`FloatingWindowGlassButtonScaleDip`/`AiConversationLiquidGlass`/`AiConversationApprovalButtonGlass` 仅命中 MainConfigData.cs :93/:325/:326 注记行（§4.1 C12/C16/C17 同源），**代码面 0**——与 p3-01 §3 红线结论一致，零漂移。

---

## 5. 回归与批次一致性

### 5.1 阶段 1 基线 119 文件零回退（对 p1-08 留档输出集合差）

方法：解析 `p1-08-s42-fulltree-source-output.txt` ZERO-HIT 节 119 文件清单，与本次直扫 168 文件集合做 `Compare-Object` 差集。

| 项 | 实测 |
| --- | --- |
| 阶段 1 基线文件数 | 119 |
| 本次树内零门禁命中文件数 | 168 |
| **基线文件中现已非零命中/缺失（回退）** | **0** —— 119/119 全部保持零门禁命中 |
| 本次新增文件（现 − 基线） | **49** —— 与 p2-08 §5.1 的 20+17+12 批次闭合一致；阶段 3 零新增文件（§5.2） |

### 5.2 全树文件集闭合（对 p2-08 订正后复扫 + p3-03 认证复跑）

| 对照留档 | 文件数 | `Compare-Object` 差集 |
| --- | ---: | --- |
| p2-08-s42-fulltree-source-postfix-output.txt（订正后权威复扫） | 168 | **0 行** |
| p3-03-s42-fulltree-source-output.txt（命名空间认证随附复跑） | 168 | **0 行** |

阶段 3 整合/裁剪/命名空间/文档四批均为既有文件编辑 + docs/ 新增，**零文件增删**——168 文件集自 p2-08 起恒定，本次独立盘点（`p3-08-tree-source-filelist.txt`）三方闭合。

### 5.3 注册面不回退 + Plugin.cs 零触碰

| 核对点 | p2-08 §7 基线 | 本次实测 | 一致性 |
| --- | --- | --- | --- |
| Plugin.cs mtime | —（阶段 2 现态） | **2026-09-04 11:17:15**，与 p3-01 §7-⑥ 开工基线 mtime 逐秒一致 | ✅ 阶段 3 全程零触碰 |
| Plugin.cs 行数 | 742 | **742** | ✅ |
| Plugin.cs `#if` 计数 | 0 | **0** | ✅ |
| `Register\w*IfEnabled` 提及 | 43 = 37 调用 + 4 辅助定义 + 1 doc + 1 region | **43**（37 调用 = 行动 29 + 触发器 2 + 组件 6；非调用 6 处逐条同位） | ✅ 不回退 |
| 引号 `"SystemTools\.` 引用 | 127 处 / 唯一 45 | **127 / 45**（唯一清单留档 `p3-08-plugin-unique-ids.txt`） | ✅ 不回退 |

### 5.4 各批自检一致性核对（p3-01/p3-02/p3-03 扫描输出 vs 本次直扫）

| 批次（留档输出时点） | 批内声明 | 本次直扫对应实测 | 一致性 |
| --- | --- | --- | --- |
| p3-01（TEMP 镜像 3 .cs，04:45:38Z） | SourceFiles=3、GateHits=0、ConditionalHits=0、PASS | 其 3 交付文件在本次全树矩阵均 0/0 PASS（§2.4）；`#if`=0（§2.5） | ✅ 一致 |
| p3-02（SettingsPage 目录 8 文件，04:59:23Z） | 8 文件、GateHits=0、ConditionalHits=0、PASS | 同命令原样重放（`p3-08-s42-settingspage-replay-output.txt`）：8/0/0/0 PASS，逐值一致 | ✅ 一致 |
| p3-03（全树，04:37:58Z） | 168/0/13/6/2 PASS | 本次 168/0/13/6/2 PASS 逐值一致；文件集差=0（§5.2） | ✅ 一致 |

**时点解释（派工预置事项）**：p3-03 的全树 S4.2 复跑时点 04:37:58Z（= 本地 12:37:58）**早于** p3-02 对共享 VM/页面的收口写入（12:52:32/12:52:51）与 p3-01 的 12:52 版复读——即 p3-03 认证的 168/0/13 反映的是并行批**在途中**树态。本次直扫为**终态**：两者计数逐值相同的原因是 p3-03 之后的两批写入均为既有零门禁命中文件内的内容编辑（VM 与各页 `#if`=0、零 §S4.2 符号引入——本次矩阵与 `#if` 复核即其证明），门禁相关内容零变化，故无差异需要归因；若后续复核发现差异，按本节时点表定位。

### 5.5 阶段 3 时段产品文件改动面盘点（边界现态）

对 `src\SystemTools.CrossPlatform` 全树（排 bin/obj）按 LastWriteTime ≥ 2026-09-04 12:00（阶段 3 时段）盘点，改动文件**恰为申报整合面**：

| 时段 | 文件 | 归属批 |
| --- | --- | --- |
| 12:36:01/:36:46 | SettingsPage\SystemToolsSettingsPage.axaml / .axaml.cs | p3-01 |
| 12:39:48/:40:19 | SettingsPage\MoreFeaturesOptionsSettingsPage.axaml / .axaml.cs | p3-01 |
| 12:39:20 | SettingsPage\FloatingWindowEditorSettingsPage.axaml | p3-02 |
| 12:42:02 | SettingsPage\AiChatSettingsPage.axaml（12:52:46 .axaml.cs） | p3-02 |
| 12:42:56 ×4 | SettingsPage\AboutSettingsPage.axaml / .axaml.cs、PluginDebugSettingsPage.axaml / .axaml.cs | p3-02 |
| 12:52:32 | SettingsPage\SystemToolsSettingsViewModel.cs（共享 VM） | p3-01 + p3-02 |

零触碰确证：**Plugin.cs 11:17:15、MainConfigData.cs 11:33:47（均为阶段 2 末态时点）、manifest.yml / csproj / global.json / slnx 均不在时段改动集内**；docs\coexistence-notes.md 13:20:10 为 p3-06 申报写入面。产品树零意外改动文件。

---

## 6. 结构抽核

### 6.1 6 页 axaml Binding 目标存在性抽核（16 处 ≥ 10 处要求；沿 p3-06 §6-3 悬空绑定重放 3 方法独立抽验）

方法：对 6 页 axaml 全量提取 `{Binding}` 路径（实测 92 处：主页 20 / 更多功能 8 / 悬浮窗编辑 28 / AiChat 31 / About 5 / PluginDebug **0**），独立抽验 16 处（覆盖全部 6 页 × 全部 4 类目标源：页属属性 / 共享 VM / 页属 VM / AiConversation 模型 / MainConfigData 配置根），逐处 grep 目标成员：

| # | 页:行 | 绑定路径 | 目标实测（文件:行） | 结论 |
| --- | --- | --- | --- | --- |
| 1 | 主页 :16 | ViewModel.IsFeatureDrawerOpen | 共享 VM :706 `[ObservableProperty] _isFeatureDrawerOpen` | ✅ |
| 2 | 主页 :194 | Config.EnableFloatingWindowFeature | MainConfigData.cs :332（p2-08 §6.2 枚举同位） | ✅ |
| 3 | 主页 :245/:260 | Config.AiModel | MainConfigData.cs :187 `public string AiModel` | ✅ |
| 4 | 更多功能 :25 | Config.AutoSwitchClassIslandTheme | MainConfigData.cs :252 | ✅ |
| 5 | 更多功能 :45 | Config.VirtualAfterSchoolEnabled | MainConfigData.cs :99 | ✅ |
| 6 | 更多功能 :87 | Config.AutoCleanupClassIslandMemory | MainConfigData.cs :291（p2-08/p3-01 同位） | ✅ |
| 7 | 悬浮窗 :24 | ViewModel.FloatingWindowProfileNames | 共享 VM :145 | ✅ |
| 8 | 悬浮窗 :76 | ViewModel.FloatingTriggerRows | 共享 VM :242 | ✅ |
| 9 | 悬浮窗 :67 | ViewModel.HasFloatingTriggerEntries | 共享 VM :245 | ✅ |
| 10 | 悬浮窗 :203 | ViewModel.Settings.FloatingWindowIconSize | MainConfigData.cs :390-397 钳制面（:395 实测） | ✅ |
| 11 | AiChat :27 | IsHistoryOpen | AiChatSettingsViewModel.cs :56 | ✅ |
| 12 | AiChat :37/:38 | Conversations / SelectedConversation | AiChatSettingsViewModel.cs :108 / :54 | ✅ |
| 13 | AiChat :63 | SelectedConversation.Messages | AVM :54 → AiConversation.cs :41 `Messages` | ✅ |
| 14 | AiChat :69/:80 | Content / DraftContent | AiConversation.cs :90 / :129 | ✅ |
| 15 | AiChat :186 | CanSend | AiChatSettingsViewModel.cs :118 | ✅ |
| 16 | About :42/:100/:115 | PluginVersion / SelectedTabIndex / IsHelpTab | AboutSettingsPage.axaml.cs :120/:121/:165（CurrentMarkdownContent :123 一并验证） | ✅ |

16/16 全解析，零悬空绑定；PluginDebug 页 0 绑定与 C21 占位口径一致（§4.1）。

### 6.2 禁用 using / namespace 镜像现态复核（p3-03 认证口径）

| 检查项 | p3-03 认证值 | 本次现态实测 | 一致性 |
| --- | --- | --- | --- |
| E1 `namespace (?!SystemTools\.CrossPlatform)` | 0 | **0** | ✅ |
| E2 `(global )?using SystemTools.(?!CrossPlatform)` | 0 | **0** | ✅ |
| 目录镜像（163 .cs 逐文件，大小写敏感比对期望 = `SystemTools.CrossPlatform[.目录]`） | 163/163、22 唯一值、0 违规 | **163 文件全检 0 违规**（含 X1 双声明文件按同值例外通过、X2 文件命名形态不影响 namespace 判定） | ✅ |
| 22 唯一命名空间文件数分布 | §2.1 表 | 抽核关键档位：Actions 31 / Services 21 / Settings 22 / SettingsPage 8 / Views 4 | ✅ 同值 |

注：p3-03 两脚本（namespace-audit / roslyn-parse-check）输出路径硬编码为 p3-03 批自身留档文件（脚本 :261/:267、:51/:56），重放将覆盖其权威证据；按证据边界本任务**不执行该脚本**，以同口径表达式独立复检（上表），X1/X2 仅作裁决先例标记（§2.4）。语法完整性现态由 §3.2 的 p3-02 收口后编译自检（12:57:52，晚于全部末笔写入）承载。

---

## 7. 写入清单与零改动声明

### 7.1 本任务写入（全部位于本案 evidence/）

| 文件 | 性质 |
| --- | --- |
| `p3-08-justice-filegates.md` | 本证据文件 |
| `p3-08-s42-fulltree-source-output.txt` / `p3-08-s42-fulltree-all-output.txt` | 权威全树主扫描（Source/All）原始输出（§2/§5.4） |
| `p3-08-s42-settingspage-replay-output.txt` | SettingsPage 目录直扫（对 p3-02 批命令原样重放，§5.4） |
| `p3-08-file-matrix-rows.txt` / `p3-08-tree-source-filelist.txt` / `p3-08-plugin-unique-ids.txt` | 矩阵生成留档 / 树内 Source 面独立盘点清单 / 45 唯一 ID 清单 |

### 7.2 零改动声明

- `src\SystemTools.CrossPlatform` 全树**零改动**（§5.5 时段盘点为旁证；本任务全部操作为读取/grep/扫描器只读运行）。
- 扫描器 `p0-07-s42-scan.ps1` 字节未动；未做任何规则改动以掩盖命中（亦无命中需要掩盖——GateHits=0）。
- p3-03 批留档（audit/roslyn 输出文件）未被重放覆盖（§6.2 注）。
- 原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha` 未触碰；未请求任何沙箱提权。

## 8. 复核方最小重放集

```powershell
# 1) 全树逐文件门禁（对照 §2.4 矩阵）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
#    预期：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、PASS、exit=0
# 2) 资产面回归：同脚本 -Scope All（预期 AssetFiles=12、GateHits=0、PASS）
# 3) SettingsPage 目录重放（对照 p3-02 批）：同脚本 -Path src\SystemTools.CrossPlatform\SettingsPage -Scope Source
# 4) 共享 VM 终态：行数=887；界标行号 25/66/68/100/113/139/193/690/693/886；:887 收口 `}`；:177 守卫；:6 D1 using
# 5) 修复残留：全树 grep IRulesetService/SetTextAsync/LoadAndConfirmAsync/\.ShowAsync\( 对照 §3.4
# 6) 裁剪面：按 §4.1 符号组全树 grep（代码面应 0；注记行清单逐条对照）
# 7) 回归：p1-08 留档 ZERO-HIT 119 文件 vs 本次扫描集合差=0；Plugin.cs mtime 11:17:15 / 742 行 / 37 调用 / 45 唯一 ID
# 8) Binding 抽核：§6.1 表逐行重放；namespace 镜像：§6.2 E1/E2 表达式（预期 0/0）
```

## 9. 上报事项汇总

1. **门禁结论**：GateHits=0；CONDITIONAL=13 与 p2-08 基线逐字节一致，零超范围、零新增条件面；无差异需上报授权链增量。p2-08 §3.3 的既有引用级偏差注记（SystemShutdownMonitor"06 条目 46"编号笔误）维持原状，随本证据一并提请尚书省/门下省终检知悉。
2. **观察级 1 项**（非门禁失败、不属 p3 批申报修复面）：SystemToolsSettingsPage.axaml.cs:197（阶段 1 骨架段）`FAContentDialog.ShowAsync()` 无参形态与 p3-02 D4 统一后的 `ShowAsync(TopLevel)` 形态不一致；可编译（bool 重载），建议阶段 4 收口裁量是否统一。本任务按边界零触碰。
3. **申报级文本勘误 1 项**（零功能影响）：p3-02 §5-1"文件头 using 增补 :1-9"与现态 :1-10（10 行 using = 原 3 + 增补 7）存在 1 行区间计数偏差；7 行增补 using 的名单与在位性（§3.1/§3.4-D1）逐行核实无误，属申报文本区间 off-by-one，本任务不改写 p3-02 证据文本，仅于此留证备查。
4. 批次一致性零分歧（§5.4）；阶段 1 基线 119/119 零回退（§5.1）；阶段 3 时段产品文件改动面与申报整合面逐文件吻合（§5.5）。
5. 本文件不推进、不审批全局工作流；属批级验证证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。

## 10. 修订记录

- 初版（p3-08 执行交付；基于本轮全树 R-2 直扫 Source/All、共享 VM 887 行全文件通读、D1-D4/C1-C21/D6 全树 grep、p1-08/p2-08/p3-03 基线集合差、注册面复核、16 处 Binding 抽验与 namespace 镜像复检）。
