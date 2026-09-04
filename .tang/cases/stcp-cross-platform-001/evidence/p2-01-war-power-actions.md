# p2-01 证据：B 档电源族 7 行动 + ClassIsland 内存 GC + 两对话框（兵部 application-code / implementation）

| 项 | 值 |
| --- | --- |
| 案卷 | stcp-cross-platform-001（case_scale=large） |
| 派工 | assignment p2-01 · 兵部 war · application-code / implementation（阶段 2 第 1 批；前次派工因基础设施故障零产出中断，本批全新执行，尚书省重派注记确认零部分产物） |
| 权威输入 | p2-05 §1.2 落点表（范围权威）+ §2.1 #10（MainConfigData 预批）+ §3（EmptyWorkingSet 预判）+ §4（双分支 API 面清单）；p0-03 §3.2 B 清单（B4–B10 逐项 file:line）；p1-05（目录/命名/注册面约定含 R1）；04-spec §S4.2:61（B 档 Windows 专属点声明位）与 U4:90（预检+降级）；06 条目 37–43（电源族）与 49（内存 GC）；p1-10 §12.5（双分支 API 漂移约束）；p0-07 §11（刑部 R-2 条件文件口径）；p1-02 §5.2 / p1-03 §5（Roslyn 批级自检方法与 CS0104 隐式 using 升级） |
| 落点结论 | **succeeded** —— 10 项落点组全交付（B4–B10 七行动 + 项 49 内存 GC 服务 + B5 两对话框附属），23 个交付文件（21 .cs + 2 .axaml）；机制适配点 10 条逐项登记（§2）；U4 预检+IDesktopToastService 降级链路全族覆盖（§3）；macOS 五列自检表 10/10 通过（§4）；S4.2 扫描 GateHits=0 / VERDICT: PASS / 直跑 exit=0、CONDITIONAL=10（§5）；Roslyn 双向符号两轮 error=0（§6）；MainConfigData 预批段落地（§7） |
| 写入范围 | 仅本批落点文件（src\SystemTools.CrossPlatform 下 22 个 .cs 新文件/修改 + 2 个 .axaml 新文件）+ MainConfigData 预批段 + evidence/ 下 4 个本批文件；源插件与宿主检出全程只读；零改动 Plugin.cs / csproj / manifest.yml / 其他批文件（并行批 p2-02/p2-03 已落的 MainConfigData 增补段零触碰，本批段独立插于其间） |
| 回报口径 | 10 项落点数 = 8 个 B19 计数项（B4/B5/B6/B7/B8/B9/B10 + 项 49）+ 2 个对话框附属（p2-05 §1.2 归本批，不另计 B19 计数） |

---

## 1. 交付清单与逐项源锚点→新落点对照

### 1.1 电源族 7 项（B19 计数项，p2-05 §1.2 行 1–7 逐行对应）

| 项 | 功能名 | 源锚点（p0-03/06 条目） | 新落点（行数） | Windows 专属点新载体 | 备注 |
| --- | --- | --- | --- | --- | --- |
| B4 | 计时关机 | ShutdownAction.cs:15（:30-38 命令启动、:40-44 WinForms 确认，06-37） | `Actions\ShutdownAction.cs`（93 行） | 条件执行器 `RunTimedShutdown`（§1.3） | SendKeys 按 06-37 删除，ShowPrompt 成员保留兼容（§2-A4） |
| B5 | 高级计时关机 | AdvancedShutdownAction.cs:22（:33 对话框字段、:558 ExtendShutdownDialog，06-38） | `Actions\AdvancedShutdownAction.cs`（538 行） | 条件执行器 计划/取消/立即 三方法 | 看门狗移除、取消可见化、计划载体改写（§2-A2/A3/A5） |
| B6 | 取消关机计划 | CancelShutdownAction.cs:14（:29-30 /a，06-39） | `Actions\CancelShutdownAction.cs`（98 行） | 条件执行器 `RunCancelScheduledShutdown` | 1116=无活动计划 语义区分（§2-A8） |
| B7 | 锁定屏幕 | LockScreenAction.cs:14（:29-30 rundll32，06-40） | `Actions\LockScreenAction.cs`（93 行） | 条件执行器 `RunLockWorkstation` | 随源 rundll32 形态保持（裁决 1） |
| B8 | 立即重启 | ImmediateRestartAction.cs:12（:16-17 ntdll、:28 ExitWindowsEx，06-41） | `Actions\ImmediateRestartAction.cs`（87 行） | 条件执行器 `RunImmediateRestart` | 源不公开 API → 命令等价 /g /t 0（裁决 1） |
| B9 | 立即关机 | ImmediateShutdownAction.cs:12（同 B8 形态，06-42） | `Actions\ImmediateShutdownAction.cs`（87 行） | 条件执行器 `RunImmediateShutdown` | 同上，/s /t 0 |
| B10 | 睡眠 | SleepAction.cs:10（:23-24 powrprof rundll32，06-43） | `Actions\SleepAction.cs`（105 行） | 条件执行器 `RunSleep` | 随源 rundll32 形态保持；同步调用有界等待语义（§2-D7） |

