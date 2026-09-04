# p1-10 证据：工部阶段 1 构建门禁与 macOS 静态兼容证据汇总

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-10 · 工部 works · infrastructure-release / verification |
| 依赖 | p1-01..p1-09 均记录 succeeded（全树 152 文件、刑部 S4.2 门禁 GateHits=0） |
| 权威输入 | p1-07 §6 接线登记表、p1-01 §6.2、04-spec S4.2 / U3 / U4 / U5、05 阶段合同阶段 1 |
| 工作区写入 | `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj`（6 项 AvaloniaResource 接线）+ `src\SystemTools.CrossPlatform\obj\*`（构建尝试残留）+ `.tang/cases/stcp-cross-platform-001/evidence/p1-10-*`（本证据及构建日志） |
| 结论 | **succeeded（按用户裁定口径：NuGet 后备 Win/Linux Release 构建通过）** —— csproj 6 项 AvaloniaResource 接线已按要求落地；Avalonia XAML/资源收集证据成立（27 .axaml + 6 项显式接线资源均进入 `avares` 清单）；NuGet 后备 Win/Linux Release 经第四轮修复后均 exit=0，产物真实体积 1,349,120 B / 文件版本 1.0.0.0。标准本地检出路径仍受 MSB4276/G3 环境噪声影响未重跑（维持记录）。macOS 静态兼容证据汇总结论成立。 |

---

## 0. 结论摘要（对应派工回报字段）

| 项 | 结论 |
| --- | --- |
| csproj 接线 | 6 项 AvaloniaResource 已按 p1-07 §6 / p1-01 §6.2 同形接入；diff 见 §1 |
| 标准本地 Release | **未重试**，Restore 阶段 `_GenerateRestoreProjectPathWalk` 失败（MSB4276/G3 环境噪声），维持 §2.2 记录 |
| NuGet 后备 Win Release | **通过**，第四轮修复后 exit=0；产物 `net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` 真实体积 1,349,120 B，文件版本 1.0.0.0 |
| NuGet 后备 Linux | **通过**，第四轮修复后 exit=0；产物 `net10.0\SystemTools.CrossPlatform.dll` 真实体积 1,349,120 B，文件版本 1.0.0.0 |
| XAML 编译证据 | 27 个 `.axaml` 被 Avalonia 构建任务以 `additionalfile` 收集，`/resource:.../Avalonia/resources` 生成；6 项显式接线资源进入 `avares` 清单；第四轮前出现并已修复 `AVLN2000` 一处 |
| macOS 静态兼容证据 | 五批 macOS 五列自检表 102/102 项全部“可用”零“不适用”；Windows 专属路径均已条件隔离或按已批准降级口径处理；刑部门禁零命中 |
| 产物预算补记 | 插件 DLL 由 5120 B 空壳 → 1,349,120 B（双 TFM 一致），文件版本 1.0.0.0；Win 输出目录仍含 Microsoft.Windows.SDK.NET.dll / WinRT.Runtime.dll（NuGet 后备 Windows TFM 产物） |
| 零写入复核 | 宿主链 5 工程 `obj\project.assets.json` mtime 与 p1-07 基线逐字节一致 |

---

## 1. 任务 0：csproj AvaloniaResource 接线

### 1.1 接线目标（p1-07 §6 表 / p1-01 §6.2）

| # | 资源路径 | 消费锚点 |
| --- | --- | --- |
| 1 | `Themes\CardTypeComponent\Theme.axaml.txt` | `Themes\CardTypeComponent\CardTypeComponentStyles.cs:13`（AssetLoader.Open avares） |
| 2 | `Themes\ClassWidgets\Theme.axaml.txt` | `Themes\ClassWidgets\ClassWidgetsStyles.cs:14` |
| 3 | `Themes\NotchStyle\Theme.axaml.txt` | `Themes\NotchStyle\NotchStyleStyles.cs:13` |
| 4 | `Themes\ClassWidgets\上课.png` | `Themes\ClassWidgets\ClassWidgetsCard.axaml:38` |
| 5 | `Themes\ClassWidgets\课间休息.png` | `Themes\ClassWidgets\ClassWidgetsCard.axaml:53` |
| 6 | `Themes\ClassWidgets\无课程.png` | `Themes\ClassWidgets\ClassWidgetsCard.axaml:68` |

