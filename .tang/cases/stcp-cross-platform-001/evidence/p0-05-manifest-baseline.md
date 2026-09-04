# p0-05 新插件独立 manifest 与配置命名空间基线证据（礼部 interfaces-documentation / implementation）

- 案卷：`stcp-cross-platform-001`；阶段 0 / assignment `p0-05`（medium+ reasoning_effort）；依赖 `p0-01`、`p0-02` 均已 succeeded（`p0-04` 已完成，csproj 空闲可编辑）
- 权威输入：`04-spec.md` R-10（:41）；`05-phased-development.md` 合同 0.1.4（:32）、0.3「插件元数据」行（:48）、0.5.3（:66）、CP-0.3（:78）；`06-migration-details-proposal.md` 预备清单第 8 条（:565）
- 先读证据：`p0-01-host-contract-baseline.md` §5（schema/解析/apiVersion 依据/源 manifest 现状）；`p0-02-scaffold-tree.md` §7（CreateCipx/CISDK0001 边界）；`p0-04-dependency-baseline.md` §6（csproj 注释块现状，本任务保留）
- 写入面：`src\SystemTools.CrossPlatform\`（manifest.yml 新增 + csproj 接线）、`.tools\manifest-schema-check\`（校验工具）、本证据文件。原插件 `E:\My Github Projects\SystemTools` 与宿主检出 `E:\ClassIsland-git-misha` 全程只读（零写入证明见 §7）
- 结论：**succeeded** —— 新 manifest 按宿主实际解析配置（YamlDotNet 16.0.0.0 + ClassIsland.Core 2.1.1.1）反序列化通过且 11 项断言全过；id / 功能 ID 前缀 / 配置命名空间与原插件零重合；三平台列表完整；apiVersion = 2.0.0.0 与 U3 基线一致；p0-06 打包前置（输出目录含 manifest.yml）已就绪

## 1. 交付物清单

| 文件 | 性质 | 说明 |
| --- | --- | --- |
| `src\SystemTools.CrossPlatform\manifest.yml` | 新增 | 新插件清单（全文见 §2；SHA256 `142CD419…AAC`） |
| `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | 编辑 | manifest 输出接线 + 头注释同步（§6；SHA256 `0797298A…139`；p0-04 注释块原样保留） |
| `.tools\manifest-schema-check\manifest-schema-check.csproj` + `Program.cs` | 新增 | manifest schema 校验工具（§5.1；不入 slnx，不参与插件构建） |
| `.tang/cases/stcp-cross-platform-001/evidence/p0-05-manifest-baseline.md` | 本文件 | 唯一 deliverable |

## 2. 新插件 manifest.yml 全文

```yaml
# SystemTools-Cross-platform 插件清单（案卷 stcp-cross-platform-001 / 阶段 0 / p0-05）
# 格式：ClassIsland 宿主插件清单（模型 ClassIsland.Core\Models\Plugin\PluginManifest.cs:10-73，
#       解析 ClassIsland\Services\PluginService.cs:68-72：CamelCase + IgnoreUnmatchedProperties + OSPlatform 转换器）。
# 独立性：id / 显示名 / 入口程序集 / 功能 ID 前缀（SystemTools.CrossPlatform.*，约定于 p0-05 证据文件）
#         / 配置命名空间（SystemTools.CrossPlatform.*，同上）均与原插件 SystemTools 零重合，支持同装并存。
# apiVersion 依据：宿主加载下限 2.0.0.0（U3 基线，PluginService.cs:168-171；p0-01 §5.3）。
# url 字段留缺（新插件仓库地址未定，不沿用原插件 URL）；dependencies 留缺（无插件依赖）。
# readme/icon 显式置空：当前脚手架无对应资产文件，避免缺省值（README.md/icon.png）成为悬空引用；
#         资产文件与字段落值随功能阶段交付时再更新。

id: SystemTools-Cross-platform
name: SystemTools 跨平台版
description: SystemTools 插件的跨平台独立版本（Windows/Linux/macOS），与原 SystemTools 插件同装并存，功能按阶段迁移交付。
entranceAssembly: "SystemTools.CrossPlatform.dll"
version: 1.0.0.0
apiVersion: 2.0.0.0
author: Programmer-MrWang
readme: ""
icon: ""
supportedOSPlatforms:
- Windows
- Linux
- macOS
```

