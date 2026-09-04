# 工作区知识案卷

> 本文件是当前工作区所有案卷共同维护的唯一知识源。索引用于快速定位，详情用于按需展开，原始事实仍以标注的案卷文件为准。
> 文件由 `tang_workspace_knowledge` 结构化维护；请勿手工复制条目或把执行流水追加到这里。

<!-- TANG_WORKSPACE_KNOWLEDGE_HEAD_START -->
## 渐进披露入口

- 新案只预载本节。先用索引判断是否存在相关经验，不要默认读取全部详情。
- 需要依据时调用 `tang_workspace_knowledge` 的 `details`；只有需要核对原始事实时再调用 `sources`。
- `key` 是跨案唯一语义键；同一知识必须更新原键，不得换名重复追加。
- 详情只保留可复用的决定、约束、模式、踩坑和验证经验；案情流水留在来源案卷。

## 知识索引

| ID | 类型 | 主题 | 适用范围 | 状态 | 来源案卷 | 一句话结论 |
| --- | --- | --- | --- | --- | --- | --- |
| K-D58C3880B7 | pitfall | ClassIsland 本地检出与 NuGet 包双分支 API 漂移 | 适用于依赖 ClassIsland（misha/v2 本地检出 + NuGet 后备包）的插件开发与发布 | confirmed | stcp-cross-platform-001 | 本地检出源码存在的 API 可能在 NuGet 二进制缺位（如 MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty），发布面须以 NuGet 包二进制 API 为基线。 |
| K-DB55B18DDA | pattern | 跨平台插件抽取的禁用符号静态门禁（S4.2） | 适用于把 Windows 专用 .NET 插件抽取为跨平台插件时判定「无 Windows 依赖」的可测试门禁 | confirmed | stcp-cross-platform-001 | 用禁用符号集合（CsWin32/WinForms/Registry/WMI/SAPI/WinRT/DllImport/Windows 专属进程与包）做全树逐文件静态扫描，A 档 GateHits=0，B 档 Windows 专属点收敛于 #if Platforms_Windows 条件文件 guard 内。 |
| K-6CA0BF5864 | pattern | SystemTools 跨平台功能迁移的三档分档经验 | 适用于 SystemTools→SystemTools-Cross-platform 及同类 ClassIsland 插件的跨平台功能分档 | confirmed | stcp-cross-platform-001 | A/B/C 三档（A 纯 SDK/Avalonia/FluentAvalonia/BCL；B 单点 Windows 调用换宿主抽象或 OS 命令；C 深度绑定 Win32/WMI/WinRT/认证/输入模型或语义不成立），B 档带三元组（Windows 点→替换→降级）。 |
| K-DBFE9E3340 | pattern | Tang 执行期基础设施/闸门/子代理故障的恢复处置 | 适用于 Tang 大案执行期遇到依赖闸门脱钩、子代理反复失败、沙箱阻断等基础设施故障时的恢复；不适用于需求/规格层面的问题 | confirmed | stcp-cross-platform-001 | 恢复处置三原则=留痕充分、零重复实施、最小边界绕开（收尾 plan 只承载验证/分析任务）；经门下省按三标准追认即合规。 |
| K-B4B8E98419 | verification | 沙箱命名管道阻断下用 Roslyn 双向验证替代真实构建 | 适用于 Windows 会话沙箱因 \\.\pipe\LOCAL\dotnet_* 命名管道策略拒绝 dotnet 子进程时的编译验证 | confirmed | stcp-cross-platform-001 | 真实构建被命名管道阻断时，用「上一阶段真实 exit=0 + 差集恰 N 个零风险文件 + Roslyn 语义级双向编译 error=0/warning=0 + 门禁差集=0」构成有效推断链，并登记发布前补跑待办。 |
<!-- TANG_WORKSPACE_KNOWLEDGE_HEAD_END -->

## 知识详情

### K-D58C3880B7 · ClassIsland 本地检出与 NuGet 包双分支 API 漂移

