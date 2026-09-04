# p1-01 证据：兵部 A 档主题 3 项 + 组件 6 项抽取交付（application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p1-01 · 兵部 war · application-code / implementation |
| 依据 | p0-03 §4.2 A 档清单（主题 3 / 组件 6，范围权威）、p1-05 结构规范（落点/命名空间/ID 前缀/自检规则，全部照办）、p0-01 §3（宿主抽象与缺口 G1–G3）、04-spec（U5、R-10、S4.2 门禁）、p0-07 扫描器 |
| 交付点 | `src\SystemTools.CrossPlatform\` 下 `Themes\`（3 目录 21 文件）+ `Controls\Components\`（24 文件）+ `Models\ComponentSettings\`（6 文件）+ `Converters\`（1 共享文件，§6.1）＝ **52 文件** |
| 结论 | **succeeded** —— 9 项功能（3+6）逐项落位、S4.2 四段扫描全 PASS（exit=0，GUID 裁决落实后复跑结论不变）、macOS 自检表无"不适用"行、结构自检六项全过；1 项共享转换器按 p1-05 §2.3-2 首需引入；组件 GUID 同装碰撞风险已按尚书省裁决落实为**新 GUIDv5 集改写**（6 处，旧→新映射与零重合自证见 §3.4/§7.1）；接线需求 6 项（§6.2） |
| 边界 | 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读；本批写入仅上述交付目录 + 本案卷 evidence/（2 个文件）；未触碰 Plugin.cs / manifest.yml（插件级）/ csproj / global.json / slnx |

---

## 1. 逐项源 file:line 对照与落点清单（9 功能项 + 附属）

### 1.1 主题 3 项（落点 `Themes\<主题>\`，p1-05 §2.1/§6 表）

| # | 功能项（p0-03 §4.2 行） | 源文件 → 新落点（文件名随源） | 源锚点（file:line） | 改写点 |
| --- | --- | --- | --- | --- |
| T1 | CardTypeComponent 主题 | `Themes\CardTypeComponent\manifest.yml`（11→12 行） | 源 manifest.yml:1（`id: Card-type-component`）；注册锚点源 Plugin.cs:79 | id 前缀改写（§2）；banner 随源 |
| T1 | 〃 | `Themes\CardTypeComponent\Theme.axaml.txt`（471 行） | 源同路径（全文复制） | 无（全文无 SystemTools 引用/资源键随源） |
| T1 | 〃 | `Themes\CardTypeComponent\Styles.axaml`（4 行） | 源 Styles.axaml:2 | xmlns 主题命名空间改写 |
| T1 | 〃 | `Themes\CardTypeComponent\CardTypeComponentStyles.cs`（32 行） | 源 :8（namespace）、:12-13（ThemeResourceUri） | namespace + avares URI（2 处） |
| T2 | ClassWidgets 主题 | `Themes\ClassWidgets\manifest.yml`（11→12 行） | 源 manifest.yml:1（`id: classwidgets`）；注册锚点源 Plugin.cs:91 | id 前缀改写（§2）；banner 随源 |
| T2 | 〃 | `Themes\ClassWidgets\Theme.axaml.txt`（551 行） | 源同路径（全文复制） | 无（全文无 SystemTools 引用） |
| T2 | 〃 | `Themes\ClassWidgets\Styles.axaml`（4 行） | 源 Styles.axaml:2 | xmlns 主题命名空间改写 |
| T2 | 〃 | `Themes\ClassWidgets\ClassWidgetsStyles.cs`（37 行） | 源 :9（namespace）、:14（URI） | namespace + avares URI（2 处） |
| T2 | 〃 | `Themes\ClassWidgets\ClassWidgetsCard.axaml`（337 行） | 源 :1（x:Class）、:7（local）、:38/:53/:68（3 张位图 URI） | x:Class + xmlns + 3×avares URI（5 处） |
| T2 | 〃 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs`（1048 行） | 源 :17（namespace） | namespace（1 处） |
| T2 | 〃 | `Themes\ClassWidgets\上课.png` / `课间休息.png` / `无课程.png`（二进制） | 源同路径（文件名含中文名随源不改，p1-05 §2.4-1） | 无 |
| T3 | NotchStyle 主题 | `Themes\NotchStyle\manifest.yml`（11→12 行） | 源 manifest.yml:1（`id: notch-style`）；注册锚点源 Plugin.cs:103 | id 前缀改写（§2）；banner/repoName 随源（§7.2） |
| T3 | 〃 | `Themes\NotchStyle\Theme.axaml.txt`（211 行） | 源 :7（xmlns:theme + assembly） | clr-namespace + assembly（2 处） |
| T3 | 〃 | `Themes\NotchStyle\Styles.axaml`（4 行） | 源 Styles.axaml:2（xmlns:theme + assembly） | clr-namespace + assembly（2 处） |
| T3 | 〃 | `Themes\NotchStyle\NotchStyleStyles.cs`（29 行） | 源 :8（namespace）、:13（URI） | namespace + avares URI（2 处） |
| T3 | 〃 | `Themes\NotchStyle\NotchClipControl.cs`（26 行）/ `NotchFrameControl.cs`（51 行）/ `NotchMaterialControl.cs`（36 行）/ `NotchShapeGeometry.cs`（48 行） | 源各自 :6/:6/:5/:5（namespace） | 各 namespace（4 处） |

