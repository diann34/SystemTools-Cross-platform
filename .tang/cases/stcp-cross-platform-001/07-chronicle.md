# 07 编年史（原始审计时间线）— stcp-cross-platform-001

> 本文件为案卷原始审计时间线，逐里程碑记录事件、责任部门、证据文件与状态流转；与 06-final-report.md 的结论性总结互补。事件顺序以流程先后为准，关键时点标注证据中的时间戳。

## 一、需求与方案阶段（中书省 / 门下省）

| 序 | 事件 | 责任 | 状态 | 证据 |
| --- | --- | --- | --- | --- |
| 1 | 接案：用户要求遍历 SystemTools 全部功能，分析跨平台可迁移性（明确非编码阶段） | 中书省 | intake=running | — |
| 2 | 仓库侦察：确认 ClassIsland（misha/v2）跨平台抽象层与 SystemTools 的 Windows 锁定根因（TFM/WinForms/CsWin32/WMI/SAPI/注册表/NAudio/Dlib-Vosk） | 中书省 | — | `01/02` §1 |
| 3 | 需求澄清：提出 3 项阻塞问题（os-coverage / tier2-scope / config-compat） | 中书省 | waiting_input | `tang_raise_clarification` |
| 4 | 用户答复：三平台并存 / B 档纳入 / 独立 ID 全新配置 | 用户 | — | 协调器转交 |
| 5 | 撰写需求与草案 v1（01 + 02，A≈36/B≈16/C≈47 初版） | 中书省 | requirement-clarification=succeeded, zhongshu-draft=succeeded | `01-requirements.md`、`02-draft-solution.md` |
| 6 | 门下省独立评审：large 维持，9 项修订 R-1…R-10 + U3/U4/U5 建议 | 门下省 | menxia-review=passed | `03-review.md`、`04-spec.md` |
| 7 | 中书省会签：源码重放核验全部修订，接受；修订 01/02 v2；勘误行动文件数 63→62 | 中书省 | countersign=passed | `02-draft-solution.md`（v2） |
| 8 | 用户审批门：批准实施（含 U3/U4/U5） | 用户 | user-approval=passed | `06-migration-details-proposal.md`（开工决定） |

## 二、执行阶段（尚书省 / 六部）

| 序 | 事件 | 责任 | 状态 | 证据 |
| --- | --- | --- | --- | --- |
| 9 | 阶段 0：脚手架与范围基线（三平台 TFM、包裁剪、独立 manifest、62→61 映射、S4.2 扫描器） | 尚书省 + 六部 | passed | p0-01…p0-07 |
| 10 | 阶段 1：A 档 33 项抽取（兵部四批 + 礼部注册 + 户部依赖 + 刑部门禁 + 吏部映射 + 工部构建） | 六部 | passed | p1-01…p1-10 |
| 11 | 阶段 1 验收：A33 33/33 注册、S4.2 门禁 0 命中、Win/Linux exit=0（1,349,120 B）、命名空间/GUID 合规 | 门下省 | menxia-stage1=passed | `evidence/menxia-stage1-acceptance.md` |
| 12 | 阶段 2：B 档 19 项适配（复制/移动/删除 BCL 递归、电源 7 项 U4、悬浮窗经典外观、条件文件 guard 落地） | 六部 | passed | p2-01…p2-10 |
| 13 | 阶段 2 验收：B19 19/19、门禁 168/168（CONDITIONAL=13 零超范围）、方案 B 双分支编译、Win/Linux exit=0（1,489,408/1,486,848 B） | 门下省 | menxia-stage2=passed | `evidence/menxia-stage2-acceptance.md` |
| 14 | 阶段 3：设置与配置整合（6 页接线 18/18、C 档裁剪 21/21、命名空间统一零调整、同装差异文档） | 六部 | passed | p3-01…p3-06 |
| 15 | **闸门故障**：旧 plan 下 p3-05…p3-06 succeeded 后，依赖闸门索引脱钩，后续任务无法派工 | 尚书省（上报） | 故障 | 见 stage3 §5 |
| 16 | **恢复处置**：收尾 plan（「阶段3-验证收尾·闸门故障恢复」）承载 4 个验证任务 p3-07…p3-10，零重复实施/零产物损失/留痕充分 | 尚书省 | succeeded | p3-07…p3-10 |
| 17 | 阶段 3 验收：18/18+21/21、门禁 168/0/13 逐值一致、VM 887 行界标共存、收尾 plan 恢复处置追认合规、Win/Linux exit=0（1,543,680/1,541,120 B） | 门下省 | menxia-stage3=passed | `evidence/menxia-stage3-acceptance.md` |
| 18 | 阶段 4：端到端验收与发布准备（终局门禁、发布就绪、发布终稿、预算链、闭卷重放与基线冻结） | 六部 | passed | p4-01…p4-05 |
| 19 | **构建沙箱命名管道阻断**：p4-01/p4-02 共 7 场景真实构建在进程启动被拒（`\\.\pipe\LOCAL\dotnet_*` denied）；以阶段 3 真实构建 + 差集 2 文件 + Roslyn 语义级编译 + 门禁差集=0 构成推断链 | 尚书省 + 门下省 | 裁量接受 | final-acceptance §5.1 |
| 20 | 门下省最终验收：98 计数终局重放、门禁四主体多时点一致、基线冻结逐值一致、9 项 O 项闭环、证据链 p0-01→p4-05 完整、两项证据缺口裁量接受 | 门下省 | menxia-acceptance=passed | `evidence/menxia-final-acceptance.md` |

## 三、终报与收尾

| 序 | 事件 | 责任 | 状态 | 证据 |
| --- | --- | --- | --- | --- |
| 21 | 中书省终报：撰写 06-final-report.md 与 07-chronicle.md | 中书省 | zhongshu-report | `06-final-report.md`、本文件 |
| 22 | 知识沉淀：向 `.tang/workspace-knowledge.md` upsert 可复用经验 | 中书省 | — | `tang_workspace_knowledge` |

## 四、关键时间戳（证据实录）

- 注册面冻结：`Plugin.cs` mtime 2026-09-04 11:17:15（742 行，唯一写入者=礼部）
- 阶段 3 收尾写：MainConfigData mtime 03:33:47Z；阶段 3 首写 04:36:01Z
- 终局权威扫描：2026-09-04T06:50:44Z（168/168 PASS）；吏部复跑 07:37:41Z 同值
- 基线冻结：manifest SHA256 `142CD419…AAC`、csproj SHA256 `A7220DB4…C38A`
- 阶段 4 时段产品面改动集 = 恰 2 个裁量点名文件（O-5/O-9，mtime 14:46:57）

## 五、勘误链（记录级，逐项在案）

E-1/E-2（早期记录）→ E-3（阶段 2 聚合计数 23→22）→ E-4（p1-09 TriggerInfo :18→:20）→ W-1（批证据行号微漂）→ E-5/E-6（p4-01 两文件 +5/+3 行复映射）→ M-1/M-2/M-3（字节数/计数注释勘误）→ p4-01 计数勘误。全链无断链、无并行双基线。
