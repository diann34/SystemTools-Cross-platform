# p3-07 证据：阶段 3 设置整合后依赖面核对与产物预算（户部 data-dependencies / verification，只读测量收尾）

- 案卷：`stcp-cross-platform-001`（case_scale=large）；阶段 3 / assignment `p3-07`；依赖 none（验证收尾，不重复实施）
- 派工背景：p3-05（吏部整合 spec）/ p3-01 / p3-02（兵部两批接线）/ p3-03（命名空间）/ p3-06（礼部同装差异文档）已由旧 plan 完成并 recorded succeeded；本 plan 仅覆盖 p3-07 验证收尾，重复实施 = 0
- 权威输入：`evidence/p2-07-revenue-dependency-check.md`（阶段 2 基线：203 产品文件 / 双形态 / csproj 零触碰 `A7220DB4…C38A` / obj 闭包）；`evidence/p3-05-personnel-settings-integration-spec.md`（§1 骨架基线 / §2 落点 / R1 勘误 W9 15-50 / §4 命名空间 22 值 8 SettingsPage .cs）；`evidence/p3-01-war-settings-pages-a.md`、`evidence/p3-02-war-settings-pages-b.md`（接线面与交付文件清单）；`evidence/p3-06-rites-coexistence-doc.md`（§2 六页 30 组映射）；`evidence/p1-07-revenue-dependency-check.md`（阶段 1 双形态基线）
- 工作区（唯一写入面）：`.tang/cases/stcp-cross-platform-001/evidence/p3-07-revenue-dependency-check.md`（本文件）；产品文件/宿主检出/NuGet 缓存全程只读，零子进程触发
- 结论：**succeeded** —— ①双形态求值 = 阶段 2 基线完全一致：csproj 字节态（SHA256 `A7220DB4…C38A` / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z）与 p2-07 §1 逐项同值，阶段 3 首个产品写（04:36:01Z）晚于 csproj mtime >10 小时，零触碰独立证据成立（§1）；②阶段 3 触达面 = 13 个 SettingsPage 产品文件（全为既有骨架改写）+ `docs\coexistence-notes.md` 1 个新文档文件，using 面全集（§3）全部映射入宿主链闭包 / .NET 共享框架 / 插件自命名空间，**未授权新增包 = 0**（§2/§3）；③B 档/A 档消费面整合后仍闭合：Core.dll 3,671,040 B / Platforms.Abstractions.dll 24,064 B 字节级 PRESENT 复验与 p2-07 §4 基线同值，SettingsPage 面零漂移红线、零宿主接口发明（§4）；④产物预算：源码产品文件 203 不变（163 cs / 29 axaml / 4 yml / 3 png / 3 txt / 1 csproj），阶段 3 净增产品文件 = 仅 docs 文档 1 个；共享 VM 74→887 行（+813，两批段界标增量），Plugin.cs 742 行零变（§5）；⑤接线需求零新增差距：AvaloniaResource 六项（csproj:113-123）在位且 6 目标文件实测存在，manifest 字节不变，宿主链 5 工程 obj 零写入，插件 obj/bin 零阶段 3 写入（§6）。体积对比如实 defer 至 p3-10。

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| 双形态求值 | csproj 字节态 = p1-10 接线终态（SHA256 `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z）= p2-07 §1 实测同值；阶段 3 零触碰（§1）——默认 PackageReference=`[]`、后备 = ClassIsland.PluginSdk 2.1.1.1（ExcludeAssets=runtime;native）、ProjectReference 互为对偶，与 p1-07 §2 / p0-04 §10.4 / p2-07 §1 结论逐项一致，无差异 |
| using 审计 | 7 个阶段 3 .cs（6 页 code-behind + 共享 VM）using 面全集 33 个唯一根全部映射入既有闭包（§3）：ClassIsland.* 宿主链 / Avalonia+FluentAvalonia / System.* BCL / SystemTools.CrossPlatform.* 自命名空间；CommunityToolkit.Mvvm.ComponentModel 唯一"产品包"面 = Shared 链传递 8.2.1 的生成器消费（VM :10，p2-07 §3.1 先例）；**需新增 PackageReference 的依赖 = 0，未授权新增包 = 0** |
| 消费面回退 | 阶段 2 闭合面整合后仍闭合：IDesktopToastService / IWindowPlatformService / SetWindowFeature / WindowFeatures / MyWindow 等 NuGet 2.1.1.1 字节级 PRESENT 复验与 p2-07 §4 同值；阶段 3 页消费 = SettingsPageBase.RequestRestart/OpenDrawer + IUriNavigationService + IRulesetService + 插件本地服务（IAppHost DI），零漂移红线、零 ABSENT 引用、零接口发明（§4） |
| 产物预算 | 阶段 3 净增产品文件 = **0 个源码文件**（产品树 203 不变）+ **1 个文档文件**（`docs\coexistence-notes.md`，14,133 B，仓库级阶段 3 窗口唯一新文件）；13 个 SettingsPage 文件全为既有骨架改写（SettingsPage 目录 14 = 6 axaml + 8 cs，与 p3-05 §4.1 一致）；Plugin.cs 742 行零变；共享 VM 74→887（+813）；**体积对比如实 defer 至 p3-10**（§5） |
| 接线需求状态 | csproj 零改动（字节同一性）；AvaloniaResource 六项（csproj:113-123）在位 + 6 目标文件实测存在；manifest.yml SHA256 不变（`142CD419…AAC`）；global.json/slnx mtime 09-03 零触碰；宿主链 5 `obj\project.assets.json` mtime 与 p2-07 §0 基线逐项同值；插件 obj/bin 最新 mtime 03:48:32Z（p2-10 阶段 2 构建）< 阶段 3 首写 04:36:01Z ⇒ 零阶段 3 写入（§6）——**零新增接线差距** |

---

## 1. 双形态求值核对（任务 1）——与 p2-07 基线一致，无差异

**csproj 现状实测（本核对，2026-09-04 会话）**：SHA256 `A7220DB4A37DBCF907E89D10AE75EE6C7780EAA8B684303F4826D37EFE93C38A` / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z —— 与 p2-07 §1 登记**逐字节、逐字段同值**（p2-07：SHA256 同串 / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z）。

**阶段 3 零触碰独立证据（mtime 口径，命令 §7-A）**：

- 阶段 3 产品写窗口实测 = **2026-09-04T04:36:01Z（首个，SystemToolsSettingsPage.axaml）→ 04:52:51Z（末个，FloatingWindowEditorSettingsPage.axaml.cs）**，13 个 SettingsPage 文件（§5.1 清单）；docs 文件 05:20:10Z。csproj mtime（09-03T18:55:37Z）早于阶段 3 每个文件写时点 >10 小时；
- 阶段 3 触达文件清单（§5.1）**不含 csproj / manifest.yml / global.json / slnx**——后三者 mtime 实测 09-03（15:12:06Z / 14:15:00Z / 14:16:06Z）零触碰；
- 两文件（MainConfigData.cs、ProcessMemoryMaintenanceService.cs）mtime = 2026-09-04T03:33:47Z，落于 p2-07 快照（阶段 2 末写 03:17:15Z）之后、阶段 3 首写（04:36:01Z）之前——系**阶段 2 收尾写**（p3-01 开工基线即记 2026-09-04 11:33:47 本地时 = 03:33:47Z，其批证据声明"与开工基线一致"；行数 553/742 与 p2-07 §5.2 阶段 2 末值一致），**非阶段 3 写入**，登记以明边界；
- 阶段 3 各批证据互证零改动：p3-01 §7-①（Plugin.cs 零触碰）、p3-02 §0（Plugin.cs/manifest/csproj/MainConfigData 零改动）、p3-06 §4-①（Plugin.cs/manifest 零触碰）；与 mtime 相互印证。

**静态条件求值（csproj 全文复核 :45-66，字节同一性 + p2-07 §1 求值结论推得，未触发 restore）**：csproj 求值面自 p1-10 起字节未变（本核对 SHA 与 p2-07/p1-10 同值）⇒ 双形态求值结论与 p2-07 §1 / p1-07 §2 基线**完全一致**：

| 场景 | 求值结果 | 与基线一致性 |
| --- | --- | --- |
| 默认（无属性 / `=true`）PackageReference | `[]`（csproj:45-54 条件仅含 ProjectReference） | ✓ |
| 后备 `-p:UseLocalClassIslandSdk=false` PackageReference | ClassIsland.PluginSdk / 2.1.1.1 / ExcludeAssets=runtime;native（csproj:63-65） | ✓ |
| 默认 ProjectReference | 检出 PluginSdk 工程（`$(ClassIslandSourceRoot)` = E:\ClassIsland-git-misha） | ✓ |
| 后备 ProjectReference | `[]` | ✓ |

- 全树 PackageReference 元素检索（src 排除 bin/obj）：唯一真实声明 = csproj:63-65（后备分支，阶段 0 形态）；余命中均为注释/doc 行（§3.2）。
- AvaloniaResource 接线（csproj:113-123）为无条件 ItemGroup，与双形态条件正交，不改变任一分支 PackageReference 求值面（沿 p2-07 §1 末行口径）。
- 后备分支真实 NuGet 发布解析仍属阶段 4 核验面（p0-04 §10.4 / p1-07 §2 / p2-07 §1 同判，本核对不执行）。

## 2. 阶段 3 触达面清单与写入边界（任务 2 前置）

**mtime ≥ 2026-09-04T04:00:00Z 仓库级扫描（排除 .tang/.git，命令 §7-B）= 恰 14 文件**：

| # | 文件（src 相对 / 仓库相对） | mtime（UTC） | 行数 | 归属批 |
| :-: | --- | --- | :-: | --- |
| 1 | SettingsPage\SystemToolsSettingsPage.axaml | 04:36:01Z | 271 | p3-01 |
| 2 | SettingsPage\SystemToolsSettingsPage.axaml.cs | 04:36:46Z | 257 | p3-01 |
| 3 | SettingsPage\FloatingWindowEditorSettingsPage.axaml | 04:39:20Z | 360 | p3-02 |
| 4 | SettingsPage\MoreFeaturesOptionsSettingsPage.axaml | 04:39:48Z | 94 | p3-01 |
| 5 | SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs | 04:40:19Z | 92 | p3-01 |
| 6 | SettingsPage\AiChatSettingsPage.axaml | 04:42:02Z | 206 | p3-02 |
| 7 | SettingsPage\AboutSettingsPage.axaml | 04:42:56Z | 154 | p3-02 |
| 8 | SettingsPage\AboutSettingsPage.axaml.cs | 04:42:56Z | 222 | p3-02 |
| 9 | SettingsPage\PluginDebugSettingsPage.axaml | 04:42:56Z | 21 | p3-02 |
| 10 | SettingsPage\PluginDebugSettingsPage.axaml.cs | 04:42:56Z | 25 | p3-02 |
| 11 | SettingsPage\SystemToolsSettingsViewModel.cs | 04:52:32Z | 887 | p3-01+p3-02 段界标 |
| 12 | SettingsPage\AiChatSettingsPage.axaml.cs | 04:52:46Z | 581 | p3-02 |
| 13 | SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs | 04:52:51Z | 561 | p3-02 |
| 14 | `docs\coexistence-notes.md`（仓库级，非 src 产品面） | 05:20:10Z | —（14,133 B） | p3-06 |

- 13 个 src 文件 = 6 落点页 ×2（.axaml/.axaml.cs）+ 共享 VM，**全部为既有骨架文件的改写**（SettingsPage 目录现 14 文件 = 6 axaml + 8 cs，与 p3-05 §4.1 命名空间普查「SettingsPage 8 .cs」一致；六页骨架为阶段 1 p1-06 交付、VM 为阶段 1 交付）；**零新增源码文件**（与产品树 203 不变互证 §5.1）。
- 阶段 3 .cs 触达面 = 7 个（上表 .axaml.cs ×6 + SystemToolsSettingsViewModel.cs）；AiChatSettingsViewModel.cs（SettingsPage 第 8 个 .cs）mtime 早于阶段 3（p3-02 §3-1 声明零改动），不在触达面。

## 3. using 审计与新增依赖扫描（任务 2）——零新增 PackageReference

### 3.1 using 面全集聚合（7 个阶段 3 .cs；按命名空间根分桶，命中文件数）

| 使用面（根） | 命中文件数 | 归属闭包 | 需新增 PackageReference？ |
| --- | :-: | --- | --- |
| `ClassIsland.Core.Abstractions.Controls` 6 / `ClassIsland.Core.Attributes` 6 / `ClassIsland.Shared` 6 / `ClassIsland.Core.Abstractions.Services` 3（IRulesetService D1 修复面，p3-02 §6-D1）/ `ClassIsland.Core` 1 / `ClassIsland.Core.Controls.Ruleset` 1（RulesetControl）/ `ClassIsland.Core.Models.Ruleset` 1（Ruleset） | 7 文件全覆盖 | PluginSdk→Core/Platforms.Abstractions/Shared 宿主链 | 否 |
| `Avalonia.*`（Controls 6 / Interactivity 5 / Input 2 / Input.Platform 1（ClipboardExtensions D2 修复面，p3-02 §6-D2）/ Platform.Storage 1 / Threading 1 / Media 1 / Media.Imaging 1 / VisualTree 1 / Avalonia 2）+ `FluentAvalonia.UI.Controls` 4 | 7 文件全覆盖 | Core 链传递 Avalonia 12.1.1 + FAUI 3.0.0（p2-07 §2 obj 闭包） | 否 |
| `System.*` / `System.Collections.*` / `System.IO` / `System.Linq` / `System.ComponentModel` / `System.Diagnostics` / `System.Threading.Tasks` | 7 文件全覆盖 | .NET 10 共享框架 BCL | 否 |
| `SystemTools.CrossPlatform.*`（Shared 5 / ConfigHandlers 5 / Services 5 / Models 1） | 7 文件全覆盖 | 插件自命名空间（镜像目录，p1-05 §3） | 否 |
| `CommunityToolkit.Mvvm.ComponentModel`（1：SystemToolsSettingsViewModel.cs:10） | 1 | **Shared 链传递 CommunityToolkit.Mvvm 8.2.1**（p2-07 §2 obj 闭包 + §3.1 FloatingWindowTriggerConfig.cs:3 同款生成器消费先例）——既有链传递包消费（[ObservableProperty] 生成器成员形态），非新增声明 | 否（消费沿用 p2-07 §3.1 结论） |

### 3.2 新 NuGet 包/引用声明检索

- 全树 PackageReference 元素（src，排除 bin/obj）：唯一真实命中 = csproj:63-65（后备分支既有声明，阶段 0 形态）；其余命中（csproj:58/:69/:76/:87/:89 与 Actions\SystemPowerCommandWindows.cs:13 等）均为注释/doc/历史说明行——**零新增**。
- 无新增 `.props/.targets` 导入（src 树无工程级新增此类文件；Services\AiAttachmentService.cs:55 的 `"*.props", "*.targets"` 为附件搜索过滤字符串，非工程引用，阶段 1 p1-04 交付面）。
- 7 个阶段 3 .cs 产品包名字符串（FluentAvaloniaUI|CommunityToolkit.Mvvm|Markdown.Avalonia|PluginSdk|PackageReference）检索：唯一 = SystemToolsSettingsViewModel.cs:10 `using CommunityToolkit.Mvvm.ComponentModel`（§3.1 合法消费）——**零新增依赖声明**。

### 3.3 S4.2 禁用语料 + 漂移红线 + 平台条件面

- S4.2 语料（System.Management|System.Speech|DlibDotNet|OpenCvSharp|NAudio|Vosk|CsWin32|Windows.Win32|RegistryKey）对 7 个阶段 3 .cs：**代码级 0 命中**（与 p3-01 §6.1 GateHits=0、p3-02 §4-④ PASS exit=0 批级扫描一致；docs/ 面 S4.2 不适用，p3-06 §5 声明成立）。
- 漂移红线六符号（IsBackgroundMaterialEnabled / FloatingWindowAppearanceStyle / FloatingWindowLiquidGlass / FloatingWindowGlassButtonScaleDip / AiConversationLiquidGlass / AiConversationApprovalButtonGlass）对 SettingsPage 全目录：**0 命中**（命令 §7-C）。
- 命名空间面：阶段 3 .cs 零 `using SystemTools.*`（裸/源插件前缀）命中（p3-05 §4.2-3 禁令兑现）；.axaml 本地命名空间零非 `SystemTools.CrossPlatform` 前缀。
- 平台条件面：SettingsPage 全目录零 `#if`（p3-01 §6.1 CONDITIONAL=0、p3-02 §4-② 零新增条件面互证）。

