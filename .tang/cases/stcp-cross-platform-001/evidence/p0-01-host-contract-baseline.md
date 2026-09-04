# p0-01 宿主基线契约核对证据（U3）

- 案卷：`stcp-cross-platform-001`；派工：阶段 0 / assignment `p0-01`（礼部 interfaces-documentation，analysis）
- 权威输入：`04-spec.md`（R-1~R-10、U3）、`05-phased-development.md` 阶段 0 合同 0.1–0.7、`06-migration-details-proposal.md` 预备清单第 5/6 条
- 宿主基线：`E:\ClassIsland-git-misha`（**全程只读**，未修改任何宿主/源插件文件；本文件为礼部唯一写入）
- 记录时间：2026-09-03 21:57 (+08:00)；执行环境：Windows，git 2.54.0.windows.1，dotnet SDK 10.0.302（`dotnet --list-sdks`）
- 结论：**succeeded**（五项既定接口均存在且有至少一个平台实现；缺口 3 项按事实记录于 §7，不自行假定兼容）

---

## 1. 检出版本/快照记录（预备清单第 3 条宿主侧）

### 1.1 git 状态：孤儿 worktree（git 元数据不可用）

| 检查项 | 命令 | 结果 |
| --- | --- | --- |
| `.git` 存在性 | `Test-Path 'E:\ClassIsland-git-misha\.git'` | `True`，且为**隐藏文件**而非目录（`Get-Item -Force`：Mode `-a-h-`） |
| gitfile 内容 | 读 `E:\ClassIsland-git-misha\.git` | `gitdir: E:/ClassIsland-git/.git/worktrees/ClassIsland-git-misha` |
| 主仓库存在性 | `Test-Path 'E:\ClassIsland-git'` / `Test-Path 'E:\ClassIsland-git\.git\worktrees\ClassIsland-git-misha'` | 均 `False`（主仓库 `E:\ClassIsland-git` 及其 worktree 管理目录**不存在**） |
| git 命令 | `git -C 'E:\ClassIsland-git-misha' rev-parse HEAD`（及 status/branch/remote/log/describe） | 全部 `fatal: not a git repository: (NULL)`，exit 1 |

**原因记录**：`E:\ClassIsland-git-misha` 是指向主仓库 `E:\ClassIsland-git` 的 git worktree（`.git` 为 gitfile 指针），但主仓库已不存在，worktree 管理目录丢失，因此 git 无法解析仓库 → 一切 git 元数据命令失败。**该检出实质为孤儿 worktree 快照，git 提交/分支无法从本目录恢复**，版本记录必须依赖构建产物标记（§1.2）。未做任何绕过或修复（只读边界）。

### 1.2 版本标记（可重放）

命令：
```powershell
Get-Item 'E:\ClassIsland-git-misha\ClassIsland.Desktop\bin\Debug\net10.0-windows10.0.19041.0\ClassIsland.Desktop.exe' | Select-Object -ExpandProperty VersionInfo | Format-List FileVersion, ProductVersion
```
结果（同时适用于同目录 `ClassIsland.Platforms.Abstractions.dll`、`ClassIsland.Core.dll`）：

| 文件 | FileVersion / ProductVersion | 修改时间 |
| --- | --- | --- |
| `ClassIsland.Desktop.exe` | `2.1.1.1` / `2.1.1.1+a8af81ba37ec1e83588148a400a00a9d8548560d` | 2026/9/1 15:35:27 |
| `ClassIsland.Platforms.Abstractions.dll` | `2.1.1.1+a8af81ba37ec1e83588148a400a00a9d8548560d` | 2026/9/1 15:35:10 |
| `ClassIsland.Core.dll` | `2.1.1.1+a8af81ba37ec1e83588148a400a00a9d8548560d` | 2026/9/1 15:35:16 |