- 唯一键：`crossplatform/classisland-dual-branch-api-drift`
- 类型：pitfall
- 适用范围：适用于依赖 ClassIsland（misha/v2 本地检出 + NuGet 后备包）的插件开发与发布
- 状态：confirmed
- 来源案卷：stcp-cross-platform-001

#### 结论

本地检出源码存在的 API 可能在 NuGet 二进制缺位（如 MainWindowStylesAssist.IsBackgroundMaterialEnabledProperty），发布面须以 NuGet 包二进制 API 为基线。

#### 经验详情

漂移现象=本地检出源码存在、NuGet ClassIsland.Core 2.1.1.1 二进制缺位的 API 只会在后备分支触发编译错误（AVLN2000）；处置=按降级口径移除引用使双分支均通过；约束=发布面以 NuGet 二进制 API 为准，本地检出仅作开发基线。

#### 原案证据

- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/evidence/menxia-stage1-acceptance.md` — §4.1 双分支 API 漂移事实、影响面、处置与阶段2+约束候选的登记

### K-DB55B18DDA · 跨平台插件抽取的禁用符号静态门禁（S4.2）

- 唯一键：`crossplatform/plugin-forbidden-symbol-gate`
- 类型：pattern
- 适用范围：适用于把 Windows 专用 .NET 插件抽取为跨平台插件时判定「无 Windows 依赖」的可测试门禁
- 状态：confirmed
- 来源案卷：stcp-cross-platform-001

#### 结论

用禁用符号集合（CsWin32/WinForms/Registry/WMI/SAPI/WinRT/DllImport/Windows 专属进程与包）做全树逐文件静态扫描，A 档 GateHits=0，B 档 Windows 专属点收敛于 #if Platforms_Windows 条件文件 guard 内。

#### 经验详情

禁用符号集合=using Windows.Win32/PInvoke.*、System.Windows.Forms、Microsoft.Win32、System.Management、System.Speech、Windows.Media/Security、DllImport/LibraryImport、cmd.exe/robocopy.exe/rundll32.exe 等专属进程、OpenCvSharp4.runtime.win/DlibDotNet/NAudio 等专属包；允许项=OperatingSystem.IsWindows() 运行时守卫；条件文件形态=裸 #if Platforms_Windows 全包裹 + 取反存根（#if !Platforms_Windows）防 CS0101；最终门禁=三平台构建通过。

#### 原案证据

- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/04-spec.md` — S4.2 定义禁用符号集合、允许项与实现期门禁定义
- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/evidence/menxia-stage2-acceptance.md` — §2/§3 全树 168/168 门禁（CONDITIONAL=13 收敛于 4 个条件文件 guard 内）与真实双分支编译证明

### K-6CA0BF5864 · SystemTools 跨平台功能迁移的三档分档经验

- 唯一键：`crossplatform/systemtools-migration-tiering`
- 类型：pattern
- 适用范围：适用于 SystemTools→SystemTools-Cross-platform 及同类 ClassIsland 插件的跨平台功能分档
- 状态：confirmed
- 来源案卷：stcp-cross-platform-001

#### 结论

A/B/C 三档（A 纯 SDK/Avalonia/FluentAvalonia/BCL；B 单点 Windows 调用换宿主抽象或 OS 命令；C 深度绑定 Win32/WMI/WinRT/认证/输入模型或语义不成立），B 档带三元组（Windows 点→替换→降级）。

#### 经验详情

最终分档 A33/B19/C46=98（含 61 活动行动功能项，62 文件减 1 死代码）。关键判定经验：ShowToast 用宿主 PlatformServices.DesktopToastService 归 A 而非 C；电源七项为单点进程级 OS 命令替换归 B 而非 C；复制/移动/删除的文件夹子路径用 robocopy.exe/cmd /c rmdir 归 B 而非 A（文件子路径才是 BCL）；整文件注释死代码不计功能项；宿主抽象缺口（全局热键/空闲检测/输入注入/壁纸/截图/OCR/音量）决定 C 档边界。

#### 原案证据

- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/02-draft-solution.md` — 三档分类、B 档三元组、逐功能总表与工程改造要点
- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/06-final-report.md` — 最终分档结果 A33+B19+C46=98 与功能落地结论

### K-DBFE9E3340 · Tang 执行期基础设施/闸门/子代理故障的恢复处置

- 唯一键：`tang/execution-infra-failure-recovery`
- 类型：pattern
- 适用范围：适用于 Tang 大案执行期遇到依赖闸门脱钩、子代理反复失败、沙箱阻断等基础设施故障时的恢复；不适用于需求/规格层面的问题
- 状态：confirmed
- 来源案卷：stcp-cross-platform-001

#### 结论

恢复处置三原则=留痕充分、零重复实施、最小边界绕开（收尾 plan 只承载验证/分析任务）；经门下省按三标准追认即合规。

#### 经验详情

故障现象与已尝试手段（重试/运行时刷新/重录）必须留痕；绕开方式用新 phase 名明示「闸门故障恢复」，且派工字段写明「依赖 none——已 succeeded 落盘，仅验证」；合规判据为「无重复实施 / 无产物损失 / 留痕充分」三标准；不得借恢复改变验收口径，不得重复实施已落盘产物。

#### 原案证据

- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/evidence/menxia-stage3-acceptance.md` — §5 收尾 plan 恢复处置合规性专项核验：依赖闸门索引脱钩后以收尾 plan 承载 4 个验证任务，三标准全过并被门下省追认

