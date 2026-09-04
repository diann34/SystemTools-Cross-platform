# p4-01 证据：门禁终局权威执行 + 收尾裁量实施（刑部 quality-security / verification，阶段 4 final）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p4-01 · 刑部 justice · quality-security / verification（阶段 4；依赖 none） |
| 权威输入 | evidence/menxia-stage3-acceptance.md §8（O-9~O-12 定义）；evidence/menxia-stage2-acceptance.md §8（O-5~O-8 定义）；p3-08-justice-filegates.md（阶段 3 终局基线 168/0/13 + :197 观察级上报）；p0-07 §11（R-2/R-2a）；p2-08 §3.1/§3.3/§4-①（CONDITIONAL=13 授权链 + O-5 定性）；p3-01/p3-02 证据（D3/D4 修复形态、共享 VM 界标）；p1-10/p2-10/p3-10 构建 logs（CS8602 计数基线） |
| 工作区 | `E:\My Github Projects\SystemTools-Cross-platform`（写入面 = 2 个裁量点名行 + 本案 evidence/ 下 p4-01-* 文件，§7） |
| 结论 | **succeeded** —— (a) 裁量实施 2 项：O-9 形态统一（SystemToolsSettingsPage.axaml.cs:187-203 现态）与 O-5 注释订正（SystemShutdownMonitor.cs:11-17 现态），逐处前后 diff 留证（§2），零行为差异声明成立（§2.3）；CS8602 经逐处评估为**零清理实施**（26 处全部源侧继承于 A 档零改动冻结文件，不存在零风险守卫形态，§3）；(b) 裁量落盘后全树 R-2 终局扫描 **168/168 PASS（GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6，exit=0）**，与 p2-08/p3-08 基线逐值一致，CONDITIONAL=13 file:line:rule **逐字节一致（差集=0）**，两触达文件单文件复扫 PASS（§4）；(c) Roslyn 升级法双向符号 Round-W/Round-N 双轮 **error=0 / warning=0**（含 WinForms ref 元数据解析；§5）；真实 dotnet 构建在本会话受命名管道边界拒绝（p0-07 §10.3/p3-02 既有口径，已留证；§5.3）——真实构建门禁仍属工部阶段级验证（p3-10 先例）；(d) 回归终验全过：C1-C21 代码面 0 命中（15 处原始命中全部=已登记注记行，逐条与 p3-08 §4.1 清单一致）、D6 零真实拖拽符号（17 原始命中分类与 p3-08 §4.2 一致）、阶段 1 基线 **119/119 零回退**、168 文件集与 p2-08/p3-08 **差集=0**、注册面 **37 调用/45 唯一 ID/43 提及**不回退、Plugin.cs 零触碰（mtime 11:17:15 逐秒一致）、共享 VM 887 行界标在位、条件文件 4 个 guard 形态完好且跨分支符号经 Round-W/N 复验（§6）；(e) O 项归类清单齐备（§8） |

---

## 1. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | 裁量项逐处 diff + 复扫 + 编译留证 | O-9/O-5 逐处前后 diff（§2.1/§2.2）；单文件复扫 PASS（§4.2）；Roslyn 双轮 error=0（§5.1） | ✅ |
| 2 | 终局矩阵 168/0/13 不变或差异上报 | 168/0/13 逐值不变；CONDITIONAL=13 与 p2-08 §3.1 逐字节一致、差集=0（§4.1） | ✅ |
| 3 | O 项归类清单齐备 | O-3/O-5/O-6/O-7/O-8/O-9/O-10/O-11/O-12 逐项归类（§8） | ✅ |
| 4 | 零行为差异声明 | 两处裁量均为注释/形态级；声明与论证见 §2.3 | ✅ |
| 5 | 边界（禁改面零触碰） | 时段改动集 = 恰 2 个裁量点名文件（§7.2）；禁改面 mtime 全部原值 | ✅ |

---

## 2. 裁量实施（逐处前后 diff + 零行为差异声明）

裁量范围认定：按派工边界「属注释/文案/零风险质量面者实施；涉及功能/范围/已批口径变更者上报」。先读 menxia-stage2/3-acceptance.md 确认 O 项权威定义后，属实施面的为 **O-5、O-9** 两项；**CS8602（O-3/O-7）经逐处评估为不可零风险实施**（§3），按派工口径出零清理结论。

