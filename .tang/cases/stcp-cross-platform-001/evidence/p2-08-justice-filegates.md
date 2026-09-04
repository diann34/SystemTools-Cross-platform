# p2-08 证据：阶段 2 B 档逐文件 S4.2 门禁留证与回归（刑部 quality-security / verification）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-08 · 刑部 justice · quality-security / verification（R-2 口径首次权威全树执行；依赖 p2-01/p2-02/p2-03/p2-06，均已记录 succeeded，全部实施面已落盘） |
| 权威输入 | p0-07-quality-gates.md §11（R-2 条件文件口径 + R-2a 勘误：guard 符号规范 = `Platforms_Windows`）；p0-07 38 规则扫描器（R-2 版，本任务零改动使用）；p1-08-justice-filegates.md（阶段 1 终态基线：119 文件 / GateHits=0）；p2-01/p2-02/p2-03/p2-06 各批自检输出（交叉参照，不替代本次独立执行）；04-spec §S4.2:61（B 档 Windows 专属点允许位）与 :76；06 条目 37–43（电源族）/44/46/49（条目 46 引用偏差见 §3.3） |
| 工作区 | `E:\My Github Projects\SystemTools-Cross-platform`（写入面 = 本案 evidence/ + 两处经授权的注释一行订正，§6） |
| 只读面 | `src\SystemTools.CrossPlatform` 全树（除 §6 两处注释订正外零改动）；原插件与宿主检出（未触碰）；扫描器 `p0-07-s42-scan.ps1`（字节未动） |
| 结论 | **succeeded** —— (a) 全树 Source 面 **168/168 文件逐文件矩阵全 PASS**（GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6，exit=0；§2）；(b) **CONDITIONAL=13 逐条对应 06 明示项/授权链，零超范围**（§3）；(c) B 档新增面专项核对通过：电源命令族为纯命令启动（零 DllImport 面）、EmptyWorkingSet psapi 互操作 guard 内、文件夹递归 BCL 化零进程启动（§4）；(d) **基线回归 PASS**：阶段 1 的 119 文件零回退，全树 168 = 119 + 49 精确闭合（§5）；(e) 两处已知提及点**均裁量订正**（注释一行/一词，复扫零影响留证，§6）；(f) 结构抽核独立复验零违规（§7） |

---

## 1. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | 全树逐文件矩阵覆盖且可重放 | Source 面 168 文件（= 163 .cs + 4 .yml + 1 .csproj）逐文件 VERDICT 全 PASS；重放命令与原始输出留档齐备（§2） | ✅ |
| 2 | GateHits=0 / CONDITIONAL=13 且逐条 06 对应留证 | GateHits=**0**；CONDITIONAL=**13** = p2-01 10 + p2-03 3，逐条判定见 §3；**超范围 CONDITIONAL = 0** | ✅ |
| 3 | 基线回归 PASS | 阶段 1 的 119 文件全部仍零命中（回归数=0）；全树文件集 168 = 119 + 49（20+17+12 批次闭合）；与 p2-03 全树输出集合差=0（§5） | ✅ |
| 4 | 提及点处置留痕 | 两处均订正（:9 一词 + :304 一数），复扫零影响（§6） | ✅ |
| 5 | 结构抽核（ID 前缀/namespace 镜像/禁用 using） | Plugin.cs 742 行、37 注册调用、零 `#if`；163 .cs namespace 镜像 0 违规；禁用 using 0（§7） | ✅ |

---

## 2. 全树权威逐文件 S4.2 门禁（R-2 口径）

### 2.1 方法与重放

- 扫描器：`.tang/cases/stcp-cross-platform-001/evidence/p0-07-s42-scan.ps1`（**R-2 版**，输出自证 `ScannerRev: R-2 (…R-1 single-file fix + R-2 PLATFORMS_WINDOWS conditional files…)`），本任务**零改动**使用。
- 执行形态：本会话 pwsh 进程内以调用运算符 `&` 直接运行（嵌套 `pwsh -File` 受宿主命名管道边界限制——p0-07 §10.3 / p1-08 §2.1 / p2-02 §4.1 既有口径；扫描逻辑、判定语义、退出码不变）。
- 重放命令（复核方常规用法）：

  ```powershell
  pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
       -Path src\SystemTools.CrossPlatform -Scope Source
  # 实测：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、
  #       VERDICT: PASS (zero gate hits) [CONDITIONAL=13 R-2: …]、exit=0
  ```

- 原始输出留档（evidence/，均为 `&` 直跑捕获 + `*>` 留档，无 harness 非零退出标记即 exit=0）：
  `p2-08-s42-fulltree-source-output.txt`（权威主扫描，2026-09-04T03:29:29Z）、`p2-08-s42-fulltree-all-output.txt`（-Scope All 回归）、4 个条件文件单文件输出、2 个提及点订正后单文件输出、`p2-08-s42-fulltree-source-postfix-output.txt`（订正后全树复扫）。