YAML 键名拼写依据（经 §5 探针实证）：宿主 `CamelCaseNamingConvention` 对 PascalCase 属性名仅小写首字母 —— `SupportedOSPlatforms`→`supportedOSPlatforms`、`EntranceAssembly`→`entranceAssembly`、`ApiVersion`→`apiVersion`（源插件 manifest 同拼写且解析命中，§5.3 探针输出可证）。

## 3. 与源 manifest.yml 逐字段对照（R-10）

源：`E:\My Github Projects\SystemTools\manifest.yml`（SHA256 `13A2E178…985`，与 p0-02 §9.1 记录一致 = 本任务只读未改）。模型 schema：`PluginManifest.cs:10-73`。

| # | schema 属性（PluginManifest.cs） | YAML 键（CamelCase） | 源插件值 | 新插件值 | 取舍说明 |
| --- | --- | --- | --- | --- | --- |
| 1 | `Id` :26 | `id` | `SystemTools` | `SystemTools-Cross-platform` | **独立命名（用户既定，04-spec R-10 / 05 合同 0.3：不得为 SystemTools）**；同装加载去重键（PluginService.cs:159-161）不冲突 |
| 2 | `Name` :21 | `name` | `SystemTools - Hoshimi Miyabi` | `SystemTools 跨平台版` | **独立显示名**（D2）：与源显示名不同串，同装时插件列表可区分 |
| 3 | `Description` :31 | `description` | 提供多彩而丰富的更多 组件/行动/规则集/触发器/实用工具/AI功能 | SystemTools 插件的跨平台独立版本（Windows/Linux/macOS），与原 SystemTools 插件同装并存，功能按阶段迁移交付。 | 独立内容，如实描述当前并存/迁移状态；不复制源文案 |
| 4 | `EntranceAssembly` :16 | `entranceAssembly` | `SystemTools.dll` | `SystemTools.CrossPlatform.dll` | 与新工程 AssemblyName `SystemTools.CrossPlatform`（p0-02 脚手架，§6 实测求值）一致 + `.dll` 后缀（schema 示例/源插件同款格式） |
| 5 | `Url` :46（string?） | `url` | `https://github.com/Programmer-MrWang/SystemTools` | **留缺（null）** | D5：新插件仓库地址未定，不沿用源 URL（避免市场/详情页误指向原插件）；后续阶段可补 |
| 6 | `Version` :51 | `version` | `3.0.0.0` | `1.0.0.0` | **D1（执行层决定）**：新插件独立版本线从 1.0.0.0 起，不复用源插件 3.0.0.0 序列，体现"独立产品线、独立演进"（并存策略） |
| 7 | `ApiVersion` :56 | `apiVersion` | `2.2.0.0` | `2.0.0.0` | **按 p0-01 §5.3 U3 依据**：宿主加载下限 2.0.0.0（PluginService.cs:168-171，`< 2.0.0.0` 判 Error；仓库示例 ExamplePlugin manifest.yml:6 同值）。高于下限合法，取下限 = 与 U3 检出的 API 面精确对齐，不虚报更高契约 |
| 8 | `Author` :61 | `author` | `Programmer-MrWang` | `Programmer-MrWang` | D6：作者为信息性字段（无命名空间/存储影响），沿用真实作者身份；显示区分由 id/name 承担 |
| 9 | `Readme` :41（默认 `README.md`） | `readme` | `README.md` | `""`（显式空） | D3：新插件工程内无 README 资产（p0-02 未创建；工作区根 README.md 是仓库文档，不随包输出），显式置空避免缺省值成为悬空引用（宿主 PluginMarketService.cs:458 / PluginsSettingsPage.axaml.cs:74 会消费该路径）；资产随阶段交付后更新 |
| 10 | `Icon` :36（默认 `icon.png`） | `icon` | `icon.png` | `""`（显式空） | D4：同 D3，无 icon.png 资产；置空优于悬空缺省。图标资产与字段落值属后续功能阶段 |
| 11 | `Dependencies` :66 | `dependencies` | 留缺（默认 `[]`） | **留缺（默认 `[]`）** | 无插件级依赖；两侧同形 |
| 12 | `SupportedOSPlatforms` :72（默认五平台） | `supportedOSPlatforms` | `[Windows]`（:19-20） | `[Windows, Linux, macOS]` | **R-10 核心要求**：三平台完整列表（合法值见 ClassIsland.Core\Enums\OSPlatform.cs:6-32 枚举 Windows/Linux/macOS/Android/iOS/Unknown；YAML 大小写不敏感解析，OSPlatformTypeConverter.cs:24-33）。不列 Android/iOS：既定交付面为 Windows/Linux/X11/macOS（04-spec U3/CP-0.1），按需收敛默认五平台 |
| — | （schema 外字段） | `repoOwner`/`repoName`/`assetsRoot` | `Programmer-MrWang`/`SystemTools`/`main` | **不写** | 源清单这三键**不是** PluginManifest schema 属性（PluginManifest.cs:10-73 无对应；`IMarketplaceItemManifest` 仅含 Name/Id/Description/Version，`IMarketplaceItemRepoManifest` 另有其表）；宿主经 `IgnoreUnmatchedProperties`（PluginService.cs:69）忽略。§5.3 探针对源 manifest 的 dump 实证：解析结果中无此三键的任何落点。新 manifest 不携带死字段 |
| — | （schema 外注释） | `# nonk8s` 等头注释 | 4 行注释 | 本任务自注 8 行注释 | 注释不被解析（YAML 语法层），仅文档用途 |

