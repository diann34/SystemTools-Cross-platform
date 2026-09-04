# p3-09 证据：设置整合后映射基线维护（吏部 personnel / repository-governance / analysis）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-09 · 吏部 personnel · repository-governance / analysis（阶段 3 验证收尾——闸门故障恢复 plan；依赖 p3-05/p3-01/p3-02/p3-03/p3-06 均已记录 succeeded，本 plan 仅验证收尾） |
| 权威输入 | p2-09-personnel-mapping-update.md（阶段 2 基线：A33+B19 落点/注册行/计数 98/p1-05 §8 六步重放口径）；p3-05-personnel-settings-integration-spec.md（含 R1 勘误：W9 15-50、W18 单面、C21 文案）；p3-01/p3-02（整合落点与 VM 终态）、p3-03（命名空间零调整认证）、p3-06（契约核对 + docs 文档落盘）各批证据 |
| 文件性质 | **阶段 3 增量映射记录**，与 p2-09（阶段 2 基线）/p1-09（A33 基线）并列作为阶段 4 映射基线；只登记阶段 3 整合面与既有基线零回退复核，不重写 A33/B19 明细 |
| 写入范围 | 仅本证据文件；`src\` 产品文件、源插件检出、宿主检出全程只读（本轮全部操作为只读检索/读取/扫描/哈希/扫描器复跑）；零产品文件改动 |
| 结论速览 | **succeeded** —— ①阶段 3 整合面登记 33 项闭合（W1-W18 接线 18 + A 面补全 4 + 共享 VM 增补段 5 + 段外守卫修订 1 + 修复 4 + docs 文档 1，逐项源锚点/新落点/归属批，§1）；②既有基线零回退（A33 非设置页锚点全数零漂移、S4 六页 SettingsPageInfo 锚点重映射 32/22/40/41/29/16、Plugin.cs 注册面 37+4 调用与组门/生命周期行逐值相等且 mtime 冻结于 11:17:15、MainConfigData 17 个 B 成员行号零漂移，§2）；③计数闭合 **98 = A33+B19+C46 维持**（52 已纳 + 46 C 零迁入，§2.6）；④C1-C21 裁剪面 + 41 项抽屉白名单已基线化（残留复扫 13 处全部注记级，白名单 41=29+2+6+4 与注册面一一对应，§3）；⑤p1-05 §8 六步重放（阶段 3 扩展口径，含 docs 产品面清点 204）全过（§4）；⑥同装差异注记候选 4 项登记（§5） |

---

## 1. 阶段 3 整合面登记（与 p2-09 并列的阶段 3 增量记录，供阶段 4 基线引用）

口径：新落点为 p3-01/p3-02 批证据交付时的实测终态行号，本轮（p3-09）对现工作树**逐项抽查复核**（复核值随行注记，全部一致）；行号以 2026-09-04 案卷工作区终态为准。

### 1.1 六页 B 档接线落点 W1-W18（18 项；p3-01 = W1-W5，p3-02 = W6-W18）

| W | 页面 · 接线项 | 源锚点 | 新落点（终态实测；`S\`=`SettingsPage\`） | 批 | 本轮复核（现态锚点） |
| :-: | --- | --- | --- | :-: | --- |
| W1 | 主页 · 「启用功能选项」管理抽屉 | 源 axaml:167-176/:21-149；axaml.cs:524-557；VM:106-113/:174-381 | `S\SystemToolsSettingsPage.axaml` :14-19（DrawerHost）/ :21-146（模板）/ :270（闭合）/ :167-177（入口 expander，按钮 :173）+ `.axaml.cs:210/:218/:229/:238-243`（开/搜索/关/保存+RequestRestart）+ 共享 VM :693-886（§1.2） | p3-01 | ✅ :14/:21/:173/:270；cs :210/:218/:229/:238/:242 全在位 |
| W2 | 主页 · 「启用悬浮窗功能」开关组 | 源 axaml:199-206；axaml.cs:88-91 | `S\SystemToolsSettingsPage.axaml:188-197`（ToggleSwitch :194，随源相对序位于「更多功能选项」:181 与「AI 服务」之间）+ `.axaml.cs:247-253`（显式 Save+RequestRestart :253） | p3-01 | ✅ :188 注记/:194 开关；cs :250-:253 |
| W3 | 更多功能选项 · 自动切换 ClassIsland 主题 | 源 axaml:17-24；axaml.cs:26-36 | `S\MoreFeaturesOptionsSettingsPage.axaml:19-30`（开关 :25）+ `.axaml.cs:51-62`（ApplyConfig :59） | p3-01 | ✅ :19/:25；cs :51/:59 |
| W4 | 更多功能选项 · 主界面遮挡文字时 | 源 axaml:26-33；axaml.cs:61-70 | 同页 axaml :30-42（开关 :36）+ cs :65-76（ApplyConfig :73） | p3-01 | ✅ :30/:36；cs :65/:73 |
| W5 | 更多功能选项 · 自动清理 ClassIsland 内存 | 源 axaml:72-79；axaml.cs:72-82 | 同页 axaml :81-92（开关 :87）+ cs :79-90（ApplyConfig :87） | p3-01 | ✅ :81/:87；cs :79/:87 |
| W6 | 悬浮窗编辑页 · 「显示悬浮窗」开关 | 源.axaml:69-77；源.cs:202-222 | `S\FloatingWindowEditorSettingsPage.axaml:50-67` + `.axaml.cs:157-178` | p3-02 | 归属批证据终态（本批抽查覆盖 W8-W9/W15-W17 同页锚点全在位，见下） |
| W7 | 同页 · 按钮布局编辑器（非拖拽，D6 口径） | 源.axaml:42-197；源 VM:401-574/:609-689/:782-860 | 同页 axaml :50-166 + `.axaml.cs:259-337` + VM 增补段 :237-655（§1.2） | p3-02 | ✅ 同页无任何拖拽符号（§3.2 复扫 0 代码命中） |
| W8 | 同页 · 外观-悬浮窗缩放 Slider | 源.axaml:312-315 | 同页 axaml :173-192 | p3-02 | ✅ 绑定行 :183-186（FloatingWindowScale） |
| W9 | 同页 · 外观-图标大小 Slider | 源.axaml:327-333（实测 15-50） | 同页 axaml :193-212 | p3-02 | ✅ **R1 勘误现态核实：Minimum=15 / Maximum=50 / TickFrequency=1（:199-201）** |
| W10 | 同页 · 外观-文本大小 Slider | 源.axaml:344-349（8-25） | 同页 axaml :213-232 | p3-02 | 区间内（:213 起，W9 块后随序） |
| W11 | 同页 · 外观-透明度 Slider | 源.axaml:364-369（10-100） | 同页 axaml :233-252 | p3-02 | 区间内（随序） |
| W12 | 同页 · 外观-主题 ComboBox（4 项，第 4 项 D5 降级注记） | 源.axaml:381-400 | 同页 axaml :253-273 | p3-02 | 区间内（随序） |
| W13 | 同页 · 阴影效果开关 | 源.axaml:402-409 | 同页 axaml :274-281 | p3-02 | 区间内 |
| W14 | 同页 · 一直显示拖动把手开关 | 源.axaml:410-417 | 同页 axaml :282-289 | p3-02 | 区间内 |
| W15 | 同页 · 层级 ComboBox（置底/置顶） | 源.axaml:419-441 | 同页 axaml :291-305 | p3-02 | ✅ ComboBox :297（FloatingWindowLayer） |
| W16 | 同页 · 层级设置频率 ComboBox（4 项，R-3 降级注记） | 源.axaml:443-467 | 同页 axaml :306-337 | p3-02 | ✅ ComboBox :311（FloatingWindowLayerRecheckMode） |
| W17 | 同页 · 按规则隐藏开关 + 「编辑规则集…」按钮 | 源.axaml:469-486；源.cs:69-80/:312-383 | 同页 axaml :339-357 + `.axaml.cs:325-337/:339-449` | p3-02 | ✅ 注记 :339 / IsVisible :348 / IsChecked :353 |
| W18 | 同页 · 方案选择面（现状核对项+随源补显示细节） | 源.axaml:48-68 | 同页 axaml :17-48（阶段 1 骨架方案面统一承载；VM 消费 §1.2） | p3-02 | 结构适配已裁定（单面承载，§5-4 劣化面注记） |

**页归属互斥复核**：p3-01 仅触碰 `SystemToolsSettingsPage.*` / `MoreFeaturesOptionsSettingsPage.*`（+共享 VM 主页面），p3-02 仅触碰 `FloatingWindowEditorSettingsPage.*` / `AiChatSettingsPage.*` / `AboutSettingsPage.*` / `PluginDebugSettingsPage.*`（+共享 VM 悬浮窗面）——本轮 SettingsPage 目录 mtime 全集与两批申报写入窗口逐文件吻合（12:36:01-12:52:51），`AiChatSettingsViewModel.cs`（02:13，阶段 1）未被触碰。**AiChat/About/PluginDebug 三页 B 接线 = 0 项**（结构事实，p3-05 §2.2）。

### 1.2 A 面补全 4 项（p3-05 §3.4-2 派生；非 B 接线，登记防阶段 4 混淆）

| 项 | 源锚点 | 新落点（终态实测） | 批 | 本轮复核 |
| --- | --- | --- | :-: | --- |
| 主页页头标签（SystemTools/功能·主设置） | 源 axaml:153-165 | `S\SystemToolsSettingsPage.axaml:150-163` | p3-01 | 区间内（:150 起） |
| 主页「当前使用模型」显示项（A 档 AiModel 只读消费，替代源语音模型检查面） | 源 axaml:286-298 | 同页 axaml :255-264 | p3-01 | ✅ :255 适配注释在位（DependencyPaths，C13 不迁） |
| AiChat 消息编辑 UI（复制/修改/保存并重新回答/取消修改） | 源 AiChatSettingsPage.axaml:185-237 | `S\AiChatSettingsPage.axaml:72-129` + `.axaml.cs:149-209` | p3-02 | 归属批证据终态（D2/D3/D4 修复面同文件，§1.3 在位佐证） |
| AiChat 拖放遮罩接线（AiAttachmentDrop*） | 源 axaml:478 | 同页 axaml :13-18 + :202-204 + `.axaml.cs:211-269` | p3-02 | ✅ :9 注记 / :14 DragDrop.AllowDrop / :203 Overlay 在位 |

### 1.3 共享 VM 增补段终态（`SettingsPage\SystemToolsSettingsViewModel.cs`，887 行；五段界标 + 段外守卫修订，本轮逐行复读核实）

| 段 | 界标区间（本轮实测） | 内容 | 批 |
| --- | --- | --- | :-: |
| 文件头 using | :1-10（原 3 行 + p3-02 增补 7 行，含 D1 修复 `using ClassIsland.Core.Abstractions.Services` :6） | ✅ 实测 10 行（p3-02 §5-1 记 ":1-9" 为记录级 ±1，见 §6 M-1） | p3-02 |
| p3-02 增补 Ⅰ（页属类型段） | :25-66 | FloatingTriggerItem / FloatingTriggerRow | p3-02 |
| p3-01 增补 Ⅰ（条目类型段） | :68-100 | FeatureItemType / UnifiedFeatureItem | p3-01 |
| p3-02 增补 Ⅱ（构造与订阅段） | :113-139 | _floatingWindowService / _entriesChangedHandler + 三参构造 | p3-02 |
| p3-02 增补 Ⅲ（页属成员段） | :193-690 | 方案管理 + 按钮布局编辑器支撑 17 成员 | p3-02 |
| p3-01 增补 Ⅱ（抽屉消费面段） | :693-886 | FeatureItems / InitializeFeatureItems（41 项白名单）/ UpdateFeatureSearchResults / MatchesFeatureSearch / SaveFeatureSettings 等 | p3-01 |
| **段外守卫修订**（悬浮窗方案面内） | SelectFloatingWindowProfile :166-191（修订注记 :173，`ProfileFileExists` 守卫 :177；`OnPropertyChanged(nameof(CurrentFloatingWindowProfile))` 联动） | 修复删除当前方案回写复活缺陷（对齐 A3 行动守卫语义，p3-02 §5-2） | p3-02 |

界标五段与 p3-02 §5-1 终态记录**逐行相等**（p3-02 收口后零续写）；两批段成员零同名（p3-01 §4 / p3-02 §5-3 互验结论维持，Roslyn 编译自检双向 error=0 背书）。

### 1.4 阶段 3 修复 4 项（p3-02 §6 D1-D4；D5 为检查脚本 stub 修正属 evidence/ 工具面，不计产品修复）

| # | 缺陷 | 修复落点（本轮实测在位） | 来源 |
| :-: | --- | --- | --- |
| D1 | `IRulesetService` CS0246（命名空间缺） | VM :6 + `FloatingWindowEditorSettingsPage.axaml.cs:13` 补 `using ClassIsland.Core.Abstractions.Services;` | p3-01 上报、尚书省转修复 |
| D2 | `SetTextAsync` CS1061（扩展方法命名空间缺） | `AiChatSettingsPage.axaml.cs:9` 补 `using Avalonia.Input.Platform;`（消费 :161） | p3-02 自检 |
| D3 | `LoadAndConfirmAsync(this)` CS1503（非 TopLevel） | `AiChatSettingsPage.axaml.cs:242-243` 改传 `TopLevel.GetTopLevel(this)` + 守卫（同款守卫 :96-97/:159-160/:321/:410/:490） | p3-02 自检 |
| D4 | `FAContentDialog.ShowAsync()` 无参重载弃用 | 同文件统一 `ShowAsync(TopLevel)`（:321/:463/:540） | p3-02 自检 |

### 1.5 docs 文档落盘（p3-06）

`docs\coexistence-notes.md`：仓库唯一文档面，**142 行 / 13,133 字节**（mtime 2026-09-04 13:20:10），五节结构与 p3-05 §5 大纲逐节对应（一 并存形态 :9 / 二 Windows 专属与降级 :38 / 三 AD8 元数据差异 :89 / 四 G1-G3 平台面 :104 / 五 配置迁移与共存注意 :120），第 2/4 节表列逐条带 file:line 或登记条目号。p3-06 §1 结构对照结论维持。

### 1.6 注记收口面（p3-02 批内，零功能代码改动）

About 页两文件注记更新为阶段 3 裁剪核验口径（`AboutSettingsPage.axaml:11` / `.axaml.cs:24-25`，C20）；PluginDebug 占位文案更正「源插件调试选项在本跨平台版本中未提供。」（`PluginDebugSettingsPage.axaml:16`，C21，R1 裁定项）——本轮实测均在位。

**阶段 3 增量登记闭合校验：18（§1.1）+ 4（§1.2）+ 5 段+1 修订（§1.3）+ 4（§1.4）+ 1（§1.5）= 33 项登记**，另注记收口 2 组（§1.6）；每项可由源锚点/新落点/归属批三列回查对应批证据。

---

## 2. 既有基线零回退复核（p1-09/p2-09 基线 → 当前终态）

### 2.1 A33 非设置页锚点零漂移（全数复核，无一漂移）

| 域 | 本轮实测 | 基线 | 结论 |
| --- | --- | --- | --- |
| 行动 29 项 ActionInfo 行 | A1 KillProcess **:14**、A2 ShowToast **:11**、A3 ToggleFloatingWindowProfile **:20**、A4 SwitchFloatingWindowTheme **:16**、A5 BackgroundPlayAudio **:13**、A6 :18、A7 :13、A8 :15、A9 ShowAiChatDialog **:9**、A10 FullscreenClock **:11**、A11 :14、A12 :15、A13 :14、A14 :14、A15 :14；B1 Copy **:11**、B2 Move **:11**、B3 Delete **:11**、B4 Shutdown **:26**、B5 AdvancedShutdown **:45**、B6 CancelShutdown **:24**、B7 LockScreen **:25**、B8 :22、B9 :22、B10 Sleep **:23**、B11 ShowFloatingWindow **:20**、B12 ToggleFloatingWindowLayer **:20**、B13 AutoSwitchClassIslandTheme **:14**、B14 AutoHideMainWindowWhenOccluded **:14** | p1-09 §1.5（A15）+ p2-09 §1.1（B14）逐值 | ✅ 29/29 零漂移（Actions\ 目录 31 文件 = 29 行动 + SystemPowerCommand 条件对） |
| 规则 4 项 | ProcessRunning / UsingClassPlan / UsingTimeLayout / InTimePeriod RuleSettings 类型声明行全部 **:5** | p1-09 §1.3 | ✅ |
| 触发器 2 项 | G1 ActionInProgressTrigger TriggerInfo **:20**（p2-09 E-4 勘误值维持）；B-触发 FloatingWindowTrigger **:18**；`Config\FloatingWindowTriggerConfig.cs:13` class | p2-09 §1.2/§2.1 | ✅ |
| 主题 3 项 | 3 个 manifest.yml id = `SystemTools.CrossPlatform.Card-type-component` / `.classwidgets` / `.notch-style` | p1-09 §1.1 | ✅ |
| 组件 6 项 GUID | 056130C1…（:18 参数行）/ F3A18AE1… / 885F26B9… / 0182775C… / E6FC9A28… / E02A4DC6… 两两互异 | p1-09 §1.2 逐值 | ✅（GUID 字面量行较 p1-09 所记 ComponentInfo 行 +1 = 多行特性参数行测量口径差，非漂移，§6 M-2） |
| 通知提供方 3 GUID | 44BB7B21…（:9）/ DD9150A5…（:10）/ 4BEE12E4…（:14） | p1-09 §1.6-S1 | ✅ |
| 服务锚点 | S1 AiChatWindowService ShowAsync **:21**；S2 VirtualAfterSchool ApplyConfig **:62**；S3 VersionCheckService 导航 URI **:94**；S-主题 Start/Stop/ApplyConfig **:21/:27/:33**；S-遮挡 Start/Shutdown(bool)/Stop/ApplyConfig **:28/:58/:68/:74**；S-浮 FloatingWindowService.cs **49,628 字节** | p1-09 §1.6 + p2-09 §1.3 逐值 | ✅ 全部零漂移 |

### 2.2 S4 设置页锚点重映射（阶段 3 预期位移，登记为新基线；非回退）

p1-09 §1.6-S4 所记 6 页 SettingsPageInfo 行号（骨架态）经阶段 3 设置页重写后整体位移，本轮重映射：

| 页 | p1-09 基线 | 当前实测 | 位移 |
| --- | :-: | :-: | :-: |
| SystemToolsSettingsPage.axaml.cs | :26 | **:32** | +6 |
| MoreFeaturesOptionsSettingsPage.axaml.cs | :18 | **:22** | +4 |
| AiChatSettingsPage.axaml.cs | :33 | **:40** | +7 |
| FloatingWindowEditorSettingsPage.axaml.cs | :21 | **:41** | +20 |
| AboutSettingsPage.axaml.cs | :28 | **:29** | +1 |
| PluginDebugSettingsPage.axaml.cs | :16 | **:16** | 0 |

六页 `.axaml` 行数 271/94/360/206/154/21 与 p3-06 §3.1 记录逐项一致（p3-02 收口后零漂移）；注册 id 全部维持 `SystemTools.CrossPlatform.settings.*`。p3-05 §1.1 六页骨架现态锚点（如主页 AI 组 axaml :13-67、悬浮窗编辑页方案面 :12-28、VM :32-73）自阶段 3 整合后**被 p3-01/p3-02 终态取代**（§1.1/§1.3 即新基线），不再作为独立基线行引用。

### 2.3 Plugin.cs 注册面零变化核对（阶段 3 零触碰预期成立）

- **mtime 冻结**：`Plugin.cs` mtime = **2026-09-04 11:17:15**（= p2-06 收口写入时刻，p3-01 §7-⑥ 开工基线同值）——阶段 3 四批（p3-01/p3-02/p3-03/p3-06）均书面零触碰 + 本轮 mtime 复测同值。
- **注册调用重放**（内容级）：`RegisterActionIfEnabled` 调用 **29**（:276-:350）、`RegisterTriggerIfEnabled` **2**（:358/:364）、`RegisterComponentIfEnabled` **6**（:403-:413）、`AddRule` **4**（:376/:382/:388/:394）、`AddSettingsPage` **6**（:161/:162/:165/:171/:173/:174）+ `AddSettingsPageGroup` :160、`AddXamlTheme` 3（:84/:96/:108）——**37 Register\*IfEnabled + 4 AddRule，与 p2-09 §5-6 记录逐值相等**。
- **组门/生命周期行重放**：设置页门 aiChat :163-166 / 悬浮窗编辑页 :169-172；B11/B12 组门 :301-:311；A9 门 :326-:329；触发器门 :362；S1 DI 门 :138-146 + 提供方 :148-157；S-浮 Start 门 :197-200 / Stop 门 :245-248；S2 :136/:208/:236；S3 :211；S-主题 :128/:202/:230；S-遮挡 :129/:232；S-内存 :130-:131/:206/:234；监视器 :221-:222/:239/:241 + handler :193/:224-228——与 p2-09 §1.3/§1.4/§2.2 全表**逐值相等**。
- **零触碰面全集**：manifest.yml SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`（= p0-05/p2-09 基线逐字符）；MainConfigData.cs 553 行 @ 11:33:47；csproj @ 02:55:37；global.json @ 2026-09-03 22:15；`SystemTools-Cross-platform.slnx` @ 2026-09-03 22:16——阶段 3 零变化。

