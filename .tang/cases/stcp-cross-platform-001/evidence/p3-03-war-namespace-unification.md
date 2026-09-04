# p3-03 证据：兵部独立命名空间审计与零调整认证

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p3-03 · 兵部 war · application-code / implementation（本任务按 p3-05 零调整结论转独立认证形态） |
| 依赖 | p3-05 已记录 succeeded；本批以其 §4 零调整结论为对照基线，**独立方法复证，不复制其清单** |
| 权威输入 | p1-05 §3.1/§3.2（命名空间体系与 using 禁令）/§6-2（复跑检索形态）；p0-07 §11（R-2 条件文件两形态裁定）；p2-08（S4.2 全树权威基线：168 文件/GateHits=0/CONDITIONAL=13）；p2-10 §7（权威构建口径：NuGet 后备双 TFM exit=0）；p3-05 §4（吏部零调整结论，对照物） |
| 审计对象 | `src\SystemTools.CrossPlatform\` 全树（排 bin/obj）：163 .cs / 29 .axaml / 203 文件 |
| 写入范围 | 仅 `.tang/cases/stcp-cross-platform-001/evidence/p3-03-*`（脚本+原始输出留档）；源插件 `E:\My Github Projects\SystemTools\` 只读（Get-Content 检索）；`src\` 产品文件、宿主检出、bin/obj **零写入**（Roslyn 证据采用非写入解析形态，p1-06/p2-06 验证批先例） |
| 结论 | **succeeded —— 零调整认证成立**：163 .cs / 29 .axaml / 独立配置命名空间全维度 **0 违例**（§6）；r1 严格版 4 项标记经逐文件裁决均为方法误报（§3）；全树复跑 Roslyn 解析 error=0 + S4.2 扫描 168/0/13 与 p2-08 基线逐项一致（§4）；并行批 p3-01/p3-02 落盘期间三个时点快照均零违例（§5）。**阶段 3 命名空间调整清单 = 空（0 项），无文件需上报裁决** |

---

## 1. 独立审计方法（区别于 p3-05 §4.1）

p3-05 采用平面 `Select-String 'namespace (?!SystemTools\.CrossPlatform)'` 检索；本批以**语法锚定的声明级交叉比对**为主检（脚本 `p3-03-namespace-audit.ps1`，产出 `p3-03-namespace-audit-output.txt`），六个维度：

| 维度 | 方法 | 对 p3-05 方法的增益 |
| --- | --- | --- |
| A. 目录×namespace 交叉比对 | 逐文件提取**全部** `namespace` 声明（行首锚定），四向断言：无声明（全局命名空间）/多声明块/非 `SystemTools.CrossPlatform` 前缀/声明值 ≠ 目录镜像值 | 平面检索对「前缀合法但镜像漂移」「多声明块」「全局命名空间」均为盲区；本方法逐声明判定 |
| B. using 面 | 逐行断言禁 `using SystemTools.*`（非 CrossPlatform 段，含 `global using` 变体，p1-05 §3.2-4）；`using SystemTools.CrossPlatform` 同程序集内部使用单列 | p3-05 §4.2-3 仅作禁令陈述，本批实测 0 命中 |
| C. .axaml 三前缀 | `x:Class`/`using:`/`clr-namespace:` 全量提取分类（本地/外部/遗留）；`x:Class` ↔ 配对 code-behind 的命名空间+类名**双向交叉验证** | p3-05 仅验前缀；本方法加验 x:Class 可解析闭合 |
| D. 独立配置命名空间 | ConfigHandlers 6 文件清单+命名空间断言；**对源插件 `ConfigHandlers\MainConfigData.cs` 只读逐名对照**（`[JsonPropertyName]` 58 对 → 新 41 对逐一比对 JSON 名）+ camelCase 自一致性；PluginConfigFolder 独立目录接线链锚点 | p3-05 引 p2-05 留痕；本批直接对源重放，不依赖转引 |
| E. 全树复跑检索 | 与 p1-05 §6-2 / p3-05 完全同形态的 `Select-String` 重放（可比性锚点） | — |
| F. 时点快照 | 审计前后各一次全树文件数+mtime 快照（并行批注记依据） | — |

**v1→v2 精化（裁决留痕）**：v1 严格版（输出存档 `p3-03-namespace-audit-output-r1-strict.txt`）标记 4 项；逐文件人工裁决（§3）确认均为方法误报后，脚本登记三条精化规则（同值多声明块=X1 例外、code-behind 接受 `<basename>.cs` 形态=X2、x:Class 类名全文件检索）并复跑。v1/v2 原始输出均留档，可审计。

## 2. 审计结果（v2 与最终复跑一致）

### 2.1 A 维：22 个唯一命名空间，目录镜像零漂移

163 .cs 全部恰为 `SystemTools.CrossPlatform.<目录路径>` 镜像形态（根文件 = `SystemTools.CrossPlatform`，仅 `Plugin.cs`）；`非 CrossPlatform` 前缀 0；全局命名空间 0。逐命名空间文件数与 p3-05 §4.1 清单**逐一相等**：

| 命名空间 | 本批实测（文件） | p3-05 §4.1 |
| --- | ---: | ---: |
| `SystemTools.CrossPlatform`（根） | 1 | 1 |
| `.Actions` / `.Config` / `.ConfigHandlers` | 31 / 2 / 6 | 31 / 2 / 6 |
| `.Controls` / `.Controls.Components` / `.Controls.Notifications` | 26 / 12 / 1 | 26 / 12 / 1 |
| `.Converters` / `.Models` / `.Models.ComponentSettings` | 1 / 2 / 6 | 1 / 2 / 6 |
| `.Rules` / `.Rules.Handlers` | 4 / 4 | 4 / 4 |
| `.Services` / `.Settings` | 21 / 22 | 21 / 22 |
| `.SettingsPage` / `.Shared` | 8 / 1 | 8 / 1 |
| `.Themes.CardTypeComponent` / `.Themes.ClassWidgets` / `.Themes.NotchStyle` | 1 / 2 / 5 | 1 / 2 / 5 |
| `.Triggers` / `.Version` / `.Views` | 2 / 1 / 4 | 2 / 1 / 4 |

注：脚本原始输出的 A-inventory 为**声明计数**口径（`Services` 22 = 21 文件 + 1 条件文件第二分支声明；`Views` 5 = 4 文件 + 1，见 §3-1 X1 例外），按文件数折算后与 p3-05 完全一致。

### 2.2 B 维：using 面零源命名空间耦合

`using SystemTools.*`（非 CrossPlatform 段）全树 **0 命中**（含 global using 变体）；`using SystemTools.CrossPlatform`（同程序集内部合法使用）156 处（最终复跑 157 处，增量为并行批 p3-01 对 `SystemToolsSettingsViewModel.cs` 的合法自 using 接线，§5）。

### 2.3 C 维：29 .axaml 三前缀零违例 + x:Class 交叉闭合

- 26 个带 `x:Class` 的 .axaml：`x:Class` 全部为 `SystemTools.CrossPlatform.*` 本地前缀，且与配对 code-behind 的命名空间、类名**双向一致**（26/26 闭合）；
- 3 个无 `x:Class` 文件均为 Themes 资源/样式面（`Themes\{CardTypeComponent,ClassWidgets,NotchStyle}\Styles.axaml`），配对要求不适用；
- `clr-namespace:` 本地引用全部镜像命名空间；历史遗留 `SystemTools.*`（非 CrossPlatform）本地引用 **0**；`using:` 形态本地 xmlns 全树 0 处（全部本地引用走 `clr-namespace:`）；
- 外部程序集引用 15 处去重（FluentAvalonia / ClassIsland.Core / System.Runtime），属合法宿主/BCL 面，非命名空间违例对象。

### 2.4 D 维：独立配置命名空间四项全对

1. **ConfigHandlers 6 文件** ✓：ButtonRulesetConfig / FloatingWindowProfile / FloatingWindowProfileManager / MainConfigData / MainConfigHandler / RowRulesetConfig，命名空间全部 = `SystemTools.CrossPlatform.ConfigHandlers`；
2. **JSON 名随源** ✓：对源插件 `ConfigHandlers\MainConfigData.cs`（只读）提取 58 对 `[JsonPropertyName]`，新插件 41 对**逐一存在于源且 JSON 名逐字节相同**（0 漂移、0 新侧缺源成员），camelCase 自一致性 41/41；ButtonRulesetConfig/RowRulesetConfig 源/新两侧均为同构 `[ObservableProperty]` 字段形态（各 1 partial class + 3 字段，无显式 JSON 名），序列化名由同款 MVVM 生成器与 ClassIsland `ConfigureFileHelper` 命名策略承载；
3. **PluginConfigFolder 独立目录** ✓：接线链 `Shared\GlobalConstants.cs:13` → `Plugin.cs:73`（宿主注入）→ `MainConfigHandler.cs:16`（`Path.Combine(pluginConfigFolder, "Main.json")`）→ `FloatingWindowProfileManager.cs:32/:38`（`PluginConfigFolder\FloatingWindowProfiles` 子目录）——与源插件配置文件零互写；
4. **功能 ID 前缀**：按派工注记由 p2-09 §5-3（202 行全前缀）背书，本批不复跑。

### 2.5 E 维：全树复跑检索（与 p3-05 可比形态）

`'namespace (?!SystemTools\.CrossPlatform)'` 全树 **0 命中**；`'(global )?using SystemTools.(?!CrossPlatform)'` **0 命中**。另注：该形态对「前缀合法但镜像漂移」「`SystemTools.CrossPlatform` 后拼遗留段」存在理论盲区，本批 A 维声明级比对已闭合（含逐字符 `-ceq` 大小写敏感比对）。

## 3. r1 严格版 4 项标记的人工裁决（全部为方法误报，非命名空间违例）

| # | r1 标记 | 裁决证据 | 认定 |
| :-: | --- | --- | --- |
| 1 | V2-MULTI-DECL `Services\SystemShutdownMonitor.cs`（2 声明） | :7 与 :103 两块均声明 `SystemTools.CrossPlatform.Services`，且均等于目录镜像（`#if Platforms_Windows` / `#else` 双分支同值承载） | **误报** → X1 例外（p0-07 §11 R-2 形态 a 条件文件标准结构；命名空间值仍唯一） |
| 2 | V2-MULTI-DECL `Views\SystemMotionPreferences.cs`（2 声明） | :5 与 :51 同上（`SystemTools.CrossPlatform.Views`） | **误报** → X1 同上 |
| 3 | V11-XCLASS-CLS-MISMATCH `Controls\Components\BetterCarouselContainerSettingsControl.axaml` | .axaml.cs 含两个类：辅助类 `BetterCarouselDurationItem`（:13）在主类 `BetterCarouselContainerSettingsControl`（:51）之前，r1 取首类致错配；主类存在且命名空间 :11 镜像正确 | **误报** → v2 改全文件检索 |
| 4 | V7-XCLASS-NO-PAIRED-CS `Controls\InTimePeriodRuleSettingsControl.axaml` | code-behind 落同目录同名 `InTimePeriodRuleSettingsControl.cs`（非 `.axaml.cs` 后缀；阶段 1 起如此，p2-08 零命中清单同口径）；`x:Class="SystemTools.CrossPlatform.Controls.InTimePeriodRuleSettingsControl"`（axaml:1）与该文件 :7 命名空间、:14 类名交叉闭合 | **误报** → X2 记录（配对后缀为文件命名细节，非 p1-05 §3.2 命名空间口径对象） |

