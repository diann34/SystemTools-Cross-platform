# p0-06 新插件三平台 Release 构建基线验证（工部 infrastructure-release / verification）

- 案卷：`stcp-cross-platform-001`；阶段 0 / assignment `p0-06`；依赖 `p0-02`、`p0-04`、`p0-05`（均已 succeeded）
- 执行环境：Windows，.NET SDK `10.0.302`
- 宿主版本（p0-01 §1.2 重放）：`2.1.1.1+a8af81ba37ec1e83588148a400a00a9d8548560d`
- 结论：**failed** —— Windows/Linux 两目标通过 NuGet 后备分支成功编译；macOS 目标因当前环境缺少 `macos` 工作负载（NETSDK1147）无法编译，不满足本任务"三平台目标均有成功编译输出"的完成条件。
- 写入面：仅新插件工程 `src\SystemTools.CrossPlatform\obj\bin\` 与 `.tang/cases/stcp-cross-platform-001/evidence/`；宿主检出 `E:\ClassIsland-git-misha` 与原插件 `E:\My Github Projects\SystemTools` 全程只读，未触发任何写入（§8）。

## 1. 环境基线（可重放）

```powershell
dotnet --version
# => 10.0.302

Get-Item 'E:\ClassIsland-git-misha\ClassIsland.Desktop\bin\Debug\net10.0-windows10.0.19041.0\ClassIsland.Desktop.exe' |
  Select-Object -ExpandProperty VersionInfo |
  Format-List FileVersion, ProductVersion
# => FileVersion 2.1.1.1 / ProductVersion 2.1.1.1+a8af81ba37ec1e83588148a400a00a9d8548560d
```

- SDK：`10.0.302`（对齐宿主 `global.json` `10.0` / `latestFeature` / `allowPrerelease`）
- 宿主最佳可用版本：`2.1.1.1` + commit `a8af81ba37ec1e83588148a400a00a9d8548560d`
- 工作目录：`E:\My Github Projects\SystemTools-Cross-platform`

## 2. 标准路径尝试（一次）

命令：
```powershell
dotnet build .\SystemTools-Cross-platform.slnx -c Release
```

结果：
- 退出码：`1`
- 摘要输出：
  ```
  正在确定要还原的项目…
  生成失败。
      0 个警告
      0 个错误
  已用时间 00:00:02.48
  ```
- 诊断日志（`-v diag`）：`obj\p0-06-slnx-diag.log`
- 根因： restore 阶段 `_GenerateRestoreProjectPathWalk` 失败；日志中出现 `MSB4276: 默认 SDK 解析程序解析 SDK“Microsoft.NET.SDK.WorkloadAutoImportPropsLocator”失败，因为目录“C:\Program Files\dotnet\sdk\10.0.302\Sdks\Microsoft.NET.SDK.WorkloadAutoImportPropsLocator\Sdk”不存在` 与 `Microsoft.NET.SDK.WorkloadManifestTargetsLocator` 同类错误。该 MSB4276 为环境/工作负载定位器噪声（与 p0-04 §7.1 同因），且 slnx 路径会经引用图写入宿主检出 obj/bin，故按派工要求不再重试标准路径，转入任务 2 后备路径。

## 3. 只读消费构建（预授权后备路径）

命令模板（三平台）：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false
# 追加平台属性：-p:PublishBuilding=true -p:PublishPlatform=linux|macos
```

### 3.1 默认 Windows 场景

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false
```

结果：退出码 `1`；与标准路径同因，restore 阶段即失败（MSB4276 环境噪声）。

`--no-restore` 变体：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false --no-restore
```

结果：
- 退出码：`1`
- TFM 已正确解析：`net10.0-windows10.0.19041.0`（PrintPlatformInfo 输出确认）
- 错误：`error NU1105: Unable to find project information for 'E:\ClassIsland-git-misha\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj'`
- 归因：跳过 restore 后，MSBuild 无法解析被引用宿主工程的项目信息；本地检出预编译产物路径为 `bin\Debug\net10.0`，而当前命令使用 `-c Release` 且 TFM 为 Windows 后缀，输出路径不匹配，无法只读消费。

### 3.2 Linux 发布场景

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

结果：退出码 `1`；restore 阶段即失败（MSB4276 环境噪声）。

