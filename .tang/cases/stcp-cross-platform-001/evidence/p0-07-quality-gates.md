# p0-07 证据：阶段 0 质量门禁基线（刑部 quality-security / verification）

| 项 | 值 |
| --- | --- |
| 案件 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p0-07 · 刑部 justice · quality-security / verification |
| 依赖 | p0-02、p0-03、p0-04 均已记录 succeeded；p0-05 succeeded；p0-06 **failed（环境阻塞：macOS 工作负载 NETSDK1147 + MSB4276 环境噪声，见 `p0-06-build-baseline.md`）**——本证据如实引用其状态，不代为改判，其失败不影响本任务证据面 |
| 权威输入 | 04-spec §S4.1 / §S4.2 / §S5.2；05 合同 0.5.4/0.5.5、CP-0.4/CP-0.5；evidence/p0-02、p0-03、p0-04、p0-06 |
| 工作区 | `E:\My Github Projects\SystemTools-Cross-platform`（唯一写入面 = 本案 evidence/ 目录） |
| 只读面 | 原插件 `E:\My Github Projects\SystemTools`、宿主检出 `E:\ClassIsland-git-misha`、新插件 `src\SystemTools.CrossPlatform\bin\obj`（p0-06 产物，保持现场） |
| 结论 | **succeeded** —— (a) §S4.2 扫描固化为可重放脚本并取得脚手架**零门禁命中基线**；(b) 资产面两 TFM 无禁用包/无 C 档原生资产（Windows TFM 平台投影 runtimepack 如实记录）；(c) 原插件隔离检查**产品面零改动**（差异均有明确外部说明）；(d) 映射计数独立复核**闭合**（62/61/98；E-1/E-2 独立确证） |

---

## 1. 结论速览（对应 05 合同 0.5 验证项）

| 验证项 | 本任务承担部分 | 结论 |
| --- | --- | --- |
| 0.5.4 范围映射核对（CP-0.4） | §6 独立复核 | **闭合**：62 文件 / 62 锚点（每文件 1 处，1 处在注释块内）；61 = A15+B14+C32；98 = A33+B19+C46；E-1/E-2 独立确证 |
| 0.5.5 原插件隔离检查（CP-0.5） | §5 独立复核 | **通过**：git 状态/HEAD 与 p0-02 基线一致；3 个关键文件 SHA256 一致；自主快照 diff 仅 IDE 自主产物；宿主 5 链 obj mtime 与 p0-04/p0-06 基线一致 |
| （新增）§S4.2 门禁工具化 | §2–§3 | **通过**：扫描器固化（38 条规则逐条对应 §S4.2 条款）；脚手架 Source 面 3/3 文件零门禁命中（VERDICT: PASS, exit=0） |
| （新增）资产面抽查（0.5.2 延伸） | §4 | **通过**：两 TFM deps.json/文件清单无 §S4.2 禁用包、无 C 档原生资产；PluginSdk 为已批准依赖且输出不含其 DLL（符合设计） |
| 受阻项 | — | p0-06 环境阻塞（仅引用状态；三平台构建门禁的最终判定属尚书省/门下省职权） |

---

## 2. §S4.2 禁用符号/包名可重放扫描固化

### 2.1 扫描器

固化文件：`.tang/cases/stcp-cross-platform-001/evidence/p0-07-s42-scan.ps1`（PowerShell 7，无外部依赖，纯标准库）。

```powershell
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 `
     -Path <目录或文件> [-Scope Source|Assets|All]
# Source 面：*.cs / *.csproj / *.yml / *.yaml（排除 \bin\ \obj\ \.git\）
# Assets 面：仅 \bin\ 下文件 —— *.deps.json 内容做包名扫描 + 全部文件名做原生资产名扫描
# 退出码：0=门禁命中为零(PASS)；1=存在门禁命中(FAIL)；2=参数错误
```

判定语义（复核方须知）：

1. **符号规则（R/X/I）作用于 .cs 原文（含注释行）**——门禁从严：注释中出现 §S4.2 符号也计命中，由复核人处置（死代码注记即按此浮现，见 §6.1）。
2. **包名规则（P）作用于 .csproj/.yml/.deps.json**；csproj 的 XML 注释（`<!-- -->` 状态机逐行判定）与 YAML `#` 注释行单独标记 `[COMMENT-ONLY]`，**门禁判定只计非注释行命中**，注释提及如实列出（本基线 csproj:79 的 6 处即此类，见 §3）。
3. 原生资产名规则（N）作用于 Assets 面文件名。
4. I 规则为机制观察规则，**不计入门禁命中**，仅供 C 档机制证据交叉验证（§6.2）。

### 2.2 规则 ↔ 04-spec §S4.2 条款映射

§S4.2 原文条款（04-spec.md:63-74）按出现顺序编号 ①–⑩：① `using Windows.Win32 / PInvoke.*`（CsWin32）；② `using System.Windows.Forms` / `.*`；③ `using Microsoft.Win32`（注册表）；④ `using System.Management`（WMI）；⑤ `using System.Speech`；⑥ `using Windows.Media.*`（WinRT：Ocr/Control）；⑦ `using Windows.Security.*`；⑧ `DllImport / LibraryImport`（user32/ntdll/kernel32/psapi/advapi32/winbio/gdi32）；⑨ Windows 专属进程名（cmd.exe、robocopy.exe、rundll32.exe、shutdown、DisplaySwitch.exe、ffmpeg.exe、SystemTools.VoskWorker.exe）；⑩ Windows 专属包（OpenCvSharp4.runtime.win、DlibDotNet、NAudio.Wasapi 路径）。