### 2.2 全树摘要

```
SourceFiles    : 168
AssetFiles     : 0    （-Scope Source 面；-Scope All 实测 AssetFiles=12、GateHits=0，§5.4）
GateHits       : 0
CommentOnly    : 6    （全部为 SystemTools.CrossPlatform.csproj:79，P01–P06 各 1 处——p0-04 §10 决策留痕注释，与 p0-07 §3 起逐阶段同值，未漂移）
InfoHits       : 2    （Views\SystemMotionPreferences.cs I04 :28/:43——SystemParametersInfo 机制观察规则，非门禁，R-2 §11.2 语义）
ConditionalHits: 13   （R-2 非门禁；逐文件清单见下，逐条 06 对应判定见 §3）
VERDICT        : PASS (zero gate hits) [CONDITIONAL=13 R-2: verify against 06 documented items]   exit=0
```

GATE-HIT FILES = (none)。树内非 bin/obj 文件总数与各批交付和精确闭合：阶段 1 终态 152（p1-08 §2.2）+ 本阶段新增 49（p2-01 20 .cs 新文件 + p2-02 17 + p2-03 12；p2-01 的"21 .cs"计含 MainConfigData 增补修改、p2-06 仅改写既有 Plugin.cs，均不增文件）= **201**；Source 面 **168**。

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

矩阵闭合核对：3+31+2+6+26+12+1+1+8+8+21+22+8+1+11+2+1+4 = **168** = 扫描器 SourceFiles 实测。

### 2.4 逐文件门禁矩阵（文件 × GateHits × CONDITIONAL × COMMENT-ONLY × INFO × VERDICT）

全部行取自留档原始输出 `p2-08-s42-fulltree-source-output.txt` 的 CONDITIONAL/ZERO-HIT/COMMENT-ONLY 节（可重放核对）。164 个零命中文件 VERDICT 均 **PASS**；4 个条件文件 GateHits 亦为 0（guard 内命中计 CONDITIONAL，R-2 §11.2），VERDICT 同为 **PASS**。

**（根）——3 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Plugin.cs | 0 | 0 | — | — | PASS |
| manifest.yml | 0 | 0 | — | — | PASS |
| SystemTools.CrossPlatform.csproj | 0 | 0 | P01–P06 @ :79（6 处） | — | PASS |

**Actions\ ——31 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
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
| **Actions\SystemPowerCommandWindows.cs** | 0 | **8**（R21 ×5 :48/:56/:60/:64/:68 + R17 ×3 :50/:72/:77，均 `#if Platforms_Windows` guard 内） | — | — | PASS |
| Actions\ToggleFloatingWindowLayerAction.cs | 0 | 0 | — | — | PASS |
| Actions\ToggleFloatingWindowProfileAction.cs | 0 | 0 | — | — | PASS |
| Actions\ToggleWorkflowAction.cs | 0 | 0 | — | — | PASS |
| Actions\TriggerCustomTriggerAction.cs | 0 | 0 | — | — | PASS |

**Config\ ——2 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Config\ActionInProgressTriggerConfig.cs | 0 | 0 | — | — | PASS |
| Config\FloatingWindowTriggerConfig.cs | 0 | 0 | — | — | PASS |

**ConfigHandlers\ ——6 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| ConfigHandlers\ButtonRulesetConfig.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfile.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfileManager.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\MainConfigData.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\MainConfigHandler.cs | 0 | 0 | — | — | PASS |
| ConfigHandlers\RowRulesetConfig.cs | 0 | 0 | — | — | PASS |

**Controls\ 平铺 ——26 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Controls\ActionFlowExecutionConfirmationSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AdvancedShutdownSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AiAttachmentDropConfirmation.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\AiAttachmentDropOverlay.axaml.cs | 0 | 0 | — | — | PASS |
| Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\BackgroundPlayAudioSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\CopySettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\DeleteSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\FullscreenClockSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\InTimePeriodRuleSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\KillProcessSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\LoadTemporaryClassPlanSettingsControl.cs | 0 | 0 | — | — | PASS |
| Controls\MoveSettingsControl.cs | 0 | 0 | — | — | PASS |
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

**Controls\Components\ ——12 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
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

**Controls\Notifications\ ——1 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Controls\Notifications\AiReplyNotificationContent.axaml.cs | 0 | 0 | — | — | PASS |

**Converters\ ——1 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Converters\EnumDescriptionConverter.cs | 0 | 0 | — | — | PASS |

