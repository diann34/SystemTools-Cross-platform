# p2-07 证据：阶段 2 依赖面核对与产物预算（户部 data-dependencies / verification，B 档 19 项实施后只读测量）

- 案卷：`stcp-cross-platform-001`；阶段 2 / assignment `p2-07`；依赖 p2-01..p2-06（均 recorded succeeded）
- 权威输入：`evidence/p1-07-revenue-dependency-check.md`（阶段 1 基线：双形态结论/传递可达八面/接线差距）；`evidence/p2-05-personnel-b-tier-layout-check.md`（§4 双分支 API 核对：缺位 4 项本地实现 + 8 面 PRESENT）；p2-01/p2-02/p2-03 批证据（实施面）；`evidence/p2-06-rites-registration-b-tier.md`（Plugin.cs 480→742 行、注册面、全树 168 Source 面）；`evidence/p1-10-works-build-gate.md`（csproj AvaloniaResource 接线终态、产物 1,349,120 B 基线）
- 工作区（唯一写入面）：`.tang/cases/stcp-cross-platform-001/evidence/p2-07-revenue-dependency-check.md`（本文件）；产品文件零改动
- 只读消费：`src\SystemTools.CrossPlatform` 全树；宿主检出 `E:\ClassIsland-git-misha`；NuGet 缓存 `C:\Users\0\.nuget\packages`
- 结论：**succeeded** —— 双形态求值结论与 p1-07 基线一致（csproj 阶段 2 零触碰：mtime 2026-09-03T18:55:37Z 系 p1-10 接线终态，早于阶段 2 首写 2026-09-04T02:09Z，全程无阶段 2 写入）；新增依赖扫描 **未授权新增包 = 0**（全部 using 面映射入宿主链闭包/共享框架/插件自命名空间；唯一产品包提及 = 既有 CommunityToolkit.Mvvm 链传递消费的合法使用，非新声明）；B 档真实消费面闭合（IDesktopToastService/IWindowPlatformService/SetWindowFeature/WindowFeatures/MyWindow 双分支 PRESENT 复验一致，插件本地抽象 IProcessMemoryMaintenanceService/SystemPowerCommand 条件文件对闭合，缺位 4 接口零宿主发明）；产物预算登记（净增 51 产品文件：49 .cs + 2 .axaml；Plugin.cs 480→742；MainConfigData 269→553、+17 B 档成员三批增补段；体积对比如实 defer 至 p2-10 新构建，阶段 1 基线 1,349,120 B 复核在位）；接线需求状态（csproj 零改动 + AvaloniaResource 六项已由 p1-10 接线且现状在位，阶段 1 闭合面未回退）。

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| 双形态求值 | csproj 字节状态 = p1-10 接线终态（125 行 / 9,952 B / mtime 2026-09-03T18:55:37Z —— 阶段 2 零触碰，见 §1）；默认模式 PackageReference=空、后备模式 PackageReference=ClassIsland.PluginSdk 2.1.1.1（ExcludeAssets=runtime;native）、ProjectReference 互为对偶 —— **与 p1-07 §2 / p0-04 §10.4 结论逐项一致，无差异**（求值面 csproj 自 p1-10 起未变；本会话沙箱仍禁 dotnet 子进程，静态求值 + 字节同一性推得，见 §1/§7） |
| 新增依赖扫描 | 51 个阶段 2 .cs 的 using 面全集聚合（§3）：映射入 ClassIsland.*（SDK 链）/ Avalonia+FluentAvalonia / CommunityToolkit.Mvvm（Shared 链传递）/ Microsoft.Extensions.* / System.* BCL / SystemTools.CrossPlatform.*（自命名空间）；S4.2 禁用语料命中 = 0（仅 2 条注释级 CsWin32 历史说明，§3-3）；`#if` 平台条件文件 6 个（§3-4）；**需新增 PackageReference 的依赖 = 0，未授权新增包 = 0** |
| B 档消费面闭合 | IDesktopToastService（9 消费文件经 `PlatformServices.DesktopToastService`）✓、IWindowPlatformService/SetWindowFeature/WindowFeatures（FloatingWindowService RecheckWindowLayer）✓、MyWindow（两对话框基类）✓ —— NuGet 2.1.1.1 字节级 + U3 源码级双分支 PRESENT 复验一致（§4）；ILauncherService/IDesktopService/ISystemEventsService 阶段 2 零消费（与 p2-05 §4 注记一致，不构成插件面）；缺位 4 接口 → 插件本地抽象（IProcessMemoryMaintenanceService 接口+实现+条件适配器对 / SystemPowerCommand 条件执行器对）+ 2 个条件文件 #else no-op 护栏，公共表面跨分支闭合（§4.2/§4.3） |
| 产物预算 | 阶段 1 基线 152 产品文件 → 阶段 2 现 203（净增 **51**：49 .cs + 2 .axaml）；Plugin.cs 480→742 行（+262）；MainConfigData.cs 269→553 行（+284，B 档成员 +17 = p2-02 2 + p2-01 1 + p2-03 14，三批增补段界标在位）；.yml/.png/.txt/.csproj 计数零变化（4/3/3/1）；**体积对比如实 defer 至 p2-10**：现 bin 为 p1-10 时代旧产物（双 TFM 插件 DLL 实测 1,349,120 B = 阶段 1 基线，mtime 2026-09-03T19:36-19:37Z；obj/bin 无任何阶段 2 写入，见 §5） |
| 接线需求状态 | csproj 阶段 2 零改动确认（mtime 早于阶段 2 全部写）；AvaloniaResource 六项已由 p1-10 接线（csproj:113-123 现状在位）且 6 目标文件实测存在（§6）；Avalonia 默认 .axaml 收集在 p1-10 真实构建已验证生效（p1-10 §任务 0）；p1-07 §6 登记的 6 项"仍待接线"差距已在 p1-10 关闭，阶段 2 未新增接线差距 |
| 宿主零写入 | 链上 5 工程 `obj\project.assets.json` mtime 快照与 p1-07 §1 / p1-10 §6.1 基线**逐字节一致**（PluginSdk 2026-09-01T07:39:08Z、Core 2026-09-02T05:11:23Z、Platforms.Abstractions/Shared/Shared.IPC 2026-09-01T07:39:07Z）——阶段 1 与本核对均未写宿主 |

