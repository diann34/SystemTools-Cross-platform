# p1-04 证据：A 档服务群 3 项抽取（兵部 application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-04 · 兵部 war · application-code / implementation |
| 权威输入 | p1-05 落点规范（§2 落点、§3 命名/ID、§4 注册面、§5 门禁）、p0-03 A 档服务域清单（A33）、02 §2.6（AI 文本链支撑类型集口径）、04-spec（R-6/U5 降级、S4.1 语音族 C、S4.2 门禁）、p0-01（宿主抽象 §3 与缺口 G1–G3）、p0-07（S4.2 扫描器）、尚书省增补指令（SystemToolsNotificationProvider 纳入 + 全局 GUID 规则 + DI 注册清单增补） |
| 写入范围 | 仅本批落点：`Services\`、`Version\`、`Views\`、`Controls\Notifications\`、AI 链附属 `Controls\AiAttachmentDrop*.axaml(.cs)`（p1-05 §2.3-1）、AI 链所需 `Models\AiAttachment.cs`/`AiConversation.cs`、共享文件按需增补（`ConfigHandlers\MainConfigData.cs`、`Shared\GlobalConstants.cs`，见 §4）、evidence/。源插件与宿主全程只读；Plugin.cs/manifest.yml/csproj/global.json/slnx 零改动 |
| 结论 | **succeeded** —— 3 项服务 + AI 支撑集共 23 个新文件落位完成（§1），S4.2 扫描 12 目标全 PASS exit=0（§8），macOS 自检表全绿、G1–G3 零暴露（§7），跨批依赖契约与 DI 注册需求已移交礼部 p1-06（§5/§6） |

---

## 1. 逐项源对照与落点清单

新文件命名空间一律 `SystemTools.CrossPlatform.<目录镜像>`（§3.2），文件名随源（§3.4-1），除 §3 明列适配点外源码逐字保留。

### 1.1 服务① AI 文本链（A9 主链，02 §2.6 口径支撑类型集）

| # | 源文件（E:\My Github Projects\SystemTools\） | 源行 | 新落点（src\SystemTools.CrossPlatform\） | 适配 |
| --- | --- | --- | --- | --- |
| 1 | `Services\AiChatWindowService.cs` | 1–66 | `Services\AiChatWindowService.cs` | 命名空间/usings；**移除 VoskSpeechService 与 MainWindowBackgroundCaptureService 两参**（源 :14/:19 及 :34/:39 传参；语音族 C + R-6 采样不迁） |
| 2 | `Services\IOpenAiCompatibleService.cs` | 1–70 | `Services\IOpenAiCompatibleService.cs` | 命名空间 |
| 3 | `Services\OpenAiCompatibleService.cs` | 1–1190 | `Services\OpenAiCompatibleService.cs` | 命名空间；`using SystemTools.ConfigHandlers` → `SystemTools.CrossPlatform.ConfigHandlers`（消费 EnableAiService :557、AiModel :575、AiApiKey :805、AiApiUrl :816） |
| 4 | `Services\AiConversationStore.cs` | 1–161 | `Services\AiConversationStore.cs` | 命名空间；usings→CrossPlatform；**回退配置目录名 `SystemTools` → `SystemTools.CrossPlatform`**（源 :23-27；同装并存 R-5 全新配置口径） |
| 5 | `Services\AiPromptService.cs` | 1–117 | `Services\AiPromptService.cs` | 命名空间（提示词文案随源不改，见 §3-注3） |
| 6 | `Services\AiAttachmentService.cs` | 1–388 | `Services\AiAttachmentService.cs` | 命名空间；usings→CrossPlatform.Models |
| 7 | `Services\AiAttachmentDropService.cs` | 1–61 | `Services\AiAttachmentDropService.cs` | 命名空间；usings→CrossPlatform（Controls/Models） |
| 8 | `Services\ClassIslandActionAiService.cs` | 1–1861 | `Services\ClassIslandActionAiService.cs` | 命名空间（纯 SDK/BCL/Avalonia.Media） |
| 9 | `Services\ClassIslandProfileAiService.cs` | 1–1825 | `Services\ClassIslandProfileAiService.cs` | 命名空间（纯 SDK/BCL/Avalonia.Threading；内部瞬态标记 `$systemToolsTimePointOrigin` :59 随源不改，仅内存内使用、从不持久化） |
| 10 | `Services\AiChatOperationGate.cs` | 1–111 | `Services\AiChatOperationGate.cs` | 命名空间 |
| 11 | `Services\SystemToolsNotificationProvider.cs` | 1–53 | `Services\SystemToolsNotificationProvider.cs` | 命名空间；usings→CrossPlatform.Controls.Notifications；**GUID×3 重造**（§3.4，尚书省增补指令 #1/#2 交付确认项） |
| 12 | `Views\AiChatFloatingWindow.axaml` | 1–537 | `Views\AiChatFloatingWindow.axaml` | x:Class、controls xmlns；**删除液态玻璃/采样/语音面**（§2）；输入区列 6→5、发送/停止列号 4→3/5→4 |
| 13 | `Views\AiChatFloatingWindow.axaml.cs` | 1–973 | `Views\AiChatFloatingWindow.axaml.cs` | 命名空间/usings；**删除液态玻璃/采样/语音机制**（§2）；保留窗口状态锁定订阅、附件/拖放/剪贴板、档案/行动审批对话框、滚动跟随全部逻辑 |
| 14 | `Controls\AiAttachmentDropOverlay.axaml` | 1–52 | `Controls\AiAttachmentDropOverlay.axaml` | x:Class（附属控件，p1-05 §2.3-1 随功能项引入，落位随源构造） |
| 15 | `Controls\AiAttachmentDropOverlay.axaml.cs` | 1–54 | `Controls\AiAttachmentDropOverlay.axaml.cs` | 命名空间（`Services.AiAttachmentService` 相对命名空间解析随镜像自动成立，源 :35） |
| 16 | `Controls\AiAttachmentDropConfirmation.axaml` | 1–86 | `Controls\AiAttachmentDropConfirmation.axaml` | x:Class |
| 17 | `Controls\AiAttachmentDropConfirmation.axaml.cs` | 1–32 | `Controls\AiAttachmentDropConfirmation.axaml.cs` | 命名空间；usings→CrossPlatform |
| 18 | `Controls\Notifications\AiReplyNotificationContent.axaml` | 1–18 | `Controls\Notifications\AiReplyNotificationContent.axaml` | x:Class |
| 19 | `Controls\Notifications\AiReplyNotificationContent.axaml.cs` | 1–79 | `Controls\Notifications\AiReplyNotificationContent.axaml.cs` | 命名空间（Avalonia 组合动画跨平台） |
| 20 | `Models\AiAttachment.cs` | 1–121 | `Models\AiAttachment.cs` | 命名空间 |
| 21 | `Models\AiConversation.cs` | 1–186 | `Models\AiConversation.cs` | 命名空间（含 AiConversationMessage） |

### 1.2 服务② 虚拟放学

| # | 源文件 | 源行 | 新落点 | 适配 |
| --- | --- | --- | --- | --- |
| 22 | `Services\VirtualAfterSchoolService.cs` | 1–299 | `Services\VirtualAfterSchoolService.cs` | 命名空间；usings→CrossPlatform.ConfigHandlers（消费 MainConfigData.VirtualAfterSchoolEnabled :129、VirtualAfterSchoolTriggerTime :144、VirtualAfterSchoolDurationSeconds :167） |

### 1.3 服务③ 版本检查

| # | 源文件 | 源行 | 新落点 | 适配 |
| --- | --- | --- | --- | --- |
| 23 | `Version\VersionCheckService.cs` | 1–109 | `Version\VersionCheckService.cs` | **命名空间随源 `SystemTools.Services` → 目录镜像 `SystemTools.CrossPlatform.Version`**（p1-05 §3.2-1 权威）；usings→CrossPlatform.Shared；设置页导航 URI 适配（§3-注2） |

**交付项数：3 项服务 + AI 支撑集（9 服务类型含提供方 + 浮窗对 + 拖放控件对 + 通知控件对 + 2 模型）= 23 个新文件。**

## 2. 不迁清单与 R-6 注记（04-spec 已批降级口径）

### 2.1 R-6 自适应背景采样子特性——不迁入（本批强制注记）

依据 04-spec R-6（「AI 对话浮窗的自适应背景子特性随 U5 降级」）+ U5（S4.4：液态玻璃 + 自适应背景采样为 C 候选，含 AI 对话浮窗消费方）+ S7-R3（所有采样消费方同步降级）。落点处置：

- **不迁文件**：`Services\MainWindowBackgroundCaptureService.cs`（GDI 采样）、`Services\BackgroundLuminanceCalculator.cs`、`Services\LiquidGlassBackdropFactory.cs`、`Controls\AiChatGlassSurface.cs`（依赖 ThirdParty\LiquidGlassAvaloniaUI，源插件 Windows-only 排除面）、`ConfigHandlers\LiquidGlassSettings.cs`/`LiquidGlassButtonSettings.cs`。
- **浮窗 axaml 删除段**（源行号）：`xmlns:lg` :8；`AiChatGlassSurfaceColor` 资源 ×3 :32/:38/:44；`LiquidGlassBackdropClip`+`LiquidGlassBackdropImage`+`LiquidGlassSurface` :59-70；`lg:LiquidGlassBackdrop.IsExcludedFromCapture` :77；`AiChatGlassSurface` 面板 ×3 :146-150/:269-273/:362-366。
- **浮窗 axaml.cs 删除段**（源行号）：`AdaptiveThemeRefreshStride` :32；捕获/玻璃字段 :38-49；`IsLiquidGlassContentVisibleProperty` 及属性 :51-72；`ConversationGlassSettings` :83；捕获计时器初始化 :129-132；`Config_OnPropertyChanged` 订阅与本体 :136/:173-187；`Window_OnOpened`/`Window_OnPositionChanged` :168-171；捕获循环/释放/外观/自适应主题全组 :189-430；`ParseColor` :429-430；OnClosed 玻璃清理 :954-964。
- **配置成员不增补**：`AiConversationFloatingWindowStyle`/`AiConversationLiquidGlass`/`AiConversationApprovalButtonGlass` 为 U5 玻璃族成员，本批增补的 MainConfigData（§4）不含之，交付代码无消费方。
- **窗口结果形态**：恒为经典外观（`IsClassicConversationSurfaceVisible` 恒 true，保留属性与绑定以最小化 axaml 偏差）；主题跟随应用 `ActualThemeVariant`（源 :128 保留，无采样介入）。

### 2.2 语音族——不迁入（04-spec S4.1「语音族 C」/ S7-R2「新插件无语音输入/唤醒」）

- 不迁：`VoskSpeechService`、`AiVoiceConversationService`、`SpeechRecognitionDependencyPrompt`（浮窗语音按钮处理器源 axaml.cs :437-448 随之删除）。
- 浮窗 axaml 语音按钮删除（源 :476-496：`VoiceInputToolTip`/`CanToggleVoiceInput`/`IsVoiceInputActive` 绑定与 Tag 样式），输入区列定义 `Auto,*,Auto,Auto,Auto,Auto`→`Auto,*,Auto,Auto,Auto`，发送/停止按钮列号前移。
- `AiPromptService.LoadSystemPrompt(bool useVoiceWakePrompt)` 签名随源保留（浮窗路径恒默认 false；语音唤醒提示词常量随源保留但语音族消费方不存在，文案不涉门禁符号）。

### 2.3 其他不迁

- `MainConfigHandler`/`MainConfigData`/`GlobalConstants` **本批不新造**：p1-03 已按 p1-05 §2.3-2 引入（`ConfigHandlers\`、`Shared\`），本批只引用 + 按需增补成员（§4）。

## 3. 适配点明细（除命名空间/usings 外的全部改动）

1. **AiChatWindowService/AiChatFloatingWindow 构造签名**：去除 `VoskSpeechService speechService`、`MainWindowBackgroundCaptureService backgroundCaptureService` 两参（服务→窗口→ViewModel 传递链同步收紧；`MainConfigHandler configHandler` 保留并继续传入 ViewModel）。
2. **版本检查导航 URI**：源 `classisland://app/settings/systemtools.settings.about` → `classisland://app/settings/SystemTools.CrossPlatform.settings.about`（新 :94；同装并存下不得导航至源插件关于页；p1-06 契约见 §5-②）。`GlobalConstants.ShowChangelogOnOpen` 写入语义随源。
3. **注 3（随源不改的观察点，非阻塞）**：提示词文案「由插件SystemTools提供服务」（AiPromptService 源 :73）与窗口标题「SystemTools - AI 对话」、通知显示名「SystemTools 通知」等显示文案随源不改（§3.3「显示名随源文案不改」）；如需产品化改名属后续决策面，不在本批抽取权限内。
4. **AiConversationStore 回退目录**：源 :23-27 回退路径末段 `SystemTools` → `SystemTools.CrossPlatform`（GlobalConstants.PluginConfigFolder 由 p1-06 的 Plugin.cs 赋值，回退仅为其 null 兜底）。
5. **GUID 重造映射**（尚书省全局 GUID 规则；源锚点 `Services\SystemToolsNotificationProvider.cs:9-14`；一次性生成后固化）：