**Models\ + Models\ComponentSettings\ ——8 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Models\AiAttachment.cs | 0 | 0 | — | — | PASS |
| Models\AiConversation.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\BetterCarouselContainerSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\ClipboardContentSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\LocalQuoteSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\NetworkStatusSettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\NextClassDisplaySettings.cs | 0 | 0 | — | — | PASS |
| Models\ComponentSettings\ScrollingTextSettings.cs | 0 | 0 | — | — | PASS |

**Rules\ + Rules\Handlers\ ——8 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Rules\Handlers\InTimePeriodRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\ProcessRunningRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\UsingClassPlanRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\Handlers\UsingTimeLayoutRuleHandler.cs | 0 | 0 | — | — | PASS |
| Rules\InTimePeriodRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\ProcessRunningRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\UsingClassPlanRuleSettings.cs | 0 | 0 | — | — | PASS |
| Rules\UsingTimeLayoutRuleSettings.cs | 0 | 0 | — | — | PASS |

**Services\ ——21 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
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
| **Services\ProcessMemoryMaintenanceNativeWindows.cs** | 0 | **2**（R13+X04 均 :25，guard 内） | — | — | PASS |
| Services\ProcessMemoryMaintenanceNativeNoOp.cs | 0 | 0 | — | — | PASS |
| Services\ProcessMemoryMaintenanceService.cs | 0 | 0 | — | — | PASS |
| Services\OpenAiCompatibleService.cs | 0 | 0 | — | — | PASS |
| Services\IProcessMemoryMaintenanceService.cs | 0 | 0 | — | — | PASS |
| **Services\SystemShutdownMonitor.cs** | 0 | **1**（R03 :5，Windows 分支 guard 内） | — | — | PASS |
| Services\SystemToolsNotificationProvider.cs | 0 | 0 | — | — | PASS |
| Services\VirtualAfterSchoolService.cs | 0 | 0 | — | — | PASS |
| Services\MainWindowTextOcclusionService.cs | 0 | 0 | — | — | PASS |

**Settings\ ——22 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
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

**SettingsPage\ ——8 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| SettingsPage\AboutSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsViewModel.cs | 0 | 0 | — | — | PASS |
| SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\PluginDebugSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsPage.axaml.cs | 0 | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsViewModel.cs | 0 | 0 | — | — | PASS |

**Shared\ ——1 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Shared\GlobalConstants.cs | 0 | 0 | — | — | PASS |

**Themes\（3 目录）——11 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
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

**Triggers\ ——2 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Triggers\ActionInProgressTrigger.cs | 0 | 0 | — | — | PASS |
| Triggers\FloatingWindowTrigger.cs | 0 | 0 | — | — | PASS |

**Version\ + Views\ ——5 文件**

| 文件 | GateHits | CONDITIONAL | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | ---: | --- | ---: | --- |
| Version\VersionCheckService.cs | 0 | 0 | — | — | PASS |
| Views\AdvancedShutdownDialog.axaml.cs | 0 | 0 | — | — | PASS |
| Views\AiChatFloatingWindow.axaml.cs | 0 | 0 | — | — | PASS |
| Views\ExtendShutdownDialog.axaml.cs | 0 | 0 | — | — | PASS |
| **Views\SystemMotionPreferences.cs** | 0 | **2**（R13+X04 均 :41，guard 内） | — | 2（I04 :28/:43） | PASS |

---

## 3. CONDITIONAL=13 逐条 06 对应判定（发现超范围 = 上报；本节判定：**零超范围**）

### 3.1 逐条判定表

扫描器不承载"是否属 06 明示项"的业务裁定（p0-07 §11.2 第 2 条）；本节为刑部 verification 角色按留证清单逐条核对的处置上报。