---

## 1. 双形态求值核对（任务 1）

**csproj 现状（2026-09-03T18:55:37Z / 9,952 B / 125 行 / SHA256 `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A`）**：当前文件体 = p1-10 工部接线后的终态（p1-10 gate §1 记录接线仅新增 1 个 ItemGroup 6 项 AvaloniaResource，csproj 由 9,112 B/阶段 0 末态增为 9,952 B；§任务 0 diff 与现文件 :113-123 逐字一致）。**阶段 2 零触碰的独立证据**：

- csproj mtime 2026-09-03T18:55:37Z（p1-10 接线时点）；阶段 2 全部产品文件首写 = 2026-09-04T02:09:22Z（p2-02 Settings 组）起、末写 = 2026-09-04T03:17:15Z（p2-06 Plugin.cs）——csproj mtime 早于阶段 2 每个文件写时点 >7 小时；
- 阶段 2 触达文件清单（53 = 51 .cs + 2 .axaml，mtime ≥ 2026-09-04T02:00Z）**不含 csproj**（§5.1 清单）；p2-01/p2-02/p2-03/p2-06 批证据各自声明"零改动 csproj / manifest / global.json / slnx"，与 mtime 相互印证；
- p2-01 §9-1 曾上报的 PLATFORMS_WINDOWS 接线需求已由尚书省微修裁决**撤销**（guard 统一 `Platforms_Windows`，零 DefineConstants 需求）；p2-06 §6 派工约束 1"零 csproj 改动、零 DefineConstants"兑现。

**静态条件求值（csproj 全文复核 :45-66，不触发 restore；重放命令 §7-A）**：

