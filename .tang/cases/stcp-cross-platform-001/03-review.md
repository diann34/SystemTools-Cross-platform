# 03 门下省评审 — SystemTools 跨平台迁移清单（案卷 stcp-cross-platform-001，量级 large）

- 评审人：门下省（独立复核）
- 输入：`01-requirements.md`（定稿）、`02-draft-solution.md`（中书省草案）
- 评审方式：全文通读 + 对原插件源码（`E:\My Github Projects\SystemTools`）与宿主检出（`E:\ClassIsland-git-misha`）做证据抽查重放（grep/read，证据均注明 文件:行）
- 结论：**通过（passed）**，附 9 项规范性修订决议（见 `04-spec.md` S3），无量级误判。

---

## 1. 范围完整性核查（逐域清点）

| 域 | 需求口径 | 草案覆盖 | 独立清点证据 | 判定 |
| --- | --- | --- | --- | --- |
| 主题 | 3 | 3/3 A | `SystemTools.csproj:31-33` 恰好打包 CardTypeComponent / ClassWidgets / NotchStyle 三个 `Theme.axaml.txt`（`VerticalSidebar` 已在 `:38` 从构建移除，非第 4 个在构建内主题） | ✅ 完整 |
| 组件 | 7 | 6 A + 1 C | `Controls\Components` 中 7 个显示组件类（NetworkStatus / ClipboardContent / LocalQuote / NextClassDisplay / BetterCarouselContainer / ScrollingText / LyricsDisplay）全部命中 | ✅ 完整 |
| 规则集 | 5 | 4 A + 1 C | `Rules\Handlers` 恰好 5 个 Handler（ProcessRunning / UsingClassPlan / UsingTimeLayout / InTimePeriod / MediaMusicPlaying） | ✅ 完整 |
| 触发器 | 7 | 1 A + 1 B + 5 C | `Triggers` 恰好 7 个 Trigger 类（ActionInProgress / FloatingWindow / UsbDevice / Hotkey / LongIdle / Keyword / MainWindowClick） | ✅ 完整 |
| 行动 | 约 60 | 18 A + 11 B + 32 C = 61 | `Actions\*.cs` 实测 **62 个文件**；其中 `ClickSimulationAction.cs` 整文件被 `/* */` 注释（死代码：未编译、未注册 `[ActionInfo]`、无 Plugin 注册引用，不计项），活动项 = 62 − 1 = 61 | ✅ 完整（计数口径须固化，见 §6.3） |
| AI 服务 | 若干 | A 档 1 条链 + C 档语音族 | `OpenAiCompatibleService` 等 9 文本链服务 + `KeywordSpeechService`（System.Speech，`:5`）+ `VoskWorker\Program.cs`（NAudio.CoreAudioApi，`:3-5`） | ✅ 完整 |
| 设置页 | 6 | **草案 §2.6 只列 5 个** | 实测 6 页：About / AiChat / PluginDebug / **MoreFeaturesOptions** / SystemTools / FloatingWindowEditor | ⚠️ **漏列「更多功能选项」页** → 修订决议 R-2 |
| 悬浮窗 / 更多功能选项 | 1 域 + 若干 | 已覆盖（B/C 分解） | `FloatingWindowService.cs`、`AdaptiveThemeSyncService.cs`、`MainWindowTextOcclusionService.cs`、`ClassIslandMemoryAutoCleanupService.cs` 均入表 | ✅ 完整 |

**范围判定**：六大功能域全部覆盖，唯一遗漏为设置页清单少列 1 页（其承载的 B 档开关与 C 档 U 盘入口已在功能行覆盖，属清单完整性问题而非范围漏项）。

---

## 2. A/B/C 三档边界核查

### 2.1 草案自述的两次校正 — **均经源码证实，同意**

| 校正主张 | 独立验证证据 | 判定 |
| --- | --- | --- |
| ShowToast 由 C 改 A | `Actions\ShowToastAction.cs:31` 确为 `await PlatformServices.DesktopToastService.ShowToastAsync(...)`（宿主跨平台抽象，无任何 Win32/WinForms 引用） | ✅ 校正正确 |
| 电源七项由 C 改 B | `ShutdownAction.cs:32,43`（`shutdown` 进程 + `SendKeys.SendWait`）、`CancelShutdownAction.cs:29`（`shutdown /a`）、`AdvancedShutdownAction.cs:207,395`（倒计时 UI 为 Avalonia + `shutdown` 进程）、`LockScreenAction.cs:29-30`（`rundll32 user32.dll,LockWorkStation`）、`SleepAction.cs:23-24`（`rundll32 powrprof.dll,SetSuspendState`）、`ImmediateRestartAction.cs:16-28` / `ImmediateShutdownAction.cs:16-28`（`RtlAdjustPrivilege` + `ExitWindowsEx`）——均为**单点、进程级或独立 P/Invoke 调用**，存在等价 OS 命令（logind/systemctl、pmset、osascript），不属深度绑定 | ✅ 校正正确；前提是 U4 提权降级策略成立（见 §7） |