| # | 文件:行 | 规则 | 命中内容 | 功能项 | 06/规范对应锚点 | 判定 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Actions\SystemPowerCommandWindows.cs:48 | R21 | `File.Exists(GetSystemToolPath("shutdown.exe"))` | B4/B5/B6/B8/B9 共用 U4 预检 | 06 条目 37/38/39/41/42 明示 shutdown 命令族；04-spec U4:90 预检要求 | ✅ 属 06 明示 Windows-专属行为 |
| 2 | Actions\SystemPowerCommandWindows.cs:50 | R17 | `File.Exists(GetSystemToolPath("rundll32.exe"))` | B7/B10 共用 U4 预检 | 06 条目 40/43；U4 预检 | ✅ 同上 |
| 3 | Actions\SystemPowerCommandWindows.cs:56 | R21 | `Run("shutdown.exe", "/s /t {seconds}")` | B4 计时关机 | 06 条目 37 替换目标"Windows 使用 `shutdown.exe /s /t <seconds>`" | ✅ 明示 |
| 4 | Actions\SystemPowerCommandWindows.cs:60 | R21 | `Run("shutdown.exe", "/s /t 0")` | B9 立即关机 | 06 条目 42（源 ntdll 未随入 → 命令等价，尚书省裁决 1，p2-01 §2-A2） | ✅ 明示（替换目标面） |
| 5 | Actions\SystemPowerCommandWindows.cs:64 | R21 | `Run("shutdown.exe", "/g /t 0")` | B8 立即重启 | 06 条目 41（表述 /r /t 0；裁决口径 /g /t 0，差异已留痕 p2-01 §9-4，同族命令启动） | ✅ 明示（差异已批留痕） |
| 6 | Actions\SystemPowerCommandWindows.cs:68 | R21 | `Run("shutdown.exe", "/a")` | B6 取消关机计划（B5 取消路径同族） | 06 条目 39/38（"`shutdown /a`"） | ✅ 明示 |
| 7 | Actions\SystemPowerCommandWindows.cs:72 | R17 | `Run("rundll32.exe", "user32.dll,LockWorkStation")` | B7 锁定屏幕 | 06 条目 40（源 :29-30 rundll32 形态随源保持，裁决 1） | ✅ 明示 |
| 8 | Actions\SystemPowerCommandWindows.cs:77 | R17 | `Run("rundll32.exe", "powrprof.dll,SetSuspendState 0,1,0")` | B10 睡眠 | 06 条目 43（源 :21-30 明示 `rundll32.exe powrprof.dll,SetSuspendState`） | ✅ 明示 |
| 9 | Services\ProcessMemoryMaintenanceNativeWindows.cs:25 | R13 | `[DllImport("psapi.dll", SetLastError = true)]` | 项 49 工作集修剪 | 06 条目 49 明示"P/Invoke `psapi.dll!EmptyWorkingSet`"（06:337-341） | ✅ 明示 |
| 10 | Services\ProcessMemoryMaintenanceNativeWindows.cs:25 | X04 | 同上（`"psapi.dll"` 原生库名字符串形态） | 项 49 | 同上（X04 为 ⑧ 加强同族） | ✅ 明示 |
| 11 | Services\SystemShutdownMonitor.cs:5 | R03 | `using System.Windows.Forms;` | B5 看门狗替换承载（会话结束监控） | 授权链 = p2-05 §1.2 非计数附属 1 明示该文件 WinForms 面为 B 档 Windows 专属点候选（S3-R4/G2 no-op 降级分支）+ p0-07 §11.1 R-2 裁定明示 SystemShutdownMonitor Windows 会话消息路径；功能锚 = 06 条目 38"看门狗改用宿主生命周期事件" | ✅ 属授权范围（引用级偏差注记见 §3.3，非超范围） |
| 12 | Views\SystemMotionPreferences.cs:41 | R13 | `[DllImport("user32.dll", SetLastError = false)]` | B11 附属动效偏好查询（源 :27-31 随批交付） | 04-spec §S4.2:76 明示点名 `SystemMotionPreferences.cs` 守卫形态可保留；p2-05 §1.2 非计数附属 2 明示"user32 `SystemParametersInfo` DllImport" | ✅ 属授权范围 |
| 13 | Views\SystemMotionPreferences.cs:41 | X04 | 同上（`"user32.dll"` 字符串形态） | 同上 | 同上 | ✅ 属授权范围 |

### 3.2 判定补充说明

- **形态合规**（R-2 §11.2 第 1 条，逐文件独立读取确证）：4 个条件文件首个非空行均为裸 `#if Platforms_Windows`（SystemPowerCommandWindows.cs:1、ProcessMemoryMaintenanceNativeWindows.cs:1、SystemMotionPreferences.cs:1）或首个非空行为裸 guard、末个非空行为裸 `#endif`（SystemShutdownMonitor.cs:1→:135，其间 :100 `#else` 为非 Windows no-op 护栏分支，其内零门禁符号）；guard 符号全部为编译生效形态 `Platforms_Windows`（R-2a 勘误口径）。SystemPowerCommandWindows.cs 与 ProcessMemoryMaintenanceNativeWindows.cs 同为**双形态合格**（全文件包裹 + `*Windows.cs` 命名）。
- **从严条款逐项满足**：guard 外零命中、`#else` 分支零命中、非两形态文件零内部 guard 命中（本次 GateHits=0 与 13 处 CONDITIONAL 全部落于上表 guard 内即其证明）；两个 `#if !Platforms_Windows` 取反存根（SystemPowerCommandStub.cs、ProcessMemoryMaintenanceNativeNoOp.cs）零符号零命中。
- **INFO=2**：SystemMotionPreferences.cs I04（SystemParametersInfo 机制观察）——I 规则非门禁（p0-07 §2.2 判定语义 4），与该文件 R13/X04 同源机制，写实留证。
- **CommentOnly=6**：csproj:79 P01–P06（p0-04 §10 决策留痕注释），与 p0-07 §3 以来的历次基线同值同位置，未漂移。

