# 门下省阶段 1 验收结论 — A 档 33 项抽取（案卷 stcp-cross-platform-001）

- 验收方：门下省（menxia-acceptance，独立复核，非抽签式抽查——关键门禁全部独立重放）
- 验收对象：阶段 1（A 档 33 项抽取）全部产出；不评价阶段 2 规划
- 权威依据：`04-spec.md` S4.1–S4.4 / S5、`05-phased-development.md` 阶段 1 行、`06-migration-details-proposal.md`（含用户开工决定「批准实施」）
- 输入工件：`05`、`06`、evidence/ p0-01…p0-07 与 p1-01…p1-10 全部证据、工作区工程 `src\SystemTools.CrossPlatform`
- **结论：通过（passed）**——六项验收要点全部独立复核成立，无需退回尚书省修订的实质问题；4 项非阻塞观察登记于 §7。

---

## 1. 要点一：A33 33/33 落地并注册（独立复核 ✓）

门下省以 `p0-03` 权威映射清单为基准，对工作区工程做了全量清点（非抽验）：

| 域 | 权威数 | 实测注册（Plugin.cs + 文件树） | 一致性 |
| --- | --: | --- | --- |
| 主题 | 3 | `AddXamlTheme` ×3（Card-type-component / classwidgets / notch-style），`avares://SystemTools.CrossPlatform/...` URI 改写到位 | ✓ |
| 组件 | 6 | `RegisterComponentIfEnabled` ×6 + 成对 SettingsControl + ComponentSettings 模型 6 个 | ✓ |
| 规则集 | 4 | 双参 `AddRule<TSettings,TSettingsControl>` ×4 + Handler 4 个 | ✓ |
| 触发器 | 1 | ActionInProgressTrigger 三件套（本体/Config/Settings） | ✓ |
| 行动 | 15 | A1–A15 逐一对照 p0-03 §3.1 与 Plugin.cs `RegisterActionIfEnabled`——15/15，ID 全为 `SystemTools.CrossPlatform.*` | ✓ |
| 服务/设置 | 4 | ① AI 文本链（AiChatWindowService + 10 文件支撑集 + 浮窗 + 通知内容控件）② 虚拟放学 ③ 版本检查 ④ 设置页 6 页骨架（含 MoreFeaturesOptionsSettingsPage，p1-06 §4） | ✓ |
| **合计** | **33** | 3+6+4+1+15+4，与 p1-05 §6 / p1-06 §2.6 闭合声明一致 | ✓ |

注册面唯一性成立：`Plugin.cs` 为唯一代码注册面（仅礼部 p1-06 产出，兵部四批交付报告零越界写入声明，p1-05 §4.1/§8-4 核对项）；主题 manifest id 与 ThemeManifest.Id 逐字符一致（p1-06 §7-5）。

## 2. 要点二：S4.2 禁用符号门禁独立重放（✓ 0 命中）

门下省未复用 p1-08 扫描器，直接以独立 grep 重放（`Windows.Win32|PInvoke.|System.Windows.Forms|Microsoft.Win32|System.Management|System.Speech|Windows.Media|Windows.Security|DllImport|LibraryImport`）：