### 2.1 O-9：SystemToolsSettingsPage.axaml.cs ShowAsync 形态统一

门下省阶段 3 §8 O-9：`:197`（现态 :190-203 区间，阶段 1 骨架段）无参 `ShowAsync()` 与 p3-02 D4 统一后的 `ShowAsync(TopLevel)` 形态不一致，建议阶段 4 收口裁量统一。

**改动前**（改动前全文留档于本轮 read；行号为改动前行号）：

```csharp
187:     private static async Task ShowAiMessageAsync(string title, string message)
188:     {
189:         var dialog = new FAContentDialog
190:         {
191:             Title = title,
192:             Content = message,
193:             PrimaryButtonText = "确定",
194:             DefaultButton = FAContentDialogButton.Primary
195:         };
196:
197:         await dialog.ShowAsync();
198:     }
```

**改动后**（现态实测，read 复核于 2026-09-04）：

```csharp
187:     // p4-01 裁量（门下省阶段 3 验收 O-9 形态统一，对齐 p3-02 D4 口径与
188:     // FloatingWindowEditorSettingsPage.axaml.cs 先例）：TopLevel 获取需实例上下文，
189:     // 静态辅助去 static 最小适配（三处调用点均为本页实例方法，调用点零改动）。
190:     private async Task ShowAiMessageAsync(string title, string message)
191:     {
192:         var dialog = new FAContentDialog
193:         {
194:             Title = title,
195:             Content = message,
196:             PrimaryButtonText = "确定",
197:             DefaultButton = FAContentDialogButton.Primary
198:         };
199:
200:         var topLevel = TopLevel.GetTopLevel(this)
201:                        ?? throw new InvalidOperationException("无法访问设置窗口");
202:         await dialog.ShowAsync(topLevel);
203:     }
```

要点说明：

1. **形态**：`TopLevel.GetTopLevel(this) ?? throw new InvalidOperationException("无法访问设置窗口")` + `ShowAsync(topLevel)`，与 p3-02 D4 先例 `FloatingWindowEditorSettingsPage.axaml.cs:206-208` 及 D3 先例 `AiChatSettingsPage.axaml.cs:242-243` 逐字同款（守卫文案同串）。
2. **静态辅助最小适配**：方法为静态辅助、无法取 `this`。两案对比后取**去 static**为最小适配——参数表/返回类型/方法名/访问级全部不变，三处调用点（:115/:131/:135，均为本页实例方法）**零改动**（全树 grep `ShowAiMessageAsync` = 4 处 = 定义 1 + 调用 3，无其他引用/反射/XAML 引用）；备选「新增 TopLevel 参数」属签名改动且须触 3 处调用点，面更大，不取。
3. 文件总行数 257 → 262（+5：注记 3 行 + 守卫 2 行 − 无参调用 1 行并入）。

### 2.2 O-5：SystemShutdownMonitor.cs 授权链注释订正

门下省阶段 2 §8 O-5：`:11` 产品注释仍写「按 06 条目 46」（与证据层同源编号笔误），建议更正为 p2-05 §1.2 + R-2 授权链表述（纯注释，零功能）。阶段 3 未处理（p3-08 未触），本任务实施。

**改动前**（:10-13，改动前行号）：

```
    /// 逐行保留源实现；按 06 条目 46 与 04-spec S3-R4/G2 既定口径，经阶段 2 平台条件文件规范
    /// （p0-07 R-2 形态 a，全文件正向平台 guard 包裹）承载于 Windows 编译分支；
    /// guard 符号采用宿主 CrossPlatformProps.props 定义的 Platforms_Windows（C# 预处理符号
    /// 大小写敏感，扫描器 R-2 以大小写不敏感匹配识别，见批证据）。
```

**改动后**（现态 :11-17）：