- **最佳可用版本记录 = `2.1.1.1` + 提交哈希 `a8af81ba37ec1e83588148a400a00a9d8548560d`**（来源：AssemblyInfo.cs 第 9-10 行 `AssemblyInformationalVersion($"{GitInfo.Tag}+{GitInfo.CommitHash}")`；与 U3 注记"发布包 2.1.1.1 仅作后备"一致）。
- 旁证（源插件侧，只读）：`E:\My Github Projects\SystemTools\SystemTools.csproj:10` `ClassIslandSourceRoot` 默认即 `E:\ClassIsland-git-misha`；`:79` 错误文本称其为 "the develop/v2/misha-alpha checkout"（检出分支身份佐证）；`:13` NuGet 后备版本 `ClassIsland.PluginSdk 2.1.1.1` 与上述产物版本一致。
- 版本机制事实：`Global.props:4` `GitVersion=false`（自建版本体系）、`:14-16` 引用 `ClassIsland.SimpleGitInfoGenerator 1.0.0.1`；`AssemblyInfo.cs:5-11` 非 NIX 构建取 `GitInfo.Tag`，NIX 构建固定 `0.0.0.0`。**风险注记**：`SimpleGitInfoGenerator` 构建期需要可用 git；本检出 git 元数据损坏，重新构建宿主可能无法复现相同版本信息（阶段 0 执行期关注点，不影响本契约核对）。

## 2. PluginSdk 与 Platforms.Abstractions 工程（任务 1）

### 2.1 ClassIsland.PluginSdk（存在）

- 工程：`E:\ClassIsland-git-misha\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj`
  - `:4` `TargetFramework=net10.0`；`:17` `ProjectReference → ..\ClassIsland.Core\ClassIsland.Core.csproj`（`IncludeAssets="all"`，即 SDK 以工程引用方式聚合 Core）；`:22-23` 将 `ClassIsland.PluginSdk.targets` 与 `generate-md5.ps1` 打入 NuGet 包 `build/net10.0`；`:26-28` 导入 `GeneratePackage.props`、`Global.props`、自身 targets。
- 打包属性（`E:\ClassIsland-git-misha\GeneratePackage.props`）：`:5` `GeneratePackageOnBuild=True`；`:6` License `LGPL-3.0-only`；`:9` RepositoryUrl `https://github.com/ClassIsland/ClassIsland`。csproj 内**未设 Version**（版本由 CI 侧提供，见 §2.3）。
- SDK 附带构建逻辑（`ClassIsland.PluginSdk\ClassIsland.PluginSdk.targets`）：`:7-35` `CreateCipx` target —— 要求输出目录含 `manifest.yml`（`:19-21` 错误码 `CISDK0001`），压缩输出为 `<插件名>.cipx`（`:28-30`）并调用 `generate-md5.ps1` 生成 MD5 摘要（`:33-34`）。

### 2.2 ClassIsland.Platforms.Abstractions（存在）

- 工程：`E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\ClassIsland.Platforms.Abstractions.csproj`
  - `:4` `TargetFramework=net10.0`；`:10` `RootNamespace=ClassIsland.Platforms.Abstraction`（注意命名空间与程序集名差异）；`:15` `ProjectReference → ..\ClassIsland.Shared\ClassIsland.Shared.csproj`；`:16` `PackageReference Avalonia $(AvaloniaVersion)`；`:19-21` 导入 `Global.props`/`GeneratePackage.props`/`AvaloniaShared.props`。
- `AvaloniaVersion=12.1.1`（`E:\ClassIsland-git-misha\AvaloniaShared.props:3`）—— 即 U3 基线的 Avalonia 版本事实。
- 两个工程均导入 `Global.props`，其中 `:7` `EnableWindowsTargeting=true`（支持在非 Windows 上构建 Windows TFM）。

### 2.3 引用方式（只记录事实与既有先例，不做决策）

