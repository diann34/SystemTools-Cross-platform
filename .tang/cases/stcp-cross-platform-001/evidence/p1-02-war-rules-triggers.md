# p1-02 证据：阶段 1 兵部抽取——A 档规则 4 项 + 触发器 1 项（war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-02 · 兵部 war · application-code / implementation（依赖 p1-05，已 succeeded） |
| 结构依据 | p1-05-personnel-layout-convention.md（强制）：§2.1 目录树 / §2.2 落点互斥 / §3.2 命名空间 / §3.3 ID 前缀 / §4.2 注册清单格式 / §5.2 扫描门禁 / §5.3 macOS 表 |
| 范围权威 | p0-03 §4.2（规则集 4A / 触发器 1A）+ 06-migration-details-proposal.md 条目 10–14（源 file:line 阅读索引） |
| 本批交付项数 | **5（4 规则 + 1 触发器）= 16 个新文件**（11 原批 + 5 裁决①增补：4 规则设置控件 + 1 axaml 附属） |
| 门禁自检 | p0-07 扫描器 4 原批路径 + 增补镜像（终轮）+ 第二道裁决单文件直扫（刑部 R-1 修复后）+ A13 消歧后触发器直扫，全部 **GateHits=0 / VERDICT: PASS / exit=0**（输出：p1-02-s42-scan-output.txt） |
| 补充自检 | 进程内 Roslyn 语义级编译 **error=0**（15 个交付 .cs + 2 检查专用存根：ImplicitUsings 等效全局 using + InitializeComponent；warning=5 均为 CS1701 版本统一提示）（输出：p1-02-supplementary-compile-check-output.txt） |
| macOS 自检表 | **无"不适用"项，零阻塞**（§4） |
| 结论 | **succeeded** |

---

## 1. 逐项源 file:line 对照与落点清单

行为口径：方法体/属性体**逐行保留源实现**（无逻辑改写）；唯一例外为尚书省第二道裁定的 A12 跨平台替代（tasklist → BCL 枚举，见 §3/§4 #15）。全部适配点见 §3。行号为源文件 1-based 行号。

### 1.1 规则 4 项（8 文件）

| # | 功能项 | 源文件:行（锚点） | 新落点 | 适配说明 |
| --- | --- | --- | --- | --- |
| R1 | 程序正在运行 | `Rules\ProcessRunningRuleSettings.cs:3-8`（类型 :5，ProcessName :7）<br>`Rules\Handlers\ProcessRunningRuleHandler.cs:8-30`（.exe 剥离 :16-20，`GetProcessesByName` :24，catch 返回 false :26-29） | `Rules\ProcessRunningRuleSettings.cs`<br>`Rules\Handlers\ProcessRunningRuleHandler.cs` | 处理器由源 `partial Plugin` 静态方法适配为独立处理器类型（§3-A2），方法体逐行保留 |
| R2 | 正在使用某课程表 | `Rules\UsingClassPlanRuleSettings.cs:3-9`（ClassPlanId :7-8）<br>`Rules\Handlers\UsingClassPlanRuleHandler.cs:11-26`（Guid 解析 :14，`IProfileService` :19，ClassPlans :20，IsActivated :25） | `Rules\UsingClassPlanRuleSettings.cs`<br>`Rules\Handlers\UsingClassPlanRuleHandler.cs` | 同上 |
| R3 | 正在使用某时间表 | `Rules\UsingTimeLayoutRuleSettings.cs:3-9`（TimeLayoutId :7-8）<br>`Rules\Handlers\UsingTimeLayoutRuleHandler.cs:11-26`（TimeLayouts :20，IsActivated :25） | `Rules\UsingTimeLayoutRuleSettings.cs`<br>`Rules\Handlers\UsingTimeLayoutRuleHandler.cs` | 同上 |
| R4 | 是否在某时间段 | `Rules\InTimePeriodRuleSettings.cs:3-12`（StartTime 默认 "08:00:00" :7-8，EndTime 默认 "18:00:00" :10-11）<br>`Rules\Handlers\InTimePeriodRuleHandler.cs:11-27`（TimeSpan 解析 :14-15，`IExactTimeService`+`DateTime.Now` 兜底 :20，跨午夜分支 :21-26） | `Rules\InTimePeriodRuleSettings.cs`<br>`Rules\Handlers\InTimePeriodRuleHandler.cs` | 同上 |

06 阅读索引交叉核对：R1=06:84、R2=06:90、R3=06:96、R4=06:102，锚点一致。

### 1.2 触发器 1 项（三件套，3 文件）

