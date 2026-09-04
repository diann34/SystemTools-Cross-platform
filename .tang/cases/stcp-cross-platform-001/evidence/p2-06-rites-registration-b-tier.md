# p2-06 证据：礼部 p2-06——注册面 B 档增补（Plugin.cs 唯一注册面，interfaces-documentation / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-06 · 礼部 rites · interfaces-documentation / implementation（阶段 2；依赖 p2-01/p2-02/p2-03 均已记录 succeeded；结构依据 p1-05（含 R1）+ p1-06 既有注册面 33/33 A 档在位） |
| 权威输入 | 兵部三批交接清单：p2-01 §8（7 行动 + 电源选项菜单组 + 内存 GC 服务对 + lifecycle 三点）、p2-02 §6（5 ActionInfo + 2 服务 DI + lifecycle）、p2-03 §4 W1–W13（悬浮窗域 13 条接线需求）；p1-05 §4.2（交接格式）与 §2.3-4（共享类型增补只读消费口径）；p1-06 §9-3/§9-4/§9-5/§9-6（分组口径与三个报备恢复点）；04-spec §S4.2（门禁，R-2 条件文件口径）；源插件 Plugin.cs（只读先例） |
| 交付点 | `src\SystemTools.CrossPlatform\Plugin.cs`（唯一交付文件，唯一注册面，仅礼部有权修改；480 行 → 684 行（主批）→ **742 行（微修 1 后）**）＋ 本案 evidence/ 4 文件（本报告、`p2-06-s42-scan-output.txt`〔主批 + 微修 1 原始输出〕、`p2-06-supplementary-compile-check.ps1`、`p2-06-supplementary-compile-check-output.txt`〔主批 + 微修 1 复跑〕） |
| 结论 | **succeeded** —— B19 逐项注册 **19/19**（行动 14/触发器 1/服务 4，§2；机器复核 37 个注册调用 / 37 个唯一 ID / 零重复 / 零非前缀，§2.5）；DI/lifecycle 接线对照三批交接逐项落实（§3）；悬浮窗编辑页注册门 + 行动/触发器组门 + 悬浮窗菜单组按源形态恢复（p1-06 §9-4/§9-6 报备恢复点全部兑现，§4）；电源选项菜单组随 p2-01 §8 交接恢复（§5）；S4.2 批内单文件直扫 + 全树收口复跑 PASS exit=0（GateHits=0，CONDITIONAL=13 与兵部三批登记一致、零新增，§6）；Roslyn 双向符号验证 Plugin.cs 归属 error=0（§7）；manifest 字节级不变（§8）；A3/A4 回归注记兑现（§9）；**微修 1（尚书省裁定）：文件操作/更多功能选项两组菜单按源形态补齐并全量复跑 PASS（§5-3/§5-4，§6/§7 微修复跑段）** |
| 边界 | 源插件 `E:\My Github Projects\SystemTools` 与宿主 `E:\ClassIsland-git-misha` 全程只读；写入仅限 Plugin.cs + evidence/；零改动 manifest.yml / csproj / global.json / slnx 及兵部三批交付文件与 MainConfigData（三批增补段只读消费，§11） |

---

## 1. 交付总览（源先例 → 新注册面逐段映射，B 档面）

| 源先例（源 Plugin.cs，只读参照） | 新注册面落点（新 Plugin.cs 行号） | B 档面处理 |
| --- | --- | --- |
| :56-57 `_systemShutdownMonitor`/`_shutdownRequestedHandler` 字段 | :50-60 两字段（XML 文档注记 W5/W7） | 逐形态随源 |
| :114-124 服务 DI 群 | :122-135（FloatingWindowService/AdaptiveThemeSyncService/MainWindowTextOcclusionService/IProcessMemoryMaintenanceService 对/ClassIslandMemoryAutoCleanupService/SystemShutdownMonitor 实例） | 顺序随源 :114-:124 相对序；C 档服务不随入（§3） |
| :125-127 SystemShutdownMonitor 实例注册 | :133-135 | `new + Start() + AddSingleton(instance)` 随源；非 Windows 分支 Start 为 no-op 护栏 |
| :182-185 悬浮窗编辑页条件注册 | :167-172 | **恢复点 ③ 兑现**：`EnableFloatingWindowFeature == true` 门随源（§4-3） |
| :201-220 AppStarted 主处理器 | :185-209 | W7/W4/W2 + p2-02 两服务 Start + p2-01 ApplyConfig，相对序随源；C 档行不随入（§3-3） |
| :287 Initialize 直注 ShutdownRequested 处理器 | :212-213 | 随源（方法幂等，与 AppStarted 双调用点形态一致） |
| :1032-1068 OnAppStopping | :217-251 | W6 全链 + p2-01/p2-02 停止面，顺序随源；源 :1049-1056 信息日志面未随入（报备 §10-2） |
| :1070-1079 RegisterShutdownRequestedHandler | :253-267 | 逐行随源（`MarkIfOsShutdown(object)` 以 p2-03 条件文件两分支同签名承载） |
| :374-387 电源选项/文件操作行动注册 | :275-291 | B4–B10 + B1–B3 逐项（启用开闭形态随源；B8–B10 单参形态随源） |
| :413-424 悬浮窗行动注册门 | :299-311 | **恢复点 ① 兑现**：B11/B12 新增 + A3/A4 恢复入源门（§4-1） |
| :475-479 悬浮窗触发器注册门 | :361-366 | **恢复点 ② 兑现**：FloatingWindowTrigger 注册于 `config.EnableFloatingWindowFeature` 门内（§4-2） |
| :430-434 更多功能选项行动注册 | :335-339 | B13/B14 逐项（源 :435 AutoOpenUsbDriveOnInsert 属 C 档不迁） |
| :641-646/:805-821 电源选项菜单组 | :473-481 + :544-570 | 组门 + 7 菜单项随源（p2-01 §8 交接行） |
| :671-677/:895-912 悬浮窗设置菜单组 | :490-498 + :572-592 | **恢复点 ④ 兑现**：组门 + B11/B12/A3/A4 归组随源（§5-2） |
| :648-653/:825-840 文件操作菜单组 | :483-491（组门）+ :591-609（BuildFileMenu）〔742 行状态〕 | **微修 1 补齐**：组门无裁剪（三成员均 B 档在册）+ 3 菜单项随源（§5-3） |
| :686-692/:923-938 更多功能选项菜单组 | :516-524（组门）+ :633-650（BuildMoreFeaturesMenu）〔742 行状态〕 | **微修 1 补齐**：组门/组内仅 B13/B14（源含 C 档 AutoOpenUsbDriveOnInsert，p1-06 §2.7 组门裁剪先例）（§5-4） |