### 3.4 .axaml xmlns 面（6 落点页）

distinct xmlns URI 全集（§2 表 6 .axaml）= `http://classisland.tech/schemas/xaml/core` ×6（ClassIsland.Core）、`https://github.com/avaloniaui` ×6（Avalonia）、`clr-namespace:FluentAvalonia.UI.Controls;assembly=FluentAvalonia` ×5（FAUI）、`clr-namespace:ClassIsland.Core.Controls;assembly=ClassIsland.Core`、`clr-namespace:ClassIsland.Core.Helpers;assembly=ClassIsland.Core`、`https://github.com/whistyun/Markdown.Avalonia`（fork Markdown.Avalonia，p2-07 §2 obj 闭包 12.0.0 既有面）、`clr-namespace:SystemTools.CrossPlatform.Controls`（自控件）——**零新增 xmlns URI/程序集面**，与阶段 1 既有 29 .axaml 同闭包。

**审计结论**：阶段 3 全部消费符号（using + xmlns）映射入宿主链闭包 / .NET 共享框架 / 插件自命名空间 / 既有传递包消费；**需新增 PackageReference 才能编译的依赖 = 0；未授权新增包 = 0**。阶段 3 接线所需的新类型面（IRulesetService/RulesetControl/Ruleset/ClipboardExtensions/FAContentDialog）全部位于已核 PRESENT 宿主面或既有链闭包（§4.1 字节复验）。