```
    /// 逐行保留源实现；Windows 会话消息路径授权链 = p2-05 §1.2（非计数附属 1：明示
    /// WinForms 面 + S3-R4/G2 no-op 降级分支）+ p0-07 §11.1 R-2 裁定点名，功能语义
    /// 服务 06 条目 38 看门狗替换（原注「按 06 条目 46」系编号笔误——06 条目 46 实为
    /// 「从悬浮窗触发」，p2-08 §4-① 定性、p4-01 裁量订正）；经阶段 2 平台条件文件
    /// 规范（p0-07 R-2 形态 a，全文件正向平台 guard 包裹）承载于 Windows 编译分支；
    /// guard 符号采用宿主 CrossPlatformProps.props 定义的 Platforms_Windows（C# 预处理
    /// 符号大小写敏感，扫描器 R-2 以大小写不敏感匹配识别，见批证据）。
```

要点说明：订正口径与 p2-08 §4-① 定性及门下省阶段 2 O-5 建议逐字对应（p2-05 §1.2 非计数附属 1 + p0-07 §11.1 R-2 裁定点名 + 06 条目 38 看门狗替换语义 + 笔误缘由注记）；纯注释改动，代码字节零变化（文件 135 → 138 行，全部为注释行内改写）；`#if` guard 结构与 R03 :5 命中位零影响（§4.2 复扫佐证）。全树 grep「条目 46」= 仅此 1 处（订正后 = 0 处笔误表述），无其他同源残留。

**派工括注「MainConfigData 计数注释」核对**：对 MainConfigData.cs 注释面（:94/:285/:318/:326-327）逐条读取核对——全部为 p1-04/p2-05/p3-01 已登记的既批注记（C12/C16/C17 降级决议注记、注册顺序注记、p2-05 §2.1 #6 已批注记），**无计数笔误**；O-5 的权威定义（menxia-stage2 §8）指向 SystemShutdownMonitor.cs:11 且已实施。该括注与权威定义不符，按权威定义执行并于此留证备查。

### 2.3 零行为差异声明（两裁量项合计）

| 项 | 声明 | 论证 |
| --- | --- | --- |
| O-9 | **所有可达生产路径零行为差异** | (1) 对话框本体、构造参数、调用时序、返回值消费完全不变；(2) 显式传入的 `TopLevel.GetTopLevel(this)` 即页面自身宿主窗口——与本文件既有 p3-01 交付面 :184 `ShowAsync(TopLevel.GetTopLevel(this))` 同一解析形态，设置页在设置窗口内已附着（Loaded 后点击触发），解析结果非空恒成立；(3) 无参重载（绑定 `ShowAsync(bool showHosted = false)`）依赖 FA 内部顶层解析，与显式传入页面宿主 TopLevel 在可达路径下承载同一窗口；(4) 守卫分支仅在控件未附着窗口的不可达边界触发——该状态下无参路径同样无法承载对话框，守卫仅将隐性失败显式化为确定性异常（与 D3/D4 先例同口径），未改变任何可达路径行为；(5) 去 static 无运行时可观察效应（无重载歧义/无委托/反射/序列化引用，全树 grep 4 处已证）。 |
| O-5 | **零行为差异（纯注释）** | 改动全部位于 `///` 文档注释内；无任何代码 token 变化；编译产物层面等价（Round-W/N 双轮 error=0 + 扫描命中位 :5 不变为佐证）。 |
| CS8602 | 不实施（§3），现态维持 | 无行为变化（零改动）。 |

---

## 3. CS8602 收口裁量结论：零清理实施（逐处留证）

门下省 O-3（阶段 1）/O-7（阶段 2）：「28 个 CS8602 可空警告……阶段 4 收口酌情清理，不设为门禁」。本任务按「仅零风险空引用守卫补齐」口径逐处评估，结论：**不存在零风险守卫形态，零清理实施**。

### 3.1 现树实测清单（26 处；登记口径 28 为沿用登记计数勘误）

| 文件 | 命中行（p3-10 fallback 双 TFM log 唯一位，Win/Linux 两轮同值） | 数 |
| --- | --- | ---: |
| Controls\Components\LocalQuoteComponent.axaml.cs | :145 :155 :156 :226 :238 :255 :268 :275 :297 :309 :321 :344 :346 :408 :412 | 15 |
| Controls\Components\BetterCarouselContainerComponent.axaml.cs | :346 :347 :365 :366 :584 :597 | 6 |
| Controls\Components\NextClassDisplayComponent.axaml.cs | :113 :121 :148 :155 :178 | 5 |
| **合计** | | **26** |

