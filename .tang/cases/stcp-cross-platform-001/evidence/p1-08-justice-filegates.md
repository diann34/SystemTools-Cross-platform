# p1-08 证据：阶段 1 A 档逐文件 S4.2 门禁留证与回归（刑部 quality-security / verification）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-08 · 刑部 justice · quality-security / verification（依赖 p1-01/p1-02/p1-03/p1-04/p1-06，均已记录 succeeded） |
| 权威输入 | 04-spec.md §S4.2（条款 ①–⑩，04-spec.md:59-77）；p0-07-quality-gates.md（38 规则扫描器 + 判定语义 + 修订 R-1 单文件模式修复）；p1-05 §5（门禁规则与自检格式）；p1-01 §5 / p1-02 §5 / p1-03 §5 / p1-04 §8 / p1-06 §7（各批自检输出，交叉参照、不替代本次独立执行） |
| 工作区 | `E:\My Github Projects\SystemTools-Cross-platform`（唯一写入面 = 本案 evidence/） |
| 只读面 | `src\SystemTools.CrossPlatform` 全树（零改动）；原插件与宿主检出（未触碰）；扫描器 `p0-07-s42-scan.ps1`（零改动，规则集/语义/退出码契约未动） |
| 结论 | **succeeded** —— (a) 全树 Source 面 **119/119 文件逐文件矩阵全 PASS**（GateHits=0、InfoHits=0；CommentOnly=6 既有 csproj:79 决策注释）；(b) **基线回归 PASS**（p0-07 §3 脚手架 3 文件复扫零命中不回退 + `-Scope All` 全树语义对照一致）；(c) MainConfigData.cs:92 已知提及点**裁量=保留**（§4）；(d) **manifest-schema-check 权威复跑 11 PASS**（p1-06 §8 待办在本任务闭合，无需转记工部 p1-10，§5）；(e) 结构抽核 4 组独立复验零违规（§6） |

---

## 1. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | 全树逐文件矩阵覆盖且可重放 | Source 面 119 文件（= 114 .cs + 4 .yml + 1 .csproj）逐文件 VERDICT 全 PASS；重放命令与原始输出留档齐备（§2） | ✅ |
| 2 | GateHits=0 或命中均留证上报 | GateHits=**0**（全树 + 回归各路均 0）；无任何需要上报处置的门禁命中 | ✅ |
| 3 | 基线回归 PASS | 3 脚手架文件单文件复扫 0 命中；全树 `-Scope All` 与 p0-07 §3 判定语义一致（CommentOnly=6 同为 csproj:79）；五批自检逐目录一致性核对无分歧（§3） | ✅ |
| 4 | manifest 复跑完成或受阻留痕+转记 | **完成**：11 PASS + SCHEMA-PARSE-CHECK: PASSED（§5）；无需转记工部 p1-10 | ✅ |

---

## 2. 全树权威逐文件 S4.2 门禁（Source 面）

### 2.1 方法与重放

- 扫描器：`.tang/cases/stcp-cross-platform-001/evidence/p0-07-s42-scan.ps1`（p0-07 固化，R-1 修复后版本，本次**零改动**使用；38 规则 R01–R21/X01–X08/P01–P07/N01–N02 + I01–I11 机制观察）。
- 执行形态：在本会话 pwsh 进程内以调用运算符 `&` 直接运行（本会话嵌套 `pwsh -File` 受宿主命名管道边界限制——沿 p0-07 R-1 §10.3 / p1-02 §5.1 / p1-03 §5 既有口径；扫描逻辑、判定语义与退出码不变）。
- 重放命令（复核方按 p0-07 §2.1 常规用法即可）：

  ```powershell
  pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
       -Path src\SystemTools.CrossPlatform -Scope Source
  # 预期：SourceFiles=119、GateHits=0、CommentOnly=6、InfoHits=0、VERDICT: PASS、exit=0
  ```

- 原始输出留档：`evidence/p1-08-s42-fulltree-source-output.txt`（运行时刻 2026-09-03T18:42:38Z）。

### 2.2 全树摘要

