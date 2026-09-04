# p4-05 证据：端到端验收重放与基线冻结终稿（吏部 personnel / repository-governance / analysis，阶段 4 项目终局项）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p4-05 · 吏部 personnel · repository-governance / analysis（阶段 4 终局项；依赖 p4-01/p4-02/p4-03/p4-04 均已记录 succeeded） |
| 权威输入 | p2-09-personnel-mapping-update.md / p3-09-personnel-mapping-update.md（映射基线：A33+B19 / C1-C21 / 白名单 41）；p4-01-justice-final-gates-and-remediation.md（裁量 2 文件现态 + O 项归类 + 终局扫描 168/0/13）；p4-02-works-release-readiness.md（发布就绪检查单 + G1/G3/cipx 终态登记）；p4-03-rites-final-docs.md + `.tang/cases/stcp-cross-platform-001/docs/coexistence-notes-final.md`（案卷终稿）；p4-04-revenue-release-budget.md（csproj/包闭包/预算链）；p0-01（宿主契约 G1–G3）；p1-05 §8（六步复核口径）；p1-09（A33 基线） |
| 写入范围 | 仅本证据文件；`src\` 产品文件、源插件检出、宿主检出全程只读（本轮全部操作为只读检索/读取/扫描/哈希 + 扫描器进程内复跑，零产品文件改动） |
| 本轮时点 | 2026-09-04（会话 UTC 07:2x–07:38Z；门禁复跑时点 2026-09-04T07:37:41Z） |
| 结论 | **succeeded** —— ①覆盖核对表 98=A33+B19+C46 终局重放全过（A33 33/33 零漂移含 E-5/E-6 重映射基线与 p4-01 两文件 +5/+3 行增量复映射；B19 19/19 逐项 + MainConfigData 17 成员逐行零漂移；C46 十四组特征名实体级 0 命中，§1）；②p1-05 §8 六步复核重放（终局版）全过：树 203+docs 初稿 1（案卷终稿不计仓库树）、命名空间 0/0、ID 前缀 243/0、注册面唯一写入者=礼部（Plugin.cs mtime 11:17:15 冻结）、门禁复跑 168/0/13 PASS exit=0（与 p4-01 权威结果逐项一致）、A33+B19 清点 52/52、阶段 1-4 记录链 p1-09→p2-09→p3-09→本件完整无缺口（§2）；③阶段 4 交付面 4 组逐项登记为最终基线组成部分（§3）；④基线冻结声明与实测树态一致（§4）；新登记记录级勘误 M-3（docs 初稿字节数，§5） |

---

## 1. 覆盖核对表 98 终局重放（98 = A33 + B19 + C46，O-9/O-5 裁量后现态）

### 1.1 A33 逐项终局重放（33/33 零漂移）

基线口径：p3-09 §1/§2（阶段 3 终态，含 E-5/E-6 重映射）+ 本轮 p4-01 两文件行号增量复映射（§1.3）。以下锚点均为本轮（2026-09-04，裁量后树态）实测。

**主题 3 项（p1-01）**：

| 项 | 终态锚点（本轮实测） | 基线 | 结论 |
| --- | --- | --- | :-: |
| T1 | `Themes\CardTypeComponent\manifest.yml` id = `SystemTools.CrossPlatform.Card-type-component` | p1-09 §1.1 | ✅ |
| T2 | `Themes\ClassWidgets\manifest.yml` id = `SystemTools.CrossPlatform.classwidgets` | 同上 | ✅ |
| T3 | `Themes\NotchStyle\manifest.yml` id = `SystemTools.CrossPlatform.notch-style` | 同上 | ✅ |

**组件 6 项（p1-01；GUID 值逐字符 = p1-09 §1.2，两两互异）**：

| 项 | ComponentInfo 属性行 | GUID 参数行（M-2 口径）/ GUID 值 | 结论 |
| --- | :-: | --- | :-: |
| C1 NetworkStatus | :17 | :18 · `056130C1-2B02-5BBE-A99F-C5EC448D6221` | ✅ |
| C2 ClipboardContent | :14 | :15 · `F3A18AE1-C153-5C1C-A660-D7E48DDDCC84` | ✅ |
| C3 LocalQuote | :23 | :24 · `885F26B9-DC4E-5DBC-9C65-64C185E5A532` | ✅ |
| C4 NextClassDisplay | :14 | :15 · `0182775C-049B-532C-BF56-14FC3CEC02A1` | ✅ |
| C5 BetterCarouselContainer | :22（单行特性，属性行=GUID 行） | :22 · `E6FC9A28-A104-50F2-95E3-B237F9CC4DAC` | ✅ |
| C6 ScrollingText | :17 | :18 · `E02A4DC6-88DE-551C-826F-A5262668AB3A` | ✅ |

**规则 4 项（p1-02）**：ProcessRunning / UsingClassPlan / UsingTimeLayout / InTimePeriod RuleSettings 类型声明行全部 **:5**（4/4，= p1-09 §1.3）✅

**触发器 1 项 A（p1-02）**：G1 `Triggers\ActionInProgressTrigger.cs` TriggerInfo **:20**（= p2-09 E-4 勘误值维持）；`Config\ActionInProgressTriggerConfig.cs` class 在位 ✅

**行动 15 项 A（p1-03）**：A1 KillProcess **:14**、A2 ShowToast **:11**、A3 ToggleFloatingWindowProfile **:20**、A4 SwitchFloatingWindowTheme **:16**、A5 BackgroundPlayAudio **:13**、A6 ActionFlowExecutionConfirmation **:18**、A7 TriggerCustomTrigger **:13**、A8 ToggleWorkflow **:15**、A9 ShowAiChatDialog **:9**、A10 FullscreenClock **:11**、A11 ClearAllNotifications **:14**、A12 LoadTemporaryClassPlan **:15**、A13 OpenAppSettings **:14**、A14 OpenProfileEditor **:14**、A15 OpenClassSwapWindow **:14** —— **15/15 `[ActionInfo](` 锚点零漂移**（= p1-09 §1.5 / p3-09 §2.1）✅

**服务/设置页聚合 4 项（p1-04 + p1-06）**：

| 项 | 终态锚点（本轮实测） | 基线 | 结论 |
| --- | --- | --- | :-: |
| S1 AI 文本链 | AiChatWindowService `ShowAsync` **:21**；3 通知 GUID `44BB7B21…`（:9）/ `DD9150A5…`（:10）/ `4BEE12E4…`（:14） | p1-09 §1.6 / p3-09 §2.1 | ✅ |
| S2 虚拟放学 | VirtualAfterSchoolService `public void ApplyConfig()` **:62** | p1-09 §1.6 | ✅（:37/:44/:97/:131 为调用点，定义行 :62 零漂移） |
| S3 版本检查 | VersionCheckService 导航 URI `classisland://app/settings/SystemTools.CrossPlatform.settings.about` **:94** | 同上 | ✅ |
| S4 设置页骨架 6 页 | SettingsPageInfo 行 **:32/:22/:40/:41/:29/:16**（E-5 重映射基线）；6 页 axaml 行数 **271/94/360/206/154/21** | p3-09 §2.2（E-5） | ✅ |

### 1.2 B19 逐项终局重放（19/19 + 非计数附属 2，零漂移）

**行动 14 项（p2-01/p2-02/p2-03）**：B1 Copy **:11**、B2 Move **:11**、B3 Delete **:11**、B4 Shutdown **:26**、B5 AdvancedShutdown **:45**、B6 CancelShutdown **:24**、B7 LockScreen **:25**、B8 ImmediateRestart **:22**、B9 ImmediateShutdown **:22**、B10 Sleep **:23**、B11 ShowFloatingWindow **:20**、B12 ToggleFloatingWindowLayer **:20**、B13 AutoSwitchClassIslandTheme **:14**、B14 AutoHideMainWindowWhenOccluded **:14** —— **14/14 `[ActionInfo](` 锚点零漂移**（= p2-09 §1.1 / p3-09 §2.1）✅

**触发器 1 项**：B-触发 `Triggers\FloatingWindowTrigger.cs` TriggerInfo **:18** + `Config\FloatingWindowTriggerConfig.cs` class **:13**（= p3-09 §2.1）✅

**服务 4 项（DI + lifecycle，本轮对 742 行 Plugin.cs 实测重放，= p2-09 §1.3 / p3-09 §2.3 逐值）**：

| 项 | DI | AppStarted | OnAppStopping | 结论 |
| --- | :-: | :-: | :-: | :-: |
| S-浮 FloatingWindowService | :127（49,628 字节实测同值） | Start 门 :197-200（:199） | Stop 门 :245-248（:247） | ✅ |
| S-主题 AdaptiveThemeSyncService | :128 | Start :202（服务内 :21/:27/:33 实测） | Stop :230 | ✅ |
| S-遮挡 MainWindowTextOcclusionService | :129 | Start :203（服务内 :28/:58/:68/:74 实测） | `Shutdown(restoreMainWindow: true)` :232 | ✅ |
| S-内存 ClassIslandMemoryAutoCleanupService | 接口对 :130 + :131 | ApplyConfig :206 | Stop :234 | ✅ |

**非计数附属 2 项（p2-05 §1.2 口径）**：SystemShutdownMonitor（W5 字段 :54 + new :133 / Start :134 + AddSingleton :135；W6 IsSessionEnding :221-222 → `CancelPlanOnAppStopping(isSessionEnding)` :239 → Dispose :241；W7 handler 定义区 :253-267（签名 :258）+ 双调用点 :193/:213 + 退订 :224-228——本轮 :193/:213/:239/:241/:258 实测命中，mtime 冻结下与 p2-09 §1.4 / p3-09 §2.3 逐值相等）✅；SystemMotionPreferences（注册面零引用维持，编译期分支承载）✅

**MainConfigData 17 个 B 档配置成员逐行重放（p3-09 §2.4 基线）**：

| 成员 | 基线（p3-09 §2.4） | 本轮实测 | 结论 |
| --- | :-: | :-: | :-: |
| AutoSwitchClassIslandTheme | :252 | `[JsonPropertyName]` :251 / 声明行 **:252** | ✅ |
| AutoHideMainWindowWhenOccluded | :266 | :265 / **:266** | ✅ |
| AutoCleanupClassIslandMemory | :291 | :290 / **:291** | ✅ |
| EnableFloatingWindowFeature | :332 | :331 / **:332** | ✅ |
| ShowFloatingWindow | :346 | :345 / **:346** | ✅ |
| FloatingWindowScale | :360 | :359 / **:360** | ✅ |
| FloatingWindowTextSize | :375 | :374 / **:375** | ✅ |
| FloatingWindowIconSize | :390 | :389 / **:390** | ✅ |
| FloatingWindowOpacity | :405 | :404 / **:405** | ✅ |
| FloatingWindowShadowEnabled | :420 | :419 / **:420** | ✅ |
| FloatingWindowDragHandleAlwaysVisible | :434 | :433 / **:434** | ✅ |
| FloatingWindowPositionX | :448 | :447 / **:448** | ✅ |
| FloatingWindowPositionY | :462 | :461 / **:462** | ✅ |
| FloatingWindowLayer | :476 | :475 / **:476** | ✅ |
| FloatingWindowLayerRecheckMode | :491 | :490 / **:491** | ✅ |
| FloatingWindowRulesetEnabled | :506 | :505 / **:506** | ✅ |
| FloatingWindowRuleset | [JsonPropertyName] :517 | **:517** / 声明行 :518 | ✅ |

**口径注**：p3-09 基线对前 16 成员记属性声明行（左列为 `[JsonPropertyName]` 行、右列为声明行，相差恒 1 行）、对 FloatingWindowRuleset 记 `[JsonPropertyName]` 属性行；本轮双口径分别实测，**17/17 逐值相等零漂移**（MainConfigData.cs 553 行 / mtime 11:33:47 阶段 4 零触碰，p4-04 §1 独立佐证）。

### 1.3 p4-01 裁量两文件行号增量复映射（本轮新基线，替代受影响旧行）

O-9/O-5 落盘（两文件 mtime 均 2026-09-04 14:46:57 = p4-01 §7.1）引起的锚点增量，**全部实测复核**：

| 文件 | 总行数 | 不受影响锚点（< 改动区） | 受影响锚点（复映射后 = 本件新基线） |
| --- | :-: | --- | --- |
| `SettingsPage\SystemToolsSettingsPage.axaml.cs` | 257 → **262**（+5） | SettingsPageInfo :32（E-5）、裸形态 ID :48（E-6）、3 处调用点 :115/:131/:135 —— 全部实测在位、零位移 | O-9 现态 **:187-203**（:187 裁量注记首行 / :190 去 static 定义 / :200-202 `TopLevel.GetTopLevel(this) ?? throw` + `ShowAsync(topLevel)` / :203 收口）；W1 cs 锚点 :210/:218/:229/:238-243 → **:215/:223/:234/:243-248**；W2 cs 锚点 :247-253 → **:252-258**（全部逐行实测命中，净位移恰 +5） |
| `Services\SystemShutdownMonitor.cs` | 135 → **138**（+3） | R03 `using System.Windows.Forms` **:5**（首非空行 `#if Platforms_Windows` :1 / 末非空行 `#endif` :138）——扫描器复跑命中位同值（§2-5） | O-5 授权链注释现态 **:11-17**（p2-05 §1.2 + p0-07 §11.1 R-2 授权链 + 06 条目 38 语义 + 笔误缘由注记，逐字实测）；「条目 46」残留恰 1 处 = 勘误注记自身（= p4-01 §2.2「订正后 0 处笔误表述」口径） |

### 1.4 C46 零迁入终局重放（维持）

本轮以 p2-09 §3.1 十四组特征关键词对现树（.cs/.axaml/.yml，排 bin/obj）独立复扫：

| 组 | 命中 | 逐条归类 |
| --- | :-: | --- |
| C1-C6 模拟键 / C7-C11 输入窗口 / C12-C13 鼠标禁用 / C14-C17 显示拓扑 / C18-C19 黑屏桌面 / C20 亮度 / C21-C23 个性化 / C 组件规则 / C 触发器 5 | **全 0** | — |
| C24-C26 设备/USB | 3 行 | Plugin.cs :335/:517/:637 注记（= p2-09 §3.2-e 同位） |
| C27-C28 语音 | 1 行 | Plugin.cs :188 AppStarted 头注（AiVoiceConversationService，= p2-09 §3.2-b 区块） |
| C29-C32 截图/音量/摄像头/提权 | 2 行 | VM :716（C1 白名单收口 doc 注记块 :713-719 内 RestartAsAdmin 提及）+ Plugin.cs :518（RestartAsAdmin 注记，= p2-09 §3.2-e） |
| C 服务/认证 7 | 3 行 | SystemToolsSettingsPage.axaml :254（A 面补全适配注记块 :254-256 内 Vosk 提及；DependencyPaths 行 :255 = p3-09 C13 登记位）+ Plugin.cs :188/:189（AppStarted 头注，= p4-01 §6.1 C14/C15 登记位） |
| 死代码/U5/其他未迁 | 7 行 | MainConfigData :93/:325、About axaml :11 / .axaml.cs :24、SystemToolsSettingsPage.axaml :255、Plugin.cs :82/:187 —— 与 p2-09 §3.2-c/d + p3-08 §4.1 + p4-01 §6.1 已登记注记清单同位同类 |

**结论：C46 特征实体命中 = 0**；全部非零命中逐条归档为已登记「说明不迁入」文档性注记（多行注记块内关键词命中行随块内行位浮动，注记块本身与 p3-08 §4.1 / p4-01 §6.1 登记清单一一对应，零未登记残留、零代码/UI/绑定/配置面命中）。**C46 零迁入维持成立**；C1-C21 裁剪面（15 处注记清单）由 p4-01 §6.1 于裁量后终态独立复证（2026-09-04），本件引用。

### 1.5 计数闭合 98 = A33 + B19 + C46（维持）

| 域 | 规范（04-spec §S4.1） | 终局实测 | 结论 |
| --- | --- | --- | :-: |
| 行动 | 15 A + 14 B + 32 C | 29 落盘+注册（§1.1/§1.2）；32 C 零落点（§1.4） | ✅ |
| 触发器 | 1 A + 1 B + 5 C | 2 落盘+注册（:20/:18）；5 C 零落点 | ✅ |
| 组件 / 规则集 | 6+1(C) / 4+1(C) | 6 / 4 落盘+注册；歌词/媒体 C 零落点 | ✅ |
| 主题 | 3 全 A | 3 落盘+注册 | ✅ |
| 服务（A 聚合 4 + B 聚合 4）+ 设置页 6 | 4+4+6 | S1-S4 + S-浮/主题/遮挡/内存 DI+lifecycle + 6 页注册（§2-4） | ✅ |
| **总计** | **A33 + B19 + C46 = 98** | 已纳 **52/52**（33+19）；C46 零迁入；阶段 4 新增功能项 **0**（裁量 2 文件为既有项内注释/形态级、终稿为案卷文档面均不计项） | ✅ **98 闭合维持** |

---

## 2. p1-05 §8 六步复核重放（终局版）

### 2-1 树核对（实测为准）

`src\SystemTools.CrossPlatform` 全树（排 bin/obj）**203 文件** = 163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj（本轮 Group-Object 实测，与 p2-09 §4.3 / p3-09 §4-1 / p4-04 §5.1 基线逐目录一致；阶段 4 零新增/零删除，p4-01 仅改写 2 个既有文件）。仓库级 docs **1 文件** = `docs\coexistence-notes.md`（p3-06 初稿；142 行 / mtime 2026-09-04 13:20:10 与 p3-09 §1.5 记录同秒，零触碰——字节数记录勘误 M-3 见 §5）→ 仓库产品面合计 **204**。案卷终稿 `.tang/cases/stcp-cross-platform-001/docs/coexistence-notes-final.md`（197 行 / 22,437 B / mtime 15:22:59）属案卷目录，**不计仓库树**。每文件唯一归批（阶段 1/2/3 归账 + §3 阶段 4 增量）维持。Source 面（扫描器口径）= **168**。

### 2-2 命名空间核对（独立复跑）

对 163 个 .cs：`namespace\s+(?!SystemTools\.CrossPlatform)` = **0 命中**；`using\s+SystemTools\.(?!CrossPlatform)` = **0 命中**（本轮独立复跑；与 p3-03 §2 / p3-09 §4-2 / p4-01 终局一致）✅

### 2-3 ID 前缀核对（独立复跑）

`"SystemTools\.` 全树（.cs/.axaml/.yml）命中 **243 行，0 非前缀**（= p3-09 §4-3 基线逐值；p4-01 未引入新 ID 字符串）；无尾段裸形态例外恰 3 处、位置 = E-6 重映射基线：`AiConversationStore.cs:27` / `AiChatSettingsPage.axaml.cs:58` / `SystemToolsSettingsPage.axaml.cs:48`（本轮逐行实测）。**源插件形态 ID 字符串零出现** ✅

### 2-4 注册面核对（唯一写入者 = 礼部）

- **mtime 冻结**：Plugin.cs **742 行 / mtime 2026-09-04 11:17:15**（= p2-06 收口时刻，阶段 3/4 全程零触碰；p4-01 §6.4/p4-03 §2 独立复测同值，本件第三重复测同值）。
- **注册调用机器复核（本轮）**：`Register\w*IfEnabled` 提及 **43** = 调用 **37**（29 行动 + 2 触发器 + 6 组件，逐类清点实测）+ 定义 4 + doc 1（:38）+ region 1（:419）（= p4-01 §6.4 结构）；`AddRule` 4（:376/:382/:388/:394，:373 为注记提及）；`AddSettingsPageGroup` :160 + `AddSettingsPage` 6（:161/:162/:165/:171/:173/:174）；`AddXamlTheme` 3（:84/:96/:108）。
- **组门/生命周期行重放**：设置页门 aiChat :163-166 / 悬浮窗编辑页 :169-172；B11/B12+恢复点门 :301-311；A9 门 :326-329；触发器门 :362；S1 DI 门 :138-146 + 提供方 :148-157；S-浮 Start :197-200 / Stop :245-248；S2 :136/:208/:236；S3 :211；S-主题 :128/:202/:230；S-遮挡 :129/:203/:232；S-内存 :130-131/:206/:234；监视器 :133-135/:221-222/:239/:241 + handler :193/:213/:224-228（定义区 :253-267，签名 :258）——与 p2-09 §1.3/§1.4/§2.2 + p3-09 §2.3 全表逐值相等。
- **唯一 ID**：Plugin.cs `"SystemTools\.` 唯一 ID **45 / 0 非前缀**（= p4-01 §6.4）。
- **禁改面哈希**：manifest.yml SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`（= p0-05 基线逐字符）；csproj SHA256 = `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A`（= p4-04 §1 终态）；MainConfigData.cs 553 行（mtime 11:33:47）；共享 VM 887 行（mtime 12:52:32）——阶段 4 零触碰。

**结论：注册面唯一写入者 = 礼部（p1-06/p2-06），阶段 1-4 终态维持成立。** ✅

### 2-5 门禁重放（引 p4-01 权威结果 + 本轮独立复跑留证注记时点）

- **权威基线**：p4-01 §4.1 终局扫描（2026-09-04T06:50:44Z，裁量落盘后）：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、VERDICT PASS、exit=0；CONDITIONAL=13 与 p2-08 §3.1 逐字节一致（差集=0）。
- **本轮独立复跑**（吏部 p4-05，时点 **2026-09-04T07:37:41Z**，`p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source` 进程内直跑，输出原文留证于本节）：

```
=== S4.2 SCAN (stcp-cross-platform-001 / p0-07) ===
Path     : src\SystemTools.CrossPlatform      Scope: Source      ScannerRev: R-2
Time(UTC): 2026-09-04T07:37:41Z
[CONDITIONAL] Actions\SystemPowerCommandWindows.cs | R21 | :48/:56/:60/:64/:68 | R17 | :50/:72/:77   （8）
[CONDITIONAL] Services\ProcessMemoryMaintenanceNativeWindows.cs | R13+X04 | :25                （2）
[CONDITIONAL] Services\SystemShutdownMonitor.cs | R03 | :5                                     （1）
[COMMENT-ONLY] SystemTools.CrossPlatform.csproj | P01–P06 | :79                                 （6，非门禁）
[INFO] Views\SystemMotionPreferences.cs | I04 | :28/:43                                          （2）
[CONDITIONAL] Views\SystemMotionPreferences.cs | R13+X04 | :41                                   （2）
--- SUMMARY ---
SourceFiles: 168    AssetFiles: 0    GateHits: 0    CommentOnly: 6    InfoHits: 2    ConditionalHits: 13
--- CONDITIONAL FILES --- SystemPowerCommandWindows(R21,R17) / ProcessMemoryMaintenanceNativeWindows(R13,X04) /
SystemShutdownMonitor(R03) / SystemMotionPreferences(R13,X04)
--- ZERO-HIT SOURCE FILES --- 168 文件逐文件零门禁命中（清单与 p1-08 119 基线 + 阶段 2/3 增量集一致）
VERDICT: PASS (zero gate hits) [CONDITIONAL=13 R-2: verify against 06 documented items]
exit code: 0
```

（本复跑输出为节录归档：摘要行、CONDITIONAL/COMMENT-ONLY/INFO 逐行命中位、CONDITIONAL 文件清单与 VERDICT 为原文照录；168 文件 ZERO-HIT 逐文件清单原文过长，以「与 p4-01 §4.1 留档 `p4-01-s42-fulltree-source-output.txt` 集合一致、差集=0」口径归档——两时点扫描间隔内时段改动集 = 恰 2 个裁量点名文件且其单文件复扫 PASS（p4-01 §4.2），集合不变性成立。）

**终局结论：168 / 0 / 13 / 2 / 6 / PASS / exit=0，与 p4-01 权威结果及 p2-08/p3-08 基线逐项一致；CONDITIONAL=13 位次逐字节同值（SystemShutdownMonitor R03 :5 不受 O-5 注释改写影响，实测佐证）。** ✅

### 2-6 A33 + B19 闭合清点（52/52）

注册面机器复核（§2-4）：Register\*IfEnabled **37**（行动 29 + 触发器 2 + 组件 6）+ AddRule **4**；B 档 15 个注册 ID 逐一恰 1 次；4 服务 DI + SystemShutdownMonitor 实例 + 维护接口对逐一在位（§1.2）。**33 + 19 = 52/52 维持** ✅（A33 逐项 = §1.1；B19 逐项 = §1.2）。

### 2-7 阶段 1-4 增量映射记录链完整性核对（p1-09 → p2-09 → p3-09 → 本件）

| 链节 | 性质 | 内容核对（本轮逐文件复读） | 状态 |
| --- | --- | --- | :-: |
| p1-09（阶段 1 基线） | A33 逐项映射 + 六步重放首版 | A33 33/33（§1 基线）；E-1（F11 映射）/E-2（设备依据）保留声明在案（§2.3）；152 树/119 Source 面 | ✅ 在案 |
| p2-09（阶段 2 基线） | B19 逐项映射 + A33 零改动复核 | B19 19/19（§1）+ 非计数附属 2（§1.4）；E-3（计数聚合 23→22）/E-4（G1 :18→:20）/W-1（锚点微漂）登记在案（§7）；C46 十四组反向检索（§3）= 本件 §1.4 复扫同组集 | ✅ 在案 |
| p3-09（阶段 3 基线） | 阶段 3 整合面 33 项登记 + 既有基线零回退 | W1-W18/A 面补全/共享 VM 五段/修复 4/docs 1（§1）；E-5（S4 六页 32/22/40/41/29/16）/E-6（裸形态 :27/:58/:48）/M-1（VM using :1-10）/M-2（GUID 行口径）登记在案（§6）；C1-C21 + 白名单 41 基线化（§3） | ✅ 在案 |
| p4-01（阶段 4 终局门禁） | 裁量实施 + 终局扫描 + O 项归类 | O-9/O-5 实施 diff（§2）、CS8602 26 处零清理（§3，登记计数 28→26 勘误按 E-3/E-4 先例口径）、168/0/13（§4）、O 项归类清单（§8） | ✅ 在案 |
| 本件 p4-05 | 终局重放 + 基线冻结 | 承接上列全部基线；新增复映射（§1.3）与记录级勘误 M-3（§5）；登记冻结坐标（§4） | ✅ 本件 |

**链完整性结论**：四链节逐项可回查、勘误链（E-1/E-2 → E-3/E-4/W-1 → E-5/E-6/M-1/M-2 → p4-01 计数勘误 + 本件 M-3/复映射登记）**逐项在案、无断链、无未处置项**；各链节对上游基线的「零漂移/重映射」定性全部经本件实测独立复证（§1/§2）。被重映射的旧值（p1-09 :26→p3-09 :32、p2-09 触发器 :18→:20 等）均由后链节书面声明替代，无并行双基线。

---

## 3. 阶段 4 交付面登记（最终基线组成部分，逐项登记）

| # | 交付物 | 源锚点/依据 | 新落点（终态） | 归属批 | 基线属性 |
| :-: | --- | --- | --- | :-: | --- |
| 1 | O-9 形态统一（ShowAsync D4 形态 + 去 static） | 门下省阶段 3 §8 O-9；p3-02 D4 先例 | `SettingsPage\SystemToolsSettingsPage.axaml.cs` **:187-203**（总行 257→262，mtime 14:46:57） | p4-01（刑部） | 产品面改动（零行为差异声明 p4-01 §2.3；Roslyn Round-W/N error=0） |
| 2 | O-5 授权链注释订正（纯注释） | 门下省阶段 2 §8 O-5；p2-05 §1.2 + p0-07 §11.1 | `Services\SystemShutdownMonitor.cs` **:11-17**（总行 135→138，mtime 14:46:57） | p4-01（刑部） | 产品面改动（零行为差异；R03 :5 位次不变实测） |
| 3 | 同装差异/平台说明终稿 | p4-03 §1 六项新增/更新 + 三方一致性终核 9 项 | `.tang/cases/stcp-cross-platform-001/docs/coexistence-notes-final.md`（197 行 / 22,437 B / mtime 15:22:59；卷首取代声明 + 5 节 + O-6/O-10/O-11 专段 + 4.2 已知限制/4.3 安装升级/4.4 裁量摘要） | p4-03（礼部） | 案卷文档面（仓库 docs 初稿 142 行零触碰维持） |
| 4 | 发布就绪检查单 + 构建边界登记 | p4-02 §5（12 项逐项结论）+ §1.3（Win 1,543,680 B / Linux 1,541,120 B 裁量前产物）+ §2（cipx 登记面）+ §6（O-8/O-12 终态） | `evidence/p4-02-works-release-readiness.md` + 9 个留档 log/txt | p4-02（工部） | 证据面（已知限制三项登记：macOS 真机 / G3 标准路径 / cipx，用户裁定口径不阻塞） |
| 5 | 发布预算终稿 + 依赖终核 | p4-04 §1（csproj SHA256 `A7220DB4…C38A`）/ §2（零新增包）/ §3（体积链）/ §4（apiVersion 一致性）/ §5（预算链 152→203→203(+1 docs)→203(+1 docs)） | `evidence/p4-04-revenue-release-budget.md` | p4-04（户部） | 证据面（裁量后重建受沙箱阻断如实注记，精确体积待环境恢复补记） |
| 6 | 门禁终局权威执行证据 | p4-01 §4-§6（168/0/13 + 单文件复扫 + Roslyn 双轮 + 回归终验） | `evidence/p4-01-*`（7 文件） | p4-01（刑部） | 证据面（本件 §2-5 独立复跑同结论） |

**登记闭合**：阶段 4 交付面 = 2 产品文件改动 + 1 案卷终稿 + 3 证据集（检查单/预算/门禁），全部纳入最终基线；每项可由源锚点/新落点/归属批三列回查对应批证据。阶段 4 净增功能项 = 0、净增产品文件 = 0（§1.5）。

---

## 4. 基线冻结声明（项目终局）

**声明**：以下终态坐标登记为 **stcp-cross-platform-001 项目最终基线**（冻结时点 = p4-01 裁量落盘 2026-09-04 14:46:57 之后的树态，本件 2026-09-04 实测核验一致）。基线冻结后，仓库进入**仅维护性变更**流程：任何后续改动不得新增功能项（A/B/C 档零增减）、不得触碰注册面唯一写入者约定（Plugin.cs 仅礼部流程可改）、manifest/csproj/global.json/slnx 变更须另行审批；每次维护性变更须重放本件 §2 六步核对与 §2-5 门禁（预期 168/0/13/PASS/exit=0 或差异上报），并按 p3-09→本件先例登记增量映射记录，保持记录链连续。

| 坐标 | 冻结值（本轮实测） |
| --- | --- |
| 产品文件集 | `src\SystemTools.CrossPlatform\` 全树 **203**（163 .cs / 29 .axaml / 4 .yml / 3 .png / 3 .txt / 1 .csproj，排 bin/obj）；仓库 docs 初稿 ×1（142 行） |
| Source 面 | **168**（扫描器口径；GateHits=0，CommentOnly=6，InfoHits=2） |
| 计数 | **98 = A33 + B19 + C46**（已纳 52/52；C46 零迁入；白名单 41） |
| 抽屉白名单 | **41**（VM `SystemToolsSettingsViewModel.cs` 唯一功能 ID，与 Plugin.cs 注册 ID 一一对应，本轮机器复核 0 缺失 0 越界） |
| CONDITIONAL | **13**（SystemPowerCommandWindows R21×5+R17×3 / ProcessMemoryMaintenanceNativeWindows R13+X04 / SystemShutdownMonitor R03 :5 / SystemMotionPreferences R13+X04） |
| 注册面 | Plugin.cs **742 行 / mtime 2026-09-04 11:17:15**；37 Register\*IfEnabled 调用（43 提及）/ 唯一 ID **45** / AddRule 4 / AddXamlTheme 3 / AddSettingsPageGroup+6 页 |
| 关键锚点 | A33/B19 全集锚点 = §1.1/§1.2（含 E-5/E-6 重映射 + §1.3 两文件复映射）；MainConfigData 17 成员 = §1.2；裸形态例外 :27/:58/:48 |
| 关键哈希/行数 | manifest `142CD419…AAC`；csproj `A7220DB4…C38A`（125 行）；MainConfigData 553 行；共享 VM 887 行；裁量两文件 262/138 行 |
| 产物体积 | Win **1,543,680 B** / Linux **1,541,120 B**（阶段 3 p3-10 真实构建、裁量前；裁量后重建受会话沙箱阻断未执行，p4-02 §1.3/p4-04 §3.1 如实登记，预期零/极小增量，精确值待环境恢复补记） |
| 宿主契约面 | G1（ISystemEventsService 无 Linux/macOS 实装）/ G2（无会话结束事件 → SystemShutdownMonitor 非 Windows no-op 分支）/ G3（IDesktopService 无 macOS 实装）——新插件当前零直接消费，文档 §4.1 用户可见说明已落盘（p4-03） |
| 已知限制（登记维持） | G1 macOS 真机重放缺失 / G3 标准路径（历史 MSB4276 + 会话沙箱阻断双重）/ cipx 打包未生成（登记面 + 手动安装路径说明已转终稿 §4.3）/ CS8602 26 处评估性零清理（A 档零改动冻结） |

**两项目标产物终态索引**：

1. **源码仓库**：`src\SystemTools.CrossPlatform\`（插件工程全集，203 文件；配套仓库级 `docs\coexistence-notes.md` 初稿 142 行）——构建入口 `SystemTools-Cross-platform.slnx`，产物 `bin\Release\net10.0-windows10.0.19041.0\` 与 `bin\Release\net10.0\`（+ cipx 打包路径 `src\SystemTools.CrossPlatform\cipx\`，待环境恢复）。
2. **案卷证据目录**：`.tang/cases/stcp-cross-platform-001\`——决策与验收件 `01-requirements.md`…`05-phased-development.md`、`06-migration-details-proposal.md`；`evidence\`（p0-01…p4-05 全链证据 + 扫描/编译/构建留档）；`docs\coexistence-notes-final.md`（发布终稿）。

---

## 5. 勘误与微漂登记（本件新增，全部为记录级，零档位、零计数、零行为差异）

| # | 类型 | 内容 | 处置 |
| --- | --- | --- | --- |
| M-3 | 记录级字节数勘误 | p3-09 §1.5 记 docs 初稿「142 行 / **13,133 字节**」；本轮实测 **14,133 B**（142 行 / mtime 2026-09-04 13:20:10 与 p3-09 记录同秒 / SHA256 `EB54C3B0D2A0F72CC3A1EABCF6BB9FB746F1D81D32AEF6DD523F8A07F61B720C`）——mtime 同秒证明零触碰，仅记录字节数笔误（差恰 1,000） | 以本件实测为终局值；p3-09 其余内容不受影响 |
| 复映射登记 | 基线锚点增量（非漂移） | §1.3：SystemToolsSettingsPage.axaml.cs 257→262（W1/W2 cs 锚点 +5，:32/:48 及调用点零位移）；SystemShutdownMonitor.cs 135→138（R03 :5 零位移）——O-9/O-5 裁量的预期增量，实测逐行证实 | 终态锚点以本件 §1.3 为准（对齐 E-5/E-6 先例口径） |
| 链条收录 | p4-01 计数勘误入链 | CS8602 登记计数 28 → 实测 26（p4-01 §3.1，明示按 E-3/E-4 先例）——记录链 §2-7 已收录为阶段 4 链节项 | 引 p4-01 为准，本件不另编号 |

---

## 6. 边界声明与复核指引

- 本任务唯一写入 = 本证据文件；`src\` 产品文件、`docs\`、源插件检出（`E:\My Github Projects\SystemTools`）、宿主检出全程零改动；门禁复跑为扫描器进程内直跑（`&` 调用，p4-01 §4.1 既有口径），输出按写入边界节录归档于 §2-5 内、未另建输出文件。
- 本文件不派工、不审批、不推进全局工作流；仅向尚书省回报 p4-05 结果，供门下省终验，并作为项目最终基线冻结登记。
- 快速复核重放：
  1. 树清点：`Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object FullName -notmatch '\\(bin|obj)\\'`（应 203）+ `Get-ChildItem docs -Recurse -File`（应 1）；
  2. 门禁：`& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source`（应 168/0/13/PASS/exit 0）；
  3. 注册面冻结：`Get-Item src\SystemTools.CrossPlatform\Plugin.cs` mtime 应为 2026-09-04 11:17:15、742 行；`(Get-FileHash src\SystemTools.CrossPlatform\manifest.yml -Algorithm SHA256).Hash` 应 `142CD419…AAC`；
  4. 裁量现态：SystemToolsSettingsPage.axaml.cs :187-203（D4 形态，262 行）；SystemShutdownMonitor.cs :11-17（授权链，138 行，R03 :5）；
  5. 白名单：对 `SystemToolsSettingsViewModel.cs` 提取 `"SystemTools\.CrossPlatform\.` 去重应 41 且全在 Plugin.cs 注册 ID 内；
  6. 计数：`Register\w*IfEnabled[<(]` 应 41 行（37 调用 + 4 定义），AddRule 4、AddSettingsPage 7 行（含组）、AddXamlTheme 3；
  7. 终稿：读 `.tang/cases/stcp-cross-platform-001/docs/coexistence-notes-final.md`（197 行，5 节 + 专段结构 = p4-03 §1）。

## 7. 修订记录

- 初版（p4-05 执行交付；基于 2026-09-04 裁量后终态树实测——覆盖核对表 98 逐项重放、p1-05 §8 六步终局重放含门禁独立复跑（2026-09-04T07:37:41Z）、阶段 1-4 记录链完整性核对、阶段 4 交付面登记、基线冻结声明核验；新登记 M-3 与两文件复映射）。