| 用途 | 源 GUID（不复用） | 新 GUID |
| --- | --- | --- |
| NotificationProviderInfo 提供方 | `7E9A3D5C-1B8F-4E2A-9C6D-0F5E8B1A4D7C` | `44BB7B21-9831-4446-B3B6-3A4D7D1BE402` |
| NotificationChannelInfo 通用渠道 | `6F8C2B4A-9D1E-5F3B-8A7C-1E4D9F6B3A8C` | `DD9150A5-A457-45CA-B1B5-393699CFB083` |
| AiReplyChannelId（AI 回复渠道） | `7D7EFBF1-02A4-4A15-9C1A-2229027339B2` | `4BEE12E4-AB5A-4193-8E8E-1651C23228F3` |

零重合核对：新 GUID 与源插件全部 GUID 形态身份无交集；显示名/图标字符参数随源不改（§3.3）。本批无 ComponentInfo 等其他 GUID 形态。

## 4. 跨批共享类型：引用与按需增补（报尚书省追认）

p1-03 交付的共享文件头部已预留「后续需要批次按需增补」口径，本批按该口径增补并逐条注记来源锚点（两文件增补后已过 S4.2 扫描，§8 目标 11/12）：

1. **`ConfigHandlers\MainConfigData.cs`（p1-03 引入，本批增补 7 个 A 档成员）**：`VirtualAfterSchoolEnabled`/`VirtualAfterSchoolTriggerTime`（守卫 0≤t<1 天）/`VirtualAfterSchoolDurationSeconds`（钳 1..7200）——虚拟放学（源 MainConfigData.cs:141-183）；`EnableAiService`/`AiApiKey`/`AiApiUrl`/`AiModel`——AI 链（源 :244-257/:323-366）。JSON 属性名与源一致；源 `EnableAiService` 另发的 `RestartPropertyChanged` 事件未随入（阶段 1 裁剪形无该事件，消费方为设置页重启提示，属 p1-06 增补面，已注记于文件内注释）。U5 玻璃三成员不增补（§2.1）。
2. **`Shared\GlobalConstants.cs`（p1-03 引入，本批增补 2 成员）**：`Information.PluginVersion`（源 :21；消费方 VersionCheckService:22）、`ShowChangelogOnOpen`（源 :24；写方 VersionCheckService:92，读方 p1-06 AboutSettingsPage）。
3. **只引用不改动**：`ConfigHandlers\MainConfigHandler.cs`、`Converters\EnumDescriptionConverter.cs` 等 p1-03/p1-01 交付物。

