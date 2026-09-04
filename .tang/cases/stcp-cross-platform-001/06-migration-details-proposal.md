# 06 迁移细节与迁移预备提案

## 文档状态与用户边界

- 本文件是面向用户审阅、用于决定是否开工的迁移决策材料；内容整合 02 v2、04-spec 与 05 规划，尚未实施。
- 本次仅敲定可迁移功能、需改动的迁移细节及开工前预备；在用户提供全套细节并明确批准前，不创建工程、不抽取源码、不改代码、不跑实施构建、不派六部。
- 05-phased-development.md 仅作为阶段规划文本保留，不表示阶段 0–4 已开工。

## 总览与计数口径

- 目标平台：Windows、Linux（宿主仅支持 X11）、macOS 三平台并存；原 `SystemTools` 继续独立维护。
- 新插件 `SystemTools-Cross-platform` 仅纳入 A+B 档；C 档 46 项留在原插件。
- 总计：A 档 33 项 + B 档 19 项 + C 档 46 项 = 98 个去重功能项。
- 行动映射：源 `Actions\*.cs` 共 62 个文件 → 61 个活动功能项；`ClickSimulationAction.cs` 整文件注释、未编译且未注册，作为死代码注记，不计功能项；行动分档为 A15+B14+C32。
- 并存约束：新插件使用独立 manifest `id`、独立功能 ID 前缀和全新配置命名空间，不与原插件冲突；三平台 `supportedOSPlatforms` 与 U3 API 基线要求属于开工前置核对项。

## A 档直接迁移清单（一）：主题与组件

> A 档判定口径：以下条目按 `02-draft-solution.md` 的全源码路径结论拟纳入新插件；实现前仍须按 `04-spec.md` S4.2 对实际纳入文件执行静态门禁。所列证据未出现 `Windows.Win32`/`PInvoke.*`、`System.Windows.Forms`、`Microsoft.Win32`、`System.Management`、`System.Speech`、WinRT `Windows.Media.*`/`Windows.Security.*`、相关 `DllImport`/Windows 专属进程/包。

### 主题（3 项）

1. **Card-type Component 主题**
   - 源证据：`Themes/CardTypeComponent/Theme.axaml.txt:1-8`（Avalonia `Styles` 与 ClassIsland 控件/转换器资源）；配套 `Themes/CardTypeComponent/CardTypeComponentStyles.cs:10`（Avalonia `Styles` 类型）。
   - 关键依赖：Avalonia XAML、ClassIsland 控件/转换器与资源系统。
   - S4.2 判定：证据路径为 Avalonia/ClassIsland 资源；按全路径核对无禁用 Windows 符号。
   - 拟纳入边界：纳入主题资源与样式，不纳入原插件 C 档功能或 Windows-only 工程属性。

2. **ClassWidgets 主题**
   - 源证据：`Themes/ClassWidgets/Styles.axaml:1-3`（Avalonia `Styles` 加载 `ClassWidgetsStyles`）；`Themes/ClassWidgets/ClassWidgetsStyles.cs:11`（Avalonia `Styles`）。
   - 关键依赖：Avalonia 样式资源与 ClassWidgets 自身样式类。
   - S4.2 判定：引用仅为 Avalonia/主题类型；按全路径核对无禁用 Windows 符号。
   - 拟纳入边界：纳入 ClassWidgets 样式资源及其构建资源，不带入 C 档服务依赖。

3. **Notch Style 主题**
   - 源证据：`Themes/NotchStyle/Styles.axaml:1-3`（Avalonia `Styles` 加载 `NotchStyleStyles`）；`Themes/NotchStyle/NotchStyleStyles.cs:10`（Avalonia `Styles`）。
   - 关键依赖：Avalonia 样式资源与 NotchStyle 样式类。
   - S4.2 判定：引用仅为 Avalonia/主题类型；按全路径核对无禁用 Windows 符号。
   - 拟纳入边界：纳入 Notch Style 样式资源，不包含显示器拓扑、截图或其他 C 档能力。

### 组件（6 项）

4. **网络延迟检测**
   - 源证据：`Controls/Components/NetworkStatusComponent.axaml.cs:1-10`（Avalonia、ClassIsland 控件属性、`HttpClient`、`System.Net.NetworkInformation.Ping`）；`:17-20`（组件注册）。
   - 关键依赖：Avalonia、ClassIsland `ComponentBase`/`ComponentInfo`、HTTP 与 .NET 网络 API。
   - S4.2 判定：全路径仅含 SDK/Avalonia/.NET 网络 API，无禁用 Windows 符号；Linux ICMP 权限差异属于运行文档注意事项，HTTP 模式仍可用。
   - 拟纳入边界：纳入组件与设置；实现期记录 Linux `cap_net_raw` 对 Ping 模式的限制，必要时采用 HTTP 检测，不扩展为平台原生探测。

5. **显示剪切板内容**
   - 源证据：`Controls/Components/ClipboardContentComponent.axaml.cs:1-10`（Avalonia Dispatcher、控件与 `Avalonia.Input.Platform`）；`:14-20`（组件注册与基类）。
   - 关键依赖：Avalonia `TopLevel.Clipboard`/`ClipboardExtensions.TryGetTextAsync`、ClassIsland `ComponentBase`、DispatcherTimer。
   - S4.2 判定：全路径使用 Avalonia 剪切板抽象与 .NET/组件 API，无 Win32、WinForms 或其他禁用符号。
   - 拟纳入边界：纳入文本剪切板读取与显示；仅保留文本能力，不引入 C 档剪贴板写入/输入注入路径。

6. **本地一言**
   - 源证据：`Controls/Components/LocalQuoteComponent.axaml.cs:1-18`（Avalonia 动画/控件、ClassIsland 服务、`System.IO` 文件 API）；`:23-29`（组件注册与基类）。
   - 关键依赖：Avalonia 动画与 Dispatcher、`ILessonsService`、.NET `File`/集合/文本 API。
   - S4.2 判定：全路径为 Avalonia、ClassIsland 服务和 .NET BCL，无禁用 Windows 符号。
   - 拟纳入边界：纳入本地文本读取、轮播和显示；配置文件路径遵循新插件独立配置边界。

7. **下节课是**
   - 源证据：`Controls/Components/NextClassDisplayComponent.axaml.cs:1-10`（ClassIsland 共享模型与 `ILessonsService`/`IProfileService`/`IExactTimeService`）；`:14-20`（组件注册与基类）。
   - 关键依赖：ClassIsland 课程、档案和精确时间抽象，Avalonia/组件基类。
   - S4.2 判定：全路径仅使用 ClassIsland/Avalonia/.NET 类型，无禁用 Windows 符号。
   - 拟纳入边界：纳入下一节课程计算和展示，不引入系统时钟/窗口/显示器平台服务。

8. **更好的轮播容器**
   - 源证据：`Controls/Components/BetterCarouselContainerComponent.axaml.cs:6-17`（Avalonia 动画/视觉树与 ClassIsland 服务/组件模型）；`:21-25`（容器注册、组件基类及 `IRulesetService`/`ILessonsService`）。
   - 关键依赖：Avalonia 动画、视觉树与控件；ClassIsland `IRulesetService`、`ILessonsService`、组件设置模型。
   - S4.2 判定：全路径使用 Avalonia/ClassIsland/.NET API，无禁用 Windows 符号。
   - 拟纳入边界：纳入容器轮播、显示时长和规则联动；不带入媒体播放规则 C 档实现。

9. **LED 文本仿真显示框**
   - 源证据：`Controls/Components/ScrollingTextComponent.axaml.cs:1-13`（Avalonia 画布/动画/Dispatcher、.NET 取消与任务 API）；`:17-23`（组件注册与 `ComponentBase`）。
   - 关键依赖：Avalonia 控件/动画/样式、Dispatcher、.NET `CancellationToken`/Task。
   - S4.2 判定：全路径仅为 Avalonia、ClassIsland 组件基类和 .NET BCL，无禁用 Windows 符号。
   - 拟纳入边界：纳入 LED 风格文本滚动和组件设置；不依赖屏幕截图、窗口枚举或其他 C 档显示能力。

## A 档直接迁移清单（二）：规则集与触发器

### 规则集（4 项）

10. **程序正在运行**
   - 源证据：`Rules/Handlers/ProcessRunningRuleHandler.cs:8-10`（规则处理入口与设置类型）；`:16-24`（规范化进程名并调用 `System.Diagnostics.Process.GetProcessesByName`）。
   - 关键依赖：.NET `System.Diagnostics.Process`、规则设置模型。
   - S4.2 判定：使用跨平台 .NET 进程 API；无 `Windows.Win32`/`PInvoke.*`、WinForms、注册表、WMI、WinRT、DllImport、Windows 专属进程或禁用包。
   - 拟纳入边界：纳入跨平台进程名匹配；保留非 Windows 上 `.exe` 后缀剥离与失败返回 false 的现有行为，不引入平台进程枚举扩展。

11. **正在使用某课程表**
   - 源证据：`Rules/Handlers/UsingClassPlanRuleHandler.cs:11-15`（规则设置与 GUID 解析）；`:19-25`（通过 `IProfileService` 查询课表并读取 `IsActivated`）。
   - 关键依赖：ClassIsland `IProfileService`、共享档案/课表模型、.NET `Guid`。
   - S4.2 判定：全路径仅使用 ClassIsland 服务/模型与 .NET API，无 S4.2 禁用符号。
   - 拟纳入边界：纳入当前档案课表激活状态判断；使用新插件独立功能注册与配置命名空间，不改变宿主档案语义。

12. **正在使用某时间表**
   - 源证据：`Rules/Handlers/UsingTimeLayoutRuleHandler.cs:11-15`（规则设置与 GUID 解析）；`:19-25`（通过 `IProfileService` 查询时间表并读取 `IsActivated`）。
   - 关键依赖：ClassIsland `IProfileService`、共享档案/时间表模型、.NET `Guid`。
   - S4.2 判定：全路径仅使用 ClassIsland 服务/模型与 .NET API，无 S4.2 禁用符号。
   - 拟纳入边界：纳入当前档案时间表激活状态判断；不引入系统时间/平台窗口或显示器 API。

13. **是否在某时间段**
   - 源证据：`Rules/Handlers/InTimePeriodRuleHandler.cs:11-15`（时间段设置解析）；`:20-26`（通过 `IExactTimeService` 获取本地时间并比较时间范围）。
   - 关键依赖：ClassIsland `IExactTimeService`、.NET `TimeSpan`/`DateTime`。
   - S4.2 判定：使用 ClassIsland 时间抽象与 .NET BCL；无 S4.2 禁用符号。现有 `DateTime.Now` 仅为宿主服务不可用时的 BCL 兜底，不构成 Windows 依赖。
   - 拟纳入边界：纳入跨午夜时间段判断与宿主精确时间服务；不扩展时区或平台时钟校准能力。

### 触发器（1 项）

14. **行动进行时**
   - 源证据：`Triggers/ActionInProgressTrigger.cs:1-10`（ClassIsland 自动化接口、`System.IO`、反射、JSON、定时器）；`:14-15`（触发器注册与配置类型）；`:25-40`（按程序集目录读取 `auto.json` 并以定时器检查）。
   - 关键依赖：ClassIsland `TriggerBase`/`TriggerInfo`，.NET `Path`、`Assembly`、`JsonSerializer`、`System.Timers.Timer`。
   - S4.2 判定：全路径为 ClassIsland 自动化 API 与 .NET BCL；不含 S4.2 禁用符号或 Windows 专属进程/包。
   - 拟纳入边界：纳入 `auto.json` 状态检查与行动进行时触发；配置文件位置须落在新插件独立目录/配置边界，不与原插件文件互写。

