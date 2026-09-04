# p3-06 证据：阶段 3 同装差异说明文档 + 设置面契约核对（礼部 rites / interfaces-documentation / documentation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-06 · 礼部 rites · interfaces-documentation / documentation（阶段 3；依赖 p3-01/p3-02/p3-03（及 p3-05）均已记录 succeeded；吏部 W9 勘误修订以文件现态为准核对） |
| 权威输入 | p3-05 §5 文档大纲与 §3.4/§6 约束；p1-03 §2（D5-D8 存储根/隔离适配）；06-migration-details-proposal.md 条目 14/21/32（路径独立边界）、条目 34/35（robocopy→BCL 元数据边界）、条目 37-43/47-49（电源/主题遮挡/内存降级）；p2-01 §2/§3（U4 三级预检+Toast 全族、EmptyWorkingSet 仅 Windows、B8 /g 口径、有界等待）；p2-02 §1.1/§2（AD1-AD10，AD8 元数据）；p2-03 §2（D1-D15 悬浮窗降级）、§3（双分支 API）；p2-06 §4/§5（菜单组现态，零注册变更）；p0-01 §3/§7（G1-G3）；p1-10 §7/§12.5、p2-10 §（G1/G3/G4 留阶段 4）、menxia-stage2-acceptance.md O-8（真机/标准路径/cipx 遗留）；p1-06 §4/§6-8/§9-7（设置页骨架/重启等价口径）；p3-01/p3-02 两批接线证据；源插件 `E:\My Github Projects\SystemTools\SettingsPage\`（只读随源核对） |
| 交付 | `docs\coexistence-notes.md`（用户可见同装差异说明，5 节，约 6.2 千字符）＋ 本证据文件；零产品源码/注册面改动 |
| 结论 | **succeeded** —— ①同装差异说明文档按 p3-05 §5 大纲 5 节扩写落盘，第 2/4 节表列逐条带 file:line 或登记条目号（§1）；②6 设置页契约核对四项全过：映射一致性 6 页 30 组可交互选项零错配（含 W9 15-50 勘误后现态 ✓）、C 档移除后零悬空绑定/零死区（PluginDebug 收口文案现态 ✓）、新增接线面文案随源逐字符核对通过（登记适配项 + 差异观察 2 项如实上报）、抽屉 41 项与注册面/组门一致（§2/§3）；③菜单树描述与 p2-06 现态一致、零注册变更（§4-①）；④S4.2 扫描对 docs/ 面不适用，如实声明（§5） |

---

## 1. 同装差异说明文档落盘与结构对照（p3-05 §5 大纲）

落盘：`docs\coexistence-notes.md`（仓库无既有 docs/ 与文档先例，按派工口径创建目录；全文中文）。5 节封顶，正文不复述批证据时间线，仅保留条目号引用。

| 文档节 | p3-05 §5 大纲节 | 覆盖内容 | 逐条引证落位 |
| :-: | :-: | --- | --- |
| 一 并存形态 | §5-1 | manifest id/显示名/前缀对照；主配置独立目录、auto.json（安装目录）、version.json（插件目录）、悬浮窗方案独立目录互不读写；菜单树 10 组现态 | 表格带 manifest.yml:11/12/20、ActionInProgressTrigger.cs:31-38、TriggerCustomTriggerAction.cs:31-38、VersionCheckService.cs:14-20、FloatingWindowProfileManager.cs:32-42、Plugin.cs:160/:471-545；p1-03 D7/D8；06 条目 14/21/32 |
| 二 Windows 专属与降级 | §5-2 | U4 三级预检+Toast 全族链路、电源 7 项逐项（B8 /g、B5 看门狗、B6 1116、B10 有界等待）、EmptyWorkingSet 仅 Windows、悬浮窗 D1-D15 归并为 8 行用户可读表、主题同步/遮挡检测 AD1/AD2 降级 | 表列逐行带 p2-01 §2/§3、p2-03 §2-D1-D15、p2-02 §2-AD1/AD2、06 条目 37-49、新文件 file:line；统一条件编译口径按 R-2/R-2a（`Platforms_Windows` 编译生效符号，§0 口径注） |
| 三 AD8 元数据差异 | §5-3 | 复制/移动/删除 robocopy→BCL 边界：内容与基础属性复制、ACL/审核元数据不复制、失败不误报成功 | 表列带 Actions\CopyAction.cs:56/:90-125、MoveAction.cs:56/:94-109、DeleteAction.cs:42/:66；06 条目 34/35/36；p2-02 §2-AD5/AD8 |
| 四 G1-G3 平台面 | §5-4 | G1（ISystemEventsService 无 Linux/macOS 实装，零消费）、G2（契约无会话结束事件→条件承载/no-op/宿主退出取消本地计划）、G3（IDesktopService 无 macOS 实装，零消费）；构建发布遗留（macOS 真机/标准路径噪声/cipx 打包 → 阶段 4） | p0-01 §3/§7-G1-G3；p1-05 §5.1-5；p2-03 §2-D12；p1-10/p2-10 工部 G 项登记；menxia-stage2 O-8 |
| 五 配置迁移与共存注意 | §5-5 | 主配置不自动迁移边界；MigrateFromLegacyConfig 一次性/幂等/仅布局成员/仅本插件方案存储范围与 AppStarted 时点；悬浮窗方案迁移（原共享缓存目录不复用）；开关语义差异（RestartPropertyChanged 不迁 → 显式落盘+请求重启等效口径、协议对话框保留、抽屉「应用并重启」走宿主 RequestRestart）；共存建议 4 条 | FloatingWindowProfileManager.cs:48-67、Plugin.cs:195；p2-03 §2-D13/D14；p2-06 §3；p1-06 §6-8/§9-7；06 预备清单 #8 |

## 2. 契约核对一：选项 ↔ MainConfigData 成员映射一致性（6 页全量）

核对方法：6 页 .axaml 全部可交互选项逐一提取绑定路径，对照 `ConfigHandlers\MainConfigData.cs`（553 行现态）成员、默认值与钳制面；Slider/NumericUpDown/ComboBox 边界对照控件声明值。 Roslyn 批级编译自检（p3-01/p3-02 error=0）佐证无错拼绑定成员。

### 2.1 主设置页 SystemToolsSettingsPage

| 选项 | 绑定成员 | 默认值 | 钳制/边界 | 现态锚点 |
| --- | --- | --- | --- | :-: |
| 启用悬浮窗功能（W2，TwoWay+Click） | `EnableFloatingWindowFeature` | true | 布尔 | axaml.cs:250-254；MainConfigData.cs:332-344 |
| 启用 AI 服务（OneWay+Click+协议对话框） | `EnableAiService` | false | 布尔；开=确认→Save→RequestRestart，关=Save→RequestRestart | axaml.cs:69-100；MainConfigData.cs:186-198 |
| AI 服务协议 `AiProviderName` | TextBox TwoWay | "OpenAI" | — | MainConfigData.cs:200-214 |
| API 密钥 `AiApiKey` | TextBox TwoWay | "" | — | MainConfigData.cs:216-230 |
| API 地址 `AiApiUrl` | TextBox TwoWay | "https://api.openai.com/v1" | — | MainConfigData.cs:232-246 |
| AI 模型 `AiModel`（ComboBox SelectedItem TwoWay + 获取模型按钮） | `AiModel` | "" | — | MainConfigData.cs:248-262 |
| 当前使用模型（显示，OneWay） | `AiModel` 只读消费 | — | A2 登记适配面 | axaml:257-265；p3-01 §1.4 |
| 更多功能选项… 导航 expander | 无配置绑定（IsClickEnabled 静态 True） | — | 与源 VM `IsMoreFeaturesClickEnabled=true`（源 :92，恒 true）语义等效 | axaml:181 |
| W1 抽屉：启用 checkbox × 41 项 | `EnabledActions/Triggers/Components/Rules[id]` | 缺席=启用（Is*Enabled 默认 true） | 保存=字典写入+Save+RequestRestart | VM:700-884；MainConfigData.cs:507-547 |

### 2.2 更多功能选项页 MoreFeaturesOptionsSettingsPage

| 选项 | 绑定成员 | 默认值 | 钳制/边界 | 现态锚点 |
| --- | --- | --- | --- | :-: |
| W3 自动切换 ClassIsland 主题 | `AutoSwitchClassIslandTheme` TwoWay + ApplyConfig + Save | false | 布尔 | axaml:25-26；MainConfigData.cs:252；axaml.cs:51-61 |
| W4 主界面遮挡文字时 | `AutoHideMainWindowWhenOccluded` 同上 | false | 布尔 | axaml:36-37；MainConfigData.cs:266 |
| 虚拟放学开关 | `VirtualAfterSchoolEnabled` 同上（p1-06 面） | false | 布尔 | MainConfigData.cs:96-110 |
| 触发时间 TimePicker | `VirtualAfterSchoolTriggerTime` TwoWay | 12:10:00 | setter 守卫 0≤t<24h | MainConfigData.cs:112-136 |
| 放学状态持续时间 NumericUpDown 1–7200 | `VirtualAfterSchoolDurationSeconds` TwoWay | 60 | UI Min/Max=钳制 1..7200 一致 | axaml:64-70；MainConfigData.cs:138-160 |
| W5 自动清理 ClassIsland 内存 | `AutoCleanupClassIslandMemory` TwoWay + ApplyConfig + Save | false | 布尔 | axaml:87-88；MainConfigData.cs:291 |

### 2.3 悬浮窗编辑页 FloatingWindowEditorSettingsPage（注册门 EnableFloatingWindowFeature，Plugin.cs:169-172）

| 选项 | 绑定成员 | 默认值 | UI 范围 | 配置钳制 | 现态锚点 |
| --- | --- | --- | --- | --- | :-: |
| W18 配置方案 ComboBox（OneWay+SelectionChanged）+ 新建/打开配置文件夹/删除当前方案 | `CurrentFloatingWindowProfile`（经 FloatingWindowProfileManager） | "Default" | — | — | VM:145-147；MainConfigData.cs:36-48 |
| W6 显示悬浮窗 ToggleSwitch（OneWay+处理器回写校验） | `ShowFloatingWindow` | true | 显示/隐藏（随源） | 布尔；IsEnabled=HasFloatingTriggerEntries | axaml:50-67；axaml.cs:158-178；MainConfigData.cs:346 |
| W8 悬浮窗缩放 Slider | `FloatingWindowScale` TwoWay | 1.0 | 0.5–2 / 0.1（axaml:179-181） | 0.5..2.0（:357-370）✓ | |
| **W9 图标大小 Slider** | `FloatingWindowIconSize` TwoWay | 22 | **15–50 / 1（axaml:199-201）** | **15..50（:387-397）** | **W9 勘误后现态 ✓**（16–120 为 p3-05 转录误，源实测 15-50，源.axaml:328-329；吏部修订已按文件现态核销） |
| W10 文字大小 Slider | `FloatingWindowTextSize` TwoWay | 12 | 8–25 / 1（axaml:219-221，随源） | 8..30（:399-411）；UI 窄于钳制=随源形态 | |
| W11 透明度 Slider | `FloatingWindowOpacity` TwoWay | 80 | 10–100 / 1（axaml:239-241） | 10..100（:413-425）✓ | |
| W12 主题 ComboBox 4 项 | `FloatingWindowTheme` SelectedIndex TwoWay | 0 | — | 归一化 0..3（:21-34）；第 4 项说明含 D5 降级注记 | |
| W13 阴影效果 | `FloatingWindowShadowEnabled` TwoWay | true | 布尔 | :427-441 | |
| W14 一直显示拖动把手 | `FloatingWindowDragHandleAlwaysVisible` TwoWay | false | 布尔 | :443-457 | |
| W15 层级 ComboBox 置底/置顶 | `FloatingWindowLayer` SelectedIndex TwoWay | 1 | 2 项 | 归一化 0/1（:459-473） | |
| W16 层级设置频率 ComboBox 4 项 | `FloatingWindowLayerRecheckMode` SelectedIndex TwoWay | 1 | 4 项 | 0..3（:475-489）；**运行时不消费（R-3 降级）**，说明含注记 | |
| W17 按规则隐藏 + 编辑规则集… | `FloatingWindowRulesetEnabled` TwoWay + `FloatingWindowRuleset`（经抽屉编辑） | false / 空 Ruleset | — | :491-505/:507-529 | |
| W7 行编辑按钮组（添加行/行规则集/在下方插入一行/删除行/按钮规则集） | 方案存储 FloatingWindowButtonRows/ButtonRulesets/RowRulesets（非主配置根） | 空 | — | Persist 经 manager 落盘 | axaml.cs:259-337；VM:237-655 |

### 2.4 AiChat / About / PluginDebug 三页

| 页 | 选项 | 绑定成员 | 结论 |
| --- | --- | --- | :-: |
| AiChat（门 EnableAiService，Plugin.cs:163-166） | 共享回复到提醒 ToggleSwitch | `ShareAiRepliesWithClassIslandNotifications` TwoWay（VM IsClassIslandNotificationSharingEnabled :142） | ✓ 默认 false（MainConfigData.cs:264-280） |
| AiChat | 历史/新建对话/会话删除/消息编辑 UI/发送-停止/附件选择与拖放遮罩 | VM/UI 状态（IsHistoryOpen、Conversations、PendingAttachments、AiModel 只读消费等），**零新增配置根成员** | ✓ 与 p1-06 §4.2 契约一致 |
| About | 插件信息卡（连击 5 次进调试页）、反馈链接、帮助/介绍/更新日志 | `GlobalConstants.PluginVersion` + UI 状态（SelectedTabIndex/CurrentMarkdownContent） | ✓ 零配置绑定 |
| PluginDebug | 零交互选项（零绑定占位） | — | ✓ MainConfigData 零对应成员，见 §3 |

映射结论：6 页 30 组可交互选项绑定成员全部存在于 MainConfigData/方案存储/页属 VM，默认值与钳制面逐一相符；**零错配、零缺失成员、零未接线悬空绑定**。MainConfigData 现态与 p2-03 增补段登记一致（553 行；B 档 17 成员 + A 档成员），阶段 3 零增补。

## 3. 契约核对二/三：C 档移除后页面完整性 + 文案随源核对

### 3.1 完整性核对（C 档移除后零残留）

- 6 页代码面 C 档条目零残留：实验性功能 expander（C1）、AI 语音按钮（C19）、液态玻璃外观 ComboBox 与玻璃 4 参数 Slider（C16-C18）、扩展功能下载组（C13）、管理员内存（C14）、USB 自动播放（C15）、About 题图/Lyricify（C 面）、PluginDebug 全参数体（C21）均零命中——与 p3-01 §2（15/15）、p3-02 §2（6/6）扫描结论一致；本核对以六页现文件通读复验（SystemToolsSettingsPage.axaml 271 行、MoreFeatures…axaml 94 行、FloatingWindowEditor…axaml 360 行、AiChat…axaml 206 行、About…axaml 154 行、PluginDebug…axaml 21 行）。
- 悬空绑定：6 页全部 `{Binding}` 路径目标实测存在（页属属性/共享 VM/页属 VM/AiConversation 模型成员，grep 复验清单见 §6 重放 3）；Roslyn 编译自检两批 error=0 佐证。
- 死区：更多功能选项页无 C14/C15 死区；「其他工具」组标签随源整组不迁（其唯一成员属 C15，axaml:77-78 注记在位）。
- PluginDebug 收口文案现态：axaml:13-18 「插件调试」+「源插件调试选项在本跨平台版本中未提供。」——p3-02 §7-3 更正后现态，无虚假整合预期。✓

### 3.2 文案随源核对（新增接线面，逐字符对照源插件只读检出）

**随源一致项**（抽屉/悬浮窗编辑页/AiChat 编辑 UI）：

| 面 | 核对结果 | 源锚点 | 新锚点 |
| --- | --- | --- | :-: |
| 抽屉标题/搜索框/谨慎条/DataGrid 四列表头（启用/类型/所属组别/名称）/空态/取消/应用并重启 | 逐字符一致 | 源 axaml:26-149 | 新 axaml:21-146 |
| 抽屉入口 expander「启用功能选项 / 选择需要本插件要启用的功能 / 管理启用的功能...」 | 逐字符一致 | 源 axaml:167-176 | 新 axaml:167-177 |
| 抽屉 41 项条目名称/组别（含源 quirk：「网络延迟」与 ComponentInfo 显示名差异、「 LED 文本仿真显示框」前导空格、行动名含「拉起自定义Windows通知」等） | 逐字符一致（白名单裁剪，名称零改写） | 源 VM:178-333 | 新 VM:724-859 |
| 悬浮窗编辑页：配置方案三按钮 ToolTip（新建/打开悬浮窗配置文件夹/删除当前方案）、行编辑按钮组、外观各项标签与单位、层级置底/置顶、频率 4 项、编辑规则集…、启用/禁用 | 逐字符一致 | 源 axaml:40-497 | 新 axaml:18-356 |
| AiChat 消息编辑 4 按钮：复制（E58B）/修改（ECA7）/保存并重新回答（ECA7）/取消修改（EC9F）+ 尺寸/主题/可见性门 | 逐字符一致（编辑钮限用户消息：嵌套 IsVisible 门，p3-02 §3-1 登记） | 源 axaml:199-237 | 新 axaml 消息模板 |

**登记适配项**（有批登记依据的非逐字符面，非偏差）：

| 面 | 差异 | 依据 |
| --- | --- | --- |
| W7 expander Description | 去拖拽表述（D6 口径） | p3-02 §1-W7 |
| W12 主题 Description | 追加 D5「自适应背景→跟随宿主明暗」注记 | p3-02 §1-W12 |
| W16 频率 Description | 追加 R-3 降级注记 | p3-02 §1-W16 |
| 当前使用模型 Description | A2 适配（源为语音模型检查面） | p3-01 §1.4 |
| PluginDebug 占位文案 | C21 收口（防虚假预期） | p3-02 §7-3 |
| 主页 AI 组描述「可通过上方"获取模型"选择」 | A2 适配语义 | p3-01 §1.4 |

**源侧随源 quirk 如实保留**（非本批引入，零改动符合「随源不改」纪律）：AiChat 空态/错误提示「请先在"更多功能选项"中获取并选择模型」（源 VM:116/:351 同文，源侧模型获取入口即在主设置页，源文自带的指路偏差按随源纪律保留）。

### 3.3 契约核对四：A/B 入口整合语义

- 抽屉枚举 = 注册面白名单：行动 29 + 触发器 2 + 组件 6 + 规则 4 = **41 项**（门关闭时 36 项），与 Plugin.cs `Register*IfEnabled` 37 调用（行动 29+组件 6+触发器 2）+ AddRule 4 一一对应（p2-09 §6 机器复核 37/37 零重复；本核对以 VM:720-859 逐项比对 Plugin.cs 注册 ID 复验）。服务 7/主题 3/设置页 6 不属抽屉可枚举面（p3-05 §3.4-3）。
- 启用门随源：FloatingWindowTrigger + 4 悬浮窗行动条目挂 `EnableFloatingWindowFeature`（VM:750-753/:818-837 ↔ Plugin.cs:301/:362 组门）；ShowAiChatDialog 挂 `EnableAiService`（VM:813-815 ↔ Plugin.cs:326）；实验性门随 C1 整块移除（源 :317-321 无对应）。✓
- 设置页注册门：aiChat=EnableAiService（Plugin.cs:163-166）、悬浮窗编辑页=EnableFloatingWindowFeature（:169-172）、其余 4 页无条件——与源 :178-185/:182-185 形态一致。✓
- 菜单组织（文档第一节描述基准）与 p2-06 微修 1 现态一致：根组「SystemTools 行动」+ 10 组（电源选项…/文件操作…/实用工具…/悬浮窗设置…/媒体工具…/更多功能选项…/高级自动化工具…/AI 功能…/其他工具…/ClassIsland…），悬浮窗设置组=EnableFloatingWindowFeature+HasAnyActionEnabled（:501-507），更多功能选项组门/组内仅 B13/B14（:519-524，USB C 项组门裁剪注记在位）。✓

## 4. 强制约束核销

| # | 约束 | 核销 |
| :-: | --- | --- |
| ① | 菜单树格式修订零注册变更 | 本批零触碰 Plugin.cs/manifest；文档菜单描述以 Plugin.cs:471-545 现态为准，与 p2-06 一致（§3.3 末条） |
| ② | 双分支 API 漂移红线 | 文档仅描述 p2-05 §4 已核 PRESENT 面行为（Toast/窗口层级经宿主接口），未提及或推荐 ABSENT 面（零 `IsBackgroundMaterialEnabled` 等未验证符号引用） |
| ③ | R-2/R-2a 统一口径 | 文档 §0 口径注统一表述：`*Windows.cs`/全文件 `#if Platforms_Windows` 条件编译 + 非 Windows no-op/跳过分支；全文档无大小写混用或死代码形态表述 |
| ④ | S4.2 适用性 | 本批交付面=docs/ + evidence/（均非 Source 面：.md 不入扫描器 SourceFiles 集），扫描不适用，声明见 §5 |
| ⑤ | 沙箱边界 | 源插件/宿主只读（SettingsPage 6 文件 Get-Content 级只读对照）；产品源码零改动；写入仅 `docs\coexistence-notes.md` + 本证据文件 |