## 4. 消费面回退核对（任务 3）——阶段 2 闭合面整合后仍闭合

### 4.1 宿主 PRESENT 面字节级复验（NuGet 2.1.1.1，与 p2-07 §4 同口径同方法）

| 程序集 | 字节数（p2-07 基线同值） | 符号 | PRESENT |
| --- | --- | --- | :-: |
| `ClassIsland.Core.dll`（net10.0） | **3,671,040 B**（p2-07 §4 同值） | IRulesetService / RulesetControl / Ruleset / MyWindow / SettingsPageBase / RequestRestart / OpenDrawer / FAContentDialog / IAppHost | 全 True |
| `ClassIsland.Platforms.Abstractions.dll`（net10.0） | **24,064 B**（p2-07 §4 同值） | IDesktopToastService / IWindowPlatformService / SetWindowFeature / GetWindowFeatures / WindowFeatures / Topmost / Bottommost / ILauncherService / IDesktopService / ISystemEventsService / ShowToastAsync | 全 True |

- 两程序集字节数 = p2-07 §4 登记同值 ⇒ 阶段 3 未引入任何宿主 API 回退（阶段 2 闭合面 IDesktopToastService/IWindowPlatformService/SetWindowFeature/WindowFeatures/MyWindow 在整合后仍闭合）。