**结论：注册面唯一写入者 = 礼部（p1-06/p2-06），阶段 3 兵部/吏部/文档批零写注册面成立（§4-4 六步重放第 4 步）。**

### 2.4 B19 配置成员锚点零漂移（MainConfigData 17 个 B 档成员逐行重放）

`AutoSwitchClassIslandTheme` :252 / `AutoHideMainWindowWhenOccluded` :266 / `AutoCleanupClassIslandMemory` :291 / `EnableFloatingWindowFeature` :332 / `ShowFloatingWindow` :346 / `FloatingWindowScale` :360 / `FloatingWindowTextSize` :375 / `FloatingWindowIconSize` :390 / `FloatingWindowOpacity` :405 / `FloatingWindowShadowEnabled` :420 / `FloatingWindowDragHandleAlwaysVisible` :434 / `FloatingWindowPositionX` :448 / `FloatingWindowPositionY` :462 / `FloatingWindowLayer` :476 / `FloatingWindowLayerRecheckMode` :491 / `FloatingWindowRulesetEnabled` :506 / `FloatingWindowRuleset` [JsonPropertyName] :517 —— 与 p3-05 §1.2 基线（p2-03 增补段登记）**17/17 逐行相等**；阶段 3 零增补零改写（mtime 冻结佐证）。W2/W3/W4/W5/W6-W17 全部为只读消费既有成员。