### 3.3 上报事项（引用级偏差注记，不改变门禁结论，不属超范围 CONDITIONAL）

p0-07 §11.1（R-2 授权文本）与 p2-03 §1.4 均将 SystemShutdownMonitor 的 Windows 会话消息路径标注为"06 条目 46"；经本次独立核对，**06 文档自身条目 46 为「从悬浮窗触发」**（06:317-321），且 06 全文无 SystemShutdownMonitor 字样。该 Windows 专属点的真实授权链为：**尚书省预批的阶段 2 落点权威表 p2-05 §1.2（非计数附属 1 行，明示 WinForms 面与 S3-R4/G2 no-op 降级分支）+ p0-07 §11.1 R-2 裁定**（点名 SystemShutdownMonitor 会话消息路径为合格条件文件用途），功能语义服务于 06 条目 38 的看门狗替换（宿主生命周期事件 → 会话结束检测）。属**交叉引用编号笔误**级偏差，条件文件用途本身在授权范围内、非超范围 CONDITIONAL；建议尚书省/门下省在终检时以 p2-05 §1.2 + R-2 裁定为对应依据（本任务不改写 p0-07/p2-03 既有证据文本，仅于此留证）。

---

## 4. B 档新增面专项核对（派工重点 2）

### 4.1 电源命令族（rundll32/shutdown.exe 命令启动——非 DllImport 面）

独立读取 `Actions\SystemPowerCommandWindows.cs`（110 行）全文确证：

| 核对点 | 实测 | 结论 |
| --- | --- | --- |
| 命中性质 | 全部 8 处命中均为**进程名字符串**：2 处 `File.Exists(GetSystemToolPath(…))` 命令存在性预检（U4，不触发动作）+ 6 处 `Run("shutdown.exe"/"rundll32.exe", args)`；`Run` 内为 `ProcessStartInfo { FileName, UseShellExecute = false, CreateNoWindow = true }` + `Process.Start` + 有界等待退出码 | ✅ 纯命令启动面，§S4.2 条款 ⑨；**非 DllImport 面** |
| DllImport 互操作族 | 全文 R13/R14/X04 **零命中**（无任何 `DllImport`/`LibraryImport`/原生库名字符串） | ✅ 命令族未夹带互操作 |
| 归属集中度 | 7 项电源行动（B4–B10）的 Windows 启动面全部收敛于此单一条件文件；各行动壳文件本体零命中（矩阵 §2.4） | ✅ 与 p2-01 §2-A9"收敛为条件文件"一致 |
| 跨 TFM 闭合 | 成对存根 `SystemPowerCommandStub.cs`（`#if !Platforms_Windows` 全包裹，34 行）零门禁符号、恒 false/-1，与实现文件 guard 为同一 `Platforms_Windows` 符号对称面（防 CS0101） | ✅ |
| R21/R17 计 CONDITIONAL 合规性 | 命中处文件名 `*Windows.cs` + 全文件裸包裹（双形态合格），命中行均在正向 guard 内；`Run` 参数含 `/s /t`、`/a`、`/g /t 0` 等，无 `cmd`、无 shell 拼接（X01 零命中） | ✅ R-2 口径合规 |

### 4.2 EmptyWorkingSet psapi 互操作（R13/X04 guard 内）

独立读取 `Services\ProcessMemoryMaintenanceNativeWindows.cs`（46 行）确证：

- `:25` `[DllImport("psapi.dll", SetLastError = true)]` + `:26` `EmptyWorkingSet(IntPtr)` 声明，`:30` 调用点前 `OperatingSystem.IsWindows()` 运行时二次守卫（防御性双保险，编译期隔离由 guard 承担），`:37` 调用、异常吞并返回 false（06 条目 49 降级口径"只跳过工作集操作并保留 GC/测量"）。
- 与 06 条目 49（06:337-341"源 :22-23 P/Invoke `psapi.dll!EmptyWorkingSet`"）逐点对应；与源承载位置声明一致（p2-01 §1.3/§2-A1）。
- 成对 no-op `ProcessMemoryMaintenanceNativeNoOp.cs`（`#if !Platforms_Windows`，恒 false）零符号；外壳 `ProcessMemoryMaintenanceService.cs`/接口 `IProcessMemoryMaintenanceService.cs` 无条件文件零命中（注册面免平台条件代码护栏，p1-10 §12.5）。

### 4.3 文件夹递归 BCL 化零进程启动复核（p2-02 面）