## A 档直接迁移清单（三）：行动 15 项（前 8 项）

15. **退出进程**
   - 源证据：`Actions/KillProcessAction.cs:15-16`（行动注册与类）；`:31-52`（进程名规范化、`Process.GetProcessesByName` 与 `Kill`）。
   - 关键依赖：.NET `System.Diagnostics.Process`、ClassIsland 自动化基类、日志与配置模型。
   - S4.2 判定：仅使用跨平台 .NET 进程 API；无 Windows.Win32/PInvoke、WinForms、注册表、WMI、WinRT、DllImport、Windows 专属进程或禁用包。
   - 拟纳入边界：纳入跨平台按进程名终止；保留 `.exe` 后缀剥离和逐进程失败记录行为，不引入 taskkill 等 Windows 命令。

16. **拉起自定义通知**
   - 源证据：`Actions/ShowToastAction.cs:11-12`（行动注册与类）；`:29-35`（调用 `PlatformServices.DesktopToastService.ShowToastAsync`）。
   - 关键依赖：ClassIsland `IDesktopToastService` 宿主抽象、自动化基类、日志。
   - S4.2 判定：通知通过宿主跨平台抽象实现，不含 S4.2 禁用符号；原行动显示名中的“Windows”字样属于旧文案，纳入时应按独立插件命名空间核对。
   - 拟纳入边界：纳入标题/正文/点击回调通知；不引入 Windows Toast 原生实现，失败继续记录日志并结束行动。

17. **切换悬浮窗配置方案**
   - 源证据：`Actions/ToggleFloatingWindowProfileAction.cs:17-18`（注册与类）；`:27-52`（获取 `FloatingWindowService`、指定方案或下一方案切换）。
   - 关键依赖：本插件悬浮窗配置管理器、ClassIsland 服务定位/通知模型、.NET 配置与并发集合。
   - S4.2 判定：该行动本身为配置状态切换，源证据不含禁用 Windows 符号；悬浮窗底层平台子特性按 B 档 R-3 单独处理，不改变此行动的 A 档主计数。
   - 拟纳入边界：纳入方案选择、可恢复快照和可选通知；配置使用新插件独立命名空间。

18. **切换悬浮窗主题**
   - 源证据：`Actions/SwitchFloatingWindowThemeAction.cs:15-16`（注册与类）；`:25-48`（读取配置并调用悬浮窗主题切换）。
   - 关键依赖：本插件悬浮窗主题配置、ClassIsland 配置/通知模型、.NET 并发集合。
   - S4.2 判定：源行动路径仅为配置与主题服务调用，无 S4.2 禁用符号；悬浮窗经典外观/层级的窗口平台细节仍由 B 档服务范围承担。
   - 拟纳入边界：纳入主题索引切换、指定主题、可恢复快照和可选通知；不纳入液态玻璃或背景采样 C 候选。

19. **后台播放音频**
   - 源证据：`Actions/BackgroundPlayAudioAction.cs:15-16`（注册与类）；`:29-42`、`:48-78`（文件存在检查、`IAudioService` 获取与 `PlayAudioAsync`）；`:81-95`（路径规范化）。
   - 关键依赖：ClassIsland `IAudioService`、.NET `File`/`FileStream`/Task；`:89-90` 仅为 `OperatingSystem.IsWindows()` 路径分支。
   - S4.2 判定：没有 S4.2 禁用 API、专属进程或禁用包；现有 Windows 守卫是允许注明的运行时分支，可保留或删除，不改变 A 档结论。
   - 拟纳入边界：纳入宿主音频服务播放和等待完成选项；不引入 NAudio.Wasapi、VoskWorker 或系统音量控制。

20. **行动流执行确认**
   - 源证据：`Actions/ActionFlowExecutionConfirmationAction.cs:18-22`（注册、类与依赖）；`:36-65`（确认结果、延迟与中断行动流）；`:68-75`（Avalonia UI 线程关闭对话框）。
   - 关键依赖：Avalonia、`FluentAvalonia.UI.Controls.FATaskDialog`、ClassIsland `IActionService`、.NET Task/CancellationToken。
   - S4.2 判定：文件使用 Avalonia/FluentAvalonia/ClassIsland/.NET；没有 `System.Windows.Forms` 残留，也没有其他禁用符号。
   - 拟纳入边界：纳入确认、延迟、取消和行动流中断 UI；不带入 Windows-only 对话框或输入模拟。

21. **触发指定触发器**
   - 源证据：`Actions/TriggerCustomTriggerAction.cs:13-15`（注册与类）；`:29-45`（程序集目录下写入 `auto.json` 的 JSON 配置）。
   - 关键依赖：ClassIsland 自动化基类、.NET `Path`/`Assembly`/`JsonSerializer`/异步文件 API。
   - S4.2 判定：仅使用 .NET 文件与 JSON API，无禁用 Windows 符号或专属进程。
   - 拟纳入边界：纳入指定触发器状态写入；路径改为新插件独立配置目录，不能与原插件 `auto.json` 互写。

22. **开关自动化**
   - 源证据：`Actions/ToggleWorkflowAction.cs:15-16`（注册与类）；`:34-39`（获取 `IAutomationService`）；`:49-79`（读取并更新 workflow 状态、保存配置）。
   - 关键依赖：ClassIsland `IAutomationService`/Workflow 模型、自动化基类、.NET 并发集合与日志。
   - S4.2 判定：全路径使用 ClassIsland 自动化服务和 .NET API，无 S4.2 禁用符号。
   - 拟纳入边界：纳入启用、禁用、切换、可恢复状态快照；使用新插件独立功能 ID 前缀，不改变宿主自动化数据语义。

23. **显示 AI 对话框（文本对话主功能）**
   - 源证据：`Actions/ShowAiChatDialogAction.cs:9-12`（注册、类与 `AiChatWindowService` 依赖）；`:14-18`（调用 `ShowAsync`）；`Services/OpenAiCompatibleService.cs:1-18`、`:29-50`（HTTP 客户端与 OpenAI-compatible API 请求）。
   - 关键依赖：Avalonia 对话窗口、ClassIsland 自动化 API、.NET `HttpClient`/JSON；AI 文本链服务（含窗口、会话、提示、附件与操作门控服务）。
   - S4.2 判定：文本对话路径使用 Avalonia、ClassIsland 和 .NET HTTP/JSON API，无 Windows-only API、进程或包；AI 浮窗自适应背景采样另按 U5/R-6 降级，不影响主行动 A 档。
   - 拟纳入边界：纳入文本聊天窗口、OpenAI-compatible HTTP 链路及会话能力；不纳入语音输入/唤醒，背景采样和液态玻璃为 C 候选。

24. **沉浸式时钟**
   - 源证据：`Actions/FullscreenClockAction.cs:10-11`（注册与类）；`:20-30`（以 `ProcessStartInfo`/`UseShellExecute=true` 打开 HTTPS URL）。
   - 关键依赖：.NET `System.Diagnostics.Process`、自动化基类。
   - S4.2 判定：使用 .NET ShellExecute 跨平台能力，不调用 Windows-only API 或专属命令；实现期可优先采用宿主 `ILauncherService`，但不得因此扩大范围。
   - 拟纳入边界：纳入打开沉浸式时钟 URL；保留失败日志/行动错误语义，不承担浏览器安装或系统默认浏览器配置。

25. **清除全部提醒**
   - 源证据：`Actions/ClearAllNotificationsAction.cs:14-15`（注册与类）；`:23-34`（获取 `INotificationHostService` 并反射调用 `CancelAllNotifications`）。
   - 关键依赖：ClassIsland `INotificationHostService`、.NET 反射与自动化 API。
   - S4.2 判定：无 Windows API、WinForms、注册表、WMI、WinRT、DllImport、Windows 进程或禁用包；反射调用是兼容性观察点，不是平台依赖。
   - 拟纳入边界：纳入宿主提醒清除与可选执行通知；实现期需验证宿主接口/成员兼容性并记录缺失成员时的可观察失败行为。

26. **加载临时课表**
   - 源证据：`Actions/LoadTemporaryClassPlanAction.cs:15-23`（注册、类与 `IProfileService`/`IExactTimeService`）；`:29-50`（查找课表、设置临时课表状态并保存档案）。
   - 关键依赖：ClassIsland `IProfileService`、`IExactTimeService`、课表模型与 .NET GUID/日期时间。
   - S4.2 判定：仅依赖 ClassIsland 服务/模型与 .NET BCL，无 S4.2 禁用符号。
   - 拟纳入边界：纳入临时课表设置、保存、可恢复快照和可选通知；不改变宿主课表数据结构。

27. **打开应用设置**
   - 源证据：`Actions/OpenAppSettingsAction.cs:14-20`（注册、类与 `IUriNavigationService`）；`:22-32`（导航到 `classisland://app/settings`）。
   - 关键依赖：ClassIsland `IUriNavigationService`、URI 与自动化 API。
   - S4.2 判定：使用宿主 URI 导航抽象，无 Windows-only API 或禁用包。
   - 拟纳入边界：纳入打开 ClassIsland 应用设置 URI；功能 ID 和配置按新插件独立命名，不修改宿主导航协议。

28. **打开档案编辑**
   - 源证据：`Actions/OpenProfileEditorAction.cs:14-20`（注册、类与 `IUriNavigationService`）；`:22-32`（导航到 `classisland://app/profile`）。
   - 关键依赖：ClassIsland URI 导航服务、URI 与自动化 API。
   - S4.2 判定：仅使用宿主跨平台导航与 .NET URI，无 S4.2 禁用符号。
   - 拟纳入边界：纳入打开档案编辑 URI 与可选通知；不复制或改造档案编辑页面。

29. **打开换课窗口**
   - 源证据：`Actions/OpenClassSwapWindowAction.cs:14-20`（注册、类与 `IUriNavigationService`）；`:22-32`（导航到 `classisland://app/class-swap`）。
   - 关键依赖：ClassIsland URI 导航服务、URI 与自动化 API。
   - S4.2 判定：使用宿主 URI 导航抽象，无 Windows-only API 或禁用包。
   - 拟纳入边界：纳入打开换课窗口 URI 与可选通知；不承担宿主换课业务逻辑迁移。

## A 档直接迁移清单（四）：服务与设置页（收尾 A 档）

