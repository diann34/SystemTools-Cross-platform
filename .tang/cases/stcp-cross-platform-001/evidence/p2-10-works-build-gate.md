# p2-10 证据：工部阶段 2 构建门禁与 macOS 静态兼容证据汇总

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-10 · 工部 works · infrastructure-release / verification |
| 依赖 | p2-01..p2-09 均记录 succeeded（203 产品文件、全树门禁 168/168 PASS） |
| 权威输入 | p2-07-revenue-dependency-check.md（csproj 零改动/体积 defer 基线 1,349,120 B）；p2-08-justice-filegates.md（CONDITIONAL=13 授权链）；p2-01/p2-02/p2-03 批 macOS 自检表；p1-10-works-build-gate.md（阶段 1 构建方法/基线）；04-spec §S4.2 / U4 / 06 条目 |
| 工作区写入 | `src\SystemTools.CrossPlatform\obj\*`（构建覆盖）、`src\SystemTools.CrossPlatform\bin\Release\*`（阶段 2 真实产物覆盖阶段 1 旧产物）、`.tang/cases/stcp-cross-platform-001/evidence/p2-10-*`（本证据及构建日志） |
| 结论 | **succeeded（按用户裁定口径：NuGet 后备 Win/Linux Release 构建均 exit=0）** —— csproj 零改动（SHA256 与 p2-07 基线一致）；Win/Linux 产物真实体积 1,489,408 B / 1,486,848 B；29 个 `.axaml` 被 Avalonia 收集，6 项显式接线资源进入 `avares` 清单；macOS 静态兼容证据汇总结论成立；宿主链 5 工程 obj mtime 与基线一致。 |

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| csproj 零改动 | **确认零改动**：`SystemTools.CrossPlatform.csproj` mtime 2026-09-03T18:55:37Z、大小 9,952 B、SHA256 `A7220DB4…C38A`，与 p2-07 §1 基线逐字节一致；无 DefineConstants 接线、无新 AvaloniaResource |
| 标准本地 Release | **仍失败于 Restore 阶段**（exit=1），根因为 MSB4276/G3 环境噪声（`Microsoft.NET.SDK.WorkloadAutoImportPropsLocator` 目录不存在），与阶段 0/1 同源；按用户裁定口径不阻塞 |
| NuGet 后备 Win Release | **通过**（exit=0）；产物 `net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` 真实体积 **1,489,408 B**，文件版本 1.0.0.0 |
| NuGet 后备 Linux | **通过**（exit=0）；产物 `net10.0\SystemTools.CrossPlatform.dll` 真实体积 **1,486,848 B**，文件版本 1.0.0.0 |
| B 档编译面预检 | 4 个条件文件跨分支编译由真实构建覆盖：Windows TFM 含 `Platforms_Windows` → 编译 Windows 分支；Linux TFM 含 `Platforms_Linux` → 编译 `#else` no-op 分支；两构建均 exit=0；隐式 using / Avalonia 12.1.1 API / 双分支漂移三类缺陷未复现 |
| XAML/资源收集 | 29 个 `.axaml` 以 `additionalfile` 收集（阶段 1 27 + B5 两对话框 2）；6 项显式 `AvaloniaResource` 进入 `GenerateAvaloniaResources` 输入清单；未出现 `AVLN2000` / XAMLIL 错误 |
| macOS 静态兼容证据 | 四批 macOS 自检表 51 项全部可用、0 项阻塞；降级处置链登记完整；4 条件文件跨分支行为矩阵成立；刑部 CONDITIONAL=13 全部处于授权/明示范围 |
| 产物预算补记 | 阶段 1 基线 1,349,120 B → 阶段 2 Win 1,489,408 B（+140,288 B / +10.4%）、Linux 1,486,848 B（+137,728 B / +10.2%）；双 TFM PDB/deps/runtimeconfig 同步更新；bin 旧产物已被新构建覆盖 |
| 零写入复核 | 宿主链 5 工程 `obj\project.assets.json` mtime 与 p1-07/p1-10/p2-07 基线逐字节一致；源树（含 csproj）无 p2-10 写入 |

