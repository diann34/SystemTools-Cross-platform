# p3-10 证据：工部阶段 3 验证收尾——整合后构建门禁与产物预算补记

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-10 · 工部 works · infrastructure-release / verification |
| 依赖 | p3-07/08/09 已记录 succeeded；p3-01/02/03/05/06 旧 plan succeeded 落盘 |
| 权威输入 | p3-07-revenue-dependency-check.md（csproj 零改动 SHA256 A7220DB4…C38A / 体积 defer 基线）；p3-08-justice-filegates.md（168/0/13 与 4 项修复现态）；p3-06-rites-coexistence-doc.md（docs/coexistence-notes.md 用户面）；p2-10-works-build-gate.md（阶段 2 基线 Win 1,489,408 B / Linux 1,486,848 B） |
| 工作区写入 | `src\SystemTools.CrossPlatform\obj\*`（构建覆盖）、`src\SystemTools.CrossPlatform\bin\Release\*`（阶段 3 真实产物覆盖阶段 2 旧产物）、`.tang/cases/stcp-cross-platform-001/evidence/p3-10-*`（本证据及构建日志） |
| 结论 | **succeeded（按用户裁定口径：NuGet 后备 Win/Linux Release 构建均 exit=0）** —— csproj 零改动（SHA256 与基线一致）；Win/Linux 产物真实体积 1,543,680 B / 1,541,120 B（较阶段 2 基线各 +54,272 B）；29 个 `.axaml` 被 Avalonia 收集；4 个条件文件跨分支编译闭合；阶段 1 三类编译缺陷零复现；macOS 静态兼容证据增量汇总成立；宿主链 5 工程 obj mtime 与基线一致。 |

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| csproj 零改动 | **确认零改动**：`SystemTools.CrossPlatform.csproj` mtime 2026-09-03T18:55:37Z、大小 9,952 B、SHA256 `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A`，与 p3-07/p2-10 基线逐字节一致 |
| 标准本地 Release | **仍失败于 Restore 阶段**（exit=1），根因为 MSB4276/G3 环境噪声（`Microsoft.NET.SDK.WorkloadAutoImportPropsLocator` / `Microsoft.NET.SDK.WorkloadManifestTargetsLocator` 目录不存在），与阶段 0/1/2 同源；按用户裁定口径不阻塞 |
| NuGet 后备 Win Release | **通过**（exit=0）；产物 `net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` 真实体积 **1,543,680 B**，文件版本 1.0.0.0 |
| NuGet 后备 Linux | **通过**（exit=0）；产物 `net10.0\SystemTools.CrossPlatform.dll` 真实体积 **1,541,120 B**，文件版本 1.0.0.0 |
| 整合后编译面预检 | 共享 VM 887 行终态编译通过；D1-D4 修复现态已由 p3-08 核验；29 个 `.axaml` 完成 `additionalfile` 收集；4 个条件文件跨分支编译闭合；阶段 1 三类缺陷（隐式 using / Avalonia API / 双分支漂移）零复现 |
| macOS 静态兼容证据 | 阶段 3 零新 Windows 专属路径、零新平台分支；docs\coexistence-notes.md 落盘为用户可见兼容性证据增量；兼容面与阶段 2 等同；真机重放留阶段 4 |
| 产物预算补记 | 阶段 2 基线 → 阶段 3 Win 1,543,680 B（+54,272 B / +3.6%）、Linux 1,541,120 B（+54,272 B / +3.6%）；PDB/deps/runtimeconfig 同步更新；bin 阶段 2 旧产物已被新构建覆盖 |
| 零写入复核 | 宿主链 5 工程 `obj\project.assets.json` mtime 与 p3-07/p2-10 基线逐项一致；源树（含 csproj）无本任务写入 |

---

## 1. 任务 0：csproj 零改动确认

### 1.1 实测状态

