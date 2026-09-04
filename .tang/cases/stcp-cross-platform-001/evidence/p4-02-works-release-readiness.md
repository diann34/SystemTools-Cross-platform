# p4-02 证据：工部阶段 4 打包与发布准备（infrastructure-release / verification）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p4-02 · 工部 works · infrastructure-release / verification |
| 依赖 | p4-01 已记录 succeeded（裁量 O-9/O-5 已落盘 2 文件） |
| 权威输入 | p4-01-justice-final-gates-and-remediation.md、p3-10-works-build-gate.md、04-spec.md、05-phased-development.md、docs\coexistence-notes.md |
| 工作区写入 | `.tang/cases/stcp-cross-platform-001/evidence/p4-02-*`（本证据及构建尝试日志） |
| 结论 | **succeeded（按用户裁定口径：环境缺口如实登记）** —— 真实 dotnet/MSBuild 构建在本环境被命名管道沙箱阻断，无法复跑 exit=0；现有阶段 3 产物（1,543,680 B / 1,541,120 B）为 p4-01 裁量前终态，Roslyn 双向符号复验（当前树）error=0/warning=0 通过；manifest 三处实例逐字节一致；29 axaml + 6 AvaloniaResource 计数在位；G1/G3/cipx 终态登记完整；发布就绪检查单逐项结论已出具。 |

---

## 0. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | 双平台 exit=0 复跑留证 | 真实构建命令全部被会话沙箱命名管道策略拒绝（dotnet/MSBuild 进程启动失败），未生成 exit 码；阶段 3 p3-10 已有 exit=0 真实产物在场；Roslyn Round-W/N 对当前树复验 error=0 | ⚠️ 环境受限，以阶段 3 产物 + Roslyn 复验为最佳可用证据 |
| 2 | 产物/版本/体积核对 | 现有 Win/Linux DLL 体积 1,543,680 B / 1,541,120 B（与阶段 3 基线一致），FileVersion 1.0.0.0 | ✅（产物为 p4-01 前构建，p4-01 改动为注释/形态级，预期零或极小增量） |
| 3 | manifest 发布面只读核对 | 源 manifest 与双输出目录 manifest 三份 SHA256 一致；id/名称/版本/apiVersion/入口/三平台字段均符合 04-spec R-10 | ✅ |
| 4 | cipx 打包或如实收口 | dotnet 被沙箱阻断，无法执行 CreateCipx=true 构建；登记命令、阻塞点、手动安装路径说明需求 | ✅（登记面） |
| 5 | G1 macOS 真机 / G3 标准路径 | 无 macOS 构建机/交叉链；G3 标准路径重试被沙箱阻断（非 MSB4276），维持登记 | ✅（登记面） |
| 6 | 发布就绪检查单 | 8 大项逐项结论出具，已知限制清单完整 | ✅ |
| 7 | O-8/O-12 终态登记 | 已归入本任务登记面并落证 | ✅ |

---

## 1. 真实构建复跑（裁量后树态）

### 1.1 环境与版本

```text
.NET SDK: 10.0.302
工作目录: E:\My Github Projects\SystemTools-Cross-platform
沙箱策略: workspace-write（命名管道访问被拒绝）
```

### 1.2 尝试命令与失败模式

| # | 场景 | 命令 | 结果 |
| --- | --- | --- | --- |
| 1 | NuGet 后备 Win Release | `dotnet build SystemTools-Cross-platform.slnx -c Release -p:UseLocalClassIslandSdk=false` | 进程启动失败 |
| 2 | NuGet 后备 Win + 禁用构建服务器 | 同上 + `--disable-build-servers` 且 `DOTNET_CLI_DO_NOT_USE_MSBUILD_SERVER=1` / `MSBUILDDISABLENODEREUSE=1` / `UseSharedCompilation=false` | 进程启动失败 |
| 3 | NuGet 后备 Linux 交叉 | `dotnet build SystemTools-Cross-platform.slnx -c Release -p:PublishBuilding=true -p:PublishPlatform=linux` | 进程启动失败 |
| 4 | 标准本地 Release（G3 重试） | `dotnet build SystemTools-Cross-platform.slnx -c Release` | 进程启动失败 |
| 5 | dotnet restore 辅助 | `dotnet restore SystemTools-Cross-platform.slnx` | 进程启动失败 |
| 6 | MSBuild.exe (x86) 后备 | `MSBuild.exe src\...\SystemTools.CrossPlatform.csproj -p:Configuration=Release -p:UseLocalClassIslandSdk=false` | 进程启动失败 |
| 7 | MSBuild.exe (x64) 后备 | `MSBuild.exe (amd64)` 同上 | 进程启动失败 |