### 1.2 项 49 服务 + 两对话框附属 + 附属设置对

| 项 | 源锚点 | 新落点 | 备注 |
| --- | --- | --- | --- |
| 49 ClassIsland 内存自动清理 | ClassIslandMemoryAutoCleanupService.cs:13（:22-23 平台互操作、:96-99 守卫、:103-120 GC 链、:27 配置读取，06-49） | `Services\ClassIslandMemoryAutoCleanupService.cs`（163 行） | GC 链+阈值测量三平台；守卫位置校正至工作集调用点（§2-A1）；构造函数注入 `IProcessMemoryMaintenanceService` |
| B5 附属对话框 1 | Views\AdvancedShutdownDialog.axaml(+.cs) 71/44 行 | `Views\AdvancedShutdownDialog.axaml` + `.axaml.cs` | 命名空间/x:Class 改写 SystemTools.CrossPlatform.Views；MyWindow 双分支 PRESENT（p2-05 §4） |
| B5 附属对话框 2 | Views\ExtendShutdownDialog.axaml(+.cs) 28/67 行 | `Views\ExtendShutdownDialog.axaml` + `.axaml.cs` | 同上 |
| B4 设置/控件对 | Settings\ShutdownSettings.cs 13 行、Controls\ShutdownSettingsControl.cs 67 行 | 同名落点 | 逐成员随源，仅命名空间改写 |
| B5 设置/控件对 | Settings\AdvancedShutdownSettings.cs 8 行、Controls\AdvancedShutdownSettingsControl.cs 54 行 | 同名落点 | 同上 |
| B6/B7 设置对 | （零新文件） | 复用 p1-03 共享 `Settings\ShortcutKeyNotificationSettings.cs` + `Controls\ShortcutKeyNotificationSettingsControl.cs` | 仅引用不复制（p2-05 §1.2 / 裁决 4） |

### 1.3 本批新造文件（6 个，命名备案见 §9-2）

| 新文件 | 形态 | 承载 |
| --- | --- | --- |
| `Actions\SystemPowerCommandWindows.cs`（110 行） | R-2 双形态合格：全文件裸 `#if Platforms_Windows` 包裹（形态 a）+ `*Windows.cs` 命名（形态 b） | 电源族全部 Windows 命令启动（6 个 Run* 方法 + 2 个 Is*Available 预检；R21×5 + R17×3 命中全部在 guard 内=CONDITIONAL） |
| `Actions\SystemPowerCommandStub.cs`（35 行） | `#if !Platforms_Windows` 全包裹；零门禁符号 | 非 Windows 编译闭合存根（返回 false/-1） |
| `Services\IProcessMemoryMaintenanceService.cs`（22 行） | 无条件；零门禁符号 | 插件本地抽象（**非宿主 API** 注记于接口 doc：宿主双分支 ABSENT，p1-05 §5.3-3 禁止发明 ClassIsland.* 接口） |
| `Services\ProcessMemoryMaintenanceService.cs`（24 行） | 无条件；零门禁符号 | 默认实现外壳（令注册面可无条件 `AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`，注册面免平台条件代码——p1-10 §12.5 护栏） |
| `Services\ProcessMemoryMaintenanceNativeWindows.cs`（47 行） | R-2 双形态合格（同上） | psapi 工作集修剪互操作声明 + 调用（R13×1 + X04×1 = CONDITIONAL 2 处） |
| `Services\ProcessMemoryMaintenanceNativeNoOp.cs`（22 行） | `#if !Platforms_Windows` 全包裹；零门禁符号 | 非 Windows no-op 留痕（恒 false，06-49 降级口径） |