### 2.2 A 档漏判的 Windows 依赖 — **发现 1 组，要求改判**

**R-1（实质性）：复制 / 移动 / 删除（文件夹子路径）不是纯 BCL，应 A→B。**

| 行动 | 文件子路径 | 文件夹子路径（实测） | 证据 |
| --- | --- | --- | --- |
| 复制 | `File.Copy`（BCL ✅） | `robocopy.exe /e /copyall /r:3 /w:3 /mt:4`（Windows 专属工具） | `CopyAction.cs:65` 与 `CopyAction.cs:96-97` |
| 移动 | `File.Move`（BCL ✅） | `robocopy.exe … /move` | `MoveAction.cs:65` 与 `MoveAction.cs:96-98` |
| 删除 | `File.Delete`（BCL ✅） | `cmd /c rmdir /s /q`（cmd.exe 外壳） | `DeleteAction.cs:51` 与 `DeleteAction.cs:29,69` |

草案 §2.5 将三者整体标注「纯 BCL ✅ A」与源码不符。三个行动均满足 B 档定义（逻辑跨平台、单点 Windows 调用替换为 .NET 递归实现或 per-OS 命令），故改判 **A→B（3 项）**：A 行动 18→15、B 行动 11→14、B 合计 16→19、A 合计 36→33、总功能项不变 61。

### 2.3 A 档证据性错误（结论不变，证据须改）

- **R-9a**：草案称 `ActionFlowExecutionConfirmationAction.cs`「顶部 `using System.Windows.Forms` 为残留可删」——实测该文件**无任何** `System.Windows.Forms` 引用（`FATaskDialog` 来自 FluentAvalonia，`ActionFlowExecutionConfirmationAction.cs:8`；`Topmost`/`Screens` 均为 Avalonia API）。A 档结论成立，但所述证据不存在，须删除该表述。
- **R-9b**：`01-requirements.md` §3.2「所有 Windows 调用为硬编码」有反例：`Views\SystemMotionPreferences.cs:12-15` 已用 `OperatingSystem.IsWindows()` 运行时守卫（非 Windows 返回 false）；`BackgroundPlayAudioAction.cs:89` 同样存在 `OperatingSystem.IsWindows()` 分支（草案自己已提到后者）。措辞应改为「绝大多数为硬编码，个别已有运行时守卫先例」。
- **R-5**：草案 §6.2 包保留清单「仅保留 ClassIsland.PluginSdk + Microsoft.Extensions.DependencyInjection」**遗漏 FluentAvalonia**——`FATaskDialog` 与 6 个设置页、多个组件设置控件均直接依赖 `FluentAvalonia.UI.Controls`（40+ 处引用）。跨平台包，必须保留。

### 2.4 B 档完整性与 C 档边界抽查

- **R-3（悬浮窗 B 档口径不完整）**：`FloatingWindowService.cs` 除 `SetWindowPos`（`:2332/:2337`，置底/置顶）外，还有**低级鼠标钩子** `SetWindowsHookEx`（`:1952`）与 **WinEvent 钩子** `SetWinEventHook`（`:2213` 前台、`:2230` 重排，DllImport 定义 `:114-127`）。草案 B 行只处理了 `SetWindowPos→IWindowPlatformService`，未说明钩子依赖的子特性（悬窗外点击自动隐藏、前台变化响应）在 Linux/macOS 的去向。B 档结论可保留，但须按子特性分解并声明降级（窗口/拖拽/层级/多方案/规则隐藏 = B；全局钩子自动隐藏与前台重排 = 降级为 Avalonia 内部事件或本期不支持）→ 规范化进 spec S3-R3。
- **R-4（漏定档的支持服务）**：`SystemShutdownMonitor.cs` 为 WinForms `NativeWindow`（`WM_QUERYENDSESSION/WM_ENDSESSION`，`:8-77`），由 `Plugin.cs:56,125,1034` 启动并使用，服务于关机族。草案全文未给它定档。归入 **B 档关机族改造点**（换宿主 `ISystemEventsService` 或非 Windows no-op）。
- **R-6（AI 对话浮窗自适应背景）**：`AiChatFloatingWindow.axaml.cs:410-416` 也调用 `BackgroundLuminanceCalculator` + 捕获帧做明暗切换——与液态玻璃同样依赖 GDI 背景采样（`MainWindowBackgroundCaptureService.cs:141,250` `CopyFromScreen`）。A 档「显示 AI 对话框」主结论不受影响，但该子特性须随 U5 一并降级，spec 中明示。
- **C 档抽查全部命中**：输入模拟 `keybd_event/mouse_event/SendInput` 族、`DisplaySwitch.exe` 四个显示器拓扑行动、WMI 亮度（`AdjustScreenBrightnessAction.cs:94`）、注册表个性化（`ChangeWallpaperAction.cs:169` `SystemParametersInfo`、`SwitchSystemAccentColorAction.cs:19` DllImport）、USB（`UsbDeviceTrigger.cs:224-263` `RegisterDeviceNotification`）、SMTC（`MediaMusicPlayingRuleHandler.cs:3,27` `Windows.Media.Control`）、Windows Hello（`WindowsHelloService.cs:158` winbio DllImport）、`NtSetSystemInformation` 内存清理（`SystemMemoryCleanupService.cs:600-641`）、GDI 截图（`ScreenShotAction.cs:53`、`MainWindowBackgroundCaptureService.cs:141,250`）——C 档证据成立。
- **C→B 可降级项评估：无。** 逐项评估过三个最接近的候选：USB 触发器（Linux 需 udev、macOS 需 IOKit，触发语义不同）、屏幕亮度（Linux 有 `/sys/class/backlight` 但 macOS 需私有 API 且碎片化）、长时空闲（X11 有 XScreenSaver 扩展但 macOS 无对等、且宿主无空闲抽象）——均不满足「1–2 处轻改」标准，维持 C 正确。
- **歌词组件 C 档**：`LyricsDisplayComponent.axaml.cs:130-243` `FindWindow/PrintWindow/EnumWindows/SetWindowPos(HWND_BOTTOM)` 证据属实，C 成立。

