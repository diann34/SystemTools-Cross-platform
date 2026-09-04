# p3-01 证据：设置页整合批次一——SystemTools 主设置页 + MoreFeaturesOptions 页（兵部 war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-01 · 兵部 war · application-code / implementation（阶段 3；依赖 p3-05 已 succeeded） |
| 权威输入 | p3-05 §2 落点表（W1-W5/A 面）、§3 裁剪面（C1-C15）、§3.4 白名单口径、§6 约束落点、§7 复核命令；p2-05 §4 双分支 PRESENT/ABSENT 集；p1-06 §6-8（RequestRestart）/§9-7（重启等价口径）；p1-05 §4.2（菜单树交接格式）+p2-09 §6（格式修订建议）；p0-07-s42-scan.ps1（R-2 扫描器）；p2-06-supplementary-compile-check.ps1（Roslyn 升级法先例）；源插件 `E:\My Github Projects\SystemTools\SettingsPage\`（只读先例） |
| 交付 | 2 页落点（SystemToolsSettingsPage.axaml/.axaml.cs、MoreFeaturesOptionsSettingsPage.axaml/.axaml.cs）+ 共享 VM p3-01 增补段（SystemToolsSettingsViewModel.cs，段界标共存纪律）= 5 个产品文件；证据 3 件（本文件 + p3-01-s42-scan-output.txt + p3-01-supplementary-compile-check.ps1/-output.txt） |
| 结论 | **succeeded** —— B 档接线 5/5（W1-W5，与 p3-05 §2 表一一对应，§1）；C 档裁剪面 15/15 零残留（代码面 0 命中，注记级 8 处均为既有"不迁"注记/本批适配注释，§2）；A 面补全 2/2（§1.6）；漂移红线 6 符号代码面零命中（§3）；macOS 五列自检 8/8 通过（§5）；S4.2 扫描 GateHits=0 / VERDICT: PASS / exit=0、CONDITIONAL=0（§6.1）；Roslyn 升级法双向符号验证 p3-01 判定面 error=0、exit=0（§6.2）；注册/菜单面零变更（§7-①）；零新增条件面（§7-②）；共享 VM 段界标共存互注齐备（§4）。**上报事项 1 项**：p3-02 段 IRulesetService 命名空间缺陷（已按裁决④上报未触碰，§9） |

---

## 0. 边界与冲突规则执行

1. 页粒度互斥（p3-05 §0-2）：本批仅触碰 SystemToolsSettingsPage.* 与 MoreFeaturesOptionsSettingsPage.* 两落点页 + 共享 VM 主页消费面；p3-02 四页（FloatingWindowEditor/AiChat/About/PluginDebug）零触碰（mtime 核对 §7-⑥，其在本会话内的变化均为 p3-02 批自身写入）。
2. 配置根零增补：W2/W3/W4/W5 仅消费 MainConfigData 既有成员（EnableFloatingWindowFeature :332 / AutoSwitchClassIslandTheme :252 / AutoHideMainWindowWhenOccluded :266 / AutoCleanupClassIslandMemory :291），A 面 AiModel :187 只读消费；MainConfigData.cs mtime 与开工基线一致（2026-09-04 11:33:47）。
3. 源插件检出与宿主检出全程只读（Select-String/Get-Content/Assembly 探测）；写入仅落点页 + 共享 VM + evidence/。

## 1. W1-W5 接线逐项落点对照（源锚点 → 新落点实测行号；实施期插入位移后区间语义为准）

### 1.1 W1 主页「启用功能选项」管理抽屉

| 面 | 源锚点（SettingsPage\，只读） | 新落点（本批实测） | 适配点登记 |
| --- | --- | --- | --- |
| 抽屉容器 DrawerHost | SystemToolsSettingsPage.axaml:21-24（页根包裹 ScrollViewer，DrawerPlacement=Right，IsDrawerOpen/DrawerContent 双绑定） | 新 axaml:14-19（同构包裹） | 零适配；x:Name="DrawerHost" 随源 |
| DrawerContentTemplate | 源 axaml:26-149（500 宽抽屉：标题行+关闭钮 / 搜索框 / 谨慎条 / DataGrid 四列（启用/类型/所属组别/名称）+ 空态 ci:Empty / 取消+「应用并重启」accent 钮） | 新 axaml:21-146（逐段同构） | 绑定经 RelativeSource AncestorType=ci:SettingsPageBase 随源；DrawerHost/DataGrid/ci:Empty 为 ClassIsland.Core 双分支既有消费面（p3-05 §6-2；Empty.axaml.cs:11/DrawerHost.axaml.cs:24 实测在库） |
| 打开/搜索/关闭/保存处理器 | 源 axaml.cs:524-557（OnManageFeaturesClick / OnFeatureSearchTextBoxTextChanged / OnCloseDrawerClick / OnSaveFromDrawerClick） | 新 axaml.cs:206-256（p3-01 段界标内，逐方法同构） | OnSaveFromDrawerClick 重启走 `SettingsPageBase.RequestRestart()`（新 :243），源 RestartClassIsland() Win 进程替换路径不迁（p1-06 §6-8） |
| 入口 expander | 源 axaml:167-176（「启用功能选项」+「管理启用的功能...」钮） | 新 axaml:167-177 | 零适配 |
| 抽屉 VM 面 | 源 VM:106-113/:174-381（FeatureItems/FeatureSearchResults/IsFeatureSearchEmpty/IsFeatureDrawerOpen/FeatureDrawerContent + InitializeFeatureItems/UpdateFeatureSearchResults/MatchesFeatureSearch/SaveFeatureSettings） | 共享 VM :692-885（p3-01 界标段） | 构造期调用随源 :52（新 axaml.cs:59）；源 :53 RefreshFloatingTriggers（p3-02 面）与 :54-55 RestartPropertyChanged/PropertyChanged 订阅不迁（新配置根无该事件，p2-05 §2.1 决策注记②） |
| **枚举白名单（结构性裁剪）** | 源 VM:178-333 清单含大量 C 条目 | 共享 VM InitializeFeatureItems（:719-799） | **仅枚举新插件注册面已迁功能项 41 项**：行动 29 + 触发器 2 + 组件 6 + 规则 4，ID 前缀 SystemTools.CrossPlatform.*，与 Plugin.cs 实测注册调用一一对应（Register*IfEnabled 37 + AddRule 4，p2-09 §5-6）；注册面 52 项口径（A33+B19）为白名单依据，服务/主题/设置页不属抽屉可枚举面（p3-05 §3.4-3：注册面即白名单）。C 条目（模拟操作/显示设置/USB/热键/媒体 C 族/实验性/AI 语音/RestartAsAdmin 等）零呈现；源 :317-321 EnableExperimentalFeatures 门随 C1 整块移除；门随源 :210-213/:302-307（EnableFloatingWindowFeature→Plugin.cs :301/:362 组门、EnableAiService→:326 门）。名称/组别逐字随源抽屉清单（含源侧既有差异：组件名「网络延迟」vs ComponentInfo「网络延迟检测」、「 LED 文本仿真显示框」前导空格，如实随源保留） |
| 保存语义 | 源 SaveFeatureSettings（EnabledActions/Triggers/Components/Rules 字典回写 + Save） | 共享 VM :844-866（同构） | 字典与 Is*Enabled 辅助为 MainConfigData 既有成员（:522-547），零增补 |

### 1.2 W2 主页「启用悬浮窗功能」开关组

| 面 | 源锚点 | 新落点 | 适配点登记 |
| --- | --- | --- | --- |
| expander + 开关 | 源 axaml:199-206（icon EA37，Description「关闭后将禁用悬浮窗相关全部功能」，ToggleSwitch TwoWay 绑定 + Click） | 新 axaml:189-197（随源相对序：位于「更多功能选项」:181 与「AI 服务」:200 之间，随源 :199 位于 :191/:208 之间） | 绑定路径随骨架页惯例走页属 `Config.EnableFloatingWindowFeature`（MainConfigData.cs:332，p2-03 增补），语义同源 ViewModel.Settings 路径 |
| 点击处理器 | 源 axaml.cs:88-91（OnFloatingFeatureToggleClick → RequestRestart；配置写入经 TwoWay 绑定） | 新 axaml.cs:247-253 | 源经 MainConfigData.RestartPropertyChanged 间接触发重启提示（源 :54/:70-73 订阅面不迁，新配置根无该事件），按 p1-06 §9-7 等价口径改为显式 `GlobalConstants.MainConfig?.Save(); RequestRestart();`（写配置仍由 TwoWay 绑定承载） |
| 开关门语义 | — | — | 开关 false→true 后行动/触发器/设置页注册门语义随源（注册门为启动期：Plugin.cs :163-172 设置页门/:301 组门/:362 触发器门，重启后生效） |

### 1.3 W3/W4/W5 MoreFeatures 页三开关组

| 项 | 源锚点 | 新落点 | 绑定成员（MainConfigData 既有，零增补） | 事件处理器（源形态随源：写配置 → 服务 ApplyConfig → Save） |
| --- | --- | --- | --- | --- |
| 分组标签「ClassIsland 外观」 | 源 axaml:16 | 新 axaml:17（ci:IconText 随源） | — | — |
| W3 自动切换 ClassIsland 主题 | 源 axaml:17-24 + axaml.cs:26-36 | 新 axaml:20-30 + axaml.cs:51-62 | AutoSwitchClassIslandTheme :252（B13） | AutoMatchThemeToggle_OnChanged → `IAppHost.GetService<AdaptiveThemeSyncService>().ApplyConfig()`（p2-02 S-主题，DI :128） |
| W4 主界面遮挡文字时 | 源 axaml:26-33 + axaml.cs:61-70 | 新 axaml:32-42 + axaml.cs:65-76 | AutoHideMainWindowWhenOccluded :266（B14） | AutoHideMainWindowOnTextToggle_OnChanged → `GetService<MainWindowTextOcclusionService>().ApplyConfig()`（p2-02 S-遮挡，DI :129；新签名 Shutdown(bool) 不影响 ApplyConfig 消费，p2-09 §1.3） |
| 分组标签「性能」 | 源 axaml:71 | 新 axaml:79（随源） | — | 源「其他工具」组标签 :117 **不迁**：其唯一成员「自动播放」属 C15 裁剪面，整组无存活成员 |
| W5 自动清理 ClassIsland 内存 | 源 axaml:72-79 + axaml.cs:72-82 | 新 axaml:82-92 + axaml.cs:79-90 | AutoCleanupClassIslandMemory :291（B） | AutoCleanupMemoryToggle_OnChanged → `GetService<ClassIslandMemoryAutoCleanupService>().ApplyConfig()`（p2-01 S-内存，DI :131） |

- 落点序随源相对序：W3/W4 于虚拟放学组 :42 之前、W5 于其后（源 :72 位于 :35 与 :81 之间）；三处理器与骨架既有 VirtualAfterSchool 处理器（TryGetService 形态，p1-06 阶段 1 面）并存不改写。
- GetService 直取为 p3-05 W3-W5 落点注记明示形态（三服务均为阶段 2 无条件单例，DI :128/:129/:131 实测）。

### 1.4 A 面补全 2 项（p3-05 §3.4-2）

| 项 | 源锚点 | 新落点 | 适配点登记 |
| --- | --- | --- | --- |
| A1 页头标签 | 源 axaml:153-165（`SystemTools` Label + FluentIcon E078 + 「功能 · 主设置」Label，[HidePageTitle] 下随源自绘） | 新 axaml:150-163 | 文案逐字随源（「显示文案随源不改」） |
| A2 「当前使用模型」显示项 | 源 axaml:286-300（Vosk 语音识别模型检查面：CheckCurrentVoskModelButton + DependencyPaths 检查，C13 依赖面） | 新 axaml:255-264（AI 服务组内、模型项之后随源序） | 按 p3-05 §3.4-2 改为 **A 档 AiModel 只读消费**：Footer=TextBlock OneWay 绑定 `Config.AiModel`（AiModel 带 INPC，「获取模型」变更后实时刷新）；源检查按钮/DependencyPaths（C13 零引入）不迁；描述文案随适配语义调整（源描述提及语音识别模型认证信息） |

## 2. C1-C15 裁剪移除面零残留留证（逐项复核，特征符号全树扫描：src\ 排 bin/obj，*.cs+*.axaml）

| 项 | 裁剪面 | 特征符号（组） | 代码面命中 | 注记级命中说明 |
| --- | --- | --- | :-: | --- |
| C1 | 实验性功能开关组（主页） | EnableExperimentalFeatures / IsExperimentalModeActivated / ExperimentalBadge | **0** | 1 注记=本批 VM 段裁剪说明行（共享 VM :718「EnableExperimentalFeatures 门随 C1 裁剪整块移除」） |
| C2 | FFmpeg 功能开关 | EnableFfmpegFeatures | **0** | 无 |
| C3 | FFmpeg 依赖下载 | DownloadFfmpeg / IsFfmpegDownloadEnabled / OnDownloadFfmpegClick | **0** | 无 |
| C4 | 人脸识别开关 | EnableFaceRecognition / FaceRecognitionCredentialCleanup | **0** | 无 |
| C5 | 人脸模型下载 | DownloadFaceModels / IsFaceModelsDownloadEnabled | **0** | 无 |
| C6 | Windows Hello | EnableWindowsHello / WindowsHelloService / WindowsHelloSupportStatus | **0** | 无 |
| C7 | VoskWorker 下载 | DownloadVoskWorker / IsVoskWorkerDownloadEnabled / OnDownloadVoskWorkerClick | **0** | 无 |
| C8 | 语音识别模型 ComboBox | SpeechRecognitionDownloadOption / SelectedSpeechRecognitionModel / ConfirmSpeechRecognitionModelDownload | **0** | 无 |
| C9 | 下载状态/进度条 | ShowDownloadProgress / DownloadStatusText / DownloadProgress | **0** | 无 |
| C10 | AI 语音唤醒开关 | EnableVoiceWakeAi | **0** | 无 |
| C11 | AI 唤醒词输入 | AiWakeWord | **0** | 无 |
| C12 | AI 对话悬浮窗样式 | AiConversationFloatingWindowStyle | **0** | 1 注记=MainConfigData.cs:93 既有「不增补注记」（p1-04/p2-05 既有，p3-05 §1.2 自引） |
| C13 | 依赖检查/下载基础设施（VM 面） | DependencyPaths / TryBeginDownload / FindSpeechRecognitionModelDirectory / ShowMd5ErrorDialogAsync | **0** | 1 注记=本批 A2 适配注释（新 axaml:255「DependencyPaths，C13 不迁」） |
| C14 | 管理员内存清理组（MoreFeatures） | AutoCleanupSystemMemory / SystemMemoryCleanupThresholdPercent / SystemMemoryCleanupService / CleanSystemMemoryNow | **0** | 1 注记=Plugin.cs:188-189 既有「不随入」注记（阶段 2 裁剪注记先例） |
| C15 | USB 自动播放开关（MoreFeatures） | AutoOpenUsbDriveOnInsert / UsbAutoPlayService | **0** | 4 注记=Plugin.cs :335/:517/:637/:188 既有「C 档未迁」注记（p3-05 §3.2-C15 自引的同口径注记先例） |

- **零残留确认：C1-C15 代码/UI/绑定/配置面全部 0 命中**；8 处注记级命中均为既有裁剪注记（5）或本批适配说明（3），无任何残留功能面，无需移除动作。p3-05 实测「现骨架零残留」结论复核成立。
- C16-C21（悬浮窗编辑页/AiChat/About/PluginDebug 面）不属本批（p3-05 §3.3 归 p3-02），未复核未触碰。

## 3. 双分支 API 漂移红线复扫（p1-10 §12.5 / p3-05 §6-2）

| 符号 | SettingsPage 面命中（.cs+.axaml 全文件） | 全树命中 | 判定 |
| --- | :-: | :-: | --- |
| MainWindowStylesAssist.IsBackgroundMaterialEnabled | **0** | **0** | ✅ 红线零命中 |
| FloatingWindowAppearanceStyle | 0 | 2（MainConfigData.cs:325 注记行） | ✅ 代码面 0 |
| FloatingWindowLiquidGlass | 0 | 2（MainConfigData.cs:325 注记行） | ✅ 代码面 0 |
| FloatingWindowGlassButtonScaleDip | 0 | 2（MainConfigData.cs:326 注记行） | ✅ 代码面 0 |
| AiConversationLiquidGlass | 0 | 1（MainConfigData.cs:93 注记行） | ✅ 代码面 0 |
| AiConversationApprovalButtonGlass | 0 | 1（MainConfigData.cs:93 注记行） | ✅ 代码面 0 |

- 本批消费面限于 p2-05 §4 PRESENT 集：SettingsPageBase.RequestRestart（p1-06 §6-8 双分支验证）、IUriNavigationService.NavigateWrapped（p1-06 既有）、DrawerHost/DataGrid/ci:Empty/ci:IconText/ci:FluentIcon（ClassIsland.Core 双分支既有）、AdaptiveThemeSyncService/MainWindowTextOcclusionService/ClassIslandMemoryAutoCleanupService（本插件已交付服务）、MainConfigData 既有成员；零新增宿主接口引用。

## 4. 共享 VM 改动申报（SystemToolsSettingsViewModel.cs，段界标共存；互注 p3-02）

### 4.1 本批（p3-01）增补段（界标 `===== p3-01 增补开始/结束 =====`，共 2 段，收口复读实测）

| 段 | 行区间（收口复读终版 2026-09-04 12:52 版，887 行） | 成员 |
| --- | --- | --- |
| 条目类型段 | :68-100 | `FeatureItemType`（枚举）、`UnifiedFeatureItem`（含 TypeDisplayName） |
| 主页功能管理抽屉消费面段 | :693-886 | `FeatureItems` / `FeatureSearchResults` / `IsFeatureSearchEmpty` / `IsFeatureDrawerOpen` / `FeatureDrawerContent` / `InitializeFeatureItems()` / `UpdateFeatureSearchResults()` / `MatchesFeatureSearch()` / `SaveFeatureSettings()` |

- 消费页：仅 SystemToolsSettingsPage（p3-01）。悬浮窗编辑页不消费本段。
- 依赖下载/进度/MD5 面零引入（C13）；下载字段（IsFfmpegDownloadEnabled 等）未随入。

### 4.2 p3-02 段核对（对方批，本批零触碰）

| 段 | 行区间（同上收口复读终版 12:52） | 内容 |
| --- | --- | --- |
| 页属类型段 | :25-66 | FloatingTriggerItem / FloatingTriggerRow |
| 构造与订阅段 | :113-139 | 三参构造、_floatingWindowService、_entriesChangedHandler |
| 页属成员段 | :193-690 | 方案管理（Add/RemoveFloatingWindowProfile 等）+ 按钮布局编辑器支撑（RefreshFloatingTriggers/AddFloatingTriggerRow/RemoveFloatingTriggerRow/PersistFloatingTriggerRows/AreRowsEqual/NotifyRulesetStatusChanged/Dispose 等）+ SelectFloatingWindowProfile 守卫修订与文件头 using 增补（其批证据登记） |

- 成员清单交叉核对（尚书省裁决③）：两批成员**零同名冲突、零定义重叠**（§4.1/§4.2 集合互斥）；p3-02 段成员逐一实测在位（RefreshFloatingTriggers :134、AddFloatingTriggerRow :469、PersistFloatingTriggerRows :492、AreRowsEqual :588、Dispose :681 等），段界完整、无语法冲突。
- 本段 p3-02 段归属编译诊断 1 项（IRulesetService CS0246，终版 :459）已按裁决④上报（§9），未修复未触碰。
- 收口复读期间 p3-02 续写留痕：12:52 版于 :24 增补一空行（格式微调），致 §4 各区间较 12:39 快照整体 +1；p3-01 两段内容零变化；行号如再漂移按 §8-6 口径以界标动态划区为准。
- 主页两参构造签名随源保留（p3-02 委托三参构造，服务为 null 时悬浮窗面不激活），主页消费面不受影响。

## 5. macOS 五列自检表（8/8 通过；U4 降级口径）

| 落点项 | macOS 运行时行为（降级口径） | 门禁符号载体 | 跨 TFM 编译闭合 | 结论 |
| --- | --- | --- | --- | --- |
| W1 抽屉面（DrawerHost/DataGrid/搜索/应用并重启） | 纯 Avalonia + ClassIsland.Core 控件（DrawerHost/DataGrid/ci:Empty 三平台同源），无平台分支 | S4.2 零命中（axaml 人工核对零禁用符号） | Round-W/N 判定面 error=0 | ✅ |
| W1 枚举白名单（41 项清单/搜索/保存） | 纯托管集合与字典操作（MainConfigData 既有成员），无平台语义 | 零命中 | Round-W/N error=0 | ✅ |
| W1 重启（应用并重启） | 宿主 SettingsPageBase.RequestRestart()（RequestRestartCommand 宿主跨平台机制，p1-06 §6-8）；源 RestartClassIsland 未迁 | 零命中（R21/X01 等零命中，§6.1） | Round-W/N error=0 | ✅ |
| W2 悬浮窗功能开关 | 配置写入/落盘跨平台一致；开关生效经宿主注册门（启动期），悬浮窗服务非 Windows 降级面随 p2-03 交付口径 | 零命中 | Round-W/N error=0 | ✅ |
| A1「当前使用模型」/A2 页头标签 | 纯绑定与静态/动态资源显示，无平台语义 | 零命中 | Round-W/N error=0 | ✅ |
| W3 自动切换主题 | AdaptiveThemeSyncService AD1/AD3 降级形（p2-02 交付）：非 Windows 无计时器/捕获租约，Start 直呼 ApplyConfig，开关保持可存取 | 零命中（服务本体非本批触碰） | Round-W/N error=0 | ✅ |
| W4 主界面遮挡文字时 | MainWindowTextOcclusionService 降级：非 Windows 检测链不启用、主界面保持可见（06 条目 48 降级口径，p2-02 交付） | 零命中 | Round-W/N error=0 | ✅ |
| W5 自动清理 ClassIsland 内存 | ClassIslandMemoryAutoCleanupService：阈值测量+托管 GC 链三平台执行；工作集修剪 Windows-only（TryTrimWorkingSet=false 留痕日志，p2-01 交付口径） | 零命中 | Round-W/N error=0 | ✅ |

零新增平台条件面：本批 3 交付 .cs CONDITIONAL=0（§6.1），两落点 .axaml 无 `#if`/条件类（axaml 不属扫描 Source 面，人工核对）。

