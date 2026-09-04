# p1-05 证据：阶段 1 新插件 A 档仓库结构规范（吏部 repository-governance / analysis，先于抽取）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-05 · 吏部 personnel · repository-governance / analysis |
| 权威输入 | 04-spec.md（S4.2 门禁、R-1~R-10）、05-phased-development.md 阶段 1 行、p0-03 A33 逐项清单（抽取范围权威）、p0-02（RootNamespace=SystemTools.CrossPlatform / 工程布局）、p0-05（功能 ID 前缀与配置命名空间约定 D7）、p0-01（宿主抽象契约与缺口 G1–G3）、p0-07（S4.2 扫描器与判定语义）、源插件目录构造（只读参照） |
| 用户常设指引 | 向源插件 `E:\My Github Projects\SystemTools` **仅学插件基础构造与宿主链接方式**（目录构造/资源组织/注册面组织）；排除仅支持 Windows 的架构（WinForms、硬编码 windows TFM、x64 限定、Win32/WMI 相关与 C 档架构） |
| macOS 兼容硬约束 | 所有新代码须 macOS 可用：宿主抽象（IWindowPlatformService / IDesktopToastService / ILauncherService / IDesktopService 等，p0-01 §3）与跨平台 API 优先；Windows 专属路径必须条件隔离或按 04-spec 已批准降级口径处理；Windows-only 资产不得进入共享路径 |
| 本文件性质 | **阶段 1 落点规范（先于抽取）**：约束目录布局、命名空间/命名、注册面归属、兼容与门禁结构规则；不预写函数体、不指定实现算法、不改变 04-spec/05 合同已批决议 |
| 写入范围 | 仅本证据文件；源插件与宿主检出零改动；不改任何产品文件 |
| 结论 | **succeeded** —— 四类约定齐备（§2–§5），与 p0-02/p0-05 既有约定零冲突（§3.1 核对），兵部四批落点互斥且覆盖 A33 全集 33/33（§6），复核方核对接引见 §8 |

---

## 0. 效力与冲突规则

1. 本规范约束阶段 1 各实施 assignment（兵部 p1-01/p1-02/p1-03/p1-04、礼部 p1-06）的**文件落点与结构约定**；功能范围以 p0-03 A33 清单为权威，行为以 04-spec/05 合同为权威。
2. 与 04-spec.md、05-phased-development.md、p0-03 冲突时，以后者为准并回报尚书省修订本规范；本规范内部修订由吏部执行并留痕于本文件尾部修订记录。
3. 阶段 1 交付的每一个新文件都必须能回答：落在哪个目录（§2）、用什么命名空间（§3）、由哪批引入、注册面归属谁（§4）、过没过门禁自检（§5）。

## 1. 源插件构造参照与取舍（只学构造，排除 Win-only）

源插件目录构造（p0-02 快照实测）与新工程映射总览：