U5 决议落实：源 `ThirdParty\LiquidGlassAvaloniaUI` 液态玻璃构造零迁入（源 ClassWidgets/NotchStyle 主题文件本身不含 ThirdParty 引用，已逐文件核实）；无任何 Windows-only 资产进入交付。

### 1.2 组件 6 项（落点 `Controls\Components\` + `Models\ComponentSettings\`，p1-05 §2.1/§6 表）

每组 = `*Component.axaml` + `*Component.axaml.cs` + `*SettingsControl.axaml` + `*SettingsControl.axaml.cs`（成对，Controls\Components\）+ `*Settings.cs`（Models\ComponentSettings\）。

| # | 功能项 | 组件注册锚点（源 file:line） | 成对文件（4，文件名随源） | 设置模型（1） |
| --- | --- | --- | --- | --- |
| C1 | 网络延迟检测 NetworkStatus | `NetworkStatusComponent.axaml.cs:17-22`（ComponentInfo） | NetworkStatusComponent.axaml（25 行）/.axaml.cs（269 行）/ NetworkStatusSettingsControl.axaml（86 行）/.axaml.cs（12 行） | NetworkStatusSettings.cs（22 行） |
| C2 | 显示剪切板内容 ClipboardContent | `ClipboardContentComponent.axaml.cs:14`（ComponentInfo） | ClipboardContentComponent.axaml（23）/.axaml.cs（119）/ ClipboardContentSettingsControl.axaml（15）/.axaml.cs（13） | ClipboardContentSettings.cs（8 行） |
| C3 | 本地一言 LocalQuote | `LocalQuoteComponent.axaml.cs:23`（ComponentInfo） | LocalQuoteComponent.axaml（45）/.axaml.cs（427）/ LocalQuoteSettingsControl.axaml（114）/.axaml.cs（50） | LocalQuoteSettings.cs（52 行） |
| C4 | 下节课是 NextClassDisplay | `NextClassDisplayComponent.axaml.cs:14`（ComponentInfo） | NextClassDisplayComponent.axaml（51）/.axaml.cs（206）/ NextClassDisplaySettingsControl.axaml（51）/.axaml.cs（13） | NextClassDisplaySettings.cs（16 行） |
| C5 | 更好的轮播容器 BetterCarouselContainer | `BetterCarouselContainerComponent.axaml.cs:22`（ComponentInfo） | BetterCarouselContainerComponent.axaml（134）/.axaml.cs（623）/ BetterCarouselContainerSettingsControl.axaml（146）/.axaml.cs（146） | BetterCarouselContainerSettings.cs（197 行） |
| C6 | ScrollingText | `ScrollingTextComponent.axaml.cs:17`（ComponentInfo） | ScrollingTextComponent.axaml（69）/.axaml.cs（132）/ ScrollingTextSettingsControl.axaml（49）/.axaml.cs（15） | ScrollingTextSettings.cs（18 行） |

范围裁决：`LyricsDisplayComponent`（音乐歌词，p0-03 §4.2 组件行 C 档 1 项）**未抽取**，与 A 档 6 项清单一致；源 Components 目录其余 2 文件（LyricsDisplay 对）零触碰。

### 1.3 共享附属文件（p1-05 §2.3-2 首需引入）

| 文件 | 源 file:line | 引入理由 | 共享声明 |
| --- | --- | --- | --- |
| `Converters\EnumDescriptionConverter.cs`（38 行） | 源 `Converters\EnumDescriptionConverter.cs:7`（namespace）、:25-27（对 NetworkDetectMode 的中文回退） | C1/C3/C5 三个设置控件 axaml:17 均引用 `clr-namespace:SystemTools.Converters` 的 `EnumDescriptionConverter`；本批为**首个需要批次**（p1-02 已先行落盘但未含 Converters） | **共享，后续批次复用**（预期 p1-03 行动设置控件引用；后续只引用不重复定义） |

## 2. 资源 URI 改写点清单（`avares://SystemTools/` → `avares://SystemTools.CrossPlatform/`，共 6 处）

| # | 文件:行（新） | 改写内容 |
| --- | --- | --- |
| 1 | `Themes\CardTypeComponent\CardTypeComponentStyles.cs:13` | `Theme.axaml.txt` 装载 URI |
| 2 | `Themes\ClassWidgets\ClassWidgetsStyles.cs:14` | `Theme.axaml.txt` 装载 URI |
| 3 | `Themes\ClassWidgets\ClassWidgetsCard.axaml:38` | `上课.png` |
| 4 | `Themes\ClassWidgets\ClassWidgetsCard.axaml:53` | `课间休息.png` |
| 5 | `Themes\ClassWidgets\ClassWidgetsCard.axaml:68` | `无课程.png` |
| 6 | `Themes\NotchStyle\NotchStyleStyles.cs:13` | `Theme.axaml.txt` 装载 URI |

其他命名类改写（非 avares，同属"程序集/命名空间身份"改写，数量为交付文件实测）：namespace 27 处、`using SystemTools.Models.ComponentSettings` → `using SystemTools.CrossPlatform.Models.ComponentSettings` 12 处、`x:Class` 13 处、`clr-namespace:SystemTools.*` 31 处、`assembly=SystemTools` → `assembly=SystemTools.CrossPlatform` 2 处（NotchStyle Styles.axaml:2 + Theme.axaml.txt:7）。`x:Key`/样式选择器/动态资源键随源零改写（p1-05 §3.4-3）。自检：新程序 `avares://SystemTools.CrossPlatform/` 恰 6 处；旧 `avares://SystemTools/` 零残留；`assembly=SystemTools"` 零残留。