- 独立检索 `Actions\` 全目录 `Process\.Start|ProcessStartInfo|UseShellExecute|cmd|robocopy|shell`：代码级 `Process.Start`/`ProcessStartInfo` **仅存在于条件文件 SystemPowerCommandWindows.cs**（§4.1）；CopyAction/MoveAction/DeleteAction 的检索命中全部为**适配注记注释**（描述"源经 shell 子进程调用外部命令行工具 → 改为 BCL 直传"的已删机制），零实际进程启动代码；AdvancedShutdownAction.cs:30 注释提及"cmd 倒计时"为源机制描述性文字，不含 `cmd.exe`/`cmd /c` 形态（R15/X01 零命中，扫描输出在位即证）。
- BCL 替换面抽读：CopyAction（File.Copy + 子目录递归，guard :118 自递归防护）、MoveAction（Directory.Move 同卷优先 + 跨卷递归复制回退）、DeleteAction（Directory.Delete(recursive:true)）——与 p2-02 §2-AD5/AD6/AD7 登记一致；三文件 GateHits=0、CONDITIONAL=0（矩阵 §2.4），**06 条目 34/35/36"非 shell 拼接的安全边界"达成**。

---

## 5. 基线回归与批次一致性

### 5.1 阶段 1 基线 119 文件零回退（与 p1-08 §2.4 矩阵逐文件对照）

方法：解析 p1-08 留档原始输出（`p1-08-s42-fulltree-source-output.txt`）ZERO-HIT 节 119 文件清单与本任务 ZERO-HIT+CONDITIONAL（全 168 文件 GateHits=0）集合做差集（本会话脚本，逻辑可重放）。

| 项 | 实测 |
| --- | --- |
| 阶段 1 基线文件数 | 119 |
| 现树零门禁命中文件数 | 168 |
| **基线文件中现已非零命中（回退）** | **0** —— 119/119 全部保持零门禁命中 |
| 新增文件（现 − 基线） | 49 = p2-01 20（7 行动 + 2 执行器对 + 5 服务 + 2 设置 + 2 控件 + 2 对话框 .axaml.cs）+ p2-02 17 + p2-03 12，逐文件清单与各批交付清单一一对应，零意外文件 |

### 5.2 全树文件集闭合（对 p2-03 留档全树输出）

`Compare-Object`（p2-03-s42-fulltree-source-output.txt vs 本任务主扫描）**差集 = 0 行**：p2-06 重写 Plugin.cs 只改内容不改文件集合，p2-03 之后树内零文件增删——与本任务独立盘点的 168 闭合。

### 5.3 五批自检一致性核对（p2-01/02/03/06 扫描输出 vs 本次直扫）

| 批次（留档输出） | 批内声明 | 本次直扫对应实测 | 一致性 |
| --- | --- | --- | --- |
| p2-01（TEMP 镜像 21 .cs） | GateHits=0、CONDITIONAL=10（SystemPowerCommandWindows R21×5+R17×3，行号 :48/:50/:56/:60/:64/:68/:72/:77；ProcessMemoryMaintenanceNativeWindows R13+X04 :25） | 单文件直扫 8+2=13 中其 10；**逐条 file:line:rule 与批内留档逐字一致** | ✅ 一致 |
| p2-02（5 落点） | Actions 20 / Controls 35 / Settings 17 / Services 14 / MainConfigData 1，全部 GateHits=0、CONDITIONAL=0 | 本次对应目录 GateHits=0、CONDITIONAL=0（其 Actions 20 = 批时点 15+5 并行中态计数；终态 31 含三兵部批全部交付，属时点差异非命中差异） | ✅ 一致 |
| p2-03（全树 168） | GateHits=0、ConditionalHits=13、InfoHits=2（I04）、PASS | 本次 168/0/13/2/PASS 逐值一致；文件集差=0（§5.2）；其本批 3 处（R03×1 + R13+X04）与单文件直扫逐条一致 | ✅ 一致 |
| p2-06（Plugin.cs 单文件 + 全树 168 ×2 轮） | Plugin.cs 1/0/0/0 PASS；全树 GateHits=0、CONDITIONAL=13、InfoHits=2、PASS | Plugin.cs 本次矩阵 0/0 PASS；全树逐值一致；13 处 CONDITIONAL 集合与 p2-06 §6.1 所列 4 文件清单逐文件一致 | ✅ 一致 |

**不一致项：无。** 未出现"批内声明 PASS 而直扫出现命中"或反向情形；扫描器字节未动，无任何规则改动。

### 5.4 资产面回归（-Scope All）

`-Scope All` 实测：SourceFiles=168、**AssetFiles=12**、GateHits=0、VERDICT PASS、exit=0——bin\ 两 TFM 的 12 个资产文件与 p0-07 §4 / p1-08 §3.1 基线清单同值，零回退（原始输出 `p2-08-s42-fulltree-all-output.txt`）。

---

## 6. 已知提及点处置（2 项，均裁量订正；边界 = 各仅注释一行，已获尚书省授权）

### 6.1 ProcessMemoryMaintenanceService.cs:9 旧 guard 符号文本（p2-01 修订 2 报备）

- **事实**：XML doc 注释 `<para>` 内引用成对条件文件时写作"全文件 `#if PLATFORMS_WINDOWS` 包裹"；被引用文件实际 guard 为 `Platforms_Windows`（R-2a 勘误：全大写符号未经 DefineConstants 定义，属死代码形态）。
- **裁量：订正**（与尚书省倾向一致）。理由：(a) 门禁零影响——该文本非 §S4.2 符号，订正前全树 GateHits 已为 0（实证在案）；(b) 功能零影响——纯注释文字；(c) 信息价值——注释是 R-2 条件文件机制的代码内说明位，保留旧符号文本会误导后续维护者重新引入死代码形态，一词订正使注释与被引用文件、R-2a 口径一致。
- **执行**：仅改该行一词（`PLATFORMS_WINDOWS` → `Platforms_Windows`）。订正后该文件单文件复扫 **1 文件 / GateHits=0 / CONDITIONAL=0 / PASS**（留档 `p2-08-s42-single-processmemoryservice-postfix-output.txt`）。

