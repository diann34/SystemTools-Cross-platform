# p3-02 证据：阶段 3 设置页整合批次二（兵部 war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-02 · 兵部 war · application-code / implementation（阶段 3；依赖 p3-05 已记录 succeeded） |
| 权威输入 | `.tang/cases/stcp-cross-platform-001/evidence/p3-05-personnel-settings-integration-spec.md`（唯一落点/裁剪权威：§2.2 落点表 W6-W18、§3.2/§3.3 裁剪面 C16-C21、§3.4 A 面补全、§0-4 冲突规则、§7 复核命令）；源插件 `E:\My Github Projects\SystemTools\SettingsPage\`（只读先例）；已批口径 D5/D6/R-3（p2-03 §2 / p2-09 §1.3 S-浮 行）、p1-06 §4.2（AiChat VM 契约）、p1-05 §5.1/§5.2/§5.3（R-2/S4.2/macOS 格式）、p1-10 §12.5（双分支漂移） |
| 结论 | **succeeded** —— 接线 13/13（W6-W18 全部落地，含 W18 现状核对项随源补显示细节）、裁剪面 6/6 零残留（C16-C21，逐项留证）、A 面补全 2/2（AiChat 消息编辑 UI + 拖放遮罩接线）、S4.2 扫描 PASS exit=0、Roslyn 补充编译自检本批 error=0、共享 VM 按尚书省裁决界标增量协作（p3-01 段完整无损互验通过）、预期零注册/零菜单/零新增条件面（实测 0/0/0） |
| 计数确认 | 接线 13 / 裁剪 6 / 补全 2 / macOS 表 13 项 / 自检 6 组（§7） |

---

## 0. 边界与写入范围

- 本批写入仅限：① 四落点页文件（`SettingsPage\FloatingWindowEditorSettingsPage.axaml[.cs]`、`AiChatSettingsPage.axaml[.cs]`、`AboutSettingsPage.axaml[.cs]`、`PluginDebugSettingsPage.axaml[.cs]`）；② 共享 VM `SettingsPage\SystemToolsSettingsViewModel.cs` 悬浮窗页属面（尚书省裁决①口径：界标增量 edit，见 §6）；③ 本案 `evidence\`（本文件、`p3-02-s42-scan-output.txt`、`p3-02-supplementary-compile-check.ps1`、`p3-02-supplementary-compile-check-output.txt`）。
- 源插件与宿主检出全程只读（Get-Content/Select-String/字节探测）；**零改动**：Plugin.cs、manifest.yml、csproj、global.json、slnx、MainConfigData.cs、p3-01 落点页（SystemToolsSettingsPage、MoreFeaturesOptionsPage）、p3-01 共享 VM 段、Models\（AiConversation.cs 复合可见性成员方案因此弃用，见 §5-1 注记）。
- `dotnet build` 实测被沙箱拒绝（`\\.\pipe\LOCAL\dotnet_*` 命名管道边界，与本会话历史批次记载一致）；按 p1-06 §7-6 / p2-03 §6.3 先例改用进程内 Roslyn 补充编译自检，官方三平台构建门禁仍属工部阶段级验证。

## 1. B 档接线 13 项逐项对照（W6-W18，全在悬浮窗编辑页）

「源锚点」= 源插件 `SettingsPage\FloatingWindowEditorSettingsPage.axaml`（缩写 源.axaml）/ `.axaml.cs`（源.cs）；「新落点」= `src\SystemTools.CrossPlatform\SettingsPage\FloatingWindowEditorSettingsPage.axaml`（新.axaml）/ `.axaml.cs`（新.cs）/ 共享 VM 增补段（§6）。

| W | 项 | 源锚点 | 新落点 | 接线与口径注记 |
| :-: | --- | --- | --- | --- |
| W6 | 「显示悬浮窗」开关 | 源.axaml:69-77；源.cs OnFloatingWindowVisibleToggleChanged :202-222 | 新.axaml:50-67（新 expander「悬浮窗按钮布局」首行）＋新.cs:157-178 | 成员 `showFloatingWindow`（MainConfigData :343-355 只读消费）；`IsChecked` OneWay + 处理器校验（`service.Entries.Count > 0` 失败回写）；`IsEnabled=HasFloatingTriggerEntries`；OnContent=显示/OffContent=隐藏 随源。落地于本批新增 expander，满足 p3-05「新 expander」落点注记 |
| W7 | 按钮布局编辑器（非拖拽） | 源.axaml:42-197；源 VM RefreshFloatingTriggers :401-574 / AddFloatingTriggerRow :609-627 / InsertFloatingTriggerRow :629-655 / RemoveFloatingTriggerRow :657-689 / PersistFloatingTriggerRows :782-860 | 新.axaml:50-166 ＋ 新.cs:259-337 ＋ VM 增补段 :237-655（RefreshFloatingTriggers/添加/插入/移除行/Persist/AreRowsEqual/规则集通知处理器） | **D6 单列口径**：行内拖拽排序/跨行拖动/按钮池机制零迁移零接线——`MoveFloatingTrigger`/`AddTriggerFromPool` 不移植，源 `⋮⋮` 拖拽把手、`DragDrop.*` 行属性、`_floatingDrag*` 状态字段、`OnFloatingTriggerRowDragOver/Drop` 处理器组全部不接线；行排序仅由添加行/在下方插入一行/删除行语义承载。保留：行规则集/按钮规则集编辑（经宿主设置窗口抽屉，与源 OpenDrawer 同机制）；新注册按钮自动入首行/无配置时全量入首行语义随源 VM |
| W8 | 悬浮窗缩放 Slider | 源.axaml:312-315 | 新.axaml:173-192 | TwoWay → `floatingWindowScale`（MainConfigData :357-370 钳制 0.5-2.0）；0.5-2 / Tick 0.1 / 实时值文本随源 |
| W9 | 图标大小 Slider | 源.axaml:327-333 | 新.axaml:193-212 | **p3-05 注记勘误上报**：spec 注「范围随源（16–120）」，源实测 `Minimum="15" Maximum="50" TickFrequency="1"`（16-120 与源 C17「背景刷新频率」面参数同形，疑转录串行）。按「范围随源」原则取源实测 **15-50**，与 MainConfigData :387-397 钳制面（15..50）一致。请尚书省确认后修订 p3-05 §2.2 W9 行 |
| W10 | 文字大小 Slider | 源.axaml:344-349（8-25） | 新.axaml:213-232 | TwoWay → `floatingWindowTextSize`（钳制 8-30） |
| W11 | 透明度 Slider | 源.axaml:364-369（10-100） | 新.axaml:233-252 | TwoWay → `floatingWindowOpacity`（钳制 10-100） |
| W12 | 主题 ComboBox（4 项） | 源.axaml:381-400 | 新.axaml:253-273 | **D5 口径**：四项随源不删项（保存储索引兼容），第 4 项「自适应背景」保留并在 Description 明示「按已批降级口径映射为跟随宿主明暗」；运行时语义由 FloatingWindowService.ResolveWindowThemeVariant 回退（p2-03 交付面 FloatingWindowService.cs:33-35） |
| W13 | 阴影效果 ToggleSwitch | 源.axaml:402-409 | 新.axaml:274-281 | TwoWay → `floatingWindowShadowEnabled` |
| W14 | 一直显示拖动把手 ToggleSwitch | 源.axaml:410-417 | 新.axaml:282-289 | TwoWay → `floatingWindowDragHandleAlwaysVisible` |
| W15 | 悬浮窗层级 ComboBox（置底/置顶） | 源.axaml:419-441 | 新.axaml:291-305 | TwoWay SelectedIndex → `floatingWindowLayer`（归一化 0/1）；运行时消费 `IWindowPlatformService.SetWindowFeature` 已闭合面经服务 SetWindowLayer（p2-03 §3.1 双分支核对通过面），页面零直连平台 API |
| W16 | 层级设置频率 ComboBox（4 项） | 源.axaml:443-467 | 新.axaml:306-337 | **R-3 降级注记随源语义**：四项 UI 随源（窗口层级变化时/前台窗口变化时/每 50ms/每 1ms，警示图标随源）；Description 附注记「钩子驱动的层级自动重检未启用（已批降级），本项仅保持配置兼容，层级在显式时点应用」——与 MainConfigData :316-318 已批注记（服务端不消费 `FloatingWindowLayerRecheckMode`）及 FloatingWindowService.cs:29-32 一致 |
| W17 | 按规则隐藏 开关 + 编辑规则集按钮 | 源.axaml:469-486；源.cs 规则集抽屉 :69-80/:312-383 | 新.axaml:339-357 ＋ 新.cs:325-337（入口）/ :339-449（OpenRulesetDrawer + 抽屉开关/监听） | TwoWay → `floatingWindowRulesetEnabled`；规则集对象 = MainConfigData 既有 `floatingWindowRuleset`（SDK `Ruleset` 类型），**零新配置根成员**；编辑器 = SDK `RulesetControl`（in-drawer 类随源）+ 宿主 `SettingsPageBase.OpenDrawer` 抽屉机制；保存语义 = Save + `IRulesetService.NotifyStatusChanged` + `UpdateWindowState`；State 属性写入门防递归（IsRulesetStateProperty） |
| W18 | 方案选择面（现状核对项） | 源.axaml:48-68 | 新.axaml:17-48（阶段 1 骨架 :15-20 基础上随源补显示细节） | 骨架选择语义与源一致（p3-05 §2.2 现状核对结论维持）；补显示细节 = 源方案管理三按钮：新建（FAContentDialog 命名，重名静默返回随源）/打开悬浮窗配置文件夹/删除当前方案（删除当前方案时切回 Default）。VM 消费面见 §6；SelectFloatingWindowProfile 守卫修订注记见 §6-3。p3-05 W7 行「方案 ComboBox」经本页方案 expander 统一承载（阶段 1 骨架已立该面，源将 ComboBox 内嵌布局编辑器顶部栏；双 ComboBox 重复绑定同一列表为劣化面，故维持单一面，属 p3-05 §8 已批的实现决策面） |

配置变更统一管线：页面订阅 `ViewModel.Settings.PropertyChanged`（新.cs:113-155）——外观/层级 9 成员 → Save + `UpdateWindowState`；显示/规则开关 → Save + UpdateWindowState + `NotifyStatusChanged`；整窗规则集对象替换 → 重注册 + Save + Notify（源 OnSettingsPropertyChanged :136-174 经典外观子集，无源液态玻璃分支）。服务侧自订阅配置变更应用经典外观（FloatingWindowService.cs:477-498，p2-03 交付），页面管线为冗余直达，与源双路径形态一致。页面 OnDetachedFromVisualTree 解除全部订阅并 `ViewModel.Dispose()`（新.cs:76-89）。

## 2. C 档裁剪移除面 6 项留证（C16-C21）

「逐项零残留确认」= 对交付路径（SettingsPage\ 全目录）grep 断言 + 页面控件树人工核对；「裁剪依据」= p3-05 §3 引 06 已批条目。

| C | 面 | 源锚点 | 留证 |
| :-: | --- | --- | --- |
| C16 | 悬浮窗编辑页液态玻璃外观 ComboBox | 源.axaml:210-232（悬浮窗样式 4 项 + 液态玻璃） | 新.axaml 零残留：外观 expander 仅 W8-W14 经典外观 7 项（§1 表），无样式 ComboBox；`FloatingWindowAppearanceStyle` 配置成员零引用零增补（grep 0 命中） |
| C17 | 液态玻璃 4 Slider（玻璃模糊/折射/背景刷新频率/按钮弹性） | 源.axaml:234-295 | 新.axaml 零残留（外观 expander 无对应控件）；`FloatingWindowLiquidGlass`/`FloatingWindowGlassButtonScaleDip` grep 0 命中（p1-10 §12.5 漂移红线双保险） |
| C18 | 行拖拽机制（与 W7 共享源区间，单列防误判） | 源.axaml:82-197 拖拽锚点 + 源.cs :56-67/:170-801 拖拽处理器组 | 新实现零拖拽面：grep `DragDrop.`/`DoDragDropAsync`/`FloatingTriggerRowDragOver`/`FloatingTriggerItemDrag` 在悬浮窗编辑页交付面 **0 命中**（全目录 grep 命中的 7 处经逐条核实均为：① `RemoveFloatingTriggerRow*` 与模式 `MoveFloatingTrigger` 的**大小写不敏感子串误匹配**——实为 W7「删除行」合法 API；② VM 内 2 处 D6 注记行文字提及不迁方法名。零真实拖拽符号） |
| C19 | AiChat 语音输入按钮 | 源 AiChatSettingsPage.axaml:423-443（VoiceInputButton，Glyph EB80） | 新 AiChatSettingsPage.axaml 零残留：输入区按钮列 = 历史/新建对话/附件/停止/发送（骨架原样）＋ A 面补全按钮（§5-1），无语音按钮；grep `VoiceInput`/`CanToggleVoiceInput`/`IsVoiceInputActive`/`VoiceInputToolTip` 0 命中；VM 语音成员 p1-06 §4.2-3 裁剪面未回迁（AiChatSettingsViewModel 本批零改动） |
| C20 | About 题图 + Lyricify Lite 帮助 | 源 AboutSettingsPage.axaml:21-51（TitleImage 面板/AboutTitleImageCacheService）+ :154-160（Lyricify 帮助 expander）+ 源.axaml.cs:29/:38 | 新 About 页零残留（p1-06 骨架即不迁）：grep `AboutTitleImageCacheService`/`Lyricify` 仅命中注记行 3 处（axaml:11、axaml.cs:24-25），零代码/控件引用；本批将两文件注记更新为阶段 3 裁剪核验口径（「已批裁剪面，p3-02 C20 核验维持零残留不迁」），零功能代码改动 |
| C21 | PluginDebug 整页选项体 | 源 PluginDebugSettingsPage.axaml:25-362（玻璃调试全参数）+ :289-356（审批按钮玻璃）+ :367-（语音唤醒调试） | 维持零绑定占位（p1-06 §4.1）：页面仍无任何 `{Binding}`；本批两处文案/注记收口——①占位文案「调试选项将随后续阶段的完整整合提供。」→「源插件调试选项在本跨平台版本中未提供。」（阶段 3 收口后原文案构成虚假整合预期）；②axaml/axaml.cs 注记更新为 C21 已批裁剪核验口径（U5 排除 + 语音族裁剪）。零功能代码改动、零注册改动 |

**裁剪面零功能代码误伤声明**：C16-C21 全部为 UI/接线面核验与注记收口；本批未删除任何 C 档功能本体（源侧液态玻璃/语音族功能本体从未迁入，p2-03 §2、p2-09 §1.3 降级登记在案），未改动任何 A/B 档既有交付代码的行为（MainConfigData/服务/行动零触碰；仅共享 VM 增补段 + 一处方法守卫修订，见 §6-3）。

## 3. A 面补全 2 项（AiChat 页）

### 3-1 消息编辑 UI（源 :185-237）

- 新落点：`AiChatSettingsPage.axaml` :72-129——骨架消息模板内嵌源块：Content TextBlock（IsNotEditing）+ 编辑 TextBox（IsEditing，DraftContent TwoWay UpdateSourceTrigger=PropertyChanged，Min/Max 尺寸随源）+ 操作按钮行（复制 / 修改 / 保存并重新回答 / 取消修改，Glyph E58B/ECA7/EC9F 与 Theme TransparentButton 随源）。
- 用户消息门控：源将编辑块置于 IsUser 容器内；骨架模板为用户/助手共用模板且 `Models\AiConversation.cs`（不在本批写入集）无 `IsUser&&IsEditing` 复合成员，故以**嵌套容器 IsVisible 承载**（外层 IsUser → 编辑按钮 IsNotEditing → 保存/取消 IsEditing），语义等价、零模型改动。
- 处理器（新.cs:149-209，形态随 p1-04 交付 `Views\AiChatFloatingWindow.axaml.cs:310-377` 先例）：CopyMessageButton（IClipboard.SetTextAsync）/ EditMessage / ConfirmEditMessage（await + ScrollToConversationBottom）/ CancelEditMessage / EditedMessageInput Alt+Enter 提交。
- VM 消费：`BeginEditUserMessage`/`CancelEditUserMessage`/`CommitEditedUserMessageAsync` 均为 p1-06 §4.2-2 契约保留成员（p1-06 证据 :158 记 393/412/418），本批对 `AiChatSettingsViewModel.cs` **零改动**。

### 3-2 拖放遮罩接线（源 :478）

- 新落点：`AiChatSettingsPage.axaml` :13-18（页根 Grid `DragDrop.AllowDrop` + DragEnter/DragOver/DragLeave/Drop 四事件，形态随 `AiChatFloatingWindow.axaml:60-64` 先例）+ :202-204（`pluginControls:AiAttachmentDropOverlay x:Name="AttachmentDropOverlay" Grid.RowSpan="2"`，源 :478 同款）。
- 处理器（新.cs:211-269）：DragEnter/Over 共用 `AttachmentDropOverlay.ShowForFiles(fileCount, availableSlots, CanModifyAttachments)` 校验 + DragEffects；DragLeave → Hide；Drop → `AiAttachmentDropService.LoadAndConfirmAsync(owner, ...)` + AddPendingAttachments/ReportError/TryBegin-EndAttachmentUpdate（浮窗先例同款）。
- 页面适配注记：`LoadAndConfirmAsync` 首参为 `TopLevel`（p1-04 交付签名）；设置页为 UserControl 非 TopLevel，故 `owner = TopLevel.GetTopLevel(this)`（守卫：无法访问设置窗口时抛 InvalidOperationException）——与浮窗直传 `this`（Window 即 TopLevel）的差异面。

## 4. 强制约束逐项核销

| # | 约束 | 核销 |
| :-: | --- | --- |
| ① | 菜单树格式修订：预期零注册/菜单变更 | Plugin.cs 零触碰；交付路径 grep `RegisterActionIfEnabled|RegisterTriggerIfEnabled|AddSettingsPage` = **0** 命中；无意外注册行，无菜单归属声明需求 |
| ② | 条件文件规范 R-2/R-2a | 零新增条件面：交付路径 grep `#if\s+Platforms` = **0**；S4.2 扫描 ConditionalHits=**0**（p3-02-s42-scan-output.txt）；guard 符号面零新增 |
| ③ | macOS 兼容硬约束 | §7.1 五列自检表 13 项，覆盖本批全部新消费面 |
| ④ | S4.2 门禁 | `p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\SettingsPage -Scope Source`：8 文件，GateHits=0，ConditionalHits=0，InfoHits=0，**VERDICT: PASS，exit=0**（原始输出 `evidence\p3-02-s42-scan-output.txt`） |
| ⑤ | Roslyn 升级法自检 | §7.2：进程内 Roslyn 全工程树 + 检查专用存根，**本批 5 个交付 .cs error=0（warning=6 均为检查语境 [ObservableProperty] 字段伪影），COMPILE OK，exit=0**；dotnet build 实测沙箱拒绝（§0），官方构建属工部阶段级门禁 |
| ⑥ | 沙箱边界 | §0 声明全部满足；源插件/宿主全程只读 |