## 4. 独立性核对（05 合同 0.5.3 / CP-0.3）

### 4.1 逐项零重合证明

| 项 | 原插件 | 新插件 | 零重合判定 | 证据 |
| --- | --- | --- | --- | --- |
| manifest `id` | `SystemTools` | `SystemTools-Cross-platform` | **不同串**（长度 11 vs 25；大小写敏感精确比较，宿主按整串收集去重 PluginService.cs:159-161） | §5.4 断言 A1 PASS |
| 显示名 `name` | `SystemTools - Hoshimi Miyabi` | `SystemTools 跨平台版` | 不同串 | §5.4 断言 A6 PASS |
| 入口程序集 | `SystemTools.dll` | `SystemTools.CrossPlatform.dll` | 不同文件名；宿主按 manifest 各自加载入口，同装两 DLL 并存不冲突 | §5.4 断言 A2 PASS |
| 功能 ID 前缀 | 实测 ID 空间：裸名（`Card-type-component`、`classwidgets`、`notch-style`）+ `SystemTools.<Name>`（`SystemTools.Shutdown`、`SystemTools.HotkeyTrigger` 等，Plugin.cs:79-533 抽样 80+ 处） | **约定：`SystemTools.CrossPlatform.*`**（阶段 0 仅固化约定，不注册任何功能；注册属阶段 1–3） | **不相交**：任何碰撞都要求原插件侧出现字符串 `CrossPlatform`，而原插件全源码 grep `CrossPlatform` **零命中**（本节 4.2 重放）→ `SystemTools.CrossPlatform.X` 不可能是原插件已注册/将注册的 ID | §4.2 grep + §5.4 断言 A10 PASS |
| 配置命名空间 | 配置/设置类型全部在 `SystemTools` 与 `SystemTools.ConfigHandlers` 等命名空间（如 `MainConfigData`（ConfigHandlers\MainConfigData.cs:11）、`LiquidGlassSettings`（ConfigHandlers\LiquidGlassSettings.cs:6-8）） | **约定：新插件配置根类型/路径一律置于 `SystemTools.CrossPlatform.*` 命名空间**（阶段 0 仅固化约定；不注册任何设置类型） | C# 命名空间 `SystemTools.CrossPlatform` 与 `SystemTools`/`SystemTools.ConfigHandlers` 为**不同命名空间身份**（子命名空间不与父合并）；且"`.CrossPlatform.`"段在原插件全源码零出现（4.2）→ 类型全名不可能重合 | §4.2 grep + p0-02 §1（RootNamespace=SystemTools.CrossPlatform） |
| 版本线 | `3.0.0.0` | `1.0.0.0` | 独立序列（D1） | §5.4 断言 A3 PASS |
| apiVersion 语义 | `2.2.0.0`（高于下限） | `2.0.0.0`（= U3 基线下限） | 各自独立落值，新值与 U3 检出 API 面一致 | §5.4 断言 A4 PASS |