## 3. p1-05 §4.2 结构化注册清单（交接礼部 p1-06；本批不写任何注册代码）

### 3.1 组件 6 项

| 项 | 类型全名 | 功能 ID（注册名，§3.3 前缀规则） | 注册目标 | 设置类型全名 | 源锚点 |
| --- | --- | --- | --- | --- | --- |
| C1 网络延迟检测 | `SystemTools.CrossPlatform.Controls.Components.NetworkStatusComponent` | `SystemTools.CrossPlatform.NetworkStatus` | 组件注册（源形态：`RegisterComponentIfEnabled<TComponent,TSettingsControl>` + `services.AddComponent<TComponent,TSettingsControl>()`，源 Plugin.cs:603-610/517-534 先例） | `SystemTools.CrossPlatform.Models.ComponentSettings.NetworkStatusSettings` | 源 ComponentInfo `NetworkStatusComponent.axaml.cs:17`；注册 ID 源值 `SystemTools.NetworkStatus`（Plugin.cs:521-522） |
| C2 显示剪切板内容 | `SystemTools.CrossPlatform.Controls.Components.ClipboardContentComponent` | `SystemTools.CrossPlatform.ClipboardContent` | 同上 | `SystemTools.CrossPlatform.Models.ComponentSettings.ClipboardContentSettings` | 源 `:14`；Plugin.cs:525-526 |
| C3 本地一言 | `SystemTools.CrossPlatform.Controls.Components.LocalQuoteComponent` | `SystemTools.CrossPlatform.LocalQuote` | 同上 | `SystemTools.CrossPlatform.Models.ComponentSettings.LocalQuoteSettings` | 源 `:23`；Plugin.cs:527-528 |
| C4 下节课是 | `SystemTools.CrossPlatform.Controls.Components.NextClassDisplayComponent` | `SystemTools.CrossPlatform.NextClassDisplay` | 同上 | `SystemTools.CrossPlatform.Models.ComponentSettings.NextClassDisplaySettings` | 源 `:14`；Plugin.cs:529-530 |
| C5 更好的轮播容器 | `SystemTools.CrossPlatform.Controls.Components.BetterCarouselContainerComponent` | `SystemTools.CrossPlatform.BetterCarouselContainer` | 同上 | `SystemTools.CrossPlatform.Models.ComponentSettings.BetterCarouselContainerSettings` | 源 `:22`；Plugin.cs:531-532 |
| C6 滚动文本 | `SystemTools.CrossPlatform.Controls.Components.ScrollingTextComponent` | `SystemTools.CrossPlatform.ScrollingText` | 同上 | `SystemTools.CrossPlatform.Models.ComponentSettings.ScrollingTextSettings` | 源 `:17`；Plugin.cs:533-534 |

配套设置控件类型（AddComponent 第二泛参，全名按 §3.2）：`SystemTools.CrossPlatform.Controls.Components.NetworkStatusSettingsControl` / `ClipboardContentSettingsControl` / `LocalQuoteSettingsControl` / `NextClassDisplaySettingsControl` / `BetterCarouselContainerSettingsControl` / `ScrollingTextSettingsControl`。

### 3.2 主题 3 项

| 项 | 类型全名 | 主题 ID（§3.3 前缀规则） | 注册目标 | 设置类型全名 | 源锚点 |
| --- | --- | --- | --- | --- | --- |
| T1 CardTypeComponent | `SystemTools.CrossPlatform.Themes.CardTypeComponent.CardTypeComponentStyles` | `SystemTools.CrossPlatform.Card-type-component` | 主题注册（源 Plugin.cs:76-84 形态：Uri + Id/Name/Description；属礼部） | 无 | 源 Id `Plugin.cs:79` + 主题 manifest.yml:1 |
| T2 ClassWidgets | `SystemTools.CrossPlatform.Themes.ClassWidgets.ClassWidgetsStyles` | `SystemTools.CrossPlatform.classwidgets` | 同上 | 无 | 源 `Plugin.cs:91` + manifest.yml:1 |
| T3 NotchStyle | `SystemTools.CrossPlatform.Themes.NotchStyle.NotchStyleStyles` | `SystemTools.CrossPlatform.notch-style` | 同上 | 无 | 源 `Plugin.cs:103` + manifest.yml:1 |

主题 manifest.yml 为主题发现资产（p1-05 §4.3-1）：id 已按前缀规则改写为 `SystemTools.CrossPlatform.*`（3 份），其余字段随源；礼部 p1-06 复核 Plugin.cs 注册 Id 与 manifest id 一致性时以本表为基准。

### 3.3 ComponentInfo GUID（裁决后状态：新 GUID 集，详见 §3.4/§7.1）

组件类内 `[ComponentInfo("<GUID>", …)]` 第一参为宿主组件 GUID 身份（`ClassIsland.Core\Attributes\ComponentInfo.cs:19/96` `Guid.Parse`）。按尚书省裁决（本批上报项回复：采纳方案 b），6 处首参已**全部改写为规范 GUIDv5 新值**，与源插件全部 GUID 零重合（映射表与零重合自证见 §3.4）；其余参数（显示名/图标/描述）随源零改写。字符串 ID（§3.1 前缀规则）与主题 manifest id（§3.2）不受该裁决影响，维持既有改写。