### 4.2 阶段 3 页消费面核对（SettingsPage 8 .cs 全检索）

阶段 3 页面宿主 API 消费全集（实测）：全部页面 `: SettingsPageBase`（RequestRestart/OpenDrawer 基类面，PRESENT）；`IAppHost.GetService/TryGetService`（ClassIsland.Shared DI 门，p1-06 全批先例）注入——FloatingWindowProfileManager / FloatingWindowService / AiConversationStore / IOpenAiCompatibleService / AiPromptService / AiChatOperationGate / SystemToolsNotificationProvider / ClassIslandProfileAiService / ClassIslandActionAiService / VirtualAfterSchoolService / AdaptiveThemeSyncService / MainWindowTextOcclusionService / ClassIslandMemoryAutoCleanupService（**全为插件本地已交付类型**）；`IRulesetService.NotifyStatusChanged`（FloatingWindowEditorSettingsPage.axaml.cs:134/:141/:153/:453、VM:459，ClassIsland.Core.Abstractions.Services，字节 PRESENT §4.1）；`IUriNavigationService.NavigateWrapped`（About:59/:79、主页:202-203，阶段 1 已核双分支可用面 p3-05 §6-2）；`SettingsPageBase.OpenDrawer("RulesetDrawerContent")`（:396，PRESENT）。