| 属性 | 实测值 | p3-07 §1 基线 | 一致性 |
| --- | --- | --- | --- |
| 路径 | `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | 同 | ✓ |
| 大小 | 9,952 B | 9,952 B | ✓ |
| mtime (UTC) | 2026-09-03T18:55:37.981Z | 2026-09-03T18:55:37Z | ✓ |
| SHA256 | `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` | `A7220DB4…C38A` | ✓ |
| 行数 | 125 | 125 | ✓ |

### 1.2 判断依据

- csproj 内 `AvaloniaResource` 六项（:113-123）与 p1-10/p2-10/p3-07 接线终态逐字一致，阶段 3 未新增、未回退。
- 构建过程中未暴露任何接线面缺口；未对 csproj 做任何写入。

**结论**：csproj 阶段 3 零改动，无需接线增补。

---

## 2. 任务 1：构建门禁

### 2.1 环境与版本

```text
.NET SDK: 10.0.302
MSBuild:  18.6.11+35b593beb
工作目录: E:\My Github Projects\SystemTools-Cross-platform
```

### 2.2 场景 A：标准本地检出 Release 构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p3-10-build-standard-detailed.log;verbosity=detailed"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | 1（留档 `p3-10-build-standard-exitcode.txt`） |
| 失败阶段 | Restore → SDK 解析 |
| 错误原文（详细日志行 22/45） | `MSB4276: 默认 SDK 解析程序解析 SDK“Microsoft.NET.SDK.WorkloadAutoImportPropsLocator”失败，因为目录“C:\Program Files\dotnet\sdk\10.0.302\Sdks\Microsoft.NET.SDK.WorkloadAutoImportPropsLocator\Sdk”不存在。`；后续 `WorkloadMSBuildSdkResolver` 成功解析，属环境噪声 |
| 产物 | 无新 DLL |

**判定**：与阶段 0/1/2 记录的 G3（本地检出路径 Restore 环境噪声）同源；本次不阻塞结论，按用户裁定口径转用 NuGet 后备模式。

**留档**：`p3-10-build-standard.log`、`p3-10-build-standard-detailed.log`、`p3-10-build-standard-exitcode.txt`

### 2.3 场景 B：NuGet 后备 Win Release 构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p3-10-build-fallback-win.log;verbosity=normal"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | **0**（留档 `p3-10-build-fallback-win-exitcode.txt`） |
| Restore | 成功（NuGet 包已存在，无需网络） |
| 目标 TFM | `net10.0-windows10.0.19041.0` |
| `PublishBuilding` / `PublishPlatform` | 空 / 空 |
| `Os_IsWindows` | `True` |
| 预处理符号（csc `/define:`） | `TRACE;Platforms_Windows;RELEASE;NET;NET10_0;NETCOREAPP;WINDOWS;WINDOWS10_0_19041_0;…` |
| 编译错误 | **0** |
| 编译警告 | 28 个 `CS8602`（可空引用解引用，历史既有）+ 2 个 `NU1900`（漏洞数据获取失败，环境噪声） |
| 产物路径 | `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` |
| 产物体积 | **1,543,680 B** |
| 文件版本 | `FileVersion=1.0.0.0`，`ProductVersion=1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e` |

**判定**：构建通过；阶段 1 三类编译缺陷未复现。

**留档**：`p3-10-build-fallback-win.log`、`p3-10-build-fallback-win-exitcode.txt`

### 2.4 场景 C：NuGet 后备 Linux 交叉构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p3-10-build-fallback-linux.log;verbosity=normal"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | **0**（留档 `p3-10-build-fallback-linux-exitcode.txt`） |
| Restore | 成功 |
| 目标 TFM | `net10.0` |
| `PublishBuilding` / `PublishPlatform` | `true` / `linux` |
| `Os_IsWindows` | `True`（构建机仍为 Windows，TFM 为 net10.0） |
| 预处理符号（csc `/define:`） | `TRACE;Platforms_Linux;RELEASE;NET;NET10_0;NETCOREAPP;…`（**无 `Platforms_Windows`、无 `WINDOWS*`**) |
| 编译错误 | **0** |
| 编译警告 | 28 个 `CS8602` + 2 个 `NU1900` |
| 产物路径 | `bin\Release\net10.0\SystemTools.CrossPlatform.dll` |
| 产物体积 | **1,541,120 B** |
| 文件版本 | `FileVersion=1.0.0.0`，`ProductVersion` 与 Win 一致 |

**判定**：Linux 路径通过；条件文件的 `#else` no-op 分支经真实 TFM 编译闭合。