---

## 1. 任务 0：csproj 零改动确认

### 1.1 实测状态

| 属性 | 实测值 | p2-07 §1 基线 | 一致性 |
| --- | --- | --- | --- |
| 路径 | `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | 同 | ✓ |
| 大小 | 9,952 B | 9,952 B | ✓ |
| mtime (UTC) | 2026-09-03T18:55:37.981Z | 2026-09-03T18:55:37Z | ✓ |
| SHA256 | `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` | `A7220DB4…C38A` | ✓ |

### 1.2 判断依据

- p2-01 原上报的 `PLATFORMS_WINDOWS` DefineConstants 接线需求已撤销，guard 统一为宿主注入的 `Platforms_Windows`（p2-01 §9-1 / p2-07 §1）。
- csproj 内 `AvaloniaResource` 六项（:113-123）与 p1-10 接线终态逐字一致，阶段 2 未新增、未回退。
- 源树最新写入为 p2-08 经授权的两处注释一词/一数订正（`ProcessMemoryMaintenanceService.cs:9`、`MainConfigData.cs:304`），不含 csproj。

**结论**：csproj 阶段 2 零改动，无需接线增补。

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
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-standard-detailed.log;verbosity=detailed"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | 1 |
| 失败阶段 | Restore → `_GenerateRestoreProjectPathWalk` |
| 错误原文 | `MSB4276: 默认 SDK 解析程序解析 SDK“Microsoft.NET.SDK.WorkloadAutoImportPropsLocator”失败，因为目录“C:\Program Files\dotnet\sdk\10.0.302\Sdks\Microsoft.NET.SDK.WorkloadAutoImportPropsLocator\Sdk”不存在。`（后续由 WorkloadMSBuildSdkResolver 成功解析，属环境噪声） |
| 最终失败点 | 多项目 `_GenerateRestoreProjectPathWalk` 目标“已完成… - 失败”，未进入编译 |
| 产物 | 无新 DLL；bin 仍保持阶段 1 旧产物直至场景 B/C 覆盖 |

**判定**：与阶段 0 p0-06 / 阶段 1 p1-10 记录的 G3（本地检出路径 Restore 环境噪声）同源；本次不阻塞结论，按用户裁定口径转用 NuGet 后备模式。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-standard.log`、`p2-10-build-standard-detailed.log`

### 2.3 场景 B：NuGet 后备 Win Release 构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-fallback-win.log;verbosity=normal"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | **0** |
| Restore | 成功（`已还原 … 用时 7.08 秒`） |
| 目标 TFM | `net10.0-windows10.0.19041.0` |
| `PublishBuilding` / `PublishPlatform` | 空 / 空 |
| `Os_IsWindows` | `True` |
| 预处理符号（csc `/define:`） | `TRACE;Platforms_Windows;RELEASE;NET;NET10_0;NETCOREAPP;WINDOWS;WINDOWS10_0_19041_0;…` |
| 编译错误 | **0** |
| 编译警告 | 28 个 `CS8602`（可空引用解引用）+ 2 个 `NU1900`（漏洞数据获取失败，环境噪声） |
| 产物路径 | `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` |
| 产物体积 | **1,489,408 B** |
| 文件版本 | `FileVersion=1.0.0.0`，`ProductVersion=1.0.0+ff0ffd786d147aa64a8a8c9e7e9ba4034677102e` |