---

## 2. B19 注册对照总表（19 项逐项，ID 一律 `SystemTools.CrossPlatform.*` 前缀）

### 2.1 行动 14 项（注册形态 = 源 RegisterActionIfEnabled 先例；新落点 Plugin.cs:271-352）

| # | 功能项 | 功能 ID | 注册形态（新 Plugin.cs 行号） | 启用开闭门 | 来源批交接行 |
| --- | --- | --- | --- | --- | --- |
| B1 | 复制 | `SystemTools.CrossPlatform.Copy` | `RegisterActionIfEnabled<CopyAction, CopySettingsControl>(…)`（:289） | IsActionEnabled | p2-02 §6 B1 行（源 :385） |
| B2 | 移动 | `SystemTools.CrossPlatform.Move` | `RegisterActionIfEnabled<MoveAction, MoveSettingsControl>(…)`（:290） | IsActionEnabled | p2-02 §6 B2 行（源 :386） |
| B3 | 删除 | `SystemTools.CrossPlatform.Delete` | `RegisterActionIfEnabled<DeleteAction, DeleteSettingsControl>(…)`（:291） | IsActionEnabled | p2-02 §6 B3 行（源 :387） |
| B4 | 计时关机 | `SystemTools.CrossPlatform.Shutdown` | `RegisterActionIfEnabled<ShutdownAction, ShutdownSettingsControl>(…)`（:276-277） | IsActionEnabled | p2-01 §8 行动注册 ×7 行 1（源 :375） |
| B5 | 高级计时关机 | `SystemTools.CrossPlatform.AdvancedShutdown` | `RegisterActionIfEnabled<AdvancedShutdownAction, AdvancedShutdownSettingsControl>(…)`（:278-279） | IsActionEnabled | p2-01 §8 行 2（源 :376-377） |
| B6 | 取消关机计划 | `SystemTools.CrossPlatform.CancelShutdown` | `RegisterActionIfEnabled<CancelShutdownAction, ShortcutKeyNotificationSettingsControl>(…)`（:282-283）——共享控件仅引用，B6/B7 不复制 | IsActionEnabled | p2-01 §8 行 4（源 :379） |
| B7 | 锁定屏幕 | `SystemTools.CrossPlatform.LockScreen` | `RegisterActionIfEnabled<LockScreenAction, ShortcutKeyNotificationSettingsControl>(…)`（:280-281）——同上仅引用 | IsActionEnabled | p2-01 §8 行 3（源 :378） |
| B8 | 立即重启 | `SystemTools.CrossPlatform.ImmediateRestart` | `RegisterActionIfEnabled<ImmediateRestartAction>(…)`（:284）——无设置对，单参形态随源 | IsActionEnabled | p2-01 §8 行 5（源 :380） |
| B9 | 立即关机 | `SystemTools.CrossPlatform.ImmediateShutdown` | `RegisterActionIfEnabled<ImmediateShutdownAction>(…)`（:285）——单参形态随源 | IsActionEnabled | p2-01 §8 行 6（源 :381） |
| B10 | 睡眠 | `SystemTools.CrossPlatform.Sleep` | `RegisterActionIfEnabled<SleepAction>(…)`（:286）——单参形态随源 | IsActionEnabled | p2-01 §8 行 7（源 :382） |
| B11 | 显示悬浮窗 | `SystemTools.CrossPlatform.ShowFloatingWindow` | `RegisterActionIfEnabled<ShowFloatingWindowAction, ShowFloatingWindowSettingsControl>(…)`（:303-304），处于 `if (config.EnableFloatingWindowFeature)` 门内（:301） | EnableFloatingWindowFeature && IsActionEnabled | p2-03 §4 W8（源 :416-417） |
| B12 | 切换悬浮窗层级 | `SystemTools.CrossPlatform.ToggleFloatingWindowLayer` | `RegisterActionIfEnabled<ToggleFloatingWindowLayerAction, ToggleFloatingWindowLayerSettingsControl>(…)`（:305-306），同门内 | 同上 | p2-03 §4 W9（源 :418-419） |
| B13 | 自动切换 ClassIsland 主题 | `SystemTools.CrossPlatform.AutoSwitchClassIslandTheme` | `RegisterActionIfEnabled<AutoSwitchClassIslandThemeAction, AutoSwitchClassIslandThemeActionSettingsControl>(…)`（:336-337） | IsActionEnabled | p2-02 §6 B13 行（源 :431-432） |
| B14 | 遮挡文字时隐藏主界面 | `SystemTools.CrossPlatform.AutoHideMainWindowWhenOccluded` | `RegisterActionIfEnabled<AutoHideMainWindowWhenOccludedAction, AutoHideMainWindowWhenOccludedActionSettingsControl>(…)`（:338-339） | IsActionEnabled | p2-02 §6 B14 行（源 :433-434） |

