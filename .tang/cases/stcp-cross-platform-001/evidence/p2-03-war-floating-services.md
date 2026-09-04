# p2-03 证据：B 档悬浮窗域抽取（兵部 war / application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-03 · 兵部 war · application-code / implementation（依赖 p2-05，已 succeeded；重派注记：前次派工因基础设施故障零产物中断，本次全新执行） |
| 权威输入 | p2-05 §1.2 p2-03 落点权威表（4 项 + 非计数附属）与 §2.1 预批增补清单、p1-05 结构规范（§2/§3/§5.1-3）、p0-03 §3.2 B 档清单（源锚点）、p1-10 §12.5 双分支 API 漂移约束、p0-07 §11 R-2 条件文件扫描口径、p1-06 §9-7 等价口径先例、p0-01 宿主契约（§3/G2）、尚书省本批裁决 1-5、04-spec §S4.2/R-*、05 合同阶段 2 行 |
| 交付范围 | 新增 12 文件 + 共享类型增补 1 文件（MainConfigData 预批段）：B11（3 文件）+ B12（3 文件）+ B-触发三件套（3 文件）+ FloatingWindowService（1 文件）+ 非计数附属 SystemShutdownMonitor/SystemMotionPreferences（2 文件）；MainConfigData 增 13 成员（7 组） |
| 结论 | **succeeded** —— 12 新文件 + MainConfigData 预批段逐文件落位（§1）；降级处置 15 条逐条登记（§2）；双分支 API 核对齐备（NuGet 2.1.1.1 字节级 + U3 源码级，§3）；接线需求 13 条移交 p2-06（§4）；macOS 五列自检 0 项"不适用"（§5）；S4.2 全树 168 文件 GateHits=0 exit=0（本批 CONDITIONAL=3、INFO=2，R-2 口径，§6）；Roslyn 双向符号验证（Windows 语境 + 非 Windows 语境）error=0（§6.3）；未改 Plugin.cs / manifest.yml / csproj / global.json / slnx |
| 修复记录 | 自检 CS0649 暴露 FloatingWindowTriggerSettings 抄录缺行（源 :60-68 按钮名称输入框块），已补齐并三重复验：归一化代码 diff 9 文件全 SAME（§1.4）+ 扫描复跑 + Roslyn 复跑均 PASS |

---

## 1. 逐项源锚点 → 新落点对照（新文件与 4 项 + 附属清单一一对应）

计数闭合：B11 + B12 + B-触发 + FloatingWindowService = 4 项（p2-05 §1.3-6：B19 = 14 行动 + 1 触发器 + 4 服务 = 19 = p2-01(8)+p2-02(7)+p2-03(4)）；SystemShutdownMonitor/SystemMotionPreferences 为非计数附属，不计入 B19。

### 1.1 B11 显示悬浮窗（行动 + 附属 + 单文件服务）

| 源文件:锚点 | 新落点 | 适配 |
| --- | --- | --- |
| `Actions\ShowFloatingWindowAction.cs:15`（ActionInfo，06 条目 44；:16-21 注入服务） | `Actions\ShowFloatingWindowAction.cs` | 命名空间/using 镜像 + 功能 ID 前缀变换；提醒路径跨批引用 SystemToolsNotificationProvider（p1-04，先例 p1-03） |
| `Settings\ShowFloatingWindowSettings.cs:5` | `Settings\ShowFloatingWindowSettings.cs` | 逐行（§1.4 归一化 diff SAME） |
| `Controls\ShowFloatingWindowSettingsControl.cs:9` | `Controls\ShowFloatingWindowSettingsControl.cs` | 逐行（SAME） |
| `Services\FloatingWindowService.cs:30`（单文件服务，窗口代码内创建无 axaml，源 2478 行） | `Services\FloatingWindowService.cs` | 经典外观保留 + 已批降级适配（§2，成员级对照见 §1.5） |

### 1.2 B12 切换悬浮窗层级

| 源文件:锚点 | 新落点 | 适配 |
| --- | --- | --- |
| `Actions\ToggleFloatingWindowLayerAction.cs:18`（ActionInfo，06 条目 45；:46-57 调服务 SetWindowLayer/ToggleWindowLayer） | `Actions\ToggleFloatingWindowLayerAction.cs` | 命名空间/using 镜像 + ID 前缀变换（SAME） |
| `Settings\ToggleFloatingWindowLayerSettings.cs:5` | `Settings\ToggleFloatingWindowLayerSettings.cs` | 逐行（SAME） |
| `Controls\ToggleFloatingWindowLayerSettingsControl.cs:10` | `Controls\ToggleFloatingWindowLayerSettingsControl.cs` | 逐行（SAME） |

### 1.3 B-触发 从悬浮窗触发（三件套；auto.json 对端 = A7 TriggerCustomTriggerAction 已由 p1-03 落地）