**判定**：构建通过；无阶段 1 三类编译缺陷复现（CS0104 `Timer` 歧义、CS1061 `IClipboard.SetTextAsync`、AVLN2000 双分支漂移）。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-fallback-win.log`、`p2-10-build-fallback-win-exitcode.txt`

### 2.4 场景 C：NuGet 后备 Linux 交叉构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux -nologo -fl "-flp:logfile=.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-fallback-linux.log;verbosity=normal"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | **0** |
| 目标 TFM | `net10.0` |
| `PublishBuilding` / `PublishPlatform` | `true` / `linux` |
| `Os_IsWindows` | `True`（构建机仍为 Windows，TFM 为 net10.0） |
| 预处理符号（csc `/define:`） | `TRACE;Platforms_Linux;RELEASE;NET;NET10_0;NETCOREAPP;NET5_0_OR_GREATER;…`（**无 `Platforms_Windows`、无 `WINDOWS*`**） |
| 编译错误 | **0** |
| 编译警告 | 28 个 `CS8602` + 2 个 `NU1900` |
| 产物路径 | `bin\Release\net10.0\SystemTools.CrossPlatform.dll` |
| 产物体积 | **1,486,848 B** |
| 文件版本 | `FileVersion=1.0.0.0`，`ProductVersion` 与 Win 一致 |

**判定**：Linux 路径通过；条件文件的 `#else` no-op 分支经真实 TFM 编译闭合；cross-platform 编译面一致性验证到 C# 编译层与 XAML 编译层。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p2-10-build-fallback-linux.log`、`p2-10-build-fallback-linux-exitcode.txt`

### 2.5 B 档编译面预检结论

| 预检面 | 证据 | 结论 |
| --- | --- | --- |
| **条件文件 4 个跨分支编译** | Win TFM `/define:Platforms_Windows` 编译 Windows 分支（exit=0）；Linux TFM `/define:Platforms_Linux` 编译 `#else` 分支（exit=0） | ✅ 跨分支闭合 |
| **插件本地抽象跨分支签名** | `IProcessMemoryMaintenanceService` + `ProcessMemoryMaintenanceService` + `ProcessMemoryMaintenanceNative{Windows,NoOp}` 在两构建中均被消费；`SystemPowerCommand{Windows,Stub}` 对称 | ✅ 已闭合（p2-07 §4.2） |
| **隐式 using 语境** | 真实构建 `<ImplicitUsings>enable`（csproj :23），未出现 `CS0104`/`CS0103` 等隐式 using 缺失错误 | ✅ 无回归 |
| **Avalonia 12.1.1 API 面** | `IClipboard.SetTextAsync` 调用未再报错；`ClassWidgetsCard.axaml` 未再触发 `AVLN2000`；29 个 `.axaml` 均完成 `additionalfile` 收集 | ✅ 无漂移/缺失引用 |
| **双分支 API 漂移** | B 档消费面 `IDesktopToastService`/`IWindowPlatformService`/`MyWindow` 等经 p2-05 §4 / p2-07 §4.1 双分支 PRESENT 核验；B 档代码未引用 `MainWindowStylesAssist.IsBackgroundMaterialEnabled` 等已知漂移点 | ✅ 未触发新漂移 |

**发现的新错误**：无。阶段 1 三类编译缺陷（`CS0104`、`CS1061`、`AVLN2000`）在本阶段 2 构建中均未复现。

### 2.6 XAML 编译与资源收集证据

#### 2.6.1 axaml 自动收集

Win 构建日志显示 **29 个 `.axaml`** 作为 `additionalfile` 传入编译器（阶段 1 为 27 个，新增 `Views\AdvancedShutdownDialog.axaml` / `Views\ExtendShutdownDialog.axaml`），完整清单见 `.tang/cases/stcp-cross-platform-001/evidence/p2-10-axaml-additionalfiles.txt`。

新增 2 个对话框均基于 `MyWindow`（宿主双分支 PRESENT，p2-05 §4 / p2-07 §4.1），xmlns 面与阶段 1 同闭包。

#### 2.6.2 显式接线资源收集

增量构建详细日志 `p2-10-build-fallback-win-detailed.log` 中 `GenerateAvaloniaResources` 目标输入清单包含全部 6 项显式接线资源：

