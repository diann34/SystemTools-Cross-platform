# 门下省阶段 2 验收结论 — B 档 19 项适配（案卷 stcp-cross-platform-001）

- 验收方：门下省（menxia-acceptance，独立复核；关键门禁独立重放，不依赖尚书省上报自证）
- 验收对象：阶段 2（B 档 19 项适配）全部产出；不评价阶段 3 规划
- 权威依据：`04-spec.md` §S4.2/U4/U5/R-6、`05-phased-development.md` 阶段 2 行、`06-migration-details-proposal.md` 条目 34–49 与 U4/U5 决议
- 输入工件：evidence/ p2-05…p2-10 全部证据、`src\SystemTools.CrossPlatform`（203 产品文件、Plugin.cs 742 行）
- **结论：通过（passed）**——六项验收要点全部独立复核成立，零超范围 CONDITIONAL，无退回项；非阻塞观察 4 项登记于 §8。

---

## 1. 要点一：B19 19/19 落地注册（独立复核 ✓）

门下省以 `p0-03 §3.2` B 清单与 06 条目 34–49 为基准，对 Plugin.cs（742 行）与文件树全量清点：

| 组 | 项 | 实测注册（Plugin.cs 行号独立读取） |
| --- | --- | --- |
| 行动 14 | B1–B3 复制/移动/删除 | `:289-291`（R-1 三项，BCL 递归化落地） |
| | B4–B10 电源族 7 | `:276/278/282/280/284/285/286`（B6/B7 共享 `ShortcutKeyNotificationSettingsControl` 仅引用零复制随源；B8–B10 单参随源） |
| | B11/B12 显示悬浮窗/切换层级 | `:303-306`，处于 `EnableFloatingWindowFeature` 源形态门内（p1-06 §9-4 报备恢复点兑现，p2-06 §4-1 恢复） |
| | B13/B14 自动切换主题/遮挡隐藏 | `:336-339` |
| 触发器 1 | 从悬浮窗触发 | `:364-365` `RegisterTriggerIfEnabled<FloatingWindowTrigger,…>`（触发器 2 = A1 + B1） |
| 服务 4 | 悬浮窗服务/主题同步/遮挡/内存 GC | `:127/:128/:129/:130-131` 类型 DI（内存 GC 经 `IProcessMemoryMaintenanceService` 接口注入承载方案 B）+ 生命周期 `:199-206/:230-234` 全接线 |
| **合计** | **19** | 14+1+4，与 p2-06 §2.7 闭合声明、p2-05 §1.3-6 分批口径（8+7+4）、p2-09 §1 逐项映射一致 |

注册面机器口径三方一致：37 注册调用 = 行动 29（A15+B14）+ 组件 6 + 触发器 2，37 唯一 ID、零重复、零非前缀（p2-06 §2.5 / p2-08 §7 / p2-09 §5-6；门下省阶段 1 建立的 30 唯一 ID 基线 + 本阶段 15 个 B 档 ID 闭合为 45，p2-08 §7-3）。06 条目 34–49（16 条目）↔ 19 功能项的携带关系（44 携悬浮窗服务面、47 携主题同步服务、48 携遮挡服务、49 为服务本身）逐条可溯。菜单组恢复（悬浮窗组/电源选项组/文件操作组/更多功能选项组，含尚书省微修 1）属注册面组织、不占计数，形态随源。

## 2. 要点二：全树 168/168 R-2 门禁独立抽核（✓ 零超范围）

1. **独立重放**：门下省 grep 重放禁用符号集合（`Windows.Win32|PInvoke.|System.Windows.Forms|Microsoft.Win32|System.Management|System.Speech|Windows.Media|Windows.Security|DllImport|LibraryImport`）→ 仅 3 个文件 4 处命中行，**全部落在 4 个条件文件内**（`SystemMotionPreferences.cs:41`、`ProcessMemoryMaintenanceNativeWindows.cs:25`、`SystemShutdownMonitor.cs:5`）；进程名类命中（shutdown.exe/rundll32.exe）按扫描器 R21/R17 规则独立核对，全部位于 `SystemPowerCommandWindows.cs` 单一条件文件。
2. **CONDITIONAL=13 逐条对应**：SystemPowerCommandWindows 8（R21×5 + R17×3，对应 06 条目 37–43 明示命令族 + U4 预检）+ ProcessMemoryMaintenanceNativeWindows 2（R13+X04 同行，06 条目 49 明示 psapi EmptyWorkingSet）+ SystemShutdownMonitor 1（R03，授权链见 §4-①）+ SystemMotionPreferences 2（R13+X04，04-spec §S4.2:76 点名允许项）。门下省抽验关键命中行（`/s /t`、`/g /t 0`、`/a`、`LockWorkStation`、`SetSuspendState 0,1,0`、`psapi.dll`、`System.Windows.Forms`）与 06 明示项/裁决留痕逐一对应，**零超范围**。
3. **基线回归**：168 = 119（阶段 1 基线，119/119 零回退）+ 49（p2-01 20 + p2-02 17 + p2-03 12），精确闭合；五批自检一致性零分歧（p2-08 §5.3）；扫描器字节未动（R-2 版零改动使用）。
4. **C46 零提前迁入反向核对**（p2-09 §3）：14 组 C 档特征名全树检索，11 行非零命中全部为注记留痕/合法 B 档面/命名近似不同实体，逐条引证豁免口径——无未申报迁入。

