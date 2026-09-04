# p1-07 证据：阶段 1 依赖面核对与产物预算（户部 data-dependencies / verification）

- 案卷：`stcp-cross-platform-001`；阶段 1 / assignment `p1-07`；依赖 p1-01..p1-06（均 succeeded）
- 权威输入：`evidence/p0-04-dependency-baseline.md`（§10 双形态基线）；`evidence/p1-01-war-themes-components.md`（§2/§6.2 接线登记）；`evidence/p1-06-rites-registration-settings.md`（§6-9：AI 页/设置页消费面与报备）；`evidence/p0-06-build-baseline.md`（§5/§6/§8 bin 基线）
- 工作区（唯一写入面）：`.tang/cases/stcp-cross-platform-001/evidence/p1-07-revenue-dependency-check.md`（本文件）；产品文件零改动
- 只读消费：`src\SystemTools.CrossPlatform` 全树；宿主检出 `E:\ClassIsland-git-misha`；原插件 `E:\My Github Projects\SystemTools`；NuGet 缓存 `C:\Users\0\.nuget\packages`
- 结论：**succeeded** —— 默认/后备双形态求值结论与 p0-04 §10 完全一致（零直接 PackageReference 形态不变）；FluentAvaloniaUI / CommunityToolkit.Mvvm / Markdown.Avalonia（宿主 fork） / Avalonia 12.1.1 全部在真实消费面经宿主链传递可达、无需新增声明；新增依赖扫描 **未授权新增包 = 0**；接线差距 = p1-01 §6.2 登记的 6 项 AvaloniaResource 仍待接线（工程面，W5 裁决归属，预期 p1-10 前落地）。

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| 双形态求值 | csproj 字节状态 = p0-04 §10.3 终态（阶段 1 零触碰，mtime 2026-09-03T15:37:37Z）；默认模式 PackageReference=空、后备模式 PackageReference=ClassIsland.PluginSdk 2.1.1.1（ExcludeAssets=runtime;native）、ProjectReference 互为对偶 —— **与 p0-04 §10.4 实测逐项一致，结论不变**（本会话无法重放 dotnet 子进程，见 §1/§2） |
| 传递可达（真实消费面） | FAUI 3.0.0（Core.csproj:72）✓；CommunityToolkit.Mvvm 8.2.1（Shared.csproj:21，经 PluginSdk→Core→Shared）✓ 含生成器先例；Markdown.Avalonia = 宿主 fork `ClassIsland.Markdown.Avalonia 12.0.0`（Core.csproj:47，namespace 仍 `Markdown.Avalonia`）✓；Avalonia 12.1.1（Core.csproj:68-73）✓；M.E.DI/Hosting 10.0.10 与 Logging ✓ —— 全部以宿主链解析闭包 + 原插件同构闭包双重实证（§3） |
| 新增依赖扫描 | using 面全集映射入闭包/Bcl；S4.2 禁用包全树零命中；`#if` 平台分叉 0；DllImport 0；`using Markdown.*` 于 .cs 0（仅 AXAML xmlns）；**需新增 PackageReference 的依赖 = 0，未授权新增包 = 0**（§4） |
| 产物预算 | 当前 bin = 2026-09-03 p0-06 时代旧产物（实测清单与体积 §5）；阶段 1 净增 149 个产品文件 + Plugin.cs 重写；体积对比结论**如实 defer** 至 p1-10 新构建后补记（§5.3） |
| 接线需求差距 | csproj 当前零 AvaloniaResource；p1-01 §6.2 登记 6 项（3×Theme.axaml.txt + 3×PNG）全部仍待接线；相关工程面事实（Avalonia buildTransitive 自动收集 axaml 的结构依据）登记于 §6，供 W5 裁决接线归属（预期 p1-10 前一次 csproj 接线，属工程面改动） |

---

## 1. 执行环境与沙箱边界（如实记录）