- **零漂移红线**（§3.3 0 命中）；**零 ABSENT 引用**（p2-05 §4 ABSENT 集在 SettingsPage 零出现）；**零宿主接口发明**（页消费全部为 PRESENT 宿主面或插件本地类型，p1-05 §5.3-3 纪律兑现）；W15 层级页零平台代码（绑定配置成员，运行时层级经插件 FloatingWindowService→宿主 SetWindowFeature 已核 PRESENT 面，p2-03/p2-07 口径延续）。

### 4.3 契约核对 30 组映射 × 依赖面交叉印证（数据面）

p3-06 §2 六页 30 组可交互选项映射（用户可见契约面，礼部已核零错配）从**数据依赖面**交叉印证如下：

- 30 组映射的配置绑定成员全部实存于 `ConfigHandlers\MainConfigData.cs`（553 行，本核对逐名检索：EnableFloatingWindowFeature/ShowFloatingWindow/FloatingWindowScale/IconSize/TextSize/Opacity/ShadowEnabled/DragHandleAlwaysVisible/Layer/LayerRecheckMode/RulesetEnabled/Ruleset/FloatingWindowTheme/CurrentFloatingWindowProfile/AutoSwitchClassIslandTheme/AutoHideMainWindowWhenOccluded/AutoCleanupClassIslandMemory/EnableAiService/AiProviderName/AiApiKey/AiApiUrl/AiModel/VirtualAfterSchoolEnabled/VirtualAfterSchoolTriggerTime/VirtualAfterSchoolDurationSeconds/ShareAiRepliesWithClassIslandNotifications 全 True；`EnabledActions/EnabledTriggers/EnabledComponents/EnabledRules`（:523-534）+ Is*Enabled 辅助（:537-547）全在位）——**零缺失成员、零新增配置根成员**；
- MainConfigData.cs mtime = 2026-09-04T03:33:47Z（阶段 2 收尾）< 阶段 3 首写 04:36:01Z ⇒ 阶段 3 **零配置根改动** ⇒ 30 组映射数据面零新增 state/持久化/迁移面（p3-01 §0-2、p3-02 §0 零改动声明与 mtime 互证）；W9 勘误（15-50）为 UI 范围面，配置钳制 15..50（:387-397）未变，依赖面不受影响；
- p3-06 §2 映射零错配结论 + p3-01/p3-02 Roslyn 双向 error=0（绑定成员拼写零错）从编译/契约面佐证数据面无悬空——本核对从依赖面独立确认「30 组选项全部落在既有配置闭包内」，无新数据依赖引入。