---

## 2. 机制适配点登记（A=已批口径落实；D=随源改动注记）

### 2.1 A 类（尚书省裁决 + 04-spec/06 已批口径）

| # | 适配点 | 内容 |
| --- | --- | --- |
| A1 | **EmptyWorkingSet 实现方式（裁决 3）** | 采用插件本地接口 `IProcessMemoryMaintenanceService` + Windows 条件适配器（psapi 互操作声明承载于全文件 guard 的 `*Windows.cs`）+ 非 Windows no-op 留痕；**符合 S4.2/R-2**（互操作声明与调用全部处于正向 guard 内，扫描计 CONDITIONAL 2 处，GateHits=0），无需上报裁决。守卫位置事实校正：源 :96-99 守卫位于 GC 块之前（非 Windows 整体不执行含 GC），新实现将平台差异收敛至工作集调用点——GC 链与阈值测量三平台执行、工作集修剪仅 Windows 适配器生效（对齐 06-49「GC 三平台+工作集仅 Windows」，与 02 v2 §3「非 Windows 整体跳过」的差异按 p2-05 §3.1 留痕） |
| A2 | **B8/B9 立即关机/重启命令等价替代（裁决 1）** | 源 ntdll RtlAdjustPrivilege + CsWin32 ExitWindowsEx（不公开 API）→ `shutdown.exe /s /t 0`（B9）与 `shutdown.exe /g /t 0`（B8，裁决口径；06-41 表述为 /r /t 0，以尚书省本批裁决为准并于此留痕差异）。能力等价：SHTDN_REASON_FLAG_PLANNED 语义由系统命令默认行为承接，不引入未公开 API |
| A3 | **B5 计划载体改写（06-38）** | 源 :156-180 经命令解释器包装本地倒计时进程 + 进程 kill 取消 → 改为系统命令族「先取消旧计划（/a）+ 直接按总秒数计划（/s /t <seconds>）」：Windows 仅允许单一关机计划，重复计划报 1190，故计划/延长前先取消（无旧计划时 /a 返回 1116 仅记日志）；本地无倒计时进程可跟踪，`_countdownProcess`/`StartOrReplaceCountdownProcess`/`StopCountdownProcess` 随之消解 |
| A4 | **B4 SendKeys 删除（06-37）** | 源 :40-44 WinForms 按键模拟自动确认删除（S4.2 禁用符号②）；`ShowPrompt` 成员保留随源配置兼容、控件语义不变，跨平台不承诺各 OS 相同的系统确认 UI（06-37 拟纳入边界明文） |
| A5 | **B5 看门狗移除（06-38）** | 源 :25/:77-87 固定宿主进程名轮询与 :256-291 计划活性轮询移除（「看门狗改用宿主生命周期事件，不检查固定 .exe 名称」）；宿主退出路径由礼部生命周期接线调用本行动静态 `CancelPlanOnAppStopping(bool)` 承担（源 Plugin.cs:1048 先例；方法仅收 bool，与 p2-03 SystemShutdownMonitor 文件零编译耦合，p2-05 §1.2 非计数附属行） |
| A6 | **取消可见化（06-38「吞异常不能掩盖未取消」）** | 源 :201-219 TryAbortSystemShutdown 吞异常 → 执行器返回退出码并记日志；对话框「取消关机计划」按钮路径：hadPlan && exit∉{0,1116} → Warning 日志 + Toast「未生效」；exit=1116（已无计划，可能被外部取消）→ 信息日志不提示 |
| A7 | **B5 延长失败处置（06-38）** | 源静默吞异常 → 延长重计划失败时：`StopAllStates()` 撤销本地计划 + 回收主对话框/悬浮窗/定时器 + Toast 失败原因（对齐 06-38「系统动作不可用时必须撤销本地计划、Toast 通知失败原因并回收窗口/定时器」） |
| A8 | **B6 语义区分（06-39）** | 退出码 0=已取消 → 成功通知（NotifyOnExecute）；1116（无活动关机计划）→ Toast「当前没有活动的关机计划」（非失败）；其余 → Toast「未执行成功」+ Error 日志 |
| A9 | **执行器收敛为条件文件（04-spec:61 声明位）** | 电源族全部 Windows 命令启动收敛至单一条件文件对（§1.3），不建平台目录；B 档「Windows 专属点」以源内声明注释（各行动文件头）+ 条件文件承载落实 |
| A10 | **U4 预检统一形状（04-spec:90）** | 全族统一三级链路（§3）；`OperatingSystem.IsWindows()` 运行时守卫分支形态（04-spec:76 允许并须注明——各行动文件头已注明） |