### 4.2 可重放核对命令

```powershell
# 原插件全源码 'CrossPlatform' 出现次数（预期 0 命中 → 功能前缀/配置命名空间不相交的关键事实）
Get-ChildItem 'E:\My Github Projects\SystemTools' -Recurse -Filter *.cs |
  Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } |
  Select-String -Pattern 'CrossPlatform' -SimpleMatch
# 本任务实测：无输出（0 命中）

# 原插件 manifest id 现状（预期 SystemTools，且哈希与 p0-02 §9.1 一致）
Get-FileHash 'E:\My Github Projects\SystemTools\manifest.yml' -Algorithm SHA256
# 实测 13A2E178B7BB3CF45F2D8678E34B20AAC7393A1FA65E3B4F594A916D1948A985（= p0-02 快照值）

# 原插件功能 ID 抽样（预期 SystemTools.<Name> 与裸名两类，无 CrossPlatform 段）
Select-String -Path 'E:\My Github Projects\SystemTools\Plugin.cs' -Pattern 'Id = "'
```

### 4.3 同装差异说明·基础对照表（完整同装差异说明属阶段 3，此为基础数据）

| 维度 | 原插件 SystemTools | 新插件 SystemTools-Cross-platform | 同装含义 |
| --- | --- | --- | --- |
| manifest id | `SystemTools` | `SystemTools-Cross-platform` | 宿主插件列表两行；加载去重互不影响 |
| 显示名 | SystemTools - Hoshimi Miyabi | SystemTools 跨平台版 | 用户可见区分 |
| 入口程序集 | SystemTools.dll | SystemTools.CrossPlatform.dll | 两个程序集文件并存于各自插件目录 |
| 平台面 | Windows | Windows / Linux / macOS | 新插件在 Linux/macOS 亦加载；原插件仅在 Windows |
| apiVersion | 2.2.0.0 | 2.0.0.0 | 均满足宿主下限 2.0.0.0（PluginService.cs:168-171） |
| version | 3.0.0.0 | 1.0.0.0 | 独立版本线 |
| 功能 ID 空间 | 裸名 + `SystemTools.*` | 约定 `SystemTools.CrossPlatform.*`（1–3 阶段生效） | 注册项不覆盖（同 ID 才覆盖，前缀不相交） |
| 配置命名空间 | `SystemTools.*` 类型 | 约定 `SystemTools.CrossPlatform.*` 类型（1–3 阶段生效） | 类型全名不同 → 宿主按类型的设置存储互不指向 |
| 依赖声明 | S4.2 Windows 原生包（csproj:46-56） | 零直接包（p0-04） | 新插件不携带 Windows 原生运行时 |

## 5. 解析验证（可重放）

### 5.1 方法：宿主二进制同构反序列化校验工具

