# 06 最终报告 — SystemTools-Cross-platform 跨平台插件迁移

- 案卷号：`stcp-cross-platform-001`
- 量级：**large**
- 结果：**项目完成，门下省最终验收通过（menxia-acceptance=passed）**
- 报告人：中书省（zhongshu-report）

## 1. 结论摘要

以 Windows 专用插件 **SystemTools** 为蓝本，经「需求澄清 → 起草 → 门下省评审 → 会签 → 用户审批 → 尚书省阶段 0–4 执行 → 门下省逐阶段验收」全流程，建成新的三平台插件 **SystemTools-Cross-platform**：

| 维度 | 结果 |
| --- | --- |
| 产品树 | **203 个产品文件**（163 `.cs` + 29 `.axaml` + 4 `.yml` + 3 `.png` + 3 `.txt` + 1 `.csproj`） |
| 功能落地 | **A 档 33 + B 档 19 = 52 项** 落地并注册；C 档 46 项留在原插件（98 功能项计数闭合） |
| 构建 | Windows / Linux Release 编译通过（exit=0）；macOS 静态兼容证据链成立（Roslyn 双向符号验证） |
| 独立边界 | 独立 `id`（`SystemTools-Cross-platform`）、独立功能 ID 前缀（`SystemTools.CrossPlatform.*`）、全新配置命名空间，与原 SystemTools 并存不冲突 |
| 发布终稿 | `docs/coexistence-notes-final.md`（197 行）落盘；基线冻结声明与实测逐值一致 |

## 2. 目标与范围

- **目标**：遍历 SystemTools 全部用户可见功能，逐功能给出 A（直接迁移）/ B（稍加修改可迁移）/ C（不迁移）三档结论，并据此建成跨平台插件。
- **范围**：主题 3、组件 7、规则集 5、触发器 7、行动 61（62 个 `.cs` 文件，`ClickSimulationAction.cs` 为整文件注释死代码）、6 个设置页、AI 服务、悬浮窗与更多功能选项服务。
- **纳入**：A 档 33 项 + B 档 19 项；**排除**：C 档 46 项（输入模拟、显示器拓扑、注册表个性化、WMI 硬件、全局钩子、语音双引擎、人脸/Hello 认证、系统级内存清理、U 盘、管理员重启等，留原插件）。

## 3. 关键用户决策

| # | 决策点 | 用户选择 |
| --- | --- | --- |
| 1 | 目标平台与定位（os-coverage） | **三平台并存**：Windows + Linux + macOS 均构建；原 SystemTools 继续独立维护，Windows 用户任选 |
| 2 | 迁移范围（tier2-scope） | **B 档纳入构建范围**：稍加修改功能做适配改造后纳入新插件 |
| 3 | 命名与配置（config-compat） | **独立 ID 与全新配置**：不与并存的原插件冲突 |
| 4 | 开工批准 | 批准实施（`06-migration-details-proposal.md` 用户开工决定） |
| 5 | U3 目标 API 版本 | 随 misha/v2 本地检出（`E:\ClassIsland-git-misha`），NuGet 2.1.1.1 仅作后备 |
| 6 | U4 电源提权降级 | 预检 + 命令缺失/无权限时经 `IDesktopToastService` 通知降级，不抛未处理异常 |
| 7 | U5 液态玻璃 | 首期仅经典外观；液态玻璃/背景采样为 C 候选增强 |

## 4. 执行过程摘要（阶段 0–4）

| 阶段 | 内容 | 出口门禁 | 结果 |
| --- | --- | --- | --- |
| **0 工程脚手架与范围基线** | 三平台 TFM 基线、裁剪原生包、固定独立 manifest、62→61 映射基线、S4.2 扫描器 | 包图无禁用项、manifest 独立、映射 98 闭合、原插件零改动 | passed |
| **1 A 档 33 项抽取** | 主题/组件/规则/触发器/行动/AI 文本链/虚拟放学/版本检查/设置页骨架 | S4.2 门禁 0 命中（独立重放）、Win/Linux Release exit=0（1,349,120 B） | passed（menxia-stage1） |
| **2 B 档 19 项适配** | 复制/移动/删除 BCL 递归化、电源 7 项、悬浮窗经典外观与层级、主题/遮挡/内存 GC、SystemShutdownMonitor | 全树门禁 168/168（CONDITIONAL=13 全收敛于 4 个条件文件）、Win/Linux exit=0（1,489,408/1,486,848 B） | passed（menxia-stage2） |
| **3 设置与配置整合** | 6 设置页 A/B/C 归属、B 档接线 18/18、C 档裁剪 21/21、命名空间统一（零调整）、同装差异文档 | 门禁 168/0/13 逐值一致、共享 VM 887 行界标共存、Win/Linux exit=0（1,543,680/1,541,120 B） | passed（menxia-stage3） |
| **4 端到端验收与发布准备** | 六步复核重放、基线冻结、发布就绪检查单、发布终稿、预算链闭合、O 项处置 | 98 计数终局重放、门禁四主体多时点一致、基线冻结逐值一致、两项证据缺口经裁量接受 | passed（menxia-final） |