- 本会话沙箱禁止 `dotnet.exe`/`git.exe` 子进程启动：启动即报命名管道访问拒绝（`Access to the path '\\.\pipe\LOCAL\dotnet_…' is denied`，与 p1-02/p1-06 §7「沙箱禁止 .NET 子进程」报告同源边界；git 亦同因被拒）。已按派工边界改用**只读等价证据**，不做绕过。
- 全部核对以 PowerShell 只读 cmdlet + 文件内容检索完成；产品树、宿主检出、原插件、NuGet 缓存全程只读。
- 宿主检出零写入证明：链上 5 工程 `obj\project.assets.json` mtime 快照 = `PluginSdk 2026-09-01T07:39:08Z`、`Core 2026-09-02T05:11:23Z`、`Platforms.Abstractions/Shared/Shared.IPC 2026-09-01T07:39:07Z`，与 p0-06 §8/p0-04 §7.3 基线记录**逐字节一致** —— 阶段 1 与本核对均未写宿主。

## 2. 双形态求值核对（任务 1）

**csproj 状态（默认/后备分支的定义面）**：`src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj`（9112 B，LastWriteTimeUtc 2026-09-03T15:37:37Z —— 阶段 0 末态，阶段 1 零触碰；p1-01 §6.2 登记、p1-06 §10「零改动：csproj」相互印证）。文件全文复核：

- 属性：`UseLocalClassIslandSdk` 缺省 `true`（csproj:38）、`ClassIslandPluginSdkVersion` 缺省 `2.1.1.1`（:39）—— 与 p0-04 §10.2/§10.3 一致。
- 默认分支 ItemGroup `Condition="'$(UseLocalClassIslandSdk)' != 'false'"`（:45-54）：唯一引用 = ProjectReference → `$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj`（ReferenceOutputAssembly=true / Private=false / GlobalPropertiesToRemove=CreateCipx）。
- 后备分支 ItemGroup `Condition="'$(UseLocalClassIslandSdk)' == 'false'"`（:56-66）：PackageReference `ClassIsland.PluginSdk` Version=`$(ClassIslandPluginSdkVersion)`（ExcludeAssets=runtime;native）。
- 文件内无其他任何 PackageReference 元素；`VerifyClassIslandSource` 目标（:95-98）保证检出缺失不回退 NuGet（CP-0.1）。

**静态条件求值（不触发 restore；重放命令记录于 §7）**：

| 场景 | 求值结果 | p0-04 §10.4 实测 | 一致性 |
| --- | --- | --- | --- |
| 默认（无属性/`=true`）PackageReference | `[]` | `[]` | ✓ |
| 后备 `-p:UseLocalClassIslandSdk=false` PackageReference | ClassIsland.PluginSdk / 2.1.1.1 / ExcludeAssets=runtime;native | 同 | ✓ |
| 默认 ProjectReference | 检出 PluginSdk csproj（E:\ClassIsland-git-misha…） | 同 | ✓ |
| 后备 ProjectReference | `[]` | 同 | ✓ |

**结论**：两分支条件是属性值上的严格互斥对偶，csproj 文件体与 p0-04 §10.4 实测时的求值面**逐字节相同** ⇒ 双形态求值结论 = **零直接 PackageReference（默认）+ NuGet 后备 2.1.1.1（显式关闭本地 SDK 时）**，与 p0-04 §10 结论**完全一致、无差异**。后备分支真实 NuGet 解析仍属发布面（阶段 4）核验，本阶段不执行（p0-04 §10.4 同判；本会话 obj 内既有的一次后备解析闭包见 §3.5，仅作佐证）。

## 3. 传递可达性核对（任务 2 —— 对真实消费面）

**拓扑**：新插件 →（PR）PluginSdk →（PR）Core → {Platforms.Abstractions, Shared, Shared.IPC}（p0-02 §4）。Core/Shared 的 PackageReference 均无 PrivateAssets（Core.csproj:47/68-73 平声明；Shared.csproj:21 平声明；仅 CsWin32 Core.csproj:49-50 与 Grpc.Tools Shared.csproj:25-26 为 PrivateAssets=all 私有工具，不外流）⇒ 包面（含 buildTransitive 资产）经链流达插件编译。

### 3.1 FluentAvaloniaUI 3.0.0 —— ✓ 可达