## 6. 门禁与自检留证

### 6.1 S4.2 批级扫描（TEMP 镜像 3 交付 .cs 字节复制，SHA256 留证于输出文件头；扫描器 p0-07-s42-scan.ps1 R-2 版，进程内直调）

| 指标 | 值 |
| --- | --- |
| SourceFiles | 3（= 本批全部交付 .cs；两 .axaml 不属 Source 面，人工核对） |
| GateHits | **0** |
| ConditionalHits | **0**（预期零新增条件面兑现） |
| InfoHits / CommentOnly | 0 / 0 |
| VERDICT | **PASS (zero gate hits)** |
| 退出码 | **0**（直跑 exit=0） |

- 完整原始输出：`evidence\p3-01-s42-scan-output.txt`。复核重放：重建 3 文件镜像后 `pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path <镜像> -Scope Source`（本会话沙箱禁嵌套 pwsh -File，直调经进程内 `&` 执行，扫描器语义/规则/退出码零改动）。
- axaml 人工核对：两 .axaml 零 §S4.2 禁用符号（内容为 FASettingsExpander/ToggleSwitch/DrawerHost/DataGrid/FluentIcon/IconText/动态资源与 XAML 注释）；XML 良构性双文件解析通过。

### 6.2 Roslyn 升级法自检（p2-06 同源方法升级形态；脚本与输出：p3-01-supplementary-compile-check.ps1 / -output.txt）