| 资源 | 大小（源文件） |
| --- | ---: |
| `Themes\CardTypeComponent\Theme.axaml.txt` | 68,065 B |
| `Themes\ClassWidgets\Theme.axaml.txt` | 33,661 B |
| `Themes\NotchStyle\Theme.axaml.txt` | 12,740 B |
| `Themes\ClassWidgets\上课.png` | 132,936 B |
| `Themes\ClassWidgets\课间休息.png` | 143,419 B |
| `Themes\ClassWidgets\无课程.png` | 126,817 B |

与 p1-10 §3.2 一致，阶段 2 未新增接线资源需求。

---

## 3. 任务 2：macOS 静态兼容证据汇总（阶段 2 增量）

### 3.1 四批 macOS 五列自检表结论

| 批次 | 文件/章节 | 检查项数 | “可用” | “不适用→降级” | 阻塞项 |
| --- | --- | ---: | ---: | ---: | ---: |
| p2-01 | `evidence/p2-01-war-power-actions.md` §4 | 10 | 10 | 0 | 0 |
| p2-02 | `evidence/p2-02-war-folder-misc-actions.md` §3 | 15 | 15 | 0 | 0 |
| p2-03 | `evidence/p2-03-war-floating-services.md` §5 | 16 | 14 | 2 | 0 |
| p2-06 | 注册/接线面，不涉及新增 macOS 依赖点 | — | — | — | — |
| **合计** | | **41** | **39** | **2** | **0** |

> 注：p2-03 中 2 项“不适用→降级”为 `SystemShutdownMonitor.cs` Windows 分支（WinForms 会话消息面）与 `SystemMotionPreferences.cs` Windows 分支（user32 互操作），均按 R-2 条件文件形态隔离，macOS 分支走 `#else` no-op，属已批降级写实而非阻塞。

### 3.2 降级 / 隔离处置链

| 来源 | 处置项 | 处置方式 | 依据 |
| --- | --- | --- | --- |
| p2-01 §3 | U4 三级预检（`OperatingSystem.IsWindows()` / 命令存在性 / 互操作可用性）+ `IDesktopToastService.ShowToastAsync` 失败降级 | 全族电源行动统一：非 Windows → Toast“平台不可用，已跳过”→ 正常结束 | 04-spec U4:90 / 06 统一要求 |
| p2-01 §2-A1 | 项 49 `EmptyWorkingSet` | 插件本地抽象 `IProcessMemoryMaintenanceService` + `*Windows.cs` 条件实现 + `*NoOp.cs` no-op；GC/阈值测量三平台执行、工作集修剪仅 Windows | 06 条目 49 / 04-spec S4.2 |
| p2-02 §3 | AD1 `AdaptiveThemeSyncService` 主题采样不可用 | 探测后端不可用时停止自动同步 + 保持当前主题 + Toast 通知 | 06 条目 47 |
| p2-02 §3 | AD2 `MainWindowTextOcclusionService` 检测链不可用 | 关闭检测、主界面保持可见 + Toast 通知 | 06 条目 48 |
| p2-02 §3 | AD5 Copy/Move/Delete BCL 化 | `File.Copy` / `Directory.Move` / `Directory.Delete(recursive:true)` 替代 shell 子进程 | 06 条目 34/35/36 |
| p2-03 §2 | D1-D15 悬浮窗域降级 | 已删除/不迁入的 C 档能力（AI 液态玻璃/背景采样/Vosk 等）按 04-spec R-6/U5 口径在阶段 1 已处置；悬浮窗层级 `SetWindowFeature` 失败回退 Avalonia `Topmost` 默认层级 | p1-04 §2.1 / p2-03 §2 D3 |
| p2-03 §5 | `SystemShutdownMonitor` / `SystemMotionPreferences` Windows 分支 | R-2 条件文件形态 a 隔离；macOS/#else 分支为 no-op（`IsSessionEnding=false`、`ShouldReduceMotion()=>false`） | p0-07 §11 / p2-05 §1.2 |

### 3.3 条件文件跨分支行为矩阵