| 源文件:锚点 | 新落点 | 适配 |
| --- | --- | --- |
| `Triggers\FloatingWindowTrigger.cs:12`（TriggerInfo；:25-44 Register/UnregisterTrigger 服务联动；:46-62 TriggerFromFloatingWindow 含恢复模式） | `Triggers\FloatingWindowTrigger.cs` | 命名空间镜像 + ID 前缀变换 + 补 Config 类型 using（SAME） |
| `Triggers\FloatingWindowTriggerConfig.cs:10`（源锚） | **`Config\FloatingWindowTriggerConfig.cs`** | 落点按 p2-05 §1.2 权威表归 `Config\`（触发器三件套 Trigger/Config/Settings 结构先例；源插件其余 5 个触发器配置均在 `Config\`，本文件为源侧唯一落 `Triggers\` 的触发器配置——**与源目录差异已登记**）；命名空间按 p1-05 §3.2 目录镜像调整，其余逐行（SAME） |
| `Settings\FloatingWindowTriggerSettings.cs:19`（TriggerSettingsControlBase 派生，图标选择对话框 + 名称输入框） | `Settings\FloatingWindowTriggerSettings.cs` | 命名空间镜像 + 补 Config 类型 using（SAME） |

### 1.4 非计数附属（2 文件，R-2 条件文件形态 a 交付）

| 源文件:锚点 | 新落点 | 条件文件处置 |
| --- | --- | --- |
| `Services\SystemShutdownMonitor.cs:8`（`NativeWindow` 子类，Windows 会话消息路径，06 条目 46 / R-4 口径；88 行） | `Services\SystemShutdownMonitor.cs` | **全文件正向平台 guard 包裹（形态 a）**：Windows 分支逐行保留源实现；`#else` 非 Windows no-op 护栏（同公共表面：`IsSessionEnding` 恒 false、Start/MarkSessionEnding/MarkIfOsShutdown/Dispose 空实现；G2 实证见 §3.2，不得假托宿主事件）。`WindowCaption` 常量按 ID 前缀规则精神变换为 `SystemTools.CrossPlatform.SystemShutdownMonitor`（源 `SystemTools.SystemShutdownMonitor`；内部窗口标题常量，非注册 ID，登记备查） |
| `Views\SystemMotionPreferences.cs:6`（动效偏好查询，源 :27-31 原生互操作声明 + `OperatingSystem.IsWindows()` 守卫非 Windows 返回 false；39 行） | `Views\SystemMotionPreferences.cs` | **全文件正向平台 guard 包裹（形态 a）**：Windows 分支逐行保留源实现（含源侧运行时守卫，双保险随源）；`#else` 分支以编译期分支承载源运行时守卫同一语义（no-op 返回 false），对外表面 `ShouldReduceMotion` 与源一致 |

**R-2 形态合规要点**：两文件首个非空行均为裸 `#if` guard、末个非空行均为裸 `#endif`（形态 a 判定通过）；guard 内命中计 CONDITIONAL、guard 外零命中；**guard 符号采用 `Platforms_Windows`（驼峰）**——宿主 CrossPlatformProps.props:37 注入的编译生效符号即此大小写（C# 预处理符号大小写敏感，全大写 `PLATFORMS_WINDOWS` 在编译器语义下恒未定义，Windows 分支将成为死代码）；派工单/R-2 文本的 `#if PLATFORMS_WINDOWS` 按扫描口径理解：扫描器以 PowerShell `-match`（大小写不敏感）匹配 guard，两种写法均识别为正向 guard（实测留证 §6.2）。**此大小写裁决事实请尚书省/门下省知悉**，p2-01 条件适配器同口径适用。

### 1.5 FloatingWindowService 适配（B11 服务；逐段对照源 2478 行）

保留面（经典外观 CW2+，逐行随源）：触发器注册表（RegisterTrigger/EnsureUniqueButtonIds/UnregisterTrigger/CreateEntry/Entries/ProfileManager）、窗口生命周期（Start/Stop/EnsureWindow/OnWindowLoaded/OnWindowOpened/OnWindowPropertyChanged/RestoreWindowFromMinimized/QueueWindowBoundsClamp/OnWindowSizeChanged）、主题面（SubscribeThemeChanged/UnsubscribeThemeChanged/OnApplicationPropertyChanged/ResolveWindowThemeVariant/IsLightTheme/SetWindowTheme/ToggleWindowTheme）、规则集隐藏 R-3 保留面（CheckFloatingWindowRuleset/CheckButtonRulesets/CheckRowRulesets/_rulesetHidingWindow/_rulesetHiddenButtons/_rulesetHiddenRows/OnPostMainTimerTicked）、可见性（ApplyVisibility/DiscardWindowState）、按钮渲染经典分支（RefreshWindowButtons/GetOrderedRows/GetConfiguredButtonRowsWithFallback/PruneButtonWidthCache/HasAnyVisibleButton/TryGetButtonPointerOverBrush）、指针/拖拽（OnPointerPressed/OnPointerMoved/OnPointerReleased/触控手动拖拽全链/CreateTouchDragHandle/CreateDragHandleDot/IsEventFromTouchDragHandle/IsTouchLikePointer/UpdateInputMode/SetTouchInputMode/UpdateDragHandleVisibility）、屏幕与位置记忆（GetWindowRect/IsWindowInsideAnyScreen/GetCenteredPositionOnPrimaryScreen/ClampToVisibleScreen/GetWindowPixelSize/EnsureWindowPositionVisibleOnStartup/SavePosition）、层级公共 API（RecheckWindowLayer/ToggleWindowLayer/SetWindowLayer）、方案切换（ToggleWindowProfile/SwitchToProfile）、工具面（TryParseColor/ConvertIcon）、FloatingWindowEntry record（逐字段随源）。规则集巡检驱动 `ILessonsService.PostMainTimerTicked` 保留（源 :2146-2152 形态，承载于 `EnsureRulesetPatrol`/`RemoveRulesetPatrol`——源 `EnsureLayerRecheckHooks`/`RemoveLayerRecheckHooks` 钩子安装体移除后的内部重命名，见 §2 D1）。