## 5. 异常与观察上报（零阻塞，均不在本批写入边界内）

1. **W3/W4 页面描述与降级现状的预期差（建议后续批裁量）**：MoreFeaturesOptionsSettingsPage.axaml:23/:34 描述沿用源文案（「每两秒检测…偏暗时切换黑暗主题」「识别到至少 4 个文字字符时隐藏主界面」），但 AD1/AD2 降级下探测后端全平台未随迁，实际行为=保存配置+服务提示不可用/已降级并保持当前状态。该差异已由 p2-02 登记且文档第二节 2.4 面向用户说明；页面描述本身属「显示文案随源不改」纪律面，本批无权改产品文件，上报尚书省/门下省裁量是否需要页内注记。
2. **主页导航 expander 标题省略号数差（1 字符）**：源 axaml:192 为「更多功能选项……」（双省略号），新 axaml:181 为「更多功能选项…」（单省略号，与源页面自身 SettingsPageInfo 显示名「更多功能选项…」一致，源 MoreFeaturesOptionsSettingsPage.axaml.cs:15）。装饰性零功能影响，上报知悉。
3. **悬浮窗编辑页页脚版权行未随源**：源 axaml:488-493 「Programmer_Wang ©2026」装饰性 TextBlock 未迁（About 页已含版权行）。零功能影响，上报知悉。
4. 产品面异常：除上述 3 项观察外，契约核对未发现悬空绑定/死区/虚假预期文案/入口不一致。