## 5. 产物预算登记（任务 4）

### 5.1 阶段 3 净增产品文件实测（仓库级 mtime ≥ 04:00:00Z 口径，命令 §7-B）

- 阶段 2 末基线（p2-07 §5.1）：产品树 203 = 163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj。
- 阶段 3 现树：**203 = 163 .cs + 29 .axaml + 4 .yml + 3 .png + 3 .txt + 1 .csproj** —— **源码产品文件数零变化，阶段 3 净增源码文件 = 0**（派工预期兑现：源码 203 不变）。
- 阶段 3 触达 = 13 个 SettingsPage 既有文件改写（§2 表 #1-13）+ 1 个新文档文件 `docs\coexistence-notes.md`（#14；docs/ 目录系 p3-06 按派工创建，仓库级阶段 3 窗口唯一新增文件）。**阶段 3 净增文件 = 恰 1（docs 文档），与派工预期一致。**
- SettingsPage 目录现 14 文件 = 6 .axaml + 8 .cs（无净增），与 p3-05 §4.1（22 命名空间普查中 SettingsPage 8 .cs）一致。

### 5.2 行数增量登记（实测；体积 defer 至 p3-10）

| 文件 | 阶段 2 末基线 | 阶段 3 现态（实测） | 增量 | 依据 |
| --- | --- | --- | --- | --- |
| `Plugin.cs` | 742 行（p2-07 §5.2） | **742 行**（mtime 03:17:15Z 零阶段 3 写） | **0** | p2-07 §5.2 + 本核对实测 |
| `ConfigHandlers\MainConfigData.cs` | 553 行（p2-07 §5.2） | **553 行**（mtime 03:33:47Z 阶段 2 收尾） | **0**（阶段 3 零触碰） | p2-07 §5.2 + p3-05 §1.2 + 本核对实测 |
| `SettingsPage\SystemToolsSettingsViewModel.cs`（共享 VM） | 74 行（p3-05 §3.1 C13 实测骨架：1-74 A 面） | **887 行** | **+813** | p3-01 §4（p3-01 段 :68-100/:693-886）+ p3-02 §5-1（三段界标 :25-66/:113-139/:193-690）+ 本核对实测 887；两批段界标共存零重名 |
| 六落点页（.axaml/.axaml.cs） | 阶段 1 骨架（p1-06 §4 内容口径，无逐行基线留证） | 主页 271/257、更多功能 94/92、悬浮窗编辑 360/561、AiChat 206/581、About 154/222、PluginDebug 21/25 | 增量不可从证据逐行复原（骨架基线未留逐行数），登记现态行数供 p3-10 体积对比基准 | p3-06 §3.1 页行数口径与本核对实测一致 |
| `docs\coexistence-notes.md` | 不存在 | 14,133 B（约 6.2 千字符，p3-06 §1） | 新增 1 | p3-06 §1 + 本核对实测 |