## 4. 全树复跑留证（认证随附证据）

| 复跑项 | 本批实测 | 权威基线 | 一致性 |
| --- | --- | --- | --- |
| Roslyn 全量解析（163 .cs，非写入型，`Microsoft.CodeAnalysis` CSharp13 解析器） | error=**0**，warning=0（输出 `p3-03-roslyn-parse-output.txt`，2026-09-04T12:37:25+08:00） | — | 命名空间/using 层面零语法性破坏 |
| 语义级编译门禁 | 引 p2-10 §2.3/§2.4：NuGet 后备 Win/Linux Release 构建 exit=0、编译错误=0（用户裁定权威口径） | p2-10 | 树态差异仅并行批在途触碰（§5），语义级验证归 p3-01/p3-02 批内编译门禁 |
| S4.2 扫描全树直扫（`-Scope Source`，2026-09-04T04:37:58Z） | SourceFiles=**168**，GateHits=**0**，ConditionalHits=**13**（R21×5+R17×3 / R13+X04 / R03 / R13+X04），CommentOnly=6，InfoHits=2，VERDICT: **PASS**（输出 `p3-03-s42-fulltree-source-output.txt`） | p2-08（168/0/13/6/2 PASS） | **逐项一致** |
| 命名空间非前缀检索 | 0 / 0（E1/E2） | p3-05 §4.1（0） | 一致并扩展 |

