# p0-02 新插件工程脚手架证据（吏部 repository-governance / implementation）

- 案卷：`stcp-cross-platform-001`；阶段 0 / assignment `p0-02`；依赖 `p0-01`（已 succeeded）
- 工作区（唯一写入面）：`E:\My Github Projects\SystemTools-Cross-platform`
- 只读消费：原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha`（U3/CP-0.1）
- 执行环境：Windows，dotnet SDK 10.0.302（对齐宿主 global.json 10.0 / latestFeature）
- 结论：**succeeded**（工程树可列举、三平台 TFM 展开验证通过、未复制 Windows-only 工程属性、原插件与宿主检出零改动）
- 本任务验证下限为"可 restore/工程加载"；三平台实际编译验证属 p0-06（见 §8）

## 1. 实际产出的解决方案/项目文件清单（工作区树）

```
E:\My Github Projects\SystemTools-Cross-platform\
├── .gitignore / LICENSE / README.md / .tang\        （既有，未改动）
├── global.json                                      [新增] SDK 解析：10.0 / latestFeature / allowPrerelease（对齐宿主 global.json）
├── SystemTools-Cross-platform.slnx                  [新增] 解决方案（.NET 10 SDK `dotnet new sln` 默认 slnx 格式；仅含新插件项目）
└── src\
    └── SystemTools.CrossPlatform\
        ├── SystemTools.CrossPlatform.csproj         [新增] 插件工程（AssemblyName/RootNamespace = SystemTools.CrossPlatform）
        └── Plugin.cs                                [新增] 最小可编译插件入口（空注册）
```

- 运行期出现的非本任务写入（发生在工作区内，属允许写入面，如实记录）：
  - `src\SystemTools.CrossPlatform\obj\`（project.assets.json 等）与 `.idea\`（含 `rider.project.restore.info`）：会话期间 **Rider IDE 后台** restore/设计时构建生成，非本任务执行写入；其中 `project.assets.json` 的 targets 键为 `net10.0-windows10.0.19041.0`，**同时构成新工程"可 restore"的下限证据**。
  - `src\SystemTools.CrossPlatform\bin\` 不存在（`--no-dependencies` 编译尝试未产出，见 §8.2）。
- 插件身份映射：解决方案/插件显示身份 `SystemTools-Cross-platform`（连字符为文件系统名）；程序集与命名空间 `SystemTools.CrossPlatform`（合法 C# 标识符）；manifest `id` 独立命名属 p0-05（04-spec R-10），本工程不预写 manifest。
- 解决方案拓扑决议：`dotnet sln add` 默认把引用闭包中的 6 个宿主检出工程也加入了 sln，已全部 `dotnet sln remove` 移除——**解决方案只含新插件表面**，宿主链仅经 ProjectReference 进入（p0-06 的 `dotnet build <sln>` 仍会经引用图构建检出工程，见 §8.3）。

## 2. 创建命令（重放）

```powershell
# 工作区根目录执行
dotnet new sln -n SystemTools-Cross-platform
dotnet sln add "src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj"
# 引用闭包修正：移除被自动带入的宿主检出工程成员（保持解决方案仅含新插件表面）
dotnet sln remove "E:\ClassIsland-git-misha\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj" `
                  "E:\ClassIsland-git-misha\ClassIsland.Core\ClassIsland.Core.csproj" `
                  "E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\ClassIsland.Platforms.Abstractions.csproj" `
                  "E:\ClassIsland-git-misha\ClassIsland.Shared\ClassIsland.Shared.csproj" `
                  "E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\ClassIsland.Shared.IPC.csproj" `
                  "E:\ClassIsland-git-misha\roslyn\IconsMappingGenerator\IconsMappingGenerator.csproj"
dotnet sln list   # 预期仅剩 src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj
```

csproj 与 Plugin.cs 为按获批边界手写（未用模板；参照原插件 `SystemTools.csproj:10-12,161-167` 的 UseLocalClassIslandSdk 本地引用先例与宿主 `ClassIsland.ExamplePlugin` 的最小入口形态）。

## 3. TFM 与宿主 CrossPlatformProps 接入记录

**机制（对齐宿主 `ClassIsland.Desktop.csproj:7/:128`）**：工程内仅声明 `<BaseFramework>net10.0</BaseFramework>`（不硬编码任何平台 TFM），`<Import Project="$(ClassIslandSourceRoot)\CrossPlatformProps.props" />`（`ClassIslandSourceRoot` 默认 `E:\ClassIsland-git-misha`）；平台展开、`Platforms_*` 编译常量、发布切换（`PublishBuilding/PublishPlatform` 或开发机 OS 探测）全部由宿主 props 提供。