| 场景 | 求值结果 | p1-07 §2 / p0-04 §10.4 实测 | 一致性 |
| --- | --- | --- | --- |
| 默认（无属性/`=true`）PackageReference | `[]` | `[]` | ✓ |
| 后备 `-p:UseLocalClassIslandSdk=false` PackageReference | ClassIsland.PluginSdk / 2.1.1.1 / ExcludeAssets=runtime;native | 同 | ✓ |
| 默认 ProjectReference | 检出 PluginSdk csproj（E:\ClassIsland-git-misha…） | 同 | ✓ |
| 后备 ProjectReference | `[]` | 同 | ✓ |

- 文件内其他任何 PackageReference = 0（全树检索唯一命中 = :63 后备分支，§3-1）；`VerifyClassIslandSource` 目标（:95-98）在位（CP-0.1 不回退）。
- AvaloniaResource 接线（:113-123）与双形态 ItemGroup 正交，不改变任一分支 PackageReference 求值面。

**结论**：csproj 求值面自 p1-10（阶段 1 末）起字节未变，阶段 2 零触碰 ⇒ 双形态求值结论与 p1-07 §2 基线**完全一致、无差异**：默认 = 零直接 PackageReference（宿主链 PR），后备 = NuGet ClassIsland.PluginSdk 2.1.1.1（显式关闭本地 SDK 时）。后备分支真实 NuGet 发布解析仍属阶段 4 核验面，本阶段不执行（p0-04 §10.4 / p1-07 §2 同判）。

## 2. 双形态求值补充：obj 既有闭包佐证（只读）

`src\SystemTools.CrossPlatform\obj\project.assets.json`（mtime 2026-09-03 时代 = p1-10 后备分支实验残留，§5.2 无阶段 2 写入）——延续 p1-07 §3.5 佐证口径：后备 Linux 实验闭包含 PluginSdk 2.1.1.1、FluentAvaloniaUI/3.0.0、CommunityToolkit.Mvvm/8.2.1、ClassIsland.Markdown.Avalonia/12.0.0、Avalonia/12.1.1，B 档消费面包自足（真实后备解析仍归阶段 4）。

## 3. 新增依赖扫描（任务 2）

**方法**：51 个阶段 2 .cs（mtime ≥ 2026-09-04T02:00Z，即 §5.1 清单的 .cs 全量）using 顶层命名空间聚合 + 目标语料检索；命令可重放（§7-C）。阶段 2 其余产品面 = 2 .axaml（XAML xmlns 面单独核对 §3-5），Plugin.cs/MainConfigData.cs 改写沿用阶段 1 既有 using 面（p1-06/p2-05 已核）。

### 3.1 using 面全集聚合（51 文件，按 namespace 根分桶，命中次数）

| 使用面 | 归属 | 需新增 PackageReference？ |
| --- | --- | --- |
| `ClassIsland.*`（83 次：Core.Abstractions.Automation 16 / Attributes 16 / Controls 11 / Platforms.Abstraction 10 / Shared 9 / Core.Models.Notification 7 / Controls 4 / …） | PluginSdk→Core/Platforms.Abstractions/Shared 链 | 否 |
| `System.*` / `System.Collections/ComponentModel/Diagnostics/IO/Linq/Net/Reflection/Text/Threading…`（59+36 次） | .NET 10 共享框架 BCL | 否 |
| `Avalonia.*` + `FluentAvalonia.UI.Controls`（49+5+2 次：Controls/Threading/Data/Media/Layout/Styling/Input/Platform.Storage/Primitives/VisualTree/ApplicationLifetimes 等） | Core 链传递（Avalonia 12.1.1 + FAUI 3.0.0） | 否 |
| `Microsoft.Extensions.*`（Logging 21 / Hosting / DependencyInjection，23 次） | Core 链 + 共享框架 | 否 |
| `CommunityToolkit.Mvvm.ComponentModel`（1 次：FloatingWindowTriggerConfig.cs:3） | **Shared 链传递 CommunityToolkit.Mvvm 8.2.1**（Shared.csproj:21；p1-07 §3.2 可达 + 生成器先例）——唯一"产品包"使用面，系**既有链传递包的消费**（MVVM 生成器成员形态），非新增声明 | 否（消费沿用 p1-07 §3.2 结论） |
| `SystemTools.CrossPlatform.*`（Settings 21 / Services 14 / Shared 6 / ConfigHandlers 4 / Views/Triggers/Config/Actions/Controls/Rules 等自命名空间） | 插件自命名空间（镜像目录，p1-05 §3） | 否 |
| `System.Runtime.InteropServices`（2：ProcessMemoryMaintenanceNativeWindows.cs、SystemMotionPreferences.cs）/ `System.Windows.Forms`（1：SystemShutdownMonitor.cs） | 全部处于全文件平台 guard 内（§3-4） | 否（S4.2 条件面，非新增包） |