| 方式 | 事实来源 |
| --- | --- |
| NuGet 包引用 | `ClassIsland.ExamplePlugin\ClassIsland.ExamplePlugin.csproj:13-19`：`ClassIsland.PluginSdk` Version `2.0.0.*`，`ExcludeAssets=runtime;native`；CI NuGet 源为 GitHub Packages（`.github\workflows\build_release.yml:82-83`） |
| 本地检出 ProjectReference | `E:\My Github Projects\SystemTools\SystemTools.csproj:10-12`（`ClassIslandSourceRoot=E:\ClassIsland-git-misha` + `UseLocalClassIslandSdk` 自动探测）、`:161-170`（条件 ProjectReference 指向 `$(ClassIslandSourceRoot)\ClassIsland.PluginSdk\ClassIsland.PluginSdk.csproj` 并导入其 targets）、`:42-45`（NuGet 后备 `2.1.1.1`） |

## 3. 既定抽象接口与平台实现清单（任务 2 / 预备清单第 5 条）

定义工程：`ClassIsland.Platforms.Abstractions`，命名空间 `ClassIsland.Platforms.Abstraction.Services`。
插件侧入口为静态门面 `E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\PlatformServices.cs:9-55`（各服务静态属性默认值均为对应 Stub，`:14/:19/:24/:34/:39/:44/:49/:54`）。
宿主注册点：`E:\ClassIsland-git-misha\ClassIsland.Desktop\Program.cs` `ActivatePlatforms()` `:151-193`（`:154-155` 全平台注册 AppLifetime+Launcher；`#if Platforms_Windows` `:156-169` 注册全部五服务；`#if Platforms_Linux` `:171-181` 注册 Window/Desktop/Toast；`#if Platforms_MacOs` `:183-191` 注册 Window/Location/Toast）。

| # | 接口 | 定义 文件:行 | 关键成员（行） | 平台实现（类声明行） | Stub（Abstractions 内） |
| --- | --- | --- | --- | --- | --- |
| 1 | `IWindowPlatformService` | `ClassIsland.Platforms.Abstractions\Services\IWindowPlatformService.cs:12` | `SetWindowFeature` :20；`GetWindowFeatures` :27；前台窗口事件 :33/:39；句柄/类名/最大化/全屏/指针 :46-92 | Windows：`platforms\ClassIsland.Platforms.Windows\Services\WindowPlatformService.cs:15`（实现 :122/:204）<br>Linux：`platforms\ClassIsland.Platforms.Linux\Services\WindowPlatformService.cs:14`（实现 :128/:191；X11 互操作见 §5.4）<br>macOS：`platforms\ClassIsland.Platforms.MacOs\Services\WindowPlatformServices.cs:15`（实现 :118/:167） | `Stubs\Services\WindowPlatformServiceStub.cs:13`（:21 no-op） |
| 2 | `ISystemEventsService` | `...\Services\ISystemEventsService.cs:6` | 仅 `TimeChanged` 事件 :11（**无会话结束/关机事件**） | Windows：`platforms\ClassIsland.Platforms.Windows\Services\SystemEventsService.cs:6` | `Stubs\Services\SystemEventsServiceStub.cs:6`（:9） |
| 3 | `IDesktopToastService` | `...\Services\IDesktopToastService.cs:8` | `ShowToastAsync(content)` :14；`ShowToastAsync(title, body, activated)` :23；`ActivateNotificationAction` :29 | Windows：`platforms\ClassIsland.Platforms.Windows\Services\DesktopToastService.cs:21`<br>Linux：`platforms\ClassIsland.Platforms.Linux\Services\DesktopToastService.cs:12`（FreeDesktop 代理 `Notification\FreeDesktopNotificationProxy.cs`）<br>macOS：`platforms\ClassIsland.Platforms.MacOs\Services\DesktopToastService.cs:7`（NSUserNotificationCenterDelegate）<br>（另有 Android：`ClassIsland.Android\Services\Platform\DesktopToastService.cs:6`） | `Stubs\Services\DesktopToastServiceStub.cs:7`（:10/:15） |
| 4 | `ILauncherService` | `...\Services\ILauncherService.cs:6` | `LaunchPath` :12；`LaunchUrl` :18 | 宿主应用层（三平台通用）：`ClassIsland.Desktop\Services\Platform\LauncherService.cs:9`，经 `Program.cs:155` 全平台注册<br>（另有 Android：`ClassIsland.Android\Services\Platform\LauncherService.cs:12`） | `Stubs\Services\LauncherServiceStub.cs:8`（:16） |
| 5 | `IDesktopService` | `...\Services\IDesktopService.cs:6` | `IsAutoStartEnabled` :11；`IsUrlSchemeRegistered` :16 | Windows：`platforms\ClassIsland.Platforms.Windows\Services\DesktopService.cs:8`<br>Linux：`platforms\ClassIsland.Platforms.Linux\Services\DesktopService.cs:8` | `Stubs\Services\DesktopServiceStub.cs:5` |