注：S4.2 扫描器文件枚举时点 04:37:58Z，其后并行批 12:38:05 的触碰不在该次枚举集内；扫描器为只读，无写入。

## 5. 并行批时点注记（p3-01/p3-02 落盘期间的三时点认证）

本批执行窗口恰逢并行接线批开始落盘，**三个认证快照时点如实登记**（全程文件计数恒为 163 .cs / 29 .axaml / 203 文件——并行批均为既有文件编辑，无新增文件落盘）：

| 时点（2026-09-04 本地） | 事件 | 树态与结果 |
| --- | --- | --- |
| 12:31:20 | r1 严格版审计（并行批零触碰，最新文件仍为 p2-08 订正 11:33:47） | 163/29；4 项严格标记（§3） |
| 12:34:45 | 并行批 p3-01 首笔触碰 `SettingsPage\SystemToolsSettingsViewModel.cs` | — |
| 12:34:50–:51 | v2 精化审计（已含 p3-01 首笔触碰；self-using 156→157 即该笔新增的合法自 using :3） | **0 违例 PASS** |
| 12:36:01 / 12:36:46 | p3-01 触碰 `SystemToolsSettingsPage.axaml` / `.axaml.cs` | — |
| 12:37:25 | Roslyn 解析复跑（163 文件 error=0） | PASS |
| 12:37:58 | S4.2 全树扫描（枚举集=该时点文件集） | 168/0/13 PASS |
| 12:38:05 | p3-01 再次触碰 VM（在 S4.2 枚举之后） | — |
| 12:39:20 / 12:39:48 | p3-02 触碰 `FloatingWindowEditorSettingsPage.axaml`；p3-01 触碰 `MoreFeaturesOptionsSettingsPage.axaml` | — |
| **12:39:55–:56** | **最终复跑（本批认证时点）**：已覆盖并行批 5 个已触碰文件（p3-01：主页 axaml/.axaml.cs/共享 VM×3、更多功能选项页 axaml；p3-02：悬浮窗编辑页 axaml），全部仍在两批派工文件范围内 | **0 违例 PASS**（22 唯一命名空间、E1=0、E2=0、x:Class 26+3 闭合、V5=0） |