### 1.2 精确 diff

```diff
--- a/src/SystemTools.CrossPlatform/SystemTools.CrossPlatform.csproj
+++ b/src/SystemTools.CrossPlatform/SystemTools.CrossPlatform.csproj
@@ -110,4 +110,16 @@
         <OutputType>Library</OutputType>
     </PropertyGroup>
 
+    <!-- p1-10 工部接线：6 项 AvaloniaResource（源 SystemTools.csproj:31-36 同形）——
+         3 个 Theme.axaml.txt 由 CardTypeComponent/ClassWidgets/NotchStyle Styles.cs 运行期 AssetLoader.Open 装载；
+         3 个 PNG 由 ClassWidgetsCard.axaml 位图 URI 消费。Avalonia 默认收集面不含 .txt/.png，必须显式接线。 -->
+    <ItemGroup>
+        <AvaloniaResource Include="Themes\CardTypeComponent\Theme.axaml.txt" />
+        <AvaloniaResource Include="Themes\ClassWidgets\Theme.axaml.txt" />
+        <AvaloniaResource Include="Themes\NotchStyle\Theme.axaml.txt" />
+        <AvaloniaResource Include="Themes\ClassWidgets\上课.png" />
+        <AvaloniaResource Include="Themes\ClassWidgets\课间休息.png" />
+        <AvaloniaResource Include="Themes\ClassWidgets\无课程.png" />
+    </ItemGroup>
+
 </Project>
```

### 1.3 接线验证

- 文件 `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` 当前共 125 行；`OutputType=Library`（p0-04/p0-06 修复）、`ApplicationManifest`/`ApplicationIcon` 清除、`None Update="manifest.yml"` 均保留；**仅新增 1 个 ItemGroup（6 项）**。
- 源 `SystemTools.csproj:31-36` 先例形态与本接线逐字一致（`<AvaloniaResource Include=.../>`）。

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
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -nologo -fl "-flp:logfile=build-detailed.log;verbosity=detailed"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | 1 |
| 失败阶段 | Restore → `_GenerateRestoreProjectPathWalk` |
| 错误原文（关键） | `MSB4276: 默认 SDK 解析程序解析 SDK“Microsoft.NET.SDK.WorkloadAutoImportPropsLocator”失败，因为目录“C:\Program Files\dotnet\sdk\10.0.302\Sdks\Microsoft.NET.SDK.WorkloadAutoImportPropsLocator\Sdk”不存在。`（后由 WorkloadMSBuildSdkResolver 成功解析，属环境噪声） |
| 最终失败点 | 多项目 `_GenerateRestoreProjectPathWalk` 目标“已完成… - 失败”，无后续显式错误；未进入编译 |
| 产物 | 无新 DLL；`bin\Release\*` 仍为 p0-06 旧产物 |

**判定**：与阶段 0 p0-06 记录的 G3（本地检出路径 Restore 环境噪声）同源；本次不阻塞结论记录，按用户裁定口径转用 NuGet 后备模式。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-standard-detailed.log`

### 2.3 场景 B：NuGet 后备 Win Release 构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -nologo -fl "-flp:logfile=build-fallback-detailed.log;verbosity=detailed"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | 1 |
| Restore | 成功（`已还原 … 用时 5.85 秒`） |
| 目标 TFM | `net10.0-windows10.0.19041.0` |
| 错误原文 | `Triggers\ActionInProgressTrigger.cs(23,13): error CS0104: “Timer”是“System.Timers.Timer”和“System.Threading.Timer”之间的不明确的引用` |
| 产物 | 无最终 DLL；`bin\Release\…\SystemTools.CrossPlatform.dll` 仍为 5120 B（p0-06 旧产物） |

**判定**：restore/NuGet 后备路径可用；构建失败根因为**源文件 C# 语义歧义**（`System.Timers.Timer` vs `System.Threading.Timer`），非工程接线/包引用/axaml 收集问题。该源文件归属兵部 p1-02，不在本任务“唯一获准产品文件改动”范围内，按派工边界不自行修改。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-win-detailed.log`

### 2.4 场景 C：NuGet 后备 Linux 交叉构建

**命令**

