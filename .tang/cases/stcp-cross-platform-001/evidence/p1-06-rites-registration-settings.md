# p1-06 证据：礼部 p1-06——新插件注册面启用（Plugin.cs 唯一注册面）+ 设置页 6 页 A 档骨架（interfaces-documentation / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-06 · 礼部 rites · interfaces-documentation / implementation（依赖 p1-01/p1-02/p1-03/p1-04，均已 succeeded；结构依据 p1-05 已 succeeded 含修订 R1） |
| 权威输入 | 兵部四批结构化注册清单（p1-01 §3/§3.2、p1-02 §2、p1-03 §3/§3.1、p1-04 §5/§6）为注册唯一输入源；p1-05 §2/§3/§4.1/§5（落点/命名/注册面归属/门禁）；p0-03 §4.2（A33 权威）；p0-05（ID 前缀 D7 与 manifest 基线）；04-spec（S4.2 门禁、U5/R-6 降级、S4.1 语音族 C）；05 阶段合同阶段 1 |
| 交付点 | `src\SystemTools.CrossPlatform\Plugin.cs`（重写，唯一注册面，仅礼部有权修改）+ `SettingsPage\` 14 个新文件（6 页 .axaml+.axaml.cs + 2 ViewModel）+ `ConfigHandlers\MainConfigData.cs`（预批增补 2 成员）+ 本案 evidence/（5 个文件）＝ **20 个写入对象** |
| 结论 | **succeeded** —— A 档 33 项功能面在 Plugin.cs 逐项注册（33/33，§2）；DI 接线按 p1-03 §3.1 与 p1-04 §6 需求逐项落实（§3）；设置页 6 页骨架 + AiChatSettingsViewModel 去语音契约 + AboutSettingsPage id 契约落实（§4）；MainConfigData 预批成员增补留痕（§5）；S4.2 批内 3 目标 + 全树收口复跑全 PASS exit=0（§7）；manifest 字节级不变（§8）；macOS 自检表零"不适用"（§6） |
| 边界 | 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读；写入仅限 Plugin.cs + SettingsPage\ + MainConfigData 预批成员 + evidence/；未触碰 manifest.yml / csproj / global.json / slnx 及兵部各批交付文件 |

---

## 1. 注册面总览（源先例 → 新注册面逐段映射）

| 源先例（Plugin.cs，只读参照） | 新注册面落点 | A 档面处理 |
| --- | --- | --- |
| :67-70 配置初始化（GlobalConstants 三赋值 + MainConfigHandler 构造） | Initialize 开头逐行保留 | p1-03 §3.1 需求全落实（§3-1） |
| :74 `services.AddLogging()` | **未随入**（核减报备 §9-1） | 宿主 Generic Host 先于插件注册日志服务，该调用为冗余防御 |
| :75-110 三主题 AddXamlTheme（Uri + ThemeManifest） | 逐项保留，Uri/Id 改写 CrossPlatform | Banner 置空（源经 ThemeBannerCacheService，阶段 1 未交付该服务；§9-2） |
| :111/:114/:124/:129 DI 服务 | 逐项保留 | p1-03 §3.1 / p1-04 §6 需求（§3） |
| :130-139 EnableAiService 条件块 | 逐项保留，去 AiVoiceConversationService（语音族 C） | 6 个条件 Singleton |
| :141-149 通知提供方去重注册 | 逐行保留 | 防 IHostedService 双注册 |
| :175-187 设置页注册（含 aiChat 条件） | AddSettingsPageGroup + [Group] 特性替代源反射分组（§9-3） | 6 页 |
| :189-190 BuildBaseActionTree + :618-726/859-996 分组 | A 档 6 组重建 | 悬浮窗设置组门为 B 档成员，阶段 1 不建组（§9-4） |
| :192-196 RegisterBaseActions/Triggers/Rules/Components | 逐项 A 档面 | 启用开闭形态随源 |
| :201/:220/:284 AppStarted 钩子 | 保留虚拟放学 Start + 版本检查 CheckAndNotify | p1-04 §6 |
| :288 AppStopping 钩子 → :1032-1068 OnAppStopping | A 档面：Stop() + 浮窗 Close() + 配置 Save() | 其余停止面（语音/人脸/悬浮窗服务等）属 B/C，不迁 |
| :572-612 条件注册辅助方法 | 逐行保留（泛型约束同源） | keyed 行动设置控件经 `AddAction<TAction,TSettingsControl>`（宿主以 ActionInfo.Id 为 key）满足 p1-03 §3.1 |

## 2. 注册对照总表（A 档 33 项逐项，ID 一律 `SystemTools.CrossPlatform.*` 前缀）

### 2.1 主题 3 项（p1-01 §3.2 清单；注册形态 = 源 Plugin.cs:76-91-103 `AddXamlTheme` 先例）

| # | 功能项 | 功能 ID（= Themes manifest id，已核一致） | 注册形态 | 来源批清单行 |
| --- | --- | --- | --- | --- |
| T1 | CardTypeComponent 主题 | `SystemTools.CrossPlatform.Card-type-component` | `services.AddXamlTheme(new Uri("avares://SystemTools.CrossPlatform/Themes/CardTypeComponent/Styles.axaml"), new ThemeManifest{…VerticalSafeAreaPx=20})` | p1-01 §1.1 表 T1 行（源 manifest.yml:1；锚点源 Plugin.cs:79） |
| T2 | ClassWidgets 主题 | `SystemTools.CrossPlatform.classwidgets` | 同形态，`…/Themes/ClassWidgets/Styles.axaml`，VerticalSafeAreaPx=20 | p1-01 §1.1 表 T2 行（源 :91） |
| T3 | NotchStyle 主题 | `SystemTools.CrossPlatform.notch-style` | 同形态，`…/Themes/NotchStyle/Styles.axaml`，VerticalSafeAreaPx=0 | p1-01 §1.1 表 T3 行（源 :103） |

### 2.2 组件 6 项（p1-01 §3 表 C1–C6；注册形态 = 源 Plugin.cs:517-534/603-612 先例）

| # | 功能项 | 功能 ID（IsComponentEnabled 键） | 注册形态 | 来源批清单行 |
| --- | --- | --- | --- | --- |
| C1 | 网络延迟检测 | `SystemTools.CrossPlatform.NetworkStatus` | `RegisterComponentIfEnabled<NetworkStatusComponent, NetworkStatusSettingsControl>(services, config, <ID>)` → `AddComponent<T,TControl>()`（ComponentInfo GUID = p1-01 新 GUIDv5 固化值，非本批改动） | p1-01 §3 表 C1 行 |
| C2 | 显示剪切板内容 | `SystemTools.CrossPlatform.ClipboardContent` | 同形态 | p1-01 §3 表 C2 行 |
| C3 | 本地一言 | `SystemTools.CrossPlatform.LocalQuote` | 同形态 | p1-01 §3 表 C3 行 |
| C4 | 下节课是 | `SystemTools.CrossPlatform.NextClassDisplay` | 同形态 | p1-01 §3 表 C4 行 |
| C5 | 更好的轮播容器 | `SystemTools.CrossPlatform.BetterCarouselContainer` | 同形态 | p1-01 §3 表 C5 行 |
| C6 | 滚动文本 | `SystemTools.CrossPlatform.ScrollingText` | 同形态 | p1-01 §3 表 C6 行 |

### 2.3 规则 4 项（p1-02 §2；注册形态 = 双参 `AddRule<TSettings,TSettingsControl>`，源 Plugin.cs:486-508 先例；p1-05 修订 R1 注：SDK 单参重载亦合法，按实际接线选用双参——4 项均有设置控件，双参与源一致）

| # | 功能项 | 功能 ID | 注册形态 | 来源批清单行 |
| --- | --- | --- | --- | --- |
| R1 | 程序正在运行 | `SystemTools.CrossPlatform.ProcessRunningRule` | `if (config.IsRuleEnabled(<ID>)) services.AddRule<ProcessRunningRuleSettings, ProcessRunningRuleSettingsControl>(<ID>, "程序正在运行", "\uE342", ProcessRunningRuleHandler.Handle)` | p1-02 §1.1 R1 行 |
| R2 | 正在使用某课程表 | `SystemTools.CrossPlatform.UsingClassPlanRule` | 同形态（名称/图标随源 :495） | p1-02 §1.1 R2 行 |
| R3 | 正在使用某时间表 | `SystemTools.CrossPlatform.UsingTimeLayoutRule` | 同形态（:501） | p1-02 §1.1 R3 行 |
| R4 | 是否在某时间段 | `SystemTools.CrossPlatform.InTimePeriodRule` | 同形态（:507） | p1-02 §1.1 R4 行 |

### 2.4 触发器 1 项（p1-02 §1.2；注册形态 = `RegisterTriggerIfEnabled` 先例，源 Plugin.cs:467-468）

| # | 功能项 | 功能 ID | 注册形态 | 来源批清单行 |
| --- | --- | --- | --- | --- |
| G1 | 行动进行时 | `SystemTools.CrossPlatform.ActionInProgressTrigger` | `RegisterTriggerIfEnabled<ActionInProgressTrigger, ActionInProgressTriggerSettings>(services, config, <ID>)`（TriggerInfo 特性已按前缀规则改写于 p1-02 交付件） | p1-02 §1.2 T1 行 |

### 2.5 行动 15 项（p1-03 §1.1/§3 表；注册形态 = `RegisterActionIfEnabled` 先例，源 Plugin.cs:572-612；行动设置控件 keyed 注册由 `AddAction<TAction,TSettingsControl>` 以 ActionInfo.Id 为 key 自动落实，满足 p1-03 §3.1 需求）

| # | 功能项 | 功能 ID | 注册形态（ActionInfo 特性已固化于 p1-03 交付件） | 来源批清单行 |
| --- | --- | --- | --- | --- |
| A1 | 退出进程 | `SystemTools.CrossPlatform.KillProcess` | `RegisterActionIfEnabled<KillProcessAction, KillProcessSettingsControl>(…, <ID>)` | p1-03 §3 表 A1 行 |
| A2 | 拉起自定义Windows通知 | `SystemTools.CrossPlatform.ShowToast` | `RegisterActionIfEnabled<ShowToastAction, ShowToastSettingsControl>` | p1-03 §3 表 A2 行 |
| A3 | 切换悬浮窗配置方案 | `SystemTools.CrossPlatform.ToggleFloatingWindowProfile` | `RegisterActionIfEnabled<ToggleFloatingWindowProfileAction, ToggleFloatingWindowProfileSettingsControl>`（组门差异见 §9-4） | p1-03 §3 表 A3 行 |
| A4 | 切换悬浮窗主题 | `SystemTools.CrossPlatform.SwitchFloatingWindowTheme` | 同形态 | p1-03 §3 表 A4 行 |
| A5 | 后台播放音频 | `SystemTools.CrossPlatform.BackgroundPlayAudio` | `RegisterActionIfEnabled<BackgroundPlayAudioAction, BackgroundPlayAudioSettingsControl>` | p1-03 §3 表 A5 行 |
| A6 | 行动流执行确认 | `SystemTools.CrossPlatform.ActionFlowExecutionConfirmation` | `RegisterActionIfEnabled<ActionFlowExecutionConfirmationAction, ActionFlowExecutionConfirmationSettingsControl>` | p1-03 §3 表 A6 行 |
| A7 | 触发指定触发器 | `SystemTools.CrossPlatform.TriggerCustomTrigger` | `RegisterActionIfEnabled<TriggerCustomTriggerAction, TriggerCustomTriggerSettingsControl>` | p1-03 §3 表 A7 行 |
| A8 | 开关自动化 | `SystemTools.CrossPlatform.ToggleWorkflow` | `RegisterActionIfEnabled<ToggleWorkflowAction, ToggleWorkflowSettingsControl>` | p1-03 §3 表 A8 行 |
| A9 | 显示AI对话框 | `SystemTools.CrossPlatform.ShowAiChatDialog` | `if (config.EnableAiService) RegisterActionIfEnabled<ShowAiChatDialogAction>(…, <ID>)`——源 :450-457 先例：A9 注册于 EnableAiService 开关内（无设置控件，单参形态随源 :456） | p1-03 §3 表 A9 行 |
| A10 | 沉浸式时钟 | `SystemTools.CrossPlatform.FullscreenClock` | `RegisterActionIfEnabled<FullscreenClockAction, FullscreenClockSettingsControl>`（控件配对随源 :427 先例） | p1-03 §3 表 A10 行 |
| A11 | 清除全部提醒 | `SystemTools.CrossPlatform.ClearAllNotifications` | `RegisterActionIfEnabled<ClearAllNotificationsAction, ShortcutKeyNotificationSettingsControl>` | p1-03 §3 表 A11 行 |
| A12 | 加载临时课表 | `SystemTools.CrossPlatform.LoadTemporaryClassPlan` | `RegisterActionIfEnabled<LoadTemporaryClassPlanAction, LoadTemporaryClassPlanSettingsControl>` | p1-03 §3 表 A12 行 |
| A13 | 打开应用设置 | `SystemTools.CrossPlatform.OpenAppSettings` | `RegisterActionIfEnabled<OpenAppSettingsAction, ShortcutKeyNotificationSettingsControl>` | p1-03 §3 表 A13 行 |
| A14 | 打开档案编辑 | `SystemTools.CrossPlatform.OpenProfileEditor` | `RegisterActionIfEnabled<OpenProfileEditorAction, ShortcutKeyNotificationSettingsControl>` | p1-03 §3 表 A14 行 |
| A15 | 打开换课窗口 | `SystemTools.CrossPlatform.OpenClassSwapWindow` | `RegisterActionIfEnabled<OpenClassSwapWindowAction, ShortcutKeyNotificationSettingsControl>` | p1-03 §3 表 A15 行 |

### 2.6 服务/设置页聚合 4 项（p1-04 §6 清单 + 礼部交付）

| # | 功能项 | 功能 ID / 键 | 注册形态 | 来源批清单行 |
| --- | --- | --- | --- | --- |
| S1 | AI 文本链服务群 | —（经 A9 行动触发） | DI 详见 §3-2；浮窗无直接注册，AppStopping `TryGetService<AiChatWindowService>()?.Close()` | p1-04 §6 表 A9 主链服务各行 |
| S2 | 虚拟放学服务 | — | `AddSingleton<VirtualAfterSchoolService>()` + AppStarted→`Start()` + AppStopping→`Stop()` | p1-04 §6 表 服务② 行 |
| S3 | 版本检查服务 | —（导航 URI `SystemTools.CrossPlatform.settings.about`） | 静态类，AppStarted→`VersionCheckService.CheckAndNotify()` | p1-04 §6 表 服务③ 行 |
| S4 | 设置页骨架 6 页（礼部本批交付） | 见 §4.1 | `AddSettingsPageGroup` + 6×`AddSettingsPage<T>`（aiChat 条件注册随源） | p1-05 §6 服务群 ④ 行（礼部 p1-06 落点） |

**33/33 闭合**：3+6+4+1+15+4 = 33，与 p0-03 §4.2 / p1-05 §6 一致；每项均按 `IsActionEnabled/IsTriggerEnabled/IsComponentEnabled/IsRuleEnabled/EnableAiService` 启用开闭形态注册（源 RegisterActionIfEnabled 先例，MainConfigData Enabled* 字典为开闭数据源，p1-03/p1-04 交付）。

### 2.7 行动菜单树（A 档面，源 BuildBaseActionTree 先例；不属于 33 项计数，属注册面用户可见组织）

| 组 | 门（随源） | 成员 |
| --- | --- | --- |
| SystemTools 行动（\uE079） | 恒建（随源 :622） | — |
| 实用工具…（\uE352） | HasAnyActionEnabled(A1,A2) | A1 退出进程 \uE0DE、A2 拉起自定义Windows通知 \uE3E4（源 :859-878 A 面） |
| 媒体工具…（\uE342） | HasAnyActionEnabled(A5)（源 EnableFfmpegFeatures 门为 B/C，不迁） | A5 后台播放音频 \uEBCC（源 :880-892） |
| 高级自动化工具…（\uE01F） | HasAnyActionEnabled(A6,A7,A8) | A6 \uE01D、A7 \uEAB7、A8 \uE051（源 :940-955） |
| AI 功能…（\uEFFF） | config.EnableAiService && HasAnyActionEnabled(A9) | A9 显示AI对话框 \uE8C3（源 :957-972） |
| 其他工具…（\uE32C） | IsActionEnabled(A10) | A10 沉浸式时钟 \uE4D2（源 :914-921） |
| ClassIsland…（\uE5CB） | HasAnyActionEnabled(A11,A12,A13,A14,A15) | A11 \uE029、A12 \uE6A1、A13 \uEF27、A14 \uE699、A15 \uE13B（源 :974-996；RestartAsAdmin 为 C 不迁） |
| 悬浮窗设置… | **阶段 1 不建组**（源 :671-677 组门 EnableFloatingWindowFeature 为 B 档成员，§9-4） | — |

菜单项 AddRange 在本地宿主检出 `ActionMenuTreeNodeCollection` 无此方法（源插件 NuGet SDK 面与本地检出存在版本差），以逐项 `Add(item)` 等价改写（KeyedCollection Add 语义一致，§9-5）。

## 3. DI 接线落实清单（对照 p1-03 §3.1 与 p1-04 §6 需求逐项）

### 3-1 p1-03 §3.1「DI/初始化接线需求表」逐项

| # | 需求（p1-03 §3.1） | 源锚点 | 落实 |
| --- | --- | --- | --- |
| 1 | `GlobalConstants.PluginConfigFolder` / `Information.PluginFolder` / `Information.PluginVersion` 赋值 | 源 Plugin.cs:67-69 | Initialize 首三行逐行保留（PluginConfigFolder=PluginConfigFolder；PluginFolder=Info.PluginFolderPath；PluginVersion=Info.Manifest.Version） |
| 2 | `GlobalConstants.MainConfig = new MainConfigHandler(PluginConfigFolder)` + `services.AddSingleton(...)` | 源 :70 / :111 | 均落实（MainConfigHandler ctor 自身亦回填 GlobalConstants.MainConfig，p1-03 交付形态） |
| 3 | `AddSingleton<FloatingWindowProfileManager>` | 源 :114 | 落实（MigrateFromLegacyConfig 属阶段 2 B11，阶段 1 不调用——p1-03 §3.1 明示） |
| 4 | 行动设置控件 keyed 注册（ActionSettingsControlBase.GetInstance 经 GetKeyedService 以行动 ID 为 key） | 宿主 ActionRegistryExtensions.AddAction | 由 `AddAction<TAction,TSettingsControl>` 落实（`AddKeyedTransient<ActionSettingsControlBase,TSettingsControl>(info.Id)`，info.Id 即 p1-03 固化的 `SystemTools.CrossPlatform.*`） |
| 5 | 14 对行动/控件配对 + A9 单参 | p1-03 §3 表 | §2.5 表逐对落地；A10 控件配对随源 :427 先例（行动本体无设置泛型） |

### 3-2 p1-04 §6「结构化注册清单」逐项

| # | 需求（p1-04 §6） | 源锚点 | 落实 |
| --- | --- | --- | --- |
| 1 | A9 主链服务 `AiChatWindowService` Singleton，条件 `EnableAiService==true` | 源 :137（条件块 :130-139） | `if (GlobalConstants.MainConfig?.Data.EnableAiService == true) { …6 Singleton… }`（源 7 项去 `AiVoiceConversationService`，语音族 C / 04-spec S4.1） |
| 2 | `IOpenAiCompatibleService` → `OpenAiCompatibleService` 接口绑定 Singleton，无条件 | 源 :129 | 落实 |
| 3 | 支撑服务 ×5（AiConversationStore/AiChatOperationGate/AiPromptService/ClassIslandProfileAiService/ClassIslandActionAiService）条件同上 | 源 :132-136 | 落实 |
| 4 | 通知提供方：`AddNotificationProvider<T>()` + 去重后 `AddSingleton<T>()` 复用同实例 + `AddSingleton<IHostedService>(sp => sp.GetRequiredService<T>())`（防提醒渠道双注册） | 源 :141-149 | 逐行保留（Single 检索 IHostedService 描述符 → Remove → AddSingleton<T> → AddSingleton<IHostedService> 工厂） |
| 5 | A9 浮窗：无直接注册；AppStopping `TryGetService<AiChatWindowService>()?.Close()` | 源 :1058 | 落实（OnAppStopping） |
| 6 | AI 回复通知内容 `AiReplyNotificationContent`：无 DI | 源 SystemToolsNotificationProvider.cs:31 | 无需注册（经 NotificationRequest.OverlayContent 使用） |
| 7 | 虚拟放学：`AddSingleton` + AppStarted→`Start()` + AppStopping→`Stop()` | 源 :124/:220/:1047 | 落实 |
| 8 | 版本检查：静态 + AppStarted→`CheckAndNotify()` | 源 :284 | 落实 |

## 4. 设置页骨架 6 页（SettingsPage\，第 33 项服务聚合；骨架 = 页面结构 + 导航 + 既有 A 档选项绑定位，完整整合属阶段 3）

### 4.1 页面清单与注册 id（6/6 确认）

| # | 页面（文件名随源） | 注册 id | 源 id | 特有注册形态 |
| --- | --- | --- | --- | --- |
| 1 | `SystemToolsSettingsPage.axaml(.cs)` | `SystemTools.CrossPlatform.settings.main` | `systemtools.settings.main` | [HidePageTitle] + [Group]；显示名/图标随源（"主设置"，图标空表达式） |
| 2 | `MoreFeaturesOptionsSettingsPage.axaml(.cs)` | `SystemTools.CrossPlatform.settings.more` | `systemtools.settings.more` | hideDefault=true 随源第 5 参；无 [HidePageTitle]（随源） |
| 3 | `AiChatSettingsPage.axaml(.cs)` | `SystemTools.CrossPlatform.settings.aiChat` | `systemtools.settings.aiChat` | **条件注册** `if (EnableAiService)`（随源 :178-181）+ [HidePageTitle] |
| 4 | `FloatingWindowEditorSettingsPage.axaml(.cs)` | `SystemTools.CrossPlatform.settings.floating` | `systemtools.settings.floating` | **无条件注册**（源 :182-185 以 EnableFloatingWindowFeature（B 档成员）为门，阶段 1 裁剪形无此成员，差异登记 §9-6）+ [HidePageTitle] |
| 5 | `AboutSettingsPage.axaml(.cs)` | **`SystemTools.CrossPlatform.settings.about`**（契约） | `systemtools.settings.about` | [HidePageTitle]；p1-04 §5-2 契约兑现，见 §4.3 |
| 6 | `PluginDebugSettingsPage.axaml(.cs)` | `SystemTools.CrossPlatform.settings.pluginDebug` | `systemtools.settings.pluginDebug` | [HidePageTitle] + hideDefault=true |

- 分组：`services.AddSettingsPageGroup("SystemTools.CrossPlatform.settings", "\uE079", "SystemTools 设置")` + 各页 `[Group("SystemTools.CrossPlatform.settings")]`（宿主 SettingsWindowRegistryExtensions 原生能力；替代源反射分组 InjectServices 方案，故**未新建** p1-05 §4.1-3 所指注册辅助文件，§9-3）。6 个注册 id 两两唯一（AddSettingsPage 重复 id 即抛错，注册唯一性由 SDK 断言）。
- 骨架内容：通用设置页＝AI 服务选项组（EnableAiService 开关+使用协议、AiProviderName/AiApiKey/AiApiUrl/AiModel+获取模型）与「更多功能选项」导航（B/C 分组不迁入）；更多功能选项页＝虚拟放学选项组（virtualAfterSchool* 三成员，ApplyConfig+Save 随源 :59-68）；AI 页＝对话结构（历史/消息区/输入/发送/停止/状态）+ AI 回复通知共享开关 + 档案修改与行动执行审批对话框（A9 主链安全面）；悬浮窗编辑页＝配置方案选择（FloatingWindowProfileManager，A3/A4 共享类型；选择语义与 A3 行动一致：SaveProfile→LoadProfile→CurrentFloatingWindowProfile→Save，源 Actions\ToggleFloatingWindowProfileAction.cs:116-124）；关于页＝插件信息卡（连击 5 次进调试页）+ 反馈链接 + 帮助/介绍/更新日志标签页；调试页＝零 A 档绑定（源页全为 U5 降级面玻璃调试选项，仅保留结构+注册入口）。
- 共享 `SystemToolsSettingsViewModel.cs` 骨架：Settings（配置根）+ FloatingWindowProfileNames/SelectFloatingWindowProfile（悬浮窗方案面）；源同名文件（61.5KB，B/C 下载与拖拽逻辑）不整体迁移。

### 4.2 AiChatSettingsViewModel 契约落实（p1-04 §5-1，逐项兑现）

1. **去语音构造**：`(AiConversationStore, IOpenAiCompatibleService, AiPromptService, AiChatOperationGate, MainConfigHandler, SystemToolsNotificationProvider, ClassIslandProfileAiService, ClassIslandActionAiService, Func<ProfileModificationPreview,Task<bool>>, Func<ActionExecutionPreview,Task<bool>>)` ＝ 8 服务参 + 2 审批委托参；源 :66 `VoskSpeechService` 参数随语音族裁剪；`useVoiceWakePrompt`/`useTransientConversation` 可选参保留且默认 false（浮窗路径恒默认 false，与 p1-04 §2.2-3 `LoadSystemPrompt(bool)` 签名保留口径一致）；`suppressClassIslandNotificationSharing` 可选参随源保留（默认 false，消费点 :633/:1404 保留）。已与 p1-04 交付浮窗 `Views\AiChatFloatingWindow.axaml.cs:74-84` 的 10 参实调逐参核对一致。
2. **29 个公共成员面保留**（p1-04 §5-1 清单源锚点逐项）：`PendingAttachments`:59、`CurrentModelName`:111、`InputPlaceholder`:115、`CanSend`:119、`IsAnyGenerationActive`:125、`IsNoGenerationActive`:127、`CanChangeConversation`:129、`CanModifyAttachments`:131、`HasStatus`:147、`HasMessages`:149、`HasPendingAttachments`:151、`IsClassIslandNotificationSharingEnabled`:155、`ConversationContentChanged`:170、`CreateNewConversation`:255、`SendAsync`:309、`BeginEditUserMessage`:393、`CancelEditUserMessage`:412、`CommitEditedUserMessageAsync`:418、`RetryAssistantMessageAsync`:470、`ReportError`:508、`AddPendingAttachments`:513、`RemovePendingAttachment`:532、`StopGeneration`:698、`TryBeginAttachmentUpdate`:781、`EndAttachmentUpdate`:800、`Dispose`、`SelectedConversation`、`InputText`、`StatusText`、`IsGenerating` —— 30 个具名成员（p1-04 §5-1 清单全文）**全部在位**，方法体逐行保留源实现。
3. **语音成员裁剪**：语音输入开关/提示/切换成员及其字段、事件订阅、Dispose 清理路径（源 :23-24、:44-48、:56、:378-397、:798-918 等）全部移除；残留核对零命中（§7-2）。
4. **MainConfigData 依赖**：`AiModel`（p1-04 已增补 ✓）、`ShareAiRepliesWithClassIslandNotifications`（本批预批增补，§5）。
5. 预览类型成员名与 p1-04 交付定义核对一致：`ProfileModificationPreview`（ProfileFilePath/Summary/Operations）、`ProfilePatchOperationPreview`（Operation/Path/Before/After）、`ActionExecutionPreview`（Summary/Items）、`ActionExecutionItemPreview`（Index/Id/Name/SettingsJson）。

### 4.3 AboutSettingsPage id 契约（p1-04 §5-2）

- 注册 id = **`SystemTools.CrossPlatform.settings.about`**（实测 `SettingsPageInfo` 特性值），与 p1-04 交付 `Version\VersionCheckService.cs:94` 导航 URI `classisland://app/settings/SystemTools.CrossPlatform.settings.about` **逐字符一致**，无需尚书省单点统一。
- 联动成员：`GlobalConstants.ShowChangelogOnOpen`（p1-04 增补）读方 = 本页 `CheckAutoSwitchTab()`（源 :126-133 语义随源：打开时若标记为真切至"更新日志"标签并复位标记）；`Information.PluginVersion` 读方 = AboutSettingsViewModel.PluginVersion。
- 连击导航目标 id 同步按前缀规则改写：`classisland://app/settings/SystemTools.CrossPlatform.settings.pluginDebug`。