| 规则 | 模式（正则） | §S4.2 条款 |
| --- | --- | --- |
| R01 | `using\s+Windows\.Win32\b` | ① |
| R02 | `\bPInvoke\.` | ① |
| R03 | `using\s+System\.Windows\.Forms\b` | ② |
| R04 | `System\.Windows\.Forms\.` | ② |
| R05 | `using\s+Microsoft\.Win32\b` | ③ |
| R06 | `Microsoft\.Win32\.` | ③（放宽为限定成员访问；`Microsoft.Win32.SafeHandles` 属 BCL 跨平台类型，若出现需人工处置，本基线无出现） |
| R07 | `using\s+System\.Management\b` | ④ |
| R08 | `System\.Management\.` | ④ |
| R09 | `using\s+System\.Speech\b` | ⑤ |
| R10 | `System\.Speech\.` | ⑤ |
| R11 | `using\s+Windows\.Media\b\|Windows\.Media\.` | ⑥ |
| R12 | `using\s+Windows\.Security\b\|Windows\.Security\.` | ⑦ |
| R13 | `\bDllImport\b` | ⑧ |
| R14 | `\bLibraryImport\b` | ⑧ |
| R15 | `\bcmd\.exe\b` | ⑨ |
| R16 | `\brobocopy\.exe\b` | ⑨ |
| R17 | `\brundll32\.exe\b` | ⑨ |
| R18 | `\bDisplaySwitch\.exe\b` | ⑨ |
| R19 | `\bffmpeg\.exe\b` | ⑨ |
| R20 | `SystemTools\.VoskWorker\.exe` | ⑨ |
| R21 | `["']shutdown(\.exe)?["']\|\bshutdown\.exe\b` | ⑨（shutdown 在源码中以 `FileName="shutdown"` 引用形态出现；裸标识符子串如 `AdvancedShutdown` 非进程启动，不标记） |
| X01 | `["']cmd["']\|\bcmd\s+/c` | ⑨加强（无 .exe 变体，实测命中 BlackScreenHtmlAction.cs:47 `FileName = "cmd"`） |
| X02 | `["']rundll32["']` | ⑨加强 |
| X03 | `\bSendKeys\b` | ②加强（WinForms SendKeys，命中 ShutdownAction.cs:43） |
| X04 | `["'](user32\|ntdll\|kernel32\|psapi\|advapi32\|winbio\|gdi32)\.dll["']` | ⑧加强（原生库名字符串形态） |
| X05 | `\bGetFfmpegPath\b` | ⑨加强（ffmpeg 原生资产访问器） |
| X06 | `\w+\.bat\b` | ⑨加强（Windows 批处理进程/动态生成，命中 jinyongshubiao.bat、huifu.bat、{id后6位}.bat） |
| X07 | `\bWindowsIdentity\b\|\bWindowsPrincipal\b` | ⑨加强（Windows 身份/提权语义） |
| X08 | `["']runas["']` | ⑨加强（UAC verb） |
| P01–P07 | `CsWin32` / `System\.Management` / `System\.Speech` / `DlibDotNet` / `OpenCvSharp4` / `NAudio\.Wasapi` / `SystemTools\.VoskWorker` | ① / ④ / ⑤ / ⑩ / ⑩ / ⑩ / ⑨（包名与 VoskWorker 运行时；与派工禁用包清单一致） |
| N01 | `(?i)(OpenCvSharpExtern\|DlibDotNetNative\|ffmpeg\|avcodec\|avformat\|avutil\|swscale\|onnxruntime)` | ⑩（原生资产文件名） |
| N02 | `(?i)VoskWorker` | ⑨（VoskWorker 资产文件名） |
| I01–I11 | keybd_event / mouse_event / GetForegroundWindow·SetWindowPos / SystemParametersInfo / ManagementScope·ManagementObjectSearcher / SetWindowsHookEx / CopyFromScreen / IMMDevice·IAudioEndpointVolume / RegisterDeviceNotification / Get-PnpDevice·Disable-PnpDevice·Enable-PnpDevice / Vosk | 非门禁机制观察（C 档依据交叉验证） |

---

## 3. 新插件脚手架零命中基线（Source + Assets）

重放命令与原始输出存档：`evidence/p0-07-scan-scaffold-output.txt`（本节为其判读）。

```powershell
pwsh -NoProfile -File .tang\...\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope All
# 实测（2026-09-03T15:59:25Z）：SourceFiles=3  AssetFiles=12  GateHits=0  CommentOnly=6  InfoHits=0
# VERDICT: PASS (zero gate hits)；exit=0
```

| 文件 | 门禁命中 | 说明 |
| --- | --- | --- |
| `src\SystemTools.CrossPlatform\Plugin.cs` | 0 | 22 行最小入口，无任何符号/包名命中 |
| `src\SystemTools.CrossPlatform\manifest.yml` | 0 | 23 行，注释与字段均无命中 |
| `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | 0（另 6 处 COMMENT-ONLY） | XML 注释豁免后非注释行零命中 |

**COMMENT-ONLY 6 处明细（非门禁命中，如实留痕）**：csproj **:79**（p0-04 决策留痕注释块）同一行出现 `CsWin32、System.Management、System.Speech、DlibDotNet、OpenCvSharp4*、NAudio.Wasapi` 六个包名（P01–P06 各 1 处）——该行为 2026-09-03 p0-04 §10 修订时写入的「S4.2 禁用包默认模式不进入本工程」决策记录，属说明性注释，非引用声明；`-getItem:PackageReference = []`（p0-04 §2/§10.4）佐证。P07（SystemTools.VoskWorker）在注释中无 `SystemTools.` 前缀全名，未命中，符合文本事实。

**零命中属预期**（当前源码仅 Plugin.cs 最小入口），本基线的价值 = 阶段 1 逐文件门禁的规则与工具预演：阶段 1 每纳入一个 A 档文件，重放同一命令即得该文件门禁状态。

工程文件当前状态注记：csproj **:100-111** 已含 `<OutputType>Library</OutputType>` 修复（注释记录 p0-06 发现的 `CrossPlatformProps.props:46-48` Windows Release 注入 `WinExe` → CS5001 缺陷，2026-09-03）；p0-02 证据文件无独立修订节记录该修复，按派工指示**以文件当前内容为准**，与 p0-06 §7 建议一致。该修复与本门禁零命中结论无交互（属性级变更，不触及 §S4.2 符号面）。

---

## 4. bin\Release 资产面抽查（p0-06 产物，两平台 DLL）

p0-06 判 failed（macOS 环境阻塞），故仅有 **net10.0（Linux）与 net10.0-windows10.0.19041.0（Windows）** 两个 TFM 输出，共 12 文件（实测清单）：

```
bin\Release\net10.0\                              manifest.yml(1430B) · SystemTools.CrossPlatform.deps.json(469B)
                                                  · SystemTools.CrossPlatform.dll(5120B) · .pdb(17772B) · .runtimeconfig.json(377B)