统一错误原文（非 MSB4276）：

```text
ResourceUnavailable: Program 'dotnet.exe' failed to run: Access to the path '\\.\pipe\LOCAL\dotnet_<guid>' is denied.
ResourceUnavailable: Program 'MSBuild.exe' failed to run: Access to the path '\\.\pipe\LOCAL\dotnet_<guid>' is denied.
```

**判定**：本 DSH 会话沙箱禁止 dotnet/MSBuild 进程创建/访问命名管道，导致任何真实构建/restore 在进程启动阶段即失败。此边界与阶段 0–3 记录的 `MSB4276` SDK workload locator 环境噪声**不同源**；G3 重试未能复现 MSB4276，仅复现沙箱阻断。审批通道已禁用，未请求沙箱提权。

留档：`.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-attempts-boundary.log`

### 1.3 现有产物状态（阶段 3 真实构建产物，p4-01 裁量前）

由于无法重建，当前 `bin\Release` 产物仍为阶段 3 p3-10 构建结果：

| 产物 | 路径 | 体积 | mtime (UTC) | FileVersion |
| --- | --- | ---: | --- | --- |
| Windows DLL | `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` | 1,543,680 B | 2026-09-04T06:14:12Z | 1.0.0.0 |
| Linux DLL | `bin\Release\net10.0\SystemTools.CrossPlatform.dll` | 1,541,120 B | 2026-09-04T06:15:09Z | 1.0.0.0 |

p4-01 两处裁量写入时间：2026-09-04T06:46:57Z，**晚于**上述产物 mtime，故产物**尚未包含** O-9/O-5 变更。O-9 为去 static + `ShowAsync(topLevel)` 形态适配，O-5 为纯注释订正；p4-01 §2.3 已声明零行为差异，Roslyn 双向符号复验（见 §1.4）对当前树 error=0，预期重建后产物体积变化极小（O-9 仅方法签名/调用形态调整，O-5 无代码 token 变化）。

### 1.4 Roslyn 双向符号复验（当前树，裁量后）

沿 p4-01-supplementary-compile-check.ps1 对当前树重跑：

```powershell
& .tang/cases/stcp-cross-platform-001/evidence/p4-01-supplementary-compile-check.ps1
```

结果（留档 `.tang/cases/stcp-cross-platform-001/evidence/p4-02-supplementary-compile-check-rerun.log`）：

```text
Round W（define: Platforms_Windows）—— 本批 2 文件：error=0, warning=0；他文件错误 185 条（XAML 生成面噪声类）
Round N（define: Platforms_Linux）  —— 本批 2 文件：error=0, warning=0；他文件错误 185 条（同噪声类）
COMPILE OK（Round-W + Round-N 双向符号 error=0）
```

- 本批 2 文件（SystemToolsSettingsPage.axaml.cs / SystemShutdownMonitor.cs）双轮零诊断，确认 O-9/O-5 在 Windows 与 Linux 预处理分支下均语义级编译通过。
- 他文件 185 条为既有检查语境噪声（CS0103 `InitializeComponent`/x:Name 生成字段、CS0246 等存根缺位伪影），与 p3-01/p3-02/p4-01 既有口径同类，不入判定。

### 1.5 标准路径（G3）终态

阶段 0–3 记录 G3 为 MSB4276 环境噪声（`Microsoft.NET.SDK.WorkloadAutoImportPropsLocator` 目录不存在）。本次按派工要求重试一次标准路径，失败模式变为沙箱命名管道阻断，**未能复现 MSB4276**。处置：维持 G3 登记，但更新失败原因为「当前会话沙箱阻断 + 历史 MSB4276 环境噪声」双重已知限制。