成员级核对（脚本归一化比对，重放命令见 §6.4）：源独有成员 34 个全部为已批降级面（钩子 12、液态玻璃 15、玻璃拖拽/延迟刷新 5、玻璃判定 2）；目标独有成员 4 个全部为登记过的适配（`ApplyWindowAppearance` 经典绘制提取、`EnsureRulesetPatrol`/`RemoveRulesetPatrol` 重命名、`NotifyEntriesChanged()` 去玻璃参数）。源 :1265 未使用局部 `profile` 保留、源 :1057 未使用局部 `profile` 保留（逐行忠实）。

### 1.6 MainConfigData 预批增补（尚书省预批 p2-05 §2.1 #1-#7；裁决 4）

增 13 成员（7 组），逐成员与源同默认值同守卫（脚本核验：默认值 13/13 一致、钳制/归一化守卫 7/7 一致，§6.4）：`EnableFloatingWindowFeature`（源 :54-65，默认 true）、`ShowFloatingWindow`（:428-440，默认 true）、外观 6 成员 `FloatingWindowScale`（:463-476，1.0，钳 0.5-2.0）/`FloatingWindowTextSize`（:478-491，12，钳 8-30）/`FloatingWindowIconSize`（:493-506，22，钳 15-50）/`FloatingWindowOpacity`（:508-521，80，钳 10-100）/`FloatingWindowShadowEnabled`（:524-536，true）/`FloatingWindowDragHandleAlwaysVisible`（:651-663，false）、`FloatingWindowPositionX/Y`（:553-579，100/100）、`FloatingWindowLayer`（:593-606，1，归一化 `value is 0 or 1`）、`FloatingWindowLayerRecheckMode`（:608-621，1，钳 0-3；成员随源保持配置兼容、运行时不消费——p2-05 §2.1 #6 已批注记）、`FloatingWindowRulesetEnabled`（:637-649，false）+ `FloatingWindowRuleset`（:665-666，`Ruleset` SDK 类型零新引入，文件头补 `using ClassIsland.Core.Models.Ruleset;`）。文件内增补段留痕注释含逐成员源锚点、RestartPropertyChanged 不引入注记（裁决 3）与液态玻璃三成员明确不增补注记。**并行批次无冲突**：p2-02 增补段（AutoSwitchClassIslandTheme/AutoHideMainWindowWhenOccluded）已先行落盘，本批段追加于 `// ===== p2-02 增补结束 =====` 之后，互不重叠。

### 1.7 新文件与清单对应核对（9 个逐行文件归一化 diff）

方法：剔除 using/namespace/`///`/`//` 行后逐行归一化比对（`SystemTools.CrossPlatform.` → `SystemTools.` 还原前缀变换）。结果：**ShowFloatingWindowAction / ToggleFloatingWindowLayerAction / ShowFloatingWindowSettings / ToggleFloatingWindowLayerSettings / FloatingWindowTriggerSettings / ShowFloatingWindowSettingsControl / ToggleFloatingWindowLayerSettingsControl / FloatingWindowTrigger / FloatingWindowTriggerConfig 九文件全部 SAME**（零未登记代码差异）。FloatingWindowService 与两条件文件按 §1.5/§1.4 处置口径另行核对（成员级 + 逐段阅读比对）。

---

## 2. R-3/R-4/U5/R-6 降级处置逐条登记（15 条）

