# p4-04 证据：发布预算终稿与依赖终核（户部 data-dependencies / verification，阶段 4 只读收尾）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p4-04 · 户部 revenue · data-dependencies / verification |
| 依赖 | p4-01 / p4-02 均已 recorded succeeded |
| 权威输入 | p4-02-works-release-readiness.md（bin 现态 1,543,680 B / 1,541,120 B 裁量前构建、cipx 未能执行、构建沙箱阻断登记）；p3-07-revenue-dependency-check.md（闭包/零新增包基线）；p4-01-justice-final-gates-and-remediation.md（裁量 2 文件形态级+纯注释）；p2-07 / p1-07-revenue-dependency-check.md（预算链前期）；p0-05-manifest-baseline.md（apiVersion=2.0.0.0 依据）；p0-04-dependency-baseline.md（双形态基线）；p3-10-works-build-gate.md（阶段 3 真实构建体积） |
| 工作区写入 | `.tang/cases/stcp-cross-platform-001/evidence/p4-04-revenue-release-budget.md`（唯一写入面，本文件） |
| 结论 | **succeeded** —— csproj 终态 SHA256 `A7220DB4…C38A` 逐值核对在位（阶段 4 零触碰）；全阶段**零未授权新增包**终核通过（全树 PackageReference 唯一真实元素 = csproj:63 后备分支既有声明；阶段 4 触达 2 文件 using 面全部映射入既有闭包/guard 面，产品包字符串零命中）；发布预算终稿登记：终态产物体积 = 现 bin 阶段 3 裁量前构建（Win 1,543,680 B / Linux 1,541,120 B）——**如实注记**：裁量后真实重建受会话沙箱命名管道阻断（dotnet 进程启动即拒），预期体积变化极小（O-9 形态级 / O-5 纯注释），精确数字待环境恢复后补记，转门下省终验知悉；打包产物体积（cipx）未执行如实登记；依赖发布面终核：NuGet 后备解析面声明性复核通过（PackageReference 对偶 + ExcludeAssets=runtime;native 与输出目录零宿主 DLL 复制行为一致；缓存 nuspec 2.1.1.1 在位 + obj 闭包全消费包自足），PluginSdk 2.1.1.1 与 manifest apiVersion=2.0.0.0 兼容性声明一致；宿主链 5 工程 obj mtime 与基线逐项同值，插件 obj/bin 零阶段 4 写入。 |

---

## 0. 结论速览（对应派工完成条件）