### 2.5 其余零触碰佐证

Services/Actions/Rules/Triggers/Config/Views/Themes 等目录在 §2.1 锚点重放中全数命中基线值；S4.2 全树扫描 ConditionalHits=13 恰为阶段 2 已登记 4 个条件文件（§4-5），零新增条件面；p3-03 三时点认证（12:31-12:39）与本轮终态（13:20 后）之间仅 p3-01/p3-02 申报文件与 p3-06 docs 文件变化，无计划外触碰。

### 2.6 计数闭合 98 维持（04-spec §S4.1）

| 域 | 规范 | 实测 | 结论 |
| --- | --- | --- | --- |
| 行动 | 15 A + 14 B + 32 C | 29 落盘+注册（§2.1）；32 C 零落点（§3.2 复扫） | ✅ |
| 触发器 | 1 A + 1 B + 5 C | 2 落盘+注册（:358/:364）；5 C 零落点 | ✅ |
| 组件 / 规则集 | 6+1(C) / 4+1(C) | 6 / 4 落盘+注册；歌词/媒体 C 零落点 | ✅ |
| 主题 | 3 全 A | 3 落盘+注册 | ✅ |
| 服务（A 聚合 4 + B 聚合 4）+ 设置页 6 | 4+4+6 | S1-S4 + S-浮/主题/遮挡/内存 DI+lifecycle + 6 页注册（§2.3） | ✅ |
| **总计** | **A33 + B19 + C46 = 98** | 已纳 **52**（33+19）；C46 零迁入；阶段 3 新增功能项 **0**（docs 文档面不计项） | ✅ **98 闭合维持** |