### K-B4B8E98419 · 沙箱命名管道阻断下用 Roslyn 双向验证替代真实构建

- 唯一键：`tang/sandbox-namedpipe-build-roslyn-substitute`
- 类型：verification
- 适用范围：适用于 Windows 会话沙箱因 \\.\pipe\LOCAL\dotnet_* 命名管道策略拒绝 dotnet 子进程时的编译验证
- 状态：confirmed
- 来源案卷：stcp-cross-platform-001

#### 结论

真实构建被命名管道阻断时，用「上一阶段真实 exit=0 + 差集恰 N 个零风险文件 + Roslyn 语义级双向编译 error=0/warning=0 + 门禁差集=0」构成有效推断链，并登记发布前补跑待办。

#### 经验详情

命名管道阻断是环境事实而非证据缺陷；处置=留证、不重试绕行、如实转报；Roslyn Round-N/W 双向符号为语义级（覆盖双预处理分支，非语法级）；验收可接受但须把真实构建复跑明确登记为发布前待办，不因该项待办降级验收结论。

#### 原案证据

- [stcp-cross-platform-001] `.tang/cases/stcp-cross-platform-001/evidence/menxia-final-acceptance.md` — §5.1 裁量①：7 场景真实构建被命名管道拒绝，以阶段3真实exit=0+差集2文件+Roslyn双轮+门禁差集=0构成推断链，接受并登记发布前补跑