### 3.4 旧→新 GUID 映射表（裁决落实记录，全局规则同步件）

| 组件 | 源 GUID（原值留痕） | 新 GUID（规范 GUIDv5，交付文件现状） | 新值落点 |
| --- | --- | --- | --- |
| NetworkStatusComponent | `8F5E2D1C-3B4A-5678-9ABC-DEF012345678` | `056130C1-2B02-5BBE-A99F-C5EC448D6221` | `Controls\Components\NetworkStatusComponent.axaml.cs` ComponentInfo 首参 |
| ClipboardContentComponent | `E2A41B7D-9F36-4A08-8B8D-1BA29E570F62` | `F3A18AE1-C153-5C1C-A660-D7E48DDDCC84` | `Controls\Components\ClipboardContentComponent.axaml.cs` 同上 |
| LocalQuoteComponent | `5D2C0E65-8648-4A67-BBEA-3FA713B1CF8D` | `885F26B9-DC4E-5DBC-9C65-64C185E5A532` | `Controls\Components\LocalQuoteComponent.axaml.cs` 同上 |
| NextClassDisplayComponent | `C3E56B6B-0E01-4F3C-8F7B-9264CA2B2143` | `0182775C-049B-532C-BF56-14FC3CEC02A1` | `Controls\Components\NextClassDisplayComponent.axaml.cs` 同上 |
| BetterCarouselContainerComponent | `A7C3455E-6A4E-4D4D-9D0D-7C6FCB5E1E3A` | `E6FC9A28-A104-50F2-95E3-B237F9CC4DAC` | `Controls\Components\BetterCarouselContainerComponent.axaml.cs` 同上 |
| ScrollingTextComponent | `A7B3E4D1-2F8C-4B9A-9E5D-6C1B2A3F4E5D` | `E02A4DC6-88DE-551C-826F-A5262668AB3A` | `Controls\Components\ScrollingTextComponent.axaml.cs` 同上 |

生成方式（**确定性派生，复核可重放**）：RFC 4122 §4.3 GUIDv5（SHA-1）。根命名空间 UUID = `GUIDv5(DNS 命名空间 {6BA7B810-9DAD-11D1-80B4-00C04FD430C8}, "systemtools-cross-platform.plugin.classisland")` = `e6b582c9-7606-5617-b55e-020dc6ea96c4`；组件值 = `GUIDv5(根命名空间, "<新命名空间全名>")`，名字串即 §3.1"类型全名"列，与源 GUID 无任何输入耦合——任一标准 SHA-1 v5 实现重放均可复现同值。

零重合自证：① 源插件 GUID 全集 = **17 个唯一 GUID 形态串**（全源检索 `*.cs/*.axaml/*.xaml/*.yml/*.yaml/*.txt/*.json/*.props/*.csproj`，排除 bin/obj/.git/.idea，353 文件）；② 新 6 值对全集检索 **0 命中**；③ 6 值两两互异（6/6）；④ 格式自证：第 3 组首 nibble=5（v5，6/6）、第 4 组首 nibble ∈ {8,9,a,b}（RFC variant，6/6）；⑤ 旧源 GUID 与首版派生中间值在本批交付目录零残留（grep 实证）。

## 4. p1-05 §5.3 macOS 兼容自检表（覆盖本批全部外部依赖点；BCL 纯 .NET API 注"BCL"）

适配方式枚举口径：宿主跨平台抽象（须 p0-01 §3 已核实）／Avalonia·FluentAvalonia·SDK 跨平台 API／BCL／删除（守卫分支）／按已批降级口径。