---

## 3. C1-C21 裁剪面 + 抽屉 41 项白名单（结构性事实基线化，供阶段 4 同装差异/平台说明与终检引用）

### 3.1 C1-C21 裁剪面清单登记（p3-05 §3 权威 + 两批核验归属；本轮全树残留复扫背书）

| 项 | 裁剪面（页） | 源锚点（p3-05 §3） | 裁剪依据 | 零残留核验批 | 本轮复扫 |
| :-: | --- | --- | --- | :-: | :-: |
| C1 | 实验性功能开关组（主页） | 源 axaml:179-189 | 06 C 面不迁 | p3-01 §2 | ✅ 仅 VM:718 裁剪说明注记 |
| C2 | FFmpeg 功能开关（主页扩展功能） | 源 axaml:322-328；cs:321 | 06 条目 85 | p3-01 §2 | ✅ 0 命中 |
| C3 | FFmpeg 下载按钮+处理器+VM 逻辑 | 源 axaml:330-336；cs:490-498；VM:1329-1422 | 06 条目 86 | p3-01 §2 | ✅ 0 命中 |
| C4 | 人脸识别开关+凭据清理 | 源 axaml:339-357；cs:370-399 | 06 条目 80 | p3-01 §2 | ✅ 0 命中 |
| C5 | 人脸模型下载+VM 逻辑 | 源 axaml:351-356；VM:1422-1527 | 06 条目 86 | p3-01 §2 | ✅ 0 命中 |
| C6 | Windows Hello 开关+支持检测 | 源 axaml:360-366；cs:412-488 | 06 条目 81 | p3-01 §2 | ✅ 0 命中 |
| C7 | VoskWorker 下载 | 源 axaml:369-374；VM:998-1119 | 06 条目 77/86 | p3-01 §2 | ✅ 0 命中 |
| C8 | 语音识别模型 ComboBox+下载确认 | 源 axaml:380-399；VM:1143-1305 | 06 条目 76/77/86 | p3-01 §2 | ✅ 0 命中 |
| C9 | 下载状态文本+进度条 | 源 axaml:405-410 | 06 条目 86 | p3-01 §2 | ✅ 0 命中 |
| C10 | AI 语音唤醒开关（主页 AI 组） | 源 axaml:263-273 | 06 条目 78 | p3-01 §2 | ✅ 0 命中 |
| C11 | AI 唤醒词文本框 | 源 axaml:276-282 | 06 条目 76-79 | p3-01 §2 | ✅ 0 命中 |
| C12 | AI 对话悬浮窗样式 ComboBox（磨砂/液态玻璃） | 源 axaml:302-315 | U5/R-6 降级决议 | p3-01 §2 | ✅ 仅 MainConfigData.cs:93 注记 |
| C13 | 主页 VM 依赖检查/下载基础设施 | 源 VM:936-996/:1528-1562；cs:500-522 | 06 条目 86；p1-05 §1 | p3-01 §2 | ✅ 仅主页 axaml:255 适配注释 |
| C14 | 管理员内存清理组（MoreFeatures） | 源 axaml:81-116；cs:84-120 | 06 条目 84 | p3-01 §2 | ✅ 仅 Plugin.cs:188-189 既有注记 |
| C15 | USB 自动播放开关（MoreFeatures） | 源 axaml:118-123；cs:38-48 | 06 条目 70 | p3-01 §2 | ✅ 仅 Plugin.cs:335/:517/:637 既有注记 |
| C16 | 液态玻璃外观样式 ComboBox（悬浮窗编辑页） | 源 axaml:210-232 | U5/R-6；p2-05 §2.1 | p3-02 §2 | ✅ 仅 MainConfigData.cs:325 注记 |
| C17 | 液态玻璃 4 参数 Slider | 源 axaml:234-295 | U5/R-6 | p3-02 §2 | ✅ 仅 MainConfigData.cs:325-326 注记 |
| C18 | 行拖拽排序/拖动机制（D6 单列防误判） | 源 axaml:44/:82-197；源.cs:56-67/:170-801 | p2-03 D6 | p3-02 §2 | ✅ 0 真实拖拽符号（大小写子串误匹配已甄别） |
| C19 | AiChat 语音输入按钮 | 源 axaml:423-443 | 06 条目 77-79 | p3-02 §2 | ✅ VoiceInput 族 0 命中 |
| C20 | About 题图头 + Lyricify Lite 帮助 | 源 axaml:28-51/:154-159；cs:29 | 06 C 面 + AboutTitleImageCacheService 未迁 | p3-02 §2 | ✅ 仅 axaml:11 / cs:24-25 不迁注记 |
| C21 | PluginDebug 整页选项体 | 源 axaml:25-362/:367 起 | U5 + 语音 C | p3-02 §2 | ✅ 零绑定占位维持，收口文案 :16 在位 |