## 5. 共享类型成员增补留痕（p1-05 §2.3-4 机制；尚书省派工预批，属主批 p1-03 流程确认在案）

`ConfigHandlers\MainConfigData.cs`（p1-03 引入、p1-04 增补 7 成员后，本批增补 2 成员，文件内留痕注释已置）：

| # | 成员 | JSON 属性名（与源一致） | 默认值 | 守卫语义 | 源锚点 | 消费方 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `AiProviderName` | `aiProviderName` | `"OpenAI"` | null 归空 + Ordinal 相等短路 + OnPropertyChanged（逐行随源） | 源 ConfigHandlers\MainConfigData.cs:308-321 | 主设置页供应商名称绑定（SettingsPage\SystemToolsSettingsPage.axaml `{Binding Config.AiProviderName}`）；p1-04 §5-1-4 预批条款「如其页面另用 AiProviderName 等同增补」的适用项 |
| 2 | `ShareAiRepliesWithClassIslandNotifications` | `shareAiRepliesWithClassIslandNotifications` | `false` | 相等短路 + OnPropertyChanged（逐行随源） | 源 :368-380 | `AiChatSettingsViewModel.IsClassIslandNotificationSharingEnabled`（源 VM :155-168 消费）＋ AI 页共享开关绑定 |

增补流程：尚书省派工单预批（p1-03 为属主批，已确认免另行确认）→ 文件内留痕注释（p1-04 增补段后追加「p1-06 增补」段，含源锚点与消费方注记）→ 本批证据登记（本节）→ S4.2 复扫 PASS（§7-1 目标 3）。