## 5. 共享 VM 改动申报（尚书省裁决口径；互注 p3-01）

### 5-1 界标与行号区间（终态实测，文件 887 行）

| 段 | 界标区间（行号） | 内容 |
| --- | --- | --- |
| 文件头 using 增补 | :1-9 | 原 3 行 using 基础上增补 7 行（System / System.Collections.Generic / System.ComponentModel / System.Linq / ClassIsland.Core.Abstractions.Services / ClassIsland.Shared / SystemTools.CrossPlatform.Services） |
| p3-02 增补 I（页属类型段） | **:25-66** | `FloatingTriggerItem`（ButtonId/Icon/ButtonName/Config 字段 + IconSource 计算属性 + OnIconChanged 部分方法实现；源 :54-75 非拖拽子集）、`FloatingTriggerRow`（Buttons/RowIndex/RowRuleset；源 :77-83，D6 口径不携带拖拽状态） |
| p3-02 增补 II（构造与订阅段） | **:113-139** | `_floatingWindowService`/`_entriesChangedHandler` 字段 + 三参构造（注入 FloatingWindowService，订阅 EntriesChanged → UIThread.Post(RefreshFloatingTriggers)）；两参构造保持 p1-06 原签名原函数体（p3-01 主页消费面不变） |
| p3-02 增补 III（页属成员段） | **:193-690** | CurrentFloatingWindowProfile / FloatingWindowProfilesDirectory / AddFloatingWindowProfile / RemoveFloatingWindowProfile / FloatingTriggerRows / HasFloatingTriggerEntries / RefreshFloatingTriggers / OnButtonConfigPropertyChanged / OnRowRulesetPropertyChanged / NotifyRulesetStatusChanged / IsRulesetStateProperty / AddFloatingTriggerRow / InsertFloatingTriggerRow / RemoveFloatingTriggerRow / PersistFloatingTriggerRows / AreRowsEqual / Dispose（共 17 成员；源 :119/:120/:401-574/:609-689/:782-860/:908-911 非拖拽子集） |
| **p3-01 段（本批零触碰，互验完整）** | :68-100（条目类型段：FeatureItemType/UnifiedFeatureItem）、:693-886（抽屉消费面段：FeatureItems/FeatureSearchResults/IsFeatureSearchEmpty/IsFeatureDrawerOpen/FeatureDrawerContent/InitializeFeatureItems/UpdateFeatureSearchResults/MatchesFeatureSearch/SaveFeatureSettings） | p3-01 申报成员清单（其段 :693-697 自declaration）与本批整文件复读实测逐项一致；两段成员与 p3-02 段**零重名**（Roslyn 全编译佐证） |