| # | 源锚点（源 FloatingWindowService.cs 除注明外） | 源面 | 处置 | 依据 |
| --- | --- | --- | --- | --- |
| D1 | :100-107/:109-112/:2134-2260 | WinEvent 前台/重排钩子（Ensure/RemoveForegroundHook、Ensure/RemoveReorderHook、OnWinEvent、_foregroundHook/_reorderHook/_winEventProc）+ 层级自动重检 RefreshLayerRecheckMode（模式 0-3 全停）+ LayerRecheck50Ms/1Ms DispatcherTimer | **移除**（R-3 钩子子特性明示降级）；其内保留的 `ILessonsService.PostMainTimerTicked` 订阅重命名承载于 EnsureRulesetPatrol/RemoveRulesetPatrol（规则集巡检驱动保留）；层级仅在显式时点（Start/UpdateWindowState/SetWindowLayer/SwitchToProfile/Loaded）一次性应用 | 尚书省裁决 1；R-3 |
| D2 | :38-43/:124-128/:1944-2011 | 低级输入钩子识别合成触控（SetWindowsHookEx 面向鼠标低级链、MSLLHOOKSTRUCT、MiWpSignature 签名、CallNextHookEx） | **移除**；`_lastTouchGeneratedMouseEventAt` 恒为 MinValue → `IsRecentTouchGeneratedMouseEvent` 恒 false（源方法体保留），触控语义由 Avalonia 指针类型直接承载 | R-3 钩子降级同族 |
| D3 | :32-37/:2310-2338 | 置顶/置底原生调用（PInvoke.SetWindowPos + HwndBottom/HwndTopmost + SET_WINDOW_POS_FLAGS） | **替换**为宿主 `IWindowPlatformService.SetWindowFeature(_window, WindowFeatures.Topmost/Bottommost, state)`（对偶翻转：切底层时置 false Topmost + true Bottommost，反之亦然）；`_window.Topmost` 源赋值形态保留 | 尚书省裁决 1（p2-05 §4 双分支 PRESENT）；p0-03 B12 替换目标 |
| D4 | :22-26/:44/:62-84/:130-149/:462/:476/:484-496/:505-509/:659-915/:1001-1050/:1237/:1243/:1247-1248 | 液态玻璃全套（Surface/InteractiveSurface/BackdropClip/捕获计时器/WriteableBitmap/后台捕获服务依赖/ParseGlassColor/ApplyLiquidGlassSettings/IsLiquidGlassRequested/IsBackgroundCaptureRequested/UpdateLiquidGlassCaptureLoop/StopLiquidGlassCapture/Release*/CaptureLiquidGlassBackdropAsync/TryGetLiquidGlassCaptureArea/UpdateAdaptiveBackgroundTheme/OnWindowPositionChanged）+ 构造器依赖 `MainWindowBackgroundCaptureService`（C 档服务不迁，构造器改为双参） | **不迁（U5/R-6 已批降级）**；其经典外观分支（底色随明暗与不透明度、圆角 8、阴影随 FloatingWindowShadowEnabled，源 :939-999）提取保留为 `ApplyWindowAppearance`（D4 保留面），挂接 OnWindowLoaded/OnWindowOpened/OnApplicationPropertyChanged/OnConfigPropertyChanged 原调用位 | 尚书省裁决 1；U5；R-6 |
| D5 | :48/:350-361/:618-621/:649-657 | 自适应背景主题（主题值 3 的采样路径与 `_adaptiveThemeRefreshCount`） | **降级**：主题值 3 在无采样路径下 `_adaptiveBackgroundThemeVariant` 恒空 → ResolveWindowThemeVariant 回退 `Application.Current.ActualThemeVariant`（跟随宿主明暗，与源"采样不可用回退宿主变体"分支一致）；`FloatingWindowTheme` 归一化守卫保留 3 值（配置兼容）；主题变更时的变体重置保留（去计数器行） | R-6 已批降级（裁决 1） |
| D6 | :81-84/:1647-1648/:1694-1717/:1761/:1766-1769/:1787-1796 | 手动鼠标拖拽捕获路径（_isDraggingWindow/Begin/EndWindowDragCapture/_dragStartScreenPoint/_dragStartWindowPosition + OnPointerMoved 手动拖尾 + OnPointerReleased wasWindowDragging 分支） | **移除**；鼠标拖拽恒走源非捕获分支 `_window.BeginMoveDrag(_lastPressedArgs)`（源 :1695-1703 在无背景捕获时即此路径，经典外观行为与源一致）；触控手动拖拽链逐行保留（_touchDragStartScreenPoint/_touchDragStartWindowPosition 等） | U5 连带（手动鼠标拖拽仅服务玻璃边拖时连续背景捕获） |
| D7 | :462/:484-496 | OnWindowPositionChanged（仅服务玻璃捕获刷新） | **移除**（订阅与方法体一并） | U5 连带 |
| D8 | :1384-1414/:1431-1446/:1858-1877 | 玻璃按钮 host（LiquidGlassInteractiveSurface 包装、ShouldReduceMotion 消费点 :1388、IsEventFromGlassButton） | **移除**；宽度缓存 LayoutUpdated 挂 button 本体（经典形态 buttonHost≡button）；右键取消恢复状态指针处理逐行保留 | U5/R-6 |
| D9 | :1272-1273/:1284-1306/:1319-1365/:1362-1365 | RefreshWindowButtons 玻璃外观分支（spacing 8/margin 12/MinWidth 104/MinHeight 48/Padding 14/nameBlock SemiBold+NoWrap+Ellipsis+MaxWidth150）与 `_lastButtonLayoutStyle`（外观样式维度缓存失效） | **移除**，全部取源经典值（6/6/54/52/(6,4)/Normal/Wrap/None/MaxWidth 100/Margin(0,2s,0,0)）；`_lastButtonLayoutScale` 尺寸维度保留（宽度缓存失效语义随源） | U5 连带 |
| D10 | :52/:66/:144-148/:285-314 | 玻璃按钮延迟刷新（_deferredButtonRefreshTimer/GlassButtonStateRefreshDelay/OnDeferredButtonRefreshTimerTick/NotifyEntriesChanged 玻璃参数分支） | **移除**；NotifyEntriesChanged 无参形态直接 ApplyVisibility/RecheckWindowLayer/RefreshWindowButtons（与源 else 分支行为一致） | U5 连带 |
| D11 | `Views\SystemMotionPreferences.cs:10`（消费点源 :1388） | ShouldReduceMotion 玻璃交互按钮缩放消费 | 消费点随 U5 移除；附属文件仍按派工交付（§1.4），**本批后 B 档零消费**（源唯一消费点为玻璃按钮；C 档消费方不迁）——留痕供终检知悉，不阻塞 | 尚书省裁决 1 + 派工交付清单 |
| D12 | `Services\SystemShutdownMonitor.cs:8`（06 条目 46） | Windows 会话消息路径（NativeWindow 子类） | **条件文件形态 a 承载**：Windows 分支逐行随源（R-4 口径）；非 Windows no-op 护栏（同表面空实现）；宿主 `ISystemEventsService` 无会话结束事件（G2 实证 §3.2）不假托 | 裁决 2；R-4；R-2 扫描口径 |
| D13 | 源 MainConfigData.cs:65 | `EnableFloatingWindowFeature` setter 另发 `RestartPropertyChanged` 事件 | **不引入事件**（裁决 3）：沿用 p1-06 §9-7 等价口径，配置变更经既有 ApplyConfig/lifecycle 路径生效；MainConfigData 增补段留痕注释 | 尚书省裁决 3；p2-05 §2.1 决策注记默认② |
| D14 | 源 Plugin.cs:207（调用先例）；目标 Plugin.cs:49（阶段 1 预留注释） | `MigrateFromLegacyConfig(GlobalConstants.MainConfig!.Data)` 旧配置迁移接线 | **不在本批接线**（注册面禁区）；登记需求移交 p2-06（§4 W4） | 裁决 1；p1-05 §2.3-2 接线注记 |
| D15 | 源 Plugin.cs:1034-1035/:1048 | SystemShutdownMonitor.IsSessionEnding → `AdvancedShutdownAction.CancelPlanOnAppStopping(bool)`（B5 看门狗消费） | bool 传递、无编译耦合（p2-05 §1.3-4）；接线需求登记移交 p2-06（§4 W6），本批不消费 p2-01 类型 | 裁决 5；p2-05 §1.2 附属行注记 |