### 3.2 新 NuGet 包/引用声明检索

- 全树 PackageReference 元素检索：唯一命中 = csproj:63（后备分支既有声明，阶段 0 形态），零新增；无 `.props/.targets` 新增（src 树无此类文件）。
- 阶段 2 .cs 中产品包字符串（FluentAvaloniaUI|CommunityToolkit.Mvvm|Markdown.Avalonia|PluginSdk|PackageReference）提及：唯一 = FloatingWindowTriggerConfig.cs:3 `using CommunityToolkit.Mvvm.ComponentModel`（§3.1 合法消费）——**零新增依赖声明**。

### 3.3 S4.2 禁用语料全树复跑（阶段 2 .cs 范围）

- 语料 `System.Management|System.Speech|DlibDotNet|OpenCvSharp|NAudio|Vosk|CsWin32|Windows.Win32|RegistryKey`：命中 2 条，**均为注释级历史说明**（ImmediateRestartAction.cs:14 / ImmediateShutdownAction.cs:14 文件头注释"源 :16-17 ntdll RtlAdjustPrivilege + :28 ExitWindowsEx（CsWin32，不公开 API）"——随源留痕注记，非代码使用，门禁扫描器 COMMENT-ONLY 分类，p2-01 §5 同口径）；代码级 GateHits = 0。
- 与 p2-01/p2-02/p2-03/p2-06 各自批级扫描（GateHits=0，p2-06 全树收口 SourceFiles=168 / CONDITIONAL=13 / exit=0）及 p2-06 §6 四条件文件清单一致。

### 3.4 平台条件文件面（`#if` 检索，6 个全部全文件 guard）

| 文件 | guard | 承载 |
| --- | --- | --- |
| `Actions\SystemPowerCommandWindows.cs`（110 行） | `#if Platforms_Windows` | 电源族 Windows 命令启动（CONDITIONAL R21×5+R17×3） |
| `Actions\SystemPowerCommandStub.cs`（35 行） | `#if !Platforms_Windows` | 非 Windows 编译闭合存根 |
| `Services\ProcessMemoryMaintenanceNativeWindows.cs`（47 行） | `#if Platforms_Windows` | psapi 工作集修剪互操作（R13+X04） |
| `Services\ProcessMemoryMaintenanceNativeNoOp.cs`（22 行） | `#if !Platforms_Windows` | 非 Windows no-op |
| `Services\SystemShutdownMonitor.cs`（135 行） | `#if Platforms_Windows … #else … #endif` | Windows NativeWindow 会话监控 / #else no-op 护栏（R03） |
| `Views\SystemMotionPreferences.cs`（62 行） | `#if Platforms_Windows … #else … #endif` | Windows SystemParametersInfo / #else `ShouldReduceMotion()=>false`（R13+X04） |