### 2.2 触发器 1 项（新落点 Plugin.cs:354-367）

| # | 功能项 | 功能 ID | 注册形态 | 启用开闭门 | 来源批交接行 |
| --- | --- | --- | --- | --- | --- |
| B-触发 | 从悬浮窗触发 | `SystemTools.CrossPlatform.FloatingWindowTrigger` | `RegisterTriggerIfEnabled<FloatingWindowTrigger, FloatingWindowTriggerSettings>(…)`（:364-365），处于 `if (config.EnableFloatingWindowFeature)` 门内（:362） | EnableFloatingWindowFeature && IsTriggerEnabled | p2-03 §4 W10/W11（源 :477-478；RegisterTriggerIfEnabled 形态 = p1-02 G1 先例） |

### 2.3 服务 4 项（B19 计数；DI 落点 Plugin.cs:122-135，生命周期见 §3）

| # | 功能项 | 注册身份 | DI 注册形态 | 来源批交接行 |
| --- | --- | --- | --- | --- |
| S-浮 | 悬浮窗服务（B11 服务面） | 类型 DI（非字符串 ID） | `services.AddSingleton<FloatingWindowService>()`（:127，紧随 FloatingWindowProfileManager :123，随源 :114→:115 相对序） | p2-03 §4 W1（源 :115） |
| S-主题 | 自动主题同步服务（B13 服务面） | 类型 DI | `services.AddSingleton<AdaptiveThemeSyncService>()`（:128） | p2-02 §6 B13 服务行（源 :119） |
| S-遮挡 | 遮挡检测服务（B14 服务面） | 类型 DI | `services.AddSingleton<MainWindowTextOcclusionService>()`（:129） | p2-02 §6 B14 服务行（源 :120） |
| S-内存 | ClassIsland 内存自动清理（项 49） | 类型 DI | `services.AddSingleton<ClassIslandMemoryAutoCleanupService>()`（:131），**其前**新增对 `AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`（:130，p2-01 §8 顺序约束） | p2-01 §8 DI 注册行（源 :122） |

### 2.4 非计数附属注册（不占 B19 计数，随交接清单落地）

| 项 | 注册形态 | 来源批交接行 |
| --- | --- | --- |
| SystemShutdownMonitor 实例 | `_systemShutdownMonitor = new SystemShutdownMonitor(); _systemShutdownMonitor.Start(); services.AddSingleton(_systemShutdownMonitor);`（:133-135）+ 字段 :54 | p2-03 §4 W5（源 :125-127/:56）；Windows 分支 WinForms 会话消息面由 R-2 条件文件形态 a 承载（p2-03 §1.4），注册面零平台条件代码 |
| IProcessMemoryMaintenanceService 对 | `AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`（:130）——p2-01 裁决 3 跨平台适配对，使注册面免平台条件代码 | p2-01 §8（新增对，须在内存清理服务注册之前——已满足，:130 在 :131 前） |

### 2.5 注册清单机器复核（本会话内复跑留证）

- 注册调用总数（`RegisterXxxIfEnabled<…>(…, "SystemTools.CrossPlatform.*")` 带引号 ID）= **37**；唯一 ID = **37**；重复注册 = **0**；非 `SystemTools.CrossPlatform.*` 前缀 = **0**。
- 构成：行动 29（A 档 15 + B 档 14）+ 组件 6 + 触发器 2（G1 + FloatingWindowTrigger）。
- B 档 15 个注册 ID（14 行动 + 1 触发器）逐一命中且各恰好 1 次（脚本逐 ID 断言输出 OK ×15）。
- 关键接线符号逐一在位：`AddSingleton<FloatingWindowService>` ×1、`AddSingleton<AdaptiveThemeSyncService>` ×1、`AddSingleton<MainWindowTextOcclusionService>` ×1、`AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>` ×1、`AddSingleton<ClassIslandMemoryAutoCleanupService>` ×1、`new SystemShutdownMonitor()` ×1、`CancelPlanOnAppStopping(isSessionEnding)` ×1、`MigrateFromLegacyConfig` 调用 ×1、`EnableFloatingWindowFeature == true` 门 ×3（设置页/AppStarted/OnAppStopping）+ `if (config.EnableFloatingWindowFeature)` 门 ×2（行动块/触发器）。

**19/19 闭合**：14 行动（§2.1）+ 1 触发器（§2.2）+ 4 服务（§2.3）= 19，与 p2-05 §1.3-6 口径（p2-01 8 + p2-02 7 + p2-03 4）一致；每项启用开闭形态随源（IsActionEnabled/IsTriggerEnabled 字典 + EnableFloatingWindowFeature 组门，MainConfigData B 档成员只读消费）。

---

## 3. DI/lifecycle 接线落实清单（对照三批交接逐项）

### 3-1 p2-01 §8 交接逐项