```powershell
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux -nologo -fl "-flp:logfile=build-linux-fallback.log;verbosity=normal"
```

**结果**

| 项 | 值 |
| --- | --- |
| 退出码 | 1 |
| 目标 TFM | `net10.0` |
| PublishBuilding / PublishPlatform | `true` / `linux` |
| 错误原文 | 与场景 B 完全一致：`Triggers\ActionInProgressTrigger.cs(23,13): error CS0104: “Timer”是“System.Timers.Timer”和“System.Threading.Timer”之间的不明确的引用` |
| 产物 | 无最终 DLL |

**判定**：Linux 路径受同一源错误阻塞；cross-platform 编译面一致性已验证到 C# 编译层。

**留档**：`.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-linux.log`

---

## 3. XAML 编译与资源收集证据

### 3.1 axaml 自动收集结论

在 NuGet 后备 Win 构建日志中，Avalonia 构建任务将 **27 个 `.axaml`** 作为 `additionalfile` 传入编译器，完整清单如下（已提取至 `.tang/cases/stcp-cross-platform-001/evidence/p1-10-axaml-additionalfiles.txt`）：

```text
Controls\AiAttachmentDropConfirmation.axaml
Controls\AiAttachmentDropOverlay.axaml
Controls\Components\BetterCarouselContainerComponent.axaml
Controls\Components\BetterCarouselContainerSettingsControl.axaml
Controls\Components\ClipboardContentComponent.axaml
Controls\Components\ClipboardContentSettingsControl.axaml
Controls\Components\LocalQuoteComponent.axaml
Controls\Components\LocalQuoteSettingsControl.axaml
Controls\Components\NetworkStatusComponent.axaml
Controls\Components\NetworkStatusSettingsControl.axaml
Controls\Components\NextClassDisplayComponent.axaml
Controls\Components\NextClassDisplaySettingsControl.axaml
Controls\Components\ScrollingTextComponent.axaml
Controls\Components\ScrollingTextSettingsControl.axaml
Controls\InTimePeriodRuleSettingsControl.axaml
Controls\Notifications\AiReplyNotificationContent.axaml
SettingsPage\AboutSettingsPage.axaml
SettingsPage\AiChatSettingsPage.axaml
SettingsPage\FloatingWindowEditorSettingsPage.axaml
SettingsPage\MoreFeaturesOptionsSettingsPage.axaml
SettingsPage\PluginDebugSettingsPage.axaml
SettingsPage\SystemToolsSettingsPage.axaml
Themes\CardTypeComponent\Styles.axaml
Themes\ClassWidgets\ClassWidgetsCard.axaml
Themes\ClassWidgets\Styles.axaml
Themes\NotchStyle\Styles.axaml
Views\AiChatFloatingWindow.axaml
```

- 数量与 p1-07 §5.2 / p1-08 §2.3 统计的 27 个 `.axaml` 一致。
- 编译器命令行包含 `/resource:obj\Release\net10.0-windows10.0.19041.0\/Avalonia/resources,"!AvaloniaResources"`，证明 XAML 资源打包目标已执行。
- **日志中未出现任何 `XAMLIL` / `XAML` / `axaml` 相关编译错误**。

### 3.2 显式接线资源收集结论

构建日志 `GenerateAvaloniaResources` 阶段列出全部 `avares` 条目，其中本任务接线 6 项均在场：

| 资源 | avares 名 | 大小（字节） |
| --- | --- | --- |
| `Themes\CardTypeComponent\Theme.axaml.txt` | `/Themes/CardTypeComponent/Theme.axaml.txt` | 68,065 |
| `Themes\ClassWidgets\Theme.axaml.txt` | `/Themes/ClassWidgets/Theme.axaml.txt` | 33,661 |
| `Themes\NotchStyle\Theme.axaml.txt` | `/Themes/NotchStyle/Theme.axaml.txt` | 12,740 |
| `Themes\ClassWidgets\上课.png` | `/Themes/ClassWidgets/上课.png` | 132,936 |
| `Themes\ClassWidgets\课间休息.png` | `/Themes/ClassWidgets/课间休息.png` | 143,419 |
| `Themes\ClassWidgets\无课程.png` | `/Themes/ClassWidgets/无课程.png` | 126,817 |