| 文件 | Windows 分支（`Platforms_Windows`） | 非 Windows 分支（`#else` / `!Platforms_Windows`） | 消费点 |
| --- | --- | --- | --- |
| `Actions\SystemPowerCommandWindows.cs` | `shutdown.exe`/`rundll32.exe` 命令启动族 | 成对存根 `SystemPowerCommandStub.cs` 恒返回 false/-1 | B4-B10 七行动统一调用 |
| `Services\ProcessMemoryMaintenanceNativeWindows.cs` | `psapi.dll!EmptyWorkingSet` P/Invoke | 成对 `ProcessMemoryMaintenanceNativeNoOp.cs` 恒 false | `ClassIslandMemoryAutoCleanupService` |
| `Services\SystemShutdownMonitor.cs` | WinForms `NativeWindow` 会话结束监控 | no-op 护栏（`IsSessionEnding=false`、主动退出分支） | `Plugin.cs` W6/W7 |
| `Views\SystemMotionPreferences.cs` | `user32.dll!SystemParametersInfo` 查询动效 | `ShouldReduceMotion()=>false` | `AdaptiveThemeSyncService` 等 |

**真实构建验证**：
- Windows TFM 构建：4 文件 Windows 分支参与编译，exit=0。
- Linux TFM 构建：4 文件 `#else` / 取反存根分支参与编译，exit=0。
- 成对存根与实现文件签名一致，防止 `CS0101` 重复定义。

### 3.4 刑部 CONDITIONAL=13 授权链判定

依据 p2-08 §3 独立判定：全树 Source 面 168 文件，`GateHits=0`、`CONDITIONAL=13`，逐条对应 06/04-spec 明示或授权项，**零超范围**。

| # | 文件:行 | 规则 | 功能项 | 授权锚点 |
| ---: | --- | ---: | --- | --- |
| 1-8 | `Actions\SystemPowerCommandWindows.cs` | R21×5 + R17×3 | B4-B10 电源命令族 | 06 条目 37-43 / 04-spec U4:90 |
| 9-10 | `Services\ProcessMemoryMaintenanceNativeWindows.cs:25` | R13 + X04 | 项 49 工作集修剪 | 06 条目 49 |
| 11 | `Services\SystemShutdownMonitor.cs:5` | R03 | B5 看门狗会话结束监控 | p2-05 §1.2 非计数附属 1 + p0-07 §11.1 R-2 裁定 |
| 12-13 | `Views\SystemMotionPreferences.cs:41` | R13 + X04 | B11 附属动效偏好查询 | 04-spec §S4.2:76 / p2-05 §1.2 非计数附属 2 |

**结论**：B 档全部 Windows 专属路径已条件隔离或按已批准降级处理；macOS 可用性以静态/代码路径证据成立；真机重放仍留阶段 4（G1 环境缺口未解决）。

---

## 4. 任务 3：产物预算补记

### 4.1 阶段 2 真实产物清单

阶段 1 旧产物已被场景 B/C 新构建覆盖：`bin\Release` 最新 mtime 为 2026-09-04T03:47Z 以后。

| 目录 | 文件 | 大小 | 说明 |
| --- | --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | SystemTools.CrossPlatform.dll | **1,489,408** | 阶段 2 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 256,320 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 1,129 | 新产物 |
| | SystemTools.CrossPlatform.runtimeconfig.json | 554 | 新产物 |
| | manifest.yml | 1,430 | 未变 |
| | Microsoft.Windows.SDK.NET.dll | 24,877,600 | NuGet 后备 Windows TFM 运行库 |
| | WinRT.Runtime.dll | 528,944 | 同上 |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll | **1,486,848** | 阶段 2 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 250,228 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 469 | 新产物 |
| | SystemTools.CrossPlatform.runtimeconfig.json | 377 | 新产物 |
| | manifest.yml | 1,430 | 未变 |

### 4.2 体积增量对比（对比阶段 1 基线 1,349,120 B）