### 2.2 D 类（随源微调注记，零行为目标变化）

| # | 适配点 | 内容 |
| --- | --- | --- |
| D1 | B4/B6/B7 通知面随源 | `IAppHost.GetService<SystemToolsNotificationProvider>()?.ShowNotification(...)` 形态随源（通知渠道 GUID 已由 p1-04 换新，引用面一致） |
| D2 | AdvancedShutdownAction 构造函数 | 主构造函数改经典构造函数：静态取消路径（`CancelPlanOnAppStopping`）无法访问主构造函数参数，构造时缓存静态 logger（可观测性适配；DI 解析形态不变） |
| D3 | 静态取消路径顺序 | 源先无条件杀本地倒计时进程再 Interlocked 判重；新实现无本地进程，Interlocked 判重后按 `!isSessionEnding` 执行 /a（源 TryAbortSystemShutdown 的位置语义保留） |
| D4 | 项 49 Process 释放 | 源 :103 `Process.GetCurrentProcess()` 未释放 → `using` 逐周期释放（防御性资源适配） |
| D5 | 项 49 日志字段 | 清理成功日志追加 `WorkingSetTrimmed` 布尔字段（06-49「记录指标」留痕面；其余文案随源） |
| D6 | B8/B9/B10 零通知随源 | 源无设置（ActionBase 非泛型）→ 无 NotifyOnExecute 通知面，仅日志；失败经 U4 Toast（源为 throw，按 06-41/42/43 改正常返回） |
| D7 | B10 同步调用语义 | 源 rundll32 电源调用为同步语义（进程到唤醒才返回）→ 执行器有界等待 1500ms：超时返回 -2，行动按「已发起、未阻塞确认」记日志，不发失败提示、不伪造成功通知（U4 不做未经确认的成功宣称）；启动失败(-1)与非零退出码 → Toast |
| D8 | 执行器返回约定 | Run* 返回 int：-1=启动失败；-2=有界等待超时（未确认）；否则进程退出码（0=命令已接受）；Is*Available 为命令文件存在性预检（不触发任何电源动作，满足 06-41「预检不得实际触发重启」） |

---

## 3. U4 预检 + IDesktopToastService 降级链路说明（全族统一）

```
OnInvoke
 ├─ U4 预检 1：OperatingSystem.IsWindows()        —— 运行时 OS 预检（04-spec:76 注明形态）
 │    └─ 否 → Toast「<功能名>在当前平台不可用，已跳过执行」→ await base.OnInvoke() 正常结束（不抛异常）
 ├─ U4 预检 2：SystemPowerCommand.Is*Available()  —— 命令文件存在性预检（不触发电源动作）
 │    └─ 否 → Toast「…命令不可用，已跳过执行」→ 正常结束
 ├─ 执行：SystemPowerCommand.Run*()（退出码判定，不以进程启动即视为成功，06-40/43）
 │    ├─ 0     → 成功路径：随源日志 + NotifyOnExecute 成功通知（有设置对者）
 │    └─ 非 0  → Toast「…未执行/未生效」+ 日志 → 正常结束（B6 另按 1116 区分无计划）
 └─ B5 特有：计划/延长前先 /a 清旧计划（A3）；重计划失败 → 撤销本地计划+回收窗口+Toast（A7）
```