30. **AI 文本对话链服务群**
   - 源证据：`Services/OpenAiCompatibleService.cs:18`（OpenAI-compatible 服务）；`:29-50`（.NET `HttpClient`/JSON 请求）；`Services/AiConversationStore.cs:12-29`（JSON 会话存储）；`Services/AiPromptService.cs:5-13`（提示服务）；`Services/AiAttachmentService.cs:18-23`（附件限制与加载入口）；`Services/AiChatOperationGate.cs:6-20`（并发操作门控）；`Services/ClassIslandActionAiService.cs:50-60`、`Services/ClassIslandProfileAiService.cs:50-59`（文本 AI 的宿主行动/档案工具契约）。
   - 关键依赖：.NET `HttpClient`、JSON、文件/文本 API；Avalonia 对话 UI；ClassIsland 自动化/档案服务抽象。
   - S4.2 判定：上述文本链源码路径仅使用 Avalonia、ClassIsland 与 .NET BCL/HTTP/JSON，不含 S4.2 禁用符号。`AiChatWindowService.cs:9-19` 当前构造还注入 `VoskSpeechService` 与 `MainWindowBackgroundCaptureService`，两者分别属于 C 档语音链与 U5 背景采样；A 档只纳入文本链及其 UI 主路径，必须将这两个 C 子依赖排除/降级，不能把整个当前依赖闭包直接宣称为 A。
   - 拟纳入边界：纳入文本请求、会话、提示、附件、操作门控、ClassIsland 行动/档案工具与对话窗口；不纳入 `System.Speech`/Vosk 语音输入或唤醒，不纳入 GDI 背景采样/液态玻璃；后两者按 C 档候选处理。

31. **虚拟放学**
   - 源证据：`Services/VirtualAfterSchoolService.cs:1-10`（Avalonia Dispatcher、ClassIsland 课程/时间服务、.NET 计时/反射）；`:14-23`（服务及 `DispatcherTimer`/`Stopwatch`）；`:33-45`（启动监视与配置监听）。
   - 关键依赖：Avalonia `DispatcherTimer`、ClassIsland `ILessonsService`/`IExactTimeService`、.NET `Stopwatch`/`DateTime`/配置属性。
   - S4.2 判定：全路径使用 Avalonia、ClassIsland 服务和 .NET BCL，无 Windows.Win32/PInvoke、WinForms、注册表、WMI、WinRT、DllImport、专属进程或禁用包。
   - 拟纳入边界：纳入软件时间/课程状态监视和虚拟放学状态；不引入系统关机、显示器或输入平台能力。

32. **版本检查与更新通知**
   - 源证据：`Version/VersionCheckService.cs:12-20`（版本检查服务与插件目录路径）；`:24-47`（版本 JSON 读写/比较）；`:68-80`（通过 `PlatformServices.DesktopToastService` 通知）。
   - 关键依赖：.NET `Path`/文件/JSON/日期时间；ClassIsland `IDesktopToastService` 宿主通知抽象；Avalonia UI Dispatcher。
   - S4.2 判定：源路径仅使用宿主通知抽象、Avalonia Dispatcher 和 .NET BCL，无 S4.2 禁用符号；版本文件位置需改用新插件独立目录，但这不改变 A 档平台结论。
   - 拟纳入边界：纳入首次安装/版本变化检测和跨平台桌面通知；通知失败保持日志/静默降级，不引入 Windows Toast 原生 API。

33. **六个设置页骨架**
   - 源证据：`SettingsPage/SystemToolsSettingsPage.axaml.cs:26-30`（主设置）；`SettingsPage/AiChatSettingsPage.axaml.cs:25-33`（AI 对话）；`SettingsPage/FloatingWindowEditorSettingsPage.axaml.cs:31-40`（悬浮窗编辑）；`SettingsPage/MoreFeaturesOptionsSettingsPage.axaml.cs:15-24`（更多功能选项）；`SettingsPage/AboutSettingsPage.axaml.cs:22-35`（关于）；`SettingsPage/PluginDebugSettingsPage.axaml.cs:14-34`（插件调试）。
   - 关键依赖：Avalonia 控件/输入/视觉树、FluentAvalonia 控件、ClassIsland `SettingsPageBase`/`SettingsPageInfo`；各页对应配置与服务模型。
   - S4.2 判定：六个页面的骨架与注册表面属于 Avalonia、FluentAvalonia、ClassIsland 和 .NET UI/API，可按 S4.1 作为 A 档"页面骨架"纳入；页面内嵌选项必须逐项遵循 A/B/C 分档，不能因骨架 A 而吸收禁用 Windows 依赖。特别是 `MoreFeaturesOptionsSettingsPage` 中自动主题/遮挡隐藏/内存自动清理按 B，U 盘自动打开按 C；AI 页语音/背景采样按 C/U5；悬浮窗页窗口平台与采样子特性按 B/C。
   - 拟纳入边界：纳入 6 页路由、基础布局、A 档设置控件及独立页面 ID；裁剪 C 档选项及其下载/原生依赖，保留 B 档选项的入口但由阶段性适配实现；配置、功能 ID 使用新插件独立命名空间。A 档计数只计页面骨架，不把页内 B/C 功能重复计数。

## B 档需改动迁移清单（一）：复制/移动/删除（R-1）

> B 档三元组格式：Windows 专属点（文件:行）→ 替换目标 → 降级行为。以下为迁移前设计细节，尚未实施。

34. **复制**
   - Windows 专属点：`Actions/CopyAction.cs:28-35` 初始化 `cmd.exe` 进程；`:96-109` 文件夹子路径调用 `robocopy.exe` 并按退出码判定失败。文件子路径 `:43-73` 使用 `File.Copy`，本身为 BCL。
   - 替换目标：文件夹子路径改为跨平台 .NET 递归复制，或由按 OS 选择的文件操作抽象承载；文件子路径继续使用 .NET BCL。不得让 `cmd.exe`/`robocopy.exe` 出现在三平台通用路径。
   - 降级行为：源路径不存在、目标不可创建、权限不足或递归复制失败时记录结构化错误并抛出行动错误，保持现有行动失败语义；不得静默报告成功。
   - 拟纳入边界：纳入文件和文件夹两种复制；保留目标目录/同名目录处理语义。仅替换 Windows 文件夹工具，不扩展为同步、权限复制或跨设备迁移产品。

35. **移动**
   - Windows 专属点：`Actions/MoveAction.cs:28-35` 初始化 `cmd.exe`；`:96-110` 文件夹子路径调用 `robocopy.exe /move`。文件子路径 `:43-73` 使用 `File.Move`，本身为 BCL。
   - 替换目标：文件夹子路径采用跨平台 .NET 递归移动，必要时由 per-OS 文件操作机制处理跨卷限制；文件子路径继续使用 .NET BCL。
   - 降级行为：源不存在、目标不可创建、跨卷/权限限制或递归移动失败时记录错误并抛出行动错误，保持当前失败可见性；不得将部分完成误报为完整成功。
   - 拟纳入边界：纳入文件和文件夹移动及现有同名目标处理；不承诺 Windows `robocopy` 的全部元数据复制语义，差异须在同装差异/平台说明中注明。

36. **删除**
   - Windows 专属点：`Actions/DeleteAction.cs:27-35` 初始化 `cmd.exe`；`:69-80` 文件夹子路径执行 `cmd /c rmdir /s /q` 并按退出码判定失败。文件子路径 `:41-59` 使用 `File.Delete`，本身为 BCL。
   - 替换目标：文件夹子路径改用跨平台 .NET 递归删除或按 OS 的目录删除机制；文件子路径继续使用 .NET BCL。路径参数必须保持非 shell 拼接的安全边界。
   - 降级行为：路径不存在、拒绝访问、文件锁定或递归删除失败时记录错误并抛出行动错误，保持现有行动错误语义；不能以"目标已不存在"以外的失败静默成功。
   - 拟纳入边界：纳入文件/文件夹删除及递归行为；不引入回收站、强制提权或平台专属安全绕过。

## B 档需改动迁移清单（二）：电源族 7 项（U4）

> 统一 U4 要求：每个电源行动进入执行前必须做 OS 能力/权限预检；Windows、Linux/X11、macOS 使用独立适配器或命令策略，禁止把命令存在当作成功。预检或执行失败时通过 `IDesktopToastService` 告知用户具体"不可用/权限不足/未执行"原因，记录日志并正常结束行动，不抛未处理异常；只有命令已接受且结果可确认时才报告成功。Linux 需记录 `systemd/logind` 与 polkit 要求，macOS 需记录 `osascript`/`pmset` 与授权要求。

37. **计时关机**
   - Windows 专属点：`Actions/ShutdownAction.cs:7` 引用 `System.Windows.Forms`；`:30-38` 启动 Windows `shutdown -s -t`；`:40-44` 用 `SendKeys.SendWait` 模拟确认。
   - 替换目标：删除 WinForms/SendKeys；由 `ISystemPowerService.ScheduleShutdown(seconds, showPrompt)` 选择 per-OS 实现。Windows 可调用 `shutdown.exe /s /t <seconds>`；Linux/X11 可用 `systemd-run --on-active=<seconds> systemctl poweroff`（或经 logind/polkit 的等价调度）；macOS 可用 `shutdown -h +<minutes>`，秒级设置需由适配器保留倒计时并在到点调用关机。
   - U4 降级：预检目标命令、logind/polkit 或 macOS 管理权限与 `showPrompt=false` 所需能力；任一检查失败通过 `IDesktopToastService` 通知"计时关机不可用/权限不足"，记录失败并正常返回，不发送未确认的成功通知、不抛未处理异常。`SendKeys` 不得作为跨平台确认手段。
   - 拟纳入边界：纳入秒数、提示开关和可取消计划；不承诺各 OS 相同的系统确认 UI。

38. **高级计时关机**
   - Windows 专属点：`Actions/AdvancedShutdownAction.cs:201-214` 以 `shutdown /a` 取消系统计划；`:388-405` 立即按钮以 `shutdown /s /t 0` 关机；`:25`/`:77-85` 以 `ClassIsland.Desktop` 进程名做 Windows 风格看门狗判断。
   - 替换目标：将系统计划、取消、倒计时和看门狗拆为 `ISystemPowerService` 与宿主生命周期抽象。Windows 使用 `shutdown.exe /s /t <seconds>`、`shutdown.exe /a`；Linux 使用 systemd/logind 的 scheduled job 或适配器保存 job id 并以 `systemctl poweroff`/取消 job；macOS 使用 `shutdown -h +<minutes>` 与 `shutdown -c`，立即关机走 `osascript`/`shutdown` 适配器。看门狗改用宿主生命周期事件，不检查固定 `.exe` 名称。
   - U4 降级：启动前预检调度、取消、立即关机权限及宿主生命周期订阅；倒计时 UI 可显示，但系统动作不可用时必须撤销本地计划、Toast 通知失败原因并回收窗口/定时器，正常返回；原 `TryAbortSystemShutdown` 的吞异常不能掩盖"未取消"。
   - 拟纳入边界：纳入高级倒计时、取消、延长、立即关机和窗口状态；不纳入固定 Windows 进程名或 Win32 电源权限。

39. **取消关机计划**
   - Windows 专属点：`Actions/CancelShutdownAction.cs:27-36` 启动 `shutdown` 并传 `/a` 取消 Windows 计划。
   - 替换目标：调用 `ISystemPowerService.CancelScheduledShutdown()`；Windows 使用 `shutdown.exe /a`；Linux 取消由适配器创建的 systemd/logind 任务并清理任务标识；macOS 使用 `shutdown -c` 或适配器记录的取消句柄。
   - U4 降级：先预检取消命令与当前用户权限，并区分"没有活动计划"和"取消失败"；通过 `IDesktopToastService` 告知取消结果，失败只记录并正常结束，不抛未处理异常或伪造"已取消"通知。
   - 拟纳入边界：纳入由本插件创建且可识别的计划取消；不承诺取消其他程序创建的不可见计划。