- manifest.yml SHA256 实测 `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC` = p2-07 §5.2 同值（字节不变）。
- p3-03 命名空间零调整结论不产生文件移动/改名（零文件数影响）。

### 5.3 体积对比 —— 如实 defer 至 p3-10

- 现 bin/obj = **p2-10 阶段 2 构建产物**（最新 mtime 2026-09-04T03:48:32Z，Release\net10.0[-windows10.0.19041.0] 双 TFM），**零阶段 3 写入**（obj/bin 最新 03:48:32Z < 阶段 3 首写 04:36:01Z；阶段 3 各批均未触发 dotnet 子进程，沙箱边界同历史批次）。
- 阶段 3 为 13 个既有文件改写 + 1 文档（无新增编译单元），其体积影响须经阶段 3 真实构建（p3-10 工部门禁）实测；**本批不做失实测量**，如实 defer 并登记 p2-10 产物时间戳为对比锚点。

## 6. 接线需求状态汇总（任务 5）——零新增差距

1. **csproj 零改动确认**：字节同一性（SHA256 `A7220DB4…C38A` = p2-07/p1-10 同值）+ mtime 2026-09-03T18:55:37Z 早于阶段 3 每个产品写 >10 小时；零 DefineConstants、零新增 AvaloniaResource/AvaloniaXaml 元素（csproj:113-123 即 p1-10 终态原六项）。
2. **AvaloniaResource 六项在位复核**：csproj:113-123 六项 `<AvaloniaResource Include=…/>` 逐字在位（CardTypeComponent/ClassWidgets/NotchStyle Theme.axaml.txt ×3 + 上课/课间休息/无课程 .png ×3）；6 目标文件实测存在（3 Theme.axaml.txt mtime 2026-09-03T17:07:00Z / 3 PNG 2026-08-25，均早于阶段 3）；运行期消费锚点未变（p1-10 gate 已证接线生效）——阶段 1/2 闭合面无回退，**p1-07 §6 登记的 6 项差距状态维持关闭，阶段 3 零新增接线差距**。
3. **manifest.yml 字节级不变**（§5.2 SHA 同值）；global.json/slnx mtime 09-03 零触碰（p3 各批约束①互证）。
4. **宿主零写入**：链上 5 工程 `obj\project.assets.json` mtime 实测与 p2-07 §0 基线**逐项同值**——ClassIsland.PluginSdk 2026-09-01T07:39:08Z、ClassIsland.Core 2026-09-02T05:11:23Z、ClassIsland.Platforms.Abstractions（E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions）2026-09-01T07:39:07Z、ClassIsland.Shared 2026-09-01T07:39:07Z、ClassIsland.Shared.IPC 2026-09-01T07:39:07Z —— 阶段 1/2/3 均未写宿主。