## 3. 要点三：条件文件 4 个 guard 与降级语义（方案 B 落地 ✓）

1. **guard 形态独立读取确证**：`SystemPowerCommandWindows.cs:1/:110` 全文件裸 `#if Platforms_Windows` 包裹 + `*Windows.cs` 命名（双形态合格）；`SystemPowerCommandStub.cs` `#if !Platforms_Windows` 反面存根零符号（防 CS0101）；`ProcessMemoryMaintenanceNativeWindows.cs:1/:46` + `ProcessMemoryMaintenanceNativeNoOp.cs` 取反存根；`SystemShutdownMonitor.cs:1→:135` 全包裹、`:100 #else` no-op 分支（`IsSessionEnding` 恒 false）；`SystemMotionPreferences.cs` 同形态。guard 符号统一为编译生效的 `Platforms_Windows`（R-2a 勘误：全大写符号恒未定义属死代码形态；p2-01 修订 2 报备 + p2-08 §6.1 经授权注释一词订正 + 复扫零影响留证）。
2. **真实双分支编译覆盖（强于静态检查）**：Win TFM `/define:…Platforms_Windows…` 编译 Windows 分支、Linux TFM `/define:…Platforms_Linux…`（无 Platforms_Windows）编译 `#else`/存根分支，两构建均 exit=0（p2-10 §2.3/§2.4/§2.5）——条件文件跨 TFM 闭合由真实构建证明，非仅扫描推断。
3. **U4 降级链路全族统一**（p2-01 §3）：OS 预检（`OperatingSystem.IsWindows()`，04-spec:76 允许形态且文件头注明）→ 命令存在性预检（`Is*Available`，不触发动作）→ 执行（有界等待，-1 失败/-2 超时/退出码）→ 失败/超时经 `IDesktopToastService` 通知（双分支 PRESENT，p2-05 §4 字节检索）+ 正常结束行动不抛未处理异常；B10 超时「已发起、未阻塞确认」不伪造成功；项 49 采用「不可用时只跳过工作集、保留 GC/测量」三选一口径（裁决 3）；非 Windows per-OS 命令策略（logind/osascript/pmset）按裁决 1 属 06 记录面，本期一律 U4 降级——与 04-spec S4.4-U4 默认值一致。
4. **U5/R-6 口径维持**：液态玻璃/背景采样族零迁入；SystemShutdownMonitor/SystemMotionPreferences 的 macOS 分支 no-op 属已批降级写实（p2-10 §3.1 注）。

## 4. 要点四：偏差注记与留痕/不迁面核验（✓ 全部合规）

| # | 事项 | 门下省核验结论 |
| --- | --- | --- |
| ① | **条目 46 编号笔误（SystemShutdownMonitor 授权链）** | 06 文档条目 46 实为「从悬浮窗触发」，全文无 SystemShutdownMonitor 字样；该文件 Windows 会话消息路径的真实授权链 = **p2-05 §1.2（非计数附属 1，明示 WinForms 面 + S3-R4/G2 no-op 降级分支）+ p0-07 §11.1 R-2 裁定点名**，功能语义服务 06 条目 38 看门狗替换（已实接线：`ShutdownRequested → MarkIfOsShutdown`，p2-06 §3-W7）。刑部定性「引用级偏差、非超范围」**成立**；条件文件用途在授权范围内，留证处置（不改写既有证据文本）合规。产品注释同源笔误见 §8 O-5 |
| ② | **B8 `/g` vs `/r` 差异** | 06-41 表述 `/r /t 0`，实现按尚书省裁决 1 执行 `/g /t 0`（/g=重启并重新注册应用），能力等价；差异在 p2-01 §2-A2 + §9-4 双处留痕，以裁决为准——**合规**（裁决属授权范围） |
| ③ | **托盘菜单面不迁**（源 `:1081-1169`） | 不在三批交接 W1–W13 内，p2-06 §10-3 如实报备、零接线、零越界引入——**合规**（如后续需要须按 p1-05 §2.3 共享增补流程登记） |
| ④ | **信息日志面不迁**（源 `:1049-1056` 两条 info 日志） | 与 p1-06 §9-1 核减 `AddLogging` 决策一致性维持（未引入 `_logger`），`CancelPlanOnAppStopping(bool)` 调用语义完整，可观测性差异留痕——**合规** |
| ⑤ | **E-3 勘误**（p2-01 聚合计数 23 → 实测 22 文件） | 逐文件交付集完整（p2-05 §1.2 权威落点表全兑现），仅聚合计数行错记；p2-09 §4.3 以实测归账并报备——**记录级勘误，合规** |
| ⑥ | **E-4 勘误**（p1-09 TriggerInfo :18 → 实测 :20） | 记录级 2 行漂移，文件内容与 p1-02 声明形状一致、零代码改动；新基线以 :20 为准——**合规** |
| ⑦ | **W-1 锚点微漂**（批证据行号 vs 终态微差） | p2-09 §1 一律以本轮实测值为阶段 3/4 基线，行为面经各批 Roslyn/扫描/注册复核背书——**合规** |
| ⑧ | **微修 1**（文件操作/更多功能选项两组菜单补齐） | 尚书省微修指令，源形态只读直参，Plugin.cs 684→742 行，全量复跑 PASS + manifest 哈希复测同值 + 注册复核 37/37 不变——**合规** |