| # | 源点（源文件:行） | 依赖/符号（API·服务·进程·包） | 适配方式 | macOS 语义 |
| --- | --- | --- | --- | --- |
| 1 | `Themes\CardTypeComponent\CardTypeComponentStyles.cs:17-24` | `AppDomain.GetAssemblies` + `AssetLoader.Open` + `AvaloniaRuntimeXamlLoader.Load` | BCL + Avalonia SDK 跨平台 API | 可用（Avalonia 三平台运行时 XAML 装载） |
| 2 | `Themes\ClassWidgets\ClassWidgetsStyles.cs:23-33` | 同上 + `FuncDataTemplate` | Avalonia SDK 跨平台 API | 可用 |
| 3 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs:32,269-273` | `DispatcherTimer`、`GetObservable`、Attached/Detached 事件 | Avalonia SDK 跨平台 API | 可用 |
| 4 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs:439` | `IAppHost.TryGetService<IExactTimeService>` | ClassIsland SDK 服务抽象 | 可用（IExactTimeService 为宿主核心服务，非 G1–G3 缺口接口） |
| 5 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs:424,444,461` | `ILessonsService`/`IWeatherService`（PostMainTimerTicked/CurrentTimeStateChanged/GetWeatherTextByCode） | ClassIsland SDK 服务抽象 | 可用（纯托管事件/查询，无平台原生调用） |
| 6 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs:899-919,962-986` | 反射属性读取（`GetProperty`/`GetValue`） | BCL | 可用（宿主组件运行时自省，AOT 场景之外的插件形态，与源一致） |
| 7 | `Themes\ClassWidgets\ClassWidgetsCard.axaml.cs:621-691` | `Task.Delay` + `CancellationTokenSource` | BCL | 可用 |
| 8 | `Themes\NotchStyle\NotchShapeGeometry.cs:18-47` | `StreamGeometry`/`Point`/`CubicBezierTo` | Avalonia SDK 跨平台 API | 可用 |
| 9 | `Themes\NotchStyle\NotchClipControl.cs:13,23` / `NotchFrameControl.cs:40-50` / `NotchMaterialControl.cs:34` | `Decorator.Clip`、`DrawingContext.DrawGeometry`、`Pen`、`MainWindowStylesAssist.GetCornerRadius` | Avalonia SDK 跨平台 API | 可用 |
| 10 | `Themes\*\Theme.axaml.txt`（CardType:57 / ClassWidgets:16 / Notch:14） | `StyleInclude Source="avares://ClassIsland/..."`（宿主 MainWindowLine 样式）+ `MainWindowBackgroundMaterialControl`/`MainWindowStylesAssist` | 宿主资产与 Avalonia 控件（ClassIsland.* 引用面，p1-05 §3.2-4 允许） | 可用（宿主 UI 为 Avalonia 三平台实现） |
| 11 | `Themes\ClassWidgets\ClassWidgetsCard.axaml:38,53,68` | avares 位图资产（3 PNG） | Avalonia SDK 跨平台 API（经 AvaloniaResource 装载，接线见 §6.2） | 可用 |
| 12 | `Controls\Components\NetworkStatusComponent.axaml.cs:70-74` | `HttpClient`（5s 超时 + User-Agent 头） | BCL | 可用 |
| 13 | `Controls\Components\NetworkStatusComponent.axaml.cs:188-189` | `System.Net.NetworkInformation.Ping`/`SendPingAsync` | BCL 跨平台 API | 可用（.NET 10 三平台 Ping 支持；ICMP 语义由 .NET 实现差异按源行为接受，HTTP 模式为设置项回退） |
| 14 | `Controls\Components\NetworkStatusComponent.axaml.cs:224-239` | `Stopwatch` | BCL | 可用 |
| 15 | `Controls\Components\NetworkStatusComponent.axaml.cs:64-68` | `DispatcherTimer` | Avalonia SDK 跨平台 API | 可用 |
| 16 | `Controls\Components\ClipboardContentComponent.axaml.cs:85-97` | `TopLevel.GetTopLevel` + `topLevel.Clipboard` + `ClipboardExtensions.TryGetTextAsync` | Avalonia SDK 跨平台 API | 可用（Avalonia 剪贴板三平台后端） |
| 17 | `Controls\Components\LocalQuoteComponent.axaml.cs:77-82` | `ILessonsService` 构造注入 + `DispatcherTimer` | ClassIsland SDK 服务抽象 + Avalonia | 可用 |
| 18 | `Controls\Components\LocalQuoteComponent.axaml.cs`（System.IO 使用点） | `File`/`Path` 读取本地一言 txt | BCL | 可用（路径来自用户设置，跨平台路径语义随 .NET） |
| 19 | `Controls\Components\LocalQuoteSettingsControl.axaml.cs:23-35` | `TopLevel.StorageProvider.OpenFilePickerAsync`（FilePickerOpenOptions/FilePickerFileType） | Avalonia SDK 跨平台 API | 可用（macOS NSOpenPanel 后端） |
| 20 | `Controls\Components\NextClassDisplayComponent.axaml.cs:102-106` | `ILessonsService`/`IProfileService`/`IExactTimeService` 注入 | ClassIsland SDK 服务抽象 | 可用（纯托管课表/时间查询） |
| 21 | `Controls\Components\BetterCarouselContainerComponent.axaml.cs:92-96` | `IRulesetService`/`ILessonsService` 注入 | ClassIsland SDK 服务抽象 | 可用 |
| 22 | `Controls\Components\BetterCarouselContainerComponent.axaml.cs`（Animation 构造点）+ `ScrollingTextComponent.axaml.cs`（Animation/DispatcherTimer） | Avalonia `Animation`/`Easing`/`Transitions` | Avalonia SDK 跨平台 API | 可用 |
| 23 | `Models\ComponentSettings\BetterCarouselContainerSettings.cs` + `BetterCarouselContainerSettingsControl.axaml.cs` | `CommunityToolkit.Mvvm.ComponentModel`（ObservableObject 等）+ `ClassIsland.Core.Models.Components.ComponentSettings`/`AssociatedComponentInfo` | SDK 传递包（ClassIsland.Shared.csproj:21 引用 8.2.1，经 PluginSdk→Core→Shared 编译期可达）+ ClassIsland SDK 模型 | 可用（纯托管） |
| 24 | `Converters\EnumDescriptionConverter.cs:11-37` | `System.ComponentModel.DescriptionAttribute` + `GetField`/`GetCustomAttribute` 反射 | BCL | 可用 |
| 25 | `Controls\Components\*.axaml`（6 组件 + 6 设置控件） | `ci:`（classisland.tech XAML 命名空间）、FluentAvalonia 控件（FASettingsExpander 等）、DynamicResource 主题键 | Avalonia/FluentAvalonia/宿主 XAML 基建 | 可用（宿主三平台 XAML 编译与主题资源） |

**结论：25 行全部"可用"，无"不适用"行**（p1-05 §5.3-2 阻塞条件未触发）；零 G1–G3 缺口接口消费（`ISystemEventsService`/`IDesktopService` 零引用，已 grep 实证）；零平台分叉（无 `#if Platforms_*`、无平台子目录、无自定义平台常量、无硬编码 TFM、无 x86/x64 限定）；零守卫分支删除需要（本批源文件无 `OperatingSystem.IsWindows()` 分支）。

