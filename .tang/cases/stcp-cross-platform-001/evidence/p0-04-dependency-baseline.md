# p0-04 新插件依赖裁剪与包图门禁基线证据（户部 data-dependencies / implementation）

- 案卷：`stcp-cross-platform-001`；阶段 0 / assignment `p0-04`；依赖 `p0-02`（succeeded）
- 权威输入：`04-spec.md` S4.2 / R-5；`05-phased-development.md` §0.1.3、§0.3「项目依赖」行、§0.5.2、CP-0.2；`evidence/p0-02-scaffold-tree.md` §4/§6/§7/§8.3
- 工作区（唯一写入面）：`E:\My Github Projects\SystemTools-Cross-platform`（csproj + 案卷证据）
- 只读消费：原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha`、NuGet 缓存 `C:\Users\0\.nuget\packages`
- 结论：**succeeded** —— 包引用裁剪结果 = 新工程保持**零直接 PackageReference**；PluginSdk/DI/FluentAvalonia 均经 U3 宿主链传递可达（与原插件自身声明形态一致）；S4.2 禁用包及其 Windows runtime 资产直接与传递双零命中。

## 1. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| 包引用裁剪结果（PackageReference 集） | **空集**（直接引用 = 0）。前 = `[]`（p0-02 脚手架），后 = `[]`（本任务复核 + 一次显式 FAUI 实验后按版本冲突回退，见 §4） |
| 保留包清单与版本 | `ClassIsland.PluginSdk`（ProjectReference→U3 检出，p0-01 快照 `2.1.1.1` / commit `a8af81ba…`）；`FluentAvaloniaUI 3.0.0`（宿主 Core.csproj:72 传递）；DI `Microsoft.Extensions.DependencyInjection / Abstractions / Hosting / Hosting.Abstractions 10.0.10`（宿主 Core.csproj:61-63 传递）；宿主 Avalonia 基线 `12.1.1`（p0-01 §2.2） |
| DI 解析结论 | 传递可达，**不重复添加**（派工任务 1 规则） |
| FluentAvalonia 解析结论 | 传递可达（版本 3.0.0 与宿主 Core 声明一致，原插件即按此编译）；显式加入被版本冲突否决（派工任务 2 规则），见 §4 |
| S4.2 禁用包零命中 | **通过**（direct=0；宿主链无向消费方输出的禁用包；CsWin32 在 Core 为 `PrivateAssets=all`+无 compile asset，不外流），见 §5 |
| 命令重放 | 见 §7；`dotnet restore/list package` 在沙箱内无法完成图走查（exit 1，宿主 obj 写入面外），按派工边界改用只读等价证据，宿主 obj mtime 零变化证明 |

## 2. 复核时的直接引用状态（派工任务 1 前半）

- `dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -nologo` → `"PackageReference": []`（**零直接引用**；与 p0-02 §6 表一致）。
- 引用来源：唯一 `ProjectReference` → `$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj`（`ReferenceOutputAssembly=true`、`Private=false`、`GlobalPropertiesToRemove=CreateCipx`）；PluginSdk 自身 `IncludeAssets=all` ProjectReference→Core，Core ProjectReference→Platforms.Abstractions / Shared / Shared.IPC（p0-02 §4 拓扑）。
- 工作区 `src\SystemTools.CrossPlatform\obj\project.assets.json`（IDE 设计时产物）targets 键为 `net10.0-windows10.0.19041.0`，libraries=0 —— 该文件为**部分/设计时恢复快照**，不作为闭包权威证据（p0-02 §8.1-4 已界定：完整 restore/build 属 p0-06 构建面）。本任务用 §3 的宿主链/原插件解析资产 + NuGet 缓存元数据作只读等价证据。

## 3. 传递依赖图与保留可达性证据（派工任务 1 后半 + 任务 2 前半）

**拓扑**：新插件 → PluginSdk → Core → {Platforms.Abstractions, Shared, Shared.IPC}（包面全部来自 Core/Abstractions 的 PackageReference）。

### 3.1 宿主 Core 解析闭包（`E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json`，net10.0）

保留相关解析条目（package 类型）：

```
Avalonia/12.1.1 · Avalonia.Controls.ColorPicker/12.1.1 · Avalonia.Skia/12.1.1 · Avalonia.Desktop/12.1.1 …
FluentAvaloniaUI/3.0.0
Microsoft.Extensions.DependencyInjection/10.0.10 · …Abstractions/10.0.10
Microsoft.Extensions.Hosting/10.0.10 · …Hosting.Abstractions/10.0.10
Microsoft.Windows.CsWin32/0.3.183（Core 私有，PrivateAssets=all；见 §5）
```

声明位置：`ClassIsland.Core.csproj:61-63`（M.E.Hosting/Hosting.Abstractions/Configuration.UserSecrets 10.0.10）、`:68-72`（Avalonia 族 `$(AvaloniaVersion)=12.1.1`、FluentAvaloniaUI 3.0.0）。

### 3.2 DI 传递可达（不再重复添加的依据）

- `Microsoft.Extensions.Hosting 10.0.10` nuspec（NuGet 缓存）net10.0 依赖组含 `Microsoft.Extensions.DependencyInjection 10.0.10` 与 `…DependencyInjection.Abstractions 10.0.10`（依赖组实列见执行输出，涵盖 DI 容器与抽象）。
- 原插件（同构拓扑：仅 ProjectReference 本地 PluginSdk，未直接声明 Hosting/Abstractions）解析资产中同样含 `Microsoft.Extensions.DependencyInjection/10.0.10` 等 —— 实证插件级编译可达。
- 故新插件**不新增** DI PackageReference（派工任务 1：「可达则不重复添加并记录证据」）。

### 3.3 FluentAvalonia 有效版本与兼容性

- **事实更正**：原插件 `E:\My Github Projects\SystemTools\SystemTools.csproj` **未声明** FluentAvalonia（其 PackageReference 全集见 §5.2：DlibDotNet、M.E.DI、CsWin32、OpenCvSharp4/Ext/runtime.win、System.Management、System.Speech；全树 *.csproj/props/targets 亦无 FA 声明）。原插件通过 SDK 链传递消费 `FluentAvaloniaUI 3.0.0`（宿主 Core.csproj:72），其 `obj\project.assets.json` 解析到 `FluentAvaloniaUI/3.0.0` + `Avalonia/12.1.1` —— 即「与源插件声明一致」的可行版本 = **3.0.0（链上版本）**。
- **兼容性校验**：`fluentavaloniaui.3.0.0.nuspec`（缓存）依赖组 net10.0：`Avalonia 12.0.0（下限）、Avalonia.Controls.ColorPicker 12.0.0、Avalonia.Controls.DataGrid 12.0.0、Avalonia.Skia 12.0.0、MicroCom.Runtime 0.11.5`；宿主 Avalonia 12.1.1 ≥ 下限 12.0.0，且宿主 Core 自身即 FAUI 3.0.0 + Avalonia 12.1.1 同构构建 —— 兼容。
- **结论**：FluentAvalonia 经链可达即满足 R-5「保留 FluentAvalonia 所需能力」与 CP-0.2「保留包可解析」，无需、也不应（见 §4）显式引入。

## 4. 显式 FAUI 引入实验与版本冲突（派工任务 2 触发回退的证据）

按任务 2 的字面尝试把保留包显式化（透明记录，非最终状态）：

1. 临时在 csproj 加 `<PackageReference Include="FluentAvaloniaUI" Version="3.0.0" />`。
2. 观测（IDE 后台设计时恢复 `obj\project.assets.json` 增量快照）：解析到 **`Avalonia/12.0.0`**（FAUI 3.0.0 依赖下限），而非宿主基线 12.1.1；`dotnet restore -v diag` 日志出现 **NU1605 ×17**（本工程 `WarningsAsErrors` 含 `NU1605`，p0-02 引宿主 Global.props 同款；即包降级检测）。
3. 判定：显式直接引用使 FAUI 的 `Avalonia ≥ 12.0.0` 约束成为距根更近的节点约束，NuGet nearest-wins 倾向把 Avalonia 压到 12.0.0，低于宿主 Core 运行时基线 12.1.1 —— 属「与宿主版本冲突」。按派工任务 2 尾句与 05 合同 0.1.3：「存在版本冲突则记录事实并上报，不强行引入」。
4. **回退**：删除该临时 PackageReference，csproj 恢复零直接引用（复核 `-getItem:PackageReference` = `[]`），仅保留说明性注释（§6）。宿主 Avalonia 12.1.1 由此保持由宿主链 Core 节点单一决定，与宿主运行时分发一致。
5. 另注：原插件亦不显式声明 FA（§3.3），故「与源插件一致」的工程形态本来就是**传递消费**。

## 5. S4.2 禁用包零命中证明（派工任务 3）

### 5.1 新工程直接引用面

- `-getItem:PackageReference` = `[]`（§2）。csproj 中无任何 PackageReference 元素（实验后已清除）。
- 无 VoskWorker/C 档原生认证、视觉运行时的源码/资产引用（p0-02 §6 对照：未复制原插件 :46-56 与 :65-97 的 Windows 包与构建目标）。

### 5.2 宿主链是否带入禁用包（消费方视角）

全宿主检出 `*.csproj`（排除 obj/bin）对 S4.2 包名扫描结果：

| 文件 | 命中 | 是否进入新插件引用链 |
| --- | --- | --- |
| `ClassIsland.Core.csproj:49` | CsWin32 0.3.183 | **否**：`<PrivateAssets>all</PrivateAssets>` 且 `IncludeAssets` 不含 `compile`（运行时/生成器私有资产），NuGet 不外流到 PluginSdk→新插件消费方 |
| `ClassIsland\ClassIsland.csproj:72,86-87` | CsWin32 / System.Management / System.Speech | 否：宿主 **app** 工程，不在 PluginSdk→Core→Abstractions/Shared/Shared.IPC 链内 |
| `ClassIsland.Launcher.csproj:12` | CsWin32 | 否：独立启动器，链外 |
| `platforms\ClassIsland.Platforms.Windows.csproj:19` | CsWin32 | 否：Windows 平台实现工程，链外 |
| DlibDotNet / OpenCvSharp* / NAudio / Vosk | 全宿主零命中 | — |

### 5.3 原插件解析图边级复核（等价拓扑证明）

原插件 `obj\project.assets.json` targets 中 SDK 链节点（`ClassIsland.PluginSdk/1.0.0`、`ClassIsland.Core/1.0.0`、`ClassIsland.Platforms.Abstractions/1.0.0`、`ClassIsland.Shared/1.0.0`、`ClassIsland.Shared.IPC/1.0.0`）的依赖边对禁用包集合 = **NONE**；原插件 assets 中出现的 CsWin32 0.3.298 / DlibDotNet / OpenCvSharp* / System.Management / System.Speech 全部来自原插件**自身直接声明**（csproj:46-56），非链上带入。新插件零直接声明 ⇒ 这些包在闭包内零来源。

### 5.4 结论

直接引用 = 0；传递面（仅 U3 链）对 S4.2 集合零命中；VoskWorker/C 档原生运行时无来源。**CP-0.2 门禁通过**（依赖图无 S4.2 禁用包；保留包 PluginSdk/DI/FA 可解析，证据 §3）。

## 6. 工程文件实际变更（写入面）

`src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj`：
- 功能零变更：直接引用集保持空（与 p0-02 交付一致）。
- 新增一处**说明性注释块**（ProjectReference 之后），固化 p0-04 决策：零显式 PackageReference、DI/FA 传递可达、S4.2 不进入、显式 FAUI 实验的 Avalonia 降级事实及其回退理由（供 p0-06/p0-07 复核）。未引入任何 manifest/打包相关内容（manifest 属 p0-05）。
- 未改动原插件 `E:\My Github Projects\SystemTools` 与宿主检出 `E:\ClassIsland-git-misha`。

## 7. 命令重放与验证记录（派工任务 3「记录使用命令与方法」）

### 7.1 标准命令尝试及沙箱结果（如实记录）

```powershell
# (a) dotnet list package —— 内部先执行 restore，沙箱内无法完成图走查
dotnet list src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj package --include-transitive
# 输出：仅 "正在确定要还原的项目…"，exit = 1（无更多消息）