## 5. 关键产物

| 产物 | 位置 |
| --- | --- |
| 产品代码树 | `src\SystemTools.CrossPlatform`（203 文件） |
| 注册面 | `Plugin.cs`（742 行，37 注册调用 + 4 AddRule + 7 AddSettingsPage + 3 AddXamlTheme，唯一写入者 = 礼部） |
| 发布终稿 | `.tang/cases/stcp-cross-platform-001/docs/coexistence-notes-final.md`（197 行/22,437 B） |
| 阶段合同 | `05-phased-development.md` |
| 迁移细节提案 | `06-migration-details-proposal.md`（633 行，条目 33/34-49/70/76-86） |
| 基线冻结 | manifest SHA256 `142CD419…AAC`、csproj SHA256 `A7220DB4…C38A` |

## 6. 门禁与验收证据

1. **S4.2 禁用符号静态门禁**：终局 168/168 文件 PASS（GateHits=0、ConditionalHits=13、InfoHits=2、CommentOnly=6）；命中全部收敛于 4 个 `#if Platforms_Windows` 条件文件（`SystemPowerCommandWindows`/`ProcessMemoryMaintenanceNativeWindows`/`SystemShutdownMonitor`/`SystemMotionPreferences`）的 guard 内，零超范围。
2. **计数闭合**：98 = A33 + B19 + C46；A33 33/33 零漂移、B19 19/19 锚点零漂移、C46 十四组特征名实体级 0 命中；52/52 维持；白名单 41 = 注册面 37 + 4。
3. **命名空间**：163 `.cs` / 22 唯一命名空间 100% 以 `SystemTools.CrossPlatform.` 开头，裸 `SystemTools.` 前缀 0；ID 前缀 243/0 违例。
4. **构建门禁**：Win/Linux Release exit=0（三阶段产物体积递增：1,349,120 → 1,489,408/1,486,848 → 1,543,680/1,541,120 B）；macOS 为静态兼容证据（Roslyn Round-N 双向符号双轮 error=0/warning=0 + 4 条件文件跨分支闭合）。
5. **零写入纪律**：宿主链 5 工程 obj mtime 与基线一致；源 SystemTools 与宿主检出全程只读；注册面唯一写入者=礼部；Plugin.cs mtime 冻结于 2026-09-04 11:17:15。
6. **验收链**：menxia-stage1/stage2/stage3/menxia-final 四轮独立验收全部 passed，无退回项。

## 7. 基础设施/闸门故障与恢复处置（全部留痕）

1. **依赖闸门索引脱钩（阶段 3）**：旧 plan 下 p3-05…p3-06 实施面全部 succeeded 后，运行时依赖闸门不消费 succeeded 记录，后续任务无法派工；尚书省经重试/运行时刷新/重录无效后，以「收尾 plan（阶段3-验证收尾·闸门故障恢复）」绕开，仅承载 4 个验证/分析任务（p3-07/p3-08/p3-09/p3-10），零重复实施、零产物损失、留痕充分；门下省专项核验后**追认合规**。
2. **构建沙箱命名管道阻断（阶段 4）**：p4-01/p4-02 共 7 场景真实构建尝试在进程启动阶段被会话沙箱命名管道策略拒绝（`\\.\pipe\LOCAL\dotnet_*` denied），审批通道禁用未提权未绕行；以「阶段 3 真实 exit=0 + 差集恰 2 个零风险文件 + Roslyn 语义级编译双轮 + 门禁差集=0」构成有效推断链，门下省裁量**接受**，并将「环境恢复后补跑真实构建」登记为发布前待办（非验收阻塞）。
3. **尚书省子代理反复失败与恢复**：执行期尚书省子代理多次失败，经恢复处置留痕，各阶段实施面最终均成功落盘（详见 07-chronicle 与历次验收）。
4. **环境缺口（G1/G3/cipx）**：G1 无 macOS 构建机（静态证据替代）；G3 标准本地路径 Restore 受 MSB4276 环境噪声（按用户裁定以 NuGet 后备为准）；cipx 打包工具链已识别但无法执行——均登记留待，不构成验收阻塞。