40. **锁定屏幕**
   - Windows 专属点：`Actions/LockScreenAction.cs:27-36` 启动 `rundll32.exe user32.dll,LockWorkStation`。
   - 替换目标：调用 `ISystemPowerService.LockSession()`；Windows 使用宿主平台锁屏抽象或 `rundll32.exe` 适配器；Linux/X11 优先 `loginctl lock-session`，必要时使用桌面环境锁屏命令并检查 logind/polkit；macOS 使用 `osascript` 触发系统锁屏快捷操作，要求辅助功能授权。
   - U4 降级：预检当前会话、`loginctl`/桌面锁屏命令或 macOS `osascript` 与辅助功能权限；失败时经 `IDesktopToastService` 通知"锁屏未执行"，记录原因并正常返回，不能抛未处理异常。成功判定以命令退出状态/宿主确认，不以进程启动即视为锁定。
   - 拟纳入边界：纳入当前用户会话锁定；不实现绕过登录、强制注销或锁屏策略修改。

41. **立即重启**
   - Windows 专属点：`Actions/ImmediateRestartAction.cs:16-17` P/Invoke `ntdll.dll!RtlAdjustPrivilege`；`:23-29` 调用 `PInvoke.ExitWindowsEx` 与 `Windows.Win32` 枚举。
   - 替换目标：移除 `DllImport`、`Windows.Win32` 和 `PInvoke`；调用 `ISystemPowerService.RestartNow()`。Windows 使用 `shutdown.exe /r /t 0`；Linux 使用 `systemctl reboot`（经 logind/polkit）；macOS 使用 `osascript -e 'tell application "System Events" to restart'` 或系统 `shutdown -r now`，由适配器选择并校验权限。
   - U4 降级：执行前探测命令可用性、当前会话和关机/重启权限；失败经 `IDesktopToastService` 告知"立即重启未执行"，记录错误并正常返回，不抛未处理异常；预检不得实际触发重启。
   - 拟纳入边界：纳入用户明确触发的立即重启；不带入 Windows 特权提升、未公开 API 或强制绕过策略。

42. **立即关机**
   - Windows 专属点：`Actions/ImmediateShutdownAction.cs:16-17` P/Invoke `ntdll.dll!RtlAdjustPrivilege`；`:23-29` 调用 `PInvoke.ExitWindowsEx` 与 `Windows.Win32` 枚举。
   - 替换目标：移除 `DllImport`、`Windows.Win32` 和 `PInvoke`；调用 `ISystemPowerService.ShutdownNow()`。Windows 使用 `shutdown.exe /s /t 0`；Linux 使用 `systemctl poweroff`（经 logind/polkit）；macOS 使用 `osascript -e 'tell application "System Events" to shut down'` 或 `shutdown -h now`，由适配器选择并校验权限。
   - U4 降级：预检命令、会话和关机权限；失败通过 `IDesktopToastService` 通知未执行并记录原因，正常返回且不抛未处理异常；命令启动但退出失败时同样不得发成功通知。
   - 拟纳入边界：纳入用户明确触发的立即关机；不纳入未公开 Windows 特权、Win32 P/Invoke 或策略规避。

43. **睡眠**
   - Windows 专属点：`Actions/SleepAction.cs:21-30` 启动 `rundll32.exe powrprof.dll,SetSuspendState 0,1,0`。
   - 替换目标：调用 `ISystemPowerService.Suspend()`；Windows 使用宿主电源抽象或 Windows 适配器；Linux 使用 `systemctl suspend`（经 logind/polkit）；macOS 使用 `pmset sleepnow`，检查执行权限与电源管理授权。
   - U4 降级：预检会话、电源状态、`systemctl`/logind/polkit 或 `pmset` 可用性；失败经 `IDesktopToastService` 告知睡眠不可用/权限不足，记录后正常返回，不抛未处理异常；以命令退出结果/宿主回执作为成功依据。
   - 拟纳入边界：纳入当前会话进入睡眠；不承诺阻止应用/系统策略拒绝睡眠，也不提供强制休眠或提权。

## B 档需改动迁移清单（三）：悬浮窗族（R-3）

> R-3 口径：悬浮窗的 Avalonia 窗口、无边框布局、拖拽、按钮编排、多方案配置和规则隐藏保留；层级设置改走 `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)`；低级鼠标钩子与 WinEvent 前台/重排响应明确降级；液态玻璃和自适应背景采样为 C 候选，不随 B 主功能迁入。

44. **显示悬浮窗**
   - Windows 专属点：`Services/FloatingWindowService.cs:21-26` 引用 `System.Runtime.InteropServices`、`Windows.Win32`、Windows 消息/句柄类型和 `System.Drawing.Rectangle`；窗口创建与 Avalonia 结构位于 `:445-479`，其中 `:450` 设置 `Topmost`，`:464-466` 注册跨平台 Pointer 事件。液态玻璃/背景捕获字段见 `:56-75`。
   - 替换目标：保留 Avalonia `Window`、无边框/透明/拖拽/按钮编排、配置方案和规则隐藏；移除窗口通用路径中的 Win32/句柄依赖，平台层仅通过 `IWindowPlatformService` 提供显示、位置约束和层级特性；液态玻璃与背景采样不在 B 实现。
   - 降级行为：若平台窗口服务不支持透明、置顶或位置约束，仍显示普通 Avalonia 悬浮窗，关闭对应视觉/层级增强并用 `IDesktopToastService` 或日志告知；若窗口创建失败，恢复配置状态并报告未显示，不抛未处理异常。
   - 拟纳入边界：纳入经典浮窗、拖拽、按钮、规则隐藏、多方案；不纳入液态玻璃、背景采样、低级鼠标钩子和 WinEvent 钩子。

45. **切换悬浮窗层级**
   - Windows 专属点：`Services/FloatingWindowService.cs:2288-2337` 通过 WinEvent 回调判断前台/重排并调用 `PInvoke.SetWindowPos`；服务头部 `:21-25` 引入 `Windows.Win32`，`ToggleFloatingWindowLayerAction.cs:46-57` 调用服务切换层级。
   - 替换目标：行动继续调用服务层，但服务改由 `IWindowPlatformService.SetWindowFeature(WindowFeature.Topmost/Bottommost)` 实现置顶/置底；前台/重排自动重检若宿主无等价跨平台事件则停用，保留 Avalonia `Topmost` 的基础 best-effort 状态。
   - 降级行为：先探测平台服务是否支持目标层级；不支持时保持普通层级并通过 `IDesktopToastService` 通知"层级增强不可用"，记录平台原因，不抛未处理异常、不宣称已置顶/置底。低级钩子、WinEvent 和 `SetWindowPos` 失败都进入同一路径。
   - 拟纳入边界：纳入 Topmost/Bottommost 两种显式层级和可恢复快照；不纳入跨桌面强制重排、WinEvent 前台监听或 HWND 操作。

46. **从悬浮窗触发**
   - Windows 专属点：本触发器注册与按钮点击逻辑在 `Triggers/FloatingWindowTrigger.cs:12-34`、`:46-62`，本身没有 Windows API；其服务依赖的 Windows 点在 `Services/FloatingWindowService.cs:2134-2240`（WinEvent/钩子安装）及 `:2288-2337`（回调和 `PInvoke.SetWindowPos`）。
   - 替换目标：保留 Avalonia Button 点击、按钮 ID 规范化、规则隐藏、行动/恢复触发；依赖的层级重检改走 `IWindowPlatformService`，不可用时关闭自动重检。按钮触发不应依赖低级鼠标钩子或 WinEvent。
   - 降级行为：平台事件服务不可用时，按钮仍可点击并触发工作流；仅禁用自动层级重检/前台响应，并通过日志或一次性 Toast 明示降级，不抛未处理异常。
   - 拟纳入边界：纳入悬浮窗按钮到工作流的触发和恢复语义；不纳入低级鼠标捕获、WinEvent 前台/重排响应、液态玻璃或背景采样。

## B 档需改动迁移清单（四）：主题、遮挡与内存清理

47. **自动切换 ClassIsland 主题**
   - Windows 专属点：`Services/AdaptiveThemeSyncService.cs:44` 以 `!OperatingSystem.IsWindows()` 直接限制功能；其实现依赖系统外观/主题检测，`Actions/AutoSwitchClassIslandThemeAction.cs:30-32` 写入配置并调用 `AdaptiveThemeSyncService.ApplyConfig()`。
   - 替换目标：保留"跟随系统主题"主配置和行动；由 `IThemePlatformService` 提供 per-OS 主题变化订阅/一次性查询。Windows 使用现有系统主题适配；Linux/X11 读取桌面主题设置或桌面环境约定；macOS 读取系统外观；无统一能力时使用手动/固定主题，不强行模拟系统主题。
   - 降级行为：主题探测不可用、权限不足或桌面环境无可识别设置时，停止自动同步、保持当前主题并通过 `IDesktopToastService` 通知"自动主题同步不可用"，记录原因，不抛未处理异常。不得把液态玻璃或背景采样当作主题同步的必要条件。
   - 拟纳入边界：纳入自动主题开关、当前主题同步和手动回退；不纳入自适应背景采样/液态玻璃，后者为 C 候选。

48. **遮挡文字时隐藏主界面**
   - Windows 专属点：`Services/MainWindowTextOcclusionService.cs:108-119` 明确仅 Windows 启动 OCR，并在无本地 OCR 语言时回退显示主界面；`:122-125` 启动连续背景捕获；`Actions/AutoHideMainWindowWhenOccludedAction.cs:30-32` 开关该服务。
   - 替换目标：保留规则/开关和"检测到文字则隐藏"语义；将 OCR 与背景捕获抽象为 `ITextOcclusionDetectionService`。Windows 可继续使用本地 OCR；Linux/X11、macOS 仅在存在明确可用的跨平台 OCR/捕获后端时启用，否则关闭检测并保持主界面可见。背景捕获/自适应采样不作为 A/B 必须能力。
   - 降级行为：启动前预检 OCR 语言、屏幕捕获权限和后端；任何不可用或检测异常都恢复主界面可见，通过 `IDesktopToastService` 告知"遮挡检测已降级/未启用"，记录后续重试，不抛未处理异常，不将未知状态解释为应隐藏。
   - 拟纳入边界：纳入跨平台可验证后端存在时的遮挡检测与主界面显隐；Windows-only OCR、连续采样和低层捕获不外溢到无后端平台，液态玻璃/自适应背景为 C 候选。

49. **ClassIsland 内存自动清理**
   - Windows 专属点：`Services/ClassIslandMemoryAutoCleanupService.cs:22-23` P/Invoke `psapi.dll!EmptyWorkingSet`；`:96-99` 仅 Windows 执行；`:103-120` 读取进程私有内存、GC 后调用 `EmptyWorkingSet`。
   - 替换目标：保留跨平台托管 GC 的低风险部分（按阈值测量并执行受控 `GC.Collect`）；将工作集压缩抽象为可选 `IProcessMemoryMaintenanceService`。Windows 可有权限校验的工作集适配器；Linux/macOS 默认不执行等价强制工作集清理，除非存在受支持且安全的宿主 API。
   - 降级行为：预检平台能力、进程句柄/权限和资源阈值；不可用时只跳过工作集操作并保留 GC/测量，或完全跳过并通过 `IDesktopToastService` 通知"系统工作集清理不可用"，记录指标后正常返回，不抛未处理异常。不得用 shell、提权或未公开 API 绕过权限。
   - 拟纳入边界：纳入 ClassIsland 托管内存阈值监测、GC 清理和可选平台工作集维护；不纳入 `SystemMemoryCleanupService` 的系统级清理，也不把 Windows `psapi.dll` 方案复制到 Linux/macOS。

