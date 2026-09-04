# p1-09 证据：A33 纳入后的映射基线更新（吏部 personnel / repository-governance / analysis）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-09 · 吏部 personnel · repository-governance / analysis（依赖 p1-01/p1-02/p1-03/p1-04/p1-06，均已 succeeded） |
| 权威输入 | p0-03-scope-mapping-baseline.md（62→61 映射、A33 清单、死代码注记、E-1/E-2）；p1-05 §6 落点闭合表与 §8 复核指引；p1-01/p1-02/p1-03/p1-04/p1-06 各批证据；04-spec §S4.1；实际文件树（`src\SystemTools.CrossPlatform\`） |
| 文件性质 | **p0-03 A 档映射的阶段 1 收口更新版**，作为阶段 2/4 的映射基线；B/C 档条目仍以 p0-03 §3.2/§3.3 为权威（本文件不重抄 B/C 明细，仅反向核验零迁入） |
| 结论速览 | **succeeded** —— A33 逐项更新闭合 **33/33**（源锚点 → 新落点 file:line → 交付批 → 注册状态）；**B19/C46 零提前迁入**（类型/符号级 0 命中，豁免/注记共 9 类逐条引证）；计数与 04-spec §S4.1 仍闭合（61=A15+B14+C32、98=A33+B19+C46）；死代码注记与 E-1/E-2 保留不变；p1-05 §8 六步复核重放全过 |
| 写入范围 | 仅本证据文件；新插件/宿主/源插件零改动（本轮对 `E:\My Github Projects\SystemTools` 与宿主检出**零直接访问**，源侧事实全部取自 p0-03/p0-02 已固化证据，新插件侧全部为只读检索） |

---

## 1. A33 逐项更新映射表（33/33，源锚点 → 新落点 → 交付批 → 注册状态）

口径：源锚点列引 p0-03 §1/§3.1/§4.2 与 p1-0X 批证据（1-based 行号）；新落点列为本轮对实际文件的**实测 file:line**（各 .cs 头部新增 XML doc 注记致锚点行较源 ±1–3 行，逐项以实测为准）；注册状态列给出 Plugin.cs 实测行区间与 p1-06 §2 对照行。行号以 2026-09-03 案卷工作区终态为准。

### 1.1 主题 3 项（落点 `Themes\<主题>\`；p1-01）

| 项 | 功能项 | 源锚点（p0-03/p1-01） | 新落点（实测） | 批 | 注册状态（Plugin.cs · p1-06 §2.1） |
| :-: | --- | --- | --- | :-: | --- |
| T1 | CardTypeComponent 主题 | 源 manifest.yml:1（id: Card-type-component）；注册源 Plugin.cs:79 | `Themes\CardTypeComponent\` 4 文件：manifest.yml:1（id 实测 `SystemTools.CrossPlatform.Card-type-component`）、Theme.axaml.txt、Styles.axaml、CardTypeComponentStyles.cs（URI 改写点 :13） | p1-01 | :65-76（AddXamlTheme，Id :69）· T1 行 |
| T2 | ClassWidgets 主题 | 源 manifest.yml:1（id: classwidgets）；Plugin.cs:91 | `Themes\ClassWidgets\` 9 文件：manifest.yml:1（id 实测）、Theme.axaml.txt、Styles.axaml、ClassWidgetsStyles.cs（:14）、ClassWidgetsCard.axaml:1（x:Class；:38/:53/:68 位图 URI）+ .axaml.cs + 上课/课间休息/无课程.png | p1-01 | :77-88（Id :81）· T2 行 |
| T3 | NotchStyle 主题 | 源 manifest.yml:1（id: notch-style）；Plugin.cs:103 | `Themes\NotchStyle\` 8 文件：manifest.yml:1（id 实测）、Theme.axaml.txt:7、Styles.axaml:2、NotchStyleStyles.cs（:13）、NotchClipControl/NotchFrameControl/NotchMaterialControl/NotchShapeGeometry 4 控件 | p1-01 | :89-100（Id :93）· T3 行 |

主题 manifest id 与 Plugin.cs ThemeManifest.Id 逐字符一致（3/3，本轮实测）。

### 1.2 组件 6 项（落点 `Controls\Components\` + `Models\ComponentSettings\`；p1-01）

| 项 | 功能项 | 源锚点 | 新落点（实测，ComponentInfo 首参 = p1-01 §3.4 新 GUIDv5） | 批 | 注册状态（Plugin.cs · §2.2） |
| :-: | --- | --- | --- | :-: | --- |
| C1 | 网络延迟检测 | 源 NetworkStatusComponent.axaml.cs:17-22 | `Controls\Components\NetworkStatusComponent.axaml.cs:17`（GUID `056130C1-2B02-5BBE-A99F-C5EC448D6221` 实测）+ 成对 4 文件 + `Models\ComponentSettings\NetworkStatusSettings.cs` | p1-01 | :266-267 · C1 行 |
| C2 | 显示剪切板内容 | 源 :14 | `...ClipboardContentComponent.axaml.cs:14`（`F3A18AE1-C153-5C1C-A660-D7E48DDDCC84`）+ 4+1 文件 | p1-01 | :268-269 · C2 行 |
| C3 | 本地一言 | 源 :23 | `...LocalQuoteComponent.axaml.cs:23`（`885F26B9-DC4E-5DBC-9C65-64C185E5A532`）+ 4+1 文件 | p1-01 | :270-271 · C3 行 |
| C4 | 下节课是 | 源 :14 | `...NextClassDisplayComponent.axaml.cs:14`（`0182775C-049B-532C-BF56-14FC3CEC02A1`）+ 4+1 文件 | p1-01 | :272-273 · C4 行 |
| C5 | 更好的轮播容器 | 源 :22 | `...BetterCarouselContainerComponent.axaml.cs:22`（`E6FC9A28-A104-50F2-95E3-B237F9CC4DAC`）+ 4+1 文件 | p1-01 | :274-275 · C5 行 |
| C6 | 滚动文本 | 源 :17 | `...ScrollingTextComponent.axaml.cs:17`（`E02A4DC6-88DE-551C-826F-A5262668AB3A`）+ 4+1 文件 | p1-01 | :276-277 · C6 行 |

6 组成对文件（*Component.axaml/.axaml.cs + *SettingsControl.axaml/.axaml.cs）与 6 设置模型全部在位（24+6 文件清点见 §4-1）；6 新 GUID 与 p1-01 §3.4 映射表逐值一致、两两互异。

### 1.3 规则 4 项（`Rules\` + `Rules\Handlers\` + `Controls\` 平铺设置控件；p1-02）

| 项 | 功能项 | 源锚点（p1-02 §1.1） | 新落点（实测） | 批 | 注册状态（Plugin.cs · §2.3） |
| :-: | --- | --- | --- | :-: | --- |
| R1 | 程序正在运行 | 源 Rules\ProcessRunningRuleSettings.cs:3-8（类型 :5）；Handlers\ProcessRunningRuleHandler.cs:8-30 | `Rules\ProcessRunningRuleSettings.cs:5`；`Rules\Handlers\ProcessRunningRuleHandler.cs:10`（static class）/:12（Handle）；`Controls\ProcessRunningRuleSettingsControl.cs`（裁决①增补） | p1-02 | :237-241（双参 AddRule）· R1 行 |
| R2 | 正在使用某课程表 | 源 UsingClassPlanRuleSettings.cs:3-9；Handler :11-26 | `Rules\UsingClassPlanRuleSettings.cs:5`；`Rules\Handlers\UsingClassPlanRuleHandler.cs:13`/:15；`Controls\UsingClassPlanRuleSettingsControl.cs` | p1-02 | :243-247 · R2 行 |
| R3 | 正在使用某时间表 | 源 UsingTimeLayoutRuleSettings.cs:3-9；Handler :11-26 | `Rules\UsingTimeLayoutRuleSettings.cs:5`；`Rules\Handlers\UsingTimeLayoutRuleHandler.cs:13`/:15；`Controls\UsingTimeLayoutRuleSettingsControl.cs` | p1-02 | :249-253 · R3 行 |
| R4 | 是否在某时间段 | 源 InTimePeriodRuleSettings.cs:3-12；Handler :11-27；控件 :1-47 + .axaml:1-28 | `Rules\InTimePeriodRuleSettings.cs:5`；`Rules\Handlers\InTimePeriodRuleHandler.cs:13`/:15；`Controls\InTimePeriodRuleSettingsControl.cs`（x:Class 实测 :1）+ `.axaml` | p1-02 | :255-259 · R4 行 |

### 1.4 触发器 1 项（三件套；p1-02）

| 项 | 功能项 | 源锚点（p1-02 §1.2） | 新落点（实测） | 批 | 注册状态（Plugin.cs · §2.4） |
| :-: | --- | --- | --- | :-: | --- |
| G1 | 行动进行时 | 源 Triggers\ActionInProgressTrigger.cs:1-92（TriggerInfo :14）；Config\...:1-21；Settings\...:1-45 | `Triggers\ActionInProgressTrigger.cs:18`（TriggerInfo，ID `SystemTools.CrossPlatform.ActionInProgressTrigger` 实测）；`Config\ActionInProgressTriggerConfig.cs:11`（class）；`Settings\ActionInProgressTriggerSettings.cs:11`（class） | p1-02 | :228-229（RegisterTriggerIfEnabled）· G1 行 |

### 1.5 行动 15 项（`Actions\` 平铺 + 附属；p1-03）

| 项 | 功能项 | 源锚点（p0-03 §3.1） | 新落点（实测 ActionInfo 行） | 批 | 注册状态（Plugin.cs · §2.5） |
| :-: | --- | --- | --- | :-: | --- |
| A1 | 退出进程 | KillProcessAction.cs:15 | `Actions\KillProcessAction.cs:14`（+ Settings\KillProcessSettings.cs、Controls\KillProcessSettingsControl.cs） | p1-03 | :177-178 · A1 行 |
| A2 | 拉起自定义Windows通知 | ShowToastAction.cs:11 | `:11`（+ Settings/Controls 同名对） | p1-03 | :179-180 · A2 行 |
| A3 | 切换悬浮窗配置方案 | ToggleFloatingWindowProfileAction.cs:17 | `:20`（+ Settings/Controls 对；D5 适配） | p1-03 | :184-185 · A3 行 |
| A4 | 切换悬浮窗主题 | SwitchFloatingWindowThemeAction.cs:15 | `:16`（+ Settings/Controls 对；D7 适配） | p1-03 | :186-187 · A4 行 |
| A5 | 后台播放音频 | BackgroundPlayAudioAction.cs:15 | `:13`（+ Settings/Controls 对；D9-1 守卫分支保留，新 :87） | p1-03 | :190-191 · A5 行 |
| A6 | 行动流执行确认 | ActionFlowExecutionConfirmationAction.cs:18 | `:18`（+ Settings/Controls 对） | p1-03 | :194-195 · A6 行 |
| A7 | 触发指定触发器 | TriggerCustomTriggerAction.cs:13 | `:13`（+ Settings/Controls 对；auto.json 对端 = G1） | p1-03 | :196-197 · A7 行 |
| A8 | 开关自动化 | ToggleWorkflowAction.cs:15 | `:15`（+ Settings/Controls 对） | p1-03 | :198-199 · A8 行 |
| A9 | 显示AI对话框 | ShowAiChatDialogAction.cs:9 | `:9`（无附属，源无设置类型） | p1-03 | :202-204（EnableAiService 门内，单参形态随源 :456）· A9 行 |
| A10 | 沉浸式时钟 | FullscreenClockAction.cs:10 | `:11`（+ Settings/Controls 对；D1/D2 → ILauncherService） | p1-03 | :208-209 · A10 行 |
| A11 | 清除全部提醒 | ClearAllNotificationsAction.cs:14 | `:14`（共享 ShortcutKeyNotificationSettings 对） | p1-03 | :212-213 · A11 行 |
| A12 | 加载临时课表 | LoadTemporaryClassPlanAction.cs:15 | `:15`（+ Settings/Controls 同名对） | p1-03 | :214-215 · A12 行 |
| A13 | 打开应用设置 | OpenAppSettingsAction.cs:14 | `:14`（共享 ShortcutKeyNotificationSettings 对） | p1-03 | :216-217 · A13 行 |
| A14 | 打开档案编辑 | OpenProfileEditorAction.cs:14 | `:14`（共享对） | p1-03 | :218-219 · A14 行 |
| A15 | 打开换课窗口 | OpenClassSwapWindowAction.cs:14 | `:14`（共享对） | p1-03 | :220-221 · A15 行 |

附属与共享类型实测在位（p1-03 §1.2/§1.3 清单）：`Settings\` 行动设置 11 文件、`Controls\` 平铺行动设置控件 11 文件、`ConfigHandlers\` 共享 6 文件（FloatingWindowProfile/FloatingWindowProfileManager/ButtonRulesetConfig/RowRulesetConfig/MainConfigData 裁剪形/MainConfigHandler）、`Shared\GlobalConstants.cs` 1 文件——全部计入 §4-1 树清点，无缺失、无多余。

### 1.6 服务/设置页聚合 4 项（A 聚合；p1-04 + p1-06）

| 项 | 功能项 | 源锚点 | 新落点（实测） | 批 | 注册状态（Plugin.cs · §2.6） |
| :-: | --- | --- | --- | :-: | --- |
| S1 | AI 文本链服务群（A9 主链 + 02 §2.6 支撑集） | 源 Services\AiChatWindowService.cs:1-66 等；DI 源 Plugin.cs:129-149 | `Services\` 11 文件（AiChatWindowService.cs 主构造 8 参 :9-17 实测，无 Vosk/采样参、ShowAsync :21；SystemToolsNotificationProvider.cs:9/:10/:14 新 GUID×3 实测 = 44BB7B21…/DD9150A5…/4BEE12E4…）+ `Views\AiChatFloatingWindow.axaml:1`（x:Class）+ `Controls\AiAttachmentDrop*` 4 + `Controls\Notifications\` 2 + `Models\` 2 | p1-04 | DI :106-115（EnableAiService 条件块 6 Singleton）+ 提供方去重注册 :119-126 · S1 行 |
| S2 | 虚拟放学服务 | 源 Services\VirtualAfterSchoolService.cs:1-299；Plugin.cs:124/:220/:1047 | `Services\VirtualAfterSchoolService.cs`（:62 ApplyConfig；:70/:79/:81/:94 消费 MainConfigData.VirtualAfterSchool* 实测） | p1-04 | :105（AddSingleton）+ :151-154（AppStarted→Start）+ :163（AppStopping→Stop）· S2 行 |
| S3 | 版本检查服务 | 源 Version\VersionCheckService.cs:1-109 | `Version\VersionCheckService.cs`（:94 导航 URI 实测 = `classisland://app/settings/SystemTools.CrossPlatform.settings.about`，与 p1-06 §4.3 契约逐字符一致） | p1-04 | :156（AppStarted→CheckAndNotify）· S3 行 |
| S4 | 设置页骨架 6 页 | 源 SettingsPage\ 6 页；Plugin.cs:175-187 | `SettingsPage\` 14 文件；6 页 SettingsPageInfo 实测：SystemToolsSettingsPage.axaml.cs:26 / MoreFeaturesOptions:18 / AiChat:33 / FloatingWindowEditor:21 / About:28 / PluginDebug:16；注册 id 全部 `SystemTools.CrossPlatform.settings.*` | p1-06 | :129-138（AddSettingsPageGroup :129；6×AddSettingsPage，aiChat 条件 :132-135）· S4 行 |

**闭合校验：3+6+4+1+15+4 = 33/33**，与 p1-05 §6、p1-06 §2、p0-03 §4.2 一致；每项注册形态均为启用开闭条件（IsActionEnabled/IsTriggerEnabled/IsComponentEnabled/IsRuleEnabled/EnableAiService，Plugin.cs :284-324 辅助方法）。

---

## 2. 计数与结构一致性（与 04-spec §S4.1 闭合）

### 2.1 规范计数闭合

| 校验项 | 规范要求（04-spec §S4.1 :45-57） | 本更新版实测 | 结论 |
| --- | --- | --- | --- |
| 主题 | 3（CardTypeComponent / ClassWidgets / NotchStyle），全 A | §1.1 = 3，全 A，全部落盘+注册 | ✅ |
| 组件 | 7 = 6 A + 1 C（歌词） | §1.2 = 6 A 落盘+注册；LyricsDisplay（C）零落点（§3） | ✅ |
| 规则集 | 5 = 4 A + 1 C（媒体播放） | §1.3 = 4 A 落盘+注册；MediaMusicPlaying（C）零落点（§3） | ✅ |
| 触发器 | 7 = 1 A + 1 B（悬浮窗触发）+ 5 C | §1.4 = 1 A 落盘+注册；FloatingWindowTrigger（B）+ 5 C 触发器零落点（§3） | ✅ |
| 行动 | 61 活动功能项 / 62 文件映射；15 A + 14 B + 32 C | §1.5 = 15 A 落盘+注册；14 B + 32 C 零落点（§3）；死代码注记保留（§2.3） | ✅ |
| 设置页 | 6，骨架 A | §1.6-S4 = 6 页骨架落盘+注册 | ✅ |
| AI 服务 | 文本链 A；语音族 C（SAPI + Vosk） | S1 文本链落盘+注册；KeywordSpeech/Vosk（C）零落点（§3） | ✅ |
| 总计 | A33 + B19 + C46 = 98 | **33（本表）+ 0（新插件内 B）+ 0（新插件内 C）= 33 已纳**；全案计数关系 61=A15+B14+C32、98=A33+B19+C46 无漂移 | ✅ |

### 2.2 A33 域分布与实际落点一致性

主题 3 + 组件 6 + 规则 4 + 触发器 1 + 行动 15 + 服务/设置页 4 = 33；逐域落点目录实测：`Themes\` 21 文件、`Controls\Components\`+`Models\ComponentSettings\` 30 文件、`Rules\`+`Rules\Handlers\` 8 文件、`Triggers\`+`Config\`+触发器 Settings 3 文件、`Actions\` 15 + 附属 22 文件、`Services\` 12 + `Version\` 1 + `Views\` 2 + `SettingsPage\` 14（+ AI 附属 8）——与 p1-05 §6 各行落点逐域吻合（§4-1）。

### 2.3 死代码注记与勘误保留声明（不变项）

1. **死代码注记（1 条，不计项）**：源 `Actions\ClickSimulationAction.cs` 整文件块注释死代码（p0-03 §2）。本更新版保留该注记与「62 文件 = 61 活动项 + 1 死代码」口径；新插件树 `ClickSimulation` 检索 **0 命中**（死代码未迁入，正确）。
2. **E-1（F11 映射勘误）保留**：`F11Action.cs` 为源侧独立活动文件（C6，本期不迁）；`BlackScreenHtmlAction.cs:64-67` 的 F11 注入属黑屏 html 行为。常用模拟键 6 源文件映射结论不变。新树 `F11Key|F11Action` 检索 0 命中（未迁入，正确）。
3. **E-2（禁用/启用硬件设备依据勘误）保留**：C24/C25 依据为 Windows PowerShell PnP cmdlet + UAC 提权（非 WMI），档位 C 不变。新树 `DisableDevice|EnableDevice` 检索 0 命中（未迁入，正确）。

---

## 3. B/C 零提前迁入反向核对（以 p0-03 B19/C46 清单为据，对实际文件树）

方法：对 `src\SystemTools.CrossPlatform\` 全树（排除 bin/obj，152 文件：*.cs/*.axaml/*.txt/*.yml/*.png/*.csproj/*.yml）按 p0-03 B/C 条目的**类型名/文件名特征**与 **Windows 专属机制符号**做关键词组检索，全部命中逐条人工归类。

### 3.1 类型/文件级检索（B19 + C46 全清单特征名）

| 组 | 覆盖的 B/C 条目（p0-03 口径） | 特征关键词 | 命中 |
| --- | --- | --- | --: |
| B 行动·文件/电源（B1-B10） | 复制/移动/删除/计时关机/高级计时关机/取消关机/锁屏/立即重启/立即关机/睡眠 | CopyAction、CopySettingsControl、MoveAction、MoveSettingsControl、DeleteAction、DeleteSettingsControl、AdvancedShutdown、CancelShutdown、ShutdownAction、ShutdownSettingsControl、ImmediateRestart、ImmediateShutdown、LockScreen、SleepAction、SleepSettingsControl、SystemShutdownMonitor | **0** |
| B 行动·悬浮窗（B11-B14） | 显示悬浮窗/切换悬浮窗层级/自动切换 ClassIsland 主题/遮挡隐藏主界面 | ShowFloatingWindowAction、ShowFloatingWindowSettings、ToggleFloatingWindowLayer、AutoSwitchClassIslandTheme、AutoHideMainWindowWhenOccluded | **0** |
| B 触发器 1 | 从悬浮窗触发 | FloatingWindowTrigger | **0** |
| B 服务 4 | 悬浮窗经典外观/自适应主题/遮挡 OCR/ClassIsland 内存 GC | FloatingWindowService、AdaptiveThemeSyncService、MainWindowTextOcclusionService、ClassIslandMemoryAutoCleanupService | **0** |
| B 配置成员 | EnableFloatingWindowFeature | EnableFloatingWindowFeature | 2（均为注记，见 §3.3-e） |
| C 行动·输入模拟（C1-C13） | Alt+F4/Alt+Tab/Ctrl+Z/Enter/Esc/F11/模拟键盘/组合键/鼠标/键入内容/窗口操作/禁用/启用鼠标 + 死代码 ClickSimulation | AltF4、AltTab、CtrlZ、EnterKey、EscKey、F11Key、SimulateKeyboard、SimulateKeyCombination、SimulateMouse、TypeContent、WindowOperation、DisableMouse、EnableMouse、ClickSimulation | **0** |
| C 行动·显示/桌面（C14-C20） | 复制/扩展/仅电脑/仅第二屏幕/黑屏html/显示桌面/调整亮度 | CloneDisplay、ExtendDisplay、InternalDisplay、ExternalDisplay、BlackScreenHtml、ShowDesktop、AdjustScreenBrightness | **0** |
| C 行动·个性化/硬件（C21-C26） | 壁纸/主题色/强调色/禁用设备/启用设备/U盘自动打开 | ChangeWallpaper、SwitchTheme、SwitchSystemAccentColor、DisableDevice、EnableDevice、AutoOpenUsbDriveOnInsert | **0** |
| C 行动·语音（C27-C28） | 启用语音唤醒 AI/唤醒语音对话 AI | EnableVoiceWakeAi、WakeUpVoiceConversationAi、AiVoiceConversation | **0** |
| C 行动·截图/音量/摄像头/提权（C29-C32） | 屏幕截图/设置音量/摄像头抓拍/重启为管理员 | ScreenShot、SetVolume、CameraCapture、RestartAsAdmin | **0** |
| C 组件 1 | 音乐软件歌词显示 | LyricsDisplay | **0** |
| C 规则 1 | 正在播放媒体音乐 | MediaMusicPlaying | **0** |
| C 触发器 5 | 热键/关键词/长时空闲/点击主界面/USB 插入 | HotkeyTrigger、HotkeyService、HotkeyRecorder、KeywordTrigger、LongIdleTrigger、MainWindowClick、UsbDeviceTrigger | **0** |
| C 服务/认证 7 | UsbAutoPlay/关键词语音(SAPI)/Vosk/人脸/Hello/系统内存清理/背景截图采样 | UsbAutoPlayService、KeywordSpeech、Vosk、FaceRecognition、WindowsHello、SystemMemoryCleanup、MainWindowBackgroundCapture、BackgroundLuminance、SpeechRecognitionDependencyPrompt | **0** |
| U5 玻璃族（C 候选/R-6） | LiquidGlass 构造/AiChatGlassSurface/ThirdParty | LiquidGlass、AiChatGlassSurface、ThirdParty | 1（注记，§3.3-a） |
| 其他未迁构造 | DependencyPaths/InjectServices/ThemeBannerCache/AboutTitleImageCache/ClassIslandSettingsService/MainWindowAreaService/ExperimentalBadge/SettingsPageLazy | 同左 | 3（均注记，§3.3-c） |

### 3.2 机制符号级检索（Win32/WMI/注册表/CoreAudio/命令）

| 组 | 特征关键词（p0-03 §3.2/§3.3 依据摘要） | 命中 | 归类 |
| --- | --- | --: | --- |
| Win32 注入/提权/窗口 | keybd_event、mouse_event、SetWindowsHookEx、RegisterDeviceNotification、ExitWindowsEx、RtlAdjustPrivilege、LockWorkStation、SetSuspendState、SetWindowPos、SystemParametersInfo、CopyFromScreen、WindowsIdentity、WindowsPrincipal | **0** | — |
| Windows 命令/资产 | rundll32、powrprof、user32.dll、DisplaySwitch、robocopy、tasklist、taskkill、shutdown、black.html、ffmpeg、jinyongshubiao、huifu | 1（注记：SystemToolsSettingsPage.axaml.cs:22 注释「ffmpeg/人脸/语音识别下载等 B/C 档面不迁入」，§3.3-c） | 注记 |
| UAC 字面量 | runas | 5（全部为 `RunAsync` 的子串误报——大小写不敏感匹配 "RunAs**y**nc" 前缀，非 UAC 提权调用；已逐条目视核实） | 误报 |
| WMI/注册表 | ManagementScope、ManagementObjectSearcher、System.Management、root\wmi、Control Panel、DWM、AppsUseLightTheme、AccentColor | 3（全部为 `Theme.axaml.txt` 中 Avalonia `DynamicResource SystemAccentColor` 主题资源键——x:Key 随源不改（p1-05 §3.4-3），非 Windows 注册表 DWM AccentColor） | 资源键随源 |
| Core Audio | IMMDevice、IAudioEndpointVolume、IAudioClient | **0** | — |
| 平台守卫/分叉 | OperatingSystem.Is*()、`#if` | 2 = `BackgroundPlayAudioAction.cs:87` + `BackgroundPlayAudioSettingsControl.cs:149`（p1-03 D9 保留的 A5 守卫分支，04-spec §S4.2 明示允许）；零 `#if`、零平台目录 | 已批豁免 |
| 资产文件 | `.bat`/`.ps1`/`.exe`/`.html` 文件实体 | **0**（树中无任何此类文件） | — |
| 禁止目录 | VoskWorker\、ThirdParty\、Platforms* | **0** | — |