### 5-2 段外修订 1 处（本批申报的悬浮窗方案面内）

- `SelectFloatingWindowProfile`（:166-191）：当前方案文件存在性守卫——只在 `_profileManager.ProfileFileExists(CurrentProfileName)` 时先 SaveProfile（对齐 A3 行动 `Actions\ToggleFloatingWindowProfileAction.cs:113-118` 同款守卫与源服务 SwitchToProfile :1525-1529 注释语义）；修订前骨架版误判**目标**方案文件存在性，删除当前方案流程会将被删方案回写磁盘复活。方法体内以注释标明 p3-02 修订与依据；另补 `OnPropertyChanged(nameof(CurrentFloatingWindowProfile))`（新增 CurrentFloatingWindowProfile 属性联动）。

### 5-3 协作过程合规（裁决①②③④逐条）

- ① 全部共享 VM 改动为**边界锚定增量 edit**（零整文件写入），p3-02 三段均以 `===== p3-02 增补开始/结束 =====` 界标包裹（沿 MainConfigData 三批先例）；
- ② 收口前整文件复读 100% 覆盖（:1-887 分六窗读毕）：p3-01 两段完整无损、成员清单与其段内申报一致、零语法冲突、单一类收尾花括号（:887）；
- ③ 未发现对方段被覆盖/损坏（其段于本批自检前完整落盘；其条目枚举段注释行含 `EnableExperimentalFeatures` 字样 1 处，属其 C 裁剪注记行，按 p3-05 §7-2「注记行除外」口径不计零残留违反）；
- ④ RefreshFloatingTriggers 定义与调用自闭合（编译通过佐证）。