### 3.3 XAML 编译面结论

- Avalonia `buildTransitive` 默认 `.axaml` 收集**在真实构建中生效**。
- 6 项 `.txt`/`.png` 因显式 `AvaloniaResource` 接线成功进入资源清单；**未接线将必然导致运行期 `AssetLoader.Open` / 位图 URI 解析失败**。
- 当前阻碍构建的是 C# 编译层源文件歧义，与 XAML/资源接线无关。

---

## 4. 任务 2：macOS 静态兼容证据汇总

### 4.1 五批 macOS 五列自检表结论

| 批次 | 文件 | 行数 | “可用” | “不适用” | 结论 |
| --- | --- | ---: | ---: | ---: | --- |
| p1-01 | `evidence/p1-01-war-themes-components.md` §4 | 25 | 25 | 0 | 全部可用 |
| p1-02 | `evidence/p1-02-war-rules-triggers.md` §4 | 19 | 19 | 0 | 全部可用 |
| p1-03 | `evidence/p1-03-war-actions.md` §4 | 21 | 21 | 0 | 全部可用 |
| p1-04 | `evidence/p1-04-war-services.md` §7 | 18 | 18 | 0 | 全部可用 |
| p1-06 | `evidence/p1-06-rites-registration-settings.md` §6 | 19 | 19 | 0 | 全部可用 |
| **合计** | | **102** | **102** | **0** | 零阻塞项 |

### 4.2 降级 / 隔离处置登记

| 来源 | 处置项 | 处置方式 | 依据 |
| --- | --- | --- | --- |
| p1-03 §2 | D1/D2 `ILauncherService.LaunchUrl` 替代 `Process.Start` | 跨平台替代（已批降级口径） | 04-spec 已批、U3 宿主抽象 |
| p1-03 §2 | D3 `Process.GetProcesses()` 替代 `tasklist` | 跨平台替代 | 04-spec 已批、尚书省第二道裁决 |
| p1-03 §2 | D4 注释死代码 `taskkill` 块 | 删除 | p1-05 §5.2-2 |
| p1-03 §2 | D5/D6/D7 悬浮窗服务面 → `FloatingWindowProfileManager` + `MainConfig` | 阶段 1 架构适配 | 05 阶段合同阶段 1 |
| p1-03 §2 | D8 `DependencyPaths.GetDependencyRoot()` → 本插件独立配置目录 | 存储根适配 | 04-spec S7/R5 独立配置 |
| p1-03 §2 | D9 `OperatingSystem.IsWindows()` 守卫分支 ×2 | 原样保留 | 04-spec S4.2 允许项 |
| p1-04 §2.1 | AI 液态玻璃/背景采样整族 | 删除（按已批准降级口径） | 04-spec R-6 / U5 |
| p1-04 §2.2 | Vosk 语音族 | 不迁入 | 04-spec S4.1 / S7-R2 |
| p1-04 §2.3 | 其他 C 档服务 | 不迁入 | p0-03 / 04-spec |
| p1-06 §4 | 主设置页 `RestartClassIsland()` → `RequestRestart()` | 跨平台替代 | 04-spec 已批 |

### 4.3 守卫分支保留声明

- `Actions\BackgroundPlayAudioAction.cs:89` 与 `Controls\BackgroundPlayAudioSettingsControl.cs:149` 的 `OperatingSystem.IsWindows()` 分支**保留原样**（04-spec S4.2 明示允许项），仅影响 Windows 盘符 URI 归一化，macOS/Linux 分支不执行。

### 4.4 刑部门禁结果

- p1-08 全树 Source 面 119 文件逐文件矩阵：**GateHits=0 / InfoHits=0 / VERDICT: PASS / exit=0**。
- 脱离扫描器的结构抽核（p1-08 §6）：禁用符号集合零命中、`SystemTools.` 引用串 100% 为 `SystemTools.CrossPlatform.*` 形态、`namespace` 114 个文件全部镜像目录。

### 4.5 macOS 代码路径兼容性结论