## 6. macOS 兼容自检表（p1-05 §5.3 五列格式，覆盖本批全部外部依赖点；BCL 纯 .NET API 不逐项列）

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | Plugin.cs:67-70 | `PluginBase.PluginConfigFolder`/`Info`（宿主注入） | 宿主抽象（PluginBase 契约，p0-01 §3） | 可用 |
| 2 | Plugin.cs:76-103 | `AddXamlTheme` + `ThemeManifest`（XAML 主题注册） | 宿主跨平台 API（ClassIsland.Core.Extensions.Registry） | 可用（Avalonia 资源加载） |
| 3 | Plugin.cs:111-149 | Microsoft.Extensions.DependencyInjection（AddSingleton/AddHostedService 等） | BCL/SDK | 可用 |
| 4 | Plugin.cs:175-187 | `AddSettingsPageGroup`/`AddSettingsPage`/`[Group]` | 宿主跨平台 API（ClassIsland.Core.Extensions.Registry） | 可用 |
| 5 | Plugin.cs:622-996 形态 | `IActionService.ActionMenuTree`/`ActionMenuTreeGroup/Item` | 宿主跨平台 API（内存注册表，无平台符号） | 可用 |
| 6 | Plugin.cs:201/:220/:284/:288 形态 | `AppBase.Current.AppStarted/AppStopping` | 宿主跨平台 API（ClassIsland.Core） | 可用 |
| 7 | Plugin.cs 钩子体 | `IAppHost.GetService/TryGetService` | 宿主跨平台抽象（ClassIsland.Shared.IAppHost，p0-01 §3） | 可用 |
| 8 | SystemToolsSettingsPage.axaml.cs:93-120 形态（源 :93-120） | AI 服务开关重启路径：源 `RestartClassIsland()`（Process.Start + .exe 替换，Win 语义） | **改用宿主 `SettingsPageBase.RequestRestart()`**（RequestRestartCommand，宿主设置窗口重启机制） | 可用（宿主跨平台实现；避免源 Win 进程替换路径） |
| 9 | SystemToolsSettingsPage.axaml.cs GetAiModelsButton 形态 | `IOpenAiCompatibleService.GetModelsAsync`（HttpClient 文本链） | 跨平台 API（BCL HttpClient 封装于 p1-04 服务） | 可用 |
| 10 | SystemToolsSettingsPage.axaml.cs:219-258 形态 | `FAContentDialog`/`CheckBox`/`TextBlock`（协议对话框） | Avalonia/FluentAvalonia 跨平台 API | 可用 |
| 11 | MoreFeaturesOptionsSettingsPage.axaml.cs（源 :59-68） | `VirtualAfterSchoolService.ApplyConfig` + `IAppHost.TryGetService` | 宿主抽象 + p1-04 交付服务（DispatcherTimer） | 可用（p1-04 §7 已核） |
| 12 | FloatingWindowEditorSettingsPage 骨架 | `FloatingWindowProfileManager`（File IO 配置方案目录） | BCL（配置文件随 PluginConfigFolder，R-5 新插件独立配置口径） | 可用 |
| 13 | AiChatSettingsPage.axaml.cs 审批对话框 | `FAContentDialog.ShowAsync(TopLevel)` + `TopLevel.GetTopLevel` | Avalonia/FluentAvalonia 跨平台 API | 可用 |
| 14 | AiChatSettingsPage.axaml.cs 附件路径 | `AiAttachmentService.CreateFilePickerOptions`/`LoadFilesAsync`（`TopLevel.StorageProvider`） | Avalonia 跨平台 API（p1-04 交付） | 可用 |
| 15 | AiChatSettingsPage/AboutSettingsPage 导航 | `IUriNavigationService.NavigateWrapped` | 宿主跨平台抽象（p0-01 §3；p1-04 VersionCheckService 已核同用法） | 可用 |
| 16 | AboutSettingsPage.axaml.cs LoadPluginIcon（源 :41 先例） | `Bitmap`（Avalonia.Media.Imaging）读插件目录 icon.png | Avalonia 跨平台 API（BCL File.Exists 守卫） | 可用 |
| 17 | AboutSettingsPage.axaml（源 :165-170 形态） | `Markdown.Avalonia.MarkdownScrollViewer` + `MarkdownConvertHelper.Engine` | 跨平台 UI 包（宿主既有依赖） | 可用 |
| 18 | AiChatSettingsViewModel 全文 | Avalonia.Threading.Dispatcher / CommunityToolkit.Mvvm 8.2.1 | 跨平台 API | 可用 |
| 19 | Plugin.cs OnAppStopping | `GlobalConstants.MainConfig?.Save()`（ConfigureFileHelper） | BCL（p1-03 交付，JSON 文件写） | 可用 |