| # | 功能项 | 源文件:行（锚点） | 新落点 | 适配说明 |
| --- | --- | --- | --- | --- |
| T1 | 行动进行时 | `Triggers\ActionInProgressTrigger.cs:1-92`（TriggerInfo :14，程序集目录取 auto.json 路径 :25-33，Loaded 2s 定时器 :35-41，UnLoaded :43-53，检查定时器体 :55-91：File.Exists :59 / 读取 :68 / JsonDocument :71 / TriggerId 匹配 :76 / 删除 :81 / `Trigger()` :85）<br>`Config\ActionInProgressTriggerConfig.cs:1-21`（ObservableRecipient :7，TriggerId :11-20）<br>`Settings\ActionInProgressTriggerSettings.cs:1-45`（TriggerSettingsControlBase :6，构造面板 :10-38，OnInitialized :40-44） | `Triggers\ActionInProgressTrigger.cs`<br>`Config\ActionInProgressTriggerConfig.cs`<br>`Settings\ActionInProgressTriggerSettings.cs` | TriggerInfo ID 按前缀规则变换（§3-A3）；移除未使用的 `using SystemTools.Utils;`（§3-A4）；跨目录 Config 类型引用补 using（§3-A5）；Timer 标识符按源语义完全限定消歧（§3-A13，行号零位移） |

06 阅读索引交叉核对：T1=06:110（"配置文件位置须落在新插件独立目录/配置边界，不与原插件文件互写"——见 §3-A7 满足方式）。

### 1.3 规则设置控件（尚书省裁决①增补：4 控件 + 1 axaml 附属）

| # | 功能项 | 源文件:行（锚点） | 新落点 | 适配说明 |
| --- | --- | --- | --- | --- |
| C1 | 程序正在运行·设置控件 | `Controls\ProcessRunningRuleSettingsControl.cs:1-175`（类 :13，构造 :17-46，OnInitialized :48-52，tasklist 查看进程 :54-86（启动 :58-69），错误对话框 :88-123，进程列表窗口 :125-174） | `Controls\ProcessRunningRuleSettingsControl.cs`（交付版 165 行） | 命名空间/using 镜像（§3-A9）；"查看正在运行的进程"辅助按钮经**第二道裁决**对齐 p1-03 D3 口径改为 BCL `Process.GetProcesses()` 跨平台枚举（§3-A12；macOS 语义见 §4 #15） |
| C2 | 正在使用某课程表·设置控件 | `Controls\UsingClassPlanRuleSettingsControl.cs:1-110`（类 :14，IAppHost.GetService :23，RefreshItems :54-71，Option record :106-109） | `Controls\UsingClassPlanRuleSettingsControl.cs` | 命名空间/using 镜像（§3-A9） |
| C3 | 正在使用某时间表·设置控件 | `Controls\UsingTimeLayoutRuleSettingsControl.cs:1-109`（类 :14，TimeLayouts 选择 :56-59） | `Controls\UsingTimeLayoutRuleSettingsControl.cs` | 命名空间/using 镜像（§3-A9） |
| C4 | 是否在某时间段·设置控件（axaml 成对） | `Controls\InTimePeriodRuleSettingsControl.cs:1-47`（partial 类 :9，InitializeComponent :13，事件 :16-46）<br>`Controls\InTimePeriodRuleSettingsControl.axaml:1-28`（x:Class :1，clr-namespace :6-7） | `Controls\InTimePeriodRuleSettingsControl.cs`<br>`Controls\InTimePeriodRuleSettingsControl.axaml` | axaml 为控件直接附属，随功能项引入（p1-05 §2.3-1）；x:Class 与各 XML 命名空间声明同步镜像（§3-A10），axaml 正文逐行随源 |

**文件清点：4 设置 + 4 处理器 + 3 触发器三件套 + 4 规则设置控件 + 1 axaml 附属 = 16 文件，与 A 档清单（规则 4 + 触发器 1）一一对应，无遗漏、无超范围落点。**

---

## 2. 结构化注册清单（p1-05 §4.2 六列格式，交接礼部 p1-06）

> 兵部不写注册代码（p1-05 §4.1）；下表为礼部写 Plugin.cs 唯一注册面的输入。显示名与图标字符**随源不改**（源 Plugin.cs:488-508 实测）。