---

## 3. 双分支 API 核对表（p1-10 §12.5 约束；NuGet 2.1.1.1 发布面为基线）

### 3.1 本批消费面逐项核对（字节级 + 源码级，本批独立复验）

| 消费面（本批文件） | U3 本地检出源码 | NuGet 2.1.1.1 二进制字节检索 | 判定 |
| --- | --- | --- | --- |
| `PlatformServices.WindowPlatformService`（服务静态门面属性，RecheckWindowLayer 消费） | PRESENT（PlatformServices.cs:14） | PRESENT（含 `WindowPlatformServiceStub` 默认值） | **两分支齐备，直接消费** |
| `IWindowPlatformService.SetWindowFeature(TopLevel, WindowFeatures, bool)`（B12 层级承载） | PRESENT（IWindowPlatformService.cs:20） | PRESENT（`SetWindowFeature`） | **两分支齐备，直接消费** |
| `IWindowPlatformService.GetWindowFeatures` | PRESENT（:27） | PRESENT | 两分支齐备（本批未消费，随面登记） |
| `WindowFeatures` 枚举 `Topmost=4`/`Bottommost=2` | PRESENT（WindowFeatures.cs:24/:20） | PRESENT（`Topmost`/`Bottommost`） | **两分支齐备，直接消费** |
| `Ruleset`（ClassIsland.Core.Models.Ruleset，MainConfigData.FloatingWindowRuleset） | SDK 类型 | Core 2.1.1.1（引用集在盘，Roslyn 编译通过） | 两分支齐备 |
| `ILessonsService.PostMainTimerTicked`（:25 事件）/`IRulesetService.IsRulesetSatisfied` | SDK 服务 | Core（引用集在盘，编译通过） | 两分支齐备 |
| `ClassIsland.Shared.Enums.ActionSetStatus`（FloatingWindowTrigger :50/:123/:147/:186） | SDK 枚举（ClassIsland.Shared\Enums\ActionSetStatus.cs） | Shared（引用集在盘，编译通过） | 两分支齐备 |
| `TriggerSettingsControlBase<T>` / `ActionSettingsControlBase<T>` / `TriggerBase<T>` / `ActionBase<T>` / `FluentIcon` / `FAContentDialog` | SDK 类型 | Core（编译通过） | 两分支齐备 |
| `IsBackgroundMaterialEnabled`（已知漂移点） | U3 源码存在 | **NuGet 二进制 ABSENT** | **B 档零消费（p2-05 实证，本批 grep 复核零命中）；禁引用遵守** |

### 3.2 G2 事实复核（D12 依据）