**登记（落点待决类，无）**：本批未新增规范外目录或文件名；`Controls\AiAttachmentDrop*.axaml(.cs)` 四文件系 p1-05 §2.3-1「附属文件随功能项走 + 落位随源构造」的直接适用，非新造命名，特此报备请尚书省追认其落点归属 p1-04。

## 5. 跨批依赖契约（移交礼部 p1-06，阶段出口构建前必须闭合）

1. **`AiChatSettingsViewModel`（`SettingsPage\AiChatSettingsViewModel.cs`，源 1714 行，浮窗 AI 链引擎）——p1-06 域**。浮窗已按以下契约引用 `SystemTools.CrossPlatform.SettingsPage.AiChatSettingsViewModel`：
   - **构造（去语音口径）**：`(AiConversationStore, IOpenAiCompatibleService, AiPromptService, AiChatOperationGate, MainConfigHandler, SystemToolsNotificationProvider, ClassIslandProfileAiService, ClassIslandActionAiService, Func<ProfileModificationPreview,Task<bool>>, Func<ActionExecutionPreview,Task<bool>>)`；源 ctor 的 `VoskSpeechService`（源 :66）随语音族裁剪；`useVoiceWakePrompt`/`useTransientConversation` 可选参以默认 false 调用。
   - **浮窗消费的公共面**（源锚点）：`PendingAttachments` :59、`CurrentModelName` :111、`InputPlaceholder` :115、`CanSend` :119、`IsAnyGenerationActive` :125、`IsNoGenerationActive` :127、`CanChangeConversation` :129、`CanModifyAttachments` :131、`HasStatus` :147、`HasMessages` :149、`HasPendingAttachments` :151、`IsClassIslandNotificationSharingEnabled` :155、`ConversationContentChanged` :170、`CreateNewConversation` :255、`SendAsync` :309、`BeginEditUserMessage` :393、`CancelEditUserMessage` :412、`CommitEditedUserMessageAsync` :418、`RetryAssistantMessageAsync` :470、`ReportError` :508、`AddPendingAttachments` :513、`RemovePendingAttachment` :532、`StopGeneration` :698、`TryBeginAttachmentUpdate` :781、`EndAttachmentUpdate` :800、`Dispose`、`SelectedConversation`、`InputText`、`StatusText`、`IsGenerating`。
   - **语音成员须随语音族裁剪**（`IsVoiceInputActive`/`CanToggleVoiceInput`/`VoiceInputToolTip`/`ToggleVoiceInputAsync` 等；浮窗 axaml 已无对应绑定）。
   - **VM 需要的 MainConfigData 成员**：`AiModel`（本批已增补 ✓）、`ShareAiRepliesWithClassIslandNotifications`（源 :157 消费，**尚未在裁剪形中，p1-06 按 §2.3-4 机制增补**；如其页面另用 `AiProviderName` 等同增补）。
