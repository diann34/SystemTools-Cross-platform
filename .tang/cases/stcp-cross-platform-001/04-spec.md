# 04 评审规格（规范性）— SystemTools 跨平台迁移决策清单（案卷 stcp-cross-platform-001，量级 large）

- 制定：门下省（基于 `03-review.md` 的源码证据）
- 性质：本文件为**本期交付物的验收契约**。上一阶段（需求 + 决策清单）按此验收；实现期（若有）的执行计划由尚书省依程序另行制定，本文件不做六部规划、不做派工、不含函数级代码方案。
- 冲突规则：本文件与 `02-draft-solution.md` 不一致处，**以本文件为准**；中书省须据此修订 02 并回签同一量级与规格。

---

## S1. 本期范围与交付物

| 项 | 规范内容 |
| --- | --- |
| 交付物 | 修订后的 `02-draft-solution.md`（功能迁移决策清单，下称「清单」），覆盖原 SystemTools 全部用户可见功能的 A/B/C 三档结论 |
| 平台目标 | Windows + Linux + macOS 三平台并存；原 SystemTools 继续独立维护（已决，不得推翻） |
| 迁移范围 | A 档 + B 档纳入本期新插件；C 档留原插件（已决） |
| 明确非目标 | 不写实现代码、不建工程、不迁移文件；不设计执行阶段与六部分工；不给函数级补丁；C 档「语音链路跨平台化 / 屏幕截图 / 系统音量」仅记录为独立立项候选 |

## S2. 分类契约（每条结论的证据格式）

清单中每一条 A/B/C 结论必须满足以下字段，缺任一字段视为不合规：

1. **源码证据**：至少一个 `文件路径:行号` + 关键依赖符号（API 名 / 包名 / 进程名 / TFM 属性）。禁止无证据结论。
2. **A 档判定式**：该功能的全部源码路径中不出现 S4.2 禁用符号集合中的任何成员（仅依赖 ClassIsland SDK、Avalonia/FluentAvalonia、.NET BCL）。
3. **B 档三元组**：Windows 专属点（文件:行）→ 替换目标（宿主抽象接口名或 per-OS 命令/机制）→ 降级行为（替换不可用时的用户可见行为）。三者缺一不可。
4. **C 档理由**：深度绑定依据（Win32/WMI/WinRT/认证/输入模型）或语义不成立依据（目标平台无对等语义/权限模型不同）；可独立立项者标注「立项候选」。
5. **计数口径**：以「功能项」计数并去重；62 个行动文件 → 61 活动功能项的映射表随清单交付（`ClickSimulationAction.cs` 整文件被 `/* */` 注释，为死代码：不编译、未注册 `[ActionInfo]`，不计项；「模拟鼠标」即 `SimulateMouseAction` 1 项）；同一代码实体（如 `FaceRecognitionService` 与「人脸识别验证器」）只计 1 次。

## S3. 修订决议（规范性，源自 03-review 源码证据；中书省修订 02 时逐条落实）