计数勘误：p1-10 第四轮闭环 log（`p1-10-build-fallback-win-r4.log`）实测即 26 唯一位（52 raw = 摘要节重复），p2-10/p3-10 同值——「28」为 O-3 登记时点计数的沿用，属登记级计数勘误（E-3/E-4 先例同口径），零门禁影响，以本节实测为终局值。

### 3.2 不可零风险实施的三重事实

1. **源侧继承**：三文件在原插件 `E:\My Github Projects\SystemTools\Controls\Components\` 中逐行同形态（同 `?` 可空字段声明、同参数less 构造函数、同命中行号——如 NextClass :24-26 `ILessonsService?/IProfileService?/IExactTimeService?`、LocalQuote :33-37 `DispatcherTimer?/Animation?` 与本树逐字节同位）。CS8602 是源插件既有形态的忠实镜像产物，非迁移引入。
2. **A 档零改动冻结**：三文件属 A 档 33 项交付面（p2-08 §5.3 计数口径「A33 零改动冻结」），任何守卫插入即破坏逐行随源审计性质，越出裁量边界（需尚书省/门下省另行裁定，不属本任务「零风险」裁量面）。
3. **无零风险守卫形态**：各命中位的可空性源于参数less 构造函数（public、可达面）；任何 `if (x is null) …` 守卫都会把该路径上的 NRE 失败改为静默跳过/短路——即**必然改变至少一条可达路径的失败行为**，不满足「零风险（全路径行为等同）」约束；类型注记收紧/构造函数删除属签名级改动，均超出「仅空守卫补齐」授权。

**处置**：O-3/O-7 以「评估后零清理」闭合（酌情裁量权内结论）；26 处清单与三重事实留证于本节，供门下省终验复核。若后续需真正清零，须按「A 档偏差适配」流程（对齐源差异登记 + 行为评审）另行派工，不在本任务裁量内。

---

## 4. 终局权威扫描（裁量落盘后）

### 4.1 全树 R-2 直扫（R-2 版扫描器零改动直用，`&` 进程内直跑——p0-07 §10.3/p3-08 §2.1 既有口径）

留档：`p4-01-s42-fulltree-source-output.txt`（2026-09-04T06:50:44Z，晚于两处裁量写入 14:46:57 本地，即终态扫描）。

```
SourceFiles    : 168     （与独立盘点 Get-ChildItem 168 逐文件一致，差集=0）
AssetFiles     : 0       （-Scope Source 面）
GateHits       : 0
CommentOnly    : 6       （csproj:79 P01–P06，与 p2-08 起逐阶段同值）
InfoHits       : 2       （SystemMotionPreferences I04 :28/:43）
ConditionalHits: 13
VERDICT        : PASS (zero gate hits) [CONDITIONAL=13 R-2: …]   exit=0
```

- **CONDITIONAL=13 逐字节一致性**：与 `p2-08-s42-fulltree-source-postfix-output.txt` CONDITIONAL 节逐行比对（file:line:rule + 命中行原文），**差集 = 0**；`Services\SystemShutdownMonitor.cs R03 :5` 位次不受 O-5 注释改写影响（注释区在 :11-17，位于 :5 之后）。
- **资产面回归**：`p4-01-s42-fulltree-all-output.txt`（-Scope All）exit=0。

### 4.2 两触达文件单文件复扫（逐处留证）

| 文件 | 留档 | 实测 |
| --- | --- | --- |
| SettingsPage\SystemToolsSettingsPage.axaml.cs | `p4-01-s42-single-settingspage-output.txt` | SourceFiles=1、GateHits=0、ConditionalHits=0、PASS、exit=0 |
| Services\SystemShutdownMonitor.cs | `p4-01-s42-single-shutdownmonitor-output.txt` | SourceFiles=1、GateHits=0、ConditionalHits=1（R03 :5，与 p3-08 基线同位同值）、PASS、exit=0 |

---

## 5. 编译双验（Roslyn 升级法 + 真实构建边界留证）

### 5.1 Roslyn 双向符号 Round-W/Round-N（方法沿 p3-02 升级形态 + 本任务增量）

脚本：`p4-01-supplementary-compile-check.ps1`（本任务新增，方法沿 p3-02-supplementary-compile-check.ps1：进程内 Roslyn 对全工程源码树 + 检查专用存根做语义级编译诊断；存根块沿 p3-02 原文未改）。增量：① Round-W = `/define:Platforms_Windows`（Windows 分支）、Round-N = `/define:Platforms_Linux`（`#else`/存根分支），对应 p2-08 §3-2 真实双 TFM define 形态；② 引用面追加 `Microsoft.WindowsDesktop.App.Ref 10.0.10` ref 程序集（提供 System.Windows.Forms 元数据，fx 引用按程序集名先见去重）；③ 判定面 = 2 个裁量触达文件。