**留档**：`p3-10-build-fallback-linux.log`、`p3-10-build-fallback-linux-exitcode.txt`

### 2.5 整合后编译面预检结论

| 预检面 | 证据 | 结论 |
| --- | --- | --- |
| **共享 VM 887 行** | 两批 5 段界标已由 p3-08 终态核验（:25-66 / :68-100 / :113-139 / :193-690 / :693-886），真实 Win/Linux 构建均 exit=0 | ✅ 编译面闭合 |
| **4 项修复现态** | D1 `IRulesetService` using、D2 `SetTextAsync` using、D3 `TopLevel.GetTopLevel`、D4 `ShowAsync(topLevel)` 均已在位（p3-08 §3.4）；本构建 error=0 | ✅ 无残留编译错误 |
| **6 页接线 XAML** | 29 个 `.axaml` 完成 `additionalfile` 收集（清单留档 `p3-10-axaml-additionalfiles.txt`，29 个，与阶段 2 同数） | ✅ XAML 编译面闭合 |
| **条件文件 4 个跨分支** | Win TFM `/define:Platforms_Windows` 编译 Windows 分支；Linux TFM `/define:Platforms_Linux` 编译 `#else` 存根分支；两构建均 exit=0 | ✅ 跨分支闭合 |
| **阶段 1 三类缺陷** | 隐式 using（CS0104/CS0103）、Avalonia API（CS1061 `IClipboard.SetTextAsync` / AVLN2000）、双分支漂移 在双构建日志中 **0 命中** | ✅ 零复现 |

**发现的新错误**：无。Win/Linux 双构建日志经 `error CS|error AVLN|AVLN2000` 扫描均为 0 命中（`MSB4276` 仅出现在场景 A 详细日志，属 G3 噪声）。

### 2.6 XAML/资源收集证据

#### 2.6.1 axaml 自动收集

Win 构建日志中提取 **29 个 `.axaml`** 作为 `additionalfile` 传入编译器（阶段 2 为 29 个，阶段 3 未新增/未删除），完整清单见 `p3-10-axaml-additionalfiles.txt`。

#### 2.6.2 显式接线资源收集

`AvaloniaResource` 六项（CardTypeComponent/ClassWidgets/NotchStyle Theme.axaml.txt ×3 + 上课/课间休息/无课程 .png ×3）在 csproj :113-123 中逐字在位；构建成功即表明资源进入 `avares` 清单，未出现 `AVLN2000` / XAMLIL 错误。

---

## 3. 任务 2：macOS 静态兼容证据·阶段 3 增量汇总

### 3.1 阶段 3 整合面无新平台语义

- 设置页 6 页全部由既有骨架改写，p3-08 全树门禁 **168/0/13** 与阶段 2 基线逐项一致，SettingsPage 目录 8 个 `.cs` 的 `#if` 计数均为 **0**。
- p3-01/p3-02 macOS 自检表合计 **8 + 13 项**：全部位于宿主跨平台机制或已批准降级路径，0 项新增 Windows 专属 P/Invoke / WinForms / user32 调用。

### 3.2 关键跨平台机制保留