- 全部 Windows 专属路径已**条件隔离**（`OperatingSystem.IsWindows()` 守卫）或**按已批准降级口径处理**（删除、跨平台替代、阶段 1 架构适配）。
- 五批自检表 102/102 项 macOS 语义“可用”，零“不适用”阻塞。
- G1–G3 缺口接口（`ISystemEventsService` / `IDesktopService` 等）在阶段 1 A 档代码中**零暴露**。
- 真机 / 标准构建重放仍受 G1 macOS 环境缺口约束，**留阶段 4 或用户指定时机**。

---

## 5. 任务 3：产物预算补记（第四轮构建成功后闭合）

NuGet 后备 Win/Linux Release 经第四轮修复后均构建成功，`bin\Release` 已更新为阶段 1 真实产物：

| 目录 | 文件 | 大小 | 说明 |
| --- | --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | SystemTools.CrossPlatform.dll | **1,349,120** | 阶段 1 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 211,960 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 1,129 | 新产物 |
| | SystemTools.CrossPlatform.runtimeconfig.json | 554 | 新产物 |
| | manifest.yml | 1,430 | 未变 |
| | Microsoft.Windows.SDK.NET.dll | 24,877,600 | Windows TFM 运行库，由 NuGet 后备 Windows 构建复制 |
| | WinRT.Runtime.dll | 528,944 | 同上 |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll | **1,349,120** | 阶段 1 真实产物（文件版本 1.0.0.0） |
| | SystemTools.CrossPlatform.pdb | 207,096 | 新产物 |
| | SystemTools.CrossPlatform.deps.json | 469 | 新产物 |
| | SystemTools.CrossPlatform.runtimeconfig.json | 377 | 新产物 |
| | manifest.yml | 1,430 | 未变 |

**体积对比闭合**：插件 DLL 由阶段 0 空壳 **5,120 B** → 阶段 1 真实体积 **1,349,120 B**（增量约 1.28 MB，双 TFM 一致）。

**文件版本**：双 TFM `SystemTools.CrossPlatform.dll` 的 `FileVersion` = `1.0.0.0`，`ProductVersion` = `1.0.0+ff0ffd786d147aa64a8a8c…`（与 p0-06 基线同一信息版本，由 manifest/构建来源决定）。
| | WinRT.Runtime.dll | 528,944 | **同上实验残留** |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll | 5,120 | 旧产物 |
| | 其他 deps/runtimeconfig/manifest | 旧值 | |

**补记口径**：

- 插件 DLL 由 5120 B 空壳 → 真实体积的对比**待源错误修复后重跑构建再补记**。
- 默认本地检出形态产物应**不复制** `Microsoft.Windows.SDK.NET.dll` / `WinRT.Runtime.dll`（因 `Private=false` / `ExcludeAssets=runtime;native`）；当前残留为 p0-06 实验产物，真实构建成功后会由新输出覆盖。

---

## 6. 任务 4：零写入复核

### 6.1 宿主链 5 工程 obj mtime

| 工程 | 路径 | LastWriteTimeUtc | 与 p1-07 §1 基线一致性 |
| --- | --- | --- | --- |
| PluginSdk | `E:\ClassIsland-git-misha\ClassIsland.PluginSdk\obj\project.assets.json` | 2026-09-01T07:39:08.0547438Z | ✓ 一致 |
| Core | `E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json` | 2026-09-02T05:11:23.9027056Z | ✓ 一致 |
| Platforms.Abstractions | `E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\obj\project.assets.json` | 2026-09-01T07:39:07.8858490Z | ✓ 一致 |
| Shared | `E:\ClassIsland-git-misha\ClassIsland.Shared\obj\project.assets.json` | 2026-09-01T07:39:07.8858490Z | ✓ 一致 |
| Shared.IPC | `E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\obj\project.assets.json` | 2026-09-01T07:39:07.8858490Z | ✓ 一致 |

### 6.2 源插件 / 其他产品文件