`ISystemEventsService` 接口仅 `TimeChanged` 一个事件（U3 源 ISystemEventsService.cs 全文阅读）；NuGet 二进制对 `SessionEnding`/`PowerModeChanged`/`add_SessionEnding` 字节检索全 ABSENT。宿主抽象确无会话结束/关机事件 → SystemShutdownMonitor 非 Windows no-op 护栏为唯一合规形态，不得假托宿主接口。

---

## 4. 接线需求清单（移交 p2-06 礼部唯一注册面；本批零注册面改动）

| # | 需求 | 源先例（源 Plugin.cs） | 备注 |
| --- | --- | --- | --- |
| W1 | `services.AddSingleton<FloatingWindowService>()` | :115 | 构造器 (MainConfigHandler, FloatingWindowProfileManager)，两者已在目标注册面（现 :103/:104） |
| W2 | FloatingWindowService.Start()（AppStarted，`EnableFloatingWindowFeature` 门） | :210-213 | 门成员已由本批增补（MainConfigData） |
| W3 | FloatingWindowService.Stop()（OnAppStopping，同门） | :1061-1064 | — |
| W4 | `IAppHost.GetService<FloatingWindowProfileManager>().MigrateFromLegacyConfig(GlobalConstants.MainConfig!.Data)`（AppStarted） | :207 | D14；目标 Plugin.cs:49 注释已预留此接线路径 |
| W5 | `_systemShutdownMonitor = new SystemShutdownMonitor(); .Start(); services.AddSingleton(_systemShutdownMonitor)` + 字段声明 | :125-127（字段 :56） | 非 Windows 分支 Start 为空实现（no-op 护栏），接线形态平台无关 |
| W6 | OnAppStopping：`IsSessionEnding` 读取 → `AdvancedShutdownAction.CancelPlanOnAppStopping(isSessionEnding)`（bool 传递）+ `systemShutdownMonitor.Dispose()` | :1034-1035/:1048/:1057 | D15；非 Windows 恒 false → 走"ClassIsland 主动退出"分支（源 :1055 语义）；p2-01 行动静态方法仅收 bool，与 p2-03 文件无编译耦合 |
| W7 | `RegisterShutdownRequestedHandler`：DesktopLifetime.ShutdownRequested → `MarkIfOsShutdown(args)` | :1070-1079 | 非 Windows 分支为空实现 |
| W8 | `RegisterActionIfEnabled<ShowFloatingWindowAction, ShowFloatingWindowSettingsControl>(services, config, "SystemTools.CrossPlatform.ShowFloatingWindow")` | :416-417 | — |
| W9 | `RegisterActionIfEnabled<ToggleFloatingWindowLayerAction, ToggleFloatingWindowLayerSettingsControl>(services, config, "SystemTools.CrossPlatform.ToggleFloatingWindowLayer")` | :418-419 | — |
| W10 | `RegisterTriggerIfEnabled<FloatingWindowTrigger, FloatingWindowTriggerSettings>(services, config, "SystemTools.CrossPlatform.FloatingWindowTrigger")` | :477-478 | 三件套随源先例（p1-02 形态） |
| W11 | 注册组门恢复：B11/B12 行动注册与触发器注册的源 `EnableFloatingWindowFeature` 包裹（:414/:475）、行动菜单悬浮窗设置组（:671-677）、悬浮窗编辑页条件注册（:182-185） | :414/:475/:671-677/:182-185 | 礼部口径（p1-06 §9-4/§9-6 恢复点归属），门成员已由本批增补 |
| W12 | A3/A4 窗口刷新路径回归注记：服务面现可用（ToggleWindowProfile/SwitchToProfile/SetWindowTheme/ToggleWindowTheme + 方案/主题消费） | p1-03 §7-5 预留 | 归属与时机由尚书省/p2-06 裁定；本批仅登记（禁区不触碰他批文件） |
| W13 | SystemMotionPreferences B 档零消费留痕（D11） | — | 供终检知悉；如尚书省裁定后续消费面（阶段 3 设置页动效选项）再行启用 |

---