| # | 交接内容 | 源锚点 | 落实（新 Plugin.cs） |
| --- | --- | --- | --- |
| 1 | 行动注册 ×7（B4–B10，B6/B7 共享 ShortcutKeyNotificationSettingsControl 仅引用；B8–B10 单参） | :375-:382 | :275-286 逐项落实（§2.1）；共享控件引用零复制 |
| 2 | 行动菜单树：「电源选项…」组（\uEDE8）+ 7 个 ActionMenuTreeItem（ID/名称/图标随源） | :641-:644/:805-:821 | :473-481 组门 + :544-570 BuildPowerMenu（§5-1；AddRange→逐项 Add 沿 p1-06 §9-5 口径） |
| 3 | DI：`AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`（新增对，须在内存清理服务注册之前）+ `AddSingleton<ClassIslandMemoryAutoCleanupService>()` | :122 | :130-:131 顺序满足约束 |
| 4 | 初始化：`IAppHost.GetService<ClassIslandMemoryAutoCleanupService>().ApplyConfig();`（须在 GlobalConstants.MainConfig 赋值之后） | :218 | :206（AppStarted 内）——GlobalConstants.MainConfig 赋值于 Initialize :76 先行完成，AppStarted 晚于 Initialize 触发，约束满足（p2-05 §2.1 #10 口径） |
| 5 | 停止：`.Stop();` | :1045 | :234（OnAppStopping 内） |
| 6 | 生命周期接线：`AdvancedShutdownAction.CancelPlanOnAppStopping(isSessionEnding)`（bool 来源=AppStopping 上下文） | :1034-:1035/:1048 | :221-:222 读取 IsSessionEnding + :239 传递调用（方法签名 `public static bool CancelPlanOnAppStopping(bool)` 已对照新 AdvancedShutdownAction.cs:78 核实） |

### 3-2 p2-02 §6 交接逐项

| # | 交接内容 | 源锚点 | 落实（新 Plugin.cs） |
| --- | --- | --- | --- |
| 1 | 5 ActionInfo（B1/B2/B3 + B13/B14，双参形态） | :385/:386/:387/:431-432/:433-434 | :288-291（文件操作组）+ :335-339（更多功能选项组）逐项落实（§2.1） |
| 2 | `AddSingleton<AdaptiveThemeSyncService>()` | :119 | :128 |
| 3 | `AddSingleton<MainWindowTextOcclusionService>()` | :120 | :129 |
| 4 | AdaptiveThemeSyncService 生命周期：AppStarted → `Start()`；OnAppStopping → `Stop()` | :215/:1041 | :202 / :230 |
| 5 | MainWindowTextOcclusionService 生命周期：AppStarted → `Start()`；OnAppStopping → `Shutdown(restoreMainWindow)` | :216/:1043 | :203 / :232（`Shutdown(restoreMainWindow: true)`，实参随源；新签名 `Shutdown(bool restoreMainWindow = false)` 已核实） |

### 3-3 p2-03 §4 W1–W13 交接逐项

| # | 交接需求 | 源先例 | 落实（新 Plugin.cs） |
| --- | --- | --- | --- |
| W1 | `services.AddSingleton<FloatingWindowService>()`（构造器 MainConfigHandler + FloatingWindowProfileManager 均已在位） | :115 | :127（紧随 FloatingWindowProfileManager :123，随源相对序） |
| W2 | FloatingWindowService.Start()（AppStarted，EnableFloatingWindowFeature 门） | :210-213 | :197-200（`== true` 门形态随源） |
| W3 | FloatingWindowService.Stop()（OnAppStopping，同门） | :1061-1064 | :245-248 |
| W4 | `IAppHost.GetService<FloatingWindowProfileManager>().MigrateFromLegacyConfig(GlobalConstants.MainConfig!.Data)`（AppStarted；p1-06 阶段 1 预留注释 :49 兑现并已改写） | :207 | :195（AppStarted 内首组接线后） |
| W5 | SystemShutdownMonitor 实例：new + Start() + AddSingleton + 字段声明 | :125-127（字段 :56） | :133-135 + 字段 :54；非 Windows 分支 Start 为 no-op，接线形态平台无关 |
| W6 | OnAppStopping：IsSessionEnding 读取 → `AdvancedShutdownAction.CancelPlanOnAppStopping(isSessionEnding)`（bool 传递）+ `systemShutdownMonitor.Dispose()` | :1034-1035/:1048/:1057 | :221-222 / :239 / :241；非 Windows 恒 false → 走"ClassIsland 主动退出"分支（源 :1055 语义） |
| W7 | `RegisterShutdownRequestedHandler`：DesktopLifetime.ShutdownRequested → `MarkIfOsShutdown(args)` | :1070-1079 | :253-267 方法 + :212-213/:193 双调用点（源 :287/:203 形态）+ OnAppStopping 退订 :224-228（源 :1036-1040 形态） |
| W8 | B11 行动注册（RegisterActionIfEnabled 双参） | :416-417 | :303-304 |
| W9 | B12 行动注册 | :418-419 | :305-306 |
| W10 | FloatingWindowTrigger 触发器注册（RegisterTriggerIfEnabled 形态） | :477-478 | :364-365 |
| W11 | 注册组门恢复（源 :414/:475/:671-677/:182-185 四处 EnableFloatingWindowFeature 门） | — | 全部兑现（§4）；门成员 `EnableFloatingWindowFeature` 已由 p2-03 增补至配置根（MainConfigData.cs:332，只读消费） |
| W12 | A3/A4 窗口刷新路径回归注记 | p1-03 §7-5 预留 | §9（礼部本批兑现登记） |
| W13 | SystemMotionPreferences B 档零消费留痕 | — | §10-6：本批注册面零引用 SystemMotionPreferences（p2-03 §2-D11 留痕兑现；Plugin.cs 零命中，供终检知悉） |