- 源插件 `E:\My Github Projects\SystemTools` 全程只读，零写入。
- 除 csproj 接线外，未修改任何 `.cs`、`.axaml`、`.yml`、`.json`、`.slnx`、global.json 等产品文件。
- 构建日志已从 `src\SystemTools.CrossPlatform\` 根目录清理，仅保留 `obj\*` / `bin\*` 构建产物目录（按派工边界允许）。

---

## 7. 残余差距声明

| 项 | 状态 | 说明 |
| --- | --- | --- |
| G1 macOS 构建 | 维持留档 | 无 macOS 构建机/交叉链，静态兼容证据已成立，真机重放留阶段 4 |
| G3 标准本地路径 | 仍受 MSB4276 环境噪声影响 | Restore 阶段失败，未进入编译；按用户裁定口径以 NuGet 后备模式为准 |
| cipx 打包 | 阶段 4 | `CreateCipx` 仍未设置，cipx 发布面核验留阶段 4 |
| 源错误 CS0104 | **新增阻塞** | `Triggers\ActionInProgressTrigger.cs:23` `Timer` 歧义导致 Win/Linux Release 均失败；归属兵部 p1-02，需修复后重跑构建 |

---

## 8. 命令与版本可重放

```powershell
# 环境版本
dotnet --version   # => 10.0.302

# 接线后 csproj 复核
Get-Content src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj

# 标准本地 Release（预期仍失败于 Restore/G3）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release

# NuGet 后备 Win Release（当前因 CS0104 失败）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false

# NuGet 后备 Linux（当前因同一 CS0104 失败）
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux

# macOS 静态证据重放（只读）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source
# 预期：SourceFiles=119, GateHits=0, InfoHits=0, VERDICT: PASS, exit=0

# 宿主 obj 零写入复核
Get-Item E:\ClassIsland-git-misha\ClassIsland.PluginSdk\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Core\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Platforms.Abstractions\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Shared\obj\project.assets.json,
         E:\ClassIsland-git-misha\ClassIsland.Shared.IPC\obj\project.assets.json |
    Select-Object FullName,LastWriteTimeUtc
```

---

## 9. 边界声明

- 本任务写入严格受限：csproj 接线 + 构建产生的 `obj\*` / `bin\*` + 本案 `evidence/p1-10-*`。
- 未触碰源插件、宿主检出、兵部/礼部/刑部/户部已交付文件。
- 发现的产品源错误 `CS0104` 未自行修复，按派工边界记录并上报尚书省/兵部处置。
- 本文件不推进、不审批全局工作流；属工部批级验证证据，报尚书省以 `tang_record_ministry_result` 记录。

---

## 10. 补充复验（p1-02 修复 `ActionInProgressTrigger.cs` `Timer` 歧义后）

### 10.1 修复来源

- 兵部 p1-02 回报：`Triggers\ActionInProgressTrigger.cs` 裸 `Timer` 两处（`:23` 字段声明、`:41` `new Timer(...)`）均完全限定为 `System.Timers.Timer`（保持源 `Elapsed` 事件语义）。
- 兵部复扫：S4.2 单文件直扫 PASS；等效语境 Roslyn 编译 error=0。

### 10.2 复验命令

```powershell
# Win NuGet 后备 Release
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false

# Linux NuGet 后备交叉构建
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

### 10.3 复验结果

| 场景 | 退出码 | 结果 | 关键输出 |
| --- | ---: | --- | --- |
| NuGet 后备 Win Release | 1 | **失败** | `Controls\KillProcessSettingsControl.cs(178,42): error CS1061: “IClipboard”未包含“SetTextAsync”的定义，并且找不到可接受第一个“IClipboard”类型参数的可访问扩展方法“SetTextAsync”(是否缺少 using 指令或程序集引用?)` |
| NuGet 后备 Linux | 1 | **失败** | 与 Win 同一 `CS1061` 错误 |

- `Triggers\ActionInProgressTrigger.cs` 原 `CS0104` 错误已消除（未再出现）。
- 新阻塞点为 `Controls\KillProcessSettingsControl.cs:178` 对 `IClipboard.SetTextAsync` 的调用，属 Avalonia 剪贴板 API 用法/API 可用性问题；该文件归属兵部 p1-02 / p1-03 设置控件域，不在本任务获准改动范围。
- 产物未更新：`bin\Release\…\SystemTools.CrossPlatform.dll` 仍为 5120 B 空壳。

### 10.4 XAML/资源收集结论（引用 §3 不变）

- 复验日志再次确认：27 个 `.axaml` 以 `additionalfile` 收集、6 项显式接线资源进入 `avares` 清单；**未出现 axaml/XAMLIL 错误**。
- 资源接线正确性已由复验 reaffirm。