## 5. macOS 兼容自检表（p1-05 §5.3 五列格式；覆盖本批全部新文件外部依赖点）

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | FloatingWindowService.cs（全文件） | Avalonia Window/Grid/StackPanel/Border/DispatcherTimer/Pointer 事件 | 逐行保留（Avalonia 跨平台层） | 可用（透明置顶层语义随平台 WM） |
| 2 | FloatingWindowService.cs:2310（新 :RecheckWindowLayer） | `PlatformServices.WindowPlatformService.SetWindowFeature`（Topmost/Bottommost） | 宿主抽象消费（p0-01 §3 #1，macOS 实装） | 可用；Stub 时回退 Avalonia Topmost 默认层级（§2 D3 写实） |
| 3 | FloatingWindowService.cs:2147（新 EnsureRulesetPatrol） | `ILessonsService.PostMainTimerTicked` | SDK 服务（保留） | 可用 |
| 4 | FloatingWindowService.cs:1068/:1087/:1146 | `IRulesetService.IsRulesetSatisfied` | SDK 服务（规则隐藏保留面） | 可用 |
| 5 | FloatingWindowTrigger.cs:50/:123/:186 | `ClassIsland.Shared.Enums.ActionSetStatus` | SDK 枚举（保留） | 可用 |
| 6 | FloatingWindowTriggerSettings.cs / ShowFloatingWindowSettingsControl.cs / ToggleFloatingWindowLayerSettingsControl.cs | `TriggerSettingsControlBase`/`ActionSettingsControlBase`/`FluentIcon`/`FAContentDialog` | SDK 控件（保留） | 可用（p1-01/p1-02 先例） |
| 7 | FloatingWindowTriggerConfig.cs | CommunityToolkit.Mvvm `[ObservableProperty]` | 包依赖（FloatingWindowProfile 同包先例，8.2.1 已引入） | 可用 |
| 8 | FloatingWindowService.cs（OnPointerMoved 鼠标路径） | `_window.BeginMoveDrag` | Avalonia 跨平台原生子句（源非捕获分支保留） | 可用（平台原生移动拖拽） |
| 9 | FloatingWindowService.cs（ClampToVisibleScreen 等） | `Screens`/`PointToScreen`/`PixelRect`/`RenderScaling` | Avalonia 跨平台（保留） | 可用 |
| 10 | FloatingWindowService.cs:2447 | 资源键 `SubtleFillColorSecondaryBrush`/`ControlFillColorSecondaryBrush` | 保留源形态（TryGetResource null 回退） | 可用（资源缺失时回退，仅视觉） |
| 11 | Services\SystemShutdownMonitor.cs `#else` 分支 | 无外部依赖（no-op 护栏） | 编译期分支（D12） | 可用（`IsSessionEnding` 恒 false；接线面走"主动退出"分支） |
| 12 | Services\SystemShutdownMonitor.cs Windows 分支 | WinForms 会话消息面（宿主 WindowsDesktop 引用面） | 条件文件形态 a 隔离（macOS 编译分支不含） | 不适用→降级（no-op），写实登记 |
| 13 | Views\SystemMotionPreferences.cs `#else` 分支 | 无外部依赖 | 编译期分支承载源运行时守卫语义 | 可用（`ShouldReduceMotion()` 恒 false，与源非 Windows 行为一致） |
| 14 | Views\SystemMotionPreferences.cs Windows 分支 | 原生互操作声明（系统动效查询） | 条件文件形态 a 隔离 | 不适用→降级（非 Windows 分支承载） |
| 15 | FloatingWindowService.cs（ResolveWindowThemeVariant 值 3） | 自适应主题采样（已降级） | D5：回退宿主明暗 | 可用（跟随宿主主题变体） |
| 16 | Actions\ShowFloatingWindowAction.cs:61 / ToggleFloatingWindowLayerAction.cs:66 | `IAppHost.GetService<SystemToolsNotificationProvider>()` | 跨批引用（p1-04 已交付） | 可用（先例 p1-03） |

**结论：16 项依赖点中 0 项"不适用"**（2 项 Windows 分支面按 R-2 条件文件口径登记为"不适用→降级"，属已批降级写实而非阻塞项）；无 Windows-only 架构进入共享路径；未发明宿主接口（消费面与 p0-01 §3 清单一致）。

---

## 6. S4.2 扫描与 Roslyn 自检留证

### 6.1 S4.2 扫描（p0-07 扫描器 R-2 版，零改动使用）

- 全树 Source 面：**168 文件、GateHits=0、ConditionalHits=13、InfoHits=2、VERDICT: PASS、exit=0**。原始输出：`evidence/p2-03-s42-fulltree-source-output.txt`（复核重放：`pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source`）。
- 本批条件文件单文件复扫（重放留证于 §6.1 输出末段同口径）：
  - `Services\SystemShutdownMonitor.cs`：GateHits=0、**CONDITIONAL=1（R03）**、exit=0；
  - `Views\SystemMotionPreferences.cs`：GateHits=0、**CONDITIONAL=2（R13、X04）**、INFO=2（I04，原生动效查询符号，非门禁）、exit=0。
- **R-2 CONDITIONAL 清单与 06 明示项对应核对（扫描器不承载业务裁定，本批自证）**：本批 3 处 CONDITIONAL = ①SystemShutdownMonitor.cs R03（06 条目 46 Windows 会话消息路径，R-4 口径，裁决 2 明示可交付）②③SystemMotionPreferences.cs R13+X04（B11 服务附属动效查询面，源 :27-31 随批交付，派工单明示）。全树其余 10 处 CONDITIONAL 属 **p2-01 并行批文件**（`Actions\SystemPowerCommandWindows.cs` 8 处、`Services\ProcessMemoryMaintenanceNativeWindows.cs` 2 处），非本批交付面，终检按其批证据核对。INFO 2 处均在本批 SystemMotionPreferences.cs（I04），非门禁，写实留证。

### 6.2 guard 形态与符号大小写实测