| 轮次 | 预处理符号 | 判定 | error | 说明 |
| --- | --- | --- | ---: | --- |
| Round-W（Windows 路径） | 真实构建同源 /define: 集（含 Platforms_Windows） | **PASS** | **0**（p3-01 判定面） | 644 个真实构建引用集（含 CommunityToolkit.Mvvm 8.2.1/Avalonia 12.1.1/Avalonia.Controls.DataGrid 12.0.0/SDK 双分支面），全工程 163 真实 .cs 入检 |
| Round-N（非 Windows 路径） | 同集去 Platforms_Windows/WINDOWS* 换 Platforms_Linux/LINUX | **PASS** | **0**（p3-01 判定面） | 本批零条件面，双 Pass 语义等价；按派工约束 5 仍执行双向 |
| 退出码 | — | **0** | — | COMPILE OK（双向） |

- 判定口径：p3-01 交付面（两页 .axaml.cs + 共享 VM p3-01 段）归属 error=0；检查专用存根归属 error=0（MVVM 生成成员 partial 存根含 FloatingTriggerItem/FloatingTriggerRow/UnifiedFeatureItem/VM 可观察成员 + OnIconChanged 生成器等价 defining declaration + 两页 InitializeComponent 存根 + 隐式 using 存根）；他文件 XAML/MVVM 生成面缺失按噪声单列（24 文件 269 项，p1-06 §7-6 先例）；p3-02 界标段归属诊断动态解析单列（1 项，§9）。
- 段归属分类实现：以 `===== p3-02 增补开始/结束 =====` 界标行号动态划区（实测 24-65/112-138/192-689），该段内诊断不计判定、如实列示。