## C 档不迁移清单（一）：输入模拟组（共 8 项功能口径）

50. **常用模拟键：Alt+F4 / Alt+Tab / Ctrl+Z / Enter / Esc / F11（合并计 1 组，6 个行动映射）**
   - 源文件/关键依赖：`Actions/AltF4Action.cs:26-40`、`AltTabAction.cs:26-39`、`CtrlZAction.cs:26-39`、`EnterKeyAction.cs:25-32`、`EscAction.cs:24-27` 均调用 `Windows.Win32.PInvoke.keybd_event`；F11 位于 `Actions/BlackScreenHtmlAction.cs:64-67`。
   - C 档理由：依赖 Win32 键盘注入和 Windows 虚拟键码/消息模型；Linux X11 即使可用 XTest 也受会话、桌面和权限限制，macOS 需辅助功能授权，无法保持"对当前前台窗口发送系统组合键"的统一语义。本期不迁移；6 个动作仍留在原插件，计数按 1 个常用模拟键组处理，映射表保留 6 个源文件。

51. **模拟键盘**
   - 源文件/关键依赖：`Actions/SimulateKeyboardAction.cs:11` 引入 `Windows.Win32`，动作主体从 `:32` 起按录制键序列注入；底层 `PInvoke.keybd_event` 调用在同文件后段。
   - C 档理由：录制键序列依赖 Windows 虚拟键码与全局输入注入；跨平台需要重新定义键码映射、按键状态、权限和桌面会话策略，非单点替换。本期留原插件。

52. **模拟组合键**
   - 源文件/关键依赖：`Actions/SimulateKeyCombinationAction.cs:12-13` 使用 `Windows.Win32` 键盘 API；`:46-50` 调用 `PInvoke.keybd_event` 并维护按键释放状态。
   - C 档理由：组合键同时按下/释放的顺序、系统快捷键拦截和安全权限均绑定 Windows 注入模型；X11/macOS 没有本期可复用的统一宿主能力，保留原插件。

53. **模拟鼠标**
   - 源文件/关键依赖：`Actions/SimulateMouseAction.cs:7,13` 使用 `System.Runtime.InteropServices` 与 `Windows.Win32`；动作包含全局坐标、按钮/滚轮注入（同文件 `:25` 起）。
   - C 档理由：全局鼠标注入依赖 user32/Win32 坐标和事件模型；X11/macOS 均受显示服务器、辅助功能或桌面权限约束，坐标/多屏语义不一致，本期不迁移。`ClickSimulationAction.cs` 为整文件注释死代码，仍不计功能项。

54. **键入内容**
   - 源文件/关键依赖：`Actions/TypeContentAction.cs:35-45` 先写系统剪贴板，再用 `PInvoke.keybd_event` 注入 Ctrl+V；文件头 `:11-12` 为 `Windows.Win32`。
   - C 档理由：同时依赖系统剪贴板写入和全局键盘注入，需处理当前会话、目标控件和 macOS 辅助功能/X11 剪贴板差异；不是纯 Avalonia/.NET 行为，留原插件。

55. **窗口操作**
   - 源文件/关键依赖：`Actions/WindowOperationAction.cs:11` 使用 `Windows.Win32`；`:26-35` 通过 `PInvoke.GetForegroundWindow` 获取活动窗口并对 HWND 操作。
   - C 档理由：前台窗口句柄、枚举、激活/最小化/移动等操作是 Win32 HWND 语义；Linux X11/Wayland 和 macOS 窗口服务器权限、句柄模型不同，无法按本期 B 档单点替换，保留原插件。

56. **禁用鼠标**
   - 源文件/关键依赖：`Actions/DisableMouseAction.cs:29-49` 启动插件目录下 `jinyongshubiao.bat`；配置控件还依赖低级 `SetWindowsHookEx`（`Controls/SimulateMouseSettingsControl.cs:161-163`）。
   - C 档理由：批处理与全局鼠标/键盘钩子均为 Windows 专属；Linux 需 XInput/udev/桌面策略，macOS 需辅助功能，且"禁用设备"与"拦截输入"可能代表不同语义。本期不迁移。

57. **启用鼠标**
   - 源文件/关键依赖：`Actions/EnableMouseAction.cs:29-49` 启动 `huifu.bat`；对应恢复路径与输入钩子状态同属 Windows 实现。
   - C 档理由：依赖 Windows 批处理和全局钩子生命周期，其他平台没有统一、可逆且不提权的对应接口；与禁用鼠标成对留在原插件。

> 计数说明：本组按 8 个功能项计（常用模拟键 6 个动作合并为 1 组 + 模拟键盘 + 组合键 + 鼠标 + 键入 + 窗口操作 + 禁用鼠标 + 启用鼠标），与 02 v2 的 C 行动映射保持一致；`ClickSimulationAction.cs` 仅作死代码映射注记。

## C 档不迁移清单（二）：显示/桌面组（7 项）

58. **复制屏幕**
   - 源文件/关键依赖：`Actions/CloneDisplayAction.cs:30-53` 启动 `DisplaySwitch.exe`（Windows 显示拓扑切换工具）。
   - C 档理由：复制显示器涉及 Windows `SetDisplayConfig`/DisplaySwitch 拓扑语义；Linux X11/Wayland 与 macOS 的显示排列、镜像策略和权限接口不同，不能保证同一结果，留在原插件。

59. **扩展屏幕**
   - 源文件/关键依赖：`Actions/ExtendDisplayAction.cs:30-53` 启动 `DisplaySwitch.exe`。
   - C 档理由：依赖 Windows 显示拓扑和显示输出编号；其他平台需要 xrandr/Wayland compositor 或 macOS 显示管理 API，设备标识与行为不统一，不属本期简单迁移。

60. **仅电脑屏幕**
   - 源文件/关键依赖：`Actions/InternalDisplayAction.cs:30-53` 启动 `DisplaySwitch.exe`。
   - C 档理由：关闭外接显示器并保留内部屏幕是 Windows 显示策略语义；Linux/macOS 的"内部屏幕"识别和禁用输出接口各异，且 Wayland/系统权限限制明显，留原插件。

61. **仅第二屏幕**
   - 源文件/关键依赖：`Actions/ExternalDisplayAction.cs:30-53` 启动 `DisplaySwitch.exe`。
   - C 档理由：依赖 Windows 对第二显示输出的固定拓扑选择；其他平台不存在稳定的"第二屏幕"语义和统一命令，需独立显示管理适配，不在本期迁移。

62. **黑屏 html**
   - 源文件/关键依赖：`Actions/BlackScreenHtmlAction.cs:45-55` 通过 `cmd /c start` 打开 `black.html`；`:64-67` 使用 `Windows.Win32.PInvoke.keybd_event` 注入 F11 全屏。
   - C 档理由：浏览器启动依赖 Windows `cmd/start`，全屏依赖 Win32 键盘注入和浏览器焦点；Linux/macOS 默认浏览器、全屏策略与辅助功能权限不同，无法保持可靠"打开后自动全屏黑屏"语义，留原插件。

63. **显示桌面**
   - 源文件/关键依赖：`Actions/ShowDesktopAction.cs:10-11` 使用 `Windows.Win32`；`:29-39` 注入 Win+D。
   - C 档理由：Win+D 是 Windows Shell 快捷键，Linux 各桌面环境和 macOS Mission Control 没有统一等价行为；全局快捷键还受会话权限影响，本期不迁移。

64. **调整屏幕亮度**
   - 源文件/关键依赖：`Actions/AdjustScreenBrightnessAction.cs:69-98` 使用 `System.Management` WMI `WmiMonitorBrightnessMethods.WmiSetBrightness`；文件中存在 `ManagementObjectSearcher`/`ManagementException` 等 WMI 依赖。
   - C 档理由：WMI 仅 Windows；Linux 需 `/sys/class/backlight`、桌面/显示器 DDC/设备权限，macOS 需系统私有或显示器控制接口，内置屏幕与外接屏语义也不同，需独立硬件适配和权限设计，留在原插件。

## C 档不迁移清单（三）：系统个性化组 + 硬件设备组（7 项）

65. **切换壁纸**
   - 源文件/关键依赖：`Actions/ChangeWallpaperAction.cs:4` 使用 `Microsoft.Win32` 注册表；`:160-180` 使用 `Windows.Win32.PInvoke.SystemParametersInfo(SPI_SETDESKWALLPAPER)`。
   - C 档理由：同时绑定 Windows 注册表壁纸配置和 Win32 `SystemParametersInfo` 广播；Linux 需桌面环境/DBus 方案，macOS 需 NSWorkspace 或脚本，文件布局、轮换和刷新语义不统一，需独立平台个性化项目，本期留原插件。

66. **切换主题色**
   - 源文件/关键依赖：`Actions/SwitchThemeAction.cs:4` 引用 `Microsoft.Win32`；`:30-32` 写入 `HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize\\AppsUseLightTheme`。
   - C 档理由：Windows 注册表值只表达 Windows 应用浅/深色偏好；Linux 各桌面环境主题设置和 macOS 外观 API 不同，且目标不是插件自身主题而是系统外观，无法保持同一系统级语义，留原插件。

67. **切换系统强调色**
   - 源文件/关键依赖：`Actions/SwitchSystemAccentColorAction.cs:19-24` P/Invoke `user32.dll!SendMessageTimeout`；`:36-47` 写入 Windows DWM/Explorer 注册表并广播 `WM_SETTINGCHANGE`。
   - C 档理由：依赖 Windows DWM/Explorer 注册表和 user32 设置变更消息；Linux/macOS 的强调色配置、刷新广播和窗口装饰模型不对等，需按桌面环境分别实现，不属于本期迁移。

68. **禁用硬件设备**
   - 源文件/关键依赖：`Actions/DisableDeviceAction.cs:38-70` 动态生成 `.bat/.ps1`，通过 `powershell.exe` 管理权限并调用 `Get-PnpDevice`/`Disable-PnpDevice`。
   - C 档理由：依赖 Windows PnP 设备实例 ID、PowerShell cmdlet 和 UAC 管理员提权；Linux 需 udev/sysfs/驱动解绑，macOS 需 IOKit，设备状态/权限/恢复语义均不同，不能按单一跨平台替代，留原插件。

69. **启用硬件设备**
   - 源文件/关键依赖：`Actions/EnableDeviceAction.cs:38-70` 动态生成批处理与 PowerShell，通过 `Get-PnpDevice`/`Enable-PnpDevice` 恢复设备。
   - C 档理由：与禁用配对依赖 Windows PnP、PowerShell 和 UAC；其他平台没有统一、可逆且不破坏驱动状态的启用接口，需要独立设备管理适配与权限设计，本期不迁移。