`--no-restore` 变体：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false -p:PublishBuilding=true -p:PublishPlatform=linux --no-restore
```

结果：
- 退出码：`1`
- TFM 已正确解析：`net10.0`（PrintPlatformInfo 输出确认）
- 错误：`error NETSDK1005: 资产文件“...\obj\project.assets.json”没有“net10.0”的目标`
- 归因：现有 `obj\project.assets.json` 仅含 `net10.0-windows10.0.19041.0` 目标（Rider 设计时产物），缺少 Linux 目标资产。

### 3.3 macOS 发布场景

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false -p:PublishBuilding=true -p:PublishPlatform=macos
```

结果：退出码 `1`；restore 阶段即失败（MSB4276 环境噪声）。

`--no-restore` 变体：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:BuildProjectReferences=false -p:PublishBuilding=true -p:PublishPlatform=macos --no-restore
```

结果：
- 退出码：`1`
- 错误：
  ```
  error NETSDK1147: 要构建此项目，必须安装以下工作负载: macos
  要安装这些工作负载，请运行以下命令: dotnet workload restore
  ```
- 归因：当前 SDK 环境未安装/无法解析 `macos` 工作负载。`dotnet workload list` 在本环境抛出 `Microsoft.DotNet.Cli.Installer.Windows.InstallerBase` 初始化异常；`C:\Program Files\dotnet\packs` 下无 `Microsoft.macOS.*` 运行时包，仅有 `microsoft.net.sdk.macos` 清单目录。macOS 目标无法在本机实际编译。

## 4. NuGet 后备分支实验（额外探索路径，仅用于收集证据）

为确认"插件本体三 TFM 可解析/可编译"与平台限定错误边界，在**不修改 csproj** 的前提下，临时使用 p0-04 §10 引入的 NuGet 后备模式（`-p:UseLocalClassIslandSdk=false`）进行验证。该模式不引用宿主检出工程，restore/build 全部写入面留在工作区。

### 4.1 Linux / net10.0

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

结果：
- 退出码：`0`（成功）
- 实际 TFM：`net10.0`
- 产物：`src\SystemTools.CrossPlatform\bin\Release\net10.0\SystemTools.CrossPlatform.dll`
- 文件版本：`1.0.0.0` / `1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e`
- 警告：`NU1900` 获取 NuGet 漏洞源失败（网络不可达，非致命）

### 4.2 Windows / net10.0-windows10.0.19041.0

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false
```

结果：
- 退出码：`1`
- 实际 TFM：`net10.0-windows10.0.19041.0`（已正确解析）
- 错误：`CSC : error CS5001: 程序不包含适合于入口点的静态 "Main" 方法`
- 根因：宿主 `CrossPlatformProps.props:46-48` 在 `Platforms_Windows` + `Release` 时将 `<OutputType>WinExe</OutputType>` 写入项目；插件为类库，继承该属性后要求 `Main` 入口。

修正实验（命令行覆盖 `OutputType=Library`，不改动 csproj）：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:OutputType=Library
```

结果：
- 退出码：`0`（成功）
- 实际 TFM：`net10.0-windows10.0.19041.0`
- 产物：`src\SystemTools.CrossPlatform\bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll`
- 文件版本：`1.0.0.0` / `1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e`
- 残余差距：默认 csproj 未覆盖 `OutputType`，本地检出路径若通过 restore，Windows Release 构建同样会命中 CS5001。

### 4.3 macOS / net10.0-macos26.5

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=macos
```

结果：
- 退出码：`1`
- 错误：`NETSDK1147: 要构建此项目，必须安装以下工作负载: macos`
- 即使追加 `-p:OutputType=Library`，结果相同（工作负载检查在属性求值/restore 之前）。

## 5. 三平台目标结果汇总

| 平台 | 预期 TFM | 实际解析 TFM | 编译结果 | 采用路径 | 关键错误/说明 |
| --- | --- | --- | --- | --- | --- |
| Windows | `net10.0-windows10.0.19041.0` | `net10.0-windows10.0.19041.0` | **成功** | NuGet 后备 + `-p:OutputType=Library` 命令行覆盖 | 默认 csproj 继承 CrossPlatformProps 的 `OutputType=WinExe`，需覆盖为 `Library` |
| Linux/X11 | `net10.0` | `net10.0` | **成功** | NuGet 后备 | NU1900 网络警告，非致命 |
| macOS | `net10.0-macos26.5` | `net10.0-macos26.5`（已解析，未进入编译） | **失败** | 任意路径 | `NETSDK1147` 缺少 `macos` 工作负载；本环境无法安装/恢复该工作负载 |
| 标准 slnx | — | — | 失败 | 标准路径 | `MSB4276` 环境噪声，restore 阶段失败 |
| 本地检出后备 | — | Windows/Linux TFM 已解析 | 失败 | `-p:BuildProjectReferences=false` | 同因 MSB4276；`--no-restore` 则 NU1105/NETSDK1005 |