**零残留维持结论**：本轮对 src 全树（.cs+.axaml）38 组特征符号复扫共 **13 处命中，逐条人工归类全部为「说明不迁入」的文档性注记或批适配注释**（MainConfigData :93/:325/:326、About axaml:11/cs:24-25、主页 axaml:255、VM :718、Plugin.cs :187-188/:335/:517/:637），**零代码/UI/绑定/配置面命中**——p3-01 §2（C1-C15 15/15）与 p3-02 §2（C16-C21 6/6）结论独立复证成立；零 C 档功能本体误伤维持（p3-05 §3.4-1）。

### 3.2 抽屉 41 项白名单（结构性裁剪口径，p3-05 §3.4-3「注册面即白名单」）

- **构成**：行动 29 + 触发器 2 + 组件 6 + 规则 4 = **41 项**，ID 前缀 `SystemTools.CrossPlatform.*`，与 Plugin.cs 注册调用一一对应（37 Register\*IfEnabled + 4 AddRule）；服务 7 / 主题 3 / 设置页 6 不属抽屉可枚举面。
- **本轮机器复核**：共享 VM p3-01 段（:693-886）内唯一功能 ID = **41**；对 Plugin.cs 全部非 settings 唯一 ID（44）求差 = **41 白名单 + 3 主题 id**（Card-type-component/classwidgets/notch-style，:88/:100/:112），白名单外 ID **0 缺失 0 越界**。
- **门随源**（p3-06 §3.3 已核，本轮引用）：悬浮窗 5 条目挂 `EnableFloatingWindowFeature`（VM:750-753/:818-837 ↔ Plugin.cs:301/:362）；ShowAiChatDialog 挂 `EnableAiService`（VM:813-815 ↔ :326）；实验性门随 C1 整块移除。
- 名称/组别逐字随源（含源 quirk：「网络延迟」vs ComponentInfo 显示名、「 LED 文本仿真显示框」前导空格，p3-01 §1.1 / p3-06 §3.2 留痕）。