```
SourceFiles   : 119
AssetFiles    : 0   （-Scope Source 面）
GateHits      : 0
CommentOnly   : 6   （全部为 SystemTools.CrossPlatform.csproj:79，P01–P06 各 1 处——p0-04 §10 决策留痕注释，非门禁命中）
InfoHits      : 0
VERDICT       : PASS (zero gate hits)   exit=0
```

- GATE-HIT FILES 节为空；ZERO-HIT SOURCE FILES 节逐文件列出 **119** 个文件（与 SourceFiles 计数闭合，矩阵见 §2.4）。
- 树盘点（非 bin/obj）：**152 文件**（派工预估 ~155 为约数；实测与各批交付清单总和精确闭合：p1-01 52 + p1-02 16 + p1-03 44 + p1-04 23 + p1-06 14 + 脚手架 manifest.yml/csproj 2 + Plugin.cs 1 = 152；Source 面 119 与 p1-06 §7-1 全树收口计数 119 一致）。

### 2.3 逐目录汇总

| 目录 | Source 面文件数 | 目录内文件总数 | GateHits | COMMENT-ONLY | INFO | 结论 |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| （根）Plugin.cs / manifest.yml / csproj | 3 | 3 | 0 | 6（仅 csproj:79） | 0 | PASS |
| Actions\ | 15 | 15 | 0 | — | 0 | PASS |
| Rules\ + Rules\Handlers\ | 8 | 8 | 0 | — | 0 | PASS |
| Triggers\ + Config\ | 2 | 2 | 0 | — | 0 | PASS |
| Settings\ | 12 | 12 | 0 | — | 0 | PASS |
| Controls\ 平铺 | 17 | 20 | 0 | — | 0 | PASS |
| Controls\Components\ | 12 | 24 | 0 | — | 0 | PASS |
| Controls\Notifications\ | 1 | 2 | 0 | — | 0 | PASS |
| Models\ + Models\ComponentSettings\ | 8 | 8 | 0 | — | 0 | PASS |
| Converters\ | 1 | 1 | 0 | — | 0 | PASS |
| ConfigHandlers\ | 6 | 6 | 0 | — | 0 | PASS |
| Shared\ | 1 | 1 | 0 | — | 0 | PASS |
| Services\ | 12 | 12 | 0 | — | 0 | PASS |
| Version\ + Views\ | 2 | 3 | 0 | — | 0 | PASS |
| SettingsPage\ | 8 | 14 | 0 | — | 0 | PASS |
| Themes\（3 主题目录） | 11 | 21 | 0 | — | 0 | PASS |
| **合计** | **119** | **152**（非 bin/obj） | **0** | **6** | **0** | **PASS** |