**三平台 TFM 展开验证**（免写入求值；命令与实测结果）：

| 场景 | 命令要点 | 实测 TargetFramework | DefineConstants |
| --- | --- | --- | --- |
| 开发机默认（本机 Windows） | `dotnet msbuild <csproj> -t:PrintPlatformInfo` | `net10.0-windows10.0.19041.0`（Os_IsWindows=True 自动探测） | `TRACE;Platforms_Windows;DEBUG` |
| 发布 windows | `-p:PublishBuilding=true -p:PublishPlatform=windows` | `net10.0-windows10.0.19041.0` | `TRACE;Platforms_Windows;DEBUG` |
| 发布 linux | `-p:PublishBuilding=true -p:PublishPlatform=linux` | `net10.0`（无后缀） | `TRACE;Platforms_Linux;DEBUG` |
| 发布 macos | `-p:PublishBuilding=true -p:PublishPlatform=macos` | `net10.0-macos26.5` | `TRACE;Platforms_MacOs;DEBUG` |

与 p0-01 基线 §4（宿主 CrossPlatformProps 展开：Windows `$(BaseFramework)-windows10.0.19041.0`、macOS `$(BaseFramework)-macos26.5`、Linux 无后缀+`Platforms_Linux`）逐项一致。宿主 props 的 `PrintPlatformInfo` 目标随导入带入，p0-06 构建时将自动打印实际 TFM。

**工程级显式属性**（均为跨平台通项，非 Windows-only）：`Nullable=enable`、`ImplicitUsings=enable`、`LangVersion=latest`、`EnableDynamicLoading=true`（插件动态加载，对齐原插件 csproj:8 与宿主 ExamplePlugin）、`EnableWindowsTargeting=true`（非 Windows 构建机交叉编译 Windows TFM 所需；宿主侧由其 Global.props:7 提供，本工程不导入 Global.props 故显式声明）。

**exe 级属性清除**：宿主 props 在 Windows 分支设置 `ApplicationManifest=app.manifest`、`ApplicationIcon=Assets\AppLogo.ico`（面向宿主 exe）；插件为类库（OutputType=Library），在导入后显式置空这两项。本工程**不创建** app.manifest/图标等 Windows 资源文件。

## 4. 引用来源记录（CP-0.1）

```xml
<ProjectReference Include="$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj">
  <ReferenceOutputAssembly>true</ReferenceOutputAssembly>
  <Private>false</Private>                      <!-- 宿主运行时自带 SDK 程序集，插件输出不复制宿主 DLL（对齐原插件 csproj:162-166） -->
  <GlobalPropertiesToRemove>CreateCipx</GlobalPropertiesToRemove>
</ProjectReference>
```

- PluginSdk 经其自身 ProjectReference 聚合完整链：Core → Platforms.Abstractions / Shared / Shared.IPC（`ClassIsland.Core.csproj:36-38`），Platforms.Abstractions 无需单独引用即处于传递闭包内。
- **无 NuGet 发布包后备**：与原插件 csproj:42-45 不同，本工程不设 `ClassIsland.PluginSdk` PackageReference 条件分支；检出缺失时 `VerifyClassIslandSource` 目标（BeforeTargets=PrepareForBuild）直接报错，引用解析只会来自 U3 指定检出。
- 版本记录：消费的检出为 p0-01 记录的 `2.1.1.1`（提交 `a8af81ba37ec1e83588148a400a00a9d8548560d`）快照；本次消费的 7 个检出文件 SHA256 见 §9.2（前后一致）。

## 5. 最小可编译插件入口（空注册）

`src\SystemTools.CrossPlatform\Plugin.cs`：`[PluginEntrance] public class Plugin : PluginBase`，`Initialize(HostBuilderContext, IServiceCollection)` 为**空方法体**——不注册任何功能、服务、主题、行动（05 合同 0.4）。入口形态依据：`PluginBase` 唯一抽象成员即 `Initialize`（`ClassIsland.Core\Abstractions\PluginBase.cs:29`）；`[PluginEntrance]` 定义于 `ClassIsland.Core\Attributes\PluginEntrance.cs:8`；同形态先例为宿主 `ClassIsland.ExamplePlugin\Plugin.cs:10-17` 与原插件 `Plugin.cs:47`。

## 6. 与原插件工程属性对照（未复制 Windows-only 属性证明）