### 2.5 修订后目标计数（去重口径）

| 档 | 修订前 | 修订后 | 变化 |
| --- | --- | --- | --- |
| A | ≈36 | **33**（主题 3 + 组件 6 + 规则 4 + 触发器 1 + 行动 15 + 服务/设置 4） | 复制/移动/删除 3 项 A→B |
| B | ≈16 | **19**（触发器 1 + 行动 14 + 服务 4） | +3；口径含 SystemShutdownMonitor 并入关机族 |
| C | ≈47 | **46**（组件 1 + 规则 1 + 触发器 5 + 行动 32 + 服务 7，人脸/Hello 服务与验证器去重） | 修正重复计数 |
| 合计 | ≈99 | **98 功能项（对应 62 个行动文件，其中 1 个为死代码 + 各域其余文件）** | 计数口径见 spec S4 |

> 服务行「语音(SAPI+Vosk)」按 2 项计、认证行「人脸/Hello 验证器」与服务行 `FaceRecognitionService`/`WindowsHelloService` 为同一代码实体，须去重——否则 C 档 8 项服务/认证重复计数 1 项。

---

## 3. 接口 / 兼容性核查（三平台并存 + 独立 ID）

1. **并存策略自洽**：新插件只含 A/B 档、C 档留原插件，与「原 SystemTools 独立维护、Windows 用户任选」一致；功能不互补、不互斥。草案 R5 已说明同装时设置不互通——合格。
2. **独立 ID 可行**：`manifest.yml:6` 现 `id: SystemTools`、`:12` `apiVersion: 2.2.0.0`、`:19-20` `supportedOSPlatforms: [Windows]`。新插件须同时改 `id`、`supportedOSPlatforms`（三平台）并新增功能 ID 前缀——草案 §6.5 已覆盖，补 manifest 平台字段要求进 spec。
3. **宿主抽象真实性（B 档可行性的关键前提）— 已在宿主检出中证实**：`ClassIsland.Platforms.Abstractions\Services\IWindowPlatformService.cs:12-20` 存在 `SetWindowFeature(TopLevel, WindowFeatures, bool)`，且 `WindowFeatures` 含 `Topmost/Bottommost/Transparent` 的三平台实现齐全：`ClassIsland.Platforms.Windows\Services\WindowPlatformService.cs:122`、`ClassIsland.Platforms.MacOs\...\WindowPlatformServices.cs:118`、`ClassIsland.Platforms.Linux\Services\WindowPlatformService.cs:128`，另有 Stub 与宿主自身大量使用（`ClassIsland\MainWindow.axaml.cs:801,827`）。`ISystemEventsService / ILauncherService / IDesktopToastService / IDesktopService` 接口文件均在。**B 档「置顶/置底换宿主抽象」与「关机监视换 ISystemEventsService」具备宿主事实基础。**
4. **Linux X11 约束一致**：`01` §3.3 与草案 R2 一致，全局钩子/输入注入归 C，无冲突。

## 4. 失败模式与回滚