## 7. 强制约束逐项核对（全部批次同款六约束）

| # | 约束 | 结果 |
| :-: | --- | --- |
| ① | 菜单树格式修订（p1-05 §4.2+p2-09 §6）：本批零注册/菜单变更 | ✅ Plugin.cs 零触碰（mtime 与开工基线 11:17:15 一致）；无注册行交接，无需菜单归属声明行 |
| ② | 条件文件规范 R-2/R-2a（guard=Platforms_Windows） | ✅ 零新增条件面（S4.2 CONDITIONAL=0；零 #if 写入） |
| ③ | macOS 兼容硬约束 | ✅ 新增消费面 macOS 五列自检表 8/8（§5） |
| ④ | S4.2 门禁批内直扫 exit=0 | ✅ GateHits=0/PASS/exit=0（§6.1） |
| ⑤ | Roslyn 升级法自检（隐式 using 语境+宿主同语境引用集） | ✅ 双向 Round-W/N 判定面 error=0、exit=0（§6.2） |
| ⑥ | 沙箱边界（源插件/宿主只读；写入仅落点页+共享 VM 主页面+evidence/；禁改 Plugin.cs/manifest.yml/csproj/MainConfigData/global.json/slnx 及 p3-02 四页） | ✅ 写入=本批 5 产品文件+4 证据文件；禁改面 mtime 与开工基线一致（Plugin.cs 11:17:15 / MainConfigData.cs 11:33:47 / manifest.yml 2026-09-03 23:12 / csproj 02:55 / global.json、slnx 2026-09-03）；p3-02 四页零触碰（其 12:39-12:41 变化均为 p3-02 批自身写入） |