bin\Release\net10.0-windows10.0.19041.0\          同上 5 文件 + Microsoft.Windows.SDK.NET.dll(24,877,600B) · WinRT.Runtime.dll(528,944B)
```

| 检查 | 结果 |
| --- | --- |
| deps.json 包名扫描（P01–P07，Assets 面原始 JSON） | **零命中**（两 TFM 均无 CsWin32/System.Management/System.Speech/DlibDotNet/OpenCvSharp4*/NAudio.Wasapi/VoskWorker） |
| 文件名原生资产扫描（N01/N02） | **零命中**（无 ffmpeg/avcodec*/OpenCvSharpExtern/DlibDotNetNative/vosk/onnxruntime 等 C 档原生资产） |
| `net10.0\...\deps.json` 内容 | libraries 仅 `SystemTools.CrossPlatform/1.0.0`（project），**无任何包依赖** —— Linux 输出无原生/Windows 资产 |
| `net10.0-windows10.0.19041.0\...\deps.json` 内容 | 除本插件外仅 `runtimepack.Microsoft.Windows.SDK.NET.Ref/10.0.19041.57`（runtimepack：Microsoft.Windows.SDK.NET.dll + WinRT.Runtime.dll） |
| manifest.yml 接线 | 两 TFM 输出目录均含 manifest.yml（p0-05 `CopyToOutputDirectory=Always` 生效） |
| PluginSdk | **已批准依赖，如实记录**：默认模式为 U3 检出 ProjectReference（`Private=false`）、后备模式为 NuGet 包 2.1.1.1（`ExcludeAssets=runtime;native`）——两种形态下宿主运行时自带 SDK 程序集，**插件输出不含 PluginSdk DLL**，两份 deps.json 亦无其条目，符合 p0-02 §4/p0-04 §10 的设计声明 |

**观察（如实记录，非门禁失败项）**：Windows TFM 输出携带 `Microsoft.Windows.SDK.NET.dll`/`WinRT.Runtime.dll`（deps.json 中 `runtimepack.Microsoft.Windows.SDK.NET.Ref/10.0.19041.57`）。该 runtimepack 是 `net10.0-windows10.0.19041.0` 目标框架**自动隐含的 WinRT 投影运行时**（`-windows` TFM 的平台条件基线载荷，宿主 ClassIsland 桌面端同样基于它运行），**不属于 §S4.2 ⑩ 禁用包清单成员**（CsWin32 为源生成器包，与此 runtimepack 非同一物），且仅存在于 Windows 输出目录、Linux 输出为零。若门下省认为 WinRT 投影面需在规范层面显式表态，属规范修订事项，本证据仅记录事实。

---

## 5. 原插件隔离检查（CP-0.5，独立复核，不沿用吏部快照为唯一证据）

### 5.1 版本控制状态（重放：`git -C 'E:\My Github Projects\SystemTools' status --porcelain` / `rev-parse HEAD`）

| 项 | p0-02 §9.1 基线 | 本任务实测（2026-09-03） | 结论 |
| --- | --- | --- | --- |
| HEAD | `0f92d1d4b8cd9a0aa9bc79d9d5e16884fb19eeed` | 同 | ✅ 一致（log -1：`2026-09-02 14:44:12 +0800` "proj: 构建修复之四"） |
| status --porcelain | ` M .idea/.idea.SystemTools/.idea/workspace.xml` + `?? .tang/` | 同，且**仅此两项** | ✅ 一致（均为 p0-02 已记录的既有外部项，非本阶段产生） |

### 5.2 `?? .tang/` 查明（派工点名事项）

源插件仓库内 `.tang/` 仅含 **1 个文件**：`.tang\workspace-knowledge.md`（1250B，CreationTimeUtc=**2026-09-02T15:11:20.72Z**，LastWriteTimeUtc 同秒）。

- 内容判读：这是 **DSH Tang 运行时的「工作区知识案卷」空脚手架**——索引区为「暂无可复用知识」，数据区 base64 解码为 `{"version":1,"entries":[]}`（零条目），**不含任何案情、代码或配置内容**。
- 归属判断：本案（stcp-cross-platform-001）的会话工作区是 `E:\My Github Projects\SystemTools-Cross-platform`，其自身 `.tang\workspace-knowledge.md` 独立存在（实测在位）；源插件仓库内的这份创建于 2026-09-02T15:11Z，且已被 p0-02 工作后快照（736 行）原样收录（见 §5.4 diff 为证）——即它**先于阶段 0 各部执行而存在**，是**另一次以源插件目录为工作区的会话留下的空运行时文件**，与本案阶段 0 执行**无关**。
- 处置建议（如实上报，不越权处理）：属未跟踪的外来运行时文件，不影响 CP-0.5（非工程/manifest/配置/源码）；是否清理由用户/尚书省决定，本任务未做任何改动。

### 5.3 关键文件 SHA256 复核（对照 p0-02 §9.1 截断记录值）

| 文件 | 本任务实测 SHA256（完整值） | p0-02 记录 | 一致性 |
| --- | --- | --- | --- |
| `SystemTools.csproj` | `E59323555D41CAADC6D0080767EAF1BD0A1234846C73EF69021E78B0E87012F8` | `E5932355…2F8` | ✅ |
| `manifest.yml` | `13A2E178B7BB3CF45F2D8678E34B20AAC7393A1FA65E3B4F594A916D1948A985` | `13A2E178…985` | ✅ |
| `Plugin.cs` | `72751F10B898C07BBF8F5C7958AB393BA5101AE251807341B31D801158C8457E` | `72751F10…E` | ✅ |

### 5.4 自主全树快照对比（版本控制差异之外的文件级复核）

重放命令（本任务执行存档：`evidence/p0-07-original-plugin-snapshot-p007.txt`，736 行）：

```powershell
$root='E:\My Github Projects\SystemTools'
$snap = Get-ChildItem $root -Recurse -File -Force | Where-Object { $_.FullName -notmatch '\\\.git\\' } |
        ForEach-Object { $_.FullName.Substring($root.Length+1) + '|' + $_.Length + '|' + $_.LastWriteTimeUtc.ToString('o') } | Sort-Object