- 本阶段纯分析，无代码变更，回滚 = 丢弃文档，风险为零。
- 实现期回滚主张（独立工程、可整体弃用）成立：新插件独立 ID + 独立配置，与原插件无共享状态。
- B 档运行时失败模式（电源/锁屏提权失败、命令缺失、OCR/采样降级）由 spec S6 规范为「预检 + 通知降级 + 不抛未处理异常」，对应未决项 U4。
- 识别性风险：新增「清单验收时的静态证据门禁若放空，A 档可能再次混入 Windows 调用」——以 spec S4 的禁用符号清单作为可测试门禁闭环（本次 CopyAction 漏判即该门禁缺失的直接例证）。

## 5. 未决项 U3/U4/U5 收敛建议（建议随审批门由用户最终确认）

| 未决项 | 门下省建议 | 依据 |
| --- | --- | --- |
| **U3 目标 API 版本** | **随 misha/v2 本地检出（`E:\ClassIsland-git-misha`）为基线**，不以发布包 2.1.1.1 为准 | B 档依赖的 `IWindowPlatformService.SetWindowFeature` 三平台实现与 Stub 仅在该检出中证实存在；`SystemTools.csproj:13` 的发布包默认 2.1.1.1 无法确认含这些抽象；`csproj:10-12` 本地 SDK 优先机制已就绪。验证要求：新工程以三平台 TFM 对检出 SDK 编译通过为准 |
| **U4 电源提权降级** | **接受「无权限/命令缺失时静默失败 + `IDesktopToastService` 通知提示」为默认行为**，每个 B 档电源/锁屏项必须预检并记录 per-OS 提权要求（Linux polkit/systemd、macOS 管理员/osascript） | 与 `01` §2.3、R6 一致；避免实现期对失败语义二次猜测 |
| **U5 液态玻璃** | **首期仅交付悬浮窗经典外观（B）；液态玻璃 + 自适应背景采样（`MainWindowBackgroundCaptureService`）及其全部消费方（悬浮窗、AI 对话浮窗、自适应主题的采样路径）降级为 C 候选增强** | 采样链 GDI `CopyFromScreen` 为 Windows 专属；宿主无对等背景采样抽象；符合 R3 |

## 6. 具体证据性勘误汇总（须在 02 修订版中落实）

1. **§2.5 A 档表**：「复制/移动/删除（System.IO）纯 BCL」错误 → 改判 B（§2.2，R-1）。
2. **§2.5 A 档表**：ActionFlowExecutionConfirmation「`using System.Windows.Forms` 残留可删」证据不存在（R-9a）。
3. **§2.5 标题**「行动（A 档，16 项）」与 §0「行动 18」口径不一：16 行（首行为 Copy/Move/Delete 合并行）= 18 个行动；修订后为 15。计数口径统一为「功能项」，文件映射须可追溯（62 文件 → 61 活动项；`ClickSimulationAction.cs` 为整文件注释死代码，未注册不计项）。
4. **§1 审计表**「System.Windows.Forms 14 个文件」→ 实测 **10 个文件**引用（6 处 `using` + 4 处全限定：ClickSimulationSettingsControl、SimulateKeyboardSettingsControl、SimulateKeyCombinationSettingsControl、ScreenShotAction、ShutdownAction、MainWindowBackgroundCaptureService、HotkeyService、SystemShutdownMonitor、IHotkeyService、UsbDeviceTrigger）。
5. **§1 审计表**「CsWin32 P/Invoke 29 个文件」→ 实测 `using Windows.Win32`/`PInvoke.` **23 个文件**，另有 **13 个文件**含活跃 `[DllImport]`（并集 33）。「29」与任一口径均不符，须标明口径或更正。
6. **§5 总表**服务行与认证行对「人脸 / Hello」重复计数 → C 档 47 应为 46（§2.5）。
7. **§6.2 包保留清单**补 FluentAvalonia（R-5）。
8. **§6 工程要点**补：manifest `supportedOSPlatforms` 三平台字段；`SystemShutdownMonitor` 与悬浮窗钩子子特性的处理（R-3/R-4）。
9. **`01` §3.2**「所有 Windows 调用为硬编码」→「绝大多数…个别已有 `OperatingSystem.IsWindows()` 守卫先例」（R-9b，不影响分类结论）。

## 7. 结论

- **量级 large 维持**：62 个行动文件 + 29+ 文件 Win32 面、三平台 TFM/包/依赖链改造、宿主抽象缺口与 U3–U5 未决项，符合 large 特征；无升档/降档证据。
- **通过理由**：六大功能域覆盖完整（除 1 处设置页漏列）；草案自述的两处关键校正（ShowToast C→A、电源七项 C→B）经源码逐点证实为**正确**；C 档证据抽查全部命中、无应降级进 B 的项；发现的问题（3 项 A→B 改判、悬浮窗/关机监视子特性定档、计数口径、包清单、数字勘误）均有界、可枚举、已全部规范化写入 `04-spec.md` S3，不构成退回重做的实质性缺陷。
- 门下省未代用户做任何范围决定：U3/U4/U5 仅给建议与默认值，最终以审批门用户确认为准。