首选路径落地成功：`.tools\manifest-schema-check\`（console 工具，net10.0）。要点：

- **模型与解析器均取自宿主实际二进制**（只读 `<Reference>` + HintPath 引用 `E:\ClassIsland-git-misha\ClassIsland.Desktop\bin\Debug\net10.0-windows10.0.19041.0\` 下 `ClassIsland.Core.dll`（含 PluginManifest 模型）、`YamlDotNet.dll`、`CommunityToolkit.Mvvm.dll`（PluginManifest 基类 ObservableRecipient 所在）；SHA256 见 §8）。无 ProjectReference、不写宿主检出；restore/build 只写 `.tools\` 内 obj/bin（工作区）。
- **DeserializerBuilder 配置复刻 `PluginService.cs:68-72`**：`IgnoreUnmatchedProperties()` + `WithTypeConverter(new OSPlatformTypeConverter_Yaml())` + `WithNamingConvention(CamelCaseNamingConvention.Instance)`。
- **OSPlatform 转换器逐行复刻** `ClassIsland\Converters\OSPlatformTypeConverter.cs:11-36`（ReadYaml 分支；WriteYaml 分支校验不需要，标注 NotSupported）。复刻文件 SHA256 `6A1D4F9F…8C6`（§8）以锁定复刻源版本。
- 断言集 A1–A10（+ SRC-ID）硬编码既定值，任一失败退出码 2；全部通过输出 `SCHEMA-PARSE-CHECK: PASSED`、退出码 0。工具不入 slnx，不参与插件构建。
- 构建期唯一警告 MSB3277（RAR 对宿主 bin 依赖闭包的 WindowsBase/System.Reactive 版本比较噪声），非致命、不影响解析结果。

### 5.2 实测结果（对新 manifest，2026-09-03，dotnet SDK 10.0.302，YamlDotNet 16.0.0.0）

```
== p0-05 manifest schema check ==
tool-assembly-version: 1.0.0.0
classisland-core-assembly: ClassIsland.Core 2.1.1.1
yamldotnet-assembly: YamlDotNet 16.0.0.0
host-api-version-floor: 2.0.0.0 (ClassIsland\Services\PluginService.cs:168-171)
deserializer-config-replicated-from: PluginService.cs:68-72 (IgnoreUnmatchedProperties + OSPlatformTypeConverter_Yaml + CamelCaseNamingConvention)
converter-replicated-from: ClassIsland\Converters\OSPlatformTypeConverter.cs:11-36
check-target: src\SystemTools.CrossPlatform\manifest.yml
source-compare-target: E:\My Github Projects\SystemTools\manifest.yml

-- dump [NEW-PLUGIN] --
IsActive = False
EntranceAssembly = SystemTools.CrossPlatform.dll
Name = SystemTools 跨平台版
Id = SystemTools-Cross-platform
Description = SystemTools 插件的跨平台独立版本（Windows/Linux/macOS），与原 SystemTools 插件同装并存，功能按阶段迁移交付。
Icon =
Readme =
Url = <null>
Version = 1.0.0.0
ApiVersion = 2.0.0.0
Author = Programmer-MrWang
Dependencies = count=0
SupportedOSPlatforms = [Windows, Linux, macOS]

-- dump [SOURCE-PLUGIN] --
IsActive = False
EntranceAssembly = SystemTools.dll
Name = SystemTools - Hoshimi Miyabi
Id = SystemTools
Description = 提供多彩而丰富的更多 组件/行动/规则集/触发器/实用工具/AI功能
Icon = icon.png
Readme = README.md
Url = https://github.com/Programmer-MrWang/SystemTools
Version = 3.0.0.0
ApiVersion = 2.2.0.0
Author = Programmer-MrWang
Dependencies = count=0
SupportedOSPlatforms = [Windows]

[PASS] SRC-ID: source manifest id = 'SystemTools' (expected 'SystemTools', unchanged baseline)
[PASS] A1-ID: id = 'SystemTools-Cross-platform' (expected 'SystemTools-Cross-platform', must not be 'SystemTools')
[PASS] A2-ENTRANCE: entranceAssembly = 'SystemTools.CrossPlatform.dll' (expected 'SystemTools.CrossPlatform.dll')
[PASS] A3-VERSION: version = '1.0.0.0' (expected '1.0.0.0'; 独立于原插件 3.0.0.0)
[PASS] A4-APIVERSION: apiVersion = '2.0.0.0' (expected '2.0.0.0', floor 2.0.0.0)
[PASS] A5-PLATFORMS: supportedOSPlatforms = [Windows, Linux, macOS] (expected [Windows, Linux, macOS])
[PASS] A6-NAME: name = 'SystemTools 跨平台版' (non-empty, distinct from source display name)
[PASS] A7-ICON-README: icon = '', readme = '' (explicit empty: no asset files in scaffold)
[PASS] A8-AUTHOR: author = 'Programmer-MrWang'
[PASS] A9-DEPENDENCIES: dependencies count = 0 (expected 0)
[PASS] A10-PREFIX: reserved feature prefix = 'SystemTools.CrossPlatform.' (family 'SystemTools.' + independent segment 'CrossPlatform'; 原插件全源码 'CrossPlatform' 零出现 → 与原插件功能 ID 空间不相交，grep 证据见 p0-05 证据文件)