### 10.5 产物预算补记（仍待构建成功后闭合）

因第二处源错误 `CS1061` 阻塞，真实体积仍无法生成。当前 `bin\Release` 状态与 §5 一致：

| 目录 | DLL 大小 | 状态 |
| --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | 5,120 B | 旧产物 |
| `bin\Release\net10.0\` | 5,120 B | 旧产物 |

### 10.6 留档

- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-win-rerun.log`
- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-linux-rerun.log`

### 10.7 补充复验结论

- **补充复验：failed**。
- 阶段 1 A 档代码在真实 .NET 10 + Avalonia 12.1.1 编译闭包下仍存在一处 API 用法错误（`IClipboard.SetTextAsync`），需兵部/礼部按源码证据修正后再次重跑。
- macOS 静态兼容证据、csproj 接线、XAML/资源收集结论、宿主零写入结论均保持成立。

---

## 11. 第三轮复验（p1-03 恢复 `using Avalonia.Input.Platform` 修复 CS1061 后）

### 11.1 修复来源

- 兵部 p1-03 回报：`Controls\KillProcessSettingsControl.cs` 在适配时误删必需 using `Avalonia.Input.Platform`；恢复一行（D10 登记）。
- 经查证，`SetTextAsync` 为 `ClipboardExtensions` 扩展方法，命名空间 `Avalonia.Input.Platform`。
- 树内同型排查确认无其他同类缺陷。

### 11.2 复验命令

```powershell
# Win NuGet 后备 Release
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false

# Linux NuGet 后备交叉构建
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

### 11.3 复验结果

| 场景 | 退出码 | 结果 | 关键输出 |
| --- | ---: | --- | --- |
| NuGet 后备 Win Release | 1 | **失败** | `Themes/ClassWidgets/ClassWidgetsCard.axaml(92,17,92,17): Avalonia error AVLN2000: Unable to find IsBackgroundMaterialEnabledProperty field on type ClassIsland.Core.Assists.MainWindowStylesAssist,ClassIsland.Core Line 92, position 17.` |
| NuGet 后备 Linux | 1 | **失败** | 与 Win 同一 `AVLN2000` XAML 编译错误 |

- 前两轮 C# 层错误（`CS0104`、`CS1061`）均已消除。
- 新阻塞点为 **Avalonia XAML 编译错误**：`ClassWidgetsCard.axaml:92` 引用的 `MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty` 在目标宿主版本（本地检出 / NuGet 后备 2.1.1.1 的 `ClassIsland.Core`）中不存在。
- 该 `.axaml` 归属兵部 p1-01 主题/组件抽取域，不在本任务获准改动范围。

### 11.4 XAML 收集终态

- 构建日志仍显示 27 个 `.axaml` 被 Avalonia 任务收集为 `additionalfile`，6 项显式接线资源进入 `avares` 清单。
- 本次是**首次出现 axaml 编译错误**（`AVLN2000`），证明 XAML 编译器已真实进入 XAMLIL 解析阶段；此前两轮未到达该阶段即被 C# 错误中断。

### 11.5 产物预算（仍未闭合）

因 `AVLN2000` 阻塞，真实体积仍无法生成。当前 `bin\Release` 状态：

| 目录 | DLL 大小 | 状态 |
| --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | 5,120 B | 旧产物 |
| `bin\Release\net10.0\` | 5,120 B | 旧产物 |

### 11.6 留档

- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-win-r3.log`
- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-linux-r3.log`

### 11.7 第三轮复验结论

- **第三轮复验：failed**。
- 阶段 1 A 档代码在真实 XAML 编译阶段暴露一处主题资源键/附加属性引用错误（`ClassWidgetsCard.axaml:92` 的 `IsBackgroundMaterialEnabledProperty`），需兵部 p1-01 按目标宿主 API 基线修正后再次重跑。
- csproj 接线、macOS 静态兼容证据、宿主零写入结论保持成立。

---

## 12. 第四轮复验（p1-01 移除 `ClassWidgetsCard.axaml` `IsBackgroundMaterialEnabled` 附加属性引用后）

### 12.1 修复来源

- 兵部 p1-01 回报：`Themes\ClassWidgets\ClassWidgetsCard.axaml:92` 移除 `IsBackgroundMaterialEnabled` 附加属性引用（U5 降级口径）。
- 根因精确化：**双分支 API 漂移**——该字段在 U3 本地检出 `ClassIsland.Core\Assists\MainWindowStylesAssist.cs:56-60` 源码中存在，但在 NuGet 后备 `ClassIsland.Core 2.1.1.1` 包二进制中缺位。
- 横查 99 文件确认无其他缺位引用。

### 12.2 复验命令

```powershell
# Win NuGet 后备 Release
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false