## 5. S4.2 门禁自检（p1-05 §5.2）

| 段 | -Path | GateHits | InfoHits | VERDICT | exit |
| --- | --- | --: | --: | --- | --: |
| 1 | `src\SystemTools.CrossPlatform\Themes` | 0 | 0 | PASS | 0 |
| 2 | `src\SystemTools.CrossPlatform\Controls\Components` | 0 | 0 | PASS | 0 |
| 3 | `src\SystemTools.CrossPlatform\Models\ComponentSettings` | 0 | 0 | PASS | 0 |
| 4 | `src\SystemTools.CrossPlatform\Converters` | 0 | 0 | PASS | 0 |

原始输出留档：`p1-01-s42-scan-output.txt`（本案卷 evidence/，含四段完整输出与重放命令；**本文件现为 GUID 裁决落实后的复跑记录**，改写前首轮扫描同为全 PASS，两轮结论一致）。INFO 规则（I*）零命中 → §5.3 表无 INFO 逐条说明项。`.cs` 注释清理：本批交付的 .cs/.axaml/.txt/.yml 中无禁用符号提及（扫描与 V2/V3 正则双重实证），无需注释清理记录。
**AVLN2000 修复后第三轮复扫（UTC 2026-09-03T19:34:04~06Z）**：`ClassWidgetsCard.axaml` 单文件直扫 + 四目录复扫全 PASS（GateHits=0/InfoHits=0/exit=0），与本节历史两轮结论一致；本轮输出同口径可由 §8 复核命令 2 重放（单文件命令：`pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Themes\ClassWidgets\ClassWidgetsCard.axaml -Scope Source`）。

补充结构自检（p1-05 §8 对齐）：V1 `namespace (?!SystemTools\.CrossPlatform)` 在本批 27 个 .cs 上零命中；V2 裸 `using SystemTools.*` 零命中；V3 裸 `SystemTools.` 字符串在本批 49 个文本文件零命中（工作区唯一直击项在 p1-02 批文件 `Triggers\ActionInProgressTrigger.cs:16` 注释内，非本批交付物）；V4 旧 `avares://SystemTools/` 零残留；V5 `assembly=SystemTools"` 零残留。批内零平台分叉文件。

## 6. 共享引入与工程接线需求

### 6.1 共享转换器引入声明（p1-05 §2.3-2）

`Converters\EnumDescriptionConverter.cs` 由本批（首个需要批次）引入，落点 `Converters\`、命名空间 `SystemTools.CrossPlatform.Converters`、类型名随源不改、行为逐行保留（含对 `NetworkDetectMode` 三值的中文回退）；已过 S4.2 自检（§5 段 4）。**共享，后续批次复用**：预期 p1-03 行动设置控件引用该类型，后续批次只引用、不重复定义。源侧 `Converters\` 目录仅此一文件，无遗留转换器需引入。

### 6.2 接线需求清单（csproj 变更不自批改，按 p1-05 §4.4-2 登记）

| # | 目标文件 | 期望 ItemGroup 形态 | 依据 |
| --- | --- | --- | --- |
| 1 | `src\SystemTools.CrossPlatform\SystemTools.CrossPlatform.csproj` | `<AvaloniaResource Include="Themes\CardTypeComponent\Theme.axaml.txt" />` | 源 SystemTools.csproj:31 同形；`AssetLoader.Open` 运行时按程序集资源装载 |
| 2 | 〃 | `<AvaloniaResource Include="Themes\ClassWidgets\Theme.axaml.txt" />` | 源 :32 |
| 3 | 〃 | `<AvaloniaResource Include="Themes\NotchStyle\Theme.axaml.txt" />` | 源 :33 |
| 4 | 〃 | `<AvaloniaResource Include="Themes\ClassWidgets\上课.png" />` | 源 :34；ClassWidgetsCard.axaml:38 位图 URI 消费 |
| 5 | 〃 | `<AvaloniaResource Include="Themes\ClassWidgets\课间休息.png" />` | 源 :35 |
| 6 | 〃 | `<AvaloniaResource Include="Themes\ClassWidgets\无课程.png" />` | 源 :36 |

无需接线的说明：① 24 个 `.axaml` 由 Avalonia 构建目标自动收集为 AvaloniaXaml（源插件与宿主 Core 均未显式列出 axaml 的同构先例，宿主 Core.csproj:89 仅显式列 Assets/** 资产）；② `CommunityToolkit.Mvvm 8.2.1` 经 PluginSdk→Core→Shared 传递可达（`ClassIsland.Shared.csproj:21`），本批消费方（BetterCarouselContainerSettings 等）无需直接 PackageReference；③ 其余包（Avalonia/FluentAvalonia/DI）按 p0-04 传递消费口径不变。接线需求合计 **6 项**。

## 7. 上报与风险登记（不阻塞本批文件交付，报尚书省裁决/知悉）

### 7.1 组件 GUID 同装碰撞风险 → **裁决已落实（新 GUID 集改写完成）**

- **上报事实（裁决前登记）**：宿主组件注册按 GUID 去重，重复即抛错——`ClassIsland.Core\Extensions\Registry\ComponentRegistryExtensions.cs:46-49`：`if (ComponentRegistryService.Registered.FirstOrDefault(x => x.Guid == info.Guid) != null) throw new ArgumentException("此组件id {info.Guid} 已经被占用。")`。源 GUID 复用将在 R-10 同装并存场景破坏并存注册。
- **裁决**：尚书省采纳方案 b)——新插件全部 GUID 形态注册身份一律采用新 GUID、与源插件全部 GUID 零重合；生成方式二选一；旧→新映射留痕；字符串 ID（前缀规则）与主题 manifest id 不变。该规则同步为全局规则（p1-04/p1-05 适用）。
- **落实记录**：选择**确定性派生**（GUIDv5，可复核重放）——派生定义与旧→新映射表见 §3.4；6 处 ComponentInfo 首参改写完成（每文件恰 1 处，其余参数随源零改写）；零重合自证五项全过（§3.4）；旧源 GUID 在本批交付目录零残留。
- **复跑**：四段 S4.2 扫描复跑全 PASS（GateHits=0/exit=0，`p1-01-s42-scan-output.txt` 已覆盖留档复跑记录）；结构自检六项重放全过；macOS 自检表不受影响（GUID 为纯托管身份令牌，无平台语义）。

### 7.2 源侧既有观察点（随源保留，不影响兼容结论）

- `NetworkStatusSettingsControl.axaml:79-82` 等 4 处 `Label`"Added by SystemTools"字样及 `MaterialDesignBodyLight` DynamicResource 键：宿主主题无该资源键时 DynamicResource 空解析、控件回退默认前景色（编译无碍、三平台行为一致）；文案/资源键随源不改（p1-05 §3.4-3）。
- `NetworkStatusComponent.axaml.cs:74` HTTP User-Agent 字面量 `SystemTools/1.0`：非注册 ID（斜杠形态，不在 `"SystemTools\.` 检查面），随源保留。
- 3 份主题 manifest.yml 的 `banner: ../../../Cache/SystemTools/...` 与 NotchStyle `repoName: SystemTools`：schema 外字段（p0-05 §3 #66 实证宿主 `IgnoreUnmatchedProperties` 忽略）、主题分发资产路径随源不改；非功能 ID、非 avares URI，不在前缀规则范围。