### 6.2 MainConfigData.cs:304 p2-03 增补段头计数 off-by-one（尚书省补充指令，源于户部 p2-07 §5.1）

- **事实（本任务独立复点，非沿用户部结论）**：该段（:304 头注 → :520 结束界标）内属性声明清点为 **14**：EnableFloatingWindowFeature(:332)、ShowFloatingWindow(:346)、Scale(:360)、TextSize(:375)、IconSize(:390)、Opacity(:405)、ShadowEnabled(:420)、DragHandleAlwaysVisible(:434)、PositionX(:448)、PositionY(:462)、Layer(:476)、LayerRecheckMode(:491)、RulesetEnabled(:506)、Ruleset(:518，唯一自动属性)——13 个手写 INPC 守卫 + 1 个自动属性。段头"以下 13 个 B 档成员（7 组）"计数错误；**"7 组"分组正确**（组=门成员/显示开关/外观 6/位置 2/层级/重检模式/规则隐藏 2），且段内逐成员注释枚举本身即 14 项。p2-03 §1.6 行文"增 13 成员（7 组）"与其自身枚举（=14）存在同一 off-by-one，属同一笔误源（本任务不改写该批证据文本，于此留证备查）。
- **裁量：订正**（与尚书省倾向一致）。理由：门禁/功能零影响（纯注释数字）；订正后与段内枚举、p2-05 §2.1 预批清单合计、户部实测三方一致，消除后续批次重写该文件时的计数误导。
- **执行**：仅改该行一处数字（13 → 14）。订正后该文件单文件复扫 **1 文件 / GateHits=0 / CONDITIONAL=0 / PASS**（留档 `p2-08-s42-single-mainconfigdata-postfix-output.txt`）。

### 6.3 订正后全树复扫（零影响证明）

| 项 | 实测 |
| --- | --- |
| 全树 `-Scope Source` 复扫 | SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、VERDICT: PASS [CONDITIONAL=13 R-2]、exit=0（留档 `p2-08-s42-fulltree-source-postfix-output.txt`） |
| 与订正前主扫描逐行差集 | **恰 2 行 = Time(UTC) 2 行（运行时刻固有）**；全部内容行（摘要计数、CONDITIONAL 节、ZERO-HIT 清单、VERDICT）逐字节一致 |
| 结论 | 两处订正零门禁影响、零扫描影响，产品语义零变化 |

---

## 7. 结构抽核（派工重点 5；本会话独立复验，不经扫描器）