| # | 完成条件 | 本任务实测 | 结论 |
| --- | --- | --- | --- |
| 1 | csproj 终态 SHA256 `A7220DB4…C38A` 零接线维持 | SHA256 `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z —— 与 p3-07/p2-10 基线逐字节一致（§1） | ✅ |
| 2 | 全阶段零未授权新增包终核 | 全树 PackageReference 唯一真实元素 = csproj:63（后备分支既有声明，阶段 0 形态）；阶段 4 触达 2 文件（SystemToolsSettingsPage.axaml.cs / SystemShutdownMonitor.cs）using 面全集映射入既有闭包 + 全文件 guard 面，产品包字符串（FluentAvaloniaUI|CommunityToolkit|Markdown.Avalonia|PluginSdk|PackageReference|ClassIsland.PluginSdk）零命中（§2） | ✅ 零新增 |
| 3 | 发布预算登记（终态体积如实注记） | 现 bin DLL = 阶段 3 p3-10 产物（Win 1,543,680 B / Linux 1,541,120 B，mtime 06:14:12Z / 06:15:09Z），**早于** p4-01 裁量写（06:46:57Z）→ 裁量前构建；如实注记 + 转门下省（§3.1/§3.3） | ✅（如实登记） |
| 4 | 打包产物体积（cipx 可用时） | cipx 目录不存在；CreateCipx 未设；dotnet 构建被沙箱阻断无法执行（p4-02 §1.2 同源）——登记面如实收口（§3.2） | ✅（登记面） |
| 5 | 依赖发布面终核（声明性） | PackageReference 对偶/ExcludeAssets 与输出行为一致性静态核对通过（输出目录实测零 ClassIsland*.dll 复制）；NuGet 缓存 `classisland.pluginsdk/2.1.1.1` nuspec 在位；obj 闭包（p3-10 后备构建残留 assets）自足（§4） | ✅ |
| 6 | apiVersion 兼容性声明一致性 | PluginSdk 2.1.1.1（包=检出 commit a8af81ba… 的 2.1.1.1 SDK 面）与 manifest apiVersion=2.0.0.0（宿主加载下限，p0-05 A4 实证 ClassIsland.Core 2.1.1.1 反序列化通过）声明一致（§4.2） | ✅ |
| 7 | 四阶段预算链汇总 | 152 → 203 → 203(+1 docs) → 203(+1 docs)；体积 1,349,120 → 1,489,408/1,486,848 → 1,543,680/1,541,120 → 现态（§5） | ✅ |
| 8 | 宿主链 obj mtime 零变化复核 | 链上 5 工程 obj\project.assets.json mtime 与 p2-07 §6-4/p3-10 §5.1 基线**逐项同值**；插件 obj/bin 最新写 = 06:15:09Z（p3-10）< p4-01 裁量写 → 零阶段 4 写入（§6） | ✅ |

---

## 1. csproj 终态核对（任务 1）

**实测（2026-09-04 会话，只读）**：

| 属性 | 实测值 | p3-07/p2-10 基线 | 一致性 |
| --- | --- | --- | --- |
| 路径 | `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | 同 | ✓ |
| SHA256 | `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` | `A7220DB4…C38A` | ✓ 逐字节 |
| 大小 | 9,952 B | 9,952 B | ✓ |
| 行数 | 125 | 125 | ✓ |
| mtime (UTC) | 2026-09-03T18:55:37Z | 2026-09-03T18:55:37Z | ✓ |

**求值面逐项在位复核（csproj 全文核对，:45-66 双形态 + :116-123 接线）**：

- 默认分支（:45-54）：唯一 ProjectReference → `$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\…`（ReferenceOutputAssembly=true / **Private=false** / GlobalPropertiesToRemove=CreateCipx）——与 p0-04 §10.4 / p2-07 §1 基线一致。
- 后备分支（:56-66）：唯一 PackageReference `ClassIsland.PluginSdk` Version=`$(ClassIslandPluginSdkVersion)`（缺省 2.1.1.1，:39）+ **ExcludeAssets=runtime;native**——与 p0-04 §10.4 / p1-07 §2 / p2-07 §1 一致。
- AvaloniaResource 六项（:116-123）在位，与 p1-10 接线终态逐字一致；manifest CopyToOutputDirectory（:90-92）在位。
- `CreateCipx` 未设（全文零命中该属性）；`VerifyClassIslandSource` 目标（:95-98）在位（CP-0.1 不回退）。

**阶段 4 零触碰独立证据**：csproj mtime（09-03T18:55:37Z）远早于 p4-01 两处裁量写入（06:46:57Z）与 p4-02 全部尝试；p4-01 §6.5 / p4-02 §1 均已登记 csproj 零改动，本核对 SHA 同值复证。**接线需求零新增**。

## 2. 全阶段零未授权新增包终核（任务 1 后半）

### 2.1 全树 PackageReference 元素检索（src，排除 bin/obj）

- **唯一真实命中 = csproj:63**（后备分支既有声明，阶段 0 双形态形态）；其余命中（csproj 注释行）均为历史说明文本——**零新增 PackageReference 声明**，与 p3-07 §3.2 / p2-07 §3.2 基线结论一致。

### 2.2 阶段 4 触达面增量复核（p4-01 裁量 2 文件）