| 项 | 类型全名 | 功能 ID | 注册目标 | 设置类型全名 | 源锚点 |
| --- | --- | --- | --- | --- | --- |
| 规则集 R1 程序正在运行（p0-03 §4.2 规则集 A；06 条目 10） | `SystemTools.CrossPlatform.Rules.Handlers.ProcessRunningRuleHandler` | `SystemTools.CrossPlatform.ProcessRunningRule` | 规则：`AddRule<ProcessRunningRuleSettings, ProcessRunningRuleSettingsControl>("SystemTools.CrossPlatform.ProcessRunningRule", "程序正在运行", "\uE342", ProcessRunningRuleHandler.Handle)` | 设置 `SystemTools.CrossPlatform.Rules.ProcessRunningRuleSettings`；设置控件 `SystemTools.CrossPlatform.Controls.ProcessRunningRuleSettingsControl` | 源 Plugin.cs:486-490；源 Handlers\ProcessRunningRuleHandler.cs:8；源 Controls\ProcessRunningRuleSettingsControl.cs:13 |
| 规则集 R2 正在使用某课程表（06 条目 11） | `SystemTools.CrossPlatform.Rules.Handlers.UsingClassPlanRuleHandler` | `SystemTools.CrossPlatform.UsingClassPlanRule` | 规则：`AddRule<UsingClassPlanRuleSettings, UsingClassPlanRuleSettingsControl>(…, "正在使用某课程表", "\uE6B1", UsingClassPlanRuleHandler.Handle)` | 设置 `SystemTools.CrossPlatform.Rules.UsingClassPlanRuleSettings`；设置控件 `SystemTools.CrossPlatform.Controls.UsingClassPlanRuleSettingsControl` | 源 Plugin.cs:492-496；源 Controls\UsingClassPlanRuleSettingsControl.cs:14 |
| 规则集 R3 正在使用某时间表（06 条目 12） | `SystemTools.CrossPlatform.Rules.Handlers.UsingTimeLayoutRuleHandler` | `SystemTools.CrossPlatform.UsingTimeLayoutRule` | 规则：`AddRule<UsingTimeLayoutRuleSettings, UsingTimeLayoutRuleSettingsControl>(…, "正在使用某时间表", "\uE69D", UsingTimeLayoutRuleHandler.Handle)` | 设置 `SystemTools.CrossPlatform.Rules.UsingTimeLayoutRuleSettings`；设置控件 `SystemTools.CrossPlatform.Controls.UsingTimeLayoutRuleSettingsControl` | 源 Plugin.cs:498-502；源 Controls\UsingTimeLayoutRuleSettingsControl.cs:14 |
| 规则集 R4 是否在某时间段（06 条目 13） | `SystemTools.CrossPlatform.Rules.Handlers.InTimePeriodRuleHandler` | `SystemTools.CrossPlatform.InTimePeriodRule` | 规则：`AddRule<InTimePeriodRuleSettings, InTimePeriodRuleSettingsControl>(…, "是否在某时间段", "\uE4CA", InTimePeriodRuleHandler.Handle)` | 设置 `SystemTools.CrossPlatform.Rules.InTimePeriodRuleSettings`；设置控件 `SystemTools.CrossPlatform.Controls.InTimePeriodRuleSettingsControl` | 源 Plugin.cs:504-508；源 Controls\InTimePeriodRuleSettingsControl.cs:9 |
| 触发器 T1 行动进行时（06 条目 14） | `SystemTools.CrossPlatform.Triggers.ActionInProgressTrigger` | `SystemTools.CrossPlatform.ActionInProgressTrigger` | 触发器注册（源形态 `RegisterTriggerIfEnabled<TTrigger,TSettings>`，源 Plugin.cs:467-468；注册方式由礼部按 SDK 形态落地）。`[TriggerInfo("SystemTools.CrossPlatform.ActionInProgressTrigger","行动进行时","\uEAB7")]` 已写入交付文件本体 :18 | 配置 `SystemTools.CrossPlatform.Config.ActionInProgressTriggerConfig`；设置控件 `SystemTools.CrossPlatform.Settings.ActionInProgressTriggerSettings` | 源 Triggers\ActionInProgressTrigger.cs:14-15；源 Plugin.cs:460-468 |

处理器委托契约核验：`RuleRegistryInfo.HandleDelegate = bool(object? settings)`（SDK RuleRegistryInfo.cs:41），各 `Handle(object? settings)` 方法组可直接转换。

> **重载注记（尚书省裁决①）**：上表 4 行按源形态给出**双参** `AddRule<TSettings, TSettingsControl>`；SDK 亦有单参重载 `AddRule<TSettings>`（RulesetRegistryExtensions.cs:39-45，仅注册 SettingsType）。礼部 p1-06 按实际接线形态落地，两形态均以本清单为输入。