## 6. 缺陷登记与修复（含 p3-01 上报转修复项）

| # | 缺陷（检查轮次） | 根因 | 修复 | 来源 |
| :-: | --- | --- | --- | --- |
| D1 | VM:459 等 `IRulesetService` CS0246 | 类型实测位于 `ClassIsland.Core.Abstractions.Services`（宿主检出 ClassIsland.Core\Abstractions\Services\IRulesetService.cs:11），非 ClassIsland.Shared | VM 文件头 + FloatingWindowEditorSettingsPage.axaml.cs 补 `using ClassIsland.Core.Abstractions.Services;`（2 文件 2 处） | **p3-01 上报、尚书省转修复指令；本批独立复证后修复** |
| D2 | AiChat 页 `SetTextAsync` CS1061 | Avalonia 12 中 `SetTextAsync` 为 `Avalonia.Input.Platform.ClipboardExtensions` 扩展方法（Avalonia.Base.dll 符号实测），缺命名空间 using | AiChatSettingsPage.axaml.cs 补 `using Avalonia.Input.Platform;`（随 Views\AiChatFloatingWindow.axaml.cs:10 先例） | 本批自检发现 |
| D3 | `LoadAndConfirmAsync(this)` CS1503 | SettingsPageBase 为 UserControl 非 TopLevel（浮窗为 Window 直传合法） | 改传 `TopLevel.GetTopLevel(this)` + 守卫（§3-2 注记） | 本批自检发现 |
| D4 | FAContentDialog.ShowAsync() 无参重载弃用 | 与本仓 p1-06 审批对话框先例（ShowAsync(TopLevel)）形态不一 | 统一 `ShowAsync(topLevel)` + TopLevel 守卫 | 本批自检发现 |
| D5 | 检查脚本首轮 stub 以点状类名（`public partial class A.B.C`）书写 | 错误恢复产生名为 `SystemTools` 的伪类型，遮蔽 `SystemTools` 命名空间，致全树类型解析污染（检查工具问题，非交付面缺陷） | stub 改块级 namespace 形态复跑通过 | 本批自检发现（登记供后续批复用脚本） |