## 5. 要点五：证据链闭合与零写入（✓）

- 链条：p2-05（落点核对 + EmptyWorkingSet 四方案预判与尚书省裁决 + 双分支 API 面字节检索）→ p2-01（电源族 7 + 项 49，U4 链路）→ p2-02（文件夹递归 BCL 化——`Copy/Move/Delete` 零进程启动，AD5–AD7 与 06 条目 34/35/36「非 shell 拼接安全边界」达成）→ p2-03（悬浮窗域 W1–W13 + 全树 168）→ p2-06（注册 19/19 + 微修 1）→ p2-07（依赖核对：csproj 零改动 SHA256 一致、无新包）→ p2-08（R-2 首次权威全树 + 两处经授权订正 + 订正后复扫差集恰 2 行时间戳）→ p2-09（B19 19/19 + A33 零改动 29 锚点抽查 + C46 反向核对 + 98 闭合）→ p2-10（构建门禁）。
- **计数闭合**：A33（零改动冻结）+ B19（本轮）= 52 已纳，C46 零迁入，98 = A33+B19+C46 与 04-spec §S4.1 一致。
- **零写入复核**：宿主链 5 工程 obj mtime 与 p1-07/p1-10/p2-07 基线一致；manifest SHA256 `142CD419…AAC` 与 p0-05 基线逐字节一致；源插件与宿主检出全程只读；产品树写入 = 兵部三批交付面 + p2-06 注册面（唯一写入者礼部，证据级核验）+ p2-08 两处经授权注释订正（复扫零影响）。
- **结构抽核独立吻合**：Plugin.cs 742 行零 `#if`；163 .cs namespace 镜像零违规、禁用裸前缀 using 0（与门下省阶段 1 全量核验口径延续一致）。

## 6. 要点六：需退回尚书省修订的具体问题

**无。** 未发现超范围 CONDITIONAL、C 档提前迁入、A 档回退、注册缺漏/重复、门禁命中、伪报成功或证据缺口。构建门禁：NuGet 后备 Win/Linux Release 均 exit=0（产物 1,489,408 / 1,486,848 B，29 .axaml 收集 + 6 资源接线）；标准本地路径仍受 G3 环境噪声（按用户裁定口径不阻塞）；阶段 1 三类编译缺陷零复现。

## 7. 与 04-spec 契约的符合性声明

- S2.3 B 档三元组（Windows 专属点 → 替换目标 → 降级行为）：条目 34–49 逐项兑现；R-1 三项按 B 档落地（BCL 递归）。
- S4.2 门禁：B 档 Windows 专属点全部收敛于 4 个条件文件 + guard 内 13 处 CONDITIONAL，GateHits=0。
- S4.4-U4：预检 + 通知降级 + 不抛未处理异常全族落地；U5：经典外观交付、液态玻璃/采样零迁入；R-6：AI 浮窗采样面维持删除。
- S8 禁止事项：未创建 C 档依赖、未修改原插件、未越注册面唯一写入者、未预写函数级实现于证据之外。

## 8. 非阻塞观察项（登记备查，随阶段 3/4 处理）

| # | 观察 | 建议 |
| --- | --- | --- |
| O-5 | `SystemShutdownMonitor.cs:11` 产品注释仍写「按 06 条目 46」（与证据层同源的编号笔误，授权链已在 p2-08 §3.3 更正定性） | 阶段 3/4 微修时将该注释更正为 p2-05 §1.2 + R-2 授权链表述（纯注释，零功能） |
| O-6 | 06 条目 41 表述 `/r` 与实现裁决口径 `/g` 的差异已在证据双向留痕 | 阶段 4 端到端验收时在文档面同步该差异记录 |
| O-7 | 28 个 CS8602 可空警告（延续阶段 1 O-3，不影响构建） | 阶段 4 收口酌情清理 |
| O-8 | G1（macOS 真机）/G3（标准本地路径）环境缺口延续 | 维持登记，真机重放与标准路径构建留阶段 4（用户裁定口径） |

## 9. 验收判定

- **阶段 2 验收：通过（passed）。** B19 19/19 注册、R-2 全树门禁 168/168（CONDITIONAL=13 零超范围）、方案 B 条件文件与 U4/U5/R-6 降级语义合规、偏差与不迁面全部如实留痕、证据链闭合、宿主/源插件零写入。
- 本文件作为案卷阶段 2 里程碑证据；阶段 3（设置与配置整合）按 05 合同解锁。
- 门下省未改任何产品文件；本文件为本任务唯一写入。