零"不适用"行；G1–G3 未暴露（本批未使用任何宿主缺口接口）；发明新接口零处。

## 7. 门禁与自检结果（全部留档本案 evidence/）

1. **S4.2 批内扫描 + 全树收口复跑**（p0-07-s42-scan.ps1 -Scope Source，交付终态复跑，单文件留档 `p1-06-s42-scan-output.txt`）：
   - 批内 3 目标：Plugin.cs（单文件形态）/ SettingsPage\（8 个 .cs）/ MainConfigData.cs —— GateHits=0、VERDICT: PASS、exit=0 ×3；
   - 全树收口（p1-05 §5.2-4；并行微修 p1-02 tasklist→BCL 替换落地与否不阻塞本批——该替换不引入命中；全树终检由刑部 p1-08 权威覆盖）：`src\SystemTools.CrossPlatform` 全目录，SourceFiles=119、**GateHits=0、VERDICT: PASS、exit=0**（csproj 6 条 COMMENT-ONLY 为 p0 既有注释提及，非门禁命中）。
2. **不迁面残留核对**（p1-04 §8-4 同款模式，覆盖本批全部交付路径）：Vosk/LiquidGlass/背景采样/VoiceInput 系/小写 `systemtools.settings.about` —— 本批路径零命中。全树现有 1 处命中为 p1-04 交付 `ConfigHandlers\MainConfigData.cs:92` 留痕注释（"源 AI 液态玻璃成员…不增补"清单说明），非 p0-07 门禁规则、非本批写入（本批仅在该文件 p1-04 段后追加 §5 两成员），不构成门禁命中；提请复核方知悉，是否随批清理由 p1-08 权威终检裁量。
3. **命名空间/using 核对**：`namespace (?!SystemTools.CrossPlatform)` 全树零命中；`using SystemTools.(?!CrossPlatform)` 零命中。
4. **注册前缀唯一性复核**：Plugin.cs 内全部带引号 `"SystemTools.` ID（30 个唯一值，§7-4 输出）100% 落于 `SystemTools.CrossPlatform.*`；6 个设置页 id + 分组 id 同前缀。与原插件 ID 空间不相交依据：p0-05 §4.2 实证原插件全源码 `CrossPlatform` 零出现（同装并存 R-10 成立）；GUID 面（6 组件 + 通知提供方 3 GUID）由 p1-01 §3.4/p1-04 §3.4 零重合自证覆盖，本批零新增 GUID 形态身份（AboutSettingsPage id 为字符串 ID，非 GUID）。
5. **主题 manifest id 一致性复核**（p1-05 §7.2）：3 个 `Themes\*\manifest.yml` id 与 Plugin.cs AddXamlTheme ThemeManifest.Id 逐字符一致（Card-type-component / classwidgets / notch-style 三形态均带前缀改写）。
6. **批内补充编译自检**（非官方门禁，方法沿 p1-02 v2 先例）：进程内 Roslyn（Microsoft.CodeAnalysis.CSharp 5.6.0）对全工程 114 源文件 + 检查专用存根编译诊断；**本批 9 个交付 .cs error=0**（warning=4 均为存根性 [ObservableProperty] 字段未用提示，真实构建由生成器消除）；他批文件 170 条为 XAML 生成面/生成器未接线预期噪声，单列不计判定。沙箱禁止 dotnet 子进程（命名管道边界），官方三平台构建门禁仍属阶段级验证（p1-05 §5.2-3）。输出：`p1-06-supplementary-compile-check.ps1` + `p1-06-supplementary-compile-check-output.txt`。