- 两条件文件首非空行/末非空行形态判定通过（形态 a）；扫描器识别 guard 计 CONDITIONAL，`#else` 分支零命中（从严口径符合）。
- 编译生效符号 = `Platforms_Windows`（CrossPlatformProps.props:37 注入；工部构建日志 /define: 集含 `Platforms_Windows` 实证）；扫描器 `-match` 大小写不敏感识别两种写法。交付采用编译生效形态，详见 §1.4（派工文本 `#if PLATFORMS_WINDOWS` 按扫描口径理解）。

### 6.3 Roslyn 批级补充编译自检（方法沿 p1-03 升级形态；非官方构建门禁）

- 脚本与输出：`evidence/p2-03-supplementary-compile-check.ps1`、`evidence/p2-03-supplementary-compile-check-output.txt`。
- 语境：引用集从工部 `p1-10-build-fallback-win-rerun.log` csc 命令行提取（**644 个 /reference: 全部在盘**，含 Avalonia/FluentAvalonia/ClassIsland SDK NuGet 双分支面与 Microsoft.WindowsDesktop.App 引用面——Windows TFM 实测含 System.Windows.Forms 引用，条件文件 Windows 分支编译语境成立）；预处理符号取自同一日志 /define: 集。
- **双向符号验证**（阶段 2 条件文件语境升级）：Pass A = Windows 符号集（含 `Platforms_Windows`）→ 条件文件 Windows 分支 + 全部交付文件编译；Pass B = 同集将 `Platforms_Windows` 换为 `Platforms_Linux`（并去 WINDOWS*）→ 条件文件 `#else` 分支 + 全部交付文件编译。**两 Pass 均 error=0（warning=148，全部为 CS1701 程序集统一与 CS8632 nullable 语境等检查语境产物——真实构建 csproj :22 `<Nullable>enable`、:23 `<ImplicitUsings>enable` 提供该语境，脚本未设）**，`COMPILE OK` exit=0。
- 编译文件集：12 交付 .cs + MainConfigData 增补段 + 同语境真实支撑集（MainConfigHandler/GlobalConstants/FloatingWindowProfile/FloatingWindowProfileManager/ButtonRulesetConfig/RowRulesetConfig）+ 检查专用存根（SystemToolsNotificationProvider 继承 SDK NotificationProviderBase 消费面 100% 真实——真实文件属 p1-04 批依赖链过深，沿 p1-03 存根先例；MVVM 生成成员存根 4 类型；隐式 using 存根）。官方三平台 dotnet build 门禁仍属阶段级验证（工部）。

### 6.4 结构核对重放命令（复核方）

```powershell
# 1) 9 个逐行文件归一化 diff（§1.7，应全 SAME——脚本内联于会话，逻辑如 §1.7 所述）
# 2) MainConfigData 增补段成员/守卫核对（§1.6）
Select-String -Path src\SystemTools.CrossPlatform\ConfigHandlers\MainConfigData.cs -Pattern 'p2-03 增补'
# 3) 条件文件形态 a 判定 + 全树扫描（§6.1 重放命令）
# 4) Roslyn 双向自检（§6.3）
& .tang\cases\stcp-cross-platform-001\evidence\p2-03-supplementary-compile-check.ps1
# 5) 双分支字节检索（§3.1 方法）
$b=[IO.File]::ReadAllBytes('C:\Users\0\.nuget\packages\classisland.platforms.abstractions\2.1.1.1\lib\net10.0\ClassIsland.Platforms.Abstractions.dll');([Text.Encoding]::ASCII.GetString($b)).Contains('SetWindowFeature')
# 6) 服务成员级对照（§1.5：源独有 34 = 降级面；目标独有 4 = 登记适配）
```

---

## 7. 边界声明

- 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读（读取/检索/字节检索，零写入）；NuGet 包字节级只读。
- 本任务写入仅限：本批落点 12 新文件（`src\SystemTools.CrossPlatform\{Actions,Controls,Settings,Config,Services,Views,Triggers}`）+ MainConfigData 预批段（含文件头 1 行 using）+ 本案 `evidence\`（本文件、p2-03-s42-fulltree-source-output.txt、p2-03-supplementary-compile-check.ps1/.txt）。
- **零改动**：Plugin.cs、manifest.yml、csproj、global.json、slnx、其他批文件（p2-02 MainConfigData 并行增补段原样保留、互不重叠；p2-01 并行条件文件未触碰）。p1-05 §1.3-2 "零 csproj 接线需求"预判成立（条件文件为源内条件编译，无需 csproj 项）。
- 派工约束遵守：IWindowPlatformService/SetWindowFeature/WindowFeatures 消费两分支齐备（§3.1）；IsBackgroundMaterialEnabled 零消费零引用；钩子子特性明示降级（D1/D2）；U5/R-6 液态玻璃与自适应采样降级（D4/D5/D6-D11）；R-4 no-op 护栏（D12）；不引入 RestartPropertyChanged（D13）；MigrateFromLegacyConfig/B5 看门狗接线需求登记移交 p2-06（D14/D15、§4）；禁改注册面（§4 全部 13 条均未在本批落地）。
- 本文件不推进、不审批全局工作流；属批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。

## 8. 修订记录

- 初版（p2-03 重派交付）。