（注：Source 面 = *.cs/*.csproj/*.yml/*.yaml；.axaml/.axaml.txt/.png 等不属 Source 面，与 p1-02 §5.1.1 口径一致，其内容由各批人工核对零禁用符号留痕。`bin\` 下 12 个资产文件由 `-Scope All` 路覆盖，见 §3。）

### 2.4 逐文件门禁矩阵（文件 × GateHits × COMMENT-ONLY × INFO × VERDICT）

全部行取自留档原始输出的 ZERO-HIT/COMMENT-ONLY 节（可重放核对）。VERDICT 均为 **PASS**（GateHits=0）。

**（根）——3 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Plugin.cs | 0 | — | — | PASS |
| manifest.yml | 0 | — | — | PASS |
| SystemTools.CrossPlatform.csproj | 0 | P01–P06 @ :79（6 处） | — | PASS |

**Actions\ ——15 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Actions\ActionFlowExecutionConfirmationAction.cs | 0 | — | — | PASS |
| Actions\BackgroundPlayAudioAction.cs | 0 | — | — | PASS |
| Actions\ClearAllNotificationsAction.cs | 0 | — | — | PASS |
| Actions\FullscreenClockAction.cs | 0 | — | — | PASS |
| Actions\KillProcessAction.cs | 0 | — | — | PASS |
| Actions\LoadTemporaryClassPlanAction.cs | 0 | — | — | PASS |
| Actions\OpenAppSettingsAction.cs | 0 | — | — | PASS |
| Actions\OpenClassSwapWindowAction.cs | 0 | — | — | PASS |
| Actions\OpenProfileEditorAction.cs | 0 | — | — | PASS |
| Actions\ShowAiChatDialogAction.cs | 0 | — | — | PASS |
| Actions\ShowToastAction.cs | 0 | — | — | PASS |
| Actions\SwitchFloatingWindowThemeAction.cs | 0 | — | — | PASS |
| Actions\ToggleFloatingWindowProfileAction.cs | 0 | — | — | PASS |
| Actions\ToggleWorkflowAction.cs | 0 | — | — | PASS |
| Actions\TriggerCustomTriggerAction.cs | 0 | — | — | PASS |

**Rules\ + Rules\Handlers\ ——8 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Rules\InTimePeriodRuleSettings.cs | 0 | — | — | PASS |
| Rules\ProcessRunningRuleSettings.cs | 0 | — | — | PASS |
| Rules\UsingClassPlanRuleSettings.cs | 0 | — | — | PASS |
| Rules\UsingTimeLayoutRuleSettings.cs | 0 | — | — | PASS |
| Rules\Handlers\InTimePeriodRuleHandler.cs | 0 | — | — | PASS |
| Rules\Handlers\ProcessRunningRuleHandler.cs | 0 | — | — | PASS |
| Rules\Handlers\UsingClassPlanRuleHandler.cs | 0 | — | — | PASS |
| Rules\Handlers\UsingTimeLayoutRuleHandler.cs | 0 | — | — | PASS |

**Triggers\ + Config\ ——2 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Triggers\ActionInProgressTrigger.cs | 0 | — | — | PASS |
| Config\ActionInProgressTriggerConfig.cs | 0 | — | — | PASS |

**Settings\ ——12 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Settings\ActionFlowExecutionConfirmationSettings.cs | 0 | — | — | PASS |
| Settings\ActionInProgressTriggerSettings.cs | 0 | — | — | PASS |
| Settings\BackgroundPlayAudioSettings.cs | 0 | — | — | PASS |
| Settings\FullscreenClockSettings.cs | 0 | — | — | PASS |
| Settings\KillProcessSettings.cs | 0 | — | — | PASS |
| Settings\LoadTemporaryClassPlanSettings.cs | 0 | — | — | PASS |
| Settings\ShortcutKeyNotificationSettings.cs | 0 | — | — | PASS |
| Settings\ShowToastSettings.cs | 0 | — | — | PASS |
| Settings\SwitchFloatingWindowThemeSettings.cs | 0 | — | — | PASS |
| Settings\ToggleFloatingWindowProfileSettings.cs | 0 | — | — | PASS |
| Settings\ToggleWorkflowSettings.cs | 0 | — | — | PASS |
| Settings\TriggerCustomTriggerSettings.cs | 0 | — | — | PASS |

**Controls\ 平铺 ——17 个 Source 面文件（目录另有 3 个 .axaml，不属 Source 面）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Controls\ActionFlowExecutionConfirmationSettingsControl.cs | 0 | — | — | PASS |
| Controls\AiAttachmentDropConfirmation.axaml.cs | 0 | — | — | PASS |
| Controls\AiAttachmentDropOverlay.axaml.cs | 0 | — | — | PASS |
| Controls\BackgroundPlayAudioSettingsControl.cs | 0 | — | — | PASS |
| Controls\FullscreenClockSettingsControl.cs | 0 | — | — | PASS |
| Controls\InTimePeriodRuleSettingsControl.cs | 0 | — | — | PASS |
| Controls\KillProcessSettingsControl.cs | 0 | — | — | PASS |
| Controls\LoadTemporaryClassPlanSettingsControl.cs | 0 | — | — | PASS |
| Controls\ProcessRunningRuleSettingsControl.cs | 0 | — | — | PASS |
| Controls\ShortcutKeyNotificationSettingsControl.cs | 0 | — | — | PASS |
| Controls\ShowToastSettingsControl.cs | 0 | — | — | PASS |
| Controls\SwitchFloatingWindowThemeSettingsControl.cs | 0 | — | — | PASS |
| Controls\ToggleFloatingWindowProfileSettingsControl.cs | 0 | — | — | PASS |
| Controls\ToggleWorkflowSettingsControl.cs | 0 | — | — | PASS |
| Controls\TriggerCustomTriggerSettingsControl.cs | 0 | — | — | PASS |
| Controls\UsingClassPlanRuleSettingsControl.cs | 0 | — | — | PASS |
| Controls\UsingTimeLayoutRuleSettingsControl.cs | 0 | — | — | PASS |

**Controls\Components\ ——12 个 Source 面文件（目录另有 12 个 .axaml）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Controls\Components\BetterCarouselContainerComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\BetterCarouselContainerSettingsControl.axaml.cs | 0 | — | — | PASS |
| Controls\Components\ClipboardContentComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\ClipboardContentSettingsControl.axaml.cs | 0 | — | — | PASS |
| Controls\Components\LocalQuoteComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\LocalQuoteSettingsControl.axaml.cs | 0 | — | — | PASS |
| Controls\Components\NetworkStatusComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\NetworkStatusSettingsControl.axaml.cs | 0 | — | — | PASS |
| Controls\Components\NextClassDisplayComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\NextClassDisplaySettingsControl.axaml.cs | 0 | — | — | PASS |
| Controls\Components\ScrollingTextComponent.axaml.cs | 0 | — | — | PASS |
| Controls\Components\ScrollingTextSettingsControl.axaml.cs | 0 | — | — | PASS |

**Controls\Notifications\ ——1 个 Source 面文件（另有 1 个 .axaml）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Controls\Notifications\AiReplyNotificationContent.axaml.cs | 0 | — | — | PASS |

**Models\ + Models\ComponentSettings\ ——8 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Models\AiAttachment.cs | 0 | — | — | PASS |
| Models\AiConversation.cs | 0 | — | — | PASS |
| Models\ComponentSettings\BetterCarouselContainerSettings.cs | 0 | — | — | PASS |
| Models\ComponentSettings\ClipboardContentSettings.cs | 0 | — | — | PASS |
| Models\ComponentSettings\LocalQuoteSettings.cs | 0 | — | — | PASS |
| Models\ComponentSettings\NetworkStatusSettings.cs | 0 | — | — | PASS |
| Models\ComponentSettings\NextClassDisplaySettings.cs | 0 | — | — | PASS |
| Models\ComponentSettings\ScrollingTextSettings.cs | 0 | — | — | PASS |

**Converters\ ——1 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Converters\EnumDescriptionConverter.cs | 0 | — | — | PASS |

**ConfigHandlers\ ——6 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| ConfigHandlers\ButtonRulesetConfig.cs | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfile.cs | 0 | — | — | PASS |
| ConfigHandlers\FloatingWindowProfileManager.cs | 0 | — | — | PASS |
| ConfigHandlers\MainConfigData.cs | 0 | — | — | PASS |
| ConfigHandlers\MainConfigHandler.cs | 0 | — | — | PASS |
| ConfigHandlers\RowRulesetConfig.cs | 0 | — | — | PASS |

**Shared\ ——1 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Shared\GlobalConstants.cs | 0 | — | — | PASS |

**Services\ ——12 文件**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Services\AiAttachmentDropService.cs | 0 | — | — | PASS |
| Services\AiAttachmentService.cs | 0 | — | — | PASS |
| Services\AiChatOperationGate.cs | 0 | — | — | PASS |
| Services\AiChatWindowService.cs | 0 | — | — | PASS |
| Services\AiConversationStore.cs | 0 | — | — | PASS |
| Services\AiPromptService.cs | 0 | — | — | PASS |
| Services\ClassIslandActionAiService.cs | 0 | — | — | PASS |
| Services\ClassIslandProfileAiService.cs | 0 | — | — | PASS |
| Services\IOpenAiCompatibleService.cs | 0 | — | — | PASS |
| Services\OpenAiCompatibleService.cs | 0 | — | — | PASS |
| Services\SystemToolsNotificationProvider.cs | 0 | — | — | PASS |
| Services\VirtualAfterSchoolService.cs | 0 | — | — | PASS |

**Version\ + Views\ ——2 个 Source 面文件（Views 另有 1 个 .axaml）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Version\VersionCheckService.cs | 0 | — | — | PASS |
| Views\AiChatFloatingWindow.axaml.cs | 0 | — | — | PASS |

**SettingsPage\ ——8 个 Source 面文件（另有 6 个 .axaml）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| SettingsPage\AboutSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\AiChatSettingsViewModel.cs | 0 | — | — | PASS |
| SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\PluginDebugSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsPage.axaml.cs | 0 | — | — | PASS |
| SettingsPage\SystemToolsSettingsViewModel.cs | 0 | — | — | PASS |

**Themes\（3 目录）——11 个 Source 面文件（另有 3 .axaml + 3 Theme.axaml.txt + 1 .axaml + 3 png，不属 Source 面）**

| 文件 | GateHits | COMMENT-ONLY | INFO | VERDICT |
| --- | ---: | --- | --- | --- |
| Themes\CardTypeComponent\CardTypeComponentStyles.cs | 0 | — | — | PASS |
| Themes\CardTypeComponent\manifest.yml | 0 | — | — | PASS |
| Themes\ClassWidgets\ClassWidgetsCard.axaml.cs | 0 | — | — | PASS |
| Themes\ClassWidgets\ClassWidgetsStyles.cs | 0 | — | — | PASS |
| Themes\ClassWidgets\manifest.yml | 0 | — | — | PASS |
| Themes\NotchStyle\manifest.yml | 0 | — | — | PASS |
| Themes\NotchStyle\NotchClipControl.cs | 0 | — | — | PASS |
| Themes\NotchStyle\NotchFrameControl.cs | 0 | — | — | PASS |
| Themes\NotchStyle\NotchMaterialControl.cs | 0 | — | — | PASS |
| Themes\NotchStyle\NotchShapeGeometry.cs | 0 | — | — | PASS |
| Themes\NotchStyle\NotchStyleStyles.cs | 0 | — | — | PASS |

矩阵闭合核对：3+15+8+2+12+17+12+1+8+1+6+1+12+2+8+11 = **119** = 扫描器 SourceFiles 实测。

---

## 3. 基线回归与批次一致性核对

### 3.1 p0-07 脚手架基线 3 文件复扫（不回退核对；同时复验 R-1 单文件模式）

| 复扫对象 | 命令要点 | SourceFiles | GateHits | CommentOnly | InfoHits | VERDICT | exit | 留档 |
| --- | --- | ---: | ---: | ---: | ---: | --- | :-: | --- |
| 全树 -Scope All | `-Path src\SystemTools.CrossPlatform -Scope All` | 119 | 0 | 6 | 0 | PASS | 0 | `p1-08-s42-fulltree-all-output.txt` |
| Plugin.cs | `-Path …\Plugin.cs -Scope All`（单文件模式） | 1 | 0 | 0 | 0 | PASS | 0 | `p1-08-s42-baseline-plugin-output.txt` |
| manifest.yml | `-Path …\manifest.yml -Scope All`（单文件模式） | 1 | 0 | 0 | 0 | PASS | 0 | `p1-08-s42-baseline-manifest-output.txt` |
| SystemTools.CrossPlatform.csproj | `-Path …\SystemTools.CrossPlatform.csproj -Scope All`（单文件模式） | 1 | 0 | 6 | 0 | PASS | 0 | `p1-08-s42-baseline-csproj-output.txt` |

- **3 脚手架文件零命中不回退** ✅：与 p0-07 §3 基线（SourceFiles=3、GateHits=0、CommentOnly=6、InfoHits=0、PASS）逐项一致；csproj 的 6 处 COMMENT-ONLY 逐条核对同为 **P01–P06 @ :79**（P07 无命中），即同一行 p0-04 §10 决策留痕注释，未发生漂移。
- **R-1 修复复验** ✅：本次 3 笔单文件扫描直接以 `-Path <单文件>` 执行（p0-07 §10.2 修复的分支），全部 exit=0——单文件模式在真实工作负载下可用，扫描器无需再修。
- **Assets 面**：全树 `-Scope All` 实测 AssetFiles=**12**（`bin\` 两 TFM 输出），门禁命中 0——与 p0-07 §4 的 12 文件清单（net10.0 5 文件 + net10.0-windows10.0.19041.0 7 文件）一致，零回退。

### 3.2 各批自检 ↔ 本次直扫逐目录一致性核对

| 批次（自检节） | 批内声明 | 本次全树直扫对应目录实测 | 一致性 |
| --- | --- | --- | --- |
| p1-01 §5 | Themes / Controls\Components / Models\ComponentSettings / Converters 四段全 PASS（GateHits=0/InfoHits=0） | Themes 11、Components 12、ComponentSettings 6、Converters 1 个 Source 文件全部 PASS | ✅ 一致 |
| p1-02 §5.1 | Rules(8)/Triggers(1)/Config(1)/Settings 单文件 PASS；Controls 单文件直扫（ProcessRunningRuleSettingsControl.cs）PASS | Rules+Handlers 8、Triggers 1、Config 1、Settings\ActionInProgressTriggerSettings.cs、Controls\ProcessRunningRuleSettingsControl.cs 全部 PASS | ✅ 一致 |
| p1-03 §5 | Actions(15)/Controls/Settings(12)/ConfigHandlers(6)/Shared(1) + 全树现状全 PASS（注明 Controls/Settings 计数含并行批当时已落盘文件） | Actions 15、Controls 平铺+Components+Notifications 30 个 Source 文件、Settings 12、ConfigHandlers 6、Shared 1 全部 PASS | ✅ 一致（其"Controls 26"为批时点并行计数口径，终态计数以本矩阵为准；门禁结论无分歧） |
| p1-04 §8 | 12 目标全 PASS（Services 12、Version、Views、Controls\Notifications、AiAttachmentDrop*×4、Models×2、MainConfigData、GlobalConstants） | Services 12、Version 1、Views 1、Notifications 1、Controls\AiAttachmentDrop* 2 个 .cs、Models 2、ConfigHandlers\MainConfigData.cs、Shared\GlobalConstants.cs 全部 PASS | ✅ 一致 |
| p1-06 §7-1 | 批内 3 目标（Plugin.cs / SettingsPage\ 8 .cs / MainConfigData）+ 全树 119 全 PASS；csproj 6 条 COMMENT-ONLY | Plugin.cs、SettingsPage 8 .cs、MainConfigData 全 PASS；全树 SourceFiles=119、GateHits=0、CommentOnly=6（同 csproj:79） | ✅ 一致 |
| p0-07 §10.3-b（R-1 回归） | 全树当时 SourceFiles=107、GateHits=0 | 本次 119、GateHits=0 | ✅ 门禁结论一致（107 为四批并行执行期中态计数，119 为五批交付终态闭合实测；计数差异属时点差异，非规则或命中差异） |

**不一致项：无。** 未出现任何"批内声明 PASS 而本次直扫出现命中"或反向情形；亦未做任何规则改动（扫描器字节未动）。

---

## 4. 已知提及点处置（p1-06 §7-2 报备事项）

**事实**：`src\SystemTools.CrossPlatform\ConfigHandlers\MainConfigData.cs:87-93` 为 p1-04 增补成员段的留痕注释块；其中 **:92** 提及三个 U5 玻璃族成员名（`AiConversationFloatingWindowStyle`/`AiConversationLiquidGlass`/`AiConversationApprovalButtonGlass`），用于说明"源 AI 液态玻璃成员不增补"的边界依据。

**门禁判定**：**非门禁命中**。
- "LiquidGlass" 不属 04-spec §S4.2 条款 ①–⑩ 任何成员（§S4.2 禁用清单为 CsWin32/WinForms/注册表/WMI/Speech/WinRT Media·Security/DllImport/Windows 进程/Windows 包；液态玻璃属 U5/C 候选降级面，非 §S4.2 符号）；
- 扫描器 38 规则集中亦无 LiquidGlass 模式（p0-07 §2.2 规则表可核）——本次全树 GateHits=0 即在该注释在位状态下取得，实证其门禁零影响。

**裁量：保留（与尚书省倾向一致）**。理由：
1. **门禁零影响**（上述实证），不构成 §S4.2 或 p1-05 §5.2-2"注释从严"口径的违例——该口径约束的是 §S4.2 符号出现在交付 .cs 注释中，LiquidGlass 非 §S4.2 符号；
2. **信息价值**：它是 p1-04 §2.1"配置成员不增补"决议在代码内的唯一锚点注释，直接说明"为何不迁"，对门下省评审与后续阶段增补者（避免误加回玻璃成员）有实证指引作用；
3. **写入边界**：本批写入仅限 evidence/，产品文件零改动为硬约束——即使判清理更妥也应上报裁定而非自行改动；
4. 清理的边际收益（注释少一行）小于其丢失的成本（不迁依据失去代码内锚点）。

**登记**：保留该注释；若后续阶段该文件再次增补或 p1-04 §2.1 决议变化，由当期属主批同步评估并留痕。

---

## 5. manifest-schema-check 权威复跑（p1-06 §8 报备待办的闭合）

| 项 | 实测 |
| --- | --- |
| 命令 | `.tools\manifest-schema-check\bin\Release\net10.0\manifest-schema-check.exe "src\SystemTools.CrossPlatform\manifest.yml" "E:\My Github Projects\SystemTools\manifest.yml"`（p0-05 §5.4 同形） |
| 第 1 次直跑 | **成功**：11 项断言全 PASS（SRC-ID + A1-ID + A2-ENTRANCE + A3-VERSION + A4-APIVERSION + A5-PLATFORMS + A6-NAME + A7-ICON-README + A8-AUTHOR + A9-DEPENDENCIES + A10-PREFIX）+ **SCHEMA-PARSE-CHECK: PASSED**，与 p0-05 §5.2 预期完全一致 |
| 第 2/3 次重定向留档尝试 | 进程启动被本会话沙箱命名管道边界拒绝（`ResourceUnavailable: Access to the path '\\.\pipe\LOCAL\dotnet_*' is denied`；本会话呈间歇性，第 1 次通过后两次拒绝）；按重试纪律停止，错误原文已存档，未请求提权 |
| 输入同一性 | 复跑输入 manifest.yml SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`，与 p0-05 §13 基线记录逐字符一致（字节同一输入 + 同一工具二进制 → 判定确定性闭合） |
| 留档 | `evidence/p1-08-manifest-schema-check-output.txt`（第 1 次直跑完整输出**明确标注转录** + 两次失败错误原文 + 重放指引） |
| 待办处置 | **p1-06 §8 待办在本任务闭合**——本会话可运行该 .NET 工具且已取得 11 PASS 权威复跑；**无需转记工部 p1-10** |

---

## 6. 结构抽核（p1-06 §7-3/7-4 结论的独立复验 + 脱离扫描器的双重复核）

检测面：`src\SystemTools.CrossPlatform` 全部 148 个文本交付文件（.cs/.axaml/.yml/.yaml/.txt，非 bin/obj）；检测方式：本会话内独立 Select-String/解析（不经扫描器）。

| # | 检查项 | 模式 | 实测 | 违规 | 结论 |
| --- | --- | --- | --- | ---: | --- |
| 1 | 带引号 `SystemTools.` 引用串全前缀 | `"SystemTools\.` | **125 处**（Plugin.cs 注册面 + ActionInfo/TriggerInfo/SettingsPageInfo/Group 特性 + 6 页 x:Class + 组件 x:Class + manifest.yml entranceAssembly + AiConversationStore 回退目录 + 设置页 Path.Combine） | **0**（全部为 `SystemTools.CrossPlatform.*` 形态） | ✅ 复验 p1-06 §7-4 成立 |
| 2 | Plugin.cs 唯一引用 ID 计数 | `"(SystemTools\.CrossPlatform\.[^"]+)"` | **30 个唯一值** | — | ✅ 与 p1-06 §7-4"30 个唯一值"一致 |
| 3 | 禁止 using（源插件命名空间面） | `using\s+SystemTools\.` | 111 处 | **0**（全部 `SystemTools.CrossPlatform.*`） | ✅ 复验 p1-06 §7-3 成立 |
| 4 | namespace 镜像 | `namespace\s+…`（114 个 .cs 全覆盖） | 114 处声明，**22 个唯一值**全部为 `SystemTools.CrossPlatform[.<目录镜像>]`（Actions/Config/ConfigHandlers/Controls/.Components/.Notifications/Converters/Models/.ComponentSettings/Rules/.Handlers/Services/Settings/SettingsPage/Shared/Themes.*/Triggers/Version/Views 与目录树逐级镜像） | **0** | ✅（.cs 文件实测 114 = 119 − 4 yml − 1 csproj，全覆盖无缺声明） |
| 5 | axaml clr-namespace 裸 `SystemTools.` | `clr-namespace:SystemTools\.(?!CrossPlatform)` | 0 命中 | **0** | ✅ |
| 6 | 脱离扫描器的禁用符号双重复核 | `Windows\.Win32|PInvoke\.|System\.Windows\.Forms|Microsoft\.Win32|System\.Management|System\.Speech|Windows\.Media|Windows\.Security|DllImport|LibraryImport|\bSendKeys\b|GetFfmpegPath|\w+\.bat\b|WindowsIdentity|WindowsPrincipal|"runas"|cmd\.exe|robocopy\.exe|rundll32\.exe|DisplaySwitch\.exe|ffmpeg\.exe|VoskWorker`（.cs 全文含注释） | 114 个 .cs | **0** | ✅ 与扫描器 R/X 零命中互证 |