# (b) dotnet restore -v diag 归因
dotnet restore src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -v diag > obj\p0-04-restore-diag.log 2>&1
# exit = 1；尾部 "生成失败。0 个警告 0 个错误"；归因线索为 MSB4276（workload locator SDK 目录缺失的环境噪声）
# 与 SDK 10.0.302 环境/workload 布局相关，非本工程包错误；且该命令会把恢复图写入宿主检出 obj
# （超出本任务「写入仅限工作区+证据」边界，p0-02 §8.2 同判），故不做 host 写入尝试。
```

**边界处理（按派工）**：不以绕过沙箱或写宿主检出的方式强行 restore；改用下列**只读等价证据路径**，并证明宿主零写入（§7.3）。

### 7.2 只读等价证据（已执行并成功）

```powershell
# 直接引用求值（不触发 restore）
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -nologo   # => []
# 宿主链解析闭包（只读）
Get-Content 'E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json' -Raw   # FAUI 3.0.0 / Avalonia 12.1.1 / M.E.* 10.0.10
# 原插件同构拓扑解析闭包（只读）
Get-Content 'E:\My Github Projects\SystemTools\obj\project.assets.json' -Raw            # 插件级 FA/DI 编译可达实证
# NuGet 缓存元数据（可解析性 + 许可证事实）
#   fluentavaloniaui/3.0.0（nuspec：net10.0 依赖组、lib/net10.0）    PRESENT
#   avalonia/12.1.1 · avalonia.controls.colorpicker/12.1.1 · avalonia.skia/12.1.1      PRESENT
#   avalonia.controls.datagrid/12.0.0 · microcom.runtime/0.11.5                          PRESENT
#   microsoft.extensions.dependencyinjection(-.abstractions)?/10.0.10
#   microsoft.extensions.hosting(-.abstractions)?/10.0.10                                 PRESENT
# Hosting 10.0.10 nuspec net10.0 组 -> 含 Microsoft.Extensions.DependencyInjection 10.0.10（DI 传递可达）
# 宿主 csproj S4.2 包名扫描（§5.2 表）
# 原插件 assets 依赖边复核（§5.3）
```

### 7.3 宿主检出零写入证明

- 执行本任务前后，`E:\ClassIsland-git-misha` 五个链上工程 `obj\project.assets.json` mtime 快照：`PluginSdk 2026-09-01T07:39:08Z`、`Core 2026-09-02T05:11:23Z`、`Platforms.Abstractions/Shared/Shared.IPC 2026-09-01T07:39:07Z` —— 前后一致（本任务未触发任何宿主写入）。
- 原插件快照沿用 p0-02 §9.1（前后零差异），本任务对其仅只读读取（grep / Get-Content / assets 解析）。

### 7.4 完整 restore/build（闭包权威验证）归属

按 p0-02 §8.3 与 05 合同 0.5.1：三平台构建与最终包图输出在 **p0-06** 执行（届时宿主 obj/bin 写入属该阶段构建面）；本任务以 §3-§5 只读证据完成基线门禁。

## 8. 许可证要点（事实记录，非法律结论；派工任务 4）

新增/保留可达包在 NuGet 缓存的 license 元数据：

| 包 | license 表达 | licenseUrl |
| --- | --- | --- |
| FluentAvaloniaUI 3.0.0 | expression（MIT） | https://licenses.nuget.org/MIT |
| Avalonia 12.1.1 | expression（MIT） | https://licenses.nuget.org/MIT |
| Microsoft.Extensions.DependencyInjection 10.0.10 | expression（MIT） | https://licenses.nuget.org/MIT |
| Microsoft.Extensions.DependencyInjection.Abstractions 10.0.10 | expression（MIT） | https://licenses.nuget.org/MIT |
| Microsoft.Extensions.Hosting 10.0.10 | expression（MIT） | https://licenses.nuget.org/MIT |
| Microsoft.Extensions.Hosting.Abstractions 10.0.10 | expression（MIT） | https://licenses.nuget.org/MIT |

（均为 license expression + licenses.nuget.org 指向；仅记录字段，不发表合规结论。M.E.* 为 .NET 平台包，Avalonia/FAUI 为对应上游项目 MIT 授权包。）

## 9. 风险与回滚

- 风险：Avalonia 版本一致性完全依赖宿主链 Core 的 `$(AvaloniaVersion)` 单一来源；若后续宿主升级 Avalonia 主版本，FAUI 3.0.0 兼容性需在宿主层复核（非本工程可控，符合 U3 检出基线决议）。
- 回滚：删除 csproj 说明注释即回到 p0-02 原状；证据文件删除即本任务完全回滚；原插件与宿主检出不受影响（§7.3）。

---

# §10 用户更正修订（2026-09-03，仍属 p0-04 责任面修订）

## 10.1 用户更正原文（留痕）

> "记得至少需要依赖包：插件依赖包ClassIsland.PluginSdk插件包 版本2.1.1.1"

用户常设指引（遵循并留痕）：向源插件 `E:\My Github Projects\SystemTools` 学习——仅学插件基础构造与宿主链接方式（本任务 = 引用声明形态），排除仅支持 Windows 的架构。

## 10.2 解释：双满足（默认检出 / 后备 NuGet 2.1.1.1）

用户更正要求插件工程声明 `ClassIsland.PluginSdk` 2.1.1.1 依赖包。为同时满足 CP-0.1（U3 检出基线，默认路径不变）与用户更正，采用源插件 `SystemTools.csproj` 的 **UseLocalClassIslandSdk 双形态先例**：

| 模式 | 触发条件 | 引用 | 来源 |
| --- | --- | --- | --- |
| 本地检出（默认） | `UseLocalClassIslandSdk` 缺省/`true` | ProjectReference → `$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj` | 对齐源插件 csproj:161-167；CP-0.1 保持 |
| NuGet 后备 | 显式 `-p:UseLocalClassIslandSdk=false` | PackageReference `ClassIsland.PluginSdk` **Version=2.1.1.1**（`ExcludeAssets=runtime;native`） | 对齐源插件 csproj:42-45（其 NuGet 后备形态）与 csproj:13（版本属性默认） |

- 属性定义：`UseLocalClassIslandSdk`（缺省 `true`）、`ClassIslandPluginSdkVersion`（缺省 `2.1.1.1`），对齐源插件 csproj:10-13。
- `ExcludeAssets=runtime;native` 与默认分支 `Private=false` 语义一致：宿主运行时自带 SDK 程序集，插件输出不复制宿主 DLL（对齐源插件 csproj:44 后备包亦同）。
- 双满足含义：**默认开发/构建 = U3 检出**（用户此前已确认的 U3 基线，CP-0.1 不被推翻）；**显式关掉本地 SDK 时 = NuGet 发布包 2.1.1.1 后备**（满足用户"至少需要依赖包 2.1.1.1"的声明要求）。两条路径都有声明可解析来源。
- 默认模式下该后备 PackageReference 条件为假，不参与求值/restore，**p0-04 已通过的 CP-0.2 禁用包零命中证据不受影响**（§5 结论保持）。

## 10.3 csproj 变更 diff 描述（src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj）

p0-05 的 manifest.yml 接线与头注释更新**全部保留**（文件尾 `None Update=manifest.yml` ItemGroup 原样在位）。本修订在 p0-05 状态上仅做：

1. 头注释「引用来源」行改写：从"仅本地检出、不设 NuGet 后备"改为"双形态（默认检出 / UseLocalClassIslandSdk=false 走 NuGet 后备 2.1.1.1）"。
2. 属性组新增两个缺省属性：`UseLocalClassIslandSdk=true`、`ClassIslandPluginSdkVersion=2.1.1.1`（注释记录双形态先例与用户更正驱动）。
3. 原 ProjectReference ItemGroup 增加 `Condition="'$(UseLocalClassIslandSdk)' != 'false'"`（默认路径不含该属性时同样求值为真，行为不变）。
4. 新增 NuGet 后备 ItemGroup：`Condition="'$(UseLocalClassIslandSdk)' == 'false'"` → PackageReference `ClassIsland.PluginSdk` Version=`$(ClassIslandPluginSdkVersion)`、`ExcludeAssets=runtime;native`。
5. p0-04 说明注释块更新：记录用户更正原文、双形态先例（源插件 csproj:10-12/42-45/161-170）、后备分支包图核验归属发布面（阶段 4）。

## 10.4 求值核验（不触发 restore、不写宿主检出；2026-09-03 实测）

```powershell
# 1) 默认模式 PackageReference —— 预期 []，实测 []
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -nologo
# 2) 后备模式 PackageReference —— 预期出现 ClassIsland.PluginSdk 2.1.1.1，实测命中
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -p:UseLocalClassIslandSdk=false -nologo
#    => Identity=ClassIsland.PluginSdk / Version=2.1.1.1 / ExcludeAssets=runtime;native
# 3) 默认模式 ProjectReference —— 预期检出 PluginSdk 在位，实测在位
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:ProjectReference -nologo
#    => E:\ClassIsland-git-misha\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj（ReferenceOutputAssembly=true / Private=false）
# 4) 后备模式 ProjectReference —— 预期 []（检出分支被关闭），实测 []
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:ProjectReference -p:UseLocalClassIslandSdk=false -nologo
# 属性复核：UseLocalClassIslandSdk=true、ClassIslandPluginSdkVersion=2.1.1.1
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getProperty:UseLocalClassIslandSdk,ClassIslandPluginSdkVersion -nologo
```

后备分支真实 NuGet 解析/restore **不在本阶段执行**（发布面验证，阶段 4；NuGet 源为 GitHub Packages 的事实已记录于 p0-01）。

## 10.5 边界声明

- 写入仅限：`src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` + 本证据文件。
- 原插件 `E:\My Github Projects\SystemTools` 与宿主检出 `E:\ClassIsland-git-misha` 全程只读。
- 宿主链 5 工程 `obj\project.assets.json` mtime 修订前后一致（`PluginSdk 2026-09-01T07:39:08Z`、`Core 2026-09-02T05:11:23Z`、`Platforms.Abstractions/Shared/Shared.IPC 2026-09-01T07:39:07Z`）——零宿主写入复核通过。
- 默认模式 CP-0.2 证据（§5）与本修订前的零直接引用求值结果保持一致，不受双形态新增影响。