**口径声明**：本认证以 12:39:56 完成时点树态为准；并行批在其后继续的编辑不在本认证快照内，其命名空间合规由 p3-05 §4.2-3 既有规则（新文件镜像目录、禁 `using SystemTools.*`）与其各自批证据约束；本批审计脚本可重放（§8），如尚书省需更晚时点复认证可直接执行。

## 6. 零调整认证结论

1. **违例清单 = 空（0 项）**：§2 全维度 0 违例——无全局命名空间、无多值声明块、无非前缀命名空间、无目录镜像漂移、无源命名空间 using 耦合、无 XAML 遗留引用、ConfigHandlers 命名空间/JSON 名随源一致。
2. **与 p3-05 §4 关系**：独立复证**一致**（22 唯一命名空间/163 文件/29 XAML 逐项吻合），且本批方法覆盖其平面检索的三处盲区（镜像漂移、多声明块、全局命名空间）均实测为零。阶段 3 命名空间维度**零调整**闭合，无需任何文件上报裁决，兵部零产品文件改动。
3. **零行为改动声明**：本批对 `src\` 产品文件、bin/obj、宿主检出、源插件**零写入**（行为面无输入，零改动平凡成立）；全部落盘仅 evidence/ 下 6 个 p3-03 文件（2 脚本 + 3 原始输出 + 本文档）。

## 7. 强制约束适用性核对

| 约束 | 适用性 | 核对结果 |
| --- | --- | --- |
| ① 菜单树格式修订 | 不涉 | 本批零注册面触碰、零产品文件改动；S4.2 复跑注册面无变化信号 |
| ② 双分支 API 漂移 | 不涉 | 零行为改动；X1 双分支文件为既有 R-2 形态，双分支命名空间同值核对一致（§3-1/2） |
| ③ R-2/R-2a guard 符号口径 | 一致 | X1 例外认定与 p0-07 §11 形态 a 口径一致；S4.2 复跑 CONDITIONAL=13 逐项与 p2-08 §3 授权链吻合 |
| ④ S4.2 门禁复跑留证 | 已留证 | `p3-03-s42-fulltree-source-output.txt`（168/0/13 PASS） |
| ⑤ 沙箱边界 | 守住 | 源插件只读（`E:\My Github Projects\SystemTools` 仅 Get-Content）；写入仅 evidence/；bin/obj 零触碰（Roslyn 非写入形态） |

## 8. 可重放命令

```powershell
# 独立命名空间审计（主检，约 1 秒；退出码 0=零违例）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p3-03-namespace-audit.ps1

# Roslyn 全量解析复跑（非写入）
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p3-03-roslyn-parse-check.ps1

# S4.2 全树直扫
pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source

# r1 严格版原始输出存档（4 项标记留痕）
Get-Content .tang\cases\stcp-cross-platform-001\evidence\p3-03-namespace-audit-output-r1-strict.txt
```

## 9. 修订记录

- 初版（p3-03 执行交付；基于 12:31:20 r1 严格版 → 4 项裁决 → 12:34:50 v2 → 12:37:25 Roslyn/12:37:58 S4.2 复跑 → 12:39:56 最终复跑五步留痕）。