- 真实消费面：`.cs` 6 文件 `using FluentAvalonia.UI.Controls`（ActionFlowExecutionConfirmationAction、AiChatFloatingWindow.axaml.cs 等）；`.axaml` 10+ 文件 `xmlns:controls="clr-namespace:FluentAvalonia.UI.Controls;assembly=FluentAvalonia"`（FASettingsExpander、FAContentDialog、FATaskDialog 使用点）。
- 链证据：Core.csproj:72 平声明 `FluentAvaloniaUI 3.0.0`；Core 解析闭包含 `FluentAvaloniaUI/3.0.0`；原插件（同构拓扑，零直接 FA 声明）解析闭包含 `FluentAvaloniaUI/3.0.0` —— 插件级编译可达实证。
- 与 p0-04 §3.3/§4 一致：保持传递消费，**不显式引入**（显式引入曾致 Avalonia 12.0.0 降级 NU1605，已回退，csproj:81-83 留痕）。

### 3.2 CommunityToolkit.Mvvm 8.2.1 —— ✓ 可达（含源生成器先例）

- 真实消费面：13 文件 `using CommunityToolkit.Mvvm.ComponentModel`（ObservableObject 等，Models\ComponentSettings 6、Config、ConfigHandlers、SettingsPage ViewModel 2 等）。
- 链证据：**Shared.csproj:21** 平声明 `CommunityToolkit.Mvvm 8.2.1`（链内节点 Core→Shared）；Core 解析闭包含 `CommunityToolkit.Mvvm/8.2.1`；原插件解析闭包含 `CommunityToolkit.Mvvm/8.2.1`。
- 生成器先例（关键工程面事实）：原插件 23 文件使用 Mvvm、152 处 `[ObservableProperty]`/partial 形态，且其 `bin\Debug\net10.0-windows10.0.19041.0\SystemTools.dll` 实测在位 ⇒ 同拓扑（仅 ProjectReference 本地 PluginSdk）下 Mvvm **源生成器在插件构建期可用**已有实证；新插件 `[ObservableProperty]` 用法（p1-06 §7-6 Roslyn 编译诊断的「生成器未接线预期噪声」）在真实构建（p1-10）消除。无需直接 PackageReference。

### 3.3 Markdown.Avalonia —— ✓ 可达（事实更正：宿主 fork `ClassIsland.Markdown.Avalonia 12.0.0`）

- 真实消费面：`SettingsPage\AboutSettingsPage.axaml:7,139-147` 与 `Views\AiChatFloatingWindow.axaml:7,267-268` —— `xmlns:mdxaml="https://github.com/whistyun/Markdown.Avalonia"` + `<mdxaml:MarkdownScrollViewer Engine="{x:Static helpers:MarkdownConvertHelper.Engine}" …>`；`.cs` 中零 `using Markdown.*`（纯 AXAML 消费）。
- **事实更正/精化**（不推翻任何基线，p0-04 未涉及 Markdown）：宿主链上可解析的包是 **`ClassIsland.Markdown.Avalonia 12.0.0`**（Core.csproj:47 平声明；fork 保持上游 whistyun 的 **`Markdown.Avalonia` 命名空间与 xmlns URI**）。Core 解析闭包含 `ClassIsland.Markdown.Avalonia/12.0.0` + Html/Svg/SyntaxHigh/Tight 4 子包；原插件闭包同含 ⇒ 插件经 Core 传递编译可达。
- 宿主同构先例：宿主 app 自身页面（`ClassIsland\Views\SettingPages\PluginsSettingsPage.axaml:19,239-247`、`UpdateSettingsPage.axaml:11,65-72`、`DevPortalWindow.axaml:10,192-198`）使用**完全相同的 mdxaml URI + MarkdownConvertHelper.Engine 形态**编译通过 —— xmlns URI→fork 程序集映射的宿主级实证。
- `MarkdownConvertHelper` 为宿主 Core 类型：`ClassIsland.Core\Helpers\MarkdownConvertHelper.cs:14`（public static，`Engine` 属性类型 = fork 的 `Markdown.Avalonia.Markdown`）⇒ 插件的 `x:Static` 引用经 Core 程序集 + fork 程序集两者都在编译闭包内解析。无需直接 PackageReference。

### 3.4 Avalonia 12.1.1（全 UI 面）与 M.E.* / BCL —— ✓ 可达