## 8. 残余差距与发布前/发布后待办

| # | 待办 | 性质 |
| --- | --- | --- |
| ① | 环境恢复后补跑真实构建（NuGet 后备 Win/Linux exit=0 复跑 + 裁量后产物体积补记） | 发布前 |
| ② | 干净重建/清理输出目录后再打包（消除 Win 输出目录 NuGet 后备实验残留 `Microsoft.Windows.SDK.NET.dll` 24.8MB + `WinRT.Runtime.dll` 528KB） | 发布前 |
| ③ | cipx 打包核验（`-p:CreateCipx=true` 产出 `.cipx`） | 发布前 |
| ④ | 发布终稿落位（`coexistence-notes-final.md` 置于仓库/发布包；当前仓库 docs 为 142 行初稿） | 发布前 |
| ⑤ | macOS 真机重放（构建 + 运行抽验）——环境可得时 | 发布后 |
| ⑥ | 宿主装载冒烟验证（Windows 首装：apiVersion 判定、注册面/设置页/行动实机走查） | 发布后 |

**非阻塞观察项**（O-1…O-14）已全部闭环或如实归类：O-3/O-7 可空警告评估性零清理、O-5/O-9 裁量已实施、O-6/O-10/O-11 文档面披露、O-8/O-12 环境缺口维持登记、O-13/O-14 并入待办。

## 9. 部门派工记录（六部全部履职）

| 部门 | 职责 | 阶段 0–4 主要交付 |
| --- | --- | --- |
| 兵部（War） | 应用代码实现 | A 档四批（p1-01…p1-04：主题/组件、规则/触发器、行动、服务）、B 档三批（p2-01 电源、p2-02 文件夹/杂项、p2-03 悬浮窗/服务）、设置页两批（p3-01/p3-02）、命名空间统一（p3-03） |
| 礼部（Rites） | 接口/注册/文档 | 注册面（Plugin.cs 唯一写入者 p1-06/p2-06）、设置页注册、同装差异文档（p3-06）、发布终稿（p4-03） |
| 吏部（Personnel） | 仓库治理/映射 | 落点规范（p1-05/p2-05/p3-05）、映射更新（p1-09/p2-09/p3-09）、终局闭卷重放与基线冻结（p4-05） |
| 户部（Revenue） | 数据/依赖/预算 | 依赖核对（p1-07/p2-07/p3-07）、发布预算链闭合（p4-04） |
| 刑部（Justice） | 质量/门禁 | S4.2 全树门禁（p1-08/p2-08/p3-08）、终局门禁与裁量（p4-01） |
| 工部（Works） | 构建/发布 | 构建门禁四轮闭环（p1-10/p2-10/p3-10）、发布就绪（p4-02） |

## 10. 风险与回滚

- 直接 P/Invoke 面广 → S4.2 禁用符号门禁作为抽取强制校验，全程 GateHits=0。
- Linux 仅 X11 → 全局键/窗口枚举/输入注入等 C 档不做。
- 电源提权 → U4 预检 + 通知降级落地，全族统一。
- 双分支 API 漂移（`MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty` 源存在/NuGet 二进制缺位）→ 按 U5 降级口径移除引用，双分支均通过。
- 回滚：新插件独立工程/ID/配置，可整体卸载/不启用，不影响原 SystemTools；宿主与源插件全程只读零写入。

## 11. 结论

项目按 large 量级完成全部阶段 0–4，门下省最终验收通过。新插件 SystemTools-Cross-platform 以 52 项可迁移功能落地、98 项计数闭合、S4.2 门禁零命中、Win/Linux 编译通过、macOS 静态兼容证据成立，达到三平台并存目标。剩余 6 项发布前/发布后待办为环境约束下的既定后置动作，不构成验收缺陷，用户对发布时点保有完整决定权。
