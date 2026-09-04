# p2-02 证据：B 档文件夹递归 3 + 零散行动 2 及其服务抽取（兵部 war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-02 · 兵部 war · application-code / implementation（依赖 p2-05，已 succeeded；前次派工因基础设施故障零产物中断，本件为重派全新执行） |
| 权威输入 | p0-03 §3.2 B 清单（B1/B2/B3/B13/B14 行锚点）、06 条目 34/35/36/47/48（替换目标/降级/边界）、p2-05 §1.2 p2-02 落点行 + §2.1 #8/#9 共享增补预批 + §4 双分支 API 核对、p1-05 落位规范（含 R1）、p1-10 §12.5 双分支 API 漂移约束、04-spec §S4.2、p1-03 升级版批内编译自检方法、尚书省重派裁决 3 条 |
| 交付范围 | 新增 17 个文件：`Actions\` 5 + `Settings\` 5 + `Controls\` 平铺 5 + `Services\` 2；增补共享类型 `ConfigHandlers\MainConfigData.cs` 2 个 B 档成员（尚书省预批 p2-05 §2.1 #8/#9）；**零条件文件**（适配点 AD2 说明） |
| 结论 | **succeeded** —— 7 项（B1/B2/B3 各含 Settings+Control、B13、B14）+ 2 服务全部落位，与 p2-05 §1.2 p2-02 行一一对应；S4.2 扫描 5/5 落点 PASS（exit=0，GateHits=0，CONDITIONAL=0）；Roslyn 批内自检 COMPILE OK（error=0，34 警告全部为 CS1701/CS1702 程序集统一化噪声，交付文件零实质警告）；macOS 自检表 0 项"不适用"；06 条目 47/48 偏差注记已登记；未改 Plugin.cs / manifest.yml / csproj / global.json / slnx |
| 条件文件需求 | **无**（B14 源 OCR 链虽为 Windows 专属，但其唯一帧源——背景捕获服务——属 C 档采样面未随任何 B 批迁移，条件隔离 OCR 无可运行输入链，见 AD2） |

---

## 1. 逐项源锚点 → 新落点对照（新文件与 B 档 7 项一一对应）

### 1.1 文件夹递归三行动（06 条目 34/35/36，R-1）

| 项 | 功能名 | 源文件:行（ActionInfo / 专属点） | 新落点 | 关键新锚点（file:line） |
| --- | --- | --- | --- | --- |
| B1 | 复制 | `Actions\CopyAction.cs:12`（:28-35 shell 初始化、:96-110 外部工具文件夹分支） | `Actions\CopyAction.cs` | :11 ActionInfo；:31-32 跨平台路径处理；:56 文件分支 File.Copy；:90/:105-125 BCL 递归复制（guard :118） |
| B2 | 移动 | `Actions\MoveAction.cs:12`（:96-110 外部工具 /move 分支） | `Actions\MoveAction.cs` | :11 ActionInfo；:56 文件分支 File.Move；:94 Directory.Move（同卷优先）；:100 跨卷回退递归复制；:104-109 源删除失败=移动未完整完成可见失败 |
| B3 | 删除 | `Actions\DeleteAction.cs:12`（:27-35 shell 初始化、:69-80 递归删除分支） | `Actions\DeleteAction.cs` | :11 ActionInfo；:42 文件分支 File.Delete；:66 BCL 递归删除 |

设置与控件附属（随功能项走，p1-05 §2.3-1；文件名/类型名随源不改）：

| 功能项 | 源文件（源锚） | 新落点 | 说明 |
| --- | --- | --- | --- |
| B1 | `Settings\CopySettings.cs:5` | `Settings\CopySettings.cs` | JSON 名逐字随源 |
| B1 | `Controls\CopySettingsControl.cs:12` | `Controls\CopySettingsControl.cs` | 文件/文件夹选择器为 Avalonia 跨平台 StorageProvider |
| B2 | `Settings\MoveSettings.cs:5` | `Settings\MoveSettings.cs` | |
| B2 | `Controls\MoveSettingsControl.cs:12` | `Controls\MoveSettingsControl.cs` | |
| B3 | `Settings\DeleteSettings.cs:5` | `Settings\DeleteSettings.cs` | |
| B3 | `Controls\DeleteSettingsControl.cs:12` | `Controls\DeleteSettingsControl.cs` | |
| B13 | `Settings\AutoSwitchClassIslandThemeActionSettings.cs:5` | `Settings\AutoSwitchClassIslandThemeActionSettings.cs` | 控件名含 Action 段随源不改（p1-05 §3.4-1） |
| B13 | `Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs:7` | `Controls\AutoSwitchClassIslandThemeActionSettingsControl.cs` | |
| B14 | `Settings\AutoHideMainWindowWhenOccludedActionSettings.cs:5` | `Settings\AutoHideMainWindowWhenOccludedActionSettings.cs` | |
| B14 | `Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs:7` | `Controls\AutoHideMainWindowWhenOccludedActionSettingsControl.cs` | |

### 1.2 零散行动 2 + 其服务 2（06 条目 47/48，按尚书省裁决 1 以源自含逻辑本地实现落地）

| 项 | 功能名 | 源文件:行 | 新落点 | 关键新锚点（file:line） |
| --- | --- | --- | --- | --- |
| B13 | 自动切换 ClassIsland 主题 | `Actions\AutoSwitchClassIslandThemeAction.cs:14`（:30-32 写配置+ApplyConfig） | `Actions\AutoSwitchClassIslandThemeAction.cs` | :14 ActionInfo；:31 写 `config.AutoSwitchClassIslandTheme`；:32 ApplyConfig；:41-47 NotifyOnExecute 通知路径 |
| B13 服务 | AdaptiveThemeSyncService | `Services\AdaptiveThemeSyncService.cs:10`（:44 开关门；:24-29 Start、:31-39 Stop、:41-53 ApplyConfig） | `Services\AdaptiveThemeSyncService.cs` | :21 Start；:27 Stop；:33 ApplyConfig；:38 配置开关门；:46-52 降级通知 |
| B14 | 遮挡文字时隐藏主界面 | `Actions\AutoHideMainWindowWhenOccludedAction.cs:14`（:30-32） | `Actions\AutoHideMainWindowWhenOccludedAction.cs` | :14 ActionInfo；:31 写 `config.AutoHideMainWindowWhenOccluded`；:32 ApplyConfig |
| B14 服务 | MainWindowTextOcclusionService | `Services\MainWindowTextOcclusionService.cs:19`（:102/:108 读配置；:37 Start、:78 Stop、:68 Shutdown、:49 Suspend） | `Services\MainWindowTextOcclusionService.cs` | :28 Start；:39 Suspend；:58 Shutdown；:68 Stop；:74 ApplyConfig；:83 恢复调用位（等价空操作）；:91 配置开关门；:39-56/:109-135 Suspend/Resume/SuspensionLease 逐行随源保留 |

方法体随源声明：B13/B14 行动 OnInvoke、设置类型、两控件为逐字随源（仅命名空间/ID 前缀变换）；服务生命周期方法（Start/Stop/Shutdown/Suspend/SuspensionLease/Resume）逐行随源，检测/采样方法体按已批降级处置不迁（§2 AD1–AD4）。

---

## 2. 适配点登记（含 06 偏差注记）

| # | 位置 | 源实现 | 处置 | 依据/说明 |
| --- | --- | --- | --- | --- |
| AD1 | B13 服务 ApplyConfig（源 :41-53，含 :44 `!OperatingSystem.IsWindows()` 分支与 :49-52 采样租约/计时器启动） | 亮度采样链（连续背景捕获 + 平均亮度 → 主机主题索引写入） | **降级落地（06 条目 47 偏差注记）**：宿主主题平台接口双分支 ABSENT（p2-05 §4）→ 按尚书省裁决以插件本地实现落地；源采样链属 C 档采样面（06 服务域清单、U5），其两个依赖文件（背景捕获服务、亮度计算器）均不在 p2-05 §1.2 任何批次交付清单内，未随任何 B 批迁移 → 依 06 条目 47 降级行为：探测不可用即停止自动同步、保持当前主题、经 `IDesktopToastService` 通知"自动主题同步不可用"、记录原因、不抛未处理异常（新 :46-52）；源 :44 的非 Windows 整体限制分支随降级形删除（探测后端全平台不可用，无平台分叉必要，属 04-spec §S4.2 允许的守卫分支处置） | p2-05 §4 IThemePlatformService ABSENT；06 条目 47 降级；p0-03 §3.2 B13"无采样退化跟随宿主明暗/手动" |
| AD2 | B14 服务检测链（源 :113-125 引擎/捕获启动、:167-333 检测循环/OCR/位图转换全链） | 背景捕获 + 本地 OCR（WinRT Windows.Media 链）识别字符数驱动主界面显隐 | **降级落地（06 条目 48 偏差注记）+ 零条件文件**：宿主遮挡检测接口双分支 ABSENT（p2-05 §4）→ 插件本地实现；OCR 链为 Windows 专属且无 BCL/命令行等价，但其唯一帧源背景捕获服务属 C 档采样面未随任何 B 批迁移——条件隔离 OCR（`#if` guard 或 *Windows.cs）仍无可运行输入链，落地反而需为 C 档采样重建输入面、越出 B 档边界（U5"背景捕获/自适应采样不作为 A/B 必须能力"）→ 全检测链不迁，依 06 条目 48 降级行为：关闭检测并保持主界面可见（本服务从不隐藏主界面，"恢复主界面可见"为结构真值），经 `IDesktopToastService` 通知"遮挡检测已降级/未启用"、记录、不抛未处理异常、不将未知状态解释为应隐藏（新 :91-97）。源恢复主界面所用的宿主设置反射辅助服务不在本批 7 项清单内且宿主 SDK 双分支无对应公开 API，未迁移（如后续批需要，按 p1-05 §2.3 共享增补流程登记） | p2-05 §4 ITextOcclusionDetectionService ABSENT；06 条目 48 降级；尚书省裁决 1（"确需 Windows 专属机制且无 BCL 等价**可**按条件文件处理"为许可而非强制，本批以零条件文件满足） |
| AD3 | B13 服务 Start/Stop（源 :24-39 计时器挂接/停止、捕获租约释放） | DispatcherTimer + 捕获租约 + 取消任务 | **等价空实现**：降级形无计时器/捕获租约/取消任务对象，保留方法签名与调用面（注册面源先例 :119/:215/:1041 三点接线不变），Start 直呼 ApplyConfig、Stop 为生命周期复位；ApplyConfig 保留"先 Stop 再判开关门"的源形状 | 生命周期形状随源，降级语义见 AD1 |
| AD4 | B14 服务 Start/Stop/Shutdown/Suspend/Resume（源 :37-92/:128-165） | 计时器/检测任务/捕获租约 + `_hiddenByThisService` 显隐记忆 | **生命周期逐行随源 + 检测面降级**：Start/Shutdown/Suspend/SuspensionLease/Resume/_stateLock/_suspensionCount/_isShuttingDown 逐行随源（挂起消费方为 C 档 AI 语音覆盖层未迁移，机制零平台依赖、供后续复用）；Stop 保留签名，恢复主界面语义无对象（从不隐藏，AD2）为等价空操作；ApplyConfig 保留源 :94-111 的"挂起判定→Stop(restoreMainWindow:)→开关门"形状（新 :74-97） | 同上 |
| AD5 | B1/B2/B3 文件夹分支 | shell 子进程初始化块（源 Copy :28-35、Move :28-35、Delete :27-35）+ 外部命令行工具调用与退出码判定 | **BCL 递归替代（06 条目 34/35/36 替换目标）**：shell 初始化块整体删除，三行动零进程启动、零 shell 拼接（路径参数直传 BCL API，满足 06 条目 36"非 shell 拼接的安全边界"）。复制：建目录 + `File.Copy(overwrite:true)` + 子目录递归（新 Copy :105-125）；移动：`Directory.Move` 同卷原子优先，IOException（跨卷/挂载点差异）回退"递归复制 + 删除源目录"（新 Move :94-109，等价源 /move 语义；目标已复制但源删除失败→记日志并抛行动错误，**部分完成不误报完整成功**）；删除：`Directory.Delete(recursive:true)`，保留源存在性预检，失败记日志并抛（新 Delete :66-74）。文件分支 BCL（File.Copy/Move/Delete）逐行随源 | 06 条目 34/35/36；p0-03 §3.2 B1–B3 |
| AD6 | B1/B2/B3 路径处理（源 Copy/Move :40-41、Delete :39 `TrimEnd('\\')`） | 仅剥离尾随反斜杠 | **跨平台路径适配**：改 BCL `Path.TrimEndingDirectorySeparator`（新 Copy/Move :31-32、Delete :30）——Windows 反斜杠语义等价，Unix 斜杠尾随符正确处理 | 派工约束 3"路径处理跨平台" |
| AD7 | B1/B2 递归复制自递归防护（新 Copy :105-125、guard :118；Move :125-145、guard :138） | （源无此面：外部工具自身排除目标目录） | **等价语义补齐**：目标目录位于源目录内部时跳过该子树，避免把目标复制进自身死循环（与源外部工具的排除行为等价）；路径等值比较 Windows 不区分大小写、其余平台区分（BCL `OperatingSystem.IsWindows()` 运行时守卫） | 06 条目 34 拟纳入边界"保留目标目录/同名目录处理语义" |
| AD8 | B1/B2 元数据语义 | 源外部工具 /copyall 复制 ACL/审核等元数据 | **差异注记（06 明示边界）**：BCL File.Copy 复制内容与基础属性，不复制 ACL/审核元数据——06 条目 35 拟纳入边界明示"不承诺全部元数据复制语义，差异须在同装差异/平台说明中注明"（条目 34 同型），登记为同装差异注记，承接方为阶段 4 同装差异/平台说明文档 | 06 条目 34/35 拟纳入边界 |
| AD9 | B3 文件分支异常文案（源 :55-56"文件移动失败"/"移动失败: {ex}"） | 源原文（复制粘贴笔误文案） | **逐字保留不改写**（方法体随源口径）；登记说明以免复核误判为移植错误 | p1-05 §3.4 抽取不改名/不改行为精神 |
| AD10 | MainConfigData 增补 | 源 `AutoSwitchClassIslandTheme` :113-125、`AutoHideMainWindowWhenOccluded` :230-242 | **共享增补（尚书省预批 p2-05 §2.1 #8/#9）**：新 :248-276 增补 2 成员，JSON 名逐字随源，守卫语义逐行随源（相同值跳过 + PropertyChanged），文件内留痕注释（新 :238-247）；消费点：B13/B14 行动写（源 :30）+ 两服务读（源 :44、:102/:108） | p1-05 §2.3-4 增补流程；本文件 §5 |

