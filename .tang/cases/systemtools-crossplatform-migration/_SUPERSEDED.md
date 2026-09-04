# 案卷已废弃（SUPERSEDED）

本目录（`systemtools-crossplatform-migration`）内的 `01-requirements.md` 与 `02-draft-solution.md` 为**更早流程/会话的旧草案**，其关键前提已被用户澄清答复推翻：

| 旧草案前提 | 当前已定结论（case: stcp-cross-platform-001） |
| --- | --- |
| 默认仅 Linux/macOS；U1「三平台 vs 仅 Linux/macOS」未决 | **三平台并存**：Windows+Linux+macOS 均构建，原 SystemTools 继续独立维护，Windows 用户可任选 |
| U2「轻改即可的采纳边界」未决 | **纳入构建范围**：B 档（稍加修改即可跨平台）本期做适配改造后纳入 |
| 未涉及配置/ID 兼容决策 | **独立 ID 与全新配置**：不与并存的 SystemTools 冲突 |

因此本目录两份旧文件**不再作为本案依据**，请以案卷 `stcp-cross-platform-001` 下的 `01-requirements.md` 与 `02-draft-solution.md` 为准。

- 旧草案中仍有效的**源码证据**（Windows 依赖审计、文件级证据速查）已在新 `02-draft-solution.md` 中复核、校正并沿用。
- 主要校正点：`ShowToastAction`（拉起自定义通知）实际已使用宿主 `PlatformServices.DesktopToastService` 跨平台抽象，由旧草案的 C 档修正为 **A 档**；`KillProcessAction`/`ProcessRunningRule` 为纯 `System.Diagnostics.Process`，归 **A 档**；电源选项七项为「OS 命令/系统调用替换」性质，归 **B 档**（而非旧草案笼统归 C）。