70. **U 盘插入自动打开**
   - 源文件/关键依赖：`Services/UsbAutoPlayService.cs:5` 使用 `System.Management`；`:28-31` 仅 Windows；`:47-50` 监听 WMI `Win32_VolumeChangeEvent`；`:75-85` 识别可移动盘并以 shell 打开盘符。开关行动为 `Actions/AutoOpenUsbDriveOnInsertAction.cs:30-32`。
   - C 档理由：依赖 WMI 卷事件、Windows 盘符/DriveInfo 和 shell 打开盘符；Linux 需 udev/udisks/桌面文件管理器，macOS 需 Disk Arbitration/NSWorkspace，自动打开策略和权限/安全提示不一致，留在原插件。

71. **USB 设备插入触发器**
   - 源文件/关键依赖：`Triggers/UsbDeviceTrigger.cs:205-228` 创建 WinForms `NativeWindow` 并调用 `RegisterDeviceNotification`；`:245-264` 处理 `WM_DEVICECHANGE`/`DBT_DEVICEARRIVAL`，使用 user32 DllImport。
   - C 档理由：依赖 Windows 消息窗口、设备广播结构和 user32 设备通知；Linux 需 udev monitor，macOS 需 IOKit notifications，设备筛选、生命周期与会话权限模型不等价，需独立硬件事件项目，本期不迁移。

> 计数说明：本子节 7 项，系统个性化 3 + 硬件设备 4；与 02 v2 §4.3-§4.4 和总表一致。

## C 档不迁移清单（四）：窗口/屏幕/全局钩子组 + 语音 AI 语音组（8 项）

72. **点击主界面触发器**
   - 源文件/关键依赖：`Services/MainWindowClickService.cs:59-71` 通过 `SetWindowsHookEx(WH_MOUSE_LL)` 安装全局低级鼠标钩子；`:85-117` 依据全局坐标判断主界面区域并触发事件；底层声明为 `user32.dll` DllImport（`:145-153`）。
   - C 档理由：依赖 Windows 全局鼠标钩子、user32 消息和屏幕像素坐标；Linux X11/Wayland 与 macOS 的全局监听权限、窗口区域获取和事件注入模型不一致，无法保持稳定的"点击主界面"系统级语义，本期留在原插件。

73. **全局热键触发器**
   - 源文件/关键依赖：`Services/HotkeyService.cs:7-10` 引用 `System.Windows.Forms` 与 `Windows.Win32`；`:64-73` 创建 WinForms `NativeWindow` 并调用 `PInvoke.RegisterHotKey`，`:96-109` 调用 `UnregisterHotKey`。
   - C 档理由：依赖 Windows 消息窗口、虚拟键码和 user32 `RegisterHotKey`；Linux 需要 X11/桌面环境专用注册机制（Wayland 通常受 compositor 限制），macOS 需全局事件/辅助功能授权，跨平台权限和冲突语义不统一，本期不迁移。

74. **长时空闲触发器**
   - 源文件/关键依赖：`Triggers/LongIdleTrigger.cs:76-92` 读取 `LASTINPUTINFO` 并计算空闲时长；`:102-104` 通过 `LibraryImport("user32.dll")` 调用 `GetLastInputInfo`。
   - C 档理由：`GetLastInputInfo` 只提供 Windows 会话级输入空闲计时；Linux 需 XScreenSaver/桌面或 logind 接口，Wayland 与不同 DE 能力不一致，macOS 需 IOKit/Quartz 事件权限，无法形成本期统一行为，留在原插件。

75. **音乐软件歌词显示**
   - 源文件/关键依赖：`Controls/Components/LyricsDisplayComponent.axaml.cs:124-136` 使用 `FindWindow`/`SetWindowPos(HWND_BOTTOM)`；`:144-187` 使用 `FindWindow`、`GetWindowRect`、GDI `Graphics` 与 `PrintWindow` 抓取目标窗口；`:227-233` 使用 `EnumWindows`；媒体播放源还依赖 `Rules/Handlers/MediaMusicPlayingRuleHandler.cs:3,27-35` 的 WinRT `Windows.Media.Control`（SMTC）。
   - C 档理由：同时绑定 HWND 窗口枚举/层级、GDI 窗口捕获和 Windows SMTC 媒体会话；Linux 需按 X11/Wayland/MPRIS 分叉，macOS 需窗口捕获与 Now Playing 能力，目标软件句柄、截图权限和音乐源语义都不等价，需独立媒体/窗口适配项目，本期留原插件。

76. **关键词触发器（SAPI）【立项候选】**
   - 源文件/关键依赖：`Triggers/KeywordTrigger.cs:35-41` 向 `KeywordSpeechService` 注册关键词；`Services/KeywordSpeechService.cs:5,17-18` 使用 `System.Speech.Recognition.SpeechRecognitionEngine`（SAPI），`:131-143` 也明确非 Windows 语音输入不可用。
   - C 档理由：关键词识别依赖 Windows SAPI/System.Speech 的识别引擎、线程和系统语音包；Linux/macOS 需替换为独立音频采集、识别引擎、模型和麦克风权限链，不能作为普通宿主抽象替换。语音链路属于独立子项目级工作量，标记为"立项候选"，留在原插件。

77. **AI 语音输入（VoskWorker）【立项候选】**
   - 源文件/关键依赖：`Services/VoskSpeechService.cs:104-115,154-163` 对非 Windows 直接报告"语音输入仅支持 Windows 麦克风"；`Services/VoskSpeechService.cs:518` 起启动外部工作进程；`Shared/DependencyPaths.cs:84-107,128-161` 固定查找 win-x64 自包含 `SystemTools.VoskWorker.exe`；VoskWorker 音频后端依赖 `NAudio.Wasapi`。
   - C 档理由：现有链路绑定 Windows 麦克风捕获、win-x64 worker 和 WASAPI/NAudio；跨平台需改造 PortAudio/ALSA/PipeWire/CoreAudio 捕获、重编译 worker 与原生依赖，并设计 per-OS 模型/权限/下载布局，属独立立项而非本期迁移。标记"立项候选"。

78. **启用语音唤醒【立项候选】**
   - 源文件/关键依赖：`Actions/EnableVoiceWakeAiAction.cs:30-46` 修改启用配置并调用 `AiVoiceConversationService.ApplyConfig()`；该服务依赖 `KeywordSpeechService`/`VoskSpeechService`，语音唤醒状态由现有 Windows 语音链路提供。
   - C 档理由：行动本身是配置开关，但其可用性、唤醒词监听和失败状态完全建立在 SAPI/VoskWorker 的 Windows 专属语音捕获链上；跨平台必须先完成独立语音引擎、后台监听、麦克风权限和模型分发设计，本期不迁移，标记"立项候选"。

79. **唤醒语音对话【立项候选】**
   - 源文件/关键依赖：`Actions/WakeUpVoiceConversationAiAction.cs:9-20` 调用注入的 `AiVoiceConversationService.TryStartVoiceConversation()`；该服务在 `Services/AiVoiceConversationService.cs:32-33,576` 使用 `KeywordSpeechService` 与 `VoskSpeechService.TryAcquireConversationAsync`。
   - C 档理由：唤醒语音对话依赖持续唤醒监听、麦克风独占/会话捕获、SAPI/VoskWorker 和 Windows 音频权限；Linux/macOS 需重新定义音频会话、后台权限、设备占用和模型运行时，不能脱离语音链路单独迁移，标记"立项候选"，留在原插件。

> 计数说明：本子节 8 项，窗口/屏幕/全局钩子 4 项 + 语音 AI 语音 4 项；编号 72–79，与 02 v2 §4.5–§4.6 的功能口径一致。语音组四项统一标记"立项候选"。

## C 档不迁移清单（五）：认证、截图音量、系统内存、摄像头依赖与管理员重启（8 项功能口径）

80. **人脸识别验证器（服务与验证器合并计 1 项）**
   - 源文件/关键依赖：`Services/FaceRecognitionService.cs:1-5,20-23,39-49` 使用 `DlibDotNet`/`DlibDotNet.Dnn` 原生模型；`Controls/FaceRecognitionAuthorizer.axaml.cs:69-79,106-117` 创建该服务并启动摄像头验证；`Plugin.cs:158` 注册 `FaceRecognitionAuthorizer`。
   - C 档理由：人脸验证同时绑定 DlibDotNet、OpenCvSharp Windows 原生运行时、摄像头采集和模型文件布局，现有服务与 `FaceRecognitionAuthorizer` 是同一认证能力的服务/界面组成，不重复计数。Linux/macOS 需重选视觉/摄像头后端、原生包、模型分发和隐私权限，超出本期迁移范围，留在原插件。

81. **Windows Hello 验证器（服务与验证器合并计 1 项）**
   - 源文件/关键依赖：`Services/WindowsHelloService.cs:6` 使用 `Windows.Security.Credentials.UI`；`:35-47` 调用 `UserConsentVerifier.CheckAvailabilityAsync`；`:158-161` 使用 `winbio.dll` `WinBioGetEnrolledFactors`；`Controls/WindowsHelloAuthorizer.axaml.cs:158-162` 发起窗口绑定验证。
   - C 档理由：依赖 Windows Hello/WinRT、Windows 生物识别服务和 Windows 安全窗口句柄；Linux/macOS 没有同一系统认证提供者、注册状态和授权界面，需宿主认证体系或各平台安全 API 的独立设计。本项服务与验证器合并只计 1 项，留在原插件。

82. **屏幕截图【立项候选】**
   - 源文件/关键依赖：`Actions/ScreenShotAction.cs:6` 引用 `System.Windows.Forms`；`:43-54` 使用 `Screen.PrimaryScreen`、`System.Drawing.Graphics.CopyFromScreen` 保存 PNG。
   - C 档理由：依赖 WinForms 屏幕枚举和 GDI 屏幕复制；Linux X11/Wayland 与 macOS 的屏幕捕获权限、合成器接口、多屏坐标及图像格式流程不同，需独立 per-OS 捕获后端和权限 UX，标记"立项候选"，本期留原插件。

83. **设置系统音量【立项候选】**
   - 源文件/关键依赖：`Actions/SetVolume.cs:25-29` 调用 `MMDeviceEnumeratorWrapper` 与 `SetMasterVolumeLevelScalar`；`:47-126` 定义 Windows Core Audio COM `IMMDevice`/`IAudioEndpointVolume`，并在 `:9-11` 使用互操作依赖。
   - C 档理由：依赖 Windows Core Audio 的 COM 设备枚举和主音量接口；Linux 需 PipeWire/PulseAudio/ALSA 分叉及会话权限，macOS 需 CoreAudio/系统脚本及设备选择策略，不能保持一个统一且安全的实现，标记"立项候选"，留在原插件。

84. **系统内存清理**
   - 源文件/关键依赖：`Services/SystemMemoryCleanupService.cs:600-645` 调用 `kernel32.dll`、`advapi32.dll`、`ntdll.dll!NtSetSystemInformation`；执行路径 `:385-413` 操作系统内存列表、文件缓存和注册表协调，并涉及管理员权限。
   - C 档理由：这是 Windows 内核级全局内存回收而非普通 GC；Linux/macOS 没有对等的 `NtSetSystemInformation` 语义和权限模型，贸然替换会改变功能含义和系统风险，本期不迁移。