## 8. manifest 不变声明

- 本批写入对象仅 `Plugin.cs`、`SettingsPage\` 14 文件、`MainConfigData.cs` 预批段、本案 evidence/ 4 文件；**manifest.yml 零触碰**。
- 字节级证据：当前 `src\SystemTools.CrossPlatform\manifest.yml` SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`，与 p0-05 证据文件 §13 基线记录 `142CD419…AAC` **完全一致**（p0-05 校验工具最近一次对该基线判 11 PASS + SCHEMA-PARSE-CHECK: PASSED）。
- 工具复跑受限说明：本会话沙箱禁止 .NET 子进程（`manifest-schema-check.exe` 启动即触发命名管道访问拒绝，与 p1-02 报告的沙箱边界同源），本批无法在会话内代跑该工具；以 SHA256 字节同一性替代工具重放作不变性证明，并建议刑部 p1-08 在允许 dotnet 子进程的会话中复跑该工具作为权威留档（p1-08 全树终检属权威覆盖范围）。

## 9. 报备事项（差异与核减，均已留痕；请尚书省/Menxia 知悉）

1. **AddLogging 核减**：源 Plugin.cs:74 `services.AddLogging()` 未随入——宿主 Generic Host 先于插件初始化注册日志服务，该调用为冗余防御；Plugin.cs 内留有注释。
2. **主题 Banner 置空**：源 :84/:96/:108 `Banner = ThemeBannerCacheService.BannerPath`（源专属缓存服务，阶段 1 未交付）→ ThemeManifest.Banner 显式置空字符串；banner 资产落值随后续资产阶段。
3. **设置页分组改用宿主原生 API**：源以反射 InjectServices（`AddSettingsPageGroup` 私有方法 + GroupId 反射回填，源 :1002-1028）实现分组；宿主检出已提供公开 `AddSettingsPageGroup(id, icon, name)` 与 `[Group]` 特性，本批直接使用，未新建任何注册辅助文件（p1-05 §4.1-3 的 InjectServices 型文件因此零引入）。
4. **悬浮窗行动菜单组门差异**：源 BuildBaseActionTree :671-677 悬浮窗设置组以 `EnableFloatingWindowFeature`（B 档成员，阶段 1 裁剪形未引入）为门；阶段 1 不建该组，A3/A4 行动本体按 IsActionEnabled 常规注册（§2.5），行动功能面完整，菜单组随阶段 2/3 B11 恢复。
5. **菜单 AddRange → 逐项 Add**：本地宿主检出 `ActionMenuTreeNodeCollection`（KeyedCollection）无 AddRange 方法（源插件 NuGet SDK 面与本地检出版本差）；以 foreach Add 等价改写，语义一致。
6. **悬浮窗编辑页无条件注册**：源 :182-185 以 EnableFloatingWindowFeature 为门；阶段 1 该成员不存在于裁剪形配置根，改为无条件注册骨架页（页面 A 档绑定面仅 FloatingWindowProfileManager 方案选择，不依赖 B 档成员）；完整门控随 B11 恢复。
7. **主设置页骨架绑定面**：源页绑定面含 `ViewModel.Settings.EnableExperimentalFeatures/EnableFaceRecognition/EnableWindowsHello/EnableFfmpegFeatures`、语音识别模型组、功能下载抽屉等 B/C 面，全部不迁入（p1-05 §4.3-2：骨架不复制 B/C 选项实现）；`RestartPropertyChanged` 事件（p1-04 注记属 p1-06 增补面）以"开关切换后直接 RequestRestart()"的源等价行为覆盖（源 :102/:119 同样在开关路径内重启），未在配置根引入该事件。
8. **AI 页骨架附件面**：保留添加附件（文件选择器）+ 待发列表 + 移除 + 重试/停止/历史/新建/删除对话与两审批对话框；源页的粘贴位图、拖放遮罩（AiAttachmentDropOverlay 服务已交付但页面接线属阶段 3 整合面）与消息编辑 UI 不迁入。
9. **显示文案随源不改**：含"由插件SystemTools提供服务"等已留观察点文案（门下省观察点，本批未改）；菜单组名/页面名/描述随源。