- 扫描范围 `src\SystemTools.CrossPlatform` 全部 `.cs`（**比 p1-08 的 119 源文件口径更宽**——额外包含 `obj\` 下 9 个生成文件）→ **0 命中**。
- p1-08 全树矩阵（SourceFiles=119、AssetFiles=12、GateHits=0、InfoHits=0、VERDICT PASS）与本独立重放一致；csproj 第 79 行注释中的禁用包名清单为 [COMMENT-ONLY] 非门禁项，判定语义已在 p0-07 固化。
- 各批级扫描（p1-01 四段、p1-02、p1-03 五落点+修复轮复跑、p1-04 十二目标、p1-06 三目标+全树收口）输出文件齐备，命令可重放（p1-10 §8）。

## 3. 要点三：工程结构 / 命名空间 / 注册面合规（S8 无越界 ✓）

1. **命名空间全量核验**：114 个 `namespace` 声明 100% 以 `SystemTools.CrossPlatform.` 开头且逐目录镜像；裸 `SystemTools.` 前缀零出现（独立 grep 全量，非抽样）——同装并存前提（p0-05 §4.2）保持。
2. **GUID 形态注册零重合（独立验证）**：新插件 GUID 形态身份 = 6 处 `ComponentInfo` + 1 处 `NotificationProviderInfo`（含渠道共 3 GUID）。门下省对源插件全仓重放两个代表 GUID（`44BB7B21-…`、`E6FC9A28-…`）→ **0 命中**；p1-01 §3.4 留有 GUIDv5 确定性派生定义、旧→新映射表与五项零重合自证（源 17 GUID 全集、互异、RFC 格式自证、旧值零残留），p1-04 §3.4 留有 NotificationProvider 映射（源 `7E9A3D5C-…` → 新值）。p1-05 修订 R1 的全局 GUID 规则被全部批次正确执行。
3. **无 C 档泄漏 / 无 Win-only 架构**：文件树无 `VoskWorker\`、`ThirdParty\`、`.bat/.ps1/.exe`；无 `#if Platforms_*` 平台分叉（阶段 1 零分叉规则，p1-05 §5.1-2）；语音族（Vosk/SAPI/AiVoiceConversation）与背景采样族（LiquidGlass/BackgroundCapture/BackgroundLuminance）在交付代码中整族删除（p1-04 §2.1/§2.2 处置表 §2.2-17/18 行）。csproj 无 `UseWindowsForms`、无 `Platforms=x64`、无硬编码 windows TFM（`BaseFramework` + 宿主 `CrossPlatformProps` 导入）。
4. **C 子依赖排除（06 §30 强制项）落实**：`AiChatWindowService` 构造 8 参，`VoskSpeechService`/`MainWindowBackgroundCaptureService` 两参已移除（p1-04 §1 第 1 行登记；浮窗→ViewModel 传递链同步收紧）；AI 浮窗自适应背景（R-6/U5）随采样族降级。
5. **禁改面纪律**：兵部四批未触碰 Plugin.cs/manifest/csproj；manifest 字节级 SHA256 与 p0-05 基线一致（p1-06 §8）；csproj 阶段 1 仅 p1-10 按接线流程追加 1 个 ItemGroup（6 项 AvaloniaResource，diff 与 p1-10 §1.2 逐行一致）。

## 4. 要点四：双分支 API 漂移、残余差距与降级口径登记（✓ 如实）

1. **双分支 API 漂移**：p1-10 §12.5 明确登记 `MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty` 在 U3 本地检出源码存在、在 NuGet `ClassIsland.Core 2.1.1.1` 二进制缺位的事实、影响面（AVLN2000 仅触发于后备分支）、处置（p1-01 按 U5 降级口径移除引用，两分支均通过）与阶段 2+ 约束候选（发布面以 NuGet 包二进制 API 为基线）。登记完整、处置在已批口径内。
2. **残余差距如实登记**（p1-10 §7）：G1 macOS 构建无环境（静态兼容证据 102/102「可用」零「不适用」替代，真机重放留阶段 4）；G3 标准本地路径 Restore 受 MSB4276 环境噪声未重跑（按用户裁定口径以 NuGet 后备为准）；cipx 打包留阶段 4（CreateCipx 未设）；28 个 CS8602 可空警告不阻塞。四项均不构成本阶段合同出口门禁的违反——阶段 1 出口为「三平台构建通过」，实际达成 Win/Linux 双 TFM Release exit=0（1,349,120 B 真实产物，第四轮闭环），macOS 为静态证据 + U5/G1 既定降级，符合 05 合同与用户裁定口径。
3. **降级/适配处置全部在已批口径内且留痕**：p1-03 D1–D10（ILauncherService 替代 Process.Start、BCL Process.GetProcesses 替代 tasklist、悬浮窗配置存储根改独立配置目录防同装冲突、`OperatingSystem.IsWindows()` 守卫按 S4.2 允许项保留、Avalonia 12.1.1 API 面适配）、p1-06 `RestartClassIsland→RequestRestart`、悬浮窗菜单组门差异（A3/A4 注册完整、菜单组随阶段 2/3 B11 恢复，已在 Plugin.cs 与 p1-06 §8-4 双侧注记）。