- 计数与 p2-06 §6 CONDITIONAL=13 四文件清单逐项一致（10+2+1…13 = SystemPowerCommandWindows 8 + ProcessMemoryMaintenanceNativeWindows 2 + SystemShutdownMonitor 1 + SystemMotionPreferences 2，p2-01/p2-03 批登记同值）；零新增。
- **#else 分支公共表面复核（跨 TFM 编译闭合面）**：SystemShutdownMonitor #else（:100-135）对外 = `IsSessionEnding`/`Start`/`MarkSessionEnding`/`MarkIfOsShutdown(object)`/`Dispose` + internal `WindowCaption`，与 Windows 分支 Plugin.cs 消费面（p2-06 W6/W7：IsSessionEnding/Start/MarkIfOsShutdown/Dispose）签名相容；SystemMotionPreferences #else（:50-62）对外 = `ShouldReduceMotion()=>false` 与 Windows 分支同形。两 #else 零禁用符号。

### 3.5 .axaml xmlns 面（2 新对话框，B5 附属）

`Views\AdvancedShutdownDialog.axaml` / `Views\ExtendShutdownDialog.axaml`：根元素 `MyWindow`（ClassIsland.Core.Controls，双分支 PRESENT §4.1）+ FluentIcon/IconText/动态资源（阶段 1 既有消费面，p2-01 §5.3 人工核对零禁用符号）；xmlns 面与阶段 1 27 .axaml 同闭包，零新 xmlns URI。

**结论**：全部消费符号映射入宿主链闭包 / .NET 共享框架 / 插件自命名空间 / 条件文件 Windows 分支；**需新增 PackageReference 才能编译的依赖 = 0；未授权新增包 = 0**。若 p2-10 真实三平台构建出现解析错误，根因只能是工程接线/编译面而非包引用面（报告路径已指明）。

## 4. 传递可达复验（任务 3 —— B 档真实消费面闭合）

**方法**：对 B 档实际消费的宿主 API 逐符号做（a）阶段 2 消费点检索 +（b）U3 本地检出源码级 +（c）NuGet 2.1.1.1 二进制字节级（Latin1 Contains；Core.dll 3,671,040 B / Platforms.Abstractions.dll 24,064 B，与 p2-05 §4 同口径）三重复验。

### 4.1 宿主 PRESENT 面（B 档真实消费，双分支闭合）

| 宿主 API | 阶段 2 消费点（file 实测） | U3 检出源码 | NuGet 2.1.1.1 字节 | 闭合 |
| --- | --- | --- | --- | --- |
| `IDesktopToastService`（经静态门 `PlatformServices.DesktopToastService`） | 9 文件：ShutdownAction:82、AdvancedShutdownAction:580、CancelShutdownAction、LockScreenAction、ImmediateRestartAction、ImmediateShutdownAction、SleepAction、AdaptiveThemeSyncService:53、MainWindowTextOcclusionService（U4 降级 Toast 链） | PRESENT `Platforms.Abstractions\Services\IDesktopToastService.cs`（`ShowToastAsync(string,string,Action?)` :23 签名与消费形态一致）；`PlatformServices.cs` 静态门 PRESENT | Platforms.Abstractions.dll PRESENT | ✓（与 p2-05 §4 一致） |
| `IWindowPlatformService.SetWindowFeature(TopLevel, WindowFeatures, bool)` / `WindowFeatures` 枚举 | `Services\FloatingWindowService.cs:1451-1462` RecheckWindowLayer（`PlatformServices.WindowPlatformService` + `SetWindowFeature(_window, WindowFeatures.Topmost/Bottommost, state)` 对偶翻转） | PRESENT `Services\IWindowPlatformService.cs:20`（签名逐字一致）+ `Enums\WindowFeatures.cs` | Platforms.Abstractions.dll PRESENT（含 SetWindowFeature/GetWindowFeatures/WindowFeatures/Topmost/Bottommost 字节） | ✓ |
| `MyWindow`（Core.Controls，基类） | `Views\AdvancedShutdownDialog.axaml.cs:15`、`ExtendShutdownDialog.axaml.cs:15`（`: MyWindow`）；AdvancedShutdownAction.cs 注释面引用 | PRESENT `ClassIsland.Core\Controls\MyWindow.cs` | Core.dll PRESENT | ✓（B5 两对话框基类，p2-05 §4 首个消费批） |
| `ILauncherService` / `IDesktopService` / `ISystemEventsService` | 阶段 2 **零消费**（与 p2-05 §4 注记一致：B19 无直接消费点；IDesktopService macOS Stub G3 不触及） | PRESENT（契约面） | Platforms.Abstractions.dll PRESENT | ✓（零消费不构成插件依赖面） |
| `MainWindowStylesAssist.IsBackgroundMaterialEnabled`（已知漂移点，p1-01 §7.4 ABSENT） | 阶段 2 **零引用**（检索零命中；B19 交付文件禁引用护栏） | ABSENT（已知） | ABSENT（已知） | ✓ 不触发 |