---

## 4. 组门恢复说明（p1-06 §9-4/§9-6 报备恢复点逐项兑现；p2-03 W11 全项）

门成员来源：`MainConfigData.EnableFloatingWindowFeature`（p2-03 增补段，MainConfigData.cs:332，默认 true，JSON 名随源）——本批**只读消费**，零 MainConfigData 改动。

### 4-1 恢复点 ①：悬浮窗行动注册门（p1-06 §9-4「A3/A4 常规注册」差异的源形态恢复）

- 源形态（:414-424）：B11/B12/A3/A4 四行动同处 `if (config.EnableFloatingWindowFeature)` 门内。
- 新落点（:299-311）：同源门形态；B11/B12 为本批新增注册，A3/A4 自阶段 1 的"无门常规开闭注册"（p1-06 §2.5 注记）**恢复入源门**，注册序随源 :416-423（ShowFloatingWindow → ToggleFloatingWindowLayer → ToggleFloatingWindowProfile → SwitchFloatingWindowTheme）。
- 语义：EnableFloatingWindowFeature=false 时悬浮窗行动面整体不注册（含 A3/A4），与源一致；开关默认 true，既有用户行动面不回退。

### 4-2 恢复点 ②：悬浮窗触发器注册门（源 :475-479）

- 新落点（:361-366）：`if (config.EnableFloatingWindowFeature) { RegisterTriggerIfEnabled<FloatingWindowTrigger, FloatingWindowTriggerSettings>(…); }`——门内再经 IsTriggerEnabled 开闭，双层形态随源。

### 4-3 恢复点 ③：悬浮窗编辑页注册门（p1-06 §9-6「无条件注册」恢复，源 :182-185）

- 新落点（:167-172）：`if (GlobalConstants.MainConfig?.Data.EnableFloatingWindowFeature == true) { services.AddSettingsPage<FloatingWindowEditorSettingsPage>(); }`——p1-06 阶段 1 因门成员未引入而登记的无条件注册差异消除；页面骨架与注册 id（`SystemTools.CrossPlatform.settings.floating`）零改动。
- **设置页面不受影响声明**：其余 5 页注册零改动（主设置/更多功能选项无条件、aiChat 条件门随源、about/pluginDebug 无条件，:160-174）；分组机制沿 p1-06 §9-3 宿主原生 `AddSettingsPageGroup`+`[Group]` 口径不变（:160），未新建任何注册辅助文件。

### 4-4 恢复点 ④：悬浮窗行动菜单组（p1-06 §9-4「阶段 1 不建组」恢复）——详见 §5-2。

---

## 5. 菜单组恢复说明（菜单树属注册面用户可见组织，不占 B19 计数——p1-06 §2.7 口径）

### 5-1 电源选项组（p2-01 §8 行动菜单树交接行；源 :641-646/:805-821）

- 组门（:474-477）：`HasAnyActionEnabled(config, 7 个 B 档电源 ID)`，随源 :642。
- 组节点（:479）：`new ActionMenuTreeGroup("电源选项…", "\uEDE8")`——名称/图标逐字符随源。
- 逐项（BuildPowerMenu :544-570，源 :805-821 文案/图标随源、ID 前缀改写）：计时关机 \uE4C4 / 高级计时关机 \uE4D2 / 取消关机计划 \uE4CC / 锁定屏幕 \uEAF0 / 立即重启 \uE0BD / 立即关机 \uEDE9 / 睡眠 \uF44B（菜单项序随源 :804-817，与注册序差异随源保留）。
- 树内位置：组插于「SystemTools 行动」根首位（源相对序：模拟操作/显示设置属 C 档未迁，电源选项为其后首个在位组）。

### 5-2 悬浮窗设置组（恢复点 ④；源 :671-677/:895-912）

- 组门（:492-494）：`config.EnableFloatingWindowFeature && HasAnyActionEnabled(config, B11/B12/A3/A4 四 ID)`——随源 :671-673 形态（A3/A4 归组随源）。
- 组节点（:496）：`new ActionMenuTreeGroup("悬浮窗设置…", "\uEA37")`——名称/图标逐字符随源。
- 逐项（BuildFloatingWindowMenu :572-592，源 :899-906 形态：每项 EnableFloatingWindowFeature && IsActionEnabled 双判随源）：显示悬浮窗 \uEA37 / 切换悬浮窗层级 \uE9A8 / 切换悬浮窗配置方案 \uE9A8 / 切换悬浮窗主题 \uE790（B11/B12/A3/A4 归组随源；A3/A4 菜单项自本批起首次进入菜单树）。
- 树内位置：随源相对序插于「实用工具…」与「媒体工具…」之间（:483-:505）。

### 5-3 文件操作组（尚书省微修 1 补齐；源 :648-653/:825-840）

- 组门（源 :649 形态随源）：`HasAnyActionEnabled(config, B1/B2/B3 三 ID)`——三成员均为 B 档在册注册项，**组门无裁剪**。
- 组节点：`new ActionMenuTreeGroup("文件操作…", "\uE759")`——名称/图标逐字符随源。
- 逐项（BuildFileMenu，源 :829-834 文案/图标随源、ID 前缀改写）：复制 \uE6AB / 移动 \uE6E7 / 删除 \uE61D。
- 树内位置：随源相对序插于「电源选项…」与「实用工具…」之间（源 :641→:648→:662）。