## 7. 复核指引与命令重放（只读，可重放）

```powershell
# A. 双形态求值（字节同一性路径）：csproj 应见 SHA256 A7220DB4…C38A / 9,952 B / 125 行 / mtime 2026-09-03T18:55:37Z
Get-FileHash -Algorithm SHA256 src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj
(Get-Content src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj).Count          # 125
#    求值面复核：csproj:45-54（默认 ProjectReference）/:63-65（后备 PackageReference 唯一真实声明）
# B. 阶段 3 触达面清单：仓库级（排除 .tang/.git）mtime ≥ 2026-09-04T04:00:00Z 应为恰 14 文件（§2 表）
Get-ChildItem . -Recurse -File | Where-Object { $_.FullName -notmatch '\.tang|\.git' -and $_.LastWriteTimeUtc -ge [datetimeoffset]'2026-09-04T04:00:00Z' }
# C. 漂移红线/命名空间/条件面：SettingsPage 全目录 3 个模式预期 0 命中
Get-ChildItem src\SystemTools.CrossPlatform\SettingsPage -File | Select-String -Pattern 'IsBackgroundMaterialEnabled|FloatingWindowAppearanceStyle|FloatingWindowLiquidGlass|FloatingWindowGlassButtonScaleDip|AiConversationLiquidGlass|AiConversationApprovalButtonGlass'
Get-ChildItem src\SystemTools.CrossPlatform\SettingsPage -Filter *.cs | Select-String -Pattern 'using\s+SystemTools\.(?!CrossPlatform)|#if'
# D. using 聚合：7 个阶段 3 .cs（§2 表 .cs ×7）顶层 using 应映射入 §3.1 五桶，无桶外根
# E. PackageReference 全树：src 排除 bin/obj 唯一真实元素 = csproj:63-65
# F. 字节 PRESENT 复验（§4.1）：Core.dll 3,671,040 B / Platforms.Abstractions.dll 24,064 B Contains 各符号
# G. 产品树计数：163 cs / 29 axaml / 4 yml / 3 png / 3 txt / 1 csproj = 203（阶段 3 零净增源码）
# H. obj/bin 零阶段 3 写入：Get-ChildItem obj,bin -Recurse 最新 mtime 应 = 2026-09-04T03:48:32Z（p2-10）
# I. 宿主零写入：链上 5 obj\project.assets.json mtime 应与 p2-07 §0 基线同值（§6-4）
```

## 8. 边界声明

- 本批写入仅 `.tang/cases/stcp-cross-platform-001/evidence/p3-07-revenue-dependency-check.md`；产品文件（csproj/源/资产/manifest/global.json/slnx）零改动；宿主检出 E:\ClassIsland-git-misha、源插件检出、NuGet 缓存全程只读；未触发构建/restore/dotnet 子进程（沿历史批次沙箱边界，以只读等价证据完成）。
- 体积对比 defer 至 p3-10（现 bin/obj 为 p2-10 阶段 2 产物，时间戳 03:48:32Z 登记为锚点）；六落点页骨架逐行基线未在既有证据留证，行数增量仅登记可复原项（Plugin.cs 0 / MainConfigData 0 / VM +813 / docs 新增 1），页面现态行数登记供 p3-10 基准。
- 后备分支真实 NuGet 发布解析仍属阶段 4（发布面）；MainConfigData.cs/ProcessMemoryMaintenanceService.cs 03:33:47Z mtime 为阶段 2 收尾写（§1 明边界），非阶段 3 触碰。
- 本文件为批级验证证据，不推进、不审批全局工作流；报尚书省以 `tang_record_ministry_result` 记录，门下省终验。

## 9. 修订记录

- 初版（p3-07 派工交付，单轮只读测量一次成型）。