### 4.2 缺位 4 接口 → 插件本地抽象（p2-05 §4 缺位清单落地复核）

| 06 表述接口（宿主双分支 ABSENT） | 阶段 2 落地 | 命名空间 | 证据 |
| --- | --- | --- | --- |
| `ISystemPowerService`（06 条目 37-43） | `SystemPowerCommand` 条件执行器对（Windows 命令族 + 非 Windows 存根） | `SystemTools.CrossPlatform.Actions`（插件本地，**非宿主 API** 注记） | Actions\SystemPowerCommandWindows.cs / SystemPowerCommandStub.cs（§3.4） |
| `IProcessMemoryMaintenanceService`（06 条目 49） | 插件本地接口 + 默认实现 + Windows 适配器 + NoOp 适配器四件套 | `SystemTools.CrossPlatform.Services` | IProcessMemoryMaintenanceService.cs / ProcessMemoryMaintenanceService.cs / ProcessMemoryMaintenanceNative{Windows,NoOp}.cs |
| `IThemePlatformService`（06 条目 47） | 不发明接口——按 06 降级"探测不可用即停止自动同步 + 保持当前主题 + Toast 通知"落地（p2-02 AD1） | —（零接口发明） | AdaptiveThemeSyncService.cs:46-52 |
| `ITextOcclusionDetectionService`（06 条目 48） | 不发明接口——按 06 降级"关闭检测、主界面保持可见 + Toast 通知"落地（p2-02 AD2；零条件文件） | — | MainWindowTextOcclusionService.cs:91-97 |

- 全部满足 p1-05 §5.3-3：零 `ClassIsland.*` 命名空间接口发明；每文件注释注明"插件本地抽象/非宿主 API"或降级口径。
- **DI 闭合**：`AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`（Plugin.cs:130）在内存清理服务注册（:131）之前，注册面零平台条件代码（p2-06 §3-1-3）；服务消费点 ClassIslandMemoryAutoCleanupService 构造注入一致（p2-01 §1.2）。
- **条件对同签名闭合**：SystemPowerCommand Windows/Stub 双分支经 p2-01 §6 Roslyn Round-W/Round-N error=0；SystemShutdownMonitor/SystemMotionPreferences 双分支经 p2-06 §7 Pass A/B Plugin.cs 归属 error=0（消费面编译一致）。

### 4.3 阶段 2 未消费既有 A 档宿主面（传递链不变量）

p1-07 §3 已核八面（FAUI 3.0.0 / Mvvm 8.2.1 / fork Markdown.Avalonia / Avalonia 12.1.1 / M.E.DI-Hosting / Platforms.* / BCL）链拓扑阶段 2 零变化：csproj 零改动（§1）+ 阶段 2 零新增 PackageReference（§3.2）⇒ 链上包面继续传递可达；B 档新增消费面（§4.1）全部落在已核 PRESENT 集内。Mvvm 生成器（FloatingWindowTriggerConfig.cs 等 [ObservableProperty] 消费）沿 Shared.csproj:21 链传递 + p1-07 §3.2 生成器先例，无需直接声明。

## 5. 产物预算登记（任务 4）

### 5.1 阶段 2 净增文件实测（mtime 口径，可重放 §7-D）