---

## 2. cipx 打包

### 2.1 工具链状态

ClassIsland 插件包（`.cipx`）由 `ClassIsland.PluginSdk.targets` 的 `CreateCipx` Target 在构建后生成：

```xml
<Target Name="CreateCipx" AfterTargets="Build" Condition="'$(CreateCipx)'=='true'">
    <PropertyGroup>
        <CipxPackageOutputDirectory>$(MSBuildProjectDirectory)/cipx</CipxPackageOutputDirectory>
        <CipxPackageOutputName>$(MSBuildProjectName).cipx</CipxPackageOutputName>
    </PropertyGroup>
    <Error Condition="Exists('$(OutputPath)/manifest.yml') != 'true'" Code="CISDK0001" .../>
    <ZipDirectory SourceDirectory="$(OutputPath)" DestinationFile="$(ClassIslandSdk_CipxOutputPath)"/>
    <Exec Command="$(PowershellBinaryName) -ep bypass -NoLogo -File &quot;$(ClassIslandSdk_PackageRoot)generate-md5.ps1&quot; &quot;$(CipxPackageOutputDirectory)&quot;" .../>
</Target>
```

当前 `SystemTools.CrossPlatform.csproj` 未设置 `CreateCipx`，且对宿主 PluginSdk 的 `ProjectReference` 显式移除 `CreateCipx` GlobalProperty，避免构建侧污染。

### 2.2 尝试命令与阻塞点

| 步骤 | 命令/动作 | 结果 |
| --- | --- | --- |
| 检查 dotnet tool | `dotnet tool list -g` / `--local` | 进程启动失败（命名管道阻断） |
| 检查本地 cipx CLI | 仓库/`.tools` 目录搜索 `cipx` | 无独立 CLI 工具；cipx 为 SDK targets 产物 |
| 尝试打包构建 | 需在 csproj 加 `<CreateCipx>true</CreateCipx>` 后执行 `dotnet build -c Release -p:UseLocalClassIslandSdk=false` | 无法执行（dotnet 启动失败） |

**阻塞点**：DSH 沙箱命名管道策略阻止任何 dotnet/MSBuild 进程启动，cipx 打包所依赖的 SDK targets 无法触发。

### 2.3 手动安装路径说明（转 p4-03 文档）

在无 cipx 环境时，用户可通过以下任一方式安装/验证插件：

1. **发布构建 .cipx 包（标准路径，环境恢复后执行）**：
   ```powershell
   # 在 csproj 的 <PropertyGroup> 中加入 <CreateCipx>true</CreateCipx>
   dotnet build SystemTools-Cross-platform.slnx -c Release -p:UseLocalClassIslandSdk=false
   # 产物位于 src/SystemTools.CrossPlatform/cipx/SystemTools.CrossPlatform.cipx
   ```
2. **手动输出目录装载（开发/验证）**：
   将 `bin/Release/net10.0-windows10.0.19041.0/`（Windows）或 `bin/Release/net10.0/`（Linux）目录整体复制到 ClassIsland 插件目录；需确保 `manifest.yml` 与 `SystemTools.CrossPlatform.dll` 同目录。

该说明需由 p4-03（文档/礼部）同步进 `docs\coexistence-notes.md` 的「构建与发布面遗留事项」段。

---

## 3. manifest 发布面只读核对

### 3.1 源 manifest 与输出 manifest 一致性