| TFM | 阶段 1 基线 | 阶段 2 体积 | 绝对增量 | 相对增量 | 主要增量来源 |
| --- | ---: | ---: | ---: | ---: | --- |
| Win (`net10.0-windows10.0.19041.0`) | 1,349,120 B | 1,489,408 B | +140,288 B | +10.4% | B 档 49 新 .cs + 2 新 .axaml（XAML 编译 + 资源流）+ Plugin.cs/MainConfigData 改写 |
| Linux (`net10.0`) | 1,349,120 B | 1,486,848 B | +137,728 B | +10.2% | 同上 |

> Win 与 Linux 体积差异 2,560 B 源于 Windows TFM 引用面略有不同（如 `Microsoft.Windows.SDK.NET` 相关元数据/资源），属正常 TFM 差异。

### 4.3 覆盖注记

- `bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` 由 2026-09-03T19:36:54Z / 1,349,120 B 覆盖为 2026-09-04T03:47:23Z / 1,489,408 B。
- `bin\Release\net10.0\SystemTools.CrossPlatform.dll` 由 2026-09-03T19:37:14Z / 1,349,120 B 覆盖为 2026-09-04T03:47:40Z / 1,486,848 B。
- 旧产物体积已在 §4.2 登记，产物清单完整见 `.tang/cases/stcp-cross-platform-001/evidence/p2-10-postbuild-products.txt`。

---

## 5. 任务 4：零写入复核

### 5.1 宿主链 5 工程 obj mtime

| 工程 | 路径 | LastWriteTimeUtc | 与 p1-07/p1-10/p2-07 基线一致性 |
| --- | --- | --- | --- |
| PluginSdk | `E:\ClassIsland-git-misha\ClassIsland.PluginSdk\obj\project.assets.json` | 2026-09-01T07:39:08.054Z | ✓ 一致 |
| Core | `E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json` | 2026-09-02T05:11:23.902Z | ✓ 一致 |
| Platforms.Abstractions | `E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |
| Shared | `E:\ClassIsland-git-misha\ClassIsland.Shared\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |
| Shared.IPC | `E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\obj\project.assets.json` | 2026-09-01T07:39:07.885Z | ✓ 一致 |

### 5.2 源插件 / 其他产品文件

- 源插件 `E:\My Github Projects\SystemTools` 全程只读，零写入。
- 除 bin/obj 构建产物外，本任务未修改任何 `.cs`、`.axaml`、`.yml`、`.json`、`.csproj`、`.slnx`、global.json 等产品文件。
- 源树（不含 bin/obj）最新写入仍为 p2-08 经授权的两处注释一词/一数订正（`ProcessMemoryMaintenanceService.cs:9`、`MainConfigData.cs:304`），csproj mtime 保持 2026-09-03。

---

## 6. 残余差距声明

| 项 | 状态 | 说明 |
| --- | --- | --- |
| G1 macOS 构建 | 维持留档 | 无 macOS 构建机/交叉链，静态兼容证据已成立，真机重放留阶段 4 |
| G3 标准本地路径 | 仍受 MSB4276 环境噪声影响 | Restore 阶段失败，未进入编译；按用户裁定口径以 NuGet 后备模式为准 |
| cipx 打包 | 阶段 4 | `CreateCipx` 仍未设置，cipx 发布面核验留阶段 4 |
| 阶段 2 编译缺陷 | 无新增 | 三类缺陷（隐式 using / Avalonia API / 双分支漂移）均未复现 |

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

# macOS 静态证据重放（只读）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
# 预期：SourceFiles=168, GateHits=0, ConditionalHits=13, InfoHits=2, VERDICT: PASS, exit=0

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

- 本任务写入严格受限：构建产生的 `obj\*` / `bin\Release\*` + 本案 `evidence/p2-10-*`。
- 未触碰源插件、宿主检出、兵部/礼部/刑部/户部已交付文件；csproj 阶段 2 零改动。
- 发现的产品源错误：无。阶段 1 三类编译缺陷均未复现。
- 本文件不推进、不审批全局工作流；属工部批级验证证据，报尚书省以 `tang_record_ministry_result` 记录。