---

## 4. p1-05 §8 六步复核重放（阶段 3 扩展口径，含 docs 产品面清点）

### 4-1 树核对（扩展：产品面 = 源码面 + 文档面）
全树 **203 文件**（163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj，排除 bin/obj）= p2-09 §4.3 基线逐目录一致（阶段 3 零新增源码文件：p3-01/p3-02 均为既有文件编辑、p3-03 零写入）；**docs 1 文件 = coexistence-notes.md（p3-06）→ 产品面合计 204**。逐文件唯一归批维持（阶段 1/2 归账不变，阶段 3 增量 = §1 十面）。Source 面（扫描器口径）= **168**。

### 4-2 命名空间核对
`namespace (?!SystemTools\.CrossPlatform)` 对 163 .cs：**0 命中**；`using SystemTools.(?!CrossPlatform)`：**0 命中**——与 p3-03 §2（22 唯一命名空间/声明级六维审计 0 违例，独立方法复证）一致，本轮独立复跑同过。✅

### 4-3 ID 前缀核对
`"SystemTools\.` 全树（.cs/.axaml/.yml）命中 **243 行，0 非前缀**（较 p2-09 记录 202 行的 +41 = 抽屉白名单 41 项 ID 进入共享 VM，p3-01 交付；全部仍为 `SystemTools.CrossPlatform.*` 形态）；无尾段裸形态例外维持 3 处，行号重映射：`AiConversationStore.cs:27`（不变）/ `AiChatSettingsPage.axaml.cs:58`（原 :51）/ `SystemToolsSettingsPage.axaml.cs:48`（原 :42）——源插件形态 ID 字符串零出现。✅（p3-03 §2.4 按 p2-09 §5-3 背书口径，本轮扩展复跑）