| 文件 | using 面全集（实测） | 归属闭包 | 需新增 PackageReference？ |
| --- | --- | --- | --- |
| `SettingsPage\SystemToolsSettingsPage.axaml.cs` | System / System.Collections.ObjectModel / System.IO / System.Linq / System.Threading.Tasks / Avalonia.Controls / Avalonia.Interactivity / ClassIsland.Core.Abstractions.Controls / ClassIsland.Core.Attributes / ClassIsland.Shared / FluentAvalonia.UI.Controls / SystemTools.CrossPlatform.{ConfigHandlers,Services,Shared} | .NET 共享框架 BCL + 宿主链传递（Avalonia 12.1.1 / FAUI 3.0.0）+ 插件自命名空间 —— 全部落入 p3-07 §3.1 五桶 | 否 |
| `Services\SystemShutdownMonitor.cs` | System / System.Reflection / System.Threading / System.Windows.Forms | BCL + **System.Windows.Forms 位于全文件 `#if Platforms_Windows` guard 内**（p4-01 §5.2 / p2-07 §3.4 条件文件规范：Round-W Windows 分支 / Round-N `#else` no-op 分支，双轮 error=0）——非新增包（S4.2 条件面既有形态） | 否 |

- 两文件产品包字符串检索（FluentAvaloniaUI|CommunityToolkit.Mvvm|Markdown.Avalonia|PluginSdk|PackageReference|ClassIsland.PluginSdk）：**0 命中**。
- O-9（去 static + `ShowAsync(topLevel)` 形态统一）与 O-5（纯注释订正）零新增类型/using 面——形态级与注释级改动与 p4-01 §2.3 零行为差异声明互证。

**终核结论**：p3-07 闭包（168 Source 面 / 203 产品文件 / 零新增依赖）在阶段 4 触达面增量复核后仍闭合；**需新增 PackageReference 才能编译的依赖 = 0；未授权新增包 = 0**。

## 3. 发布预算登记（任务 2）

### 3.1 终态产物体积登记（如实注记：裁量前构建）

现 `bin\Release` 双 TFM 产物为**阶段 3 p3-10 真实构建结果**（NuGet 后备模式，exit=0），**尚未包含** p4-01 O-9/O-5 两处裁量（产物 mtime 早于裁量写入 ~32 分钟）：

| 产物 | 路径 | 体积 | mtime (UTC) | FileVersion |
| --- | --- | ---: | --- | --- |
| Windows DLL | `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` | **1,543,680 B** | 2026-09-04T06:14:12Z | 1.0.0.0 |
| Linux DLL | `bin\Release\net10.0\SystemTools.CrossPlatform.dll` | **1,541,120 B** | 2026-09-04T06:15:09Z | 1.0.0.0 |

**如实注记（必读）**：
- 本体积为 **p4-01 裁量前**的阶段 3 终态构建值（与 p3-10 §4.1 同值、p4-02 §1.3 复核同值）。裁量后真实重建在本会话被 DSH 沙箱命名管道策略阻断（dotnet.exe 启动即拒：`Access to the path '\\.\pipe\LOCAL\dotnet_*' is denied`，p4-02 §1.2 同源，审批通道禁用未提权），**无法生成裁量后树态的 exit=0 重建体积**。
- 预期裁量后体积变化**极小**：O-9 为方法形态适配（去 static + 守卫 + 显式 TopLevel 参数，行 257→262），O-5 为纯注释（代码 token 零变化）——Roslyn Round-W/N 双向符号复验 error=0（p4-01 §5.1 / p4-02 §1.4）。精确数字待环境恢复后补记。
- **转门下省终验知悉**：终态验收以「阶段 3 体积 + 裁量零/极小增量预期」为登记口径，不以失实重建冒充裁量后体积。

### 3.2 打包产物体积（cipx）——登记面如实收口