其余宿主平台抽象（同工程，供完整性）：`IAppLifetimeService`（`Services\IAppLifetimeService.cs`；实现 `ClassIsland.Desktop\Services\Platform\DesktopAppLifetimeService.cs:7` 全平台 + Android；Stub `AppLifetimeServiceStub.cs:6`）、`ILocationService`（Windows `:7`、macOS `:7`、Stub；**无 Linux 实现**）、`IPlatformFilePickerService`（默认 `Stubs\Services\AvaloniaDefaultPlatformFilePickerService.cs:8`）。

B 档 R-3 契约佐证：`SetWindowFeature` 三平台实现均已实装（Windows :122 / Linux :128 / macOS :118，§3 表）；特性枚举 `ClassIsland.Platforms.Abstractions\Enums\WindowFeatures.cs:7-37` 为 `[Flags]`，含 `Topmost=4` :24、`Bottommost=2` :20（另有 Transparent/Private/ToolWindow/SkipManagement）—— `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)` 替换目标在 U3 基线成立。

## 4. CrossPlatformProps.props：TFM / 平台切换 / SDK / RID（任务 3 / 预备清单第 6 条）

文件：`E:\ClassIsland-git-misha\CrossPlatformProps.props`（60 行；被 `ClassIsland.Desktop.csproj:128` 导入）。

1. **基础 TFM**：回退值 `TargetFramework=$(BaseFramework)`（:13）。`BaseFramework` 由入口工程定义：宿主应用 `ClassIsland.Desktop.csproj:7` = **`net10.0`**（启动器 `ClassIsland.Launcher.csproj:5` = `net9.0`）。
2. **三平台切换方式**（两级）：
   - 发布/CI：`PublishBuilding=='true'` + `PublishPlatform ∈ {linux, windows, macos}` → 置 `Platforms_{OS}=true`（:15-23）；
   - 开发机：`PublishBuilding != 'true'` 时按 `[System.OperatingSystem]::IsWindows()/IsLinux()/IsMacOs()` 自动（:25-33）。
3. **平台 TFM 展开**：
   - Windows：`$(BaseFramework)-windows10.0.19041.0` + `DefineConstants Platforms_Windows` + `app.manifest` + 图标（:35-40）；
   - macOS：`$(BaseFramework)-macos26.5`，`SupportedOSPlatformVersion=12.0`（:41-45）；
   - Linux：**无 TFM 后缀**（保持 `net10.0`），仅 `DefineConstants Platforms_Linux`（:49-51）。
   - Windows Release 输出 `WinExe`（:46-48）。调试 Target `PrintPlatformInfo` 打印 TFM/RID（:53-59）。