85. **摄像头抓拍**
   - 源文件/关键依赖：`Actions/CameraCaptureAction.cs:48-64` 固定查找 `DependencyPaths.GetFfmpegPath()`，要求 `ffmpeg.exe`，并用 `-f dshow -i video=...` DirectShow 参数采集；工程依赖 `OpenCvSharp4.runtime.win` 还服务于相关摄像头/人脸链路。
   - C 档理由：FFmpeg 编解码器本身可跨平台，但当前输入参数是 Windows DirectShow，依赖路径是 Windows 可执行文件，摄像头设备枚举和权限也按 OS 分裂；Linux 需 v4l2、macOS 需 avfoundation，并需独立设备选择/权限/打包方案，本期留原插件。

86. **C 档依赖下载管理（FFmpeg / 人脸模型 / VoskWorker / 语音模型）**
   - 源文件/关键依赖：`Shared/DependencyPaths.cs:43,80-112,335-399` 固定使用 `ffmpeg.exe`、`SystemTools.VoskWorker.exe` 与 Windows 原生人脸目录；`SettingsPage/SystemToolsSettingsViewModel.cs:998-1082,1143-1249,1329-1422` 下载、校验 MD5、解压并安装这些依赖；设置页入口见 `SettingsPage/SystemToolsSettingsPage.axaml.cs:401-408,490-496,860-863`。
   - C 档理由：下载管理不是独立可迁移功能，而是绑定 C 档 Windows 原生组件、win-x64 worker、DirectShow/原生模型和固定文件布局；若在跨平台插件保留会暴露不可用或错误的依赖。需先设计 per-OS 依赖清单、架构包、模型许可/校验、目录迁移与失败回滚，随 C 档能力裁剪，本期不迁移。

87. **重启应用为管理员身份**
   - 源文件/关键依赖：`Actions/RestartAsAdminAction.cs:24-35` 用 `WindowsIdentity`/`WindowsPrincipal` 检查管理员角色，并以 `ProcessStartInfo.Verb = "runas"` 请求 Windows UAC；`:46-49` 启动提升实例后停止当前进程。
   - C 档理由：Windows UAC 的管理员令牌、`runas` shell verb 和"管理员身份"模型在 Linux（sudo/polkit）与 macOS（Authorization Services）上没有同一语义；跨平台还需重新定义凭据交互、进程继承和回滚行为，留在原插件。

> 计数说明：本子节 8 项阅读条目，认证 2 + 截图/音量 2 + 系统内存 1 + 摄像头 1 + 依赖下载管理聚合说明 1 + 管理员重启 1；编号 80–87。与 02 v2 §4.7–§4.11 的功能清单一致。注意：C 档的"服务/触发器/组件/行动"总量按批准的去重口径统计，本子节的依赖下载管理是设置页能力聚合项，不能重复计入其背后的语音/人脸/FFmpeg 功能。

## C 档计数核对与三档总表

06 的 C 档 8a–8e 使用的是"便于审阅的合并/聚合条目"编号，当前 C50–C87 共 38 个阅读条目，不能直接作为 C 功能项总数。规范计数必须按 `04-spec.md §S4.1` 的功能域展开，并以同一代码实体去重：

| 功能域 | C 档规范数 | 06 分组条目展开 | 展开口径 |
| --- | ---: | --- | --- |
| 组件 | 1 | 8d 的"音乐软件歌词显示" | `LyricsDisplayComponent` 作为 1 个组件；其窗口捕获/层级与媒体源依赖不再另计组件 |
| 规则集 | 1 | 8d 的歌词/媒体相关证据 | `MediaMusicPlayingRuleHandler` 的"正在播放媒体音乐"作为 1 个规则；SMTC 仅是该规则的依赖，不单独加项 |
| 触发器 | 5 | 8c 的 USB 设备插入 + 8d 的点击主界面、全局热键、长时空闲、关键词 | 5 个独立触发器：`UsbDeviceTrigger`、`MainWindowClickTrigger`、`HotkeyTrigger`、`LongIdleTrigger`、`KeywordTrigger` |
| 行动 | 32 | 8a 展开 13 + 8b 7 + 8c 展开 6 + 8d 展开 2 + 8e 展开 4 | 见下方行动展开表；8a 的常用模拟键必须由合并组展开为 6 个行动文件，8e 的依赖下载管理不属于行动项 |
| 服务/认证 | 7 | 8c 的 USB 自动播放服务 + 8d 的 SAPI/Vosk 语音服务 + 8e 的系统内存、认证与背景采样 | 7 个去重能力：`UsbAutoPlayService`、`KeywordSpeechService`（SAPI）、`VoskSpeechService`（VoskWorker）、`FaceRecognitionService`/`FaceRecognitionAuthorizer`（合并 1 项）、`WindowsHelloService`/`WindowsHelloAuthorizer`（合并 1 项）、`SystemMemoryCleanupService`、`MainWindowBackgroundCaptureService`（背景截图采样） |

### 行动 32 项展开

- **8a 输入模拟：13 项**：Alt+F4、Alt+Tab、Ctrl+Z、Enter、Esc、F11（6 项；F11 的源码仍在 `BlackScreenHtmlAction`，但在行动映射中按常用模拟键单独计）；模拟键盘、模拟组合键、模拟鼠标、键入内容、窗口操作、禁用鼠标、启用鼠标（7 项）。
- **8b 显示/桌面：7 项**：复制屏幕、扩展屏幕、仅电脑屏幕、仅第二屏幕、黑屏 html、显示桌面、调整屏幕亮度。
- **8c 个性化/硬件：3 项**：切换壁纸、切换主题色、切换系统强调色；禁用硬件设备、启用硬件设备、U 盘插入自动打开（3 项）。合计 6 项行动，另有 USB 自动播放服务和 USB 设备插入触发器各 1 项，不能混入行动数。
- **8d 语音行动：2 项**：启用语音唤醒、唤醒语音对话。关键词触发器计入触发器 5，`KeywordSpeechService` 计入服务/认证 7，AI 语音输入的 `VoskSpeechService` 计入服务/认证 7。
- **8e：4 项行动**：屏幕截图、设置系统音量、摄像头抓拍、重启应用为管理员身份。另有系统内存清理 1 项服务能力、人脸 1 项认证能力、Hello 1 项认证能力；"C 档依赖下载管理（FFmpeg/人脸模型/VoskWorker/语音模型）"是设置页聚合/裁剪说明，不是额外功能项。

行动展开合计为 `13 + 7 + 6 + 2 + 4 = 32`。C 档总计为 `组件 1 + 规则 1 + 触发器 5 + 行动 32 + 服务/认证 7 = 46`。

### 38 与 46 的差项说明

1. **8a 合并差项**：当前 8a 首条（新编号 50）把 6 个常用模拟键合并为 1 个阅读条目；规范行动计数须展开为 6 个，因此该处产生 `+5` 的展开差异。
2. **8e 聚合差项**：`C 档依赖下载管理` 是 FFmpeg、人脸模型、VoskWorker 和语音模型的设置页聚合管理说明，不能把下载按钮或依赖包再计为功能；其背后能力已分别落入摄像头、人脸、语音和服务条目，不产生新增计数。
3. **服务展开差项**：8d 的语音条目同时覆盖触发器/行动/服务依赖；按规范需把 `KeywordSpeechService`（SAPI）和 `VoskSpeechService`（VoskWorker）作为服务/认证域各计 1 项。8e 需补明确 `MainWindowBackgroundCaptureService` 背景截图采样为服务/认证域 1 项；它与屏幕截图行动不是同一功能，不重复行动计数。
4. **去重差项**：`FaceRecognitionService` 与 `FaceRecognitionAuthorizer` 合并计 1 项；`WindowsHelloService` 与 `WindowsHelloAuthorizer` 合并计 1 项。服务、验证器、设置页入口不重复计数。
5. **阅读编号方案**：C 档采用与 A/B 连续的唯一编号，不再使用与 A/B 重号的子节裸编号；编号映射为 8a: 50–57、8b: 58–64、8c: 65–71、8d: 72–79、8e: 80–87。C 档内部保留"8a–8e"子节标签；C46 展开表和 A33/B19/C46 规范计数不变。

### 三档最终总表

| 档位 | 功能项数 | 计数校验 |
| --- | ---: | --- |
| A 直接迁移 | 33 | 主题 3 + 组件 6 + 规则 4 + 触发器 1 + 行动 15 + 服务/设置页聚合 4 |
| B 稍加修改 | 19 | 触发器 1 + 行动 14 + 服务/悬浮窗/更多选项 4 |
| C 不迁移 | 46 | 组件 1 + 规则 1 + 触发器 5 + 行动 32 + 服务/认证 7 |
| **合计** | **98** | `A33 + B19 + C46 = 98`；行动 `A15 + B14 + C32 = 61` 活动功能项，另有 1 个注释死代码文件映射，源行动文件总数 62 |

此说明不改变 02 v2/04-spec 的分类结论；它只把 06 的阅读分组映射补成可重放的规范计数。

## 开工前迁移预备清单

以下事项是用户明确批准"开始实施"后、阶段 0 开工前必须完成的预备核对；在用户批准前仅形成清单，不创建工程、不下载依赖、不改源插件。

1. **冻结决策输入**：确认 `01-requirements.md`、`02-draft-solution.md`、`03-review.md`、`04-spec.md`、本提案及 C46 计数核对说明均为同一版；记录最终 case_scale=`large`。任何 U3/U4/U5、三平台范围、A33/B19/C46 或同装策略变更，都必须先回到需求/会签材料修订。
2. **确认用户开工门**：用户明确选择"批准实施"后才可进入 05 的阶段 0；"继续补充细节""暂不实施"或未回答均视为未开工。开工决定、时间和反馈原文写入本案决策记录。
3. **保存源与宿主基线**：记录 `E:\My Github Projects\SystemTools` 当前提交/工作树状态、工程文件、manifest、设置入口和 62 个行动文件清单；记录 `E:\ClassIsland-git-misha` misha/v2 检出版本、SDK/平台抽象接口文件和平台实现。基线快照只读，不修改原插件。
4. **完成 62→61→A/B/C 映射**：按 C46 核对说明将 C 阅读条目展开为稳定 ID；确认 `ClickSimulationAction.cs` 是整文件注释死代码、不注册、不计活动项；核对行动 `A15+B14+C32=61`、总计 `A33+B19+C46=98`，无重复、无遗漏。
5. **核对宿主 API**：从指定 misha/v2 检出确认 `ClassIsland.PluginSdk`、`ClassIsland.Platforms.Abstractions` 及既定 `IWindowPlatformService`、`ISystemEventsService`、`IDesktopToastService`、`ILauncherService`、`IDesktopService` 等接口和至少一个平台实现；缺失接口不得自行假定兼容，须按 S6 重新降级或回到评审。
6. **确定三平台工程入口**：确认宿主 `CrossPlatformProps` 的基础 TFM 与 Windows/Linux(X11)/macOS 平台切换方式、SDK 版本、RID/架构策略和发布目录；不得复制源工程的 `net10.0-windows`、WinForms、x64 单平台限定。
7. **建立依赖裁剪基线**：形成新插件包引用与传递依赖清单；明确移除 `CsWin32`、`System.Management`、`System.Speech`、`DlibDotNet`、`OpenCvSharp4*`、`OpenCvSharp4.runtime.win`、`NAudio.Wasapi`、VoskWorker 与 C 档原生认证/视觉运行时；保留 PluginSdk、DI、FluentAvalonia 等已批准依赖。
8. **准备独立元数据与配置方案**：确定新插件 manifest `id`、功能 ID 前缀、配置命名空间、设置文件/目录和 `supportedOSPlatforms`；确认不复用 `SystemTools` ID、不自动迁移旧配置、不与原插件注册冲突，并准备同装差异说明。
9. **固定静态门禁规则**：将 `04-spec.md §S4.2` 禁用符号、Windows 专属进程和包名转成可重放检查；A 档不得出现禁用项，B 档仅在 Windows 专属点证据中出现；C 档代码不得进入新插件输出。
10. **建立证据目录和命名**：所有阶段日志、包图、manifest 解析、映射表、静态扫描、构建输出和失败记录放入 `.tang/cases/stcp-cross-platform-001/`，不创建共享 `.tang/evidence` 或 `.tang/reports`；证据文件应包含命令、版本、目标 TFM、输入文件和结论。
11. **定义原插件隔离检查**：准备实施前后对比原 `SystemTools` 工程、manifest、配置和源码差异的命令/记录格式；确认新插件可单独禁用、卸载或回滚，原插件不需要修改。
12. **锁定停止条件**：三平台目标未解析、包图带入禁用资产、manifest 冲突、映射未闭合、宿主接口缺失、原插件出现未授权差异或任一必需证据不可复核时，立即停止阶段推进，保留现场，不以猜测补齐。