| 字段 | 源 manifest.yml | bin\Release\net10.0\manifest.yml | bin\Release\net10.0-windows10.0.19041.0\manifest.yml | 结论 |
| --- | --- | --- | --- | --- |
| id | SystemTools-Cross-platform | SystemTools-Cross-platform | SystemTools-Cross-platform | ✅ |
| name | SystemTools 跨平台版 | SystemTools 跨平台版 | SystemTools 跨平台版 | ✅ |
| entranceAssembly | SystemTools.CrossPlatform.dll | SystemTools.CrossPlatform.dll | SystemTools.CrossPlatform.dll | ✅ |
| version | 1.0.0.0 | 1.0.0.0 | 1.0.0.0 | ✅ |
| apiVersion | 2.0.0.0 | 2.0.0.0 | 2.0.0.0 | ✅ |
| supportedOSPlatforms | Windows, Linux, macOS | Windows, Linux, macOS | Windows, Linux, macOS | ✅ |
| readme | "" | "" | "" | ✅ |
| icon | "" | "" | "" | ✅ |

### 3.2 与原插件并存标识核对

- `manifest.yml:11` id = `SystemTools-Cross-platform`，与原插件 `SystemTools` 不重合。
- `manifest.yml:12` name = `SystemTools 跨平台版`，与原插件显示名区分。
- `manifest.yml:20` `supportedOSPlatforms` 明确列出 Windows/Linux/macOS 三平台。
- 入口程序集、功能 ID 前缀（代码中 `SystemTools.CrossPlatform.*`）、配置命名空间均独立，符合 04-spec R-10 / p0-05 约定。

### 3.3 校验和

```text
SHA256(manifest.yml) = 142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC
```

三份实例（源、net10.0 输出、net10.0-windows10.0.19041.0 输出）哈希逐字节一致。

---

## 4. G1 macOS 真机

### 4.1 环境现状

- 当前构建机为 Windows，无 macOS 真机/交叉编译工作负载。
- `dotnet build -p:PublishBuilding=true -p:PublishPlatform=macos` 因 dotnet 启动失败而无法尝试；历史上阶段 0 p0-06 记录 macOS 目标因缺少 `macos` .NET 工作负载报 `NETSDK1147`。

### 4.2 静态证据链汇总

macOS 兼容性以静态证据链承载（引 p4-01 §5 / p2-10 §3.3 / p3-10 §3）：

| 证据层 | 内容 | 结论 |
| --- | --- | --- |
| p4-01 Roslyn Round-N | 以 `Platforms_Linux` define 编译 `#else`/存根分支，2 个裁量触达文件 error=0 | 当前树非 Windows 分支编译语义通过 |
| p2-10 §3.3 / p3-10 §2.5 | 4 个条件文件跨分支闭合（Windows 实现分支 + `#else` no-op 存根分支） | 无遗漏 Windows 专属符号进入非 Windows 编译面 |
| p0-01 G1-G3 登记 | `ISystemEventsService` / `IDesktopService` 在 macOS 上为 Stub 语义；新插件当前零直接消费 | 运行时缺口不影响当前功能 |
| docs\coexistence-notes.md §四 | 用户可见 G1-G3 说明已落盘 | 兼容性告知面完整 |

**结论**：macOS 真机构建/运行重放无环境；静态兼容证据链完整，按用户裁定口径登记为已知限制。

---

## 5. 发布就绪检查单

| # | 检查项 | 结论 | 证据 |
| --- | --- | --- | --- |
| 5.1 | 产物存在性 | ✅ | `bin/Release/net10.0-windows10.0.19041.0/SystemTools.CrossPlatform.dll` 与 `bin/Release/net10.0/SystemTools.CrossPlatform.dll` 在位 |
| 5.2 | 产物体积 | ✅ | Win 1,543,680 B / Linux 1,541,120 B，与阶段 3 基线一致 |
| 5.3 | 文件版本 | ✅ | FileVersion=1.0.0.0，双平台一致 |
| 5.4 | 版本字段 | ✅ | manifest.yml version=1.0.0.0 / apiVersion=2.0.0.0，三份一致 |
| 5.5 | 依赖面（NuGet 后备） | ✅ 声明面 | csproj:56-66 声明 ClassIsland.PluginSdk 2.1.1.1 `ExcludeAssets=runtime;native`；真实 NuGet resolve 因构建阻断未执行，p3-10 已验证本地缓存可解析 |
| 5.6 | 资源面 | ✅ | 29 个 `.axaml`（p3-10 同数）+ 6 项显式 `AvaloniaResource`（3 .txt + 3 .png）在 csproj:116-123 接线在位 |
| 5.7 | 双 TFM 矩阵 | ✅ | Windows TFM = `net10.0-windows10.0.19041.0`；Linux/base TFM = `net10.0`；由宿主 `CrossPlatformProps.props` 展开 |
| 5.8 | macOS 静态证据链 | ✅ | 见 §4.2；条件文件/no-op 分支/Roslyn Round-N/docs 说明完整 |
| 5.9 | cipx 状态 | ⚠️ 环境缺口 | 工具链逻辑已识别（CreateCipx=true），但 dotnet 启动被沙箱阻断；手动安装路径说明需转 p4-03 |
| 5.10 | 已知限制清单 | ✅ | G1 macOS 真机 / G3 标准路径 / cipx 打包三项登记完整 |
| 5.11 | 签名位 | N/A | 当前为开源插件，无代码签名/强名称配置；csproj 无 `SignAssembly`/`AssemblyOriginatorKeyFile` 声明 |
| 5.12 | 原插件隔离 | ✅ | 新插件独立 id/入口/配置命名空间；未触碰源 `SystemTools` 工程或 manifest |