### 4-4 注册面核对（内容级，git 不可用同 p1-09 §4-4）
1. Plugin.cs 742 行：37+4 注册调用与组门/生命周期行逐值重放相等（§2.3）；零兵部批/吏部批注册痕迹混入；
2. p3-01 §7-①/p3-02 §4-①/p3-03 §7/p3-06 §4-① 均书面零触碰 Plugin.cs/manifest/csproj + mtime/哈希复测同值（§2.3）；
3. MainConfigData 仅含阶段 2 增补段（§2.4 十七成员重放），阶段 3 零增补。
**结论：注册面唯一写入者 = 礼部（p1-06/p2-06）在阶段 3 终态维持成立。** ✅

### 4-5 门禁重放（时点注记：本任务执行时案卷尚无 p3-08 证据文件，故按派工口径引 p3-02/p3-03 收口留证为基线 + 本轮独立复跑）
- 批级收口基线：p3-02 §4-④（SettingsPage 面 8 文件 GateHits=0/PASS/exit=0）+ p3-03 §4（全树 168/0/13/6/2 PASS，12:37:58Z 时点）；
- **本轮独立复跑**（2026-09-04T05:55:51Z，对当前终态）：`p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source` → **SourceFiles=168、GateHits=0、ConditionalHits=13**（SystemPowerCommandWindows R21×5+R17×3 / ProcessMemoryMaintenanceNativeWindows R13+X04 / SystemShutdownMonitor R03 / SystemMotionPreferences R13+X04，与 p2-08 登记零新增）、**CommentOnly=6（csproj 既有注释）、InfoHits=2（I04）、VERDICT: PASS、exit=0**——与 p2-08/p3-03 权威基线**逐项一致**。✅

### 4-6 A33+B19 闭合清点
注册面机器复核（§2.3）：Register\*IfEnabled 37（行动 29 + 触发器 2 + 组件 6）+ AddRule 4；B 档 15 个注册 ID 逐一恰 1 次（:276-:365 逐行重放）；4 服务 DI + SystemShutdownMonitor 实例 + 维护接口对逐一在位。**33 + 19 = 52/52 维持** ✅（A33 逐项 = p1-09 §1 + 本文件 §2.1 复核；B19 逐项 = p2-09 §1 + 本文件 §2.1/§2.4 复核）。

---

## 5. 同装差异注记候选登记（供阶段 4 文档批与终检引用；零阻塞，均不属本任务写入边界）