4. **SDK 版本**：`global.json:2-6` `"version": "10.0"`，`rollForward: latestFeature`，`allowPrerelease: true`。CI：win/linux `10.0.x`，macOS 钉死 `MACOS_DOTNET_SDK_VERSION=10.0.302`（`build_release.yml:22,70`）。本机 SDK：`10.0.302`。
5. **RID/架构策略**：props 本身不设 RID；由 Nuke 传入 —— `build\Build.cs:69-77`：`osRid = windows→win / linux→linux / macos→osx / android→android`，`RuntimeIdentifier = "{osRid}-{Arch}"`；架构矩阵 `arch: ['x64','x86','arm64']`（`build_release.yml:37`），排除 linux-x86（:40-41）与 linux-full（:44-45，Linux 一律自包含），macOS 仅 `arm64/x64` + `selfContained` + `pkg`（:46-54）。发布参数链：`Build.DesktopApp.cs:20-25,51-65` 传递 `PublishBuilding/PublishPlatform/RuntimeIdentifier/ClassIsland_PlatformTarget/SelfContained`；`ClassIsland_PlatformTarget` 映射 `PLATFORM_x64/x86/ARM64/ARM` 编译常量（`Global.props:39-53`）。发布目录 `out/ClassIsland`，产物命名 `out_{BuildName}_{os}_{Arch}_{BuildType}_{Package}`（`Build.cs:50-52,78`）。
6. **Linux(X11) 佐证**：`platforms\ClassIsland.Platforms.Linux\X.cs:11` `const string X11 = "libX11.so.6"`；`:18` `XOpenDisplay` P/Invoke；被 `Services\WindowPlatformService.cs:36/48/73` 使用 —— 宿主 Linux 路径为 **X11 互操作**（无 Wayland 实装）。

## 5. 新插件 manifest schema 与 apiVersion 依据（任务 4）

1. **schema（模型）**：`ClassIsland.Core\Models\Plugin\PluginManifest.cs:10-73` —— 字段：`EntranceAssembly` :16、`Name` :21、`Id` :26、`Description` :31、`Icon` :36、`Readme` :41、`Url` :46、`Version` :51、**`ApiVersion` :56**、`Author` :61、`Dependencies` :66、**`SupportedOSPlatforms` :72**（默认全部平台；`:71` 有效值 Windows/Linux/macOS/Android/iOS）。
2. **schema（解析代码）**：`ClassIsland\Services\PluginService.cs` —— `:42` 文件名常量 `PluginManifestFileName = "manifest.yml"`；`:68-72`/`:119-123` YamlDotNet `DeserializerBuilder`（`IgnoreUnmatchedProperties` + `OSPlatformTypeConverter_Yaml` + `CamelCaseNamingConvention`）；`:84`/`:139` `Deserialize<PluginManifest>`。OS 平台转换器：`ClassIsland\Converters\OSPlatformTypeConverter.cs:11`。`.cipx` 包内 manifest 读取：`ClassIsland\Services\XamlThemeService.cs:435-439`。
3. **apiVersion 取值依据（U3 基线对应值）**：本检出强制最低 **`2.0.0.0`** —— `PluginService.cs:168-171`：启用插件的 `ApiVersion < 2.0.0.0` 判为 `PluginLoadStatus.Error`（"插件的 API 版本需要至少为 2.0.0.0 才能被当前版本的 ClassIsland 加载"）。仓库内示例 `ClassIsland.ExamplePlugin\manifest.yml:6` 取 `apiVersion: 2.0.0.0`。即：**U3 基线下新插件 manifest 的 apiVersion 依据 = 宿主加载下限 2.0.0.0（示例值 2.0.0.0）**；具体落值由执行阶段按此依据写入，不属于本次核对的决定范围。
4. **对照（源插件现状，R-10 对应）**：`E:\My Github Projects\SystemTools\manifest.yml` —— `:6` `id: SystemTools`、`:11` `version: 3.0.0.0`、`:12` `apiVersion: 2.2.0.0`、`:19-20` `supportedOSPlatforms: [Windows]`。新插件 manifest 须独立 `id`、三平台列表、apiVersion 按 §5.3 依据（R-10 / 05 合同 0.1.4）。

## 6. 重放指引（复核方最小命令集）