## 开工前验收与可重放期望

1. **范围重放**：在源插件上重放主题 3、组件 7、规则 5、触发器 7、行动 62 文件/61 活动项、设置页 6、AI 文本/语音与服务清单；将 A33/B19/C46 逐域展开并与 `04-spec.md §S4.1` 一致。
2. **C 档重放**：检查 C 条目稳定 ID 或连续编号 50–87；确认歌词组件、媒体规则、USB 触发器/服务、语音 SAPI/Vosk、认证服务与验证器、背景截图采样、系统内存清理和 C 依赖下载聚合均按核对说明去重；不得将依赖下载按钮再次计为功能。
3. **阶段 0 构建重放**：使用新插件解决方案的 Release 构建入口，记录 .NET SDK、宿主检出版本、实际 TFM 和 Windows/Linux(X11)/macOS 三目标成功输出；"只恢复未编译"或只通过 Windows 不算通过。
4. **包与资产重放**：运行项目包清单/传递依赖检查，确认禁用包、Windows runtime、VoskWorker、C 档原生模型/视觉/认证资产均不在新插件输出；确认已批准的 PluginSdk、DI、FluentAvalonia 可解析。
5. **manifest/config 重放**：按宿主 schema 解析 manifest，核对独立 ID、功能前缀、配置命名空间、三平台 `supportedOSPlatforms` 和 U3 API 版本；在两插件同装场景确认注册项不覆盖、设置不互写。
6. **静态门禁重放**：对纳入 A/B 的实际源文件反向扫描 S4.2 禁用符号；A 档零命中，B 档命中只能落在已声明 Windows 专属点；对新插件发布目录检查 Windows 专属进程、原生包和 C 档文件没有泄漏。
7. **B 档行为验收准备**：为 7 项电源/锁屏/睡眠、文件夹复制/移动/删除、悬浮窗经典外观/层级和触发器准备能力存在、权限不足、命令缺失、执行失败、成功确认、Toast 通知和正常返回的测试矩阵；U4 失败不得抛未处理异常或伪造成功。
8. **U5 验收准备**：确认首期只验收悬浮窗经典外观与既定适配行为；液态玻璃、自适应背景采样、AI 浮窗背景采样均不进入首期交付，也不因采样失败影响核心窗口显示。
9. **宿主前提重放**：逐个检查阶段文档引用的宿主抽象接口存在且至少有一个平台实现；接口文件、实现文件、版本和检查命令写入证据。
10. **隔离与回滚重放**：实施前后原插件差异为空或有明确外部变更说明；禁用/卸载新插件后原插件仍可运行；新插件工程、manifest、配置和发布资产可整体移除，不要求改动原插件。
11. **证据可重放要求**：另一复核方仅凭本案文档、源/宿主路径、版本记录和命令即可重做范围、包图、静态门禁、manifest、构建与隔离检查；所有失败输出和未解决风险必须保留，不得只写"已验证"。

## 风险、失败处理与回滚

### 风险登记

- **R1：原生依赖或 C 档源码漏入新插件**。A/B 抽取或传递依赖可能重新带入 `CsWin32`、WinForms、WMI、SAPI、WinRT、Dlib/OpenCV、WASAPI、Windows 专属进程或 C 档文件。处理：阶段 0 建立包图、源代码禁用符号和发布资产三重门禁；任一命中即停止推进并修订依赖边界。
- **R2：三平台目标被误判为仅恢复成功**。工程可能只解析 Windows TFM，或 Linux/macOS 只完成 restore 未完成编译。处理：Release 构建必须记录 SDK、宿主 props、实际 TFM 及 Windows/Linux(X11)/macOS 各目标成功输出；任一目标未解析、未编译或出现平台限定错误，阶段失败。
- **R3：C 档边界、去重与计数漂移**。合并条目、设置聚合项、服务/验证器组合或死代码可能造成重复/遗漏。处理：以 C50–C87 稳定编号和 C46 展开说明作为阅读索引，以 `04-spec.md §S4.1` 作为规范计数；重放 `A33+B19+C46=98`、`A15+B14+C32=61`，保留 `ClickSimulationAction.cs` 的死代码注记。
- **R4：宿主 U3 API 或平台实现不满足文档假设**。目标检出中的接口签名、版本或平台实现可能发生差异。处理：阶段 0 逐个核对 `ClassIsland.PluginSdk`、`ClassIsland.Platforms.Abstractions` 和被引用接口的文件及至少一个平台实现；缺失时停止，不用未经审批的发布包替代，按 S6 重新降级或回到评审。
- **R5：B 档权限/命令失败被伪报成功**。电源、锁屏、睡眠和文件系统操作在不同 OS 上可能缺少命令、权限或会话。处理：依 U4 做能力与权限预检；失败通过 `IDesktopToastService` 说明未执行/权限不足/命令缺失，正常返回，不抛未处理异常，也不在仅启动进程时宣称成功。
- **R6：U5 范围扩张、背景采样或双插件并存破坏首期边界**。液态玻璃/自适应背景、AI 浮窗采样可能被误带入；独立插件也可能复用原 ID/配置造成同装冲突。处理：首期仅交付经典悬浮窗外观，采样能力保持 C 候选且失败不影响核心显示；新插件使用独立 manifest ID、功能 ID 前缀和配置命名空间，并通过同装/禁用/卸载检查。

### 失败处理原则（收拢 `04-spec.md` S6/S7）

1. **门禁失败即封锁依赖阶段**：静态符号、包图、三平台构建、宿主接口、manifest/config、隔离或行为证据任一失败，只停止依赖该证据的后续阶段；保留已通过阶段成果和原始失败输出，不以"已验证"文字替代证据。
2. **源码事实优先**：发现任何档位漏判、证据行不存在、文件清单或计数不符时，以源代码和 `02-draft-solution.md`/`04-spec.md` 为准修订条目；同步更新 C50–C87 索引、域计数、62→61 映射和勘误记录。门下省仅对变更条目做增量复核，未更新的旧证据不得继续作为出口证据。
3. **宿主抽象缺失的处理**：若引用的宿主接口不存在或没有可用平台实现，暂停相关 B 档项，明确改用已批准抽象、自建平台服务或降为 C；同步修订需求、规范、阶段合同和计数后再执行，不在代码中暗含新范围。
4. **U4 运行失败处理**：回收本地计划、定时器、窗口和资源；通过 `IDesktopToastService` 说明权限/命令/会话原因，记录退出码与 OS；正常返回，不抛未处理异常，不发送未经确认的成功通知。
5. **隔离/资产污染处理**：若原 `SystemTools` 出现未授权差异，或新插件发布资产带入 C 档/Windows 原生依赖，立即停止发布；保留差异与输出，只撤销本阶段确认产生的误改，不覆盖用户既有修改；修订工程边界后重新跑包图、资产和隔离检查。
6. **证据不可重放处理**：缺少命令、版本、输入、目标 TFM、标准输出/错误、文件行证据或失败记录时，按证据缺失退回补充，不用描述性结论补洞；另一复核方无法独立重做前，不得标记阶段通过。
7. **用户决定变化处理**：U3/U4/U5 或平台范围被用户修改时，只调整受影响的替换目标、降级策略和验收字段；若修改直接命中分档前提，则暂停执行、更新计数并重新进入相应评审/审批，不沿用旧批准。

### 回滚原则

- **分析期回滚**：本案尚未实施时，回滚仅限文档版本和勘误；保留旧稿、核对证据、失败记录和用户决定，不修改源插件。
- **阶段 0 回滚**：脚手架、依赖声明、manifest、配置命名空间或证据门禁失败时，可整体禁用、移除或重建新插件；原 `SystemTools` 工程、源码、manifest、配置和发布产物保持不变。
- **阶段 1–3 回滚**：新插件保持独立工程/ID/配置，任一阶段失败可停用该阶段产物或整体卸载新插件，保留已通过证据；不得通过修改原插件规避失败。
- **阶段 4 发布前回滚**：范围、静态门禁、构建、资产、并存和回归证据未全部通过时，不发布或不启用新插件，继续使用原插件；失败输出和未解决风险进入案卷。
- **C 档候选另立项目**：语音、屏幕截图、系统音量及其他 C 候选不得因本案 A+B 迁移通过而自动纳入；未来必须重新审批平台后端、权限、依赖许可、安装布局、验收和回滚。

## 用户开工决策记录（占位）

> 仅用于记录用户在审批门作出的明确决定。在"批准实施"被明确记录前，不得创建工程、抽取/迁移源码、修改原插件、下载/安装 C 档依赖、实施构建或派遣六部。

- 案卷号：`stcp-cross-platform-001`
- 提案文件：`.tang/cases/stcp-cross-platform-001/06-migration-details-proposal.md`
- 提案版本/变更：`C50–C87` 连续编号；C46 展开核对；9a/9b 收尾章节
- case_scale：`large`
- 决策状态：`批准实施`
- 用户决定选项：
  - `批准实施`：按 `05-phased-development.md` 从阶段 0 开始；阶段门禁、证据、风险检查点和回滚仍然有效。
  - `暂不实施`：保留全部材料和证据，不创建工程、不修改源码、不构建迁移。
  - `继续补充细节`：填写需要补充的具体平台、API、依赖、行为、验收或风险问题，补充后重新进入用户审批门。
  - `取消本案`：停止后续工作，保留文档、失败记录和审计轨迹。
- 用户决定原文：`批准实施——在工作区新建这个跨平台版插件吧！（插件名字叫做SystemTools-Cross-platform）`
- 用户决定时间：`本次审批消息`
- 用户附加条件/反馈：`插件名定为 SystemTools-Cross-platform，新建于当前工作区（E:\My Github Projects\SystemTools-Cross-platform）。`
- 批准后首个允许动作：仅执行阶段 0 合同规定的工程脚手架、依赖裁剪、manifest/config 边界和 62→61/A15+B14+C32 基线核对；不得直接进入 A/B 功能抽取。
- 未批准时禁止动作：创建工程、抽取/迁移源码、修改原插件、下载/安装 C 档依赖、实施构建、派遣六部。