---

## 3. macOS 兼容自检表（p1-05 §5.3 五列格式；覆盖本批全部新文件外部依赖点）

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `CopyAction.cs:56`（源 :65） | `File.Copy` | BCL（保留） | 可用（BCL 三平台） |
| 2 | `CopyAction.cs:90,113-124`（源 :96-110 外部工具） | BCL 递归复制（Directory/File API） | BCL 替代（AD5） | 可用（递归复制为纯托管 IO；ACL 元数据差异见 AD8，为全平台注记非 macOS 缺口） |
| 3 | `MoveAction.cs:94`（源 :96-110 外部工具 /move） | `Directory.Move` | BCL 替代（AD5） | 可用（同卷 rename 原子移动） |
| 4 | `MoveAction.cs:100,104-109` | 递归复制 + 删除源回退 | BCL（AD5） | 可用（跨卷/挂载点 IOException 触发回退，语义全平台一致） |
| 5 | `DeleteAction.cs:66`（源 :69-80） | `Directory.Delete(recursive:true)` | BCL 替代（AD5） | 可用 |
| 6 | `CopyAction.cs:31-32`、`MoveAction.cs:31-32`、`DeleteAction.cs:30`（源 TrimEnd） | `Path.TrimEndingDirectorySeparator` | BCL（AD6） | 可用（.NET Core 3.0+ BCL） |
| 7 | `CopyAction.cs:118`、`MoveAction.cs:138` | `OperatingSystem.IsWindows()` 守卫（路径等值比较口径） | BCL 运行时守卫（AD7） | 可用（macOS 分支取 Ordinal 区分大小写，语义正确） |
| 8 | `AdaptiveThemeSyncService.cs:46-52`（源 :49-52 采样链） | `PlatformServices.DesktopToastService.ShowToastAsync` | 宿主抽象（保留，p0-01 §3 #3）+ 按已批降级（AD1） | 可用（macOS DesktopToastService 实装；探测后端不可用为全平台结构事实，本项 toast 在 macOS 同样如实提示并保持当前主题） |
| 9 | `MainWindowTextOcclusionService.cs:91-97`（源 :113-125 检测链） | 同上 toast 宿主抽象 | 宿主抽象（保留）+ 按已批降级（AD2） | 可用（检测后端全平台未迁移，macOS 语义=关闭检测、主界面保持可见、toast 如实提示） |
| 10 | `MainWindowTextOcclusionService.cs:109-135`（源 :128-165） | `Avalonia.Threading.Dispatcher`（Resume 回 UI 线程） | Avalonia 跨平台 API（随源保留） | 可用（Avalonia 三平台） |
| 11 | B13/B14 行动 :41-47/:41-47 | `SystemToolsNotificationProvider.ShowNotification` | 跨批依赖（p1-04 交付，新 GUID 零重合） | 可用（提醒为宿主 Avalonia UI 层） |
| 12 | `CopySettingsControl.cs` 等三控件 BrowsePath | `TopLevel.StorageProvider.OpenFolderPickerAsync/OpenFilePickerAsync` | Avalonia 跨平台 StorageProvider（随源保留） | 可用（macOS 原生选择器后端） |
| 13 | B13/B14 行动 :25-26/:25-26 | `GlobalConstants.MainConfig?.Data`（共享配置根） | 共享类型引用（本批增补 2 成员，AD10） | 可用（BCL JSON 配置写本插件独立目录） |
| 14 | 两服务构造 | `MainConfigHandler`（ConfigHandlers 真实交付） | 共享类型引用 | 可用（BCL IO） |
| 15 | 其余 | BCL 纯 .NET API（IO/JSON/LINQ/Threading） | BCL | 可用（按 p1-05 §5.3 规则不逐项列） |