| # | 决议 | 证据 |
| --- | --- | --- |
| R-1 | **复制/移动/删除改判 A→B（3 项）**：文件子路径为 BCL（`File.Copy/Move/Delete`），文件夹子路径依赖 Windows 专属进程；B 档三元组：`robocopy.exe`/`cmd /c rmdir` → 跨平台 .NET 递归实现或 per-OS 命令 → 失败时记录日志并抛出行动错误（与现行为一致） | `CopyAction.cs:65,96-97`、`MoveAction.cs:65,96-98`、`DeleteAction.cs:29,51,69` |
| R-2 | 设置页清单补第 6 页 **MoreFeaturesOptionsSettingsPage**：页面骨架 A，其承载的选项按归属分档（自动切换主题/遮挡隐藏/内存自动清理 = B；U 盘自动打开 = C） | `SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs:16` |
| R-3 | **悬浮窗按子特性分解**：Avalonia 窗口 + 拖拽 + 按钮编排 + 多方案 + 规则隐藏 = B（保留）；置顶/置底 = B（`SetWindowPos` → `IWindowPlatformService.SetWindowFeature(Topmost/Bottommost)`）；**低级鼠标钩子自动隐藏与 WinEvent 前台/重排响应 = 明示降级**（Avalonia 内部指针/激活事件近似或本期不支持，清单中写明）；液态玻璃/自适应背景 = C 候选（U5） | `FloatingWindowService.cs:1952,2213,2230,2332,2337` |
| R-4 | **SystemShutdownMonitor 纳入 B 档关机族改造点**：WinForms `NativeWindow`（WM_QUERYENDSESSION/WM_ENDSESSION）→ 宿主 `ISystemEventsService`（若提供会话结束事件）或非 Windows no-op 降级 | `SystemShutdownMonitor.cs:8-77`、`Plugin.cs:56,125,1034` |
| R-5 | 工程要点包保留清单**补 FluentAvalonia**（FATaskDialog、设置页与组件设置控件依赖）；移除清单维持：CsWin32、System.Management、System.Speech、DlibDotNet、OpenCvSharp4* | `ActionFlowExecutionConfirmationAction.cs:8` 等 40+ 处引用 |
| R-6 | **AI 对话浮窗的自适应背景子特性随 U5 降级**（与液态玻璃同属 GDI 背景采样依赖）；「显示 AI 对话框」A 档主结论不变 | `AiChatFloatingWindow.axaml.cs:410-416`、`MainWindowBackgroundCaptureService.cs:141,250` |
| R-7 | 计数勘误：A=33 / B=19 / C=46 / 总 98 功能项；行动 15A+14B+32C；C 档服务/认证去重（人脸/Hello 服务与验证器同一实体）；行动标题「16 项」表述废弃 | 03-review §2.5 |
| R-8 | 审计表数字更正：`System.Windows.Forms` 引用 = **10 文件**；CsWin32 `using Windows.Win32`/`PInvoke.` = **23 文件** + 活跃 `[DllImport]` = **13 文件**（并集 33），并标明口径 | 03-review §6.4/6.5 |
| R-9 | 措辞更正：删除「ActionFlowExecutionConfirmation 顶部 using System.Windows.Forms 残留」表述；`01` §3.2「所有 Windows 调用为硬编码」→「绝大多数硬编码，个别已有 `OperatingSystem.IsWindows()` 守卫（`SystemMotionPreferences.cs:12-15`、`BackgroundPlayAudioAction.cs:89`）」 | 03-review §2.3 |
| R-10 | 工程要点补 manifest 要求：新插件 `id` 独立命名、`supportedOSPlatforms` 置为三平台、`apiVersion` 随 U3 决议 | `manifest.yml:6,12,19-20` |

## S4. 验收标准（可测试）

### S4.1 覆盖核对表（逐域，任何一项不符即不通过）

| 域 | 必须覆盖数 | 分档要求 |
| --- | --- | --- |
| 主题 | 3（构建内：CardTypeComponent / ClassWidgets / NotchStyle） | 全 A |
| 组件 | 7 | 6 A + 1 C（歌词） |
| 规则集 | 5 | 4 A + 1 C（媒体播放） |
| 触发器 | 7 | 1 A + 1 B（悬浮窗触发）+ 5 C |
| 行动 | 61 活动功能项 / 62 文件映射表（`ClickSimulationAction.cs` 为整文件注释死代码，不计项） | 15 A + 14 B + 32 C（修订后） |
| 设置页 | 6 | 骨架 A；各页内嵌选项按功能分档，依赖下载管理随 C 裁剪 |
| AI 服务 | 文本链 A；语音族 C（SAPI + Vosk 2 项） | 语音标立项候选 |
| 悬浮窗/更多功能选项 | 全部子特性按 S3-R3 分解 | — |
| 总计 | A33 + B19 + C46 = 98，与逐域之和一致 | — |

### S4.2 A 档禁用符号集合（静态证据门禁，亦为实现期跨平台编译门禁的前身）

A 档功能的证据文件中**不得出现**以下任一符号；B 档仅允许在其「Windows 专属点」字段声明的位置出现：

```
using Windows.Win32 / PInvoke.*（CsWin32）
using System.Windows.Forms / System.Windows.Forms.*
using Microsoft.Win32（注册表）
using System.Management（WMI）
using System.Speech
using Windows.Media.*（WinRT：Ocr / Control）
using Windows.Security.*
DllImport / LibraryImport（user32/ntdll/kernel32/psapi/advapi32/winbio/gdi32）
Windows 专属进程名：cmd.exe、robocopy.exe、rundll32.exe、shutdown、DisplaySwitch.exe、ffmpeg.exe（Windows 包）、SystemTools.VoskWorker.exe
Windows 专属包：OpenCvSharp4.runtime.win、DlibDotNet（win 原生）、NAudio.Wasapi 路径
```

允许且须注明：`OperatingSystem.IsWindows()` 守卫分支（现库存于 `SystemMotionPreferences.cs`、`BackgroundPlayAudioAction.cs`，可原样保留或删除，不影响分档）。
实现期门禁定义（决策级，供尚书省阶段引用）：新插件工程编译目标为三平台 TFM 时，源代码不得包含上述 using 与 Windows 专属进程启动；以「三平台构建通过」为最终门禁证据。

### S4.3 结论字段完备性