SCHEMA-PARSE-CHECK: PASSED (schema parse ok; id/entrance/version/apiVersion/platforms all bound and independent)
（退出码 0）
```

### 5.3 判别力探针（对源 manifest 的同引擎解析，先行执行）

在定稿新 manifest 前，先用同一工具解析**源** manifest：CamelCase 键绑定实证（`entranceAssembly`/`supportedOSPlatforms`/`apiVersion` 全部命中模型属性）与 `repoOwner/repoName/assetsRoot` 被 `IgnoreUnmatchedProperties` 忽略的实证均出自该探针；断言套件对源 manifest 判 7 项 FAIL（A1–A7）——证明校验具备判别力、非恒真。源 dump（上文 SOURCE-PLUGIN 段）同时成为 §3 逐字段对照的"解析后事实"侧，而非仅 YAML 文本对照。

### 5.4 回放指引（另一复核方）

```powershell
# 工作区根目录执行（dotnet SDK 10.0.x；宿主检出与 DLL 哈希见 §8）
dotnet build .tools\manifest-schema-check\manifest-schema-check.csproj -c Release
.tools\manifest-schema-check\bin\Release\net10.0\manifest-schema-check.exe `
  "src\SystemTools.CrossPlatform\manifest.yml" `
  "E:\My Github Projects\SystemTools\manifest.yml"
# 预期：11 PASS + SCHEMA-PARSE-CHECK: PASSED，退出码 0（对照 §5.2 输出）