### 2.1 落点裁决落实（尚书省裁决①）

- **归属结论**：4 个规则设置控件为规则功能的附属设置 UI，随规则功能项归属 **p1-02**（尚书省 2026-09-03 裁决；p1-05 §2.1/§2.2 未明确处由尚书省补全）。
- **交付确认**：`Controls\` 平铺落位 4 控件 + 1 axaml 附属（InTimePeriodRuleSettingsControl 成对结构随源），文件名随源、命名空间 `SystemTools.CrossPlatform.Controls`、逐行随源、零新造文件名——已全部交付并通过门禁（§5.1 增补扫描）与 §8 复核。
- **注册清单同步**：§2 表 4 行已更新为双参形态并加注单参重载备选。

---

## 3. 适配点清单（全部为结构/命名适配，零行为改写）

| # | 适配点 | 依据 |
| --- | --- | --- |
| A1 | 命名空间镜像：8 规则域文件 → `SystemTools.CrossPlatform.Rules` / `SystemTools.CrossPlatform.Rules.Handlers`；触发器三件套 → `SystemTools.CrossPlatform.Triggers` / `.Config` / `.Settings`（源侧为 `SystemTools` / `SystemTools.Rules` / `SystemTools.Triggers`） | p1-05 §3.2-1 |
| A2 | 处理器结构：源 `public partial class Plugin` 静态方法（源 Handlers\*.cs:6-9）→ 独立 `public static class <Rule>RuleHandler` + `public static bool Handle(object? settings)`，方法体逐行保留。若保留 partial 形态，`SystemTools.CrossPlatform.Rules.Handlers` 命名空间下会生成与新 `SystemTools.CrossPlatform.Plugin` 同名不同址的伪 Plugin 类，且兵部禁改 Plugin.cs | p1-05 §3.2-1 与 §4.1-2 联合约束；§3.4-1 文件名=主类型名；类型名随源文件名（非新造文件名，报尚书省备案口径见 §6） |
| A3 | 触发器功能 ID：`SystemTools.ActionInProgressTrigger` → `SystemTools.CrossPlatform.ActionInProgressTrigger`；显示名"行动进行时"、图标字符 `\uEAB7` 随源不改 | p1-05 §3.3 |
| A4 | 移除源 `Triggers\ActionInProgressTrigger.cs:10` `using SystemTools.Utils;`（该 using 在源文件体内未使用，属禁用命名空间面） | p1-05 §3.2-4 |
| A5 | 跨目录类型引用补 using：`Triggers\ActionInProgressTrigger.cs`、`Settings\ActionInProgressTriggerSettings.cs` 增 `using SystemTools.CrossPlatform.Config;`（源三件套同处 `SystemTools.Triggers` 命名空间，新工程按 §3.2 分属三命名空间所致） | p1-05 §3.2-1 |
| A6 | 规则处理器 `using SystemTools.Rules;` → `using SystemTools.CrossPlatform.Rules;`（4 处） | p1-05 §3.2-4 |
| A7 | auto.json 落点：源实现即取"本插件程序集目录"（`Assembly.GetExecutingAssembly().Location` + `Path.Combine`，源 :25-32），未改路径逻辑；新插件程序集为 SystemTools.CrossPlatform，运行时 auto.json 天然落新插件目录，满足 06:113"不与原插件文件互写" | 06:113；源 :25-32 逐行保留 |
| A8 | 新增各文件头 XML doc 摘要注明抽取来源与适配依据；未从源带入任何注释（源 11 文件零注释，无可清理项）；新注释零 S4.2 禁用符号提及 | p1-05 §5.2-2 |
| A9 | 4 个规则设置控件（裁决①增补）：命名空间 `SystemTools.Controls` → `SystemTools.CrossPlatform.Controls`；`using SystemTools.Rules;` → `using SystemTools.CrossPlatform.Rules;`（4 处）；其余逐行随源 | p1-05 §3.2-1/§3.2-4 |
| A10 | `InTimePeriodRuleSettingsControl.axaml`（附属随批）：`x:Class` 与 `controls:`/`rules:` 两个 `clr-namespace` 声明同步镜像为 `SystemTools.CrossPlatform.*`；axaml 正文逐行随源 | p1-05 §3.2-1/§3.2-3 |
| A11 | `InTimePeriodRuleSettingsControl.cs` XML doc 曾以技术词 "clr-namespace" 行文，其子串撞 §8 复核从严正则；措辞改为 "XML 命名空间声明"（门禁 R*/X* 规则不受影响，留痕见扫描输出勘误节） | p1-05 §5.2-2 |
| A13 | **CS0104 消歧**（`Triggers\ActionInProgressTrigger.cs`，p1-10 构建门禁暴露）：交付文件内 `using System.Timers;`（随源保留）与构建期 ImplicitUsings 注入的 `System.Threading` 并存，裸 `Timer` 在两个使用位（:23 字段声明、:41 `new Timer(2000)`）歧义。源语义确认为 **System.Timers.Timer（Elapsed 模式）**：源文件 `using System.Timers;`（源 :9）且使用 `Elapsed` 事件与 `ElapsedEventArgs`（源 :42/:55，二者仅 System.Timers 所有）。修复 = 该两处裸 `Timer` 改完全限定名 `System.Timers.Timer`（同线内最小改动，行号零位移）；`ElapsedEventArgs` 无歧义未动。同批同类排查（隐式 using 语境全量重编译 + 修复前形态探针复现）：Process/Task/Timer 等裸名逐名筛查**零再现** | 工部 p1-10 构建门禁 CS0104；尚书省修复指令；源语义核对（源 :9/:42/:55） |
| A12 | **第二道裁决适配**（`ProcessRunningRuleSettingsControl.ShowProcessList`，交付版 :61-76）：源经启动系统命令行工具 tasklist（Windows 专属，源 :63-90）获取进程列表 → BCL `Process.GetProcesses()` 进程名+PID 定宽文本列表（`ProcessName,-40` + `Id,10`，按名序，与 p1-03 D3 逐字符同型）；补 `using System.Linq;`；"查看正在运行的进程"窗口/复制/失败弹窗 UI、"获取进程列表失败"文案与 catch 语义随源保留；源 tasklist 输出的桌面会话/内存列等 Windows 专属字段不迁移。裁定依据：04-spec 已批"跨平台替代"口径 + macOS 硬约束 + 06 R1"不引入平台进程枚举扩展"系指不新增源外枚举能力（BCL 枚举保持源同一用户能力，非行为扩展）+ 同型实现两批一致（p1-03 D3 先例） | 04-spec 降级口径（跨平台替代）；尚书省第二道裁决；p1-03-war-actions.md §D3 同型 |

---

## 4. macOS 兼容自检表（p1-05 §5.3 五列格式，覆盖全部外部依赖点）

适配方式枚举校验（19 项）：宿主抽象 0 项、跨平台 API 11 项（其中 2 项与 BCL 并列）、BCL 8 项（其中 2 项与跨平台 API 并列）、删除（守卫分支）0 项、按已批准降级口径 0 项（第二道裁决后，#15 由写实降级改为跨平台替代，macOS 语义全部"可用"）。

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `Handlers\ProcessRunningRuleHandler.cs:24` | `System.Diagnostics.Process.GetProcessesByName` | BCL | 可用（.NET 跨平台进程枚举；枚举失败经 catch 返回 false，源语义保留） |
| 2 | `Handlers\ProcessRunningRuleHandler.cs:16-19` | 字符串 `.exe` 后缀剥离（`string.EndsWith`/范围运算符） | BCL | 可用（纯字符串处理，无平台分支） |
| 3 | `Handlers\UsingClassPlanRuleHandler.cs:19` / `Handlers\UsingTimeLayoutRuleHandler.cs:19` | `IAppHost.TryGetService<IProfileService>()` | 跨平台 API（ClassIsland SDK 服务门面，`ClassIsland.Core`） | 可用（宿主进程内服务定位，Profile 数据为宿主共享内存模型，无平台耦合；不触及 p0-01 G1–G3 缺口面） |
| 4 | `Handlers\UsingClassPlanRuleHandler.cs:20,25` / `Handlers\UsingTimeLayoutRuleHandler.cs:20,25` | `Profile.ClassPlans/TimeLayouts` 字典与 `IsActivated`（`ClassIsland.Shared` 模型） | 跨平台 API（SDK 共享模型） | 可用（纯数据读取） |
| 5 | `Handlers\InTimePeriodRuleHandler.cs:20` | `IExactTimeService.GetCurrentLocalDateTime()`；`DateTime.Now` 兜底 | 跨平台 API（SDK 时间抽象）+ BCL | 可用（服务缺失时 BCL 本地时间兜底，`DateTime.Now` 无 Windows 依赖） |
| 6 | `Handlers\InTimePeriodRuleHandler.cs:21-26` | `TimeSpan.TryParse` 与跨午夜比较 | BCL | 可用 |
| 7 | `Triggers\ActionInProgressTrigger.cs:25,32` | `Assembly.GetExecutingAssembly().Location`、`Path.GetDirectoryName/Combine` | BCL | 可用（解析至新插件自身安装目录，无平台注册表/特殊路径依赖） |
| 8 | `Triggers\ActionInProgressTrigger.cs:37-39,43-53` | `System.Timers.Timer`（Elapsed/Start/Stop/Dispose） | BCL | 可用 |
| 9 | `Triggers\ActionInProgressTrigger.cs:59,68,81` | `File.Exists/ReadAllText/Delete`（`lock(this)` 串行化读写删，随源） | BCL | 可用 |
| 10 | `Triggers\ActionInProgressTrigger.cs:71-77` | `System.Text.Json.JsonDocument.Parse` / `TryGetProperty` | BCL | 可用 |
| 11 | `Triggers\ActionInProgressTrigger.cs:14,85` / 基类 | `[TriggerInfo]`、`TriggerBase<T>`（Settings 属性、`Trigger()`、Loaded/UnLoaded） | 跨平台 API（ClassIsland SDK 自动化抽象） | 可用（SDK 抽象无平台耦合） |
| 12 | `Config\ActionInProgressTriggerConfig.cs:7,18` | `CommunityToolkit.Mvvm` `ObservableRecipient`/`OnPropertyChanged` | 跨平台 API（MVVM 库，经 SDK 链传递：Shared.csproj:21 v8.2.1） | 可用（纯托管库） |
| 13 | `Settings\ActionInProgressTriggerSettings.cs:12-37` | Avalonia `StackPanel/TextBox/TextBlock` 代码式 UI | 跨平台 API（Avalonia UI，宿主基线 12.1.1） | 可用（Avalonia 三平台渲染） |
| 14 | `Settings\ActionInProgressTriggerSettings.cs:6,40-44` | `TriggerSettingsControlBase<T>` 与 `OnInitialized` | 跨平台 API（ClassIsland SDK 控件抽象） | 可用（SDK 抽象无平台耦合） |
| 15 | `Controls\ProcessRunningRuleSettingsControl.cs:61-76`（源 tasklist 段 :63-90） | BCL `Process.GetProcesses()` 进程名+PID 定宽列表（`ProcessName,-40`+`Id,10`）——尚书省第二道裁决：对齐 p1-03 D3 口径的跨平台替代，替换源 tasklist 启动段 | BCL（跨平台进程枚举） | 可用（BCL 跨平台进程枚举，D3 同口径：三平台枚举本机进程；UI/复制/失败弹窗与"获取进程列表失败"文案随源，桌面会话/内存列等 Windows 专属字段不迁移） |
| 16 | `Controls\ProcessRunningRuleSettingsControl.cs:140` | Avalonia `FontFamily("Consolas, monospace")` | 跨平台 API（Avalonia） | 可用（macOS 无 Consolas 时按 monospace 回退） |
| 17 | `Controls\UsingClassPlanRuleSettingsControl.cs:23` / `Controls\UsingTimeLayoutRuleSettingsControl.cs:23` | `IAppHost.GetService<IProfileService>()`；`Profile.ClassPlans/TimeLayouts`（含 `IsOverlay`/`Name`）；Avalonia `ComboBox`/`DispatcherTimer` + LINQ | 跨平台 API（SDK 服务门面 + SDK 共享模型 + Avalonia UI）+ BCL | 可用（同 #3–#4 语义；刷新定时器为 Avalonia UI 线程机制） |
| 18 | `Controls\InTimePeriodRuleSettingsControl.axaml:12-22` / `.cs:16-46` | Avalonia `TimePicker`（UseSeconds/24HourClock）与 `TimePickerSelectedValueChangedEventArgs` | 跨平台 API（Avalonia） | 可用 |
| 19 | 4 控件基类 `RuleSettingsControlBase<T>`（各 .cs 类声明行） | ClassIsland SDK 规则设置控件抽象 | 跨平台 API（ClassIsland SDK） | 可用（SDK 抽象无平台耦合） |

**表结论：19/19 项 macOS 语义全部"可用"（第二道裁决后无降级项），无"不适用"阻塞项，零平台分叉（16 个新文件零 `#if`、零平台条件目录、零 Windows-only API/资产，§5.1-2 阶段 1 口径满足）。**