- 降级通知载体：`ClassIsland.Platforms.Abstraction.PlatformServices.DesktopToastService.ShowToastAsync(string, string)`——**双分支 PRESENT**（p2-05 §4：U3 本地检出 `Services\IDesktopToastService.cs:23` + NuGet 2.1.1.1 包二进制均含），p1-04 `ShowToastAction` 同消费面先例；Toast 自身异常仅记日志（不因降级通知失败再抛错）。
- 「正常结束行动」语义：U4 降级分支统一 `await base.OnInvoke()` 后返回（06 统一要求「记录失败并正常结束行动，不抛未处理异常」）；B4 参数预校验（Settings==null / Seconds<0）保留源形态裸 return（源既有行为，非 U4 路径）。
- 项 49 降级分支（06-49 三选一）：采用「不可用时只跳过工作集操作并保留 GC/测量」——30 秒周期服务不周期性 Toast，修剪不可用经 `WorkingSetTrimmed=False` 日志留痕（裁决 3 口径）。
- 非 Windows 分支实现边界：Linux/macOS per-OS 命令策略（logind/osascript/pmset）为 06 记录面要求，不在本批实现范围（裁决 1：非 Windows 一律 U4 降级口径）。

---

## 4. macOS 五列自检表（10/10 通过）

| 落点项 | macOS 运行时行为（U4 降级口径） | 门禁符号载体 | 跨 TFM 编译闭合 | 结论 |
| --- | --- | --- | --- | --- |
| B4 计时关机 | OS 预检失败 → Toast 降级 → 正常结束 | 行动壳零命中；命令启动在条件文件 guard 内 | Round-N error=0 | ✅ |
| B5 高级计时关机 | 同上（不显示对话框、不计划） | 同上 + 看门狗/固定进程名检查已移除 | Round-N error=0 | ✅ |
| B6 取消关机计划 | 同上 | 同上 | Round-N error=0 | ✅ |
| B7 锁定屏幕 | 同上 | 同上 | Round-N error=0 | ✅ |
| B8 立即重启 | 同上 | 同上（源 ntdll/ExitWindowsEx 未随入） | Round-N error=0 | ✅ |
| B9 立即关机 | 同上 | 同上 | Round-N error=0 | ✅ |
| B10 睡眠 | 同上 | 同上 | Round-N error=0 | ✅ |
| 项 49 内存 GC | 阈值测量+托管 GC 链**正常执行**（三平台功能面）；工作集修剪 no-op（TryTrimWorkingSet=false 留痕于日志） | 互操作声明+调用在条件文件 guard 内（CONDITIONAL 2 处）；服务本体零命中 | Round-W/N 均 error=0 | ✅ |
| 两对话框 | 纯 Avalonia + MyWindow（宿主双分支 PRESENT），无平台条件面；仅 B5 在 Windows 达成预检后可达 | axaml 不属扫描 Source 面（人工核对零禁用符号，§5-4）；.axaml.cs 零命中 | Round-N error=0 | ✅ |
| 两设置对 | 纯 Avalonia 代码构造控件，无平台条件面 | 零命中 | Round-N error=0 | ✅ |

零裸 Windows API：非条件文件（17/21 .cs）零 §S4.2 门禁符号命中（§5 ZERO-HIT 清单）；条件文件 2 个的命中全部处于正向 guard 内（CONDITIONAL，非门禁）。

---

## 5. S4.2 扫描留证（p0-07 扫描器 R-2 版）

### 5.1 批级扫描结果（TEMP 镜像 21 个交付 .cs 字节复制，SHA256 留证于输出文件头）

| 指标 | 值 |
| --- | --- |
| SourceFiles | 21（= 本批全部交付 .cs；另 2 个 .axaml 不属 Source 面） |
| GateHits | **0** |
| ConditionalHits | **10**（R-2 非门禁） |
| InfoHits / CommentOnly | 0 / 0 |
| VERDICT | **PASS (zero gate hits) [CONDITIONAL=10 R-2]** |
| 退出码 | **0**（微修后直跑复核：单文件直扫直调无 `[exit code]` 非零标记，进程以 0 退出） |

- **guard 符号统一微修后复跑留证（尚书省微修指令）**：guard `#if PLATFORMS_WINDOWS` → `#if Platforms_Windows`（编译生效符号）后全量复跑——两条件文件单文件直扫 CONDITIONAL 计数不变（8+2=10）、GateHits=0、PASS；批级镜像重扫同表结果（GateHits=0/CONDITIONAL=10/PASS）；扫描器 `-match` 大小写不敏感，R-2 形态 a 识别不受大小写影响，扫描器零改动。

### 5.2 CONDITIONAL 逐文件清单（R-2 口径，供门下省终检对照 06 已声明 Windows-专属项）