- Avalonia：Core.csproj:68-73（Avalonia / Desktop / Skia / Controls.ColorPicker 12.1.1 + Labs.CommandManager 12.0.2）；Core 闭包 12.1.1；新插件 38 .cs `using Avalonia.*` + 27 .axaml 全量依赖。与 p0-04 §3.1 宿主基线一致。
- M.E.DI/Hosting 10.0.10：Core.csproj:61-63 平声明，Core/原插件闭包含 `Microsoft.Extensions.DependencyInjection(-.Abstractions)?/Hosting…/10.0.10`（p0-04 §3.2 结论不变）；新插件 `using Microsoft.Extensions.DependencyInjection/Hosting`（Plugin.cs、Services）可达。`Microsoft.Extensions.Logging` 属共享框架 + 宿主 Host 注册（p1-06 §9-1 AddLogging 核减留痕），BCL 面。
- `System.Net.Http[.Headers|.Json]`、`System.Net.NetworkInformation`（OpenAiCompatibleService、NetworkStatusComponent、AiChatSettingsViewModel 等）：.NET 10 共享框架 in-box，非包依赖。
- `ClassIsland.Platforms.Abstraction[.Models|.Services]`：链内 Platforms.Abstractions（p0-02 §4），5 文件使用（VersionCheckService、FullscreenClock 等）。

### 3.5 佐证：本工程 obj 现存解析闭包（只读，非权威）

`src\SystemTools.CrossPlatform\obj\project.assets.json`（mtime 2026-09-03T15:40:38Z —— p0-06 §4 后备分支 Linux 实验的 restore 残留；targets 键 `net10.0`、libraries=104）解析到 `ClassIsland.PluginSdk/2.1.1.1`、`FluentAvaloniaUI/3.0.0`、`CommunityToolkit.Mvvm/8.2.1`、`ClassIsland.Markdown.Avalonia/12.0.0`、`Avalonia/12.1.1` —— 后备分支对全部消费面包亦自足（真实后备 Windows/发布解析仍归阶段 4）。p0-04 §2 记载的旧「libraries=0 设计时快照」已被该实验闭包覆盖，仍非默认模式权威闭包；默认模式完整 restore 首跑在 p1-10。

## 4. 新增依赖扫描（任务 3）

**方法**：全树（114 .cs + 27 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj，排除 obj/bin）using 面/命名空间聚合 + 目标语料检索；命令可重放（§7）。

1. **using 面全集分类**（114 .cs 顶层命名空间聚合 + 定向展开，命中文件数）：

   | 使用面 | 归属 | 是否需要新增 PackageReference |
   | --- | --- | --- |
   | `Avalonia.*`（Controls 38、Media 16、Threading 15、…） | Core 链传递（12.1.1） | 否 |
   | `FluentAvalonia.UI.*`（6） | Core 链传递（3.0.0） | 否 |
   | `CommunityToolkit.Mvvm.*`（13） | Shared 链传递（8.2.1） | 否 |
   | `Markdown.*` | .cs 零命中；AXAML xmlns 指向 fork（3.3） | 否 |
   | `ClassIsland.Core/Shared/Platforms.*`（~190） | PluginSdk 链 | 否 |
   | `Microsoft.Extensions.{DependencyInjection,Hosting,Logging}`（23） | Core 链 + 共享框架 | 否 |
   | `System.*` / `System.Collections/ComponentModel/Diagnostics/IO/Linq/Net/Reflection/Text/Threading…` | .NET 10 共享框架 BCL | 否 |

2. **S4.2 禁用包/风险语料全树检索**（`System.Management|System.Speech|DlibDotNet|OpenCvSharp|NAudio|Vosk|CsWin32|Windows.Win32|RegistryKey`）：**零命中**（p1-06 §7-1 全树终态复跑 GateHits=0 一致）。
3. **宿主基础设施包零使用面**：Core/Shared 链上的 AsyncImageLoader.Avalonia、CompositionMaterial.Avalonia、MoonSharp、Lib.Harmony.Thin、Octokit、ReactiveUI、SmoothScroll.Avalonia、SoundFlow、Xaml.Behaviors、YamlDotNet、Avalonia.Labs、CsesSharp/Google.Protobuf/Grpc* —— 语料检索全树**零命中**（插件未消费，随链存在不构成插件依赖）。
4. **平台符号**：`#if` 平台分叉 = 0；`DllImport` = 0；`OperatingSystem.IsWindows()` 2 处（`Actions\BackgroundPlayAudioAction.cs:87`、`Controls\BackgroundPlayAudioSettingsControl.cs:149`）均为**运行时守卫**（Windows 盘符路径归一化回退），非编译期分叉、非包依赖（随源行为）。
5. **结论**：全部消费符号映射入宿主链闭包或 .NET 共享框架；**需新增 PackageReference 才能编译的依赖 = 0；未授权新增包 = 0**。若 p1-10 真实构建出现 XAML/生成器解析错误，根因只能是工程接线面（§6）而非包引用面 —— 报告路径已指明。