$old = Get-Content '.tang\cases\stcp-cross-platform-001\evidence\p0-02-original-plugin-snapshot-after.txt'
(Compare-Object -ReferenceObject $old -DifferenceObject $snap)   # 与 p0-02 工作后基线逐行差集
```

实测：双方各 **736 行**；`Compare-Object` 差集 **10 行 = 5 个文件的时间戳/大小变化**，逐条归因如下——**工程、manifest、配置、源码、资产零变化**：

| 文件 | p0-02 基线 → 本任务实测 | 归因 |
| --- | --- | --- |
| `.idea\.idea.SystemTools\.idea\workspace.xml` | 31102B@09-02T06:50:10Z → 31162B@09-03T15:10:55Z | Rider IDE 会话状态自主写入（即 §5.1 既有 ` M` 项的延续；IDE 文件，非插件产物） |
| `obj\rider.project.model.nuget.info` | 20B@09-02T04:10:27Z → 20B@09-03T14:47:58Z | Rider IDE 后台 restore 元数据（大小未变） |
| `obj\rider.project.restore.info` | 20B@09-02T05:11:23Z → 20B@09-03T14:47:58Z | 同上 |
| `obj\Debug\...\SystemTools.AssemblyInfo.cs` | 1184B@09-02T06:30:11Z → 1184B@09-03T14:47:54Z | Rider IDE 设计时构建产物（大小未变） |
| `obj\Debug\...\SystemTools.AssemblyInfoInputs.cache` | 66B@09-02T06:30:11Z → 66B@09-03T14:47:54Z | 同上 |

归因依据：以上 5 文件均为 IDE 状态/obj 中间产物（`obj\`、`.idea\` 均不在 git 跟踪内）；写入时刻（09-03T14:47~15:10Z）与本阶段各部对源插件的只读操作（git status/rev-parse/log、Get-ChildItem、Get-Content、Select-String、Get-FileHash）无因果——这些操作不产生写入；p0-02 基线之后**任何源码/工程/manifest/配置文件零差异**。

### 5.5 宿主检出 5 链工程 obj mtime 复核（对照 p0-04 §7.3 / p0-06 §8 基线）

| 工程 | p0-04/p0-06 基线 | 本任务实测（UTC） | 一致性 |
| --- | --- | --- | --- |
| ClassIsland.PluginSdk | 2026-09-01T07:39:08Z | 2026-09-01T07:39:08.0547438Z | ✅ |
| ClassIsland.Core | 2026-09-02T05:11:23Z | 2026-09-02T05:11:23.9027056Z | ✅ |
| ClassIsland.Platforms.Abstractions | 2026-09-01T07:39:07Z | 2026-09-01T07:39:07.8858490Z | ✅ |
| ClassIsland.Shared | 2026-09-01T07:39:07Z | 2026-09-01T07:39:07.8858490Z | ✅ |
| ClassIsland.Shared.IPC | 2026-09-01T07:39:07Z | 2026-09-01T07:39:07.8858490Z | ✅ |

### 5.6 隔离结论

阶段 0 全程（p0-02 脚手架 → p0-03 映射 → p0-04 依赖 → p0-05 manifest → p0-06 构建 → p0-07 本任务）：原插件 **HEAD 未变、git 跟踪面仅既有 2 项外部状态、产品面（源码/工程/manifest/配置/资产）快照零差异、关键文件 SHA256 一致**；宿主检出 5 链 obj 零写入。**CP-0.5 通过**——全部差异均有明确非本阶段外部说明（IDE 自主产物 + 外来空运行时文件），无任何本阶段误改。

---

## 6. 映射计数独立复核（CP-0.4，不依赖吏部结论重放）

### 6.1 文件数 / 注册锚点 / 死代码注记

```powershell
(Get-ChildItem 'E:\My Github Projects\SystemTools\Actions' -Filter '*.cs' -File).Count   # => 62
(Get-ChildItem 'E:\My Github Projects\SystemTools\Actions' -Directory).Count             # => 0（无子目录）
Select-String -Path 'E:\My Github Projects\SystemTools\Actions\*.cs' -Pattern '\[ActionInfo'   # => 62 处
```

- 文件数 **62** ✅（与 p0-03 §1、05 合同 0.5.4 一致；我的扫描器 SourceFiles 计数亦为 62，双路一致）。
- 锚点 **62 处，每文件恰 1 处**（Group-Object 后 Count≠1 的文件数 = 0）✅。
- `ClickSimulationAction.cs` 锚点在 **:11**；整文件块注释独立复核：全文 **56 行**（55 行内容 + 第 56 行空行），**第 1 行以 `/*using ClassIsland.Core...` 开始、第 55 行为 `}*/` 结束**，其间无任何注释符闭合/重开，`[ActionInfo]`(:11)、类声明(:12)、`[DllImport("user32.dll")]`(:51-52) 全部位于同一对块注释符内 → 编译器不产出该类型，框架无法经 ActionInfo 反射注册 ✅。
- 全仓库引用重放（排除 bin/obj/.git，`Get-ChildItem -Recurse -Filter *.cs | Select-String 'ClickSimulation'`）：命中仅 3 处文件——本文件（注释内）、`Controls\ClickSimulationSettingsControl.cs:9,14`、`Settings\ClickSimulationSettings.cs:5`，后两者引用 **Settings 配置类型**（非 Action 类），不构成对该行动类的编译引用 ✅。**死代码注记 1 条成立，活动功能项 = 62 − 1 = 61。**

### 6.2 扫描驱动的分档交叉验证（我自己的检索构建）

方法：对 `Actions\*.cs` 运行同一扫描器（原始输出存档 `evidence/p0-07-scan-actions-output.txt`：GateHits=171、InfoHits=73），得到「零门禁命中集合」与「命中规则集合」，再与吏部分档逐文件对照。

**零命中集合（24 文件）恰好 = A15 ∪ B11-B14 ∪ C24-C28** ✅：

| 组 | 文件 | 我的机制复核（自己读取/扫描佐证） |
| --- | --- | --- |
| A 档 15 项 | ActionFlowExecutionConfirmation / BackgroundPlayAudio / ClearAllNotifications / FullscreenClock / KillProcess / LoadTemporaryClassPlan / OpenAppSettings / OpenClassSwapWindow / OpenProfileEditor / ShowAiChatDialog / ShowToast / SwitchFloatingWindowTheme / ToggleFloatingWindowProfile / ToggleWorkflow / TriggerCustomTrigger | 全部零门禁命中、零机制观察命中——满足 §S4.2 对 A 档的必要条件（S5.2 反向 grep）；其 SDK/BCL 证据行以吏部 §3.1 为参照一致 |
| B 档服务侧 4 项 | B11 ShowFloatingWindow（:16-21 注入 FloatingWindowService，钩子点在服务侧）、B12 ToggleFloatingWindowLayer（:19-22 纯状态）、B13 AutoSwitchClassIslandTheme（:30-31 配置+GetService\<AdaptiveThemeSyncService\>）、B14 AutoHideMainWindowWhenOccluded（:30-31 配置+GetService\<MainWindowTextOcclusionService\>） | 行动文件本体零 Windows 符号，Windows 点在服务侧——与吏部声明一致 |
| C 档服务/配置侧 5 项 | C24 DisableDevice、C25 EnableDevice（见 §6.5 E-2：PnP PowerShell+UAC，非 WMI）、C26 AutoOpenUsbDriveOnInsert（:30-31 配置+GetService\<UsbAutoPlayService\>）、C27 EnableVoiceWakeAi（:30-31 配置+TryGetService\<AiVoiceConversationService\>）、C28 WakeUpVoiceConversationAi（:10-18 注入+TryStartVoiceConversation） | 行动文件本体零 §S4.2 符号，C 档依据为服务侧 Windows 专属依赖——与吏部声明一致 |

**命中集合（38 文件 = 37 活动 + 1 死代码）逐文件规则 ↔ 吏部声明点对照**（全部一致，无反例）：

| 文件 | 吏部档 | 我的门禁规则（行号） | 与吏部声明点一致性 |
| --- | :-: | --- | --- |
| CopyAction | B1 | R15:30（cmd.exe）、R16:96（robocopy.exe） | ✅ 声明 :96-98 robocopy；:30 cmd.exe 为同文件另一隐藏进程启动点（RedirectStandardOutput/Error，与 :96 同属文件夹/文件复制进程启动族）——依据注记级补充，不改档 |
| MoveAction | B2 | R15:30、R16:96 | ✅ 同 B1 |
| DeleteAction | B3 | R15:29（cmd.exe） | ✅ 声明 :29 |
| ShutdownAction | B4 | R03:7、R21:32（shutdown）、X03:43（SendKeys） | ✅ 声明 :32/:43 |
| AdvancedShutdownAction | B5 | R15:165（cmd.exe /c timeout…& shutdown）、R21:207、:395 | ✅ 声明 :207/:395；:165 为同族 cmd 包装启动点——依据注记级补充，不改档 |
| CancelShutdownAction | B6 | R21:29 | ✅ 声明 :29-30 |
| LockScreenAction | B7 | R17:29（rundll32.exe） | ✅ 声明 :29-30 |
| ImmediateRestartAction | B8 | R01:8、R13+X04:16（ntdll.dll DllImport）、R02:28（ExitWindowsEx）、R21:38（注释行） | ✅ 声明 :16-17/:23/:28 |
| ImmediateShutdownAction | B9 | 同 B8 形态 | ✅ |
| SleepAction | B10 | R17:23 | ✅ 声明 :23-24 |
| AltF4/AltTab/CtrlZ/EnterKey/Esc/F11Action | C1–C6 | R01+R02（PInvoke.keybd_event VK_*） | ✅（F11 详见 §6.4 E-1） |
| SimulateKeyboard/SimulateKeyCombination/SimulateMouse/TypeContent/WindowOperation | C7–C11 | R01+R02（+R13/X04 注释行残留；SimulateMouse 另 X06:38/:179 jinyongshubiao/huifu.bat） | ✅ 声明 using Windows.Win32 + PInvoke 注入；C9 依吏部注记含服务侧批量执行 bat |
| DisableMouse/EnableMouseAction | C12/C13 | X06:29（jinyongshubiao.bat / huifu.bat） | ✅ 声明 :29 |
| Clone/Extend/Internal/ExternalDisplayAction | C14–C17 | R18:30/:53（DisplaySwitch.exe） | ✅ |
| BlackScreenHtmlAction | C18 | R01:13、X01:47（`FileName="cmd"` + /c start）、R02:64/:66（VK_F11）、R13/X04:87（注释） | ✅ 声明 :47-48/:64-67 |
| ShowDesktopAction | C19 | R01:10-11、R02:29-38（VK_LWIN/VK_D） | ✅ |
| AdjustScreenBrightnessAction | C20 | R07:5（using System.Management）+ I05:75/:79（ManagementScope root\wmi） | ✅ |
| ChangeWallpaperAction | C21 | R05:4、R01:14、R02:169（SystemParametersInfo） | ✅ |
| SwitchThemeAction / SwitchSystemAccentColorAction | C22/C23 | R05:4（C23 另 R13+X04:19 user32 DllImport——同 C 档 Win32 个性化机制族） | ✅ |
| ScreenShotAction | C29 | R03:6 + I07:53（CopyFromScreen） | ✅ |
| SetVolume | C30 | R01:11（using Windows.Win32）+ I08（IMMDevice/IAudioEndpointVolume 自定义 Core Audio COM 接口 :62-218） | ✅ |
| CameraCaptureAction | C31 | X05:48（GetFfmpegPath）、R19:52（找不到 ffmpeg.exe 校验） | ✅ 声明 :48-52/:57 |
| RestartAsAdminAction | C32 | X08:33（Verb="runas"）、X07:63-64（WindowsIdentity/WindowsPrincipal） | ✅ 声明 :33/:63-64 |
| ClickSimulationAction | 死代码 | R13+X04:51-52、I02:38-52 | ✅ 全部位于整文件注释块内（§6.1），不计活动项 |

**分档判定式复核结论**：A 档 15 项全部通过 §S4.2 反向扫描（无任何命中）；全部命中文件的规则类别均落在其吏部声明的「Windows 专属点」机制族内（进程启动/注入/注册表/WMI/WinForms/COM/提权），未发现任何「A 档文件含禁用符号」或「命中文件机制与分档矛盾」的反例。**我的独立检索支持 A15 + B14 + C32 = 61 的行动分档。**

### 6.3 计数闭合（61 与 98）

- 行动域：62 文件 = **61 活动项 + 1 死代码注记**；61 = **A15 + B14 + C32**（吏部 §3 分档表行数独立清点：A1–A15=15、B1–B14=14、C1–C32=32，8a 13+8b 7+8c 6+8d 2+8e 4=32）✅ —— 与 04-spec §S4.1 行动行、05 合同 0.5.4 一致。
- 全案（非行动域按 06 L513-550 C46 展开说明核对）：
  - A33 = 主题 3 + 组件 6 + 规则 4 + 触发器 1 + 行动 15 + 服务/设置页聚合 4（06 L547）= **33** ✅
  - B19 = 触发器 1 + 行动 14 + 服务/悬浮窗/更多选项 4（06 L548）= **19** ✅
  - C46 = 组件 1 + 规则 1 + 触发器 5 + 行动 32 + 服务/认证 7（06 L533/L549；服务/认证 7 项 = UsbAutoPlayService、KeywordSpeechService(SAPI)、VoskSpeechService(VoskWorker)、人脸服务+验证器(合并1)、Hello 服务+验证器(合并1)、SystemMemoryCleanupService、MainWindowBackgroundCaptureService，06 L523）= **46** ✅
  - **98 = 33 + 19 + 46** ✅（06 L550 与 04-spec §S4.1 总计行一致）；38 阅读条目 → 46 的差项口径（+5 常用模拟键展开、依赖下载管理聚合不计项、服务展开、人脸/Hello 去重）按 06 L535-541 独立复算成立。

### 6.4 勘误 E-1 独立验证（F11 为独立活动文件）

我自己的结论：**E-1 成立**。`Actions\F11Action.cs` 为独立活动行动文件（全文 39 行）：`:11` `[ActionInfo("SystemTools.F11Key", "按下 F11 键", "\uEA0B", false)]`，`:24-26` `PInvoke.keybd_event(VK_F11,…)`（我的扫描 R01:7/R02:24/:26 独立佐证）。`BlackScreenHtmlAction.cs:44-67`（我自己读取）确为「黑屏 html」行动自身行为：`:47` `FileName="cmd"` + `/c start` 打开 black.html 后，`:61-67` 发送 F11 自动全屏——该 F11 注入服务于黑屏行动，**不承担常用模拟键 F11 的注册职责**。06 L527「F11 的源码仍在 BlackScreenHtmlAction」属索引级误记，E-1 修正正确；展开后 8a 仍 13 项、常用模拟键 6 个源文件（AltF4/AltTab/CtrlZ/EnterKey/Esc/F11）映射成立，**档位与计数零影响**。

### 6.5 勘误 E-2 独立验证（禁用/启用硬件设备 = PnP PowerShell + UAC，非 WMI）

我自己的结论：**E-2 成立**。两文件（各 89 行，结构对称）我自己全文读取：

- 动态生成 `{id后6位}.bat`/`{lastSixChars}.ps1`（DisableDeviceAction.cs:33-36、:58-59）与 `Enable_{lastSixChars}.bat`/`.ps1`（EnableDeviceAction.cs:33-36、:58-59）；
- bat 内容（两文件 :38-47）：`net session >nul 2>&1` 管理员检查 + 非管理员时 `powershell -Command "Start-Process -FilePath '%~0' -Verb RunAs"` UAC 提权重启，再以 `powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass` 执行 ps1；
- ps1 内容（两文件 :49-56）：`Get-PnpDevice | Where-Object {…InstanceId…}` + `Disable-PnpDevice` / `Enable-PnpDevice`（我的扫描 I10 机制观察规则在两文件 **:49、:52** 各命中，独立佐证）；
- **无 WMI**：两文件 using 块（:1-11）无 `System.Management`，扫描 R07/R08 **零命中**，机制观察规则 I05（ManagementScope/ManagementObjectSearcher）在两文件**零命中**——02 §4.4「WMI」依据注记确属误记，真实 Windows 专属点 = Windows PowerShell PnP cmdlet + UAC 管理员提权；**C 档结论不变**（Windows 专属设备管理语义），与吏部登记一致。

---

## 7. 阶段 0 质量门禁综合结论

| # | 门禁项 | 结论 |
| --- | --- | --- |
| 1 | §S4.2 扫描固化 + 脚手架零命中基线（0.5.2/CP-0.2 延伸） | **通过**（GateHits=0；csproj:79 注释提及 6 处已标记留痕；工具与规则可重放） |
| 2 | 资产面抽查（两 TFM deps.json + 文件清单） | **通过**（无禁用包、无 C 档原生资产；PluginSdk 已批准依赖如实记录；Windows TFM 平台投影 runtimepack 事实记录见 §4 观察） |
| 3 | 原插件隔离检查（CP-0.5 / 0.5.5） | **通过**（产品面零改动；差异均有明确非本阶段外部说明：Rider IDE 自主产物 ×5、外来空 `.tang` 脚手架 ×1） |
| 4 | 映射计数独立复核（CP-0.4 / 0.5.4） | **通过**（62/62 锚点/死代码 1；A15+B14+C32=61；A33+B19+C46=98；E-1/E-2 独立确证） |
| 5 | 三平台构建门禁（0.5.1/CP-0.1） | **受阻（环境）**——p0-06 判 failed：macOS 目标缺 `macos` 工作负载（NETSDK1147），标准路径受 MSB4276 环境噪声阻塞；Windows/Linux 两目标经 NuGet 后备分支已证实可编译。本任务按职权**仅引用该状态，不代为判定或修复**；处置属尚书省/门下省 |

阶段 1 逐文件门禁预演说明：纳入每个新源文件后重放 §2.1 命令即可复现门禁判定；X 加强规则（cmd/runas/.bat/身份提权等）已在本轮 62 文件全体量上验证了与吏部声明点的对齐度，可直接作为阶段 1 的门禁输入。

## 8. 复核指引（另一复核方重放清单）

1. 脚手架扫描：`pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope All` → 预期 exit=0、GateHits=0、CommentOnly=6（csproj:79）。
2. Actions 交叉扫描：同脚本 `-Path 'E:\My Github Projects\SystemTools\Actions' -Scope Source` → 预期 GateHits=171、InfoHits=73、零命中 24 文件清单 = §6.2。
3. 计数：`Get-ChildItem ...\Actions -Filter *.cs`（62）；`Select-String -Pattern '\[ActionInfo'`（62，每文件 1）；读取 `ClickSimulationAction.cs`（56 行，:1 `/*` 起、:55 `}*/` 止）。
4. 隔离：`git -C 'E:\My Github Projects\SystemTools' rev-parse HEAD / status --porcelain`；`Get-FileHash` 三文件对照 §5.3；§5.4 快照命令 + `Compare-Object`（预期同 10 行 IDE 差异或其后无新增产品差异）；宿主 5 链 obj mtime 对照 §5.5。
5. E-1/E-2：读取 `Actions\F11Action.cs`、`Actions\BlackScreenHtmlAction.cs`(:40-70)、`Actions\DisableDeviceAction.cs`、`Actions\EnableDeviceAction.cs`。

## 9. 只读声明与产出清单

- 原插件与宿主检出全程只读（git 只读子命令、列举、读取、哈希）；新插件 `src\SystemTools.CrossPlatform\bin\obj`（p0-06 现场）未做任何清理或修改，仅只读扫描。
- 本任务写入（全部位于本案 evidence/）：本文件、`p0-07-s42-scan.ps1`（固化扫描器）、`p0-07-scan-scaffold-output.txt`、`p0-07-scan-actions-output.txt`、`p0-07-original-plugin-snapshot-p007.txt`（自主快照）。
- 无未决阻塞问题；本任务不推进、不审批全局工作流。

---

## 10. 修订 R-1（2026-09-03）：扫描器单文件路径模式缺陷修复（p1-02 §5.3-1 上报，p1-08 逐文件门禁前置）

### 10.1 缺陷来源

p1-02-war-rules-triggers.md §5.3-1（兵部上报）：`p0-07-s42-scan.ps1` 的 `-Path` 指向**单个文件**时，脚本 :95 对 `FileInfo` 调用不存在的实例方法 `GetDirectoryName()`，抛 `MethodInvocationException`、exit=1。该分支未被 p0-07 阶段的目录级扫描触发（p0-07 各路均以目录为 `-Path`），故原基线结论不受影响；p1-02 批次曾以属主目录 `Settings\` 替代绕行，并建议刑部修复。

### 10.2 修复内容（最小单行改动）

```diff
- $rootPrefix = if ($item.PSIsContainer) { $item.FullName.TrimEnd('\') + '\' } else { $item.GetDirectoryName() + '\' }
+ $rootPrefix = if ($item.PSIsContainer) { $item.FullName.TrimEnd('\') + '\' } else { $item.DirectoryName + '\' }
```

仅修复单文件分支的父目录求值（`FileInfo.DirectoryName` 属性，等价语义）；**规则集（R/X/P/N/I）、判定语义（.cs 原文含注释、csproj/yml 注释豁免 + COMMENT-ONLY、I 规则非门禁）、退出码契约（0/1/2）零变化**。

### 10.3 回归验证（输出留档 evidence/）

| 回归 | 命令要点 | 实测 | 结果 |
| --- | --- | --- | --- |
| a) 单文件模式 | `-Path src\SystemTools.CrossPlatform\Plugin.cs -Scope All` | SourceFiles=1、GateHits=0、InfoHits=0、VERDICT: PASS | **exit=0 ✅**（留档 `p0-07-scan-regression-singlefile.txt`） |
| b) 全目录复跑 | `-Path src\SystemTools.CrossPlatform -Scope All` | SourceFiles=**107**（p1-01/p1-02 批次交付后的当前树）、GateHits=**0**、CommentOnly=6（与 p0-07 §3 同一 csproj:79）、InfoHits=0、VERDICT: PASS | **exit=0 ✅**（留档 `p0-07-scan-regression-dir-rerun.txt`） |

**批内一致性**：回归 b 以全目录收口覆盖 p1-01 §5 四路径（Themes / Controls\Components / Models\ComponentSettings / Converters，均 0/PASS）与 p1-02 §5 四路径（含 Settings\，均 0/PASS）所涉全部文件——**零新门禁命中、零新 INFO 命中、与批内结果完全一致；未做任何规则改动以掩盖命中**（也无命中需要掩盖）。

执行方式注记：本轮回归在当前会话内以调用运算符 `&` 直接运行脚本并 `*>` 留档（本会话后段嵌套 `pwsh -File` 受环境命名管道边界阻断，`ResourceUnavailable`）；脚本 `exit` 语义即进程退出码，harness 无非零退出标记即 exit=0。**复核方用法不变**：`pwsh -NoProfile -File <脚本> -Path ... [-Scope ...]` 照常可用。

### 10.4 既有证据效力声明

p0-07 §3（脚手架零命中基线）、§5（隔离检查）、§6（Actions 交叉扫描）及 p1-01/p1-02 的扫描结果均经由**目录模式**产生，不经过被修复分支，全部结论维持有效；本修订仅使**单文件模式**进入可用状态，供 p1-08 起的逐文件门禁直接使用。

---

## 11. 修订 R-2（2026-09-03）：平台条件文件扫描口径（尚书省裁定落档；p1-08 刑部执行）

### 11.1 背景与授权

尚书省补充指令（R-1 先例延续，阶段 2 前置微任务）：扫描口径修订 R-2（平台条件文件）。规范依据链：04-spec §S4.2（04-spec.md:61）预设 B 档「Windows 专属点」允许位；p1-05 §5.1-3 预留阶段 2 条件文件规范（「规范建立归尚书省调度」）；06 条目 49（EmptyWorkingSet 仅 Windows）、条目 46（SystemShutdownMonitor Windows 会话消息路径）；尚书省现激活该预留规范并要求扫描器配套口径，作为 p2-01 条件适配器自检的前置。

### 11.2 规范四条（尚书省裁定）与落地语义

1. **条件文件两形态（仅此两种）**：(a) 全文件 `#if PLATFORMS_WINDOWS`…`#endif` 包裹的 .cs；(b) 文件名 `*Windows.cs` 且全部禁用符号行均处于该 guard 内。落地判定：形态 (a) = 首个非空行（trim 后）恰为 `#if PLATFORMS_WINDOWS` 且末个非空行恰为 `#endif`；形态 (b) = 文件名以 `Windows.cs` 结尾（`-like '*Windows.cs'`）。**guard 行须为裸条件文本**：尾部注释、复合条件（`&&`/`||`）、取反（`!PLATFORMS_WINDOWS`）均不识别为正向 guard（从严——此类行按非 guard 处理，其内命中落 GateHits）。
2. **适用范围仅限 06 明示 Windows-专属行为**（EmptyWorkingSet 条目 49；SystemShutdownMonitor Windows 会话消息路径条目 46；及兵部登记的其他 06 明示项；不得用于规避 BCL/命令行等价可实现的行为）——扫描器**只负责 guard 内/外分流与 CONDITIONAL 逐文件清单留证**，「是否属 06 明示项」由终检（尚书省/门下省）按清单核对，扫描器不承载该业务裁定。
3. **本地接口一律插件命名空间，禁 ClassIsland.* 发明宿主接口；非 Windows 适配器 no-op/降级并留痕**——属实现规范，非本次扫描规则面（扫描器未据此新增检查；如需机器化可在后续修订以 I 类观察规则承载）。
4. **扫描语义**：qualifying 条件文件内、处于正向 `#if/#elif PLATFORMS_WINDOWS` guard 中的 R*/X* 门禁符号命中 → 新计数器 **CONDITIONAL**（逐文件清单留证），不计 GateHits；**guard 外命中、`#else` 分支命中、非两形态文件的内部 guard 命中一律仍为 GateHits（从严不变）**；其余规则（P*/N*/I*）语义零改动。CONDITIONAL>0 时 VERDICT 仍 PASS 但报告列清单；**退出码仍仅由 GateHits 决定**。

落地解释（供复核方与后续修订参照）：

- **CONDITIONAL 适用规则集** = 全部 R*/X* 门禁符号规则（§S4.2 ①–⑨ 符号族；R13/R14 为裁定点名的代表条款，X04/X01/X07 等为其「加强」同族）。P*（包名，作用于 csproj/yml/deps.json）、N*（资产名）、I*（非门禁观察）与 guard 语义无交集或本就不计门禁，维持原语义。理由：两形态文件本身即专门的条件适配文件，其内 §S4.2 符号仅编译于 windows TFM；防滥用由「06 明示项终检核对」承担。若尚书省要求收窄至原生互操作族（R13/R14/X04/R01/R02），属一处集合改动，可再修订。
- **guard 状态机**：`#if`/`#elif`/`#else`/`#endif` 栈式跟踪（嵌套任意层，栈内含 `PW` 即 guarded）；`#else` 将栈顶翻转为 `EL`（非 guarded——`#if PLATFORMS_WINDOWS` 的 else 分支编译于非 Windows，从严不豁免）；`//` 行注释不参与状态更新（防注释内伪指令扰动）；块注释内伪指令未剔除（罕见场景注记：块注释内 `#endif` 会使后续真实 guard 命中从严落 GateHits；块注释内 `#if PLATFORMS_WINDOWS` 会错误开启 guard——复核遇该形态按人工处置）。
- **勘误注记（R-2a，2026-09-03，尚书省裁决对齐；依据兵部 p2-03 §1.4/§6.2 实证 + 刑部独立复核留档 `p1-08-r2a-erratum-note-output.txt`）**：guard 符号以编译生效形态 **`Platforms_Windows`**（宿主 `CrossPlatformProps.props:37` DefineConstants 注入，刑部只读复核同行确证）为规范写法；扫描器 `-match` 大小写不敏感，全大写 `PLATFORMS_WINDOWS` 写法亦被识别为形态 (a) 正向 guard 但因该符号未经 DefineConstants 定义属**死代码形态**，终检按统一口径（`Platforms_Windows`）核对；取反/复合等非正向形态的从严语义不受大小写影响（`#if !Platforms_Windows` 实测仍不识别为正向 guard）。本注记为文档对齐，零扫描器改动、零产品文件改动。

### 11.3 实现改动（最小 diff，7 处，规则集/退出码契约零变化）

| # | 位置 | 改动 |
| --- | --- | --- |
| 1 | 头部注释 | 增 R-2 用法注记（两形态/CONDITIONAL 语义/从严边界） |
| 2 | 输出头 | `Scope` 行后新增 `ScannerRev: R-2 …` 版本行 |
| 3 | 计数器初始化 | 增 `$conditionalCount = 0`、`$conditionalFiles = @{}` |
| 4 | .cs 主循环 | 增两形态资格判定（`$qualifies`：`*Windows.cs` 或全文件裸包裹）+ 逐行 guard 状态机（`$guardStack`，`//` 行跳过）+ 命中三分支：`I*`→INFO / `qualifies -and guarded`→CONDITIONAL / 其余→HIT-GATE |
| 5 | 文件分类 | 增 `if ($fileCond.Count -gt 0) { $conditionalFiles[$rel] = … }` |
| 6 | 摘要与节 | `InfoHits` 行后增 `ConditionalHits:` 行；GATE-HIT FILES 节后增 `--- CONDITIONAL FILES (R-2) ---` 节（空则 `(none)`） |
| 7 | VERDICT | GateHits=0 且 CONDITIONAL>0 时追加 `[CONDITIONAL=N R-2: verify against 06 documented items]`；否则逐字节原样 |

语法复核：PowerShell Parser ParseFile **0 错误**。

### 11.4 回归（零误伤证明，留档 evidence/）

| 回归 | 实测 | 结果 |
| --- | --- | --- |
| 全树 `-Scope Source` 复跑 | SourceFiles=**119**、GateHits=**0**、CommentOnly=6（同 csproj:79）、InfoHits=0、**ConditionalHits=0**、VERDICT: PASS、exit=0 | ✅ 与阶段 1 终态一致 |
| 与阶段 1 终态逐行差集 | Compare-Object 差集**恰 6 行** = 新旧 Time(UTC) 2 行（运行时刻固有）+ R-2 新增 4 行（ScannerRev / ConditionalHits:0 / CONDITIONAL FILES 节头 / (none)）；**其余内容行（摘要计数、GATE-HIT 节、119 文件 ZERO-HIT 清单、VERDICT）逐字节一致** | ✅ 零误伤 |
| 单文件模式：Plugin.cs | 1/0/COND 0/PASS/exit=0 | ✅ |
| 单文件模式：csproj | 1/0 + 6 COMMENT-ONLY（未动）/COND 0/PASS/exit=0（csproj 非 .cs，guard 逻辑不适用，P 规则语义未动） | ✅ |

留档：`p1-08-r2-regression-fulltree-source-output.txt`、`p1-08-r2-regression-plugin-singlefile-output.txt`、`p1-08-r2-regression-csproj-singlefile-output.txt`、`p1-08-r2-regression-diff-vs-stage1.txt`。

### 11.5 合成用例分流验证（5 用例，测毕已删除；输出留档）

| 用例（临时目录 p1-08-r2-selftest\） | 形态/场景 | 内容要点 | 期望 | 实测 | 结论 |
| --- | --- | --- | --- | --- | --- |
| A_FullWrap.cs | (a) 全文件包裹 | guard 内 `using Windows.Win32`+`PInvoke.EmptyWorkingSet`+`DllImport("psapi.dll")` | 4 CONDITIONAL（R01/R02/R13/X04）、GateHits=0 | 同期望；单文件复扫 exit=0，`VERDICT: PASS (zero gate hits) [CONDITIONAL=4 R-2: …]` | ✅ |
| B_FormB_Windows.cs | (b) *Windows.cs 合格 | guard 内 `DllImport("user32.dll")`，guard 外纯 BCL | 2 CONDITIONAL、GateHits=0 | 同期望 | ✅ |
| C_FormB_Violation_Windows.cs | (b) 违规 | guard 内 kernel32 DllImport + **guard 外** user32 DllImport | guard 内 2 CONDITIONAL；guard 外 R13+X04 → 2 GateHits；GetForegroundWindow 保持 INFO | 同期望；单文件复扫 exit=1（GateHits=2）、ConditionalHits=2、InfoHits=1 | ✅ 三路分流正确 |
| D_InternalGuard_Regular.cs | 非两形态文件 | 文件名非 *Windows.cs、非全包裹，仅内部 `#if PLATFORMS_WINDOWS` 包 DllImport | 从严：2 GateHits（两形态之外不豁免） | 同期望 | ✅ |
| E_ElseBranch_Windows.cs | (b) 文件 #else 分支 | `#if !PLATFORMS_WINDOWS #else` 内 gdi32 DllImport | 从严：2 GateHits（else 分支编译于非 Windows） | 同期望（取反条件不识别为正向 guard） | ✅ |
| 目录聚合（5 文件） | — | — | GateHits=6、ConditionalHits=8、InfoHits=1、VERDICT FAIL、exit=1 | 同期望 | ✅ |

用例文件与临时目录已删除（`Test-Path` 复核 False）；原始输出留档：`p1-08-r2-selftest-dir-output.txt`、`p1-08-r2-selftest-a-fullwrap-output.txt`、`p1-08-r2-selftest-c-violation-output.txt`。

### 11.6 边界声明

- 本修订写入：`p0-07-s42-scan.ps1`（尚书省授权的扫描器面）、本文件（§11）、evidence/ 留档 8 文件（§11.4 4 文件 + §11.5 3 文件 + 差集留档）；临时用例目录测毕删除。
- `src\SystemTools.CrossPlatform` 零改动；原插件与宿主检出未触碰；未请求任何沙箱提权。
- p1-05 §5.2-1 的批级重放预期（GateHits=0 / VERDICT: PASS / exit=0）不变；p0-07 §2.1/§3、§10 R-1 既有结论经 §11.4 回归复核维持有效（除 4 行 R-2 新增行外逐字节一致）。