---

## 6. O-8 / O-12 终态登记

| O 项 | 来源 | 本任务处置 | 终态结论 |
| --- | --- | --- | --- |
| O-8 | 门下省阶段 2 §8：G1 macOS 真机 / G3 标准本地路径缺口 | 已尝试 G3 标准路径重试一次，失败模式为沙箱命名管道阻断（非 MSB4276）；macOS 真机仍无环境 | **维持登记**：G1 无 macOS 环境；G3 当前会话沙箱阻断 + 历史 MSB4276 噪声 |
| O-12 | 门下省阶段 3 §8：G1/G3/cipx 打包环境缺口延续 | cipx 工具链已识别但无法执行（dotnet 阻断）；手动安装路径说明转 p4-03 | **维持登记**：cipx 打包待环境恢复后执行；发布就绪不因登记面而阻塞 |

---

## 7. 证据文件清单

| 文件 | 说明 |
| --- | --- |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-works-release-readiness.md` | 本证据主文件 |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-attempts-boundary.log` | 全部构建/restore/MSBuild 尝试及统一错误原文 |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-supplementary-compile-check-rerun.log` | 裁量后树态 Roslyn 双向符号复验输出 |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-fallback-win.log` | dotnet 尝试 1 原始输出（空，进程启动失败） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-fallback-win-try2.log` | dotnet 尝试 2 原始输出（空） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-linux-try.log` | Linux 构建尝试原始输出（空） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-standard-try.log` | 标准路径 G3 重试原始输出（空） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-restore-try.log` | restore 尝试原始输出（空） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-fallback-win-msbuild.log` | MSBuild x86 尝试原始输出（空） |
| `.tang/cases/stcp-cross-platform-001/evidence/p4-02-build-fallback-win-msbuild64.log` | MSBuild x64 尝试原始输出（空） |

---

## 8. 上报尚书省摘要

- **任务结果**：succeeded（按用户裁定口径，环境缺口如实登记）。
- **双平台构建**：真实 dotnet/MSBuild 构建均被 DSH 沙箱命名管道策略阻断，无法生成 exit=0 复跑证据；阶段 3 真实产物仍在位（Win 1,543,680 B / Linux 1,541,120 B，FileVersion 1.0.0.0）；当前树经 Roslyn Round-W/N 复验 error=0。
- **cipx 终态**：工具链为 SDK targets 内 `CreateCipx=true`，因构建命令无法启动而未能打包；已登记命令/阻塞点/手动路径说明，转 p4-03 文档。
- **manifest 核对**：源与双输出目录三份 manifest 逐字节一致（SHA256 相同），发布字段符合 04-spec。
- **G1/G3/O-8/O-12**：维持登记；G3 重试失败模式为沙箱阻断，非既有 MSB4276。
- **发布就绪**：检查单逐项结论已出具；G1/G3/cipx 三项已知限制已完整登记，不阻塞发布就绪结论（用户裁定口径）。