## 8. 复核重放指引

1. W1-W5 落点：§1 各"新落点"行号对工作树文件重放（区间语义；源锚点对源插件只读检出重放）。
2. 白名单 41 项：对共享 VM InitializeFeatureItems 逐项 ID 在 Plugin.cs 检索（应各恰 1 次注册/组门锚点）；计数 29+2+6+4=41。
3. C1-C15：对 §2 特征符号组按 §2 口径全树重扫（代码面应 0 命中）。
4. 红线：§3 六符号重扫（SettingsPage 面 0，全树仅注记）。
5. S4.2/Roslyn：按 §6 重放（镜像重建或按输出文件头 SHA256 核对）。
6. VM 段共存：按 §4 区间复读共享 VM（p3-02 若续写致行号漂移，以界标文本动态划区为准）。

## 9. 上报事项

1. **p3-02 段共享 VM 编译缺陷（已上报尚书省，未触碰）**：SystemToolsSettingsViewModel.cs:458（12:39 Roslyn 快照实测；12:52 终版 :459，p3-02 页属成员段内）`IAppHost.TryGetService<IRulesetService>()` CS0246——`IRulesetService` 实测位于 `ClassIsland.Core.Abstractions.Services`（U3 检出 ClassIsland.Core\Abstractions\Services\IRulesetService.cs:11），不在 `ClassIsland.Shared`；文件头 using 集不含该命名空间，真实构建将失败（Roslyn 全 644 引用集复核，NuGet/Shared 程序集均无该名）。修复建议（归 p3-02）：其段内补 `using ClassIsland.Core.Abstractions.Services;` 或改全限定名。本批判定面不受影响（Roslyn 按段归属分类后双 Pass 判定面 error=0）。
2. 其余零上报：无注册行交接、无新增条件面、无跨批落点冲突、无 p3-05 冲突。

## 10. 边界声明

- 本批产品写入=5 文件（两落点页 4 件 + 共享 VM p3-01 增补段）；证据写入=本文件 + p3-01-s42-scan-output.txt + p3-01-supplementary-compile-check.ps1 + p3-01-supplementary-compile-check-output.txt。
- 本文件不派工、不审批、不推进全局工作流；仅向尚书省回报本批结果，门下省终验。
- p3-02 在本会话内对共享 VM/其四页的并行写入与本批段界标共存；本批收口复读以其当时状态留证，若其后续续写致行号漂移，按 §8-6 口径重放。

## 11. 修订记录

- 初版（p3-01 执行交付；基于本轮对两落点页 + 共享 VM 实测接线、全树 C/红线扫描、S4.2 直扫与 Roslyn 双向验证）。
