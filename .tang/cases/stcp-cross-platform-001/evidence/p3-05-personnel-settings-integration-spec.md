# p3-05 证据：阶段 3 设置与配置整合结构方案（吏部 personnel / repository-governance / analysis，先于实施）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-05 · 吏部 personnel · repository-governance / analysis（阶段 3；依赖 none；先于兵部接线批与礼部差异文档批） |
| 权威输入 | 05-phased-development.md 阶段 3 行（6 设置页 A/B/C 选项归属 + 独立配置/功能命名空间 + 同装差异说明）；06-migration-details-proposal.md 条目 33（六页骨架边界）、条目 86（C 依赖下载面）、条目 70/76-79/80-84（C 裁剪依据）；p2-09 §1/§2.2/§5/§6（映射基线与注册行实测）；p2-05 §2.1（MainConfigData B 档成员增补清单与"明确不增补"清单）；p2-03 增补段（MainConfigData.cs:304-520，B 档 14 成员现态）；p1-06 §4/§9（6 页骨架现态与报备口径）；p2-06 §4-3/§5（注册门恢复与菜单组）；p1-05 §3/§4.2/§5.1（命名空间体系/交接格式/平台条件规范）；p1-10 §12.5（双分支 API 漂移）；源插件 `E:\My Github Projects\SystemTools\SettingsPage\`（只读先例，6 页完整形态） |
| 文件性质 | 阶段 3 落点/裁剪/命名空间结构方案（文档性产出，先于抽取）：约束 B 档选项接线落点、C 档裁剪面、命名空间核对结论、同装差异文档大纲与约束落点；不预写函数体、不指定控件树逐行实现、不改变已批决议 |
| 写入范围 | 仅本证据文件；`src\` 产品文件、源插件检出、宿主检出全程只读；零产品文件改动 |
| 结论 | **succeeded** —— ①6 页 B 档接线落点 18 项（p3-01 主页 2 + 更多功能选项页 3；p3-02 悬浮窗编辑页 13；AiChat/About/PluginDebug 三页 0），两批按"页"为粒度互斥、零冲突（§2/§7）；②C 档裁剪移除面 21 项，逐项带源锚点 + 现骨架零残留核对 + 已批裁剪依据；零 C 档功能本体误伤（§3/§3.4）；③命名空间统一 = **零调整**（163 .cs / 22 唯一值全部镜像目录，XAML 面零违例，p1-05 §3 体系全核对通过）（§4）；④同装差异说明文档大纲 5 节齐备、逐节引证批登记条目（§5）；⑤约束落点 2 项登记（§6） |

---

## 0. 效力、范围与冲突规则

1. 本方案约束阶段 3 各实施批（兵部 p3-01/p3-02 设置页接线、礼部 p3-06 同装差异文档）的**接线落点与裁剪面**；功能范围与行为以 04-spec/05 合同阶段 3 行及 06 已批条目为权威。
2. 兵部两批互斥分配（阶段 3 执行计划既定）：**p3-01 = SystemTools 主设置页 + MoreFeaturesOptions 页；p3-02 = AiChat / FloatingWindowEditor / About / PluginDebug 四页**。本方案以"页"为粒度逐项标注归属批，同一页面文件（.axaml/.axaml.cs/页属 VM）只归属一个批次；§2 全表零跨批重叠。
3. 阶段 2 已交付的配置根成员（MainConfigData 17 个 B 档成员，§1.2）与共享类型（FloatingWindowProfileManager、ButtonRulesetConfig/RowRulesetConfig、AiAttachmentDrop* 等）由两批**只读消费**，阶段 3 零增补需求时不得改写 MainConfigData（p1-05 §2.3-4 流程仅在确需新成员时触发）。
4. 与 04-spec/05/06/p1-05 冲突时以后者为准并回报尚书省修订本方案。

## 1. 现状基线（实测，2026-09 本轮）

### 1.1 六页骨架现态（注册行 = Plugin.cs 实测）

| # | 页面 | 注册 id（现态） | 注册门（现态） | 骨架现内容（新落点锚点） | 源页形态（差异概述） |
| :-: | --- | --- | --- | --- | --- |
| 1 | SystemToolsSettingsPage | `SystemTools.CrossPlatform.settings.main`（Plugin.cs:161） | 无条件（随源） | AI 服务选项组（axaml :13-67；开关+协议对话框 axaml.cs:58-85/:133-174）＋「更多功能选项」导航（axaml :69-74） | 源页另有：启用功能选项抽屉（axaml :167-176/:21-149）、悬浮窗功能开关（:199-206）、实验性功能（:179-186，C）、启用扩展功能+下载（:318-412，C）、AI 组 C 项（:263-315） |
| 2 | MoreFeaturesOptionsSettingsPage | `SystemTools.CrossPlatform.settings.more`（:162） | 无条件（随源 :15 hideDefault） | 仅虚拟放学组（axaml :12-46；ApplyConfig axaml.cs 沿源 :50-59 形态） | 源页另有：自动主题（:17-24）、遮挡隐藏（:26-33）、ClassIsland 内存（:72-79）三个 B 组；管理员内存（:81-116，C）、USB 自动播放（:118-123，C） |
| 3 | FloatingWindowEditorSettingsPage | `SystemTools.CrossPlatform.settings.floating`（:171，门 :169 `EnableFloatingWindowFeature == true`，p2-06 §4-3 恢复） | 条件（随源 :182-185） | 仅配置方案选择组（axaml :12-28，经共享 SystemToolsSettingsViewModel.cs:32-73 方案面） | 源页含按钮布局编辑器（:42-197）、外观设置（:199-417，含液态玻璃 C 面 :210-295）、层级（:419-467）、按规则隐藏（:469-486） |
| 4 | AiChatSettingsPage | `SystemTools.CrossPlatform.settings.aiChat`（:165，门 :163 `EnableAiService`） | 条件（随源 :178-181） | 对话结构 + 共享回复开关 + 附件文件选择器（axaml :10-133；VM 契约 p1-06 §4.2） | 源页另有语音按钮（:423-443，C）、拖放遮罩（:478，接线待阶段 3）、消息编辑 UI（:185-237，A 面接线待阶段 3） |
| 5 | AboutSettingsPage | `SystemTools.CrossPlatform.settings.about`（:173） | 无条件（随源） | 插件信息卡（连击 5 次进调试页）+ 反馈链接 + 帮助/介绍/更新日志（axaml :13-153） | 源页另有题图头（:28-51，AboutTitleImageCacheService 不迁）、Lyricify Lite 帮助（:154-159，C 面不迁） |
| 6 | PluginDebugSettingsPage | `SystemTools.CrossPlatform.settings.pluginDebug`（:174） | 无条件（随源） | 零绑定占位（axaml :9-18，p1-06 §4.1：源页全为 U5 降级面） | 源页 = 液态玻璃调试全参数体（:25-362）+ 审批按钮玻璃（:289-356）+ 语音唤醒调试（:367 起） |

### 1.2 配置根现态（MainConfigData.cs，553 行；阶段 3 只读消费基线）

- **B 档成员 17 个**：p2-03 增补 14 个（7 组，增补段 :304-520）——`EnableFloatingWindowFeature` :332 / `ShowFloatingWindow` :346 / `FloatingWindowScale` :360 / `FloatingWindowTextSize` :375 / `FloatingWindowIconSize` :390 / `FloatingWindowOpacity` :405 / `FloatingWindowShadowEnabled` :420 / `FloatingWindowDragHandleAlwaysVisible` :434 / `FloatingWindowPositionX` :448 / `FloatingWindowPositionY` :462 / `FloatingWindowLayer` :476 / `FloatingWindowLayerRecheckMode` :491 / `FloatingWindowRulesetEnabled` :506 / `FloatingWindowRuleset`（Ruleset 型）:517-518；p2-02 增补 2 个——`AutoSwitchClassIslandTheme` :252 / `AutoHideMainWindowWhenOccluded` :266；p2-01 增补 1 个——`AutoCleanupClassIslandMemory` :291。JSON 名随源、守卫语义随源（p2-05 §2.1 预批清单全部兑现）。
- **A 档成员（页绑定既有）**：基础 3 个（`FloatingWindowTheme` :24 / `CurrentFloatingWindowProfile` :39 / `FloatingWindowHorizontal` :65）+ p1-04 七个 + p1-06 两个（`AiProviderName` :211 / `ShareAiRepliesWithClassIslandNotifications` :226）。
- **明确不增补成员（U5/C，零存在）**：`EnableExperimentalFeatures`、`EnableFfmpegFeatures`、`EnableFaceRecognition`、`EnableWindowsHello`、`AutoOpenUsbDriveOnInsert`、`AutoCleanupSystemMemory`、`SystemMemoryCleanupThresholdPercent`、`LyricifyLiteWarningDismissed`、AI 语音成员、液态玻璃 3 成员（`FloatingWindowAppearanceStyle`/`FloatingWindowLiquidGlass`/`FloatingWindowGlassButtonScaleDip`，不增补注记 :325-327）——p2-05 §2.1 清单全部兑现（p2-09 §3.3 复核一致）。

## 2. 6 设置页 B 档选项接线落点表（18 项；页粒度互斥）

口径：**接线项** = 需在现骨架上新增/补全的 B 档设置控件、绑定或选项组（每行给源锚点 + 新落点 + 接线注记）。阶段 2 已交付的配置成员/服务由接线消费，零新成员增补需求。落点行号为本轮实测现态，实施时在锚点区间内插入，行号允许位移。

### 2.1 p3-01 批（2 页，5 项）

| # | 页面·接线项 | 档位依据 | 源锚点（源插件） | 新落点（现骨架） | 接线注记 |
| :-: | --- | --- | --- | --- | --- |
| W1 | 主页 · 「启用功能选项」管理抽屉（expander + 右侧 DrawerHost + DataGrid + 应用并重启） | A/B 共用启用管理面（05 阶段 3 行"A/B/C 选项归属"；非计数项） | 源 SystemToolsSettingsPage.axaml:167-176（expander）、:21-149（DrawerHost 抽屉模板）、源 axaml.cs:524-558（开抽屉/搜索/保存）；源 VM :174/:337/:359 | SystemToolsSettingsPage.axaml（现有 :13-74 两组之间/之前随源相对序插入 expander；抽屉模板挂页根 DrawerHost） | 清单枚举必须仅覆盖 A+B 已迁功能项（注册面 52 项口径，p2-09 §5-6）；C 条目零呈现。重启按钮走 `SettingsPageBase.RequestRestart()`（p1-06 §6-8 口径），不得迁源 `RestartClassIsland()`（:773，Win 进程替换路径） |
| W2 | 主页 · 「启用悬浮窗功能」开关组 | B（成员 `EnableFloatingWindowFeature`，MainConfigData.cs:332） | 源 SystemToolsSettingsPage.axaml:199-206；源 axaml.cs:88 OnFloatingFeatureToggleClick | SystemToolsSettingsPage.axaml（插于「更多功能选项」导航 :69-74 与「AI 服务」:13 之间，随源相对序 :199 位于 :191/:208 之间） | 写配置 + Save + `RequestRestart()`（p1-06 §9-7 等价口径；源 RestartPropertyChanged 事件不迁，p2-05 §2.1 决策注记裁定②）。开关 false→true 后行动/触发器/设置页注册门语义与源一致（注册门为启动期） |
| W3 | 更多功能选项页 · 「自动切换 ClassIsland 主题」开关组 | B13（成员 :252；服务面 p2-02 S-主题） | 源 MoreFeaturesOptionsSettingsPage.axaml:17-24；源 axaml.cs:26-36（AdaptiveThemeSyncService.ApplyConfig + Save） | MoreFeaturesOptionsSettingsPage.axaml（插于虚拟放学组 :12-46 之前，随源序） | 事件处理器形态随源 axaml.cs:26-36；服务类型与生命周期已由 p2-02 交付（p2-09 §1.3 S-主题行） |
| W4 | 更多功能选项页 · 「主界面遮挡文字时」开关组 | B14（成员 :266；服务面 p2-02 S-遮挡） | 源 axaml:26-33；源 axaml.cs:61-70（MainWindowTextOcclusionService.ApplyConfig） | 同页（插于 W3 与虚拟放学组之间，随源序） | 同上；新签名 `Shutdown(bool)` 不影响 ApplyConfig 消费（p2-09 §1.3 S-遮挡行） |
| W5 | 更多功能选项页 · 「自动清理 ClassIsland 内存」开关组 | B/项 49（成员 :291；服务面 p2-01 S-内存） | 源 axaml:72-79；源 axaml.cs:72-82（ClassIslandMemoryAutoCleanupService.ApplyConfig） | 同页（插于虚拟放学组之后，随源序 :72 位于 :35 与 :81 之间） | 同上；GC 链三平台 + 工作集仅 Windows 语义随 p2-01 交付（p2-09 §1.3 S-内存行） |

### 2.2 p3-02 批（悬浮窗编辑页 13 项；AiChat/About/PluginDebug 三页 0 项）

| # | 页面·接线项 | 档位依据 | 源锚点（源插件） | 新落点（现骨架） | 接线注记 |
| :-: | --- | --- | --- | --- | --- |
| W6 | 悬浮窗编辑页 · 「显示悬浮窗」开关 | B11（成员 :346） | 源 FloatingWindowEditorSettingsPage.axaml:69-77 | FloatingWindowEditorSettingsPage.axaml（新 expander） | 源 OneWay 绑定 + 点击处理器形态随源；写配置经 ApplyConfig/lifecycle 生效（§6 注记同 W2） |
| W7 | 同页 · 悬浮窗按钮布局编辑器（方案 ComboBox + 触发器按钮行 + 添加/移除行） | B11 保留面（R-3）；配置载体 ButtonRulesetConfig/RowRulesetConfig（ConfigHandlers\，阶段 1 已交付） | 源 axaml:42-197（:50-51 ComboBox、:69-77 开关、:79 添加行、:82 FloatingTriggerRows、:134/:159-175 行内按钮） | 同页 axaml + 页属处理器 | **D6 降级硬约束**：行内拖拽排序/跨行拖动不迁（源拖拽处理器组不接线）；保留添加行/移除行/按钮选择语义。浮动触发器配置落 `Config\FloatingWindowTriggerConfig.cs`（p2-03 已交付） |
| W8 | 同页 · 外观-悬浮窗缩放 | B11（成员 :360） | 源 axaml:312-315 | 同页「外观设置」expander | Slider 绑定成员，范围随源（0.5–2） |
| W9 | 同页 · 外观-图标大小 | B11（成员 :390） | 源 axaml:332-335 | 同页 | **勘误 R1（尚书省采纳兵部 p3-02 实测上报）**：范围随源＝**15–50**/TickFrequency=1（源 FloatingWindowEditorSettingsPage.axaml:328-329 实测 Minimum=15/Maximum=50，与源 MainConfigData :387-397 钳制面 15..50 一致）；本行原注"16–120"系与 §3 C17「背景刷新频率」Slider 参数同形串行，作废 |
| W10 | 同页 · 外观-文本大小 | B11（成员 :375） | 源 axaml:352-355 | 同页 | 范围随源（8–25） |
| W11 | 同页 · 外观-不透明度 | B11（成员 :405） | 源 axaml:372-374 | 同页 | 范围随源（10–100） |
| W12 | 同页 · 外观-主题 ComboBox（含「自适应背景」项） | A 基础成员 `FloatingWindowTheme`（:24，A4 消费） | 源 axaml:381-400（四项 :387/:390/:393/:396） | 同页 | 随源四项结构；第 4 项「自适应背景」按 D5 已批降级映射为跟随宿主明暗（FloatingWindowTheme 为 int 索引，**不删项**以保存储配置索引兼容；p2-09 §1.3 S-浮 D5 注记） |
| W13 | 同页 · 外观-阴影效果开关 | B11（成员 :420） | 源 axaml:402-408 | 同页 | 直接绑定 |
| W14 | 同页 · 外观-一直显示拖动把手开关 | B11（成员 :434） | 源 axaml:410-416 | 同页 | 直接绑定 |
| W15 | 同页 · 层级 ComboBox（置底/置顶） | B12（成员 :476；宿主 `IWindowPlatformService.SetWindowFeature` 承载，p2-05 §4） | 源 axaml:419-433 | 同页「悬浮窗层级」expander | 绑定 + 写配置；实际层级应用走 B12 服务链（p2-03 D3），页面零平台代码 |
| W16 | 同页 · 层级设置频率 ComboBox | B12 关联（成员 :491；R-3 降级下运行时不启用，p2-05 §2.1 #6） | 源 axaml:434-466（四项） | 同页（层级 expander 内嵌项） | 随源四项绑定（配置兼容）；页内附降级说明注记（自动重检停用），实现形态由 p3-02 在已批 R-3 口径内定 |
| W17 | 同页 · 按规则隐藏开关 + 「编辑规则集…」按钮 | B11/R-3 保留面（成员 :506/:517-518） | 源 axaml:469-486（:475-480 按钮、:483 开关） | 同页「按规则隐藏」expander | 全局规则集编辑入口；编辑器实现消费 SDK Ruleset 与既有 ConfigHandlers 规则配置类型，零新配置根成员 |
| W18 | 同页 · 方案选择面补全（源页 ComboBox SelectedItem 双向绑定方案切换语义） | A3/A4 共享类型（骨架已有） | 源 axaml:50-51 | 现骨架 axaml:15-20 已具备（SystemToolsSettingsViewModel.cs:36-73） | 现状核对项：骨架面与源选择语义一致；无新成员。**已裁定适配（尚书省，p3-02）**：方案面由阶段 1 骨架 expander **单一承载**——源页内嵌顶部栏第二 ComboBox 形态不复刻，双 ComboBox 收敛为单面属**劣化面**（非缺口），留作同装差异注记候选 |

**AiChat / About / PluginDebug 三页 B 接线 = 0 项**（结构事实）：AiChat 页 B 面仅共享回复开关（已接线，axaml :15-17）；About 页零 B 选项；PluginDebug 页源全为 U5/C 面。三页阶段 3 工作为 A 面补全（AiChat 消息编辑 UI 与拖放遮罩接线，见 §3.3 注记）与 C 裁剪核验，非 B 接线。

**互斥零冲突声明**：上表 18 项按页面归属两批——p3-01 仅触碰 `SystemToolsSettingsPage.*` 与 `MoreFeaturesOptionsSettingsPage.*`（+其共享 VM 主页消费面），p3-02 仅触碰 `FloatingWindowEditorSettingsPage.*`、`AiChatSettingsPage.*`、`AboutSettingsPage.*`、`PluginDebugSettingsPage.*`；`SystemToolsSettingsViewModel.cs` 为主页/悬浮窗页共享 VM，其悬浮窗方案面归 p3-02 消费、主页 AI/抽屉面归 p3-01 消费，两批各自只增补页属绑定代码，**共享 VM 改动须在批证据中互注**（如需增 VM 成员，按页归属申报，禁止同名成员双批各写一份）。注册面（Plugin.cs）、MainConfigData、manifest 阶段 3 预期零改动；如出现注册/成员需求，按 p1-05 §4 流程上报，不得批内自改。

## 3. C 档裁剪移除面清单（21 项）

口径：裁剪面 = 源设置页中属 C 档（或 U5 降级排除）的**选项 UI 面与依赖下载接线面**。逐项标注：源锚点 → 现骨架对应位（残留核对）→ 裁剪依据。**验证结论（§3.4）：零 C 档功能本体误伤——C 档 46 项功能本体本就不在新插件（p2-09 §3 反向检索 0 实体），本清单仅覆盖设置/下载 UI 与接线；现骨架零残留（逐项核对于本轮实测）。**

### 3.1 主页（p3-01 页面；裁剪核验归属 p3-01 批自检）

| # | 裁剪面 | 源锚点 | 现骨架残留核对 | 裁剪依据 |
| :-: | --- | --- | --- | --- |
| C1 | 「实验性功能」开关组 | 源 SystemToolsSettingsPage.axaml:179-189 | 无（成员 `EnableExperimentalFeatures` 不存在于 MainConfigData） | 06 C 面不迁（p2-05 §2.1 明确不增补清单） |
| C2 | 启用扩展功能 · FFmpeg 功能开关 | 源 axaml:322-328；源 axaml.cs:321 | 无 | 06 条目 85（ffmpeg/dshow 链 C） |
| C3 | 启用扩展功能 · FFmpeg 下载按钮 + 处理器 + VM 下载逻辑 | 源 axaml:330-336；源 axaml.cs:490-498；源 VM:1329-1422（DownloadFfmpegAsync） | 无（DependencyPaths 0 命中，p2-09 §3.1） | 06 条目 86（C 依赖下载管理聚合裁剪） |
| C4 | 启用扩展功能 · 人脸识别开关 + 凭据清理路径 | 源 axaml:339-357；源 axaml.cs:370-399（含 :396 FaceRecognitionCredentialCleanup） | 无 | 06 条目 80（人脸认证 C） |
| C5 | 启用扩展功能 · 人脸模型下载按钮 + VM 逻辑 | 源 axaml:351-356；源 axaml.cs:401-410；源 VM:1422-1527 | 无 | 06 条目 86 |
| C6 | 启用扩展功能 · Windows Hello 开关 + 支持检测 | 源 axaml:360-366；源 axaml.cs:412-488 | 无 | 06 条目 81（Hello 认证 C） |
| C7 | 启用扩展功能 · 语音识别服务（VoskWorker）下载 | 源 axaml:369-374；源 axaml.cs:860-864；源 VM:998-1119 | 无 | 06 条目 77/86（VoskWorker C） |
| C8 | 启用扩展功能 · 语音识别模型 ComboBox + 下载确认 | 源 axaml:380-399；源 axaml.cs:801-857（含 :821 确认对话框）；源 VM:1143-1305 | 无 | 06 条目 76/77/86（SAPI/Vosk 语音链 C） |
| C9 | 启用扩展功能 · 下载状态文本 + 进度条 | 源 axaml:405-410 | 无 | 06 条目 86（随下载面整体裁剪） |
| C10 | AI 服务组 · 「语音唤醒 AI」开关 | 源 axaml:263-273 | 无（`EnableVoiceWakeAi` 不存在；p2-09 §3.1 语音组 0 命中） | 06 条目 78（语音唤醒 C 立项候选） |
| C11 | AI 服务组 · 「AI 唤醒词」文本框 | 源 axaml:276-282 | 无（`AiWakeWord` 不存在） | 06 条目 76-79（语音链 C） |
| C12 | AI 服务组 · 「AI 对话悬浮窗样式」ComboBox（磨砂/液态玻璃） | 源 axaml:302-315 | 无（液态玻璃成员零存在，MainConfigData.cs:325-327 注记） | U5/R-6 降级决议（p1-06 §9；p1-10 §12.5 漂移点零消费口径） |
| C13 | 主页 VM 依赖检查/下载基础设施（DependencyPaths 消费群 + TryBeginDownload/进度/MD5 对话框） | 源 VM:936-996（存在性检查）、:1528-1562（下载生命周期）；源 axaml.cs:500-522（错误/MD5 对话框） | 无（`Shared\DependencyPaths.cs` 零引入；骨架 VM 仅 74 行 A 面，SystemToolsSettingsViewModel.cs:1-74） | 06 条目 86；p1-05 §1（ThirdParty/VoskWorker 目录禁止） |

### 3.2 更多功能选项页 / 悬浮窗编辑页

| # | 裁剪面 | 源锚点 | 现骨架残留核对 | 裁剪依据 |
| :-: | --- | --- | --- | --- |
| C14 | 更多功能选项 · 「自动清理内存（管理员）」组（含一键清理） | 源 MoreFeaturesOptionsSettingsPage.axaml:81-116；源 axaml.cs:84-120 | 无（`AutoCleanupSystemMemory`/`SystemMemoryCleanupThresholdPercent` 不存在） | 06 条目 84（系统级内存清理 C） |
| C15 | 更多功能选项 · 「自动播放」USB 开关 | 源 axaml:118-123；源 axaml.cs:38-48 | 无（`AutoOpenUsbDriveOnInsert` 不存在；注册面已有同口径注记先例 Plugin.cs:335/:517/:637） | 06 条目 70（USB 自动播放 C） |
| C16 | 悬浮窗编辑页 · 「液态玻璃(实验性)」外观样式 ComboBox | 源 FloatingWindowEditorSettingsPage.axaml:210-217 | 无（`FloatingWindowAppearanceStyle` 不存在，:325-327 注记） | U5/R-6（p2-05 §2.1 明确不增补） |
| C17 | 悬浮窗编辑页 · 液态玻璃 4 参数 Slider（模糊/折射/背景刷新/按钮缩放） | 源 axaml:222-295（:233-235/:253-255/:273-275/:293-295 绑定） | 无（`FloatingWindowLiquidGlass`/`FloatingWindowGlassButtonScaleDip` 不存在） | U5/R-6；MainConfigData.cs:325-327 禁引用注记 |
| C18 | 悬浮窗编辑页 · 触发器行拖拽排序/拖动机制（B 面裁减机制，非 C 本体） | 源 axaml:44（拖拽描述）；拖拽处理器见源页 code-behind（D6 面）；另源主页 axaml.cs:560-739 有一组悬浮窗触发器行处理器，源主页 axaml 无对应 UI 锚点（源侧遗留面，一并零迁移） | 无（骨架无行编辑器；W7 接线时按 D6 只做非拖拽编辑） | p2-03 D6（手动鼠标拖拽移除，已批降级）——单列以区别于 C 裁剪，防误伤复核误判 |

### 3.3 AiChat / About / PluginDebug 页

| # | 裁剪面 | 源锚点 | 现骨架残留核对 | 裁剪依据 |
| :-: | --- | --- | --- | --- |
| C19 | AiChat · 语音输入按钮组 | 源 AiChatSettingsPage.axaml:423-443（VoiceInputToolTip/CanToggleVoiceInput/IsVoiceInputActive） | 无（VM 语音成员已裁净，p1-06 §4.2-3/§7-2 零命中） | 06 条目 77-79（语音族 C） |
| C20 | About · 题图头 + Lyricify Lite 适配帮助 expander | 源 AboutSettingsPage.axaml:28-51（TitleImage）+ 源 axaml.cs:29（AboutTitleImageCacheService 字段）；源 axaml:154-159 | 无（骨架已在 AboutSettingsPage.axaml:11 / .axaml.cs:24 置不迁注记） | 06 C 面（歌词组件 C 相关帮助）+ AboutTitleImageCacheService 未迁（p1-09 §3.3-d 同款口径） |
| C21 | PluginDebug · 整页选项体（玻璃预设/折射背景/色彩/渐进/高光/内外阴影/审批按钮玻璃/恢复默认/语音唤醒调试） | 源 PluginDebugSettingsPage.axaml:25-362 + :367 起 | 无（骨架零绑定占位，axaml:9-18） | U5 液态玻璃排除 + 语音 C（06 条目 78）；p1-06 §4.1「零 A 档绑定」口径维持。**已裁定适配（尚书省，p3-02）**：占位文案更正为「源插件调试选项在本跨平台版本中未提供」（替换骨架现占位文案）；文案变化不构成选项接线或裁剪面口径变化 |

### 3.4 零功能本体误伤声明与 A 面补全注记

1. **零误伤**：上述 21 项全部为设置/下载 UI 与其接线面；C 档 46 项功能本体（行动 32/触发器 5/组件 1/规则 1/服务认证 7）本就不在新插件——p2-09 §3 全树特征检索 0 实体、§3.3 机制符号零新增，本轮未发现任何需在阶段 3「补裁」的功能本体；裁剪工作性质为"确认零残留 + 不回迁"，非删除既有功能代码。
2. **A 面补全（非裁剪，登记防混淆）**：AiChat 页消息编辑 UI（源 :185-237；VM 成员已在 p1-06 §4.2-2 契约内保留）与拖放遮罩接线（源 :478；AiAttachmentDropService/AiAttachmentDropOverlay/AiAttachmentDropConfirmation 已交付）为 p1-06 §9-8 明示的阶段 3 整合面，归 p3-02。主页「当前使用模型」显示项（源 :286-298，A 档 `AiModel` 消费）与页头标签（源 :153-165）为可选随源补全项，归 p3-01。源页「粘贴位图」面不在已批 A 契约内（p1-04 附件面 = 文件选择器口径），维持不迁；如需纳入须尚书省修订后方可。
3. **抽屉枚举裁剪口径**：W1 抽屉的功能清单在源由 `InitializeFeatureItems`/`UpdateFeatureSearchResults`/`SaveFeatureSettings`（源 VM :174/:337/:359）统一枚举含 C 项——新实现枚举仅限 A+B 注册面 52 项，C 项裁剪由枚举构造保证（不逐条列 C 名，属结构性裁剪依据：注册面即白名单）。

## 4. 命名空间统一方案（p1-05 §3 体系核对）——零调整结论

### 4.1 实测审计（本轮全树重放，163 .cs + 29 .axaml）

- `namespace\s+SystemTools\.(?!CrossPlatform)` 全树 **0 命中**；全局命名空间文件 **0**（与 p2-09 §5-2 一致并扩展）。
- 163 文件 / **22 个唯一命名空间**，逐一核对 = `SystemTools.CrossPlatform.<目录路径>`（仅目录镜像，不含文件名；Plugin.cs 根文件 = `SystemTools.CrossPlatform`）：Actions 31、Config 2、ConfigHandlers 6、Controls 26、Controls.Components 12、Controls.Notifications 1、Converters 1、Models 2、Models.ComponentSettings 6、Rules 4、Rules.Handlers 4、Services 21、Settings 22、SettingsPage 8、Shared 1、Themes.CardTypeComponent 1、Themes.ClassWidgets 2、Themes.NotchStyle 5、Triggers 2、Version 1、Views 4、根 1——**镜像违例 0**。
- XAML 面：全部 29 个 .axaml 的 `x:Class`、`using:`、`clr-namespace:` 本地命名空间 **0 非 `SystemTools.CrossPlatform` 前缀**。

### 4.2 结论与方案

1. **调整清单 = 空（0 项）**：22 个唯一值全部为 p1-05 §3.2 体系的合法镜像形态，无 `SystemTools.*` 裸前缀遗留、无全局命名空间、无目录-命名空间漂移文件；阶段 3 **不产生任何文件×现命名空间×目标命名空间调整行**。
2. **独立配置命名空间核对**（p1-05 §3.1 表第 3-4 行）：配置类型全部落 `SystemTools.CrossPlatform.ConfigHandlers`（6 文件 ✓，含 MainConfigData/MainConfigHandler/FloatingWindowProfile/Manager/ButtonRulesetConfig/RowRulesetConfig）；配置 JSON 属性名随源 camelCase（p2 各批增补段逐项留痕）；配置落盘走 `GlobalConstants.PluginConfigFolder` 独立目录（p1-03 D7），与源插件配置文件零互写。功能 ID/注册名前缀 `SystemTools.CrossPlatform.*` 由 p2-09 §5-3（202 行全前缀、仅 3 处无尾段形态已登记）背书，本轮不重复复跑。
3. **零行为改动声明**：命名空间维度的"统一"在本案中自阶段 1 起即一次性成立（每文件唯一命名空间随目录），阶段 3 维持 p1-05 §3.2 规则：p3 各批新文件（如有）命名空间必须镜像其目录；**禁止**在设置页接线中引入 `using SystemTools.*`（源命名空间，p1-05 §3.2-4）。

## 5. 同装差异说明文档大纲（归属礼部 p3-06 执行；本方案仅定结构）

产物建议名：同装差异说明（用户可见文档，落新插件资产/文档面或 manifest readme 面，由 p3-06 按礼部职权定稿）。章节结构与逐节内容来源（批登记条目）：

| 节 | 章节标题 | 内容要点 | 内容来源引证（批登记条目） |
| :-: | --- | --- | --- |
| 1 | 并存形态说明 | 两插件可同装并存的前提：独立 manifest id、功能 ID 前缀空间不相交、独立配置目录、宿主同时启用的注册隔离边界 | 04-spec R-10；06 总览并存约束段；p0-05 §4.1/§4.2（源侧 `CrossPlatform` 零出现）；p2-09 §5-3（前缀空间实测） |
| 2 | B 档 Windows 专属行为与降级 | 7 项电源 U4 预检/通知降级、悬浮窗 R-3 钩子/层级、U5 经典外观、复制/移动/删除跨平台命令替换与失败语义、主题/遮挡/内存降级可观察性 | p2-01 §（A2-A10/D1-D15 降级登记）、p2-02 §（AD1-AD10）、p2-03 §（D1-D13/W 系列）、p2-09 §1 特殊处置注记列（逐项锚点已固化） |
| 3 | AD8 元数据差异承接 | 复制/移动不再使用 robocopy `/copyall`：ACL/审核等元数据不随内容复制；属全平台注记（非某平台缺口） | p2-02 §AD8（登记原文 + 承接方 = 阶段 4 同装差异/平台说明文档）；06 条目 34/35 拟纳入边界 |
| 4 | G1–G3 平台面 | 会话结束事件非 Windows 不可用（SystemShutdownMonitor no-op 护栏 + 高级关机看门狗语义）、IDesktopService macOS 实装缺口、ISystemEventsService Linux/macOS 缺实装对设置页消费面的影响（阶段 3 页面不直接消费缺口接口，写清"感知面"即可） | p0-01 §3/§7（G1-G3 登记）；p1-05 §5.1-5（缺口摘要）；p2-03 §1.4（非计数附属处置）；p2-09 §1.4（W5-W7/W13 实测） |
| 5 | 配置迁移与共存注意 | 悬浮窗方案一次性迁移（MigrateFromLegacyConfig）范围与主配置"不自动迁移旧配置"边界；auto.json/版本检查文件独立目录；两插件配置/触发器文件互不读写；设置页开关语义差异（重启提示等价口径） | p1-03 D5-D8（存储根/独立配置）；p2-06 §3-3 W4（迁移调用接线）；06 条目 14/21/32（路径独立边界）；p1-06 §9-7（RestartPropertyChanged 等价口径，供第 5 节开关行为描述） |

结构约束：大纲为 5 节封顶的用户文档骨架；p3-06 执行时逐节扩写，不得把批证据时间线复制为正文；第 2/4 节表列须逐条带源文件:行或批证据条目号（可复核）。

## 6. 约束落点（对阶段 3 两类横向约束的适用性）

1. **菜单树格式修订（p1-05 §4.2 + p2-09 §6 修订建议登记）**：阶段 3 变更表面 = 设置页选项接线，**预期零 `RegisterActionIfEnabled` 新增、零菜单树变更**（MoreFeatures/悬浮窗等行动菜单组已由 p2-06 §5 按源形态恢复）。适用性约定：p3 两批任一交接若意外出现行动/触发器注册行（预期无），必须按修订后格式附「行动菜单树」归属声明（组/组门/菜单项文案图标锚点），杜绝"注册有、菜单无"缺口；设置页面本身不入行动菜单树（设置页注册 id 空间独立，Plugin.cs:160-174）。
2. **双分支 API 漂移约束（p1-10 §12.5）对设置页消费面的核对范围**：
   - 页面宿主 API 面：`SettingsPageBase.RequestRestart`（p1-06 §6-8 已核双分支可用）、`AddSettingsPageGroup`/`[Group]`/`AddSettingsPage`（p1-06 §6-4 已核）、`IUriNavigationService.NavigateWrapped`（p1-06 §6-15 已核）、DrawerHost/DataGrid/FAContentDialog（ClassIsland.Core 二进制既有消费先例）。
   - 页面服务消费面：AdaptiveThemeSyncService / MainWindowTextOcclusionService / ClassIslandMemoryAutoCleanupService 的 `ApplyConfig`（p2-01/p2-02 交付）、FloatingWindowProfileManager 方案面（p1-03）、AiAttachmentDrop* （p1-04）——均为插件内类型，无漂移面。
   - **漂移红线（禁引用）**：`MainWindowStylesAssist.IsBackgroundMaterialEnabled`（p1-01 §7.4 漂移点）、`FloatingWindowAppearanceStyle`/`FloatingWindowLiquidGlass.*`/`FloatingWindowGlassButtonScaleDip`（U5 排除 + MainConfigData.cs:325-327 禁引用注记）；p3 批交付自检按 p1-01 §7.5 复扫口径覆盖本批交付路径。
   - 06 替换目标表述中的 4 个缺位接口（ISystemPowerService/IThemePlatformService/ITextOcclusionDetectionService/IProcessMemoryMaintenanceService，p2-05 §4）在阶段 3 页面消费面以**插件本地已交付实现**为唯一引用对象（IProcessMemoryMaintenanceService 已落插件命名空间 p2-01 §1.3），页面层零新增宿主接口引用。

## 7. 交付统计与复核指引

- **接线项 18**（p3-01：W1-W5 共 5；p3-02：W6-W18 共 13）＋ A 面补全注记 4 项（§3.4-2）。
- **裁剪面 21**（C1-C13 主页 13；C14-C18 更多功能/悬浮窗 5；C19-C21 三页 3）＋ 结构性裁剪口径 1 项（抽屉枚举白名单，§3.4-3）。
- **命名空间调整 0**（§4 零调整结论；22 唯一值/163 文件/29 XAML 全核对）。
- **文档大纲 5 节**：并存形态说明 / B 档 Windows 专属行为与降级 / AD8 元数据差异承接 / G1-G3 平台面 / 配置迁移与共存注意（§5，逐节引证批登记条目）。
- 复核重放：
  1. 命名空间：`Select-String -Path src\SystemTools.CrossPlatform\**\*.cs -Pattern 'namespace (?!SystemTools\.CrossPlatform)'`（预期 0 命中）；
  2. C 成员零存在：对 §1.2 "明确不增补"成员名逐个在 MainConfigData.cs 与 SettingsPage\ 检索（预期 0 代码命中，注记行除外）；
  3. 接线锚点：§2 表各行"新落点"对现骨架文件行号重放（实施期允许插入位移，区间语义为准）；
  4. 裁剪锚点：§3 表"源锚点"对源插件 `E:\My Github Projects\SystemTools\SettingsPage\` 各文件行号重放（只读）。

## 8. 边界声明

- 本任务唯一写入 = 本证据文件；`src\` 产品文件零改动，源插件检出与宿主检出全程只读（本轮对源 SettingsPage 14 文件为 Select-String/Get-Content 只读检索）。
- 本文件不派工、不审批、不推进全局工作流；接线落点与裁剪面供尚书省阶段 3 执行计划与兵部两批、礼部 p3-06 派工引用；批内如与本方案冲突，按 §0-4 冲突规则上报。
- W7 按钮布局编辑器的非拖拽编辑交互、W12 自适应背景项的 D5 映射实现、W16 层级频率的页内降级注记形态，均为已批口径内的实现决策面，归 p3-02；本方案不预写控件树与函数体。

## 9. 修订记录

- 初版（p3-05 执行交付；基于本轮对现骨架 163 .cs/29 .axaml 全树实测与源插件 SettingsPage 只读实测）。
- **R1 勘误（尚书省指令，采纳兵部 p3-02 实测上报；零产品文件改动）**：§2.2 W9「外观-图标大小」范围原注 16–120 作废（系与 §3 C17「背景刷新频率」Slider 参数同形串行），更正为**范围随源＝15–50/TickFrequency=1**（源 FloatingWindowEditorSettingsPage.axaml:328-329 实测 + 源 MainConfigData :387-397 钳制面 15..50 一致）；兵部已按"范围随源"取 15–50 落地，本 spec 同步登记。另登记两项尚书省已裁定适配（本 spec 补口径，不改计数/归属）：W18 方案面单一承载（骨架 expander 统一承载，源内嵌顶部栏双 ComboBox 形态不复刻，登记为劣化面）；PluginDebug 占位文案更正为「源插件调试选项在本跨平台版本中未提供」（§3.3 C21 行注记）。接线项 18 / 裁剪面 21 / 命名空间调整 0 / 大纲 5 节计数不变。