| # | 候选 | 事实与锚点 | 裁定/处置 |
| :-: | --- | --- | --- |
| 1 | W3/W4 页面描述与 AD1/AD2 降级现状的预期差 | MoreFeatures axaml:23/:34 描述沿用源文案（「每两秒检测…偏暗时切换黑暗主题」「识别到至少 4 个文字字符时隐藏主界面」），实际行为 = 保存配置 + 服务提示不可用/已降级并保持当前状态（p3-06 §5-1；p2-02 AD1/AD2 登记；docs 第二节 2.4 已面向用户说明） | **文案维持随源**（「显示文案随源不改」纪律面）；转阶段 4 验收知悉：是否需页内注记由门下省/尚书省裁量（p3-06 原上报延续） |
| 2 | 主页导航 expander 标题省略号数差（1 字符） | 源 axaml:192「更多功能选项……」（双省略号）vs 新 axaml:181「更多功能选项…」（单省略号，与源页自身 SettingsPageInfo 显示名一致，源 MoreFeatures…axaml.cs:15）（p3-06 §5-2） | **装饰性**，零功能影响，登记知悉 |
| 3 | 悬浮窗编辑页页脚版权行未随源 | 源 axaml:488-493「Programmer_Wang ©2026」未迁（本轮实测该页无 Programmer_Wang 字样；About 页已含版权行）（p3-06 §5-3） | **装饰性**，零功能影响，登记知悉 |
| 4 | W18 方案面单一承载（双 ComboBox 收敛为单面）= 劣化面 | 源页内嵌顶部栏第二 ComboBox 形态不复刻，方案面由阶段 1 骨架 expander 统一承载（p3-05 §2.2 W18 + R1 勘误登记；p3-02 §1-W18/§7-3-2；尚书省已裁定适配） | **劣化面（非缺口）**：阶段 4 同装差异说明文档批引用 + 终检引用 |

---

## 6. 勘误与微漂登记（全部为记录级，零档位、零计数、零行为差异）

| # | 类型 | 内容 | 处置 |
| :-: | --- | --- | --- |
| E-5 | 基线锚点重映射 | S4 六页 SettingsPageInfo 锚点 26/18/33/21/28/16 → **32/22/40/41/29/16**（§2.2）——设置页重写预期位移，非回退 | 新基线以本文件 §2.2 为准 |
| E-6 | 基线锚点重映射 | 裸形态 ID 例外 3 处：AiChatSettingsPage.axaml.cs :51→**:58**、SystemToolsSettingsPage.axaml.cs :42→**:48**（AiConversationStore.cs:27 不变）（§4-3） | 新基线以本文件 §4-3 为准 |
| M-1 | 记录级微漂 | p3-02 §5-1 记共享 VM using 增补区间 ":1-9"，实测终态 **10 行 using（:1-10）**（原 3 + 增补 7 = 10；区间端点记录差 ±1） | 以本文件 §1.3 实测为准 |
| M-2 | 测量口径注记 | 组件 GUID：p1-09 所记为 `[ComponentInfo(` 属性行（如 C1 :17），本轮符号检索命中 GUID 参数行（:18，多行特性）；GUID 值逐字符相等，零漂移 | 归属行口径：属性行 = p1-09 值；GUID 参数行 = 本文件 §2.1 值 |

---

## 7. 边界声明与复核指引

- 本任务唯一写入 = 本证据文件；`src\` 产品文件、源插件检出（`E:\My Github Projects\SystemTools`）、宿主检出全程零改动（源侧事实全部取自 p0-03/p3-05 已固化证据，新插件侧全部为只读检索/扫描/哈希/扫描器复跑，与 p2-09 §8 口径一致）。
- 本文件不派工、不审批、不推进全局工作流；仅向尚书省回报 p3-09 结果，供门下省终验，并作为阶段 4 映射基线（与 p1-09/p2-09 并列）。
- 快速复核重放：
  1. 树清点：`Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object FullName -notmatch '\\(bin|obj)\\'`（应 203）+ `Get-ChildItem docs -Recurse -File`（应 1）；
  2. 门禁：`& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source`（应 168/0/13/PASS/exit 0）；
  3. 注册面：对本文件 §2.3 各行号重放 `Select-String -Path src\SystemTools.CrossPlatform\Plugin.cs -Pattern <ID>`；
  4. 零触碰：`Get-Item src\SystemTools.CrossPlatform\Plugin.cs` mtime 应为 2026-09-04 11:17:15；manifest SHA256 应 142CD419…AAC；
  5. 白名单：`Select-String -Path src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs -Pattern '"SystemTools\.CrossPlatform\.'` 去重应 41，且与 Plugin.cs 注册 ID 一一对应；
  6. C 残留：§3.1 38 组符号复扫非零命中应恰为 §3.1 所列 13 处注记行。

## 8. 修订记录

- 初版（p3-09 执行交付；基于 2026-09-04 案卷工作区终态实测——树 203+docs 1、Plugin.cs mtime 冻结核验、A33+B19 锚点全量重放、S4/裸形态/VM 界标重映射、C1-C21 残留复扫、白名单机器比对、S4.2 独立复跑）。