2. **AboutSettingsPage 页 id 契约**：VersionCheckService 导航 `classisland://app/settings/SystemTools.CrossPlatform.settings.about` → p1-06 注册 AboutSettingsPage 时须采用一致 id（§3.3 前缀规则的裸名推导形态），不一致时由 p1-06 回报尚书省统一调整（单点改动 VersionCheckService:94）。
3. **p1-03 A9 行动**（ShowAiChatDialogAction，p1-03 域）经 `IAppHost.GetService<AiChatWindowService>().ShowAsync()` 接通主链（源 Plugin.cs:965-966 先例）；本批服务已就位。

## 6. 结构化注册清单（p1-05 §4.2 交接格式 → 礼部 p1-06）

| 项 | 类型全名 | 功能 ID | 注册目标（生命周期随源先例） | 设置类型全名 | 源锚点 |
| --- | --- | --- | --- | --- | --- |
| A9 主链服务 | `SystemTools.CrossPlatform.Services.AiChatWindowService` | —（经 A9 行动触发） | 服务 DI **Singleton，条件 `Data.EnableAiService == true`** | 无 | 源 Plugin.cs:137（条件块 :130-139） |
| A9 主链服务 | `SystemTools.CrossPlatform.Services.IOpenAiCompatibleService` → `OpenAiCompatibleService` | — | 服务 DI Singleton，**接口绑定，无条件** | 无 | 源 Plugin.cs:129 |
| A9 支撑服务 | `SystemTools.CrossPlatform.Services.AiConversationStore` / `AiChatOperationGate` / `AiPromptService` / `ClassIslandProfileAiService` / `ClassIslandActionAiService` | — | 服务 DI Singleton ×5，条件同上 | 无 | 源 Plugin.cs:132-136 |
| **DI 注册需求项（尚书省增补指令 #3）** | `SystemTools.CrossPlatform.Services.SystemToolsNotificationProvider` | 提供方/渠道 GUID 见 §3-5 映射（新） | **`AddNotificationProvider<T>()` + 去重后 `AddSingleton<T>()` 复用同一实例 + `AddSingleton<IHostedService>(sp => sp.GetRequiredService<T>())`**（防止每个提醒渠道被注册两次的源注释先例） | 无 | 源 Plugin.cs:141-149 |
| A9 浮窗 | `SystemTools.CrossPlatform.Views.AiChatFloatingWindow` | — | 无直接注册（AiChatWindowService.ShowAsync 按需创建）；AppStopping 时 `TryGetService<AiChatWindowService>()?.Close()` | 无 | 源 Plugin.cs:1058 |
| AI 回复通知内容 | `SystemTools.CrossPlatform.Controls.Notifications.AiReplyNotificationContent` | — | 无 DI（经 NotificationRequest.OverlayContent 使用） | 无 | 源 SystemToolsNotificationProvider.cs:31 |
| 服务② 虚拟放学 | `SystemTools.CrossPlatform.Services.VirtualAfterSchoolService` | — | 服务 DI Singleton；**AppStarted → `Start()`；AppStopping → `Stop()`** | MainConfigData（virtualAfterSchool* 三成员） | 源 Plugin.cs:124 / :220 / :1047 |
| 服务③ 版本检查 | `SystemTools.CrossPlatform.Version.VersionCheckService` | — | 静态类无 DI；**`AppBase.Current.AppStarted += (_, _) => VersionCheckService.CheckAndNotify()`** | MainConfigData（无成员，version.json 于插件目录自管） | 源 Plugin.cs:284 |
| 拖放确认/遮罩 | `SystemTools.CrossPlatform.Controls.AiAttachmentDropConfirmation` / `AiAttachmentDropOverlay` | — | 无 DI（浮窗/服务内部 new） | 无 | 源 AiAttachmentDropService.cs:33、AiChatFloatingWindow.axaml :514（新行号） |