## 5. 产物预算登记（任务 4）

### 5.1 bin 现状（阶段 1 前实测基线，2026-09-03 p0-06 时代旧产物）

| 目录 | 文件 | 字节 |
| --- | --- | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | SystemTools.CrossPlatform.dll（5120，1.0.0.0）· .pdb（20688）· .deps.json（1129）· .runtimeconfig.json（554）· manifest.yml（1430）· **Microsoft.Windows.SDK.NET.dll（24,877,600）** · **WinRT.Runtime.dll（528,944）** | ≈ 25.44 MB |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll（5120）· .pdb（17772）· .deps.json（469）· .runtimeconfig.json（377）· manifest.yml（1430） | ≈ 25.2 KB |

- 口径警示（避免失实比较）：Windows 目录的 Microsoft.Windows.SDK.NET.dll / WinRT.Runtime.dll（2024-11-11 包内 mtime）为 **p0-06 §4 NuGet 后备分支实验的运行时复制残留**，非默认本地检出形态插件产物（默认形态 Private=false / ExcludeAssets=runtime;native，宿主自带 SDK 程序集，不复制宿主 DLL）⇒ 该 24.8 MB 项**不代表默认形态基线体积**，登记为实验残留，不作预算项。
- 插件 DLL 5120 B = 阶段 0 空注册最小编译产物（p0-06 §6：文件版本 1.0.0.0 / 1.0.0+ff0ffd7…）。

### 5.2 阶段 1 预期增量登记（实测面）