| # | 检查项 | 方法/模式 | 实测 | 违规 | 结论 |
| --- | --- | --- | --- | ---: | --- |
| 1 | Plugin.cs 行数与平台符号 | 全文读取/计数 | **742 行**（p2-06 微修 1 后状态）；`#if` 出现 **0** 次 | 0 | ✅ 与 p2-06 §1/§6 一致 |
| 2 | 注册调用计数（复现 p2-06 §2.5 口径） | `Register\w*IfEnabled` 全行分类：4 个辅助方法定义（含 RegisterActionIfEnabled 双泛型重载）+ 1 处 doc 注释提及 + 1 处 `#region` 行提及（L419）剔除后，代码调用 = **37**（RegisterActionIfEnabled 29 + RegisterComponentIfEnabled 6 + RegisterTriggerIfEnabled 2）；37 处均携带引号 ID（7 处同行 + 30 处续行） | **37 / 37** | 0 | ✅ 与 p2-06 §2.5"37 调用/行动 29+组件 6+触发器 2"精确一致 |
| 3 | ID 前缀（注册 + 菜单） | Plugin.cs 引号 `"SystemTools\.` 引用全部 127 处、唯一值 45 个（37 个注册 ID + 8 个设置页/分组 id，均 `SystemTools.CrossPlatform.*` 形态；45 = 阶段 1 基线 30 + 本阶段新增 15 个 B 档注册 ID，闭合）；非前缀引用 | **0** | ✅ |
| 4 | namespace 镜像 | 163 个 .cs（168 − 4 yml − 1 csproj）逐文件 `^namespace` 提取；期望 = `SystemTools.CrossPlatform[.目录镜像]` | 163/163 有声明；唯一值 22；目录镜像违规 **0** | ✅ |
| 5 | 禁用 using | `using\s+SystemTools\.(?!CrossPlatform)` 全 .cs | **0** | ✅ |

---

## 8. 边界声明与复核指引

### 8.1 写入清单

| 文件 | 性质 |
| --- | --- |
| `p2-08-justice-filegates.md` | 本证据文件 |
| `p2-08-s42-fulltree-source-output.txt` / `p2-08-s42-fulltree-all-output.txt` | 权威全树主扫描（Source/All）原始输出（§2/§5.4） |
| `p2-08-s42-single-{systempowerwindows,processmemorywindows,shutdownmonitor,motionpreferences}-output.txt` | 4 个条件文件单文件复扫原始输出（§3.2/§3.1 判定输入） |
| `p2-08-s42-single-{processmemoryservice,mainconfigdata}-postfix-output.txt` | 两处提及点订正后单文件复扫原始输出（§6） |
| `p2-08-s42-fulltree-source-postfix-output.txt` | 订正后全树复扫原始输出（§6.3） |
| `src\...\Services\ProcessMemoryMaintenanceService.cs` :9 | **经授权注释一词订正**（PLATFORMS_WINDOWS → Platforms_Windows，§6.1） |
| `src\...\ConfigHandlers\MainConfigData.cs` :304 | **经授权注释一数订正**（13 个 → 14 个，§6.2） |

### 8.2 零改动/只读声明

- 除 §6 两处经授权的注释一行订正外，`src\SystemTools.CrossPlatform` 全树零改动；两处订正后经单文件+全树复扫证明零门禁/零扫描影响（§6.3）。
- 扫描器 `p0-07-s42-scan.ps1` 字节未动；未做任何规则改动以掩盖命中（亦无命中需要掩盖——GateHits=0）。
- 原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha` 未触碰；未请求任何沙箱提权。

### 8.3 复核方最小重放集

```powershell
# 1) 全树逐文件门禁（对照 §2.4 矩阵；订正后现态）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
#    预期：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、PASS、exit=0
# 2) 资产面回归（对照 §5.4）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope All
# 3) 4 个条件文件单文件复扫（对照 §3.1：8/2/1/2）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Actions\SystemPowerCommandWindows.cs -Scope Source
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Services\ProcessMemoryMaintenanceNativeWindows.cs -Scope Source
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Services\SystemShutdownMonitor.cs -Scope Source
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Views\SystemMotionPreferences.cs -Scope Source
# 4) 基线集合差（对照 §5.1；ZERO-HIT 节解析法同本任务脚本）
# 5) 结构抽核（对照 §7）
Select-String -Path src\SystemTools.CrossPlatform\Plugin.cs -Pattern '\bRegister\w*IfEnabled\b'
Select-String -Path src\SystemTools.CrossPlatform\Plugin.cs -Pattern '"SystemTools\.'
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | ? { $_.FullName -notmatch '\\(bin|obj)\\' } | Select-String -Pattern '^namespace\s+|using\s+SystemTools\.'
# 6) 两处订正核对：读 ProcessMemoryMaintenanceService.cs:9 与 MainConfigData.cs:304 现文本
```

### 8.4 上报事项汇总

1. 门禁命中（GateHits）= 0；CONDITIONAL=13 逐条对应判定 = 全部在授权/明示范围内，**零超范围 CONDITIONAL**；引用级偏差 1 项（SystemShutdownMonitor 的"06 条目 46"编号引用与 06 文档实际条目 46 不符，真实授权链为 p2-05 §1.2 + p0-07 §11.1，见 §3.3）——上报尚书省/门下省知悉，不影响门禁结论。
2. 已知提及点 2 项均按尚书省倾向裁量订正（各仅注释一行/一词），订正后复扫零影响留证（§6）。
3. 批次一致性核对零分歧（§5.3）；阶段 1 基线 119/119 零回退（§5.1）。
4. 本文件不推进、不审批全局工作流；属批级验证证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。