- 阶段 1 末基线（p1-07 §5.2）：产品树 152 = 114 .cs + 27 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj。
- 阶段 2 现树：**203** = 163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj ⇒ **净增 51 产品文件（49 .cs + 2 .axaml）**；.yml/.png/.txt/.csproj 计数零变化。
- 阶段 2 触达文件 = 53（mtime ≥ 2026-09-04T02:00Z：51 .cs + 2 .axaml）；其中 Plugin.cs、MainConfigData.cs 为既有文件改写（净增 = 53 − 2 改写 − … = 51 新文件 + 2 改写，与树计数差一致）。派工"约 52 新文件"估算与实测 51 之差 = 计数口径（本登记以实测 51 净增为准；兵部三批交付计数 23+17+12 含部分改写/共享文件叙述差异，不影响净增量）。
- 批分布（mtime 聚类）：p2-02（Settings 5 + Controls 5 + Actions 5 + Services 2 = 17）、p2-03（12 .cs，p2-03 自报）、p2-01（21 .cs + 2 .axaml，p2-01 自报 23 = 21 cs + 2 axaml，聚类 22 因并行写交错——以树计数与批自报交叉印证，净增量以树为准）。
- **Axaml 明细**：AdvancedShutdownDialog.axaml / ExtendShutdownDialog.axaml（B5 附属，mtime 2026-09-04T02:16:04Z）。

### 5.2 改写文件增量

| 文件 | 阶段 1 末 | 阶段 2 现 | 增量 | 依据 |
| --- | --- | --- | --- | --- |
| `Plugin.cs` | 480 行（p1-06 终态） | **742 行** | +262 | p2-06 §11（480→684 主批→742 微修 1）+ 本核对实测 742；全文件零 `#if`（p2-06 §6） |
| `ConfigHandlers\MainConfigData.cs` | 269 行（p1-03 裁剪形） | **553 行** | +284 | p2-05 §2.1 基线 269 + 本核对实测 553；三批增补段界标在位：p2-02（:239-277，2 成员）、p2-01（:279-302，1 成员）、p2-03（:304-520，14 属性声明）⇒ B 档成员 +17 |
| `manifest.yml` | SHA256 `142CD419…AAC` | 同值 `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC` | 0（字节不变） | 本核对实测（§6） |

- p2-03 增补段界标注释"13 个 B 档成员（7 组）"与实测 14 个属性声明（EnableFloatingWindowFeature + ShowFloatingWindow + 外观 6 + PositionX/Y 2 + Layer + LayerRecheckMode + RulesetEnabled + Ruleset = 14）存在**注释计数差异（文档性）**：p2-05 §2.1 预批清单 #1-#7 合计亦为 14（1+1+6+2+1+1+2），p2-03 头注释按"组"口径写 13/7 组系批证据笔误，不影响编译/配置语义（Roslyn 全树双向验证已过）；登记留痕，交尚书省知悉（可顺手订正注释，非阻塞）。

### 5.3 体积对比 —— 如实 defer 至 p2-10

- 现 bin = **p1-10 时代旧产物，零阶段 2 写入**：obj/bin 全树最新 mtime = 2026-09-03T19:37:14Z（< 阶段 2 首写 02:09Z），无任何 09-04 文件（§5.2/§7-E）。
- 双 TFM 插件 DLL 实测 **1,349,120 B**（net10.0 2026-09-03T19:37:14Z 与 net10.0-windows10.0.19041.0 2026-09-03T19:36:54Z 一致）= p1-10 gate 登记的阶段 1 基线体积（A 档全量 27 axaml + 114 类时代）。
- 阶段 2 新增 49 .cs + 2 .axaml（XAML 编译 + 资源流增量）与 Plugin.cs/MainConfigData 增量的**真实体积影响无法在旧产物上实测** ⇒ 按派工边界**如实 defer**：标注「待 p2-10 新构建后补记」（届时插件 DLL 由 1,349,120 B 增为含 B 档 19 项的真实体积；以默认本地检出形态 + 后备形态输出为准，双 TFM 分别登记）。不做失实测量。

## 6. 接线需求状态汇总（任务 5）