- `src\SystemTools.CrossPlatform\cipx\` 目录**不存在**（实测）；csproj 未设 `CreateCipx`（§1）。
- cipx 由 ClassIsland.PluginSdk.targets 的 `CreateCipx` Target 在构建后生成（p4-02 §2.1）；dotnet 构建被沙箱阻断 → 无法触发打包。手动安装路径说明已转 p4-03 文档（p4-02 §2.3）。
- **登记**：打包产物体积（`.cipx` 文件字节数）**未能执行，如实空缺**；待环境恢复后以 `dotnet build … -p:CreateCipx=true`（后备模式）产出并补记。此环境缺口与 p3-10 §6 G1/G3/cipx、p4-02 §5.9-5.10 登记一致，不阻塞发布就绪（用户裁定口径）。

### 3.3 obj/bin 清理建议（发布前清理面清单，只读建议不执行）

| # | 清理项 | 现状实测 | 建议 |
| --- | --- | --- | --- |
| 1 | Win 输出目录 NuGet 后备实验残留 | `bin\Release\net10.0-windows10.0.19041.0\Microsoft.Windows.SDK.NET.dll`（24,877,600 B）+ `WinRT.Runtime.dll`（528,944 B）在位 | 该两项为 NuGet 后备分支实验的运行时复制残留（p1-07 §5.1 口径警示：**不代表默认本地检出形态插件产物体积**；默认形态 Private=false / ExcludeAssets 不复制宿主/运行时 DLL）。发布（手动装载目录 / cipx）前建议在干净输出上重建，或以默认形态核对是否应含——勿让 24.8 MB 残留进入插件目录 |
| 2 | 裁量后重建缺失 | 现 DLL 为阶段 3 裁量前产物（§3.1） | 环境恢复后执行一次真实重建（NuGet 后备 Win/Linux）覆盖，产出 O-9/O-5 后体积——转工部/门下省终验衔接 |
| 3 | obj 中间产物面 | obj 含 Debug/Release 全量中间产物 + 后备构建 assets（`project.assets.json` mtime 2026-09-04T06:14:45Z = p3-10 残留，libraries 闭包见 §4.1） | 打包前 `dotnet clean` 或删 `obj\Release` 后重建，保证 cipx 只含干净编译面；obj 为可再生物不入版本控制建议 |
| 4 | cipx 产物目录 | 不存在 | 发布打包待环境恢复后执行 CreateCipx=true 构建，产物目录为 `src\SystemTools.CrossPlatform\cipx\SystemTools.CrossPlatform.cipx`（p4-02 §2.1/§2.3） |

- 以上为**只读建议清单**，本任务零删除/零写入产品面；执行归属工部发布面（p4-02 承接项）。

## 4. 依赖发布面终核（任务 3）

### 4.1 NuGet 后备解析面声明性复核（静态）

**（a）声明面（csproj 双形态对偶）**：

| 模式 | 声明 | 发布行为语义 | 与输出一致性（实测） |
| --- | --- | --- | --- |
| 默认（本地检出） | ProjectReference `Private=false`（:51） | 宿主自带 SDK 程序集，插件输出不复制宿主 DLL | 双 TFM 输出目录**零 ClassIsland*.dll** ✓ |
| 后备（NuGet） | PackageReference `ClassIsland.PluginSdk 2.1.1.1` + `ExcludeAssets=runtime;native`（:63-65） | 同上语义（排除 runtime/native 资产，不复制宿主 DLL） | 双 TFM 输出目录**零 ClassIsland*.dll** ✓ |

- 两分支语义对偶一致：无论走检出还是 NuGet，插件输出目录均不含宿主程序集——与宿主动态加载模型（EnableDynamicLoading=true）及原插件先例（源 SystemTools.csproj:44/161-167）同构。
- **零宿主 DLL 复制实测**：`bin\Release` 递归检索 `ClassIsland*.dll` = **0 命中**（Win/Linux 双目录均无）。

**（b）解析可达声明性证据**：
- NuGet 缓存 `C:\Users\0\.nuget\packages\classisland.pluginsdk\2.1.1.1\` 在位：nuspec **version=2.1.1.1 / id=ClassIsland.PluginSdk**，含 build/ 与 lib/ 资产 → 后备 PackageReference 声明可解析（p3-10 已用该包实际构建 exit=0 实证，非仅声明）。
- 本工程 obj `project.assets.json`（p3-10 后备构建残留，mtime 2026-09-04T06:14:45Z）闭包实测含：**ClassIsland.PluginSdk/2.1.1.1、FluentAvaloniaUI/3.0.0、CommunityToolkit.Mvvm/8.2.1、ClassIsland.Markdown.Avalonia/12.0.0、Avalonia/12.1.1** —— 后备解析面对全部消费包自足（与 p2-07 §2 / p1-07 §3.5 佐证口径一致）。

**（c）边界声明**：真实 `dotnet restore`/NuGet 图走查在本会话沙箱被阻断（命名管道），本复核为**声明性静态核对**（声明 → 缓存 nuspec → 既有解析闭包三角验证）；最终发布解析 exit=0 证据由 p3-10 承载、裁量后重建待环境恢复。

### 4.2 PluginSdk 2.1.1.1 与 manifest apiVersion=2.0.0.0 兼容性声明一致性

| 核对点 | 声明/事实 | 一致性 |
| --- | --- | --- |
| 宿主 API 加载下限 | `2.0.0.0`（U3 检出 `ClassIsland\Services\PluginService.cs:168-171`，`< 2.0.0.0` 判 Error；p0-01 §5.3 / p0-05 §5.2 工具输出 `host-api-version-floor: 2.0.0.0`） | — |
| manifest apiVersion | `2.0.0.0`（源 manifest.yml:36，p0-05 A4 断言 PASS；SHA256 三份一致 `142CD419…AAC`，本任务复测） | **= 基线下限**，合法、不虚报更高契约（p0-05 §3 #7） |
| 编译/打包 SDK 面 | NuGet 后备 `ClassIsland.PluginSdk 2.1.1.1` = 检出 commit `a8af81ba…` 对应 SDK 面（p0-01 §1.2 / p0-05 §8）；p0-05 用宿主 ClassIsland.Core **2.1.1.1** 二进制反序列化新 manifest 通过 A4 | 2.1.1.1 SDK 面 ≥ 2.0.0.0 apiVersion 声明 —— **无版本倒挂** |
| 源插件对照 | 源 manifest apiVersion=2.2.0.0（高于下限），新插件取下限 2.0.0.0 = 与 U3 检出 API 面精确对齐（p0-05 §3 #7） | 声明级一致，无兼容性冲突 |

**结论**：manifest `apiVersion=2.0.0.0` 声明与 PluginSdk 2.1.1.1（检出/NuGet 双形态同版本）所代表的宿主 API 面一致——取 U3 基线下限，不低于下限、不高于 SDK 面，声明与编译/打包依赖面无冲突。运行时端到端装载（宿主实际加载判 apiVersion）仍属 p4-02/门下省终验环境面（p0-05 §5.5 边界）。

## 5. 四阶段预算链汇总（任务 4）

### 5.1 文件数演进（产品树 src 口径，排除 obj/bin）

| 阶段 | 依据 | 产品文件数 | 净增 | 内容说明 |
| --- | --- | ---: | ---: | --- |
| 阶段 1 末 | p1-07 §5.2 | **152**（114 cs/27 axaml/4 yml/3 png/3 txt/1 csproj） | （阶段 0 基线 3 → +149） | A 档全量 + Plugin.cs 重写 |
| 阶段 2 末 | p2-07 §5.1 | **203**（163 cs/29 axaml/4 yml/3 png/3 txt/1 csproj） | **+51**（49 cs + 2 axaml） | B 档 19 项 + 附属 |
| 阶段 3 末 | p3-07 §5.1 | **203**（同左）+ 仓库级 `docs\coexistence-notes.md` ×1 | **+0 src** / +1 docs | 13 SettingsPage 既有文件改写，零新增源码文件 |
| 阶段 4 终态 | **本任务实测** | **203**（同左，本核对计数 cs=163/axaml=29/yml=4/png=3/txt=3/csproj=1）+ docs ×1 | **+0 src** | p4-01 仅改写 2 既有文件（O-9/O-5），零新增/删除 |

### 5.2 体积演进（插件 DLL 字节数，NuGet 后备真实构建口径）

| 阶段 | 依据 | Win（net10.0-windows10.0.19041.0） | Linux/base（net10.0） | 净增（Win / Linux） |
| --- | --- | ---: | ---: | ---: |
| 阶段 1 末 | p1-10 真实构建（p2-07 §5.3 登记） | 1,349,120 B | 1,349,120 B | —（阶段 0 空壳 5,120 B 起） |
| 阶段 2 末 | p2-10 真实构建（p3-10 §4.2 基线） | 1,489,408 B | 1,486,848 B | +140,288 / +137,728 |
| 阶段 3 末 | p3-10 真实构建 exit=0 | 1,543,680 B | 1,541,120 B | +54,272 / +54,272 |
| 阶段 4 终态 | **现 bin（p4-01 裁量前，§3.1）** | **1,543,680 B** | **1,541,120 B** | 0（注记：预期零/极小，未重建） |

- Win/Linux 差异 2,560 B 为 Windows TFM 引用面差异（p3-10 §4.2 注），跨阶段稳定。
- 阶段 3 净增（+54,272 B / +3.6%）= 共享 VM 74→887 行（+813）+ 6 落点页接线增量（p3-10 §4.2）；阶段 2 净增 = B 档 49 cs + 2 axaml。
- **阶段 4 净增**：O-9/O-5 裁量后体积变化未实测（沙箱阻断）；以 p4-01 §2.3 零行为差异声明 + Roslyn 双轮 error=0 支撑「预期零或极小」，精确值待环境恢复补记（转门下省）。

## 6. 宿主链 obj mtime 零变化复核 + 边界

**宿主链 5 工程 `obj\project.assets.json` mtime 实测（本任务，2026-09-04）**：

| 工程 | mtime (UTC) | p2-07 §6-4 / p3-10 §5.1 基线 | 一致 |
| --- | --- | --- | :-: |
| ClassIsland.PluginSdk | 2026-09-01T07:39:08.054Z | 同 | ✓ |
| ClassIsland.Core | 2026-09-02T05:11:23.902Z | 同 | ✓ |
| ClassIsland.Platforms.Abstractions | 2026-09-01T07:39:07.885Z | 同 | ✓ |
| ClassIsland.Shared | 2026-09-01T07:39:07.885Z | 同 | ✓ |
| ClassIsland.Shared.IPC | 2026-09-01T07:39:07.885Z | 同 | ✓ |

- **插件 obj/bin 零阶段 4 写入**：最新写 = 2026-09-04T06:15:09Z（p3-10 产物）< p4-01 裁量写 06:46:57Z；本任务只读测量零写入。p4-02 构建尝试全部在进程启动前被沙箱拒绝，未产生任何写入（§3.1 注记）。
- 源插件 `E:\My Github Projects\SystemTools` 与宿主检出全程只读；manifest.yml 三份（源 + 双输出目录）SHA256 一致 `142CD419…AAC`。

## 7. 复核指引与命令重放（只读，可重放）

```powershell
# 1) csproj 终态（预期 SHA256 A7220DB4…C38A / 9,952 B / 125 行 / mtime 09-03T18:55:37Z）
Get-FileHash src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -Algorithm SHA256
# 2) 全树 PackageReference（预期唯一真实元素 = csproj:63 后备分支）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object { $_.FullName -notmatch '\\(obj|bin)\\' } | Select-String -Pattern '<PackageReference'
# 3) 产物体积（预期 1,543,680 B / 1,541,120 B，mtime 06:14:12Z / 06:15:09Z）
Get-Item src\SystemTools.CrossPlatform\bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll, src\SystemTools.CrossPlatform\bin\Release\net10.0\SystemTools.CrossPlatform.dll
# 4) 宿主 DLL 零复制（预期 0 命中）
Get-ChildItem src\SystemTools.CrossPlatform\bin\Release -Recurse -Filter 'ClassIsland*.dll'
# 5) NuGet 缓存后备包（预期 nuspec version=2.1.1.1）
Get-Content C:\Users\0\.nuget\packages\classisland.pluginsdk\2.1.1.1\classisland.pluginsdk.nuspec
# 6) obj 闭包自足（预期 PluginSdk 2.1.1.1 / FAUI 3.0.0 / Mvvm 8.2.1 / fork 12.0.0 / Avalonia 12.1.1）
(Get-Content src\SystemTools.CrossPlatform\obj\project.assets.json -Raw | ConvertFrom-Json).libraries.PSObject.Properties.Name
# 7) 宿主链 obj mtime（预期与 §6 表同值）
Get-Item E:\ClassIsland-git-misha\ClassIsland.{PluginSdk\obj,Core\obj,Platforms.Abstractions\obj,Shared\obj,Shared.IPC\obj}\project.assets.json | Select FullName,LastWriteTimeUtc
# 8) 产品树计数（预期 163 cs / 29 axaml / 4 yml / 3 png / 3 txt / 1 csproj = 203）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | Where-Object { $_.FullName -notmatch '\\(obj|bin)\\' }
```

## 8. 边界声明

- 本批写入仅 `.tang/cases/stcp-cross-platform-001/evidence/p4-04-revenue-release-budget.md`；产品文件（csproj/源/资产/manifest/global.json/slnx）**零改动**；宿主检出、源插件、NuGet 缓存全程只读；未触发任何构建/restore/dotnet 子进程（沙箱命名管道边界，p4-02 §1.2 同源，不做绕过）。
- 终态体积以现 bin（阶段 3 裁量前构建）登记并**如实注记**裁量后未重建事实与预期极小增量，转门下省终验知悉；cipx 打包体积未执行如实空缺；obj/bin 清理面为只读建议清单。
- 后备分支真实 NuGet 发布解析最终 exit=0 证据由 p3-10 承载，裁量后重建待环境恢复（工部/门下省衔接）。
- 本文件为批级验证证据，不推进、不审批全局工作流；报尚书省以 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。

## 9. 上报尚书省摘要

- **任务结果**：succeeded（只读测量一次成型）。
- **csproj 终态**：SHA256 `A7220DB4…C38A` / 9,952 B / 125 行 / mtime 09-03T18:55:37Z 逐值在位，阶段 4 零触碰、零新增接线差距。
- **终态体积登记（含注记）**：现 bin = 阶段 3 p3-10 真实产物 **Win 1,543,680 B / Linux 1,541,120 B**（FileVersion 1.0.0.0，mtime 06:14:12Z/06:15:09Z）——为 **p4-01 裁量前构建**；裁量后真实重建受沙箱命名管道阻断未执行，O-9 形态级/O-5 纯注释预期零或极小增量，精确数字待环境恢复补记，**转门下省终验知悉**。cipx 打包体积未能执行，如实空缺（登记面）。
- **依赖终核结论**：全阶段零未授权新增包（全树 PackageReference 唯一真实元素 = csproj:63 后备分支；阶段 4 触达 2 文件 using 面全部入既有闭包/guard 面，产品包字符串零命中）；NuGet 后备解析面声明性复核通过（缓存 nuspec 2.1.1.1 在位、输出目录零宿主 DLL 复制与 ExcludeAssets/Private=false 语义一致、obj 闭包自足）；PluginSdk 2.1.1.1 与 manifest apiVersion=2.0.0.0 兼容性声明一致（= 宿主加载下限，无倒挂）。
- **四阶段预算链摘要**：文件 152→203→203(+1 docs)→203(+1 docs)；体积 1,349,120 → 1,489,408/1,486,848 → 1,543,680/1,541,120（阶段 4 预期零/极小，未重建）。宿主链 5 obj mtime 与基线逐项同值，插件 obj/bin 零阶段 4 写入。
- 边界：全程只读，零产品文件改动，无失败项、无原始报错（构建阻断为环境事实已于 p4-02 登记，本任务不重试）。

## 10. 修订记录

- 初版（p4-04 派工交付，单轮只读测量一次成型）。