留档：`p4-01-supplementary-compile-check-output.txt`，关键结果：

```
Round W（define: Platforms_Windows）—— 本批 2 文件：error=0, warning=0；他文件错误 185 条（XAML 生成面噪声类）
Round N（define: Platforms_Linux）  —— 本批 2 文件：error=0, warning=0；他文件错误 185 条（同噪声类）
COMPILE OK（Round-W + Round-N 双向符号 error=0）
```

- 本批 2 文件双轮零诊断（含零警告）——O-9 形态改动与 O-5 注记在 Windows 分支（WinForms 元数据真实解析）与 `#else` 分支下均语义级编译通过。
- 他文件 185 条为既有检查语境噪声类（CS0103 `InitializeComponent`/x:Name 生成字段、CS0246 等存根缺位伪影），与 p3-01/p3-02 既有口径同类，不入判定；真实全树 error=0 由工部真实构建门禁承载（p3-10 exit=0 树 = 本任务树 − 2 处零风险裁量改动）。

### 5.2 条件文件 4 个跨分支符号复验

| 文件 | guard 形态（本次实测） | 跨分支符号 |
| --- | --- | --- |
| Actions\SystemPowerCommandWindows.cs（110 行） | 首非空行 `#if Platforms_Windows` / 末行 `#endif` | Round-W 激活 8 处 R21/R17（R-2 条件命中），Round-N 空分支 + `SystemPowerCommandStub.cs`（`#if !Platforms_Windows`）反向存根，双轮无 CS0101 |
| Services\ProcessMemoryMaintenanceNativeWindows.cs（46 行） | 同上 | Round-W 激活 R13+X04 :25；Round-N + `ProcessMemoryMaintenanceNativeNoOp.cs` 取反存根 |
| Services\SystemShutdownMonitor.cs（138 行） | 同上（O-5 注记后结构不变） | Round-W Windows 实现分支（WinForms 事件路径）；Round-N `#else` no-op 分支（:100-134，IsSessionEnding 恒 false）——**双轮 error=0 即本条件文件跨分支闭合** |
| Views\SystemMotionPreferences.cs（62 行） | 同上 | Round-W 激活 R13+X04 :41；Round-N `#else` no-op 分支 |

### 5.3 真实 dotnet 构建边界（如实留证）

本会话按 p3-10 §2.3/§2.4 同款命令发起 NuGet 后备 Win/Linux 真实构建，**dotnet.exe 启动即被会话沙箱拒绝**：`Access to the path '\\.\pipe\LOCAL\dotnet_*' is denied`（两次同型；与 p0-07 §10.3 / p3-02 头注既有的命名管道边界口径一致；本会话审批通道禁用，未提权）。处置：不重试、不绕行，以 §5.1 Roslyn 双向符号法承载本任务编译验证（派工明示方法），真实构建门禁属工部阶段级验证职责（p3-10 先例），如实转报尚书省在阶段 4 构建门禁任务中复跑。

---

## 6. 回归终验

### 6.1 C1-C21 裁剪面（代码面 0 命中 + 注记豁免清单续登记）