| 原插件 `SystemTools.csproj`（Windows-only 项） | 原值/位置 | 新工程 | 判定 |
| --- | --- | --- | --- |
| 硬编码平台 TFM | `net10.0-windows10.0.19041.0`（:3） | `BaseFramework=net10.0` + 宿主 props 三平台展开 | 未复制 ✅ |
| WinForms | `UseWindowsForms=true`（:6） | 未设置（实测求值 = 空） | 未复制 ✅ |
| 单平台架构限定 | `Platforms=x64`（:7） | 未设置（实测求值 = 默认 `AnyCPU`） | 未复制 ✅ |
| Windows 打包 | `CreateCipx=true`（:9） | 未设置（实测求值 = 空；见 §7） | 未复制 ✅ |
| Windows 资源文件 | `Themes\*.png`、`.bat/.ps1`、app 资源等（:31-38,100-138） | 无任何资源项 | 未复制 ✅ |
| C 档产品包 | DlibDotNet/OpenCvSharp4*/System.Management/System.Speech/CsWin32（:46-56） | 无任何 PackageReference（S4.2 禁用包零引入；包引用细化属 p0-04） | 未复制 ✅ |
| VoskWorker/宿主依赖剥离等 Windows 构建目标 | :65-97 | 无 | 未复制 ✅ |

（原插件非 Windows-only 项 `EnableDynamicLoading=true` 按插件通用需要保留，已在 §3 记录。）

## 7. manifest/cipx 边界事实（供 p0-05/p0-06 引用）

- 本工程**未设** `CreateCipx`，故 PluginSdk.targets 的 `CreateCipx` 目标（条件 `'$(CreateCipx)'=='true'`，`ClassIsland.PluginSdk.targets:7-9`）不会触发，其 `CISDK0001`（输出目录缺 manifest.yml 报错，:19-21）**不会被评估**；该 targets 仅在 CreateCipx=true 的打包构建中生效（本工程也未 import 该 targets 文件——原插件经 csproj:169-170 导入，本工程不需要）。
- p0-05 落地 manifest.yml 后，p0-06 设 `CreateCipx=true` 即启用打包；`GlobalPropertiesToRemove=CreateCipx`（本工程 :4 项）将阻止该属性流入被引用的宿主工程。

## 8. 验证结果与边界内限制

### 8.1 通过项（免检出写入）

1. **工程树可列举**：§1；`dotnet sln list` 仅含新插件项目。
2. **工程加载/求值干净**：默认与三平台强制场景的 `dotnet msbuild -t:PrintPlatformInfo` / `-getProperty` / `-getItem:Compile` 全部成功、无错误无警告；Compile 项实测仅 `Plugin.cs`（无 A/B/C 源码混入）。
3. **三平台 TFM 展开**：§3 表，与宿主基线一致。
4. **可 restore 下限**：新工程 `obj\project.assets.json` 存在且 targets 键为 `net10.0-windows10.0.19041.0`（Rider 后台生成，见 §1 注记）。
5. **未复制 Windows-only 属性**：§6 对照表。

### 8.2 未做项（边界内限制，如实记录）

- **未做三平台/本机实际编译**：任务注明编译验证属 p0-06。本任务曾尝试零检出写入的单工程编译 `dotnet build <csproj> --no-restore --no-dependencies`，结果失败：`error NU1105: Unable to find project information for '...\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj'`（该引用结构下跳过依赖构建时 MSBuild 无法解析检出工程信息）。失败尝试仅在本工作区 obj 留有缓存，未触发任何检出写入（§9.2 复核为证）。
- **未运行完整 restore**：`dotnet restore/build` 会把恢复图写入宿主检出的 `obj\project.assets.json`（超出本任务"写入仅限工作区+证据"边界），故不做；新工程自身的 restore 有效性由 §8.1-4 资产佐证。

### 8.3 p0-06 可重放命令（届时宿主检出的 obj/bin 写入属该阶段构建面）

```powershell
dotnet build .\SystemTools-Cross-platform.slnx -c Release          # 05 合同 0.5.1 标准入口（引用图含检出工程）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release
# 平台强制场景：追加 -p:PublishBuilding=true -p:PublishPlatform=windows|linux|macos
dotnet list src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj package   # 包图门禁（CP-0.2，属 p0-04/p0-06）
```

## 9. 原插件与宿主检出零改动证明（供 p0-07 隔离检查引用）

### 9.1 原插件 `E:\My Github Projects\SystemTools`

- 快照方式：工作前/后各一次全树清单（相对路径|字节数|LastWriteTimeUtc，排除 `.git`），存于本案 evidence：
  - `.tang/cases/stcp-cross-platform-001/evidence/p0-02-original-plugin-snapshot-before.txt`（736 行）
  - `.tang/cases/stcp-cross-platform-001/evidence/p0-02-original-plugin-snapshot-after.txt`（736 行）