## 5. 要点五：阶段 0/1 证据链闭合性抽查（✓）

- 链条完整：p0-01（宿主契约+G1–G3 缺口）→ p0-02/p0-05（脚手架/manifest 基线）→ p0-03（62→61 权威映射，与 04-spec 修订后口径一致，ClickSimulation 死代码注记正确）→ p0-04（依赖裁剪+用户 NuGet 更正留痕）→ p0-06（构建基线）→ p0-07（S4.2 扫描器与判定语义）→ p1-05（落点规范+修订 R1）→ p1-01/02/03/04（兵部四批，均 succeeded）→ p1-06（礼部注册+设置页，succeeded）→ p1-07（户部接线登记）→ p1-08（刑部全树门禁）→ p1-09（吏部映射更新）→ p1-10（工部构建门禁四轮闭环，终态 succeeded）。
- 交叉引用一致性抽查通过：p1-03 注册清单 ↔ Plugin.cs 实接线逐项一致；p1-06 §2 总表 ↔ p1-01/02/03/04 四批清单一致；p1-10 引用的修复轮（CS0104/CS1061/AVLN2000）与 p1-02/p1-03/p1-01 各自修复记录闭环；p1-04 增补 GlobalConstants 成员经尚书省裁决流程留痕（p1-03 §2 结案裁决、p1-06 §5 增补登记）。
- 零写入复核：宿主链 5 工程 obj mtime 与 p1-07 基线一致；源插件全程只读（p1-03 仅 GB18030 只读解码读取的记录）。

## 6. 要点六：需退回尚书省修订的具体问题

**无。** 未发现分档违反、门禁违反、越界写入、C 档泄漏、伪报成功或证据缺口。四轮构建迭代（CS0104 → CS1061 → AVLN2000 → 通过）均为缺陷发现-修复-复验的正常闭环，且每轮修复均限定在归属批次内、经复扫与复验确认。

## 7. 非阻塞观察项（登记备查，随阶段 3/4 处理，不影响本验收）

| # | 观察 | 建议 |
| --- | --- | --- |
| O-1 | ShowToast 菜单显示名「拉起自定义Windows通知」随源保留（符合 p1-05 §3.3「显示名随源」与 06 §16 注记） | 阶段 3 文档/同装差异说明时按独立插件口径核对用户可见文案 |
| O-2 | `apiVersion: 2.0.0.0` 取宿主加载下限（manifest 注释已论证 U3 关系）；NuGet 后备 2.1.1.1 组合语义 | 阶段 4 发布面核验时再次确认 apiVersion 与后备包组合 |
| O-3 | 28 个 CS8602 可空警告（不影响构建） | 阶段 4 收口时酌情清理，不设为门禁 |
| O-4 | G3 标准本地路径构建未重跑（MSB4276 环境噪声） | 维持 p1-10 登记口径：阶段 4 或环境恢复后重放 |

## 8. 验收判定

- **阶段 1 验收：通过（passed）。** A33 33/33 注册、S4.2 门禁 0 命中（独立重放）、结构/命名/GUID/注册面合规、API 漂移与残余差距如实登记、证据链闭合。
- 本验收文件作为案卷阶段 1 里程碑证据；阶段 2（B 档 19 项适配）按 05 合同在阶段 1 通过后解锁。
- 门下省未改任何产品文件；本文件为本任务唯一写入。