# Linux NuGet 后备交叉构建
dotnet build src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj -c Release -p:UseLocalClassIslandSdk=false -p:PublishBuilding=true -p:PublishPlatform=linux
```

### 12.3 复验结果

| 场景 | 退出码 | 结果 | 关键输出 |
| --- | ---: | --- | --- |
| NuGet 后备 Win Release | 0 | **成功** | `SystemTools.CrossPlatform -> bin\Release\net10.0-windows10.0.19041.0\SystemTools.CrossPlatform.dll` |
| NuGet 后备 Linux | 0 | **成功** | `SystemTools.CrossPlatform -> bin\Release\net10.0\SystemTools.CrossPlatform.dll` |

- 此前 C# 错误（`CS0104`、`CS1061`）与 XAML 错误（`AVLN2000`）均未再现。
- 仅余 28 个 `CS8602` 可空引用警告，不影响构建通过。

### 12.4 产物清单与真实体积

| 目录 | 文件 | 大小 | 说明 |
| --- | --- | ---: | --- |
| `bin\Release\net10.0-windows10.0.19041.0\` | SystemTools.CrossPlatform.dll | 1,349,120 | 文件版本 1.0.0.0 |
| | SystemTools.CrossPlatform.pdb | 211,960 | |
| | SystemTools.CrossPlatform.deps.json | 1,129 | |
| | SystemTools.CrossPlatform.runtimeconfig.json | 554 | |
| | manifest.yml | 1,430 | |
| | Microsoft.Windows.SDK.NET.dll | 24,877,600 | NuGet 后备 Windows TFM 产物 |
| | WinRT.Runtime.dll | 528,944 | NuGet 后备 Windows TFM 产物 |
| `bin\Release\net10.0\` | SystemTools.CrossPlatform.dll | 1,349,120 | 文件版本 1.0.0.0 |
| | SystemTools.CrossPlatform.pdb | 207,096 | |
| | SystemTools.CrossPlatform.deps.json | 469 | |
| | SystemTools.CrossPlatform.runtimeconfig.json | 377 | |
| | manifest.yml | 1,430 | |

**预算补记闭合**：插件 DLL 由阶段 0 空壳 **5,120 B** → 阶段 1 真实体积 **1,349,120 B**（双 TFM 一致）。

### 12.5 双分支 API 漂移事实登记

- **事实**：`MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty` 在 U3 本地检出源码中存在，在 `ClassIsland.Core 2.1.1.1` NuGet 包二进制中不存在。
- **影响**：NuGet 后备构建路径触发 `AVLN2000`；U3 本地检出路径不会触发。
- **处置**：p1-01 已按 U5 降级口径移除引用，两分支现均通过。
- **约束候选**：阶段 2+ 若恢复背景材质/液态玻璃相关特性，须以 NuGet 包二进制实际暴露的 API 为发布面基线，避免再次漂移。

### 12.6 XAML/资源收集终态

- 27 个 `.axaml` 被 Avalonia 任务以 `additionalfile` 收集，6 项显式接线资源进入 `avares` 清单；第四轮无 XAMLIL 错误。
- 资源接线与 XAML 收集结论最终成立。

### 12.7 留档

- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-win-r4.log`
- `.tang/cases/stcp-cross-platform-001/evidence/p1-10-build-fallback-linux-r4.log`

### 12.8 第四轮复验结论

- **第四轮复验：succeeded**。
- 在用户裁定口径（NuGet 后备模式）下，Win/Linux Release 构建均 exit=0，阶段 1 产物体积与文件版本已记录。
- 标准本地路径（G3 MSB4276 环境噪声）未重试，维持 §2.2 记录；macOS 静态兼容证据、宿主零写入结论保持成立。