### 5-4 更多功能选项组（尚书省微修 1 补齐；源 :686-692/:923-938）

- 组门差异注记：源 :687-688 组门含 `AutoOpenUsbDriveOnInsert`（C 档未迁）——按 p1-06 §2.7 组门裁剪先例（ClassIsland 组门裁剪 RestartAsAdmin 同口径），**组门/组内仅呈现 B13/B14 两个在册注册项**；C 档 ID 于 Plugin.cs 仅注释留痕、零注册零菜单项（机器复核 3 处命中全为注释行，§11）。
- 组节点：`new ActionMenuTreeGroup("更多功能选项…", "\uE28E")`——名称/图标逐字符随源。
- 逐项（BuildMoreFeaturesMenu，源 :927-930 文案/图标随源）：自动切换 ClassIsland 主题 \uE5CB / 遮挡文字时隐藏主界面 \uEEE3（源 :931-932 AutoOpenUsbDriveOnInsert 菜单项不呈现）。
- 树内位置：随源相对序插于「媒体工具…」与「高级自动化工具…」之间（源 :679→:686→:694）。

### 5-5 菜单组织机制与行号口径

- 逐项 `Add(item)` 等价改写沿 p1-06 §9-5 口径（宿主 `ActionMenuTreeNodeCollection` 无 AddRange），语义一致。
- **行号口径**：本报告 §1-§4/§9 行号为主批 684 行状态；§5-3/§5-4 为微修 1 后 742 行状态（微修 1 使 :483 之后菜单区行号整体 +58；主批区 :1-482 行号不变）。
- 菜单组织面补齐经过：主批（§10-1 初版报备）按交接范围仅建电源选项/悬浮窗设置两组；尚书省微修 1 裁定由本注册面小批补齐其余两组（源先例只读直参，免兵部补交接往返），§5-3/§5-4 为其交付记录。微修后菜单面合计：组节点 10（根除外）+ 菜单项 29（主批 24 + 微修 5），全部文案/图标逐字符随源。

---

## 6. S4.2 门禁自检与全树收口复跑（p0-07 扫描器 R-2 版，零改动使用；原始输出留档 `p2-06-s42-scan-output.txt`）

执行方式：单一 pwsh 进程内 `&` 直接调用扫描器（嵌套 pwsh 子进程受沙箱命名管道边界限制，p1-02/p2-02 同款先例）；扫描器输出/规则/退出码零改动。

| run | 目标 | SourceFiles | GateHits | ConditionalHits | InfoHits | VERDICT | exit |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `Plugin.cs` 单文件直扫（-Scope Source） | 1 | **0** | 0 | 0 | **PASS (zero gate hits)** | **0** |
| 2 | 全树收口复跑 `src\SystemTools.CrossPlatform`（-Scope Source） | **168** | **0** | **13**（R-2 非门禁） | 2（I04，p2-03 既有） | **PASS (zero gate hits) [CONDITIONAL=13 R-2]** | **0** |
| 4 | **微修 1**：`Plugin.cs` 单文件直扫（菜单组织面补齐后） | 1 | **0** | 0 | 0 | **PASS (zero gate hits)** | **0** |
| 5 | **微修 1**：全树收口复跑（菜单组织面补齐后） | **168** | **0** | **13**（四文件集合与主批一致） | 2 | **PASS (zero gate hits) [CONDITIONAL=13 R-2]** | **0** |

- **CONDITIONAL=13 与兵部三批登记一致且零新增**：13 = 10（p2-01：SystemPowerCommandWindows R21×5+R17×3 / ProcessMemoryMaintenanceNativeWindows R13+X04）+ 3（p2-03：SystemShutdownMonitor R03 / SystemMotionPreferences R13+X04）。逐文件清单（扫描输出 CONDITIONAL FILES 段）：`Actions\SystemPowerCommandWindows.cs : R21,R17`、`Services\ProcessMemoryMaintenanceNativeWindows.cs : R13,X04`、`Services\SystemShutdownMonitor.cs : R03`、`Views\SystemMotionPreferences.cs : R13,X04`。本批唯一交付文件 Plugin.cs **零 #if、零条件文件、零新增 CONDITIONAL**。
- GATE-HIT FILES = (none)（两个 run 均）；COMMENT-ONLY 6 条为 csproj 既有注释（p1-06 §7-1 同值，非门禁命中）。
- 文件数说明：全树实测 **168** 与 p2-03 §6.1 全树基线同值（本批零新增 .cs 文件，仅改写 Plugin.cs）；派工单"预期 ~180"为估算口径，实际以 168 计，门禁判定变量（GateHits/CONDITIONAL/exit）不受影响。
- 派工约束 1 兑现：**零 csproj 改动、零 DefineConstants 需求**（p2-01 原接线需求已撤销；Plugin.cs 无任何平台预处理符号）。
- 派工约束 2 兑现（GUID 条款）：本批零新增 GUID 形态注册身份——全部为 ActionInfo/TriggerInfo 字符串 ID（15 个）+ 服务 DI 类型注册；预期"无新增 GUID"成立，零映射留痕需求。
- 派工约束 3 兑现：显示文案随源不改（§5 菜单 16 项〔主批 11 + 微修 5〕文案/图标逐字符随源；既有页面/行动文案零触碰）；ID 全部 `SystemTools.CrossPlatform.*` 前缀（§2.5 机器复核零非前缀）。
- **微修 1 复跑补充**：run 4/5 原始输出已追加于 `p2-06-s42-scan-output.txt`（"## 微修 1 run 4/run 5" 段）；微修 1 后 manifest SHA256 复测同值 `142CD419…AAC`（同文件微修段留档）；微修 1 注册面机器复核：行动/触发器注册调用 31（29 行动 + 2 触发器）+ 组件 6 = 37 不变，唯一 ID 37、零重复、零非前缀；`AutoOpenUsbDriveOnInsert` 全文件 3 处命中均为注释行（:335/:517/:637），零注册零菜单项。