## 7. 自检输出与 macOS 表

### 7-1 macOS 兼容自检表（p1-05 §5.3 五列格式；覆盖本批新消费面；BCL 项注明）

| # | 源点（本批交付文件:行） | 依赖/符号 | 适配方式 | macOS 语义 |
| :-: | --- | --- | --- | --- |
| 1 | FloatingWindowEditorSettingsPage.axaml.cs:341/:447 | `SettingsPageBase.OpenDrawer`/`OpenDrawerCommand`（设置窗口抽屉） | 宿主跨平台 API（ClassIsland.Core；p3-05 §6 既有消费先例面） | 可用 |
| 2 | FloatingWindowEditorSettingsPage.axaml.cs:377 | `ClassIsland.Core.Controls.Ruleset.RulesetControl`（in-drawer） | SDK 跨平台控件 | 可用 |
| 3 | 新.cs 多处 | `IAppHost.GetService/TryGetService`（ClassIsland.Shared） | 宿主抽象（p1-06 全批先例） | 可用 |
| 4 | 新.cs:145/:152 等；VM:459 | `IRulesetService.NotifyStatusChanged`（ClassIsland.Core.Abstractions.Services） | 宿主抽象 | 可用 |
| 5 | VM :258-271/:684-686 等 | `FloatingWindowService.Entries/EntriesChanged/EnsureUniqueButtonIds/UpdateWindowState/ConvertIcon/ProfileManager` | 插件内服务（p2-03 交付，跨平台面） | 可用 |
| 6 | VM :214/:227/:277 等 | `FloatingWindowProfileManager.CreateProfile/RemoveProfile/SaveProfile/LoadProfile/ProfileFileExists/GetProfileNames/ProfilesDirectory` | 插件内共享类型（p1-03 交付）＋BCL 文件 IO | 可用（BCL） |
| 7 | 新.axaml TwoWay 绑定全表 | MainConfigData B 档成员 14 个（:329-:518 只读消费）+ A 档既有成员 | 插件内配置根（p2-03/p2-05 已批面） | 可用 |
| 8 | 新.cs:231-244 | `Process.Start(ProcessStartInfo UseShellExecute=true)` 打开配置文件夹 | BCL | 可用（macOS 经 open 打开目录） |
| 9 | 新.cs:224-226 | `FAContentDialog.ShowAsync(TopLevel)` | FluentAvalonia 跨平台 API（p1-06 审批对话框先例） | 可用 |
| 10 | AiChatSettingsPage.axaml:13-18 | `DragDrop.AllowDrop/DragEnter/DragOver/DragLeave/Drop` 附加事件 | Avalonia 跨平台 API（浮窗先例同款） | 可用 |
| 11 | AiChatSettingsPage.axaml:202-204；.cs:211-269 | `AiAttachmentDropOverlay.ShowForFiles/Hide`、`AiAttachmentDropService.LoadAndConfirmAsync`、`AiAttachmentDropConfirmation` | 插件内已交付面（p1-04）＋Avalonia | 可用 |
| 12 | AiChatSettingsPage.axaml.cs:158-160 | `IClipboard.SetTextAsync`（ClipboardExtensions） | Avalonia 跨平台 API（浮窗 :321 先例同款） | 可用 |
| 13 | VM :132-134 | `Avalonia.Threading.Dispatcher.UIThread.Post` | Avalonia 跨平台 API | 可用 |