- 阶段 0 src 基线文件集 = 3（csproj、Plugin.cs、manifest.yml；manifest 为 p0-05 落地）。当前 src 产品树（排除 obj/bin）= **152 文件**：114 .cs、27 .axaml、4 .yml（根 manifest + 3 主题 manifest）、3 .png、3 .txt、1 .csproj ⇒ **阶段 1 净增 149 个产品文件**（A 档 33 项 + 附属），另 `Plugin.cs` 重写为唯一注册面（24,415 B，mtime 2026-09-03T18:21:31Z；p1-06 交付）。
- 资产输入面（将进入程序集资源/编译流）：27 .axaml（XAML 编译）+ 3 `Theme.axaml.txt` + 3 PNG（`Themes\ClassWidgets\上课.png / 课间休息.png / 无课程.png`，实测在位）—— 其中 6 项（3 txt + 3 png）尚无 AvaloniaResource 接线（§6）；根 `manifest.yml` SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`，与 p0-05/p1-06 §8 基线字节一致（未变）。
- **体积对比**：按派工边界**不作失实测量** —— 实测对比标注「**待 p1-10 新构建后补记**」（届时：插件 DLL 由 5120 B 空壳增至含 27 编译 XAML + 114 类 + 资源流的真实体积；bin 目录以默认本地检出形态输出为准，WinRT 实验残留由 p1-10 输出覆盖）。

## 6. 接线需求状态汇总（任务 5 —— 供 W5 裁决接线归属）

csproj 当前 **零 AvaloniaResource / 零显式 AvaloniaXaml**（全文复核；阶段 1 零触碰，p1-06 §10 同证）。与 p1-01 §6.2 登记的差距清单（6 项，全部仍待接线）：

| # | 待接线目标 | 期望形态（源 SystemTools.csproj:31-36 先例） | 消费锚点（运行期） | 状态 |
| --- | --- | --- | --- | --- |
| 1 | `Themes\CardTypeComponent\Theme.axaml.txt` | `<AvaloniaResource Include=…/>` | CardTypeComponentStyles.cs:13（AssetLoader.Open avares） | 未接线 |
| 2 | `Themes\ClassWidgets\Theme.axaml.txt` | 〃 | ClassWidgetsStyles.cs:14 | 未接线 |
| 3 | `Themes\NotchStyle\Theme.axaml.txt` | 〃 | NotchStyleStyles.cs:13 | 未接线 |
| 4 | `Themes\ClassWidgets\上课.png` | 〃 | ClassWidgetsCard.axaml:38 | 未接线 |
| 5 | `Themes\ClassWidgets\课间休息.png` | 〃 | ClassWidgetsCard.axaml:53 | 未接线 |
| 6 | `Themes\ClassWidgets\无课程.png` | 〃 | ClassWidgetsCard.axaml:68 | 未接线 |

相关工程面事实（登记供裁决，非本域判定）：
- Avalonia 12.1.1 包含 `buildTransitive\Avalonia.props`，内含 `EnableDefaultItems==True` 时 `<AvaloniaXaml Include="**\*.axaml" …/>` 默认收集（NuGet 缓存实测）⇒ 27 个 .axaml 的 AvaloniaXaml 收集主张（p1-01 §6.2 ①）**有结构依据**，但阶段 0 各次构建（p0-06）均在 0 axaml 状态下完成，**XAML 编译首跑在 p1-10**；若该收集在真实构建未生效，差距将扩大为 axaml 显式接线面（届时按 p1-10 实测修正本登记）。
- 3 txt + 3 png 不在 Avalonia 默认收集面（仅 .axaml/.xaml），必须 AvaloniaResource 显式接线，否则 `AssetLoader.Open("avares://SystemTools.CrossPlatform/…")` 与位图 URI 运行期解析失败（编译不受影响）。
- 归属：属**工程面（csproj）改动**，按尚书省 W5 裁决接线归属；预期 p1-10 前执行一次 csproj 接线（工部 infra-release 域）。本批（户部 verification）不代批、不改产品文件。

## 7. 复核指引与命令重放

```powershell
# A. 双形态求值（需允许 dotnet 子进程的会话；本会话沙箱拒绝，见 §1 —— 结果为 p0-04 §10.4 实测 + csproj 字节同一性推得）
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -nologo                                   # => []
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -p:UseLocalClassIslandSdk=false -nologo  # => ClassIsland.PluginSdk 2.1.1.1 ExcludeAssets=runtime;native
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:ProjectReference -nologo                                   # => 检出 PluginSdk
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:ProjectReference -p:UseLocalClassIslandSdk=false -nologo  # => []
# B. 宿主链/原插件解析闭包（只读）
Get-Content 'E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json' -Raw       # FAUI 3.0.0 / Mvvm 8.2.1 / fork 12.0.0 / Avalonia 12.1.1
Get-Content 'E:\My Github Projects\SystemTools\obj\project.assets.json' -Raw               # 同构拓扑插件级可达实证
# C. 本工程现 obj 闭包（后备 Linux 实验残留，佐证）
Get-Content 'src\SystemTools.CrossPlatform\obj\project.assets.json' -Raw                  # PluginSdk 2.1.1.1 + 全消费面包
# D. using 面聚合 / 语料扫描（PowerShell 只读，本会话已执行）
#    $corpus='System\.Management|…|DllImport|RegistryKey' → src 全树零命中（§4-2/4-3/4-4 明细）
# E. 接线差距复核：csproj AvaloniaResource 计数 = 0；3 txt + 3 png SHA 前缀见 p1-01 §6.2 目标路径（本文件 §6 表）
# F. 宿主零写入：链上 5 obj mtime 见 §1（= p0-06 §8 基线）
```

## 8. 边界声明

- 本批写入仅 `.tang/cases/stcp-cross-platform-001/evidence/p1-07-revenue-dependency-check.md`；产品文件（csproj/源/资产/manifest）零改动；宿主检出、原插件、NuGet 缓存全程只读。
- 未代批任何接线/构建变更；6 项 AvaloniaResource 差距与 Avalonia buildTransitive 事实已登记，接线归属由尚书省 W5 裁决。
- 后备分支真实 NuGet 发布解析仍属阶段 4（发布面）；macOS 构建环境缺口为 p0-06 G1 已知项，与本任务无涉。
- 本文件为批级验证证据，不推进、不审批全局工作流；报尚书省以 `tang_record_ministry_result` 记录，门下省终验。