---

## 5. 扫描自检与批内自检结果

### 5.1 S4.2 门禁扫描（p1-05 §5.2，批交付前置）

- 输出留档：`.tang/cases/stcp-cross-platform-001/evidence/p1-02-s42-scan-output.txt`（含 4 段原始输出 + §8 复核重放记录）。
- 重放命令（每路径同形，幂等可复跑）：

  ```powershell
  pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
       -Path src\SystemTools.CrossPlatform\Rules -Scope Source   # Triggers\Config\Settings\ 同形
  ```

- 结果汇总：

| 扫描路径 | 覆盖文件 | GateHits | InfoHits | VERDICT | 退出码 |
| --- | ---: | ---: | ---: | --- | --- |
| `Rules` | 8 | 0 | 0 | PASS | 0 |
| `Triggers` | 1 | 0 | 0 | PASS | 0 |
| `Config` | 1 | 0 | 0 | PASS | 0 |
| `Settings`（单文件模式缺陷，见 §5.3） | 1 | 0 | 0 | PASS | 0 |

- 执行注记：扫描由批内进程内 `&` 调用执行（本会话沙箱禁止子 .NET 进程，`pwsh -NoProfile -File` 启动即被命名管道边界拒绝；扫描器语义/规则零改动，判定语义与退出码不变，上方 VERDICT/退出码为工具原始回报）。复核方可按上方命令直接重放。
- p1-05 §8 复核重放（15 个交付 .cs，终态）：`namespace` 非 `SystemTools.CrossPlatform` 命中 **0**；`using SystemTools.*`（非 CrossPlatform）命中 **0**；`"SystemTools\.` 字符串命中 **1** 且为 `SystemTools.CrossPlatform.ActionInProgressTrigger` 合规形态（TriggerInfo 行）；axaml `x:Class` 与 2 处 `clr-namespace` 均已镜像为 `SystemTools.CrossPlatform.*`（留痕于输出文件 axaml 核对节）。