全树 grep（*.cs + *.axaml，排 bin/obj）逐组实测：C1=1（VM:718 注记）、C12=1（MainConfigData:93 注记）、C13=1（SystemToolsSettingsPage.axaml:255 注记）、C14=1（Plugin.cs:189 注记）、C15=4（Plugin.cs :188/:335/:517/:637 注记）、C16=1（MainConfigData:325 注记）、C17=2（MainConfigData:325/:326 注记）、C20=4（AboutSettingsPage.axaml:11 + .axaml.cs:24/:25 + Plugin.cs:187 注记）；**C2-C11、C19 全零**。15 处原始命中**逐条**与 p3-08 §4.1 已登记注记清单同位同类，零未登记残留、零代码面命中，无需移除动作。

### 6.2 D6 零真实拖拽符号

`MoveFloatingTrigger|AddTriggerFromPool|DoDragDrop|_floatingDrag|FloatingTriggerRowDragOver|FloatingTriggerItemDrag|DragDrop\.` 原始命中 17 处，逐条分类与 p3-08 §4.2 一致：子串误匹配 5（FloatingWindowEditorSettingsPage.axaml:114/.cs:264/:276、VM:529/:530，实为删除行合法 API）+ VM 内 D6 注记 2（VM:195/:239）+ A 面附件拖放 10（AiChatSettingsPage.axaml:14-18、AiChatFloatingWindow.axaml:60-64）= **真实拖拽机制符号 0**。

### 6.3 基线与文件集

| 对照 | 数 | 差集 |
| --- | ---: | --- |
| p1-08 阶段 1 基线（ZERO-HIT 119 文件） | 119 | **回退 0**（119/119 全部保持零门禁命中） |
| p2-08 订正后复扫（168） | 168 | **0 行** |
| p3-08 全树（168） | 168 | **0 行** |
| 本次独立盘点（Get-ChildItem，排 bin/obj） | 168 | 与扫描集合**差集 0** |

### 6.4 注册面 + Plugin.cs 零触碰

| 核对点 | 基线（p3-08 §5.3） | 本次实测 | 一致性 |
| --- | --- | --- | --- |
| Plugin.cs mtime | 2026-09-04 11:17:15 | **11:17:15**（逐秒一致） | ✅ 零触碰 |
| Plugin.cs 行数 / `#if` | 742 / 0 | 742 / 0 | ✅ |
| `Register\w*IfEnabled` 提及 | 43 = 37 调用 + 4 辅助定义 + 1 doc + 1 region | 43 = **37 调用**（如 :276/:278/:280…:411/:413）+ 4 定义（:421/:430/:441/:452）+ 1 doc（:38）+ 1 region（:419） | ✅ |
| `"SystemTools\.` 唯一 ID | 45 | **45** | ✅ |

### 6.5 共享 VM 界标与禁改面现态

- VM `SystemToolsSettingsViewModel.cs`：mtime 12:52:32（阶段 3 末态，未触碰）、887 行、:6 D1 using、:177 守卫、:695 交叉核对口径行、:887 单一收口花括号全部在位。
- 时段改动集 = **恰 2 个裁量点名文件**（两文件 mtime 2026-09-04 14:46:57 = 本任务写入）；MainConfigData.cs（11:33:47）/ manifest.yml（2026-09-03 23:12:06）/ csproj（02:55:37）/ Plugin.cs（11:17:15）/ VM（12:52:32）mtime 与 p3-08 §5.5 基线逐值一致——禁改面零触碰。

---

## 7. 写入清单

### 7.1 产品面写入（裁量点名行，2 文件）

| 文件 | 改动 | 行数变化 |
| --- | --- | --- |
| SettingsPage\SystemToolsSettingsPage.axaml.cs | O-9：:187-203（去 static + D4 形态守卫 + ShowAsync(topLevel)） | 257 → 262 |
| Services\SystemShutdownMonitor.cs | O-5：:11-17 授权链注释订正（纯注释） | 135 → 138 |

### 7.2 证据面写入（本案 evidence/ 下）

`p4-01-justice-final-gates-and-remediation.md`（本文件）、`p4-01-s42-fulltree-source-output.txt`、`p4-01-s42-fulltree-all-output.txt`、`p4-01-s42-single-settingspage-output.txt`、`p4-01-s42-single-shutdownmonitor-output.txt`、`p4-01-supplementary-compile-check.ps1`、`p4-01-supplementary-compile-check-output.txt`。