```powershell
# 版本记录
Get-Content 'E:\ClassIsland-git-misha\.git'
Test-Path 'E:\ClassIsland-git'
git -C 'E:\ClassIsland-git-misha' rev-parse HEAD          # 预期 fatal: not a git repository: (NULL)
Get-Item 'E:\ClassIsland-git-misha\ClassIsland.Desktop\bin\Debug\net10.0-windows10.0.19041.0\ClassIsland.Desktop.exe' | % VersionInfo | fl FileVersion, ProductVersion

# 接口定义（预期 5 处命中，行号见 §3）
# rg 'interface (IWindowPlatformService|ISystemEventsService|IDesktopToastService|ILauncherService|IDesktopService)' E:\ClassIsland-git-misha

# 平台实现（预期 Windows/Linux/macOS/Desktop/Android + Stubs，见 §3）
# rg '(class|struct)\s+\w+[^{;\r\n]*\bI(WindowPlatformService|SystemEventsService|DesktopToastService|LauncherService|DesktopService)\b' E:\ClassIsland-git-misha

# SetWindowFeature 三平台实现（预期 Windows:122 / Linux:128 / macOS:118）
# rg 'public void SetWindowFeature' E:\ClassIsland-git-misha\platforms

# TFM / RID / apiVersion
Get-Content 'E:\ClassIsland-git-misha\CrossPlatformProps.props'
Get-Content 'E:\ClassIsland-git-misha\global.json'
# rg 'apiVersion' E:\ClassIsland-git-misha\ClassIsland.ExamplePlugin\manifest.yml
# 源码 rg 'apiVersion' E:\ClassIsland-git-misha\ClassIsland\Services\PluginService.cs   # 预期 :168 下限 2.0.0.0
```

## 7. 缺口清单（显式上报；只记录事实，不假定兼容）

| # | 缺口 | 证据 | 对既定计划的含义 |
| --- | --- | --- | --- |
| G1 | `ISystemEventsService` **无 Linux/macOS 实现**（仅 Windows + Stub）。运行时在 Linux/macOS 上保持门面默认 Stub（`PlatformServices.cs:34`；`Program.cs:171-191` 两分支均未赋值） | §3 表 #2；`Stubs\Services\SystemEventsServiceStub.cs:6` | 依赖该接口的行为在 Linux/macOS 上将落到 Stub 语义（`TimeChanged` 无触发方）；B 档涉及项不得假定为真实事件源 |
| G2 | `ISystemEventsService` 契约面**仅含 `TimeChanged`（ISystemEventsService.cs:11），无会话结束/关机/电源事件** | §3 表 #2 | R-4 预设的"宿主 ISystemEventsService（**若提供**会话结束事件）"答案为**不提供** → `SystemShutdownMonitor` 须走既定的"非 Windows no-op 降级"路径或经批准的其他机制（04-spec S3-R4 已预留该分支） |
| G3 | `IDesktopService` **无 macOS 实现**（Windows/Linux 有，macOS 运行时为 Stub：`Program.cs:183-191` 未注册） | §3 表 #5；`Stubs\Services\DesktopServiceStub.cs:5` | macOS 上开机自启/URL 协议注册属性为 Stub 语义，不得假定可用 |

无其他缺口：五项既定接口全部存在且各有 ≥1 平台实现（§3）；`SetWindowFeature(Topmost/Bottommost)` 三平台实装成立；`ILauncherService` 经 `Program.cs:155` 在三平台可用（实现在宿主应用层）。

## 8. 边界声明

- 宿主 `E:\ClassIsland-git-misha` 与源插件 `E:\My Github Projects\SystemTools` 全程只读；全部写入仅本证据文件（工作区内 `.tang/cases/stcp-cross-platform-001/evidence/`）。
- 未遭遇沙箱拒绝；git 命令为只读执行并原样记录其失败输出（§1.1），未绕过。
- 本证据仅记录契约事实与依据，不做兼容性假定、不做工程决策、不推进全局工作流。