# csproj 接线求值（不触发 restore，不写宿主检出）
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:None -nologo
# 预期：manifest.yml 项 CopyToOutputDirectory=Always
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getProperty:CreateCipx -getProperty:AssemblyName -nologo
# 预期：CreateCipx=""（空，未设）；AssemblyName=SystemTools.CrossPlatform
```

### 5.5 验证边界（如实声明）

- 本验证 = **schema 反序列化级**（与宿主 PluginService.cs:68-72/119-123 同构）；**宿主运行时端到端加载**（cipx 安装、插件目录发现、EntranceAssembly 实际装载）留待阶段 4 验收重放（05 合同阶段 4），本阶段不冒充。
- 工具的 A10 为"前缀约定 + 源码零出现"的静态核对；功能注册时刻的前缀门禁（新增源码 grep `SystemTools.` 注册 ID 是否带 `SystemTools.CrossPlatform.` 前缀）属阶段 1–3 的 Justice/礼部验收面。

## 6. csproj manifest 输出接线（p0-06 打包前置）

- 新增 ItemGroup：`<None Update="manifest.yml"><CopyToOutputDirectory>Always</CopyToOutputDirectory></None>`，**形式对齐原插件 SystemTools.csproj:100-102**（原插件同款即被 PluginSdk.targets 的 CreateCipx target 消费：targets:19-21 要求输出目录含 manifest.yml，否则 CISDK0001）。`-getItem:None` 求值实证：manifest.yml 携带 `CopyToOutputDirectory=Always`（§5.4）。
- **未导入 PluginSdk.targets、未设 CreateCipx**（实测 `CreateCipx=""`，§5.4）——打包启用属 p0-06（p0-02 §7 边界事实：`GlobalPropertiesToRemove=CreateCipx` 已阻止该属性流入宿主引用链）。
- p0-04 注释块（csproj 原说明注释）原样保留；仅头注释中"不生成 manifest.yml/cipx"一句更新为本任务后状态（manifest 已接线、CreateCipx 仍未设），并新增接线处注释。
- 打包前置状态：p0-06 设 `CreateCipx=true` 构建 → manifest.yml 必在输出目录（Always 复制）→ CISDK0001 前置满足。

## 7. 原插件与宿主检出零写入证明

- 原插件 `E:\My Github Projects\SystemTools`：本任务仅只读（manifest/Plugin.cs/csproj 读取、grep、Get-FileHash）；manifest SHA256 与 p0-02 §9.1 快照一致（`13A2E178…985`，§4.2）。
- 宿主 `E:\ClassIsland-git-misha`：五链上工程 `obj\project.assets.json` mtime 实测 `PluginSdk 2026-09-01T07:39:08Z`、`Core 2026-09-02T05:11:23Z`、`Platforms.Abstractions/Shared/Shared.IPC 2026-09-01T07:39:07Z` —— 与 p0-04 §7.3 基线逐项相同（本任务 dotnet build/run 仅及 `.tools\` 工具自身 obj/bin，无 ProjectReference 不触宿主）。
- 未遭遇沙箱拒绝；无任何越界写入。

## 8. 版本与哈希锁定（复核基线）

| 对象 | 值 |
| --- | --- |
| 宿主检出快照 | p0-01 §1.2：`2.1.1.1` + commit `a8af81ba37ec1e83588148a400a00a9d8548560d` |
| ClassIsland.Core.dll（Desktop bin） | SHA256 `05CED7D9…1F2A` |
| YamlDotNet.dll（Desktop bin） | SHA256 `86F873F6…DA6`（assembly version 16.0.0.0） |
| CommunityToolkit.Mvvm.dll（Desktop bin） | SHA256 `9084D770…B5F` |
| 复刻转换器源 OSPlatformTypeConverter.cs | SHA256 `6A1D4F9F…8C6` |
| 新 manifest.yml | SHA256 `142CD419…AAC` |
| 新 csproj（接线后） | SHA256 `0797298A…139` |
| 工具链 | dotnet SDK 10.0.302（p0-01 §4 同源）；工具 Program.cs 见 `.tools\manifest-schema-check\` |

## 9. 执行层决定记录（D1–D7，均不触及已审批决议）

| # | 决定 | 依据/理由 |
| --- | --- | --- |
| D1 | `version: 1.0.0.0`（独立版本线） | 05 合同 0.1.4"固化独立 manifest"；独立产品线从首版计数，不复用源 3.0.0.0 |
| D2 | `name: SystemTools 跨平台版` | 独立显示名（R-10 同装可区分原则）；与源显示名不同串 |
| D3 | `readme: ""`（显式空） | 工程内无 README 资产；避免缺省 `README.md` 悬空（宿主消费点 PluginMarketService.cs:458） |
| D4 | `icon: ""`（显式空） | 同 D3（无 icon.png 资产）；资产与字段落值随功能阶段交付 |
| D5 | `url` 留缺（null） | 新插件仓库地址未定；不沿用源 URL 防市场信息误导 |
| D6 | `author: Programmer-MrWang`（沿用） | 信息性字段，真实作者；命名空间区分不依赖此字段 |
| D7 | 功能 ID 前缀 = `SystemTools.CrossPlatform.*`；配置命名空间 = `SystemTools.CrossPlatform.*` 类型 | 与 p0-02 程序集/RootNamespace 一致；与原插件空间不相交（§4.1/§4.2）。**本阶段仅固化约定并记录，不注册任何功能/设置类型（注册属阶段 1–3）** |

## 10. 残余缺口与后续归属

| # | 缺口 | 归属 |
| --- | --- | --- |
| G1 | 宿主运行时端到端加载（cipx 打包 + 宿主装载）未验证 | 阶段 4 验收重放（本阶段为 schema 级验证） |
| G2 | icon/readme 资产与字段落值（当前显式空） | 功能阶段交付资产时更新 |
| G3 | 功能 ID 前缀/配置命名空间的"注册时门禁"（防止阶段 1–3 实际注册时漂移出约定） | 阶段 1–3 验收（各阶段 Justice/礼部面） |
| G4 | 完整同装差异说明文档 | 阶段 3（05 合同阶段表；本文件 §4.3 提供基础对照表） |