### 5.1.1 增补扫描（尚书省裁决①：4 控件 + 1 axaml）

- 方法：`Controls\` 已成共享容器（p1-01 `Components\**`、p1-03 行动设置控件、p1-04 AI 附件控件已落盘），整目录扫描将覆盖他批文件；扫描器单文件模式缺陷（§5.3-1）修复在途。故采用**临时镜像法**：5 个增补文件逐字节复制至 TEMP 镜像目录（SHA256 逐文件留档于输出文件，复核可用同哈希验证一致性），对镜像运行真实扫描器（-Scope Source），临时镜像已清理。
- 两轮留证：初轮 17:30:49Z PASS（后因 A11 注释措辞修正重做）；**终轮 17:32:31Z：SourceFiles=4（.axaml 不属 Source 面，扫描器口径）GateHits=0 / VERDICT: PASS / exit=0**（EXIT_MARKER=0 显式留证）。
- axaml 门禁口径说明：Source 面规则只作用于 .cs/.csproj/.yml/.yaml，.axaml 不在内（与 p1-01 axaml 交付同口径）；axaml 内容已人工核对零禁用符号（§8 axaml 核对节）。
- **第二道裁决复跑（17:42:54Z）**：刑部 R-1 修复（:95 改 `$item.DirectoryName`）已落地，单文件直扫恢复可用——`-Path src\SystemTools.CrossPlatform\Controls\ProcessRunningRuleSettingsControl.cs -Scope Source` 直扫该裁决②替换后文件：SourceFiles=1，GateHits=0，VERDICT: PASS，EXIT_MARKER=0（留档同输出文件）。
- **A13 消歧复跑（19:05:05Z）**：`-Path src\SystemTools.CrossPlatform\Triggers\ActionInProgressTrigger.cs -Scope Source` 单文件直扫（刑部 R-1 版）：SourceFiles=1，GateHits=0，VERDICT: PASS，EXIT_MARKER=0（留档同输出文件）。

### 5.2 批内补充编译自检（非官方构建门禁）

- 脚本/输出：`evidence\p1-02-supplementary-compile-check.ps1` / `p1-02-supplementary-compile-check-output.txt`。
- 方法：进程内 Roslyn 5.6（每文件独立 SyntaxTree，LanguageVersion=Latest，Nullable=Enable），引用 .NET 10.0.10 共享框架 + 宿主同版本链（Avalonia 12.1.1 / ClassIsland.Core / ClassIsland.Shared / CommunityToolkit.Mvvm 8.2.1 等，取自 .tools\manifest-schema-check\bin\Release\net10.0 与共享框架，滤原生镜像）。
- 范围：**15 个交付 .cs + 1 个检查专用存根**（存根仅模拟 Avalonia XAML 编译器为 `InTimePeriodRuleSettingsControl.axaml` 生成的 `InitializeComponent`，使独立 C# 编译可覆盖该控件；存根非交付文件；axaml 本体由真实构建的 Avalonia XAML 编译器覆盖）。
- 结果：**error=0**（warning=5，全部 CS1701 程序集版本统一提示）——15 个交付 .cs 语义级编译通过，证明 §4 表中 SDK/BCL 依赖点全部真实可解析。**第二道裁决复跑（tasklist → BCL 枚举 + `using System.Linq;`）后重跑：error=0（warning=5），输出已覆盖留档。**
- **自检方法升级（p1-10 CS0104 后）**：新增检查专用"隐式全局 using"树（.NET SDK 隐式集 7 项：System/System.Collections.Generic/System.IO/System.Linq/System.Net.Http/System.Threading/System.Threading.Tasks），复现构建期 ImplicitUsings 注入语境。复现性探针：修复前裸 `Timer` 形态在该语境下 error=1 且文案与工部构建日志一致（"ambiguous reference between 'System.Timers.Timer' and 'System.Threading.Timer'"），证明升级有效；升级后全量重跑 **error=0**——A13 消歧成立且全批无同类裸名歧义再现（Process/Task/Timer 等逐名筛查通过）。输出覆盖留档。
- 官方三平台构建门禁（p1-05 §5.2-3）**不在本批执行**，属阶段级验证；因会话沙箱禁止子 .NET 进程，本批无法代跑 `dotnet build`，重放命令：`dotnet build .\src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj`。

### 5.3 工具缺陷与上报事项（不阻塞本批）

1. **p0-07 扫描器单文件路径模式缺陷**：`-Path` 指向单个 `.cs` 时曾在 :95 对 `FileInfo` 调用不存在的实例方法 `GetDirectoryName`，抛 `MethodInvocationException`、exit=1。**状态：刑部 R-1 修复已落地（:95 改 `$item.DirectoryName`，本批已实测单文件直扫通过，见 §5.1.1 复跑）**；原批 `Settings\` 与裁决①增补时期的替代处置（属主目录/临时镜像法）留痕于 §5.1/§5.1.1。
2. 落点待决（4 个规则设置控件归属）：**已经尚书省第一道裁决归 p1-02 并交付落实，见 §2.1**。
3. A2 处理器类型化适配（源为 partial Plugin 方法）：属 p1-05 §3.4-4 所称"新造类型名"情形的同构事实（文件名仍随源），**尚书省第一道裁决之②已备案准予**，详见 §3-A2。
4. tasklist 观察项：**经尚书省第二道裁决落实为 BCL `Process.GetProcesses()` 跨平台替代（对齐 p1-03 D3 口径），已替换、复扫、复编译通过，详见 §3-A12 与 §4 #15**。

---

## 6. 边界声明

- 本批写入：16 个交付文件——原批 11 个（`Rules\**` 8、`Triggers\ActionInProgressTrigger.cs`、`Config\ActionInProgressTriggerConfig.cs`、`Settings\ActionInProgressTriggerSettings.cs`）+ 裁决①增补 5 个（`Controls\ProcessRunningRuleSettingsControl.cs`、`UsingClassPlanRuleSettingsControl.cs`、`UsingTimeLayoutRuleSettingsControl.cs`、`InTimePeriodRuleSettingsControl.cs`、`InTimePeriodRuleSettingsControl.axaml`）+ evidence/ 下 4 个本批文件（本报告、扫描输出、编译自检脚本与输出）。`Rules\`、`Triggers\`、`Config\` 为本批专属落点（p1-05 §2.2），`Settings\` 仅写清单内单文件；`Controls\` 平铺仅写裁决归属本批的 5 个文件（`Components\`、`Notifications\` 及 p1-03 平铺行动设置控件零触碰）。
- 临时区写入：S4.2 增补扫描的 TEMP 镜像目录两轮均已清理（§5.1.1），无残留。
- 零改动：`Plugin.cs`、`manifest.yml`、`SystemTools.CrossPlatform.csproj`、`global.json`、`.slnx`、原插件检出（`E:\My Github Projects\SystemTools` 只读）、宿主检出（`E:\ClassIsland-git-misha` 只读）。
- 零新造文件名：16 个交付文件名与源文件名逐一相同（p1-05 §3.4-1；含 axaml 成对名）；§5.3-3 所报类型化适配不改文件名。
- 本文件不推进、不审批全局工作流；仅向尚书省回报本批结果。