1. **csproj 零改动确认**：mtime 2026-09-03T18:55:37Z = p1-10 接线终态；阶段 2 全部 53 个触达文件均晚于此且不含 csproj（§1/§5.1）；p2-01 DefineConstants 接线需求已撤销（§1）。零 DefineConstants、零新 AvaloniaResource/AvaloniaXaml 元素。
2. **AvaloniaResource 六项已接线现状复核**（p1-07 §6 阶段 1 登记"仍待接线"→ p1-10 已落地，阶段 2 未回退）：
   - csproj :113-123 六项 `<AvaloniaResource Include=…/>` 在位（CardTypeComponent/ClassWidgets/NotchStyle Theme.axaml.txt ×3 + 上课/课间休息/无课程 .png ×3），与 p1-01 §6.2 期望形态、p1-10 gate §任务 0 diff 逐字一致；
   - 6 目标文件实测存在（Test-Path 全 True）；
   - 运行期消费锚点未变：Styles.cs AssetLoader.Open ×3（CardTypeComponentStyles/ClassWidgetsStyles/NotchStyleStyles）+ ClassWidgetsCard.axaml 位图 URI ×3——接线目标与消费点一一对应（阶段 1 核对结论延续）；
   - p1-10 gate 已证 6 项进入 avares 资源清单 + Avalonia buildTransitive 默认收集 27 .axaml 在真实构建生效 ⇒ p1-07 §6 登记差距全部关闭。
3. **manifest 字节级不变**（§5.2），与 p2-06 §8 复测一致。

## 7. 复核指引与命令重放

```powershell
# A. 双形态求值（需允许 dotnet 子进程的会话；本会话沙箱拒绝，结果 = p1-10 后字节同一性 + p1-07 §2 推得）
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -nologo                                    # => []（默认）
dotnet msbuild src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -getItem:PackageReference -p:UseLocalClassIslandSdk=false -nologo   # => ClassIsland.PluginSdk 2.1.1.1 ExcludeAssets=runtime;native
# B. csproj 零触碰：Get-Item 应见 mtime 2026-09-03T18:55:37Z / 9,952 B / SHA256 A7220DB4…C38A
# C. using 面聚合/语料扫描：51 阶段 2 .cs（mtime≥2026-09-04T02:00Z）顶层 using 聚合（§3.1）+ 语料 §3.3 零代码级命中
# D. 净增计数：产品树 203（163 cs+29 axaml+4 yml+3 png+3 txt+1 csproj）− 阶段 1 基线 152 = +51
# E. bin/obj 零阶段 2 写入：Get-ChildItem obj,bin -Recurse 最新 mtime 应 = 2026-09-03T19:37:14Z（p1-10）
# F. 双分支 PRESENT 字节检索（§4.1）：Core.dll/Platforms.Abstractions.dll 2.1.1.1 Contains 复验
# G. 宿主零写入：链上 5 obj\project.assets.json mtime（§0 末行）应与 p1-07 §1/p1-10 §6.1 一致
```

## 8. 边界声明

- 本批写入仅 `.tang/cases/stcp-cross-platform-001/evidence/p2-07-revenue-dependency-check.md`；产品文件（csproj/源/资产/manifest）零改动；宿主检出、原插件、NuGet 缓存全程只读；未触发任何构建/restore/子进程（沙箱禁 dotnet/git 的环境边界如实沿用 p1-07 §1 记录，本核对以只读等价证据完成，不做绕过）。
- 体积对比 defer 至 p2-10（阶段 1 基线 1,349,120 B 复核在位，非失实测量）；p2-03 增补段注释计数差异（13 vs 实测 14 属性）登记留痕，不阻塞。
- 后备分支真实 NuGet 发布解析仍属阶段 4（发布面）；macOS 构建环境缺口为 p0-06 G1 已知项，与本任务无涉。
- 本文件为批级验证证据，不推进、不审批全局工作流；报尚书省以 `tang_record_ministry_result` 记录，门下省终验。

## 9. 修订记录

- 初版（p2-07 派工交付，单轮测量一次成型）。