| 源构造 | 先例内容（实测） | 新工程处置 |
| --- | --- | --- |
| `Actions\*.cs` 平铺 | 62 文件一目录、无子目录，一文件一 `[ActionInfo]` 注册锚点 | **沿用**：`Actions\` 平铺放 15 个 A 档行动（p1-03） |
| `Controls\` 平铺 + `Controls\Components\` + `Controls\Notifications\` | 行动/规则设置控件平铺；组件与其设置控件成对放 Components；通知内容控件放 Notifications | **沿用三分结构**：Components→p1-01，平铺行动设置控件→p1-03，Notifications→p1-04（仅 A 档所需） |
| `Models\ComponentSettings\` | 组件设置模型逐组件一文件 | **沿用**（p1-01） |
| `Rules\*Settings.cs` + `Rules\Handlers\*RuleHandler.cs` | 规则设置与处理器分置两处 | **沿用**（p1-02） |
| `Triggers\` + `Config\` + `Settings\` | 触发器三件套（本体/配置/设置） | **沿用**（p1-02，仅 A 档触发器） |
| `Themes\<主题>\` 每主题独立目录 | 各含 `manifest.yml`（主题清单）、`Theme.axaml.txt`（主题入口）、`Styles.axaml`、`*Styles.cs`、图片资产 | **沿用**：3 个 A 档主题各自成目录（p1-01） |
| `SettingsPage\*.axaml(.cs)` | 6 个设置页 + ViewModel | **沿用**：6 页骨架（礼部 p1-06） |
| `Services\` 平铺、`Version\VersionCheckService.cs`、`Views\` 窗口/对话框 | 服务平铺；版本检查独立 Version 目录；浮窗/对话框在 Views | **沿用**（p1-04，仅 A 档所需） |
| `ConfigHandlers\`、`Converters\`、`Shared\`、`Models\` | 共享配置/转换器/辅助类型 | **按需引入**（§2.3 规则），不整体复制 |
| Windows-only 构造 | `VoskWorker\`、`ThirdParty\LiquidGlassAvaloniaUI`、`*.bat/*.ps1`、`black.html`、ffmpeg/人脸/Vosk 运行时、`x64` 架构限定、`UseWindowsForms`、硬编码 windows TFM | **排除，一律不进入新工程**（用户指引 + S4.2 + C 档边界） |

axaml 组织先例：`.axaml` 与 `.axaml.cs` 同目录成对、`x:Class` 指向同目录命名空间——新工程逐字沿用。

## 2. 约定一：目录布局（A 档各域落位）

### 2.1 目标目录树（`src\SystemTools.CrossPlatform\` 下，★=阶段 1 新增面）

```
src\SystemTools.CrossPlatform\
├── Plugin.cs                       [既有] 唯一注册面，仅礼部 p1-06 可改（§4.1）
├── manifest.yml                    [既有 p0-05] 插件清单，阶段 1 无人改（icon/readme 落值属后续资产阶段）
├── Actions\                        ★ p1-03：15 个 A 档行动 *.cs，文件名随源（§6 表）
├── Controls\
│   ├── Components\                 ★ p1-01：6 组件成对文件 *Component.axaml(.cs) + *SettingsControl.axaml(.cs)
│   ├── Notifications\              ★ p1-04：仅 AI 文本链所需通知内容控件（随源先例，按需）
│   └── <Name>SettingsControl.cs    ★ p1-03：A 档行动设置控件（平铺随源，按需）／★ p1-02：4 个规则设置控件（修订 R1，同为 Controls\ 平铺、文件名随源）
├── Models\
│   ├── ComponentSettings\          ★ p1-01：6 个组件设置模型 *.cs
│   └── (AiAttachment.cs 等)        ★ p1-04：AI 文本链所需模型（随源 Models\，按需）
├── Rules\
│   ├── <Rule>RuleSettings.cs       ★ p1-02：4 个规则设置类型
│   └── Handlers\                   ★ p1-02：4 个 *RuleHandler.cs
├── Triggers\                       ★ p1-02：ActionInProgressTrigger.cs
├── Config\                         ★ p1-02：ActionInProgressTriggerConfig.cs（随源 Config\ 先例）
├── Settings\                       ★ p1-02：ActionInProgressTriggerSettings.cs ／ p1-03：A 档行动 *Settings.cs（文件级归属见 §2.2）
├── Themes\
│   ├── CardTypeComponent\          ★ p1-01：manifest.yml + Theme.axaml.txt + Styles.axaml + CardTypeComponentStyles.cs
│   ├── ClassWidgets\               ★ p1-01：同上 + ClassWidgetsCard.axaml(.cs) + 图片资产（文件名随源）
│   └── NotchStyle\                 ★ p1-01：同上 + Notch*Control.cs + NotchShapeGeometry.cs + NotchStyleStyles.cs
│                                   ⚠ 源 LiquidGlass（液态玻璃）不迁入（U5/C 候选）
├── Services\                       ★ p1-04：AI 文本链服务集（AiChatWindowService 及 02 §2.6 口径的支撑类型）
│                                   ★ p1-04：VirtualAfterSchoolService.cs（虚拟放学）
├── Version\                        ★ p1-04：VersionCheckService.cs（随源 Version\ 先例）
├── Views\                          ★ p1-04：AiChatFloatingWindow.axaml(.cs)（A9 主链；R-6：自适应背景采样路径不得迁入）
├── SettingsPage\                   ★ 礼部 p1-06：6 页骨架（SystemTools/AiChat/FloatingWindowEditor/MoreFeaturesOptions/About/PluginDebug）+ 各页 ViewModel 骨架
├── Converters\  Shared\            ★ 按需（§2.3 共享类型规则）
└── SystemTools.CrossPlatform.csproj [既有] 阶段 1 默认无人改（§4.4）
```

禁止创建的目录：`VoskWorker\`、`ThirdParty\`、任何 `Platforms.*\` 平台子工程/平台子目录（阶段 1 无此需要，见 §5.1）；禁止落地任何 `.bat`/`.ps1`/`.exe`/原生二进制资产。

### 2.2 批次落点互斥规则（兵部四批 + 礼部）

| 落点 | 唯一引入批次 | 说明 |
| --- | --- | --- |
| `Themes\**`（含主题 manifest.yml、资产） | p1-01 | 3 主题全归 p1-01 |
| `Controls\Components\**`、`Models\ComponentSettings\**` | p1-01 | 组件成对文件与设置模型 |
| `Rules\**`、`Triggers\`、`Config\`、`Controls\<规则名>SettingsControl.cs`（4 个） | p1-02 | 规则域 + A 档触发器三件套 + 规则设置控件随规则批（修订 R1；Controls\ 平铺、文件名随源） |
| `Settings\ActionInProgressTriggerSettings.cs` | p1-02 | 触发器设置类型随触发器批次 |
| `Actions\**`、`Controls\` 平铺行动设置控件、`Settings\<行动名>Settings.cs` | p1-03 | 行动及其附属（附属文件引入规则见 §2.3） |
| `Services\`、`Version\`、`Views\`、`Controls\Notifications\`、AI 文本链所需 `Models\*` | p1-04 | 服务群（AI 文本链/虚拟放学/版本检查 3 项聚合） |
| `Services\SystemToolsNotificationProvider.cs` | p1-04 | **修订 R1 落点确认**：AI 回复通知提供方，其成员属 02 §2.6 AI 文本链支撑集——按功能项归属定落，不适用 §2.3-2"首个需要者引入"共享规则 |
| `SettingsPage\**`、`Plugin.cs` | 礼部 p1-06 | 设置页骨架 6 页 + 注册面 |

判定规则：**同一文件不得出现在两个批次的交付清单**；`Settings\` 与 `Controls\` 是共享容器目录，按"文件随其功能项所属批次"归属（触发器附属→p1-02，规则附属含设置控件→p1-02，行动附属→p1-03）；跨批复用类型一律引用不复制（§2.3）。

### 2.3 共享/附属类型引入规则

1. **附属文件随功能项走**：某 A 档功能项抽取时，其在源插件中的直接附属（同功能的 `*Settings.cs`、`*SettingsControl.cs`、设置模型）由同一批次一并引入，落位随源构造（§1），并在该批交付清单中逐文件列出（含源文件名 → 新落点映射）。
2. **跨功能共享类型由首个需要者引入**：`ConfigHandlers\`、`Converters\`、`Shared\`、`Models\` 中被多个功能引用的类型（如悬浮窗配置状态类型 `FloatingWindowProfile`/`FloatingWindowProfileManager` 为 A3/A4 所需），由**首个需要它的批次**引入（预期为 p1-03 随 A3/A4），在交付清单中标注"共享，后续批次复用"；引入前必须通过 S4.2 自检（§5.2），未通过即停批上报，不得改写其行为。后续批次只引用、不重复定义。
3. **不确定归属时**：批次在交付报告中登记"落点待决文件"并说明理由，由尚书省裁决；不得私自放到规则外目录。
4. `MainConfigData` 型聚合配置根：阶段 1 仅当某 A 档功能确需时才引入，落 `ConfigHandlers\`、命名空间 `SystemTools.CrossPlatform.ConfigHandlers`、类型名保持 `MainConfigData`；其内嵌选项只允许 A 档成员（B/C 选项成员阶段 2/3 处理）。
5. **跨批引用确认（修订 R1）**：p1-03 八个行动的提醒路径经 `SystemToolsNotificationProvider`（落点 p1-04，§2.2）为**合法跨批引用**——p1-03 仅引用该类型，不引入、不复制其文件，并在其 §4.2 注册清单/交付报告中登记该引用关系；该提供方的 DI 注册需求（`AddNotificationProvider` + `AddSingleton` + `IHostedService`）由 **p1-04 注册清单承载**，礼部 p1-06 在 `Plugin.cs` 唯一注册面落实（§4.1）。

### 2.4 资产落位与资源 URI 改写

1. 主题资产（如 `Themes\ClassWidgets\课间休息.png` 等）落主题自身目录、**文件名随源不改**（含中文名），保证 `Theme.axaml.txt` 内相对/资源引用可逐条核对。
2. 资源 URI 因程序集名改变必须逐条改写：`avares://SystemTools/...` → `avares://SystemTools.CrossPlatform/...`（x:Key 保持源值）；p1-01 在交付清单中逐条列出改写点。
3. 资产进 csproj 的 `AvaloniaResource` 接线属工程文件变更 → 按 §4.4 走接线需求流程，批次不得自行改 csproj。

## 3. 约定二：命名空间与命名

### 3.1 与既有约定的零冲突核对

| 既有约定（权威） | 本规范 | 零冲突结论 |
| --- | --- | --- |
| p0-02：AssemblyName/RootNamespace = `SystemTools.CrossPlatform` | 全部新文件命名空间以其为根 | ✅ 一致 |
| p0-05 D7：功能 ID 前缀 = `SystemTools.CrossPlatform.*` | §3.3 ID 变换规则 | ✅ 一致（仅细化，不放宽） |
| p0-05 §4.1：配置命名空间 = `SystemTools.CrossPlatform.*` 类型 | §3.2 全类型规则 | ✅ 一致（配置类型规则为全类型规则的特例） |
| p0-05 §4.2：源插件全源码 `CrossPlatform` 零出现 → 前缀空间不相交 | 新 ID/命名空间必含 `CrossPlatform` 段 | ✅ 同装并存成立的前提被保留 |

### 3.2 命名空间规则

1. **命名空间 = `SystemTools.CrossPlatform.<目录路径>`**，逐级镜像文件在工程内的目录（`Actions\` → `SystemTools.CrossPlatform.Actions`；`Controls\Components\` → `SystemTools.CrossPlatform.Controls.Components`；`Rules\Handlers\` → `SystemTools.CrossPlatform.Rules.Handlers`；`Themes\ClassWidgets\` → `SystemTools.CrossPlatform.Themes.ClassWidgets`；依此类推）。
2. **全类型命名空间必须以 `SystemTools.CrossPlatform.` 开头**：禁止 `SystemTools.*`（与源插件命名空间身份重叠的风险面，p0-05 §4.1 同装逻辑延伸）、禁止全局命名空间类型、禁止在抽取时改写类型名。
3. XAML：`x:Class` = 该文件命名空间 + 类型名；本地 xmlns 用 `using:SystemTools.CrossPlatform....`。
4. using 面：允许 `ClassIsland.*`、`Avalonia.*`、`FluentAvalonia.*`、`Microsoft.Extensions.*`、BCL；**禁止 `using SystemTools.*`（源插件命名空间）**——新插件不与源程序集产生编译耦合。

### 3.3 功能 ID / 注册名变换规则（随源先例改造）

| 源形态（p0-05 §4.1 实测两类） | 新 ID 规则 | 示例 |
| --- | --- | --- |
| `SystemTools.<Name>`（行动等） | `SystemTools.CrossPlatform.<Name>`，`<Name>` 段随源不改 | `SystemTools.KillProcess` → `SystemTools.CrossPlatform.KillProcess` |
| 裸名（主题/组件/规则集，如 `classwidgets`、`notch-style`） | `SystemTools.CrossPlatform.<裸名>`，裸名随源不改 | `classwidgets` → `SystemTools.CrossPlatform.classwidgets` |

- 判据：任何新注册 ID 必含 `CrossPlatform` 段 → 与源插件 ID 空间不相交（p0-05 §4.2 已证源侧零出现）。
- 显示名（ActionInfo 第二参等）随源文案不改；图标字符参数随源。
- **GUID 形态条款（修订 R1 增补）**：前缀规则**不覆盖 GUID 形态注册身份**。新插件全部 GUID 形态注册身份（`ComponentInfo`、`NotificationProviderInfo` 及同形态特性/参数）一律使用**新 GUID**，与源插件全部 GUID **零重合**（依据：04-spec R-10 同装并存 + 宿主 `ComponentRegistryExtensions.cs:46-49` 对同 GUID 组件注册抛错）。生成方式二选一并留痕：①确定性派生（由源 GUID + 新插件标识确定性派生，可复算）；②一次性固化（生成后写死源码）。每批在其交付证据中提供**旧→新 GUID 映射表**（源 GUID → 新 GUID → 使用点 文件:行），供复核方重放核对零重合。上表字符串 ID 规则不变。

### 3.4 类型/文件命名与资源键

1. **文件名 = 主类型名**，一文件一主类型；抽取文件**沿用源文件名**（含 `SetVolume.cs` 这类非 Action 后缀名），保证与 p0-03 清单逐行可对——阶段 1 不做任何改名。
2. 附属命名随源先例：`*Action.cs`、`*Component.axaml(.cs)`、`*SettingsControl.axaml(.cs)` / `.cs`、`*RuleHandler.cs`、`*Trigger.cs`、`*Settings.cs`、`*Config.cs`、主题 `*Styles.cs` + `Theme.axaml.txt` + `Styles.axaml` + `manifest.yml`。
3. 资源键约定：主题内 `x:Key`、样式选择器、动态资源引用**随源值不改**；仅按 §2.4-2 改资源 URI 的程序集段。组件注册显示名随源。
4. 新造文件（如确需的注册辅助）命名须经交付报告说明并报尚书省备案；默认状态 = 阶段 1 零新造文件名。

## 4. 约定三：注册面与配置面归属

### 4.1 唯一注册面 = `Plugin.cs`（仅礼部 p1-06 可改）

1. 工程根 `Plugin.cs` 是**唯一**代码注册面：行动（ActionInfo）、组件、规则、触发器、主题、服务 DI、设置页入口的全部注册接线在此进行（对齐源插件 Plugin.cs 单面注册先例）。
2. **兵部 p1-01–p1-04 禁改** `Plugin.cs`、`manifest.yml`、`SystemTools.CrossPlatform.csproj`、`global.json`、slnx；改了即越界，门下省/都察院可按此判 remand。
3. 若沿源先例引入注册辅助文件（如源 `Shared\InjectServices.cs` 型自动注册面），该文件**属注册面延伸，同样仅礼部可建/可改**，且须经尚书省同意。

### 4.2 注册清单交接格式（兵部批 → 礼部 p1-06）

每个兵部批交付时，在其证据文件中给出结构化**注册清单**（礼部据此写 Plugin.cs，兵部不写注册代码）：

| 列 | 内容 |
| --- | --- |
| 项 | p0-03 功能项编号（A1…）+ 功能名 |
| 类型全名 | 新命名空间全名（§3.2） |
| 功能 ID | 按 §3.3 变换后的 `SystemTools.CrossPlatform.*` |
| 注册目标 | ActionInfo / 组件注册 / 规则 / 触发器 / 主题 / 服务 DI（生命周期随源先例）/ 设置页入口 |
| 设置类型全名 | 该项 `*Settings.cs` / `*Config.cs` 新全名（无则"无"） |
| 源锚点 | 源文件:行（p0-03 清单行） |

规则注册形态注（修订 R1）：礼部 p1-06 按 p1-02 注册清单以双参形态 `AddRule<TSettings, TSettingsControl>` 落地规则（设置类型 + 设置控件）；SDK 单参重载 `AddRule<TSettings>`（`RulesetRegistryExtensions.cs:39-45`）亦为合法形态，以实际接线为准。

### 4.3 主题清单与设置页骨架归属

1. `Themes\<主题>\manifest.yml` 是**主题发现资产**（宿主按目录加载），不是插件注册面：由 p1-01 交付（随源构造，id 按 §3.3 前缀规则改写），礼部 p1-06 复核其与 Plugin.cs 注册的一致性。
2. `SettingsPage\` 6 页**骨架**（页面类 + 导航入口）由礼部 p1-06 交付，落 `SettingsPage\`、命名空间 `SystemTools.CrossPlatform.SettingsPage`；页面骨架引用的页内选项按各功能项档位归属其批次交付的选项类型，骨架不复制 B/C 选项实现。

### 4.4 配置面与工程接线需求流程

1. 选项/配置类型落位随源构造（§1/§2.3），命名空间随 §3.2；配置类型由其功能项批次交付，礼部不代写。
2. 任何 csproj 需求（如主题资产 `AvaloniaResource` 接线）**不自批改**：批次在交付报告登记"接线需求"（目标文件 + 期望 ItemGroup 形态），由尚书省指定归属（默认礼部 p1-06 执行或另派），执行后仍按 §4.1 的禁改面口径追认。
3. `manifest.yml` 插件级清单阶段 1 零变更（p0-05 已固化）；icon/readme 落值属后续资产阶段，不在阶段 1。

## 5. 约定四：兼容性与门禁结构规则

### 5.1 平台条件文件组织方式（Platforms_* 模式）

1. 常量来源唯一：宿主 `CrossPlatformProps.props` 注入的 `Platforms_Windows` / `Platforms_Linux` / `Platforms_MacOs`（p0-02 §3 实测 DefineConstants）与 `OperatingSystem.IsWindows()/IsLinux()/IsMacOs()` 运行时守卫；**禁止自定义平台常量、禁止硬编码平台 TFM、禁止 x86/x64 架构限定**（用户指引）。
2. **阶段 1（A 档）规则：零平台分叉**。A 档定义即"无 S4.2 禁用符号、纯跨平台路径"（04-spec §S4.2），因此阶段 1 不创建平台条件文件、不建平台子目录、不新增 `#if Platforms_*` 分叉；源 A 档文件内既有的 `OperatingSystem.IsWindows()` 守卫分支（p0-03 A5:89 等）按 04-spec 允许原样保留或删除。
3. 抽取中发现某 A 档文件**必须**平台分支才能编译 → 停批上报（该事实可能触发分档复核，04-spec §S6），不得以 `#if Platforms_Windows` 包裹 Windows-only API 混入共享路径。`#if` 平台隔离文件的组织方式（命名 `*Windows.cs` 等 + csproj 条件编译项）为**阶段 2 B 档**的结构面，届时另立规范。
4. Windows-only 资产（`.bat`/`.ps1`/ffmpeg/人脸模型/Vosk 运行时/`black.html` 等）不得进入新工程任何路径（§2.1 禁止清单）。
5. 宿主抽象消费口径（p0-01 §3/§7）：优先 `IWindowPlatformService`、`IDesktopToastService`、`ILauncherService`、`IDesktopService`；注意缺口 G1–G3（`ISystemEventsService` 无 Linux/macOS 实装且无会话结束事件、`IDesktopService` 无 macOS 实装）——凡引用这两者的 A 档逻辑，自检表中 macOS 语义须写实（Stub 语义/降级），不得假定可用。

### 5.2 S4.2 门禁自检（每批交付前，exit=0）

1. 每批对**本批交付路径**运行 p0-07 扫描器并留存原始输出（证据文件名 `p1-0X-s42-scan-output.txt`）：

   ```powershell
   pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
        -Path <本批交付目录或文件，如 src\SystemTools.CrossPlatform\Actions> -Scope Source
   # 预期：GateHits=0，VERDICT: PASS，exit=0
   ```

2. 判定语义（p0-07 §2.1，批次须知）：符号规则对 `.cs` **注释同样从严计命中** → 引用禁用符号的说明文字只能写在 `.tang` 证据（.md）中，**不得出现在交付的 .cs 注释里**（含从源文件带注释抽取的情形，注释含禁用符号须清理并记录）。INFO 规则（I*）非门禁，但出现即在 §5.3 表中逐条说明。
3. 批级自检 + 阶段出口门禁的关系：扫描 exit=0 是**批交付前置**；Windows/Linux/macOS 三平台构建通过是**阶段 1 出口门禁**（05 合同阶段 1），由阶段级验证执行，批次不得以扫描通过替代构建。
4. 全量复跑：p1-06 完成注册面后，对 `src\SystemTools.CrossPlatform` 全目录复跑同一命令（Source 面），作为阶段 1 抽取面零命中的收口证据。

### 5.3 macOS 兼容自检记录格式（逐项，随批交付）

每批证据中附下表，覆盖本批全部新文件中使用的外部依赖点（BCL 纯 .NET API 不逐项列，注明"BCL"即可）：

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `Actions\ShowToastAction.cs:31` | `PlatformServices.DesktopToastService.ShowToastAsync` | 宿主抽象（保留） | 可用（p0-01 §3 #3 三平台实装） |
| … | … | … | 宿主抽象 / 跨平台 API / BCL / 删除（守卫分支）/ 按已批降级口径 | 可用 / 降级（写实说明）/ **不适用** |

填表规则：

1. **适配方式**限五类枚举：宿主跨平台抽象（注明接口名，须在 p0-01 §3 已核实）、Avalonia/FluentAvalonia/SDK 跨平台 API、BCL、删除（仅限 04-spec 允许删除的守卫分支）、按已批准降级口径（注明 04-spec/U 条款号）。
2. **macOS 语义 = "不适用"即阻塞项**：该批不得交付，登记原因回报尚书省（可能触发 S6 分档复核或降级口径修订）。
3. 宿主抽象引用必须与 p0-01 §3 的接口清单与缺口注记（G1–G3）一致；发明新接口属越界。
4. 该表与 §4.2 注册清单同为批交付的必要组成，缺任一即视为未完成。

## 6. A33 覆盖核对（落点互斥 + 全集闭合）

| 域 | 项数 | 明细（源文件/实体） | 引入批次 | 落点 |
| --- | --: | --- | --- | --- |
| 主题 | 3 | CardTypeComponent 主题；ClassWidgets 主题；NotchStyle 主题 | p1-01 | `Themes\CardTypeComponent|ClassWidgets|NotchStyle\` |
| 组件 | 6 | NetworkStatus / ClipboardContent / LocalQuote / NextClassDisplay / BetterCarouselContainer / ScrollingText（各含设置对） | p1-01 | `Controls\Components\` + `Models\ComponentSettings\` |
| 规则集 | 4 | ProcessRunningRule / UsingClassPlanRule / UsingTimeLayoutRule / InTimePeriodRule（设置 + Handler） | p1-02 | `Rules\` + `Rules\Handlers\` |
| 触发器 | 1 | ActionInProgressTrigger（本体 + Config + Settings 三件套） | p1-02 | `Triggers\` + `Config\` + `Settings\` |
| 行动 | 15 | A1 KillProcess、A2 ShowToast、A3 ToggleFloatingWindowProfile、A4 SwitchFloatingWindowTheme、A5 BackgroundPlayAudio、A6 ActionFlowExecutionConfirmation、A7 TriggerCustomTrigger、A8 ToggleWorkflow、A9 ShowAiChatDialog、A10 FullscreenClock、A11 ClearAllNotifications、A12 LoadTemporaryClassPlan、A13 OpenAppSettings、A14 OpenProfileEditor、A15 OpenClassSwapWindow（源文件名见 p0-03 §3.1） | p1-03 | `Actions\` + `Controls\` 平铺设置控件 + `Settings\` + §2.3-2 共享配置类型 |
| 服务群（A 聚合） | 4 | ① AI 文本链（AiChatWindowService 及 02 §2.6 口径支撑集，含 A9 浮窗 `Views\AiChatFloatingWindow`，R-6 采样子特性不迁）② 虚拟放学 `Services\VirtualAfterSchoolService.cs` ③ 版本检查 `Version\VersionCheckService.cs` ④ 设置页骨架 6 页 | ①②③ = p1-04；④ = 礼部 p1-06 | `Services\` + `Version\` + `Views\`（+按需 `Models\`、`Controls\Notifications\`）；`SettingsPage\` |
| **合计** | **33** | = 3+6+4+1+15+4，与 p0-03 §4.2 / 04-spec §S4.1 一致 | 互斥：p1-01/p1-02/p1-03/p1-04/p1-06 五落点集两两无交集（§2.2） | |

闭合校验：兵部四批 = 3+6+4+1+15+3 = 32 项；礼部 p1-06 = 1 项（设置页骨架聚合）；33/33，无遗漏、无重复归属。C 档 46 项零落点（不进入任何目录）；B 档 19 项零落点（阶段 2 另行规划，本规范不预支）。

## 7. 阶段 1 交接流程摘要

1. 兵部 p1-01 → p1-02 → p1-03 → p1-04（依赖序随尚书省阶段计划）：按本规范落位抽取 → 批内自检（§5.2 扫描 exit=0 + §5.3 macOS 表 + §4.2 注册清单）→ 交付报告。
2. 礼部 p1-06：汇总四批注册清单 → 写 `Plugin.cs` 唯一注册面 + 交付 `SettingsPage\` 6 页骨架 → 复核主题 manifest id 一致性 → 全目录复跑扫描（§5.2-4）。
3. 阶段出口：三平台构建门禁（05 合同阶段 1）通过后，方进入阶段 2。
4. 任何落点/命名/注册面冲突：停批 → 交付报告登记 → 尚书省裁决；不得私自改规范外的路径或归属。

## 8. 复核指引（另一复核方据此核对新文件落位）

1. 树核对：`Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object FullName -notmatch '\\(bin|obj)\\'`，对照 §2.1 树与 §2.2 归属表——每个新文件应能唯一归入一个批次落点。
2. 命名空间核对：抽查每个新 `.cs` 的 `namespace` 以 `SystemTools.CrossPlatform.` 开头且镜像目录；`Select-String -Path src\SystemTools.CrossPlatform\**\*.cs -Pattern 'namespace (?!SystemTools\.CrossPlatform)'` 预期零命中（含 `SystemTools.` 裸前缀零命中）。
3. ID 前缀核对：对交付源码 `Select-String -Pattern '"SystemTools\.' `，命中行应全部为 `SystemTools.CrossPlatform.` 形态（引用源插件 ID 的字符串零出现）。
4. 注册面核对：`Plugin.cs` 的 git diff 应仅由礼部 p1-06 产生；四批交付报告中不应包含对 `Plugin.cs`/csproj/manifest.yml 的写入声明。
5. 门禁核对：重放各批 `p1-0X-s42-scan-output.txt` 所载命令，预期 exit=0；对全目录复跑同命令亦应 exit=0。
6. A33 闭合：按 §6 表清点各批交付清单项数 = 33，且每项源锚点可回查 p0-03 清单行。

## 9. 边界声明

- 源插件 `E:\My Github Projects\SystemTools` 与宿主检出全程**只读**；本任务对其零写入（目录构造事实取自 p0-02 快照与 p0-03 实测，未直接触碰源检出）。
- 本任务唯一写入 = 本证据文件；未改任何产品文件（`src\` 下零新增/零修改）。
- 本文件不推进、不审批全局工作流；落点规范之外的执行问题回报尚书省。

## 10. 修订记录

- **R1（尚书省修订指令，阶段 1 执行期；依据：兵部 p1-01 上报宿主 `ComponentRegistryExtensions.cs:46-49` 对同 GUID 组件注册抛错、p1-03 中期简报 `SystemToolsNotificationProvider` 跨批依赖）**——本规范吏部内部修订，零产品文件改动：
  1. **§3.3 增补「GUID 形态条款」**：前缀规则不覆盖 GUID；新插件全部 GUID 形态注册身份（ComponentInfo/NotificationProviderInfo/同形态）一律新 GUID、与源插件全部 GUID 零重合（R-10 同装并存 + 宿主同 GUID 抛错为依据）；生成方式确定性派生或一次性固化，旧→新映射逐条留痕批证据；字符串 ID 规则不变。
  2. **§2.2/§2.3 增补落点确认**：`Services\SystemToolsNotificationProvider.cs` 归 p1-04（其 AI 回复通知成员属 02 §2.6 AI 文本链支撑集）；p1-03 八行动提醒路径为合法跨批引用（登记于其注册清单）；该提供方 DI 注册需求（AddNotificationProvider + AddSingleton + IHostedService）由 p1-04 注册清单承载、礼部 p1-06 落实。
  3. **§2.1/§2.2 增补落点归属（追加修订项）**：4 个规则设置控件（源 `Controls\ProcessRunningRuleSettingsControl.cs` 等 4 文件）归兵部 p1-02 批（`Controls\` 平铺，文件名随源）——与行动设置控件随行动批同理；礼部 p1-06 注册时按 p1-02 注册清单双参形态 `AddRule<TSettings, TSettingsControl>` 落地（SDK 单参重载 `AddRule<TSettings>`，`RulesetRegistryExtensions.cs:39-45`，亦为合法形态，以实际接线为准）。
  - 涉及位置：§3.3（GUID 条款）、§2.1（Controls\ 平铺行）、§2.2（p1-04 新增行 + p1-02/p1-03 行 + 判定规则）、§2.3（新增第 5 条）、§4.2（规则注册形态注）；修订不改变 §2.2 互斥判定与 §6 A33 闭合校验（规则设置控件为规则项附属、不另计项；NotificationProvider 本就落在 p1-04 的 `Services\` 落点集内，仅显式化归属）。