## 7. macOS 兼容自检表（p1-05 §5.3 五列格式，覆盖本批全部外部依赖点）

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `Version\VersionCheckService.cs:79-85`（源 :75-85） | `PlatformServices.DesktopToastService.ShowToastAsync(title, body, activated)` | 宿主跨平台抽象 `IDesktopToastService`（p0-01 §3 #3） | 可用（macOS 实装：NSUserNotificationCenterDelegate） |
| 2 | `Version\VersionCheckService.cs:95-96` | `IAppHost.TryGetService<IUriNavigationService>().NavigateWrapped` | SDK 跨平台 API（ClassIsland 宿主服务） | 可用（宿主应用层路由，非平台 API） |
| 3 | `Version\VersionCheckService.cs:18-22` | 插件目录 `version.json` 读写（File/Path/JsonSerializer） | BCL | 可用 |
| 4 | `Views\AiChatFloatingWindow.axaml.cs:113-129`（新） | `GetPropertyChangedObservable(WindowStateProperty)` + `Dispatcher.UIThread.Post` | Avalonia 跨平台 API（Avalonia.Base/Threading） | 可用 |
| 5 | `Views\AiChatFloatingWindow.axaml.cs`（拖放组） | `DragDrop.AllowDrop/DragEnter/Drop` + `DataTransfer.TryGetFiles()` | Avalonia 12 跨平台拖放 API | 可用（X11/Quartz 后端同源 API） |
| 6 | `Views\AiChatFloatingWindow.axaml.cs:247-260`（新） | `Clipboard.TryGetTextAsync()` / `TryGetBitmapAsync()`（Avalonia.Input.Platform） | Avalonia 跨平台剪贴板 API | 可用 |
| 7 | `Views\AiChatFloatingWindow.axaml.cs:334-338`（新） | `StorageProvider.OpenFilePickerAsync`（Avalonia.Platform.Storage） | Avalonia 跨平台文件选择 API | 可用 |
| 8 | `Views\AiChatFloatingWindow.axaml.cs`（对话框组） | `FAContentDialog.ShowAsync(TopLevel)`（FluentAvalonia） | FluentAvalonia 跨平台 API（宿主链传递，R-5 保留包） | 可用 |
| 9 | `Views\AiChatFloatingWindow.axaml:277-279`（新） | `mdxaml:MarkdownScrollViewer` | SDK 跨平台 API（ClassIsland.Markdown.Avalonia 12.0.0，宿主 Core 传递引用，无新包） | 可用（纯 Avalonia 渲染） |
| 10 | `Controls\Notifications\AiReplyNotificationContent.axaml.cs:64-77` | `ElementComposition`/`Compositor.CreateVector3DKeyFrameAnimation` | Avalonia 跨平台渲染组合 API | 可用（Skia/Metal 组合后端） |
| 11 | `Models\AiAttachment.cs:73`、`Services\AiAttachmentService.cs` | `Bitmap.DecodeToWidth`、`FilePickerOpenOptions`、UTF 编码校验 | Avalonia.Skia 跨平台 API + BCL | 可用 |
| 12 | `Services\AiConversationStore.cs:23-28` | `GlobalConstants.PluginConfigFolder ?? LocalApplicationData` 兜底 | BCL（`Environment.GetFolderPath` 三平台） | 可用（回退目录名已改 `SystemTools.CrossPlatform`，§3-4） |
| 13 | `Services\OpenAiCompatibleService.cs`（全文） | `HttpClient`/`SocketsHttpHandler` 语义、System.Text.Json | BCL | 可用 |
| 14 | `Services\SystemToolsNotificationProvider.cs:16-41` | `NotificationProviderBase`/`NotificationRequest`/`Channel()` | SDK 跨平台 API（ClassIsland 通知宿主 UI） | 可用（宿主通知面板为 Avalonia 界面） |
| 15 | `Services\VirtualAfterSchoolService.cs:20-118/:256-298` | `DispatcherTimer` + `ILessonsService`/`IExactTimeService` + 受限反射（PreMainTimerTicked/PostMainTimerTicked 事件转发） | SDK 跨平台 API（宿主核心服务）+ BCL 反射 | 可用（反射目标为宿主 SDK 类型，非平台 API） |
| 16 | `Services\ClassIslandActionAiService.cs`/`ClassIslandProfileAiService.cs` | SDK 自动化/档案服务 + System.Text.Json + 受限反射 | SDK 跨平台 API + BCL | 可用 |
| 17 | （删除）源 `AiChatFloatingWindow.axaml.cs:410-416` + `MainWindowBackgroundCaptureService.cs:141,250` | GDI 背景采样 + `BackgroundLuminanceCalculator` + `LiquidGlassBackdropFactory` + ThirdParty\LiquidGlassAvaloniaUI | **删除（按已批准降级口径 04-spec R-6/U5）** | 已消除：交付代码无此依赖点（非「不适用」阻塞项——该行记录的是被删除的源依赖，非本批新代码的外部依赖） |
| 18 | （删除）源 `AiChatFloatingWindow.axaml.cs:91/:105` 等 | `VoskSpeechService`（SAPI/Vosk 语音族）、`SpeechRecognitionDependencyPrompt` | **删除（04-spec S4.1/S7-R2：新插件无语音输入/唤醒）** | 已消除：同上，语音族整族不迁 |