**判定**：Windows/Linux 两平台有成功编译输出；macOS 仅有 TFM 解析、无编译输出。按本任务"三平台目标均有成功编译输出"的完成条件，判 **failed**。

## 6. 产物清单

```
src\SystemTools.CrossPlatform\bin\Release\net10.0\
├── SystemTools.CrossPlatform.dll          (Linux 目标产物)
├── SystemTools.CrossPlatform.pdb
├── SystemTools.CrossPlatform.deps.json
└── manifest.yml                           (CopyToOutputDirectory=Always 接线生效)

src\SystemTools.CrossPlatform\bin\Release\net10.0-windows10.0.19041.0\
├── SystemTools.CrossPlatform.dll          (Windows 目标产物)
├── SystemTools.CrossPlatform.pdb
├── SystemTools.CrossPlatform.deps.json
└── manifest.yml                           (CopyToOutputDirectory=Always 接线生效)
```

两平台 DLL 文件版本均为 `1.0.0.0` / `1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e`。

## 7. 发现的产品缺陷（csproj 层级）

`CrossPlatformProps.props:46-48` 在 Windows Release 配置下将 `OutputType` 设为 `WinExe`（面向宿主 exe）。新插件 csproj 在导入该 props 后仅清除了 `ApplicationManifest` 与 `ApplicationIcon`（p0-02 §3），但未将 `OutputType` 覆盖回 `Library`。结果：

- NuGet 后备 Windows Release 构建失败：`CS5001` 缺少 `Main`。
- 若本地检出路径通过 restore，同一错误必然出现。

**建议修复**：在现有清除 `ApplicationManifest`/`ApplicationIcon` 的 PropertyGroup 中增加 `<OutputType>Library</OutputType>`。本任务作为 verification 角色未修改产品文件，仅记录缺陷。

## 8. 宿主检出零写入证明

执行本任务前后，宿主链 5 个工程 `obj\project.assets.json` 修改时间未变：

| 工程 | mtime（UTC） |
| --- | --- |
| `ClassIsland.PluginSdk` | 2026-09-01T07:39:08Z |
| `ClassIsland.Core` | 2026-09-02T05:11:23Z |
| `ClassIsland.Platforms.Abstractions` | 2026-09-01T07:39:07Z |
| `ClassIsland.Shared` | 2026-09-01T07:39:07Z |
| `ClassIsland.Shared.IPC` | 2026-09-01T07:39:07Z |

所有 restore/build 写入均发生在工作区 `src\SystemTools.CrossPlatform\obj\` 与 `bin\` 下，未向 `E:\ClassIsland-git-misha` 写入。

## 9. 残余差距与后续归属

| # | 差距 | 归属/建议 |
| --- | --- | --- |
| G1 | macOS 目标未能在本环境编译（NETSDK1147 缺少工作负载） | 环境基础设施缺口；需在具备 macOS workload 的构建机/CI 上重放验证 |
| G2 | csproj 未覆盖 `OutputType=Library`，Windows Release 本地检出/NuGet 路径均会 CS5001 | 产品修复（p0-02 责任面回归或新任务） |
| G3 | 标准路径与本地检出后备路径均受 MSB4276 环境噪声阻塞 | 环境修复（补齐/修复 SDK workload locator）后重放标准 slnx 构建 |
| G4 | NuGet 后备分支仅验证到 2.1.1.1 包本地缓存可用；cipx 打包未执行 | 阶段 4 发布面验证（05 合同） |

## 10. 结论

本任务按派工要求执行了标准路径一次、本地检出后备路径三平台、NuGet 后备分支探索实验，并记录了全部输出与错误原文。

- **已证实**：Windows/Linux 两平台 TFM 展开与 Release 编译可在本环境达成（NuGet 后备路径 + OutputType 覆盖）。
- **未达成**：macOS 目标因当前环境缺少 `macos` .NET 工作负载，无法进入编译；标准路径与本地检出后备路径亦被 MSB4276 环境噪声阻塞。
- **综合判定**：不满足"三平台目标均有成功编译输出"的完成条件，本任务 **failed**，提请尚书省/礼部/户部按 05 合同与 CP-0.1/CP-0.2 决定是否修复环境/产品后继续。

## 11. 补充复验：G2 OutputType 缺陷修复验证（p0-02 修订 R1）

### 11.1 修复来源

- 修复责任：吏部 p0-02 修订 R1（`src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` 文件尾 PropertyGroup 新增 `<OutputType>Library</OutputType>`）。
- 修复依据：宿主 `CrossPlatformProps.props:46-48` 在 Windows Release/Release_MSIX 分支注入 `<OutputType>WinExe</OutputType>`（面向宿主 exe）；插件类库无 `Main`，Windows Release 构建必现 `CS5001`。
- 吏部求值核验结论（p0-02-scaffold-tree.md §11.3）：修复后 `-getProperty:OutputType` 在 Release/Release_MSIX + Windows/linux/macos 全场景均返回 `Library`。

### 11.2 复验命令与结果

#### 11.2.1 Windows Release / NuGet 后备（不再加 OutputType 覆盖）

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false
```