## 6. 边界声明与复核重放

- 写入=2 文件（`docs\coexistence-notes.md`、本证据文件）；源插件检出与宿主检出只读；零产品源码/注册面/manifest 改动。
- S4.2 声明：docs/ 与 evidence/ 非 Source 面，扫描器不适用；文档中出现的 `robocopy`/`EmptyWorkingSet`/`shutdown /g` 等均为行为说明文字，不构成 Source 面符号。
- 本文件不派工、不审批、不推进全局工作流；仅向尚书省回报本批结果，门下省终验。

复核重放：
1. 文档节↔大纲对照：读 `docs\coexistence-notes.md` 与 p3-05 §5 逐节比对；
2. 映射重放：对 §2 表逐行打开 axaml/MainConfigData.cs 行号现态核对（W9 行核对 axaml:199-201 ↔ MainConfigData.cs:387-397）；
3. 悬空绑定重放：对 6 页 axaml 的 Binding 路径逐个 grep 页属/VM/模型成员（IsHistoryOpen 等清单位于 AiChatSettingsViewModel.cs:61-140）；
4. 随源重放：对照源插件 `E:\My Github Projects\SystemTools\SettingsPage\{SystemToolsSettingsPage.axaml:21-206,FloatingWindowEditorSettingsPage.axaml:40-497,AiChatSettingsPage.axaml:180-240,SystemToolsSettingsViewModel.cs:174-333}` 只读比对；
5. 抽屉计数重放：VM:720-859 枚举项计数（组件 6+触发器 2+规则 4+行动 29）↔ Plugin.cs 注册调用 37+AddRule 4。

## 7. 修订记录

- 初版（p3-06 执行交付；基于本轮对 6 页现文件、MainConfigData/Plugin.cs/共享 VM/方案管理器现态实测与源插件 6 文件只读随源核对）。