**G1–G3 缺口语义核对（p0-01 §7）**：本批交付代码**不引用** `ISystemEventsService`（G1/G2）、`IDesktopService`（G3）、`IWindowPlatformService` 与 `ILauncherService`——三个缺口接口零暴露；唯一宿主平台抽象为 `IDesktopToastService`（三平台实装成立，含 macOS）。自检表无「不适用」判定，无阻塞项。

## 8. S4.2 扫描自检（p1-05 §5.2）

- 命令模板：`pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path <本批交付路径> -Scope Source`
- 覆盖 12 个目标：`Services\`（12 文件）、`Version\`、`Views\`、`Controls\Notifications\`、`Controls\AiAttachmentDrop*.axaml(.cs)` ×4、`Models\AiAttachment.cs`、`Models\AiConversation.cs`、增补后的共享文件 `ConfigHandlers\MainConfigData.cs`、`Shared\GlobalConstants.cs`。
- 结果：**12/12 全部 GateHits=0、CommentOnly=0、InfoHits=0，`VERDICT: PASS (zero gate hits)`，exit=0**。
- 原始输出留档：`.tang/cases/stcp-cross-platform-001/evidence/p1-04-s42-scan-output.txt`（含逐目标命令回显与 exit 码）。
- 注释清理（§5.2-2）：交付 .cs 中仅保留一条英文说明注释（TryPasteBitmapAsync 文本优先级行为，无禁用符号）；删除段注释仅存在于本证据文件与代码内无符号注记行。
- 边界说明：扫描 exit=0 为本批交付前置；Windows/Linux/macOS 三平台构建为阶段 1 出口门禁（§5.2-3），且依赖 §5 契约（p1-06 ViewModel/注册面）闭合后执行，本批不以扫描替代构建。

## 9. 边界声明

- 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` **全程只读**（复制抽取为只读读取 + 工作区写入）。
- 未改 `Plugin.cs`、`manifest.yml`、`SystemTools.CrossPlatform.csproj`、`global.json`、`SystemTools-Cross-platform.slnx`（本会话零写入）；未触碰 p1-01/p1-02/p1-03 已交付文件（除 §4 两处共享成员增补，均已在文件内注记）。
- 无平台分叉：零 `#if Platforms_*`、零平台 TFM/架构限定、零 Windows-only 资产（§5.1-2 阶段 1 规则）；抽取中未出现「必须平台分支才能编译」的 A 档文件（删除面均为已批降级/C 档内容）。
- 本文件不推进、不审批全局工作流；跨批事项（§4 增补追认、§5 契约）移交尚书省/礼部处置。

## 10. 复核指引（另一复核方最小命令集）

```powershell
# 1) 落点树核对（23 个新文件应唯一归入 §1 表）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -File | ? FullName -notmatch '\\(bin|obj)\\'
# 2) 命名空间核对（预期零命中）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Select-String -Pattern 'namespace (?!SystemTools\.CrossPlatform)'
# 3) 禁止 using（预期仅 SystemTools.CrossPlatform.* 形态）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Select-String -Pattern 'using SystemTools\.'
# 4) 不迁面残留核对（预期零命中）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Include *.cs,*.axaml | Select-String -Pattern 'Vosk|LiquidGlass|AiChatGlassSurface|BackgroundCapture|BackgroundLuminance|VoiceInput|IsVoiceInputActive|systemtools\.settings\.about'
# 5) 门禁重放
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Services -Scope Source   # 预期 PASS exit=0
# 6) GUID 零重合（预期零命中）
Get-ChildItem src\SystemTools.CrossPlatform\Services -Filter *.cs | Select-String -Pattern '7E9A3D5C|6F8C2B4A|7D7EFBF1'
```