| 文件 | 规则 | 逐行命中（均处于正向 `#if Platforms_Windows` guard 内） |
| --- | --- | --- |
| `Actions\SystemPowerCommandWindows.cs` | R21 ×5（:48/:56/:60/:64/:68）+ R17 ×3（:50/:72/:77） | 6 个 Run*/Is* 方法内的系统命令文件名字符串——即裁决 1 命令族与随源 rundll32 形态的声明落点 |
| `Services\ProcessMemoryMaintenanceNativeWindows.cs` | R13 ×1 + X04 ×1（均 :25） | psapi 工作集修剪互操作声明（源 :22-23 随源承载） |

- guard 外零命中、#else 分支零命中、非两形态文件零内部 guard 命中（R-2 从严条款逐项满足；`#if !Platforms_Windows` 取反存根文件内零符号，无从严命中）。
- 完整原始输出：`evidence\p2-01-s42-scan-output.txt`（runsprise 内捕获留档 + 直跑输出本节）。复核重放：
  `pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path src\SystemTools.CrossPlatform\Actions -Scope Source`（注意：Actions\ 为共享容器，含他批文件；本批口径为 21 文件镜像扫描，镜像与清理见 §10）。
- 本会话沙箱禁嵌套 `pwsh -File`（p1-02/p0-07 同款环境边界），扫描经进程内子 runspace 调用执行（扫描器语义/规则/退出码零改动）；直跑复核证明 exit=0。
- 注：`SystemPowerCommandWindows.cs` 与 `ProcessMemoryMaintenanceNativeWindows.cs` 亦列入 ZERO-HIT 区（其 guard 内命中计 CONDITIONAL 不计 GateHits，R-2 §11.2 落地语义）。

### 5.3 axaml 人工核对

2 个对话框 .axaml 不属扫描器 Source 面（.cs/.csproj/.yml/.yaml，p0-07 §2.1）：人工核对零 §S4.2 禁用符号（内容为 MyWindow/FluentIcon/IconText/动态资源引用，与源逐行同构，仅 x:Class 改写）。

---

## 6. Roslyn 批级自检留证（双向符号验证，派工约束 4）

| 轮次 | 预处理符号 | 语法树 | error | warning | 判定 |
| --- | --- | --- | ---: | ---: | --- |
| Round-W（Windows 路径） | `Platforms_Windows`（编译生效符号，宿主 props 注入） | 26 | **0** | 109 | COMPILE OK——条件实现（命令族 + psapi 互操作）语义级通过 |
| Round-N（no-op 路径） | （无） | 26 | **0** | 109 | COMPILE OK——条件存根路径语义级通过 |
| 总判定 | — | — | — | — | **PASS**：双向符号验证通过（定义 Platforms_Windows=Windows 路径通过、不定义=no-op 路径通过） |

- 方法：进程内 Roslyn 5.6（每文件独立 SyntaxTree，LanguageVersion=Latest，Nullable=Enable），引用 .NET 10.0.10 共享框架 + 宿主同版本链 237 DLL（p1-02/p1-03 同源方法）；隐式全局 using 树 7 项（p1-02 CS0104 升级法）。
- 范围：本批 21 个交付 .cs + 4 个跨批只读引用（ShortcutKeyNotificationSettings / MainConfigHandler / ButtonRulesetConfig / RowRulesetConfig）+ GlobalConstants + 1 个检查专用存根（SystemToolsNotificationProvider : NotificationProviderBase，ShowNotification 来自基类真实 SDK 面——p1-03 同法）。
- warning 明细：CS1701 ×105/轮（FluentAvalonia→Avalonia 12.1.1 程序集版本统一提示，p1-02 同款非缺陷）+ CS0169/CS0414 ×4/轮（全部位于跨批 p1-03 的 ButtonRulesetConfig/RowRulesetConfig——其 MVVM 生成成员由真实构建源生成器产出，独立编译语境下字段呈未使用，p1-03 §5 同现象）——**本批 21 文件零诊断**。
- 脚本/输出：`evidence\p2-01-supplementary-compile-check.ps1` / `p2-01-supplementary-compile-check-output.txt`。官方三平台构建门禁仍属阶段级验证（尚书省/工部职权）。

---

## 7. 共享类型增补留痕与引用