### 7.3 中断恢复说明

本派工曾因宿主后台意外关闭中断（中断发生于产出前，src 下无本批任何文件）。本次为从头完整执行：上述全部交付与自检均为本轮现场产出，无跨轮残留文件。

### 7.4 AVLN2000 修复登记（尚书省修复指令 p1-10 第三轮；U5 降级新适配点）

- **缺陷**：工部 p1-10 第三轮构建日志 `p1-10-build-fallback-win-r3.log`：`Themes/ClassWidgets/ClassWidgetsCard.axaml(92,17): AVLN2000: Unable to find IsBackgroundMaterialEnabledProperty field on type ClassIsland.Core.Assists.MainWindowStylesAssist,ClassIsland.Core`。
- **根因精确化（只读取证，修正派工分析中的缺位面定位）**：缺位面在 **NuGet 后备分支的 ClassIsland.Core 2.1.1.1 包二进制**——`C:\Users\0\.nuget\packages\classisland.core\2.1.1.1\lib\net10.0\ClassIsland.Core.dll` 元数据串检索 `IsBackgroundMaterialEnabled`/`EffectiveBackgroundOpacity`/`MainWindowBackgroundMaterialControl` 均 **ABSENT**；而 **U3 本地检出源码** `ClassIsland.Core\Assists\MainWindowStylesAssist.cs:56-60` **含**该附加属性，标准分支构建日志 `p1-10-build-standard-detailed.log` 无 AVLN2000。该轮 assets.json 实证解析 `ClassIsland.Core/2.1.1.1` 包（fallback 形态）。即：**双分支 API 漂移**（本地检出源码 = NuGet 包二进制的超集），任何仅存于本地检出的 API 都将阻塞后备分支可构建性（CP-0.1/0.2 双形态要求）。
- **修复（bounded 最小改动）**：交付文件 `Themes\ClassWidgets\ClassWidgetsCard.axaml` 移除该 `IsVisible="{Binding !$self.(assists:MainWindowStylesAssist.IsBackgroundMaterialEnabled), Mode=OneWay}"` 属性行（源 :92），注释（源 :86-89）同步改写为 U5 降级口径并留痕（卡片**恒经典 CW2 外观**；宿主背景材质开关属 U5 排除面且后备分支无此 API）；同 Border 的 `CornerRadius` 绑定与其余内容零改动。
- **行为语义**：源行为"宿主原生材质启用时隐藏 CW2 框（材质框替代）"；新行为"恒显示 CW2 框"。与 04-spec U5"浮窗恒经典外观、背景采样不迁"的组件面等价落点一致。
- **复扫**：单文件直扫 + 四目录复扫全 PASS（UTC 2026-09-03T19:34:04~06Z，GateHits=0/exit=0）；`IsBackgroundMaterialEnabled|BackgroundMaterialType` 在本批全批零残留；结构自检 V1–V5 重放全过；macOS 自检表不受影响（纯 XAML 绑定移除，无平台语义）。

### 7.5 横查结论（防同类缺陷；逐文件存在性核对）

**面 1：编译面**（Avalonia 编译器逐符号检查对象 = 24 组件 axaml + ClassWidgetsCard.axaml + 3 Styles.axaml + 全部 .cs；约束 = NuGet 后备分支包与本地检出双分支）：