### 3.3 命中归类与豁免清单（逐条引证）

全部非零命中均为**注记文本、已批豁免面或误报**，无一代码引用、无 B/C 类型/文件实体：

- **a. 共享类型 A 档裁剪形（p1-05 §2.3-2/§2.3-4，p1-03 §1.3，p1-04 §4，p1-06 §5）**：`ConfigHandlers\` 6 文件 + `Shared\GlobalConstants.cs` 为已批共享引入。MainConfigData 实测 269 行仅含 A 档成员（悬浮窗方案/主题状态、行动流确认位置、虚拟放学 3、AI 链 4+2、Enabled* 字典与 Is*Enabled 辅助），B/C 成员零引入；`MainConfigData.cs:92` 注释为 p1-04 留痕「源 AI 液态玻璃成员不增补」（p1-06 §7-2 已登记，非门禁规则、非类型引用）。
- **b. 已批降级/替代面（各批证据口径）**：A5 两处 `OperatingSystem.IsWindows()` 守卫分支保留（p1-03 D9，04-spec §S4.2 允许项）；A1 taskkill 死代码已删除（p1-03 D4，新树 taskkill/tasklist 0 命中）；A10 Process.Start→ILauncherService（p1-03 D1/D2，新树无 Process.Start 打开 URL 残留语义）；ProcessRunningRuleSettingsControl tasklist→BCL Process.GetProcesses（p1-02 A12，新树 tasklist 0 命中）。
- **c. 注释级留痕（4 处，均为"说明不迁入"的文档性文本，非代码引用）**：`Plugin.cs:63`（ThemeBannerCacheService 核减注记，p1-06 §9-2）；`AboutSettingsPage.axaml:11` 与 `.axaml.cs:24`（AboutTitleImageCacheService 题图/帮助 B/C 面不迁注记）；`SystemToolsSettingsPage.axaml.cs:22`（ffmpeg/人脸/语音下载 B/C 面不迁注记，p1-06 §9-7）。
- **d. B 成员名注记（2 处）**：`Plugin.cs:381` 与 `SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs:17` 注释——「源以 EnableFloatingWindowFeature（B 档成员，阶段 1 裁剪形未引入）为组门/条件」，与 p1-06 §9-4/§9-6 差异登记逐字对应；该成员在新插件配置根中**不存在**（MainConfigData 实测无此属性），仅有注册面差异说明。
- **e. 资源键随源**：`Theme.axaml.txt` 3 处 `SystemAccentColor` 为 Avalonia DynamicResource 主题键（p1-05 §3.4-3 x:Key 随源不改），与 Windows 注册表强调色（C23）无关。
- **f. 字体写实（2 处）**：`Controls\KillProcessSettingsControl.cs:52` 与 `SettingsPage\AiChatSettingsPage.axaml:38` 的 `"Segoe Fluent Icons,Segoe MDL2 Assets"` 字体串——p1-03 §4 #18 已登记降级写实（macOS 缺字回退默认字形，仅视觉提示）；属显示文案随源口径，非 Windows API 依赖。
- **g. 附件类型过滤常量（1 处）**：`Services\AiAttachmentService.cs:54` 的 `*.ps1/*.bat/*.cmd` 等为源保留的文件选择器类型过滤模式串（附件类型约束行为），非 .bat/.ps1 资产落地（§3.2 已证树中零此类文件）。
- **h. 误报澄清**：`runas` 5 命中全部为 `RunAsync`（Avalonia 动画 API）子串误报；`AccentColor` 3 命中见 e。

**结论：B19/C46 零提前迁入成立。** 新插件不存在任何 B/C 功能项的类型、文件、注册身份或机制符号实体；全部非零命中可逐条追溯至已批共享/降级/留痕口径。无「未申报迁入」需上报事项。

---

## 4. 仓库结构收尾核对（p1-05 §8 六步复核重放，2026-09-03 案卷会话）

### 4-1 树核对

实测全树 **152 文件**（排除 bin/obj；114 .cs + 4 .yml + 1 .csproj + 其余 axaml/txt/png）。逐目录：Actions 15、Config 1、ConfigHandlers 6、Controls 46（Components 24 + 平铺 16 + Notifications 2 + AiAttachmentDrop* 4）、Converters 1、Models 8（AiAttachment/AiConversation 2 + ComponentSettings 6）、Rules 8、Services 12、Settings 12、SettingsPage 14、Shared 1、Themes 21、Triggers 1、Version 1、Views 2 + 根 3（Plugin.cs / manifest.yml / csproj）。

**批次归属清点**（每文件唯一归入 p1-05 §2.2 一批）：p1-01 = 52（Themes 21 + Components 24 + ComponentSettings 6 + Converters 1）；p1-02 = 16（Rules 8 + Triggers 1 + Config 1 + Settings\ActionInProgressTriggerSettings 1 + Controls 平铺 5）；p1-03 = 44（Actions 15 + Settings 11 + Controls 平铺 11 + ConfigHandlers 6 + Shared 1）；p1-04 = 23（Services 12 + Views 2 + Notifications 2 + AiAttachmentDrop* 4 + Models 2 + Version 1 —— 含 Version 目录 1，合计 23）；p1-06 = 14（SettingsPage）+ Plugin.cs 重写；p0 脚手架 = manifest.yml + csproj。52+16+44+23+14+3 = **152** ✓。与各批证据声明文件数逐一相符（p1-01 §交付点 52、p1-02 §0 16、p1-03 §0 44、p1-04 §1 23、p1-06 §0 SettingsPage 14）。

### 4-2 命名空间核对

`namespace (?!SystemTools\.CrossPlatform)` 对 114 个 .cs 全树检索：**0 命中**（含 `SystemTools.` 裸前缀零命中）✓（p1-05 §8-2 预期一致）。

### 4-3 ID 前缀核对

`"SystemTools\.` 全树检索（.cs/.axaml/.yml）：**全部命中均为 `SystemTools.CrossPlatform.` 形态**——行动 ActionInfo 15、触发器 TriggerInfo 1、组件/规则/行动注册与菜单树（Plugin.cs）、设置页 SettingsPageInfo 6 + [Group] 6 + 分组 id 1、主题 ThemeManifest.Id 3、x:Class/clr-namespace 面、manifest.yml:14 `entranceAssembly: SystemTools.CrossPlatform.dll`、AiConversationStore.cs:27 回退目录名、2 处插件目录路径（AiChatSettingsPage.axaml.cs:51、SystemToolsSettingsPage.axaml.cs:42）。**源插件形态 ID 字符串（`"SystemTools.<Name>` 不含 CrossPlatform 段）零出现** ✓（p0-05 §4.2 前缀空间不相交前提保持）。

### 4-4 注册面核对

git.exe 在本会话沙箱不可用（命名管道边界，子进程启动被拒，与 p1-02 §5.1/p1-06 §7 报告的沙箱边界同源；工作区亦无 .git 元数据目录）→ 以**内容级核验**替代 git diff：

1. Plugin.cs 本轮逐行读取（480 行），内容与 p1-06 §1/§2/§3/§4 声明逐段一致（33 项注册 + DI 接线 + 菜单树 + 生命周期钩子），无兵部四批或 p1-05 期的注册痕迹混入；
2. p1-01 §8 / p1-02 §6 / p1-03 §8 / p1-04 §9 / p1-05 §9 均书面声明零写 Plugin.cs / csproj / manifest.yml / global.json / slnx；
3. manifest.yml 字节不变：p1-06 §8 SHA256 `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC` 与 p0-05 基线一致；
4. csproj 为 p0 脚手架形态：本轮全树扫描 CommentOnly=6 全部为 csproj:79 既有注释（p0-07 分类非门禁）。

**结论：注册面唯一写入者 = 礼部 p1-06 成立（证据级核验）。**

### 4-5 门禁重放

本轮对 `src\SystemTools.CrossPlatform` 全目录复跑 p0-07 扫描器（-Scope Source，2026-09-03T18:43:18Z）：**SourceFiles=119、GateHits=0、InfoHits=0、VERDICT: PASS、exit=0**（CommentOnly=6：csproj:79 禁用包清单注释，非门禁命中，与 p1-06 §7-1 终态记录一致）。各批留档 `p1-0X-s42-scan-output.txt` 与本轮全树复跑交叉一致。

### 4-6 A33 闭合清点

§1 表逐批清点：p1-01 = 3 主题 + 6 组件 = 9；p1-02 = 4 规则 + 1 触发器 = 5；p1-03 = 15 行动；p1-04 = 3 服务（AI 文本链/虚拟放学/版本检查）；p1-06 = 1（设置页骨架聚合）。**9+5+15+3+1 = 33/33**；每项源锚点可回查 p0-03 §1/§3.1/§4.2 清单行，新落点与注册行可由本表 file:line 直接重放。

---

## 5. 与 p0-03 基线的差异追溯（全部差异可追溯）

| 差异类型 | 内容 | 追溯 |
| --- | --- | --- |
| 状态列更新 | A 档 33 项由「待迁移」→「已落盘 + 已注册」，新增 3 列（新落点 file:line / 交付批 / 注册状态） | 本文件 §1（逐项实测） |
| 新落点行号位移 | 兵部/礼部抽取在各 .cs 头部新增 XML doc 注记，锚点行较源 ±1–3 行（如 A1 :15→:14、A3 :17→:20、A10 :10→:11；适配删除行致 A5 :15→:13） | §1.5 实测列；适配依据 p1-03 §2 |
| 零档位/计数漂移 | 61=A15+B14+C32、98=A33+B19+C46、A33 域分布 3+6+4+1+15+4 全部维持 | §2.1/§2.2 |
| 死代码注记 / E-1 / E-2 | 保留不变，且经新树反向核对佐证（ClickSimulation/F11/设备管理类 0 命中） | §2.3 |
| GUID 面新增映射 | 组件 6 + 通知提供方 3 处 GUID 形态身份为新值（源 GUID 零重合） | p1-01 §3.4、p1-04 §3-5（本表 §1.2/S1 实测同值） |
| B/C 档条目 | 未迁入、未改档、未改计数；p0-03 §3.2/§3.3 仍为权威 | §3 |

---

## 6. 边界声明

- 本任务唯一写入 = 本证据文件；`src\` 产品文件、Plugin.cs、manifest.yml、csproj、各批交付物**零改动**。
- 源插件 `E:\My Github Projects\SystemTools` 与宿主检出本轮**零直接访问**；源侧事实（源锚点、B/C 清单、死代码注记、E-1/E-2）全部取自 p0-03/p0-02 已固化证据，新插件侧事实全部来自本轮只读检索/扫描（15 组重放命令）。
- git.exe 受沙箱命名管道边界限制不可用，§4-4 以内容级核验替代（已注明）；三平台构建门禁属阶段级验证，不在本任务范围（p1-05 §5.2-3）。
- 本文件不推进、不审批全局工作流；仅向尚书省回报 p1-09 结果，供门下省终验与阶段 2/4 映射基线引用。