---

## 7. Roslyn 批内补充编译自检（派工约束 5：沿升级方法——隐式 using 语境 + 宿主同语境引用集）

- 脚本/输出：`evidence\p2-06-supplementary-compile-check.ps1` / `p2-06-supplementary-compile-check-output.txt`（非官方构建门禁；官方三平台 dotnet build 仍属阶段级验证，工部职权）。
- 语境：引用集从工部 `p1-10-build-fallback-win-rerun.log` csc 命令行提取（**644 个 /reference: 全部在盘**，含 Avalonia/FluentAvalonia/ClassIsland SDK 双分支面与 Microsoft.WindowsDesktop.App 引用面）；预处理符号取自同一日志 /define: 集；隐式全局 using 存根（.NET SDK 隐式集）；MVVM 8.2.1 生成成员 partial 存根（p2-03 同款）。
- 入检树：**工程全量真实 .cs 163 文件**（排 bin/obj，含 Plugin.cs 及其全部引用闭包——163 = 全树 Source 面 168 − csproj 1 − yml 4）+ 检查专用存根 2；SystemToolsNotificationProvider 以真实文件入检（全工程语境下无需存根，较 p2-03 更强）。
- **双向符号验证**（阶段 2 条件文件语境，p2-03 方法）：
  - Pass A（Windows 语境，含 `Platforms_Windows`）：**Plugin.cs 归属 error=0**（warning=3，均为 CS8632 nullable 语境提示——检查脚本未设 Nullable=enable 的语境产物，真实构建 csproj `<Nullable>enable` 下不存在，p2-03 §6.3 同款注记）；
  - Pass B（非 Windows 语境，`Platforms_Windows`→`Platforms_Linux`）：**Plugin.cs 归属 error=0**（warning=3 同上）。
  - 双 Pass 全树其余 262 条 error 全部归属 26 个非判定文件（XAML 生成面/MVVM 生成器未接线预期噪声，p1-06 §7-6 先例口径，单列不计判定）。
- 判定：**COMPILE OK（双向）**，exit=0——B19 注册/DI/lifecycle/组门接线对 SystemShutdownMonitor 两分支公共表面（`IsSessionEnding`/`Start`/`MarkIfOsShutdown(object)`/`Dispose`）编译一致，`ShutdownRequestedEventArgs`（Avalonia.Controls.ApplicationLifetimes）消费面与真实构建语境同源。
- **微修 1 复跑**：同一脚本/语境（163 真实 .cs + 644 引用，零改动）双向重验——Pass A/Pass B 均 **Plugin.cs 归属 error=0**（warning=3 CS8632 语境 artifact 同前），全树 262 条 error 归属集合与主批完全一致（26 文件 XAML/MVVM 生成面噪声）；COMPILE OK，exit=0。输出追加于 `p2-06-supplementary-compile-check-output.txt` "微修 1 复跑" 段。

---

## 8. manifest 不变声明

- 本批写入对象仅 `src\SystemTools.CrossPlatform\Plugin.cs` 与本案 evidence/ 4 文件；**manifest.yml 零触碰**（含 `Themes\*\manifest.yml` 三个主题清单零触碰）。
- 字节级证据：本批交付后实测 `src\SystemTools.CrossPlatform\manifest.yml` SHA256 = `142CD419DA23D17DAD565B91D0AE6833CEEFAC7032FB3C6D3A8E991A00A26AAC`，与 p0-05 证据 §13 基线记录 `142CD419…AAC` **逐字符一致**（p0-05 校验工具最近一次对该基线判 11 PASS + SCHEMA-PARSE-CHECK: PASSED；哈希实测已留档 `p2-06-s42-scan-output.txt` run 3 段）。

---

## 9. A3/A4 窗口刷新路径回归注记（p2-03 W12 归属兑现）

- **注册面**：A3（`SystemTools.CrossPlatform.ToggleFloatingWindowProfile`）/A4（`SystemTools.CrossPlatform.SwitchFloatingWindowTheme`）行动本体自 p1-03 交付以来注册形态未变（RegisterActionIfEnabled 双参 + IsActionEnabled 开闭）；本批唯一变化 = 恢复入源 `EnableFloatingWindowFeature` 组门（§4-1）——与源 :416-423 语义一致，开关默认 true 下行为面无回退。
- **服务面**：p2-03 FloatingWindowService 交付后，A3/A4 消费面现可用——方案路径 `ToggleWindowProfile`/`SwitchToProfile`（A3），主题路径 `SetWindowTheme`/`ToggleWindowTheme`（A4），及 FloatingWindowProfileManager 方案/主题消费；服务 Start/Stop 已接线（W2/W3，§3-3）。
- **窗口刷新路径**：A3 执行后悬浮窗经服务方案切换链刷新（FloatingWindowService.ApplyVisibility/RefreshWindowButtons 经典保留面）；A4 经主题订阅链刷新（SubscribeThemeChanged/ResolveWindowThemeVariant/SetWindowTheme 保留面）——两路径的服务内部实现属 p2-03 批交付面，本批仅确认注册面→服务调用面贯通（消费符号经 §7 双向编译验证）。
- **菜单面**：A3/A4 菜单项随悬浮窗设置组恢复进入菜单树（§5-2，文案/图标随源 :904/:906）；p1-06 阶段 1"A3/A4 菜单组缺失"差异消除。