| 项 | 内容 |
| --- | --- |
| MainConfigData 增补（裁决 3 预批） | `AutoCleanupClassIslandMemory`（JSON `autoCleanupClassIslandMemory`，默认 false，INPC 相同值跳过+PropertyChanged 逐行随源，源 :187-199）；独立增补段（头尾 `===== p2-01 增补开始/结束 =====` 界标）插于 p2-02 与 p2-03 段之间，含消费点与注册顺序注记（p2-05 §2.1 #10：ApplyConfig 调用须在 GlobalConstants.MainConfig 赋值之后，源 Plugin.cs:70/:218 先例）。落地后核验：段界标与成员均在位（并行批增补段零触碰） |
| 共享 ShortcutKeyNotificationSettings(+Control) | B6/B7 仅引用不复制（裁决 4；p1-03 共享交付零改动，Roslyn 自检以只读引用纳入编译闭合） |
| GlobalConstants | 零增补（消费面仅经 `GlobalConstants.MainConfig?.Data` 既有句柄，随源 :27） |

---

## 8. 注册面交接清单（→ 礼部，p1-05 §4.2 形态；源 Plugin.cs 只读先例）

| 类别 | 交接内容 | 源锚点 |
| --- | --- | --- |
| 行动注册 ×7 | `RegisterActionIfEnabled<ShutdownAction, ShutdownSettingsControl>(…, "SystemTools.CrossPlatform.Shutdown")`；`<AdvancedShutdownAction, AdvancedShutdownSettingsControl>(…, "SystemTools.CrossPlatform.AdvancedShutdown")`；`<LockScreenAction, ShortcutKeyNotificationSettingsControl>(…, "SystemTools.CrossPlatform.LockScreen")`；`<CancelShutdownAction, ShortcutKeyNotificationSettingsControl>(…, "SystemTools.CrossPlatform.CancelShutdown")`；`<ImmediateRestartAction>(…, "SystemTools.CrossPlatform.ImmediateRestart")`；`<ImmediateShutdownAction>(…, "SystemTools.CrossPlatform.ImmediateShutdown")`；`<SleepAction>(…, "SystemTools.CrossPlatform.Sleep")`（B8–B10 单参形态） | :375–:382 |
| 行动菜单树 | 「电源选项…」组（`\uEDE8`）+ 7 个 ActionMenuTreeItem（ID/名称/图标随源，ID 前缀 SystemTools.CrossPlatform.*） | :641–:644/:805–:821 |
| DI 注册（新增对） | `AddSingleton<IProcessMemoryMaintenanceService, ProcessMemoryMaintenanceService>()`（新增，须在内存清理服务注册之前）；`AddSingleton<ClassIslandMemoryAutoCleanupService>()`（服务构造函数新增第二参数 `IProcessMemoryMaintenanceService`） | :122 |
| 初始化 | `IAppHost.GetService<ClassIslandMemoryAutoCleanupService>().ApplyConfig();`（须在 GlobalConstants.MainConfig 赋值之后，p2-05 §2.1 #10） | :218 |
| 停止 | `IAppHost.GetService<ClassIslandMemoryAutoCleanupService>().Stop();` | :1045 |
| 生命周期接线 | `AdvancedShutdownAction.CancelPlanOnAppStopping(isSessionEnding)`（bool 来源=AppStopping 上下文；Windows 会话结束事件面由 p2-03 SystemShutdownMonitor 承接，本方法仅收 bool） | :1034–:1035/:1048 |

---

## 9. 上报事项（不阻塞本批交付）