---

## 7. 边界声明与复核指引

### 7.1 写入清单（全部位于本案 evidence/）

| 文件 | 性质 |
| --- | --- |
| `p1-08-justice-filegates.md` | 本证据文件 |
| `p1-08-s42-fulltree-source-output.txt` | 全树 Source 面权威扫描原始输出（§2） |
| `p1-08-s42-fulltree-all-output.txt` | 全树 -Scope All 回归扫描原始输出（§3.1） |
| `p1-08-s42-baseline-plugin-output.txt` | Plugin.cs 单文件复扫原始输出（§3.1） |
| `p1-08-s42-baseline-manifest-output.txt` | manifest.yml 单文件复扫原始输出（§3.1） |
| `p1-08-s42-baseline-csproj-output.txt` | csproj 单文件复扫原始输出（§3.1） |
| `p1-08-manifest-schema-check-output.txt` | manifest 工具复跑留档（第 1 次直跑完整输出转录 + 失败错误原文，§5） |

### 7.2 零改动声明

- `src\SystemTools.CrossPlatform` 全树零改动（全部操作为只读列举/读取/扫描/哈希）；`p0-07-s42-scan.ps1` 字节未动（无需再修——单文件模式经 3 笔真实扫描复验可用）；
- 原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha` 未触碰；
- 未做任何规则改动以掩盖命中（亦无命中需要掩盖）；未请求任何沙箱提权。

### 7.3 复核方最小重放集

```powershell
# 1) 全树逐文件门禁（对照 §2.4 矩阵）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
# 2) 基线回归（对照 §3.1）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope All
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Plugin.cs -Scope All
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\manifest.yml -Scope All
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -Scope All
# 3) manifest 工具复跑（对照 §5；p0-05 §5.4 同形）
.tools\manifest-schema-check\bin\Release\net10.0\manifest-schema-check.exe "src\SystemTools.CrossPlatform\manifest.yml" "E:\My Github Projects\SystemTools\manifest.yml"
# 4) 结构抽核（对照 §6）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File -Include *.cs,*.axaml,*.yml,*.yaml,*.txt | ? { $_.FullName -notmatch '\\(bin|obj)\\' } | Select-String -Pattern '"SystemTools\.'
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | ? { $_.FullName -notmatch '\\(bin|obj)\\' } | Select-String -Pattern 'namespace\s+|using\s+SystemTools\.'
# 5) 树盘点（对照 §2.2/§2.3 计数）
(Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | ? { $_.FullName -notmatch '\\(bin|obj|\.git)\\' }).Count   # 预期 152
```

### 7.4 上报事项

- 无失败、无门禁命中、无批次一致性分歧；唯一环境注记为 §5 所载 manifest 工具重定向留档两次遭命名管道边界（第 1 次直跑已成功取证，结论不受影响）。
- 本文件不推进、不审批全局工作流；属批级验证证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。