| 能力 | 阶段 3 状态 | 证据 |
| --- | --- | --- |
| W2 重启 | 走 `SettingsPageBase.RequestRestart` 宿主跨平台机制 | 主页 axaml.cs 点击处理 + VM `SaveFeatureSettings` 末尾调用 RequestRestart（p3-06 §2.1/§3.3） |
| D5 主题映射 | 悬浮窗主题 ComboBox 第 4 项说明已追加「自适应背景→跟随宿主明暗」降级注记 | FloatingWindowEditorSettingsPage.axaml（p3-06 §2.3） |
| G1/G2/G3 | 同装差异文档 §四 已面向用户覆盖：ISystemEventsService 无 Linux/macOS 实装、会话结束事件走条件承载/no-op、IDesktopService 无 macOS 实装 | docs\coexistence-notes.md §四（p3-06 §1） |

### 3.3 同装差异文档落盘

- `docs\coexistence-notes.md`：14,133 B / 142 行 / mtime 2026-09-04T05:20:10Z，按 p3-05 §5 大纲 5 节扩写完成，第 2/4 节表列逐条带 file:line 或登记条目号。
- 该文档的落盘本身即为阶段 3 兼容性证据增量：它将 G1-G3 与降级行为以用户可见形式固化，无需新增产品代码即可证明兼容面未退化。

### 3.4 结论口径

- **阶段 3 零新 Windows 专属路径、零新平台分支。**
- **兼容面与阶段 2 等同**：条件文件仍是原 4 个（Actions\SystemPowerCommandWindows.cs、Services\ProcessMemoryMaintenanceNativeWindows.cs、Services\SystemShutdownMonitor.cs、Views\SystemMotionPreferences.cs），跨分支行为矩阵与 p2-10 §3.3 一致。
- **真机重放仍留阶段 4**（G1 环境缺口未解决）。

---

## 4. 任务 3：产物预算补记

### 4.1 阶段 3 真实产物清单

阶段 2 旧产物已被场景 B/C 新构建覆盖：`bin\Release` 下 DLL/PDB 最新 mtime 为 2026-09-04T06:14Z/06:15Z 以后。完整清单见 `p3-10-postbuild-products.txt`。

| 目录 | 文件 | 大小 | 说明 |
| --- | --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | SystemTools.CrossPlatform.dll | **1,543,680** | 阶段 3 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 275,144 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 1,129 | 与阶段 2 同（未重新生成） |
| | SystemTools.CrossPlatform.runtimeconfig.json | 554 | 与阶段 2 同（未重新生成） |
| | manifest.yml | 1,430 | 未变 |
| | Microsoft.Windows.SDK.NET.dll | 24,877,600 | NuGet 后备 Windows TFM 运行库 |
| | WinRT.Runtime.dll | 528,944 | 同上 |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll | **1,541,120** | 阶段 3 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 268,972 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 469 | 新产物 |
| | SystemTools.CrossPlatform.runtimeconfig.json | 377 | 新产物 |
| | manifest.yml | 1,430 | 未变 |

### 4.2 体积增量对比（对比阶段 2 基线）

| TFM | 阶段 2 基线 | 阶段 3 体积 | 绝对增量 | 相对增量 | 主要增量来源 |
| --- | ---: | ---: | ---: | ---: | --- |
| Win (`net10.0-windows10.0.19041.0`) | 1,489,408 B | 1,543,680 B | **+54,272 B** | +3.6% | 共享 VM 74→887 行（+813）+ 6 落点页接线增量 |
| Linux (`net10.0`) | 1,486,848 B | 1,541,120 B | **+54,272 B** | +3.6% | 同上 |

> Win 与 Linux 体积差异 2,560 B 与阶段 2 一致，源于 Windows TFM 引用面略有不同（`Microsoft.Windows.SDK.NET` 相关元数据/资源），属正常 TFM 差异。

### 4.3 覆盖注记

- `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` 由 2026-09-04T03:47:23Z / 1,489,408 B 覆盖为 2026-09-04T06:14:12Z / 1,543,680 B。
- `bin\Release\net10.0\SystemTools.CrossPlatform.dll` 由 2026-09-04T03:47:40Z / 1,486,848 B 覆盖为 2026-09-04T06:15:09Z / 1,541,120 B。
- 阶段 2 旧产物体积已在 §4.2 登记；产物清单完整见 `p3-10-postbuild-products.txt`。