| 文件（交付落点） | 宿主引用符号 | NuGet 后备 Core 2.1.1.1 | 本地检出源码 | 结论 |
| --- | --- | --- | --- | --- |
| `Themes\ClassWidgets\ClassWidgetsCard.axaml` | `MainWindowStylesAssist.IsBackgroundMaterialEnabled` | ABSENT（字节检索） | PRESENT（Assists\MainWindowStylesAssist.cs:56-60） | **已移除（§7.4）** |
| 〃 | `MainWindowStylesAssist.CornerRadius`（绑定 :93） | PRESENT | PRESENT（:19-23） | 保留 ✓ |
| 〃 + 6 设置控件 axaml | `ci:SizeDoubleToCornerRadiusConverter`、`ci:FluentIcon(Source)`、`controls:FASettingsExpander`（FluentAvalonia） | PRESENT（`SizeDoubleToCornerRadiusConverter`/`FluentIconSource`/`ComponentBase` 字节检索 PRESENT；r3 构建全量 axaml 编译仅 1 错为旁证） | PRESENT | ✓ |
| `Themes\NotchStyle\NotchClipControl.cs`/`NotchFrameControl.cs`/`NotchMaterialControl.cs` | `MainWindowStylesAssist.GetCornerRadius`、`.CornerRadiusProperty` | PRESENT | PRESENT | ✓ |
| 12 组件 .axaml.cs + 6 模型 .cs + 3 Styles.cs | ClassIsland.Core/Shared SDK API、CommunityToolkit.Mvvm | C# 编译两轮已消错（工部 p1-10 日志结论） | 〃 | ✓（构建实证） |

**面 2：运行时面**（3 份 Theme.axaml.txt 为运行时装载资产、不参与 XAML 编译，解析于运行时宿主二进制 = U3 检出构建；NuGet 包仅编译期消费，不构成运行时约束）：

| 运行时引用 | 本地检出（= 运行时宿主 API） | 结论 |
| --- | --- | --- |
| `MainWindowBackgroundMaterialControl` + `EffectiveBackgroundOpacity`（CardType Theme:66-67、ClassWidgets Theme:24-25） | PRESENT（`ClassIsland.Core\Controls\MainWindowBackgroundMaterialControl.cs:13/15-24`） | ✓ |
| `MainWindowLine.BackgroundWidth`（三主题模板绑定/过渡） | PRESENT（`ClassIsland\Controls\MainWindowLine.cs:131-134`） | ✓ |
| `MainWindowStylesAssist.{BackgroundOpacity, BackgroundColor, IsCustomBackgroundColorEnabled, IsIslandSeperated, MainWindowInEditMode}` | PRESENT（Assists\MainWindowStylesAssist.cs:13-73，NuGet 亦全 PRESENT） | ✓ |
| `controls:MainWindowLine`、`coreControls:ComponentPresenter`（IsRootComponent/IsOnMainWindow/IsNotificationEnabled 选择器） | 宿主核心控件（p0-01 §3 宿主契约面；r1 标准分支构建通过） | ✓ |

**横查结论**：本批**清零**——唯一不可解析引用即 §7.4 已修复项；其余引用编译面双分支可解析、运行时面由宿主二进制提供。
**跨批横查**：他批已交付 98 文件（Actions / Controls 平铺 / Controls\Notifications / Models / Rules / Services / Settings / SettingsPage / Shared / Triggers / Version / Views / ConfigHandlers / Config / Plugin.cs）对 `IsBackgroundMaterialEnabled|EffectiveBackgroundOpacity|MainWindowBackgroundMaterialControl|MainWindowStylesAssist.*|BackgroundMaterialType` 检索**零命中**——无同类缺位，无需上报调度清单。

## 8. 边界声明与复核指引

- 源插件与宿主检出全程只读（本批全部源访问为读取/检索）；工作区写入 = §开头交付点所列 52 文件 + 本案卷 evidence/ 的 2 个文件（本报告 + p1-01-s42-scan-output.txt）；未触碰禁改面（Plugin.cs / 插件 manifest.yml / csproj / global.json / slnx）。
- 复核最小命令集：
  1. 树核对：`Get-ChildItem src\SystemTools.CrossPlatform\Themes,src\SystemTools.CrossPlatform\Controls\Components,src\SystemTools.CrossPlatform\Models\ComponentSettings,src\SystemTools.CrossPlatform\Converters -Recurse -File`（52 文件，对照 §1 清单）。
  2. 门禁重放：§5 所列 4 条命令，预期全 PASS/exit=0。
  3. 命名空间核对：`Select-String -Path src\SystemTools.CrossPlatform\{Themes,Controls,Models,Converters}\**\*.cs -Pattern 'namespace (?!SystemTools\.CrossPlatform)'` 预期零命中。
  4. URI 核对：`Select-String -Path src\SystemTools.CrossPlatform\Themes\**\* -Pattern 'avares://SystemTools/'` 预期零命中。
  5. 注册清单核对：对照 §3 与礼部 Plugin.cs 实装（功能 ID 全部 `SystemTools.CrossPlatform.*` 形态）。
  6. GUID 零重合复核：按 §3.4 派生定义重放 GUIDv5 应得同值；`$new = <§3.4 新 6 值>` 后对源插件 GUID 全集（17 值，全集提取命令见 §3.4 自证①）检索应 0 命中；旧源 6 GUID 在 `src\SystemTools.CrossPlatform\` 下 `Select-String` 应零命中。
- 本报告不推进、不审批全局工作流；§7.1 裁决请求与接线需求移交尚书省。