### 7-2 自检命令与原始输出（复核方重放）

```powershell
# 1) S4.2 门禁（预期 GateHits=0 / ConditionalHits=0 / VERDICT: PASS / exit=0）
& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\SettingsPage -Scope Source
#    原始输出：evidence\p3-02-s42-scan-output.txt

# 2) Roslyn 补充编译自检（预期 本批 error=0 / COMPILE OK / exit=0）
& .tang\cases\stcp-cross-platform-001\evidence\p3-02-supplementary-compile-check.ps1
#    原始输出：evidence\p3-02-supplementary-compile-check-output.txt（含存根构成与他批噪声单列）

# 3) 漂移红线（预期 0；Select-String 大小写不敏感，"RemoveFloatingTriggerRow" 与
#    "MoveFloatingTrigger" 为子串误匹配、VM 注记行 2 处为 D6 口径文字，均非拖拽符号）
Get-ChildItem src\SystemTools.CrossPlatform\SettingsPage -File | Select-String `
  -Pattern 'IsBackgroundMaterialEnabled|FloatingWindowAppearanceStyle|FloatingWindowLiquidGlass|FloatingWindowGlassButtonScaleDip|DoDragDropAsync|DoDragDrop|FloatingTriggerRowDragOver|FloatingTriggerItemDrag'