---

## 5. 任务 4：零写入复核

### 5.1 宿主链 5 工程 obj mtime

| 工程 | 路径 | LastWriteTimeUtc | 与 p3-07/p2-10 基线一致性 |
| --- | --- | --- | --- |
| PluginSdk | `E:\ClassIsland-git-misha\ClassIsland.PluginSdk\obj\project.assets.json` | 2026-09-01T07:39:08.054Z | ✓ 一致 |
| Core | `E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json` | 2026-09-02T05:11:23.902Z | ✓ 一致 |
| Platforms.Abstractions | `E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |
| Shared | `E:\ClassIsland-git-misha\ClassIsland.Shared\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |
| Shared.IPC | `E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |

### 5.2 源插件 / 其他产品文件

- 源插件 `E:\My Github Projects\SystemTools` 全程只读，零写入。
- 除构建产生的 `obj\*` / `bin\Release\*` 外，本任务未修改任何 `.cs`、`.axaml`、`.yml`、`.json`、`.csproj`、`.slnx`、global.json 等产品文件。
- `SystemTools.CrossPlatform.csproj` mtime 保持 2026-09-03T18:55:37Z，SHA256 未变。

---

## 6. 残余差距声明

| 项 | 状态 | 说明 |
| --- | --- | --- |
| G1 macOS 构建 | 维持留档 | 无 macOS 构建机/交叉链，静态兼容证据已成立，真机重放留阶段 4 |
| G3 标准本地路径 | 仍受 MSB4276 环境噪声影响 | Restore 阶段失败，未进入编译；按用户裁定口径以 NuGet 后备模式为准 |
| cipx 打包 | 阶段 4 | `CreateCipx` 仍未设置，cipx 发布面核验留阶段 4 |
| 阶段 3 编译缺陷 | 无新增 | 三类缺陷（隐式 using / Avalonia API / 双分支漂移）均未复现 |
| 观察级残留 | 阶段 4 裁量 | p3-08 已上报 `SystemToolsSettingsPage.axaml.cs:197` 无参 `ShowAsync()` 形态与 D4 统一口径不一致；可编译，不阻塞阶段 3 |

---

## 7. 命令与版本可重放

```powershell
# 环境版本
dotnet --version   # => 10.0.302

# csproj 零改动复核
Get-FileHash -Algorithm SHA256 src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj
# => A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A

# 标准本地 Release（预期仍失败于 Restore/G3）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release

# NuGet 后备 Win Release（预期 exit=0）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false

# NuGet 后备 Linux（预期 exit=0）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux

# 产物体积复核
Get-Item src\SystemTools.CrossPlatform\bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll
Get-Item src\SystemTools.CrossPlatform\bin\Release\net10.0\SystemTools.CrossPlatform.dll

# axaml 收集数复核（从 win 日志提取）
[regex]::Matches((Get-Content .tang/cases/stcp-cross-platform-001/evidence/p3-10-build-fallback-win.log -Raw), 'additionalfile:(\S+\.axaml)').Count
# 去重后 = 29

# 宿主 obj 零写入复核
Get-Item E:\ClassIsland-git-misha\ClassIsland.PluginSdk\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Shared\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\obj\project.assets.json |
    Select-Object FullName,LastWriteTimeUtc
```

---

## 8. 边界声明

- 本任务写入严格受限：构建产生的 `obj\*` / `bin\Release\*` + 本案 `evidence/p3-10-*`。
- 未触碰源插件、宿主检出、兵部/礼部/刑部/户部已交付文件；csproj 阶段 3 零改动。
- 发现的产品源错误：无。阶段 1 三类编译缺陷均未复现。
- 本文件不推进、不审批全局工作流；属工部批级验证证据，报尚书省以 `tang_record_ministry_result` 记录。

## 9. 修订记录

- 初版（p3-10 执行交付；基于本轮标准构建 + NuGet 后备 Win/Linux 双构建实测、产物体积对比、宿主零写入复核）。