- A 档 33 项：每项 ≥1 条 `文件:行` 证据 + 判定式说明（无 S4.2 符号）。
- B 档 19 项：每项含 S2.3 三元组；其中电源/锁屏 7 项另须含 U4 降级策略引用；悬浮窗 3 项（服务/显示/层级）+ 触发器 1 项按 S3-R3 子特性口径表述。
- C 档 46 项：每项含 S2.4 理由；语音链路/屏幕截图/系统音量 3 处标「立项候选」。

### S4.4 未决项收敛（随审批门由用户确认，门下省建议为默认值）

| 项 | 规范默认值（用户可改） |
| --- | --- |
| U3 | 新插件以 misha/v2 本地检出（`E:\ClassIsland-git-misha`）的 `ClassIsland.PluginSdk`/`ClassIsland.Platforms.Abstractions` 为目标 API 基线；发布包 2.1.1.1 仅作后备。已验证该检出含 B 档所需 `IWindowPlatformService.SetWindowFeature` 三平台实现与 `ISystemEventsService/ILauncherService/IDesktopToastService/IDesktopService` |
| U4 | B 档电源/锁屏/睡眠项：执行前预检（命令/权限），无权限或命令缺失时**不抛未处理异常**，经 `IDesktopToastService` 通知用户降级结果；清单中记录 per-OS 提权要求（Linux polkit/logind、macOS osascript/pmset） |
| U5 | 首期交付悬浮窗经典外观（B）；液态玻璃 + 自适应背景采样为 C 候选增强（含悬浮窗、AI 对话浮窗两个消费方） |

## S5. 验证期望（复核方可重放）

1. **覆盖重放**：对 `E:\My Github Projects\SystemTools` 重放以下检查并对照清单——`Actions/*.cs` 文件数（预期 **62**，其中 `ClickSimulationAction.cs` 为整文件 `/* */` 注释死代码：未编译、未注册、不计项）；Triggers/Rules Handlers/Components/设置页 类清单（预期 7/5/7/6）；`manifest.yml` 现值。
2. **分档重放（抽样 ≥10 项，含全部 7 项电源 B 档与全部 A→B 改判项）**：按 S2 证据字段回到源码行验证；A 档抽样按 S4.2 禁用符号集合反向 grep。
3. **一致性校验**：A+B+C 分域计数 = S4.1 表；62 文件映射表（61 活动项 + 1 死代码注记）无重复、无遗漏；C 档无重复计项。
4. **宿主前提校验**：清单引用的每个宿主抽象接口（`IWindowPlatformService`、`ISystemEventsService` 等）在 `E:\ClassIsland-git-misha` 检出中存在（接口文件 + ≥1 平台实现）。

## S6. 失败处理

- **发现新漏判**（任何档位证据与源码不符）：以源码为准修订 02 对应条目，更新计数与映射表，并在清单「勘误记录」节登记；门下省对变更条目做增量复核，无需整体重审。
- **证据无法复核**（文件/行不存在）：该条目按「证据缺失」退回补充，不得以描述性理由替代源码证据。
- **宿主抽象缺失**（清单引用的接口在检出中不存在）：对应 B 档项降级为 C 或改为「自建平台服务」并标注风险，同步更新计数。
- **U3/U4/U5 被用户否决或修改**：仅调整受影响条目的替换目标/降级策略字段，分档不变（除非否决直接命中分档前提，如 U5 改为「首期交付液态玻璃」则相关项移回待定并重新评审）。

## S7. 风险与回滚（决策级）

| 风险 | 规范应对 |
| --- | --- |
| R1 原生依赖面广（CsWin32 23 文件 + DllImport 13 文件） | S4.2 门禁作为实现期强制校验的决策依据；A/B 抽取必须逐文件对照禁用符号集合 |
| R2 语音双引擎 Windows 专属 | C 档立项候选，本期不含；新插件无语音输入/唤醒（工程要点已定） |
| R3 背景采样 GDI | U5 降级决议；所有采样消费方（悬浮窗/AI 浮窗/自适应主题采样路径）同步降级 |
| R4 认证 Windows 专有 | C 档；后续若做须换宿主认证体系，本期不设计 |
| R5 双插件并存语义 | 独立 ID/功能前缀/全新配置（已决）；清单须含「同装差异说明」文档要求 |
| R6 电源提权 | U4 默认降级策略 + per-OS 提权记录 |
| 回滚 | 本期纯分析，丢弃文档即回滚；实现期新插件独立工程/ID/配置，可整体不启用或卸载，不影响原 SystemTools |

## S8. 禁止事项（对后续所有阶段有效）

- 不得将本规格落为函数级实现方案、文件级补丁或工程文件模板。
- 不得在本阶段创建工程、修改原插件源码或迁移文件。
- 不得由本规格推导六部派工或执行阶段计划（属尚书省职权，且须待用户审批通过后启动）。
- 未经用户审批门确认，不得将 U3/U4/U5 的默认值当作最终决议对外表述。