# 4) C 档成员/语音族零代码命中（预期仅注记行）
Get-ChildItem src\SystemTools.CrossPlatform\SettingsPage -File | Select-String `
  -Pattern 'EnableExperimentalFeatures|EnableFfmpegFeatures|EnableFaceRecognition|EnableWindowsHello|AutoOpenUsbDriveOnInsert|Lyricify|AboutTitleImageCacheService|VoiceInput|AiWakeWord'

# 5) 注册行/条件面/命名空间（预期 0）
Get-ChildItem src\SystemTools.CrossPlatform\SettingsPage -File | Select-String `
  -Pattern 'RegisterActionIfEnabled|RegisterTriggerIfEnabled|#if\s+Platforms|using SystemTools\.(?!CrossPlatform)|namespace (?!SystemTools\.CrossPlatform)'

# 6) 双分支字节检索（p1-10 §12.5 红线，沿 p2-03 §6.4 方法）
$b=[IO.File]::ReadAllBytes("$env:USERPROFILE\.nuget\packages\classisland.core\2.1.1.1\lib\net10.0\ClassIsland.Core.dll");([Text.Encoding]::ASCII.GetString($b)).Contains('IsBackgroundMaterialEnabled')
```

实测：1) PASS exit=0；2) OK exit=0；3)-5) 均 0（见 §1/§2/§4 留证）；6) 沿用 p1-10 §12.5 事实（NuGet 2.1.1.1 无该符号），本批交付面零引用该符号（grep 3 已证）。

### 7-3 W9 范围勘误与差异申报（回报尚书省）

1. **W9 勘误**：p3-05 §2.2 W9 注「范围随源（16–120）」与源实测（15-50，源.axaml:328-329）不符；本批按「范围随源」取 15-50（与 MainConfigData 钳制面一致）。请修订 p3-05（§0-4 冲突规则）。
2. **W18 结构适配**：方案 ComboBox 维持阶段 1 骨架独立 expander 承载（单一面），源「ComboBox 内嵌布局编辑器顶部栏」不复刻，理由见 §1 W18 行注记——属 p3-05 §8 已批实现决策面。
3. **PluginDebug 占位文案更正**（§2 C21）：非功能改动，防虚假整合预期。

## 8. 边界声明

- 本文件不派工、不审批、不推进全局工作流；为 p3-02 批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。
- p3-08 刑部交叉核对口径：本批共享 VM 段成员清单见 §5-1（三段界标 + 17 成员 + 2 字段 + 三参构造 + 1 处守卫修订 + 7 行 using 增补）；p3-01 段成员清单以 :693-697 其段自declaration 为准，本批零触碰。

## 9. 修订记录

- 初版（p3-02 执行交付；W6-W18/C16-C21/A 面补全/VM 申报/自检留证全数在案；含 p3-01 上报转修复项 D1）。