结果：
- 退出码：`0`（成功）
- 实际 TFM：`net10.0-windows10.0.19041.0`
- 产物：`src\SystemTools.CrossPlatform\bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll`
- 文件版本：`1.0.0.0` / `1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e`
- 警告：`NU1900` 获取 NuGet 漏洞源失败（网络不可达，非致命）
- 关键验证点：未追加 `-p:OutputType=Library`，csproj 自身修复已阻止 `CS5001`。

#### 11.2.2 Linux Release / NuGet 后备（回归检查）

命令：
```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

结果：
- 退出码：`0`（成功）
- 实际 TFM：`net10.0`
- 产物：`src\SystemTools.CrossPlatform\bin\Release\net10.0\SystemTools.CrossPlatform.dll`
- 文件版本：`1.0.0.0` / `1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e`
- 回归结论：OutputType 修复对 Linux 无不良影响，编译仍然成功。

### 11.3 未重试项（状态不变）

按尚书省复验指令，以下因环境阻塞的项目**未重试**，状态维持原 p0-06 结论：

| 项 | 状态 | 原因 |
| --- | --- | --- |
| macOS 目标编译 | 失败 | `NETSDK1147` 缺少 `macos` 工作负载；`dotnet workload list` 仍抛 `InstallerBase` 初始化异常 |
| 标准 slnx 路径 | 失败 | `MSB4276` SDK workload locator 环境噪声 |
| 本地检出后备路径 | 失败 | 同因 `MSB4276`；`--no-restore` 仍 NU1105/NETSDK1005 |

### 11.4 复验后残余差距声明

- **G2 已消除**：csproj 已固定 `OutputType=Library`，Windows Release NuGet 后备路径不再报 `CS5001`。
- **G1/G3/G4 维持不变**：
  - G1（macOS 工作负载缺失）仍阻塞 macOS 编译；
  - G3（MSB4276 环境噪声）仍阻塞标准路径与本地检出后备路径；
  - G4（cipx 打包未执行）仍待阶段 4。

### 11.5 宿主检出零写入复核

复验执行前后，宿主链 5 个工程 `obj\project.assets.json` 修改时间仍维持原值：

| 工程 | mtime（UTC） |
| --- | --- |
| `ClassIsland.PluginSdk` | 2026-09-01T07:39:08Z |
| `ClassIsland.Core` | 2026-09-02T05:11:23Z |
| `ClassIsland.Platforms.Abstractions` | 2026-09-01T07:39:07Z |
| `ClassIsland.Shared` | 2026-09-01T07:39:07Z |
| `ClassIsland.Shared.IPC` | 2026-09-01T07:39:07Z |

### 11.6 复验结论

- **复验本身**：succeeded —— G2 缺陷已消除，Windows/Linux NuGet 后备 Release 构建均无需命令行覆盖即可成功。
- **p0-06 原判定**：维持 **failed** 不变，因 macOS 目标仍无成功编译输出，不满足"三平台目标均有成功编译输出"的完成条件。