---

## 10. 报备事项（差异与未随入面，均已留痕；请尚书省/Menxia 知悉）

1. **文件操作组/更多功能选项组菜单树——已补齐（尚书省微修 1，交付记录 §5-3/§5-4）**：p2-02 §6 交接清单无菜单树行——**格式缺口留痕：p1-05 §4.2 交接格式表列不含"菜单树"列，致 p2-02 交接遗漏菜单组织面**（p2-01 §8/p2-03 W11 为显式交接行故未遗漏）；供吏部 p2-09 结构规范修订登记（建议 §4.2 表列增补"行动菜单树（如有）"可选列，避免后续批次再现同类缺口）。微修 1 由尚书省裁定以源先例只读直参落实（免兵部补交接往返），两组菜单按源形态补齐（组门裁剪差异见 §5-4 注记），本条初版"未建"状态废止。
2. **源 OnAppStopping 信息日志面未随入**（源 :1049-1056 两条 LogInformation）：三批交接未含 logger 接线；p1-06 §9-1 已核减 AddLogging 且未引入 `_logger` 字段，本批不越界引入；`CancelPlanOnAppStopping(bool)` 调用语义完整（行动内部日志/Toast 面由 p2-01 批承载），可观测性差异仅宿主退出路径两条 info 日志，留痕备查。
3. **源悬浮窗托盘菜单面未随入**（源 :1081-1169 RegisterOrUpdateFloatingWindowTrayMenu 等）：不在三批交接 W1–W13 内，本批零接线；如后续批需要，按 p1-05 §2.3 共享增补/交接流程登记。
4. **RegisterShutdownRequestedHandler 双调用点**（Initialize 直注 + AppStarted 重注）：随源 :287/:203 形态保留，方法幂等（null 判重）；OnAppStopping 退订随源 :1036-1040。
5. **AppStarted 处理器内 C 档行不随入**（源 :205-206/:208/:214/:217/:219 与 :221-263 日志/人脸面）：属 C 档或未交接面，注释内逐项列名留痕。
6. **SystemMotionPreferences 零消费（W13）**：本批注册面零引用该类型（B 档唯一消费点已随 U5 降级移除，p2-03 §2-D11）；留痕供终检知悉，不阻塞。
7. **MigrateFromLegacyConfig 时点**：随源 :207 置于 AppStarted（MainConfig 赋值后、悬浮窗服务 Start 前）；p1-03 §3.1 阶段 1 预留注释（原 Plugin.cs:49）已改写为兑现注记。

---

## 11. 边界声明与复核指引

- 本批写入：`src\SystemTools.CrossPlatform\Plugin.cs`（唯一交付文件，480→684 行（主批）→742 行（微修 1））＋ evidence/ 4 文件（本报告、`p2-06-s42-scan-output.txt`〔主批 3 段 + 微修 1 复跑 2 段〕、`p2-06-supplementary-compile-check.ps1`、`p2-06-supplementary-compile-check-output.txt`〔主批 + 微修 1 复跑〕）。
- 零改动：`manifest.yml`（SHA256 与 p0-05 基线一致，§8）、`SystemTools.CrossPlatform.csproj`、`global.json`、`.slnx`、`ConfigHandlers\MainConfigData.cs`（p2-01/p2-02/p2-03 三批增补段只读消费）、兵部三批全部交付文件、p1-06 设置页、源插件检出（只读）、宿主检出（只读）。
- 复核重放：
  1. S4.2 单文件：`& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Plugin.cs -Scope Source`（预期 GateHits=0、exit=0）；
  2. S4.2 全树：`& .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform -Scope Source`（预期 SourceFiles=168、GateHits=0、CONDITIONAL=13、exit=0）；
  3. manifest 哈希：`(Get-FileHash src\SystemTools.CrossPlatform\manifest.yml -Algorithm SHA256).Hash`（预期 142CD419…AAC）；
  4. Roslyn 双向：`& .tang\cases\stcp-cross-platform-001\evidence\p2-06-supplementary-compile-check.ps1`（预期两 Pass 均 PASS、exit=0）；
  5. 注册清单：§2.5 机器复核口径（37 调用/37 唯一 ID/零重复/零非前缀/15 个 B 档 ID 逐一在位）；微修 1 后同口径复核（§6 微修补充段）菜单项 29（主批 24 + 微修 5）/组节点 11（根 + 10 组）/`AutoOpenUsbDriveOnInsert` 零代码面。
- 本文件不推进、不审批全局工作流；属批级交付证据，交尚书省 `tang_record_ministry_result` 记录，门下省终验为独立最终接受权威。

## 12. 修订记录

- 初版（p2-06 执行交付；单轮编辑一次成型，批内零返工）。
- 微修 1（尚书省微修指令：文件操作/更多功能选项两组菜单树补齐，源 :648-653/:825-840/:686-692/:923-938 只读直参；Plugin.cs 684→742 行；复跑 run 4/5 + Roslyn 微修段全 PASS；§5-3/§5-4 新增、§5-5 改写、§10-1 改写为已补齐、§6/§7/§11 同步；B19 计数 19 项零变化——菜单组织面不占计数）。