## 10. 边界声明

- 本批写入：`Plugin.cs`（重写，唯一注册面）；`SettingsPage\` 14 个新文件（6×.axaml + 6×.axaml.cs + SystemToolsSettingsViewModel.cs + AiChatSettingsViewModel.cs）；`ConfigHandlers\MainConfigData.cs`（仅 §5 预批 2 成员 + 留痕注释）；evidence/ 5 文件（本报告、`p1-06-s42-scan-output.txt`〔批内 3 目标 + 全树终态复跑单档〕、`p1-06-supplementary-compile-check.ps1` + `p1-06-supplementary-compile-check-output.txt`、`p1-06-manifest-check-output.txt`〔工具受阻记录 + 哈希不变性证据〕）。早前中态复跑单档 `p1-06-s42-fulltree-rescan-output.txt` 已被终态单档取代并移除，避免双档混淆。
- 零改动：`manifest.yml`、`SystemTools.CrossPlatform.csproj`、`global.json`、`.slnx`、兵部四批全部交付文件、原插件检出（只读）、宿主检出（只读）。
- 新文件命名全部随源（p1-05 §3.4-1）；`SettingsPage\` 落点与命名空间 `SystemTools.CrossPlatform.SettingsPage` 符合 p1-05 §2.1/§3.2-3。
- 本文件不推进、不审批全局工作流；属批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验。