<!-- TANG_WORKSPACE_KNOWLEDGE_DATA_START
eyJ2ZXJzaW9uIjoxLCJlbnRyaWVzIjpbeyJpZCI6IkstREJGRTlFMzM0MCIsImtleSI6InRhbmcvZXhlY3V0aW9uLWluZnJhLWZhaWx1cmUtcmVjb3ZlcnkiLCJraW5kIjoicGF0dGVybiIsInRvcGljIjoiVGFuZyDmiafooYzmnJ/ln7rnoYDorr7mlr0v6Ze46ZeoL+WtkOS7o+eQhuaVhemanOeahOaBouWkjeWkhOe9riIsInNjb3BlIjoi6YCC55So5LqOIFRhbmcg5aSn5qGI5omn6KGM5pyf6YGH5Yiw5L6d6LWW6Ze46Zeo6ISx6ZKp44CB5a2Q5Luj55CG5Y+N5aSN5aSx6LSl44CB5rKZ566x6Zi75pat562J5Z+656GA6K6+5pa95pWF6Zqc5pe255qE5oGi5aSN77yb5LiN6YCC55So5LqO6ZyA5rGCL+inhOagvOWxgumdoueahOmXrumimCIsInN1bW1hcnkiOiLmgaLlpI3lpITnva7kuInljp/liJk955WZ55eV5YWF5YiG44CB6Zu26YeN5aSN5a6e5pa944CB5pyA5bCP6L6555WM57uV5byA77yI5pS25bC+IHBsYW4g5Y+q5om/6L296aqM6K+BL+WIhuaekOS7u+WKoe+8ie+8m+e7j+mXqOS4i+ecgeaMieS4ieagh+WHhui/veiupOWNs+WQiOinhOOAgiIsImRldGFpbHMiOiLmlYXpmpznjrDosaHkuI7lt7LlsJ3or5XmiYvmrrXvvIjph43or5Uv6L+Q6KGM5pe25Yi35pawL+mHjeW9le+8ieW/hemhu+eVmeeXle+8m+e7leW8gOaWueW8j+eUqOaWsCBwaGFzZSDlkI3mmI7npLrjgIzpl7jpl6jmlYXpmpzmgaLlpI3jgI3vvIzkuJTmtL7lt6XlrZfmrrXlhpnmmI7jgIzkvp3otZYgbm9uZeKAlOKAlOW3siBzdWNjZWVkZWQg6JC955uY77yM5LuF6aqM6K+B44CN77yb5ZCI6KeE5Yik5o2u5Li644CM5peg6YeN5aSN5a6e5pa9IC8g5peg5Lqn54mp5o2f5aSxIC8g55WZ55eV5YWF5YiG44CN5LiJ5qCH5YeG77yb5LiN5b6X5YCf5oGi5aSN5pS55Y+Y6aqM5pS25Y+j5b6E77yM5LiN5b6X6YeN5aSN5a6e5pa95bey6JC955uY5Lqn54mp44CCIiwic3RhdGUiOiJjb25maXJtZWQiLCJzb3VyY2VDYXNlcyI6WyJzdGNwLWNyb3NzLXBsYXRmb3JtLTAwMSJdLCJldmlkZW5jZSI6W3siY2FzZUlkIjoic3RjcC1jcm9zcy1wbGF0Zm9ybS0wMDEiLCJhcnRpZmFjdCI6Ii50YW5nL2Nhc2VzL3N0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxL2V2aWRlbmNlL21lbnhpYS1zdGFnZTMtYWNjZXB0YW5jZS5tZCIsIm5vdGUiOiLCpzUg5pS25bC+IHBsYW4g5oGi5aSN5aSE572u5ZCI6KeE5oCn5LiT6aG55qC46aqM77ya5L6d6LWW6Ze46Zeo57Si5byV6ISx6ZKp5ZCO5Lul5pS25bC+IHBsYW4g5om/6L29IDQg5Liq6aqM6K+B5Lu75Yqh77yM5LiJ5qCH5YeG5YWo6L+H5bm26KKr6Zeo5LiL55yB6L+96K6kIn1dLCJzdXBlcnNlZGVzIjpbXSwidXBkYXRlZEF0IjoiMjAyNi0wOS0wNFQwNzo1NTo0MC4yODBaIn0seyJpZCI6IkstQjRCOEU5ODQxOSIsImtleSI6InRhbmcvc2FuZGJveC1uYW1lZHBpcGUtYnVpbGQtcm9zbHluLXN1YnN0aXR1dGUiLCJraW5kIjoidmVyaWZpY2F0aW9uIiwidG9waWMiOiLmspnnrrHlkb3lkI3nrqHpgZPpmLvmlq3kuIvnlKggUm9zbHluIOWPjOWQkemqjOivgeabv+S7o+ecn+WunuaehOW7uiIsInNjb3BlIjoi6YCC55So5LqOIFdpbmRvd3Mg5Lya6K+d5rKZ566x5ZugIFxcXFwuXFxwaXBlXFxMT0NBTFxcZG90bmV0Xyog5ZG95ZCN566h6YGT562W55Wl5ouS57udIGRvdG5ldCDlrZDov5vnqIvml7bnmoTnvJbor5Hpqozor4EiLCJzdW1tYXJ5Ijoi55yf5a6e5p6E5bu66KKr5ZG95ZCN566h6YGT6Zi75pat5pe277yM55So44CM5LiK5LiA6Zi25q6155yf5a6eIGV4aXQ9MCArIOW3rumbhuaBsCBOIOS4qumbtumjjumZqeaWh+S7tiArIFJvc2x5biDor63kuYnnuqflj4zlkJHnvJbor5EgZXJyb3I9MC93YXJuaW5nPTAgKyDpl6jnpoHlt67pm4Y9MOOAjeaehOaIkOacieaViOaOqOaWremTvu+8jOW5tueZu+iusOWPkeW4g+WJjeihpei3keW+heWKnuOAgiIsImRldGFpbHMiOiLlkb3lkI3nrqHpgZPpmLvmlq3mmK/njq/looPkuovlrp7ogIzpnZ7or4Hmja7nvLrpmbfvvJvlpITnva4955WZ6K+B44CB5LiN6YeN6K+V57uV6KGM44CB5aaC5a6e6L2s5oql77ybUm9zbHluIFJvdW5kLU4vVyDlj4zlkJHnrKblj7fkuLror63kuYnnuqfvvIjopobnm5blj4zpooTlpITnkIbliIbmlK/vvIzpnZ7or63ms5XnuqfvvInvvJvpqozmlLblj6/mjqXlj5fkvYbpobvmiornnJ/lrp7mnoTlu7rlpI3ot5HmmI7noa7nmbvorrDkuLrlj5HluIPliY3lvoXlip7vvIzkuI3lm6Dor6XpobnlvoXlip7pmY3nuqfpqozmlLbnu5PorrrjgIIiLCJzdGF0ZSI6ImNvbmZpcm1lZCIsInNvdXJjZUNhc2VzIjpbInN0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxIl0sImV2aWRlbmNlIjpbeyJjYXNlSWQiOiJzdGNwLWNyb3NzLXBsYXRmb3JtLTAwMSIsImFydGlmYWN0IjoiLnRhbmcvY2FzZXMvc3RjcC1jcm9zcy1wbGF0Zm9ybS0wMDEvZXZpZGVuY2UvbWVueGlhLWZpbmFsLWFjY2VwdGFuY2UubWQiLCJub3RlIjoiwqc1LjEg6KOB6YeP4pGg77yaNyDlnLrmma/nnJ/lrp7mnoTlu7rooqvlkb3lkI3nrqHpgZPmi5Lnu53vvIzku6XpmLbmrrUz55yf5a6eZXhpdD0wK+W3rumbhjLmlofku7YrUm9zbHlu5Y+M6L2uK+mXqOemgeW3rumbhj0w5p6E5oiQ5o6o5pat6ZO+77yM5o6l5Y+X5bm255m76K6w5Y+R5biD5YmN6KGl6LeRIn1dLCJzdXBlcnNlZGVzIjpbXSwidXBkYXRlZEF0IjoiMjAyNi0wOS0wNFQwNzo1NTo0MC4yODBaIn0seyJpZCI6IkstREI1NUIxOEREQSIsImtleSI6ImNyb3NzcGxhdGZvcm0vcGx1Z2luLWZvcmJpZGRlbi1zeW1ib2wtZ2F0ZSIsImtpbmQiOiJwYXR0ZXJuIiwidG9waWMiOiLot6jlubPlj7Dmj5Lku7bmir3lj5bnmoTnpoHnlKjnrKblj7fpnZnmgIHpl6jnpoHvvIhTNC4y77yJIiwic2NvcGUiOiLpgILnlKjkuo7mioogV2luZG93cyDkuJPnlKggLk5FVCDmj5Lku7bmir3lj5bkuLrot6jlubPlj7Dmj5Lku7bml7bliKTlrprjgIzml6AgV2luZG93cyDkvp3otZbjgI3nmoTlj6/mtYvor5Xpl6jnpoEiLCJzdW1tYXJ5Ijoi55So56aB55So56ym5Y+36ZuG5ZCI77yIQ3NXaW4zMi9XaW5Gb3Jtcy9SZWdpc3RyeS9XTUkvU0FQSS9XaW5SVC9EbGxJbXBvcnQvV2luZG93cyDkuJPlsZ7ov5vnqIvkuI7ljIXvvInlgZrlhajmoJHpgJDmlofku7bpnZnmgIHmiavmj4/vvIxBIOahoyBHYXRlSGl0cz0w77yMQiDmoaMgV2luZG93cyDkuJPlsZ7ngrnmlLbmlZvkuo4gI2lmIFBsYXRmb3Jtc19XaW5kb3dzIOadoeS7tuaWh+S7tiBndWFyZCDlhoXjgIIiLCJkZXRhaWxzIjoi56aB55So56ym5Y+36ZuG5ZCIPXVzaW5nIFdpbmRvd3MuV2luMzIvUEludm9rZS4q44CBU3lzdGVtLldpbmRvd3MuRm9ybXPjgIFNaWNyb3NvZnQuV2luMzLjgIFTeXN0ZW0uTWFuYWdlbWVudOOAgVN5c3RlbS5TcGVlY2jjgIFXaW5kb3dzLk1lZGlhL1NlY3VyaXR544CBRGxsSW1wb3J0L0xpYnJhcnlJbXBvcnTjgIFjbWQuZXhlL3JvYm9jb3B5LmV4ZS9ydW5kbGwzMi5leGUg562J5LiT5bGe6L+b56iL44CBT3BlbkN2U2hhcnA0LnJ1bnRpbWUud2luL0RsaWJEb3ROZXQvTkF1ZGlvIOetieS4k+WxnuWMhe+8m+WFgeiuuOmhuT1PcGVyYXRpbmdTeXN0ZW0uSXNXaW5kb3dzKCkg6L+Q6KGM5pe25a6I5Y2r77yb5p2h5Lu25paH5Lu25b2i5oCBPeijuCAjaWYgUGxhdGZvcm1zX1dpbmRvd3Mg5YWo5YyF6KO5ICsg5Y+W5Y+N5a2Y5qC577yII2lmICFQbGF0Zm9ybXNfV2luZG93c++8iemYsiBDUzAxMDHvvJvmnIDnu4jpl6jnpoE95LiJ5bmz5Y+w5p6E5bu66YCa6L+H44CCIiwic3RhdGUiOiJjb25maXJtZWQiLCJzb3VyY2VDYXNlcyI6WyJzdGNwLWNyb3NzLXBsYXRmb3JtLTAwMSJdLCJldmlkZW5jZSI6W3siY2FzZUlkIjoic3RjcC1jcm9zcy1wbGF0Zm9ybS0wMDEiLCJhcnRpZmFjdCI6Ii50YW5nL2Nhc2VzL3N0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxLzA0LXNwZWMubWQiLCJub3RlIjoiUzQuMiDlrprkuYnnpoHnlKjnrKblj7fpm4blkIjjgIHlhYHorrjpobnkuI7lrp7njrDmnJ/pl6jnpoHlrprkuYkifSx7ImNhc2VJZCI6InN0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxIiwiYXJ0aWZhY3QiOiIudGFuZy9jYXNlcy9zdGNwLWNyb3NzLXBsYXRmb3JtLTAwMS9ldmlkZW5jZS9tZW54aWEtc3RhZ2UyLWFjY2VwdGFuY2UubWQiLCJub3RlIjoiwqcyL8KnMyDlhajmoJEgMTY4LzE2OCDpl6jnpoHvvIhDT05ESVRJT05BTD0xMyDmlLbmlZvkuo4gNCDkuKrmnaHku7bmlofku7YgZ3VhcmQg5YaF77yJ5LiO55yf5a6e5Y+M5YiG5pSv57yW6K+R6K+B5piOIn1dLCJzdXBlcnNlZGVzIjpbXSwidXBkYXRlZEF0IjoiMjAyNi0wOS0wNFQwNzo1NTo0MC4yODBaIn0seyJpZCI6IkstRDU4QzM4ODBCNyIsImtleSI6ImNyb3NzcGxhdGZvcm0vY2xhc3Npc2xhbmQtZHVhbC1icmFuY2gtYXBpLWRyaWZ0Iiwia2luZCI6InBpdGZhbGwiLCJ0b3BpYyI6IkNsYXNzSXNsYW5kIOacrOWcsOajgOWHuuS4jiBOdUdldCDljIXlj4zliIbmlK8gQVBJIOa8guenuyIsInNjb3BlIjoi6YCC55So5LqO5L6d6LWWIENsYXNzSXNsYW5k77yIbWlzaGEvdjIg5pys5Zyw5qOA5Ye6ICsgTnVHZXQg5ZCO5aSH5YyF77yJ55qE5o+S5Lu25byA5Y+R5LiO5Y+R5biDIiwic3VtbWFyeSI6IuacrOWcsOajgOWHuua6kOeggeWtmOWcqOeahCBBUEkg5Y+v6IO95ZyoIE51R2V0IOS6jOi/m+WItue8uuS9je+8iOWmgiBNYWluV2luZG93U3R5bGVzQXNzaXN0LklzQmFja2dyb3VuZE1hdGVyaWFsRW5hYmxlZFByb3BlcnR577yJ77yM5Y+R5biD6Z2i6aG75LulIE51R2V0IOWMheS6jOi/m+WItiBBUEkg5Li65Z+657q/44CCIiwiZGV0YWlscyI6Iua8guenu+eOsOixoT3mnKzlnLDmo4Dlh7rmupDnoIHlrZjlnKjjgIFOdUdldCBDbGFzc0lzbGFuZC5Db3JlIDIuMS4xLjEg5LqM6L+b5Yi257y65L2N55qEIEFQSSDlj6rkvJrlnKjlkI7lpIfliIbmlK/op6blj5HnvJbor5HplJnor6/vvIhBVkxOMjAwMO+8ie+8m+WkhOe9rj3mjInpmY3nuqflj6PlvoTnp7vpmaTlvJXnlKjkvb/lj4zliIbmlK/lnYfpgJrov4fvvJvnuqbmnZ895Y+R5biD6Z2i5LulIE51R2V0IOS6jOi/m+WItiBBUEkg5Li65YeG77yM5pys5Zyw5qOA5Ye65LuF5L2c5byA5Y+R5Z+657q/44CCIiwic3RhdGUiOiJjb25maXJtZWQiLCJzb3VyY2VDYXNlcyI6WyJzdGNwLWNyb3NzLXBsYXRmb3JtLTAwMSJdLCJldmlkZW5jZSI6W3siY2FzZUlkIjoic3RjcC1jcm9zcy1wbGF0Zm9ybS0wMDEiLCJhcnRpZmFjdCI6Ii50YW5nL2Nhc2VzL3N0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxL2V2aWRlbmNlL21lbnhpYS1zdGFnZTEtYWNjZXB0YW5jZS5tZCIsIm5vdGUiOiLCpzQuMSDlj4zliIbmlK8gQVBJIOa8guenu+S6i+WunuOAgeW9seWTjemdouOAgeWkhOe9ruS4jumYtuautTIr57qm5p2f5YCZ6YCJ55qE55m76K6wIn1dLCJzdXBlcnNlZGVzIjpbXSwidXBkYXRlZEF0IjoiMjAyNi0wOS0wNFQwNzo1NTo0MC4yODBaIn0seyJpZCI6IkstNkNBMEJGNTg2NCIsImtleSI6ImNyb3NzcGxhdGZvcm0vc3lzdGVtdG9vbHMtbWlncmF0aW9uLXRpZXJpbmciLCJraW5kIjoicGF0dGVybiIsInRvcGljIjoiU3lzdGVtVG9vbHMg6Leo5bmz5Y+w5Yqf6IO96L+B56e755qE5LiJ5qGj5YiG5qGj57uP6aqMIiwic2NvcGUiOiLpgILnlKjkuo4gU3lzdGVtVG9vbHPihpJTeXN0ZW1Ub29scy1Dcm9zcy1wbGF0Zm9ybSDlj4rlkIznsbsgQ2xhc3NJc2xhbmQg5o+S5Lu255qE6Leo5bmz5Y+w5Yqf6IO95YiG5qGjIiwic3VtbWFyeSI6IkEvQi9DIOS4ieaho++8iEEg57qvIFNESy9BdmFsb25pYS9GbHVlbnRBdmFsb25pYS9CQ0zvvJtCIOWNleeCuSBXaW5kb3dzIOiwg+eUqOaNouWuv+S4u+aKveixoeaIliBPUyDlkb3ku6TvvJtDIOa3seW6pue7keWumiBXaW4zMi9XTUkvV2luUlQv6K6k6K+BL+i+k+WFpeaooeWei+aIluivreS5ieS4jeaIkOeri++8ie+8jEIg5qGj5bim5LiJ5YWD57uE77yIV2luZG93cyDngrnihpLmm7/mjaLihpLpmY3nuqfvvInjgIIiLCJkZXRhaWxzIjoi5pyA57uI5YiG5qGjIEEzMy9CMTkvQzQ2PTk477yI5ZCrIDYxIOa0u+WKqOihjOWKqOWKn+iDvemhue+8jDYyIOaWh+S7tuWHjyAxIOatu+S7o+egge+8ieOAguWFs+mUruWIpOWumue7j+mqjO+8mlNob3dUb2FzdCDnlKjlrr/kuLsgUGxhdGZvcm1TZXJ2aWNlcy5EZXNrdG9wVG9hc3RTZXJ2aWNlIOW9kiBBIOiAjOmdniBD77yb55S15rqQ5LiD6aG55Li65Y2V54K56L+b56iL57qnIE9TIOWRveS7pOabv+aNouW9kiBCIOiAjOmdniBD77yb5aSN5Yi2L+enu+WKqC/liKDpmaTnmoTmlofku7blpLnlrZDot6/lvoTnlKggcm9ib2NvcHkuZXhlL2NtZCAvYyBybWRpciDlvZIgQiDogIzpnZ4gQe+8iOaWh+S7tuWtkOi3r+W+hOaJjeaYryBCQ0zvvInvvJvmlbTmlofku7bms6jph4rmrbvku6PnoIHkuI3orqHlip/og73pobnvvJvlrr/kuLvmir3osaHnvLrlj6PvvIjlhajlsYDng63plK4v56m66Zey5qOA5rWLL+i+k+WFpeazqOWFpS/lo4Hnurgv5oiq5Zu+L09DUi/pn7Pph4/vvInlhrPlrpogQyDmoaPovrnnlYzjgIIiLCJzdGF0ZSI6ImNvbmZpcm1lZCIsInNvdXJjZUNhc2VzIjpbInN0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxIl0sImV2aWRlbmNlIjpbeyJjYXNlSWQiOiJzdGNwLWNyb3NzLXBsYXRmb3JtLTAwMSIsImFydGlmYWN0IjoiLnRhbmcvY2FzZXMvc3RjcC1jcm9zcy1wbGF0Zm9ybS0wMDEvMDItZHJhZnQtc29sdXRpb24ubWQiLCJub3RlIjoi5LiJ5qGj5YiG57G744CBQiDmoaPkuInlhYPnu4TjgIHpgJDlip/og73mgLvooajkuI7lt6XnqIvmlLnpgKDopoHngrkifSx7ImNhc2VJZCI6InN0Y3AtY3Jvc3MtcGxhdGZvcm0tMDAxIiwiYXJ0aWZhY3QiOiIudGFuZy9jYXNlcy9zdGNwLWNyb3NzLXBsYXRmb3JtLTAwMS8wNi1maW5hbC1yZXBvcnQubWQiLCJub3RlIjoi5pyA57uI5YiG5qGj57uT5p6cIEEzMytCMTkrQzQ2PTk4IOS4juWKn+iDveiQveWcsOe7k+iuuiJ9XSwic3VwZXJzZWRlcyI6W10sInVwZGF0ZWRBdCI6IjIwMjYtMDktMDRUMDc6NTU6NDAuMjgwWiJ9XX0=
TANG_WORKSPACE_KNOWLEDGE_DATA_END -->