1. **【微修裁决后撤销】PLATFORMS_WINDOWS 编译常量接线需求**：初版曾以全大写 `PLATFORMS_WINDOWS` 为 guard 并报工部 p2-10 接线；尚书省 guard 符号统一微修裁决指出该符号在 C# 预处理大小写敏感语义下恒未定义（宿主 CrossPlatformProps.props:37 注入的编译生效符号为 `Platforms_Windows`），Windows 分支将成死代码。微修已执行：两条件文件正向 guard 及两存根取反 guard 统一改用 `Platforms_Windows`（§11 修订 2），**无需任何 csproj DefineConstants 接线**，原上报事项撤销；Roslyn Round-W（定义 Platforms_Windows）error=0 即 props 注入现态下 Windows 路径生效的直接证据。
2. **新造文件名备案（p1-05 §3.4-4，6 个，§1.3）**：R-2 条件文件约定要求 `*Windows.cs` 命名/全文件包裹，故执行器与适配器文件名带平台后缀而共享类型名居内（`SystemPowerCommand` / `ProcessMemoryMaintenanceNative`）；`IProcessMemoryMaintenanceService`/`ProcessMemoryMaintenanceService`/`SystemPowerCommandStub`/`ProcessMemoryMaintenanceNativeNoOp` 为成对条件文件的跨 TFM 编译闭合面。报尚书省备案。
3. **06 表述偏差注记（裁决 2）**：06 条目 37–43 所名 `ISystemPowerService` 宿主接口双分支 ABSENT（p2-05 §4），电源执行器按插件本地实现落地（`SystemTools.CrossPlatform.Actions.SystemPowerCommand` 条件文件对）；项 49 的 `IProcessMemoryMaintenanceService` 同为插件本地抽象（接口文件注明「非宿主 API」）。证据登记「06 表述按本地实现落地」。
4. **B8 替代口径差异留痕**：06-41 替换目标写 `shutdown.exe /r /t 0`，本批按尚书省裁决 1 执行 `/g /t 0`（/g=重启并重新注册应用，/r=完整重启；均满足「立即重启」能力），以裁决为准（§2-A2）。
5. **并行批共存**：MainConfigData 现含 p2-02/p2-03 增补段（本批执行期间已落盘）；本批段独立界标插入，三方互斥零冲突；后续批重写该文件时须保留既有段。

---

## 10. 边界声明与复核指引

- 本批写入：`src\SystemTools.CrossPlatform` 下——Actions 9 文件（7 行动 + 执行器对）、Services 6 文件（GC 服务 + 维护抽象 3 件 + 条件对 2 件中 2 件已计前述……即 §1 全表 23 个交付文件）+ `ConfigHandlers\MainConfigData.cs`（仅预批段）。evidence/ 下 4 文件（本报告、扫描输出、编译自检脚本、编译自检输出）。
- TEMP 区：扫描镜像目录 `…\Temp\dsh-*\p2-01-s42-mirror`（21 .cs 字节复制 + SHA256 留证）**测毕已删除**（复核 False）。
- 零改动：Plugin.cs、manifest.yml、SystemTools.CrossPlatform.csproj、global.json、.slnx、源插件检出（只读）、宿主检出（只读）、p1-06 设置页、其他批文件（p2-02/p2-03 增补段零触碰）。
- 复核重放：① 扫描=§5.1 重放命令（或按本报告 SHA256 重建镜像后批扫）；② Roslyn=`pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p2-01-supplementary-compile-check.ps1`（退出码 0=双向 PASS）；③ 逐项源锚点核对=§1 表 file:line 对照源插件只读检出；④ 守卫位置校正核对=读源 `Services\ClassIslandMemoryAutoCleanupService.cs:94-126` 与新 `TryCleanupOnce()` 对照。
- 本文件不推进、不审批全局工作流；仅向尚书省回报本批结果，门下省终验。

## 11. 修订记录

- 初版（p2-01 重派执行交付；前次派工零产出中断，无先前版本）。
- 修订 2（尚书省 guard 符号统一微修裁决）：4 处 guard 行统一 `#if Platforms_Windows` / `#if !Platforms_Windows`（两条件实现文件 + 两存根取反对称面，防 Windows TFM CS0101 重复定义），文件头注记同步（R-2 口径按编译生效符号统一说明，扫描器 -match 大小写不敏感、口径不变）；复跑两条件文件单文件直扫（CONDITIONAL 8/2 不变、GateHits=0、PASS）+ 批级镜像重扫（GateHits=0/CONDITIONAL=10/PASS/直跑 exit=0）+ Roslyn 双向重跑（Round-W 定义 Platforms_Windows error=0、Round-N error=0）；§1.3/§5/§6/§9 同步更新，原上报事项 1（p2-10 接线需求）撤销。新增注记：`ProcessMemoryMaintenanceService.cs:12` 注释仍保留旧符号文本的文档性残留（微修边界仅授权两条件文件+证据，未触碰；语义以两条件文件实际 guard 为准，建议后续批顺手订正）。