- **清单逐行对比：无差异（NO DIFFERENCES）**。
- git 佐证：HEAD `0f92d1d4b8cd9a0aa9bc79d9d5e16884fb19eeed`（main，"proj: 构建修复之四"，2026-09-02）；`git status --porcelain` 工作前/后同为且仅为**既有外部改动**（非本阶段产生，CP-0.5 说明）：` M .idea/.idea.SystemTools/.idea/workspace.xml`、`?? .tang/`。
- 关键文件 SHA256 前后一致：`SystemTools.csproj = E5932355…2F8`、`manifest.yml = 13A2E178…985`、`Plugin.cs = 72751F10…E`（完整值记录于快照生成输出；重放命令 `Get-FileHash`）。
- 本任务对原插件目录执行的**全部**操作均为只读读取（git status、Get-ChildItem、Get-FileHash、读 SystemTools.csproj/Plugin.cs）。

### 9.2 宿主检出 `E:\ClassIsland-git-misha`

- 被消费 7 文件 SHA256 工作前/后一致：`CrossPlatformProps.props`、`Global.props`、`global.json`、`ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj`、`ClassIsland.PluginSdk\ClassIsland.PluginSdk.targets`、`ClassIsland.Core\ClassIsland.Core.csproj`、`ClassIsland.Platforms.Abstractions\ClassIsland.Platforms.Abstractions.csproj`。
- 链上 5 工程 `obj\project.assets.json` mtime 工作前/后一致（2026-09-01~09-02 原值），证明本任务（含失败的 --no-dependencies 尝试）**从未触发**对检出的 restore/build 写入。

## 10. 回滚（对应 05 合同 0.7）

删除本任务新增的 3 个工程文件 + slnx + `src\` 目录（及 IDE 后台产物 bin/obj/.idea）即完全回滚；原 `SystemTools` 与宿主检出不受任何影响（§9）。

## 11. 修订 R1（2026-09-03）：OutputType=Library 修复（p0-06 发现缺陷，仍属 p0-02 脚手架责任面）

### 11.1 缺陷来源与机制

- 来源：工部 p0-06 构建基线报告（`.tang/cases/stcp-cross-platform-001/evidence/p0-06-build-baseline.md` §4.2/§7，缺陷 G2）；尚书省修订指令下达本任务修复。
- 机制：宿主 `CrossPlatformProps.props:46-48` 在 Windows Release/Release_MSIX 分支注入 `<OutputType>WinExe</OutputType>`（该 props 面向宿主 exe 设计）；插件类库无 `Main`，Windows Release 构建必现 CS5001。
- 本工程 csproj 在导入 props 后原仅清除同组的 exe 级产物属性 `ApplicationManifest`/`ApplicationIcon`（§3"exe 级属性清除"），遗漏了同源注入的 `OutputType`。

### 11.2 修复内容

`src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` 文件尾"导入后清除 exe 级属性"PropertyGroup 内新增 `<OutputType>Library</OutputType>`（与 ApplicationManifest/ApplicationIcon 同组、同注释块），缘由注释已注明：CrossPlatformProps:46-48 WinExe 面向宿主 exe、插件为类库、对齐同组属性清除先例；`Library` 为本工程各配置的 SDK 默认值，仅覆盖宿主 props 对 Windows Release 分支的注入。**p0-04 双形态引用与 p0-05 manifest 接线全部保留未动**（编辑前已通读 csproj 全文核对）。

### 11.3 求值核验（免写入：`dotnet msbuild -getProperty`，未触发 restore、未写宿主检出）

| 场景 | 修复前 | 修复后 |
| --- | --- | --- |
| `-p:Configuration=Release`（开发机默认=Windows） | **WinExe**（缺陷复现） | **Library** ✅ |
| `-p:Configuration=Release_MSIX`（开发机默认） | （未单测，同 props 条件分支） | Library ✅ |
| `-p:Configuration=Debug`（开发机默认） | Library | Library（不变）✅ |
| Release + PublishPlatform=windows | （同 WinExe 分支） | Library ✅ |
| Release + PublishPlatform=linux | Library | Library（不变）✅ |
| Release + PublishPlatform=macos | Library | Library（不变）✅ |

### 11.4 回归复核

- `-getItem:PackageReference`（默认模式）仍为 **0 项**（p0-04 双形态后备分支条件为假，未受影响）。
- `-getItem:None` 仍含 `manifest.yml`（p0-05 输出接线完好）。
- TFM 展开抽查不变：默认 `net10.0-windows10.0.19041.0`、macos `net10.0-macos26.5`。
- 宿主检出链上 5 工程 `obj\project.assets.json` mtime 仍为 2026-09-01~09-02 原值（零写入复核通过）。

### 11.5 后续

编译级复验（Windows Release 实际构建不再报 CS5001）由工部 p0-06 另行执行，本任务按指令不跑 build。