### 7.3 零改动声明

`src\SystemTools.CrossPlatform` 除 §7.1 两文件外零改动；扫描器 p0-07-s42-scan.ps1 字节未动；原插件与宿主检出只读未触碰（仅读取对照）；未请求沙箱提权；真实构建发起被拒后未重试绕行（§5.3）。

---

## 8. O 项归类清单（供尚书省分派/门下省终验）

| # | O 项 | 本任务处置 | 归类结论 |
| --- | --- | --- | --- |
| O-3/O-7 | 28（实测 26）处 CS8602 | 逐处评估：源侧继承 + A 档零改动冻结 + 无零风险守卫形态（§3） | **已闭合（评估性零清理）**；若需真清零须另行裁定 A 档偏差适配，非本任务裁量面 |
| O-5 | SystemShutdownMonitor.cs:11 注释笔误 | **本任务实施**（§2.2） | 已闭合 |
| O-6 | 06 条目 41 `/r` vs 裁决 `/g` 差异 | 未触（本任务无文档面权限） | **文档面 → 归 p4-03**（coexistence-notes 同步该差异记录） |
| O-8 | G1 macOS 真机 / G3 标准本地路径缺口 | 未触（环境缺位，用户裁定口径） | **打包/环境面 → 归 p4-02**；维持登记 |
| O-9 | :197 无参 ShowAsync 形态 | **本任务实施**（§2.1） | 已闭合 |
| O-10 | 「层级设置频率」保留不消费 | 未触；页内注记与文档 §2.3 已如实披露，改行为=功能/口径变更（禁止裁量） | **验收确认面 → 归 p4-03 文档复核 + 门下省端到端终验确认用户感知一致性** |
| O-11 | 抽屉清单两处源侧文案差异 | 未触；文案随源为既批口径，对齐即改用户可见文案（非零行为面） | **文档面 → 归 p4-03**（仅文档面酌情对齐，代码面维持随源） |
| O-12 | G1/G3/cipx 打包环境缺口延续 | 未触 | **打包面 → 归 p4-02**（真机重放/标准路径构建/cipx 打包核验，用户裁定口径） |

## 9. 复核方最小重放集

```powershell
# 1) 全树逐文件门禁（对照 §4.1）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
#    预期：SourceFiles=168、GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6、PASS、exit=0
# 2) 单文件复扫：同脚本 -Path <两触达文件各自路径>（预期 0/0 PASS 与 0/1-COND@:5 PASS）
# 3) Roslyn 双向符号：& .tang\cases\stcp-cross-platform-001\evidence\p4-01-supplementary-compile-check.ps1
#    预期：Round W/N 本批 error=0 warning=0，COMPILE OK，exit=0
# 4) 裁量现态：SystemToolsSettingsPage.axaml.cs:187-203（D4 形态）；SystemShutdownMonitor.cs:11-17（授权链）
# 5) 回归：§6 各表逐项重放（C 组 grep / 119&168 集合差 / Plugin.cs mtime+43 提及+45 ID / VM 界标 / 4 条件文件 guard）
```

## 10. 上报事项汇总

1. **门禁结论**：终局 168/0/13 逐值不变，CONDITIONAL=13 与 p2-08 基线差集=0，零超范围、零新增条件面；无差异需上报授权链增量。
2. **裁量实施**：2 项（O-9/O-5）逐处 diff+复扫+双轮编译留证，零行为差异声明成立；CS8602 零清理（§3 三重事实）；「MainConfigData 计数注释」括注经核对与权威 O-5 定义不符，按权威定义执行（§2.2 留证）。
3. **边界受限如实转报**：真实 dotnet 构建在本会话被命名管道边界拒绝（§5.3），请尚书省在阶段 4 构建门禁任务（工部）复跑真实构建以在裁量后树态重建全树 exit=0 证据。
4. 本文件不推进、不审批全局工作流；属批级验证证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。

## 11. 修订记录

- 初版（p4-01 执行交付；基于裁量双实施 + 全树/单文件 R-2 终局扫描 + Roslyn Round-W/N 双轮 + C1-C21/D6/119/168/37-45/VM/guard 回归终验 + O 项归类评估）。