**结论：15 项依赖点中 0 项"不适用"**（无阻塞项，无需触发 S6 分档复核）；宿主抽象引用与 p0-01 §3 清单一致（`IDesktopToastService`），未发明新接口；缺口 G1–G3（`ISystemEventsService`/`IDesktopService`）本批无消费点；U4 预检口径不涉本批（本批零 OS 命令、零权限动作）。

---

## 4. S4.2 门禁自检与批内编译自检（p1-05 §5.2 / p1-03 §5.1 升级方法）

### 4.1 S4.2 扫描

- 输出留档：`.tang/cases/stcp-cross-platform-001/evidence/p2-02-s42-scan-output.txt`（原始输出，5 段各含 VERDICT 与 exit 码）。
- 执行方式：单一 pwsh 进程内以 `&` 直接调用 p0-07-s42-scan.ps1（ScannerRev R-2），对 5 个交付落点 `-Scope Source` 扫描（嵌套 pwsh 子进程受沙箱命名管道边界限制，p1-03 §5 同款先例）。
- 结果：**5/5 落点 `VERDICT: PASS (zero gate hits)`，每次调用 exit=0，GateHits=0，CONDITIONAL=0，InfoHits=0**——`Actions\`（20 文件含并行批次共存文件）、`Controls\`（31）、`Settings\`（16）、`Services\`（10）、`ConfigHandlers\MainConfigData.cs`（单文件）。
- 条件文件口径：本批**零条件文件**（AD2），CONDITIONAL 计数 0；刑部 R-2 形态未触发。
- 注释清理核对：本批 17 个交付 .cs 注释零禁用符号（shell 工具名等源专属点表述仅出现于本 .md 证据，符合 p1-05 §5.2-2）。

### 4.2 批内补充编译自检（p1-03 升级方法沿例）

- 脚本/输出：`evidence\p2-02-supplementary-compile-check.ps1` / `evidence\p2-02-supplementary-compile-check-output.txt`（非官方构建门禁；官方三平台 dotnet build 仍属阶段级验证，p1-05 §5.2-3）。
- 语境等效性：①引用集 323 个自工部 `p1-10-build-fallback-win-rerun.log` csc `/reference:` token 提取（与真实构建相同，逐路径核在，含 Avalonia 12.1.1 ref 链）；②预处理符号取自同日志 `/define:` 集（`Platforms_Windows` 等 27 项）；③隐式全局 using 存根（.NET SDK 隐式集 7 项）；④跨批依赖消费面存根 1 个（`SystemToolsNotificationProvider` 继承真实 SDK `NotificationProviderBase`，p1-03 同款先例；真实文件不重复入检以免牵入其 AI 通知内容控件闭包）+ MVVM 生成成员存根 1 个（ButtonRulesetConfig/RowRulesetConfig 各 3 个 `[ObservableProperty]` 等价属性，MainConfigData 闭包所需）。
- 入检树：25 = 本批 17 个交付 .cs + 5 个真实共享上下文（MainConfigData【含 p2-02 增补段】/MainConfigHandler/ButtonRulesetConfig/RowRulesetConfig/GlobalConstants）+ 3 个检查专用存根。
- 过程留痕（检查方法失真，非交付代码缺陷）：第一轮 2 个错误为 MainConfigData 对 ButtonRulesetConfig/RowRulesetConfig 的类型引用缺失——入检清单漏列该两真实文件所致（真实构建中工程全量编译无此问题）；补列真实文件 + MVVM 存根后归零。
- 结果：**COMPILE OK（error=0, warning=34）**——34 个警告全部为 CS1701/CS1702 程序集统一化噪声（`<no-source>` 程序集级，真实构建经 /nowarn:1701,1702 抑制），**来自交付文件的警告 0、错误 0**。

## 5. 共享类型增补留痕（p1-05 §2.3-4 流程：预批已得，文件内留痕 + 双方证据互注）

- `ConfigHandlers\MainConfigData.cs` 新 :238-247 留痕注释块 + :248-276 两成员（实际行号已核）：
  - `AutoSwitchClassIslandTheme`（JSON `autoSwitchClassIslandTheme`，源 :113-125）：B13 行动写（源 :30）+ AdaptiveThemeSyncService 读（源 :44）；新文件 :248-261（属性 :251）。
  - `AutoHideMainWindowWhenOccluded`（JSON `autoHideMainWindowWhenOccluded`，源 :230-242）：B14 行动写（源 :30）+ MainWindowTextOcclusionService 读（源 :102/:108）；新文件 :262-275（属性 :265）。
- JSON 属性名与源同名成员逐字一致（配置格式兼容语义）；守卫语义逐行随源（相同值跳过 + `OnPropertyChanged`）；未引入源其余 B/C 成员与 `RestartPropertyChanged` 事件（p2-05 §2.1 决策注记 ②口径：本批无事件消费方）。
- GlobalConstants：**零增补**（本批消费面仅既有 `MainConfig`/`PluginConfigFolder`，p2-05 §2.2 一致）。

## 6. p1-05 §4.2 结构化注册清单（兵部批 → 礼部，注册面禁改声明见 §8）

**说明**：本批 5 个 ActionInfo ID 均为字符串前缀形态，无 GUID 形态注册身份（无 NotificationProviderInfo 等），"新 GUID 零重合"规则不触发。

| 项 | 类型全名 | 功能 ID | 注册目标 | 设置类型全名 | 源锚点（源 Plugin.cs） |
| --- | --- | --- | --- | --- | --- |
| B1 | SystemTools.CrossPlatform.Actions.CopyAction | SystemTools.CrossPlatform.Copy | ActionInfo + 设置控件 CopySettingsControl | SystemTools.CrossPlatform.Settings.CopySettings | :385 |
| B2 | SystemTools.CrossPlatform.Actions.MoveAction | SystemTools.CrossPlatform.Move | ActionInfo + 设置控件 MoveSettingsControl | SystemTools.CrossPlatform.Settings.MoveSettings | :386 |
| B3 | SystemTools.CrossPlatform.Actions.DeleteAction | SystemTools.CrossPlatform.Delete | ActionInfo + 设置控件 DeleteSettingsControl | SystemTools.CrossPlatform.Settings.DeleteSettings | :387 |
| B13 | SystemTools.CrossPlatform.Actions.AutoSwitchClassIslandThemeAction | SystemTools.CrossPlatform.AutoSwitchClassIslandTheme | ActionInfo + 设置控件 AutoSwitchClassIslandThemeActionSettingsControl | SystemTools.CrossPlatform.Settings.AutoSwitchClassIslandThemeActionSettings | :431-432 |
| B14 | SystemTools.CrossPlatform.Actions.AutoHideMainWindowWhenOccludedAction | SystemTools.CrossPlatform.AutoHideMainWindowWhenOccluded | ActionInfo + 设置控件 AutoHideMainWindowWhenOccludedActionSettingsControl | SystemTools.CrossPlatform.Settings.AutoHideMainWindowWhenOccludedActionSettings | :433-434 |
| B13 服务 | SystemTools.CrossPlatform.Services.AdaptiveThemeSyncService | —（非注册身份） | DI：`AddSingleton<AdaptiveThemeSyncService>()`；生命周期：`IAppHost.GetService<AdaptiveThemeSyncService>().Start()` 与 `.Stop()`（源 :119/:215/:1041 三点形态） | —（构造依赖 MainConfigHandler，新插件已有 AddSingleton 先例） | :119/:215/:1041 |
| B14 服务 | SystemTools.CrossPlatform.Services.MainWindowTextOcclusionService | —（非注册身份） | DI：`AddSingleton<MainWindowTextOcclusionService>()`；生命周期：`.Start()` 与 `.Shutdown(restoreMainWindow)`（源 :120/:216/:1043 三点形态） | 同上 | :120/:216/:1043 |

## 7. 结构自检记录（p1-05 §8 复核指引重放，本批范围）

1. 落点核对：17 个新文件逐一落入 p2-05 §1.2 p2-02 行允许落点（Actions\、Controls\ 平铺、Settings\、Services\）；零新目录、零 csproj 接线需求（全部为既有容器目录内追加 .cs，p2-05 §1.3-2 先例）；零 .bat/.ps1/.exe/原生资产。
2. 命名空间核对：17 个新 .cs `namespace` 全部以 `SystemTools.CrossPlatform.` 开头且镜像目录（重放 violations=0）。
3. ID 前缀核对：Actions 5 文件 `"SystemTools\.` 命中 5 行，全部为 `SystemTools.CrossPlatform.*` 形态；源插件 ID 字符串零出现。
4. 禁用 using 核对：`using\s+SystemTools\.(?!CrossPlatform)` 对 17 文件零命中；using 面仅 ClassIsland.*、Avalonia.*、Microsoft.Extensions.*、BCL 与本插件命名空间。
5. 文件名随源核对：17 个文件与 p2-05 §1.2 p2-02 行逐一同名（一文件一主类型；零新造文件名，零命名备案需求）。
6. 双分支 API 漂移约束（p1-10 §12.5）：本批消费的宿主 API 全部属 p2-05 §4 已核 8 面 PRESENT 集（`IDesktopToastService`/`IAppHost`/`NotificationProviderBase`）；两缺位接口（06 条目 47/48 所名）按尚书省裁决 1 以插件本地实现落地（AD1/AD2），零 `ClassIsland.*` 命名空间接口发明（p1-05 §5.3-3）；`MainWindowStylesAssist`（ABSENT 面）本批零引用。

## 8. 边界声明

- 源插件 `E:\My Github Projects\SystemTools` 与宿主检出全程只读（只读读取/检索；零写入）。
- 本任务写入仅限本批落点（`src\SystemTools.CrossPlatform\{Actions,Controls,Settings,Services}` 下 17 个新文件）+ 尚书省预批段（`ConfigHandlers\MainConfigData.cs` 增补 2 成员，p2-05 §2.1 #8/#9）+ 本案 evidence\（本文件、p2-02-s42-scan-output.txt、p2-02-supplementary-compile-check.ps1/.txt）；未改 `Plugin.cs`、`manifest.yml`、csproj、global.json、slnx 及任何其他批次文件。
- 本文件不推进、不审批全局工作流；属批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验。

## 9. 修订记录

- 初版（p2-02 重派执行交付；前次因基础设施故障零产物中断，本件为唯一有效版本）。
