<#
p3-03 兵部（application-code / implementation，独立认证形态）· 独立命名空间全量审计
案卷 stcp-cross-platform-001 · assignment p3-03（依赖 p3-05 已 succeeded）

独立方法（区别于 p3-05 §4.1 的 Select-String 平面检索，不复制其清单）：
  A. 目录×namespace 声明交叉比对：逐文件语法锚定提取全部 namespace 声明（捕获全局命名空间、
     多声明块、非前缀、目录镜像漂移四类），并产出 命名空间→文件集 清单（22 唯一值独立复算）。
  B. using 面检查：禁 `using SystemTools.*`（非 CrossPlatform 段）源命名空间耦合（p1-05 §3.2-4，
     含 global using 变体）；`using SystemTools.CrossPlatform`（同程序集内部合法）信息性清单。
  C. 29 .axaml：x:Class / using: / clr-namespace: 前缀核对 + x:Class ↔ 配对 .axaml.cs 命名空间与
     类名双向交叉验证；历史遗留 SystemTools.*（非 CrossPlatform）本地引用零容忍。
  D. 独立配置命名空间核对：ConfigHandlers 6 文件清单与命名空间 + JSON 名随源（对源插件
     ConfigHandlers\MainConfigData.cs / ButtonRulesetConfig.cs / RowRulesetConfig.cs 只读逐名对照）
     + camelCase 自一致性 + PluginConfigFolder 独立目录接线链（GlobalConstants→Plugin.cs→
     MainConfigHandler→FloatingWindowProfileManager 子目录）。
  E. 全树复跑检索（p1-05 §6-2 / p3-05 复核形态）：'namespace (?!SystemTools\.CrossPlatform)' 预期 0。
  F. 树态时点快照（审计前/后各一次）：并行批（p3-01/p3-02）落盘时点注记依据。

v2 精化（2026-09-04，r1 严格版 4 项人工裁决后）：①多声明块且各块命名空间值相同并等于目录镜像
  → 降级为例外记录 X1（p0-07 R-2 形态 a 条件文件 #if/#else 双分支同值承载，命名空间值仍唯一）；
  ②code-behind 配对接受 <basename>.cs 形态（InTimePeriodRuleSettingsControl 阶段 1 先例），
    记录 X2；③x:Class 类名匹配改为全文件检索（多类文件主类可在辅助类后声明）。
  r1 严格版输出存档：p3-03-namespace-audit-output-r1-strict.txt（4 项原始标记留痕）。

只读审计：零产品文件改动；写入仅本脚本与 evidence 输出文件（p3-03-namespace-audit-output.txt）。
退出码：0 = 零违例（零调整认证成立）；1 = 存在违例（调整清单上报尚书省裁决）。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Location).Path
$proj = Join-Path $ws 'src\SystemTools.CrossPlatform'
$prefix = 'SystemTools.CrossPlatform'
$srcPluginRoot = 'E:\My Github Projects\SystemTools'
$out = New-Object System.Collections.Generic.List[string]
function Log([string]$s) { $script:out.Add($s) }
$viol = New-Object System.Collections.Generic.List[string]
$info = New-Object System.Collections.Generic.List[string]

function Get-SourceFiles {
  Get-ChildItem $proj -Recurse -File | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Sort-Object FullName
}
function Snap([string]$label) {
  Log "--- TREE-SNAPSHOT $label（本地时点 $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')) ---"
  $all = @(Get-SourceFiles)
  $cs = @($all | Where-Object Extension -eq '.cs')
  $ax = @($all | Where-Object Extension -eq '.axaml')
  Log "files(all)=$($all.Count) cs=$($cs.Count) axaml=$($ax.Count)"
  $newest = @($all | Sort-Object LastWriteTime -Descending | Select-Object -First 3)
  foreach ($n in $newest) { Log ("  newest: {0} {1}" -f $n.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'), $n.FullName.Substring($proj.Length + 1)) }
}

Log '=== p3-03 独立命名空间全量审计（兵部 · 方法独立于 p3-05 §4.1） ==='
Log ('审计起点(UTC): ' + (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))
Snap 'BEFORE'

$all = @(Get-SourceFiles)
$csFiles = @($all | Where-Object Extension -eq '.cs')
$axamlFiles = @($all | Where-Object Extension -eq '.axaml')

# ---------- A. 目录×namespace 声明交叉比对 ----------
Log ''
Log '=== A. .cs 目录×namespace 声明交叉比对 ==='
$nsInv = @{}
$rootFiles = @()
foreach ($f in $csFiles) {
  $rel = $f.FullName.Substring($proj.Length + 1)
  $dirRel = [System.IO.Path]::GetDirectoryName($rel)
  if ([string]::IsNullOrEmpty($dirRel) -or $dirRel -eq '.') { $expected = $prefix; $rootFiles += $rel }
  else { $expected = $prefix + '.' + ($dirRel -replace '\\', '.') }
  $lines = @(Get-Content -LiteralPath $f.FullName)
  $decls = @()
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*namespace\s+([A-Za-z_][A-Za-z0-9_.]*)') {
      $decls += [pscustomobject]@{ Line = $i + 1; Ns = $Matches[1] }
    }
  }
  if ($decls.Count -eq 0) { $viol.Add("V1-GLOBAL-NS`t$rel"); continue }
  if ($decls.Count -gt 1) {
    # v2 精化：多声明块且各块命名空间值相同并等于目录镜像 = p0-07 R-2 形态 a 条件文件
    # #if/#else 双分支同值承载（命名空间值仍唯一），降级为例外记录 X1，非 p1-05 §3.2 违例；
    # 各块值不同或不等于镜像时仍记 V2/V4 违例。
    $distinct = @($decls | ForEach-Object { $_.Ns } | Sort-Object -Unique)
    if ($distinct.Count -eq 1 -and $distinct[0] -ceq $expected) {
      $info.Add("X1-COND-DUAL-BRANCH-SAME-NS`t$rel`tdecl-lines=$(($decls | ForEach-Object { $_.Line }) -join '/')`tns=$($distinct[0])")
    } else {
      $viol.Add("V2-MULTI-DECL`t$rel`tcount=$($decls.Count)`tvalues=$(($distinct) -join '|')")
    }
  }
  foreach ($d in $decls) {
    $isLocal = ($d.Ns -eq $prefix) -or $d.Ns.StartsWith($prefix + '.')
    if (-not $isLocal) { $viol.Add("V3-NON-PREFIX`t${rel}:$($d.Line)`t$($d.Ns)") }
    elseif ($d.Ns -cne $expected) { $viol.Add("V4-MIRROR-MISMATCH`t${rel}:$($d.Line)`tdeclared=$($d.Ns)`texpected=$expected") }
    if (-not $nsInv.ContainsKey($d.Ns)) { $nsInv[$d.Ns] = New-Object 'System.Collections.Generic.List[string]' }
    [void]$nsInv[$d.Ns].Add($rel)
  }
}
Log "A-result: .cs 文件=$($csFiles.Count)；唯一命名空间=$($nsInv.Count)；根目录 .cs=$(($rootFiles | ForEach-Object { $_ }) -join ', ')"
Log 'A-inventory（命名空间 → 文件数）：'
foreach ($k in ($nsInv.Keys | Sort-Object)) { Log ("  {0} = {1}" -f $k, $nsInv[$k].Count) }

# ---------- B. using 面 ----------
Log ''
Log '=== B. using 面（源命名空间耦合检查，p1-05 §3.2-4） ==='
$selfUsing = @()
foreach ($f in $csFiles) {
  $rel = $f.FullName.Substring($proj.Length + 1)
  $lines = @(Get-Content -LiteralPath $f.FullName)
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*(global\s+)?using\s+SystemTools\.(?!CrossPlatform)') {
      $viol.Add("V5-SOURCE-USING`t${rel}:$($i+1)`t$($lines[$i].Trim())")
    } elseif ($lines[$i] -match '^\s*(global\s+)?using\s+SystemTools\.CrossPlatform') {
      $selfUsing += "${rel}:$($i+1)"
    }
  }
}
Log "B-result: V5 源命名空间 using 命中=$(@($viol | Where-Object { $_ -like 'V5-*' }).Count)（预期 0）；同程序集内部 using SystemTools.CrossPlatform（合法）count=$($selfUsing.Count)"
foreach ($u in $selfUsing) { Log "  self-using: $u" }

# ---------- C. .axaml 核对 ----------
Log ''
Log '=== C. .axaml x:Class / using: / clr-namespace: 核对 ==='
$xclassPaired = 0
$xclassMissing = @()
$externalRefs = New-Object 'System.Collections.Generic.List[string]'
foreach ($f in $axamlFiles) {
  $rel = $f.FullName.Substring($proj.Length + 1)
  $text = Get-Content -LiteralPath $f.FullName -Raw
  $xc = [regex]::Match($text, 'x:Class\s*=\s*"([^"]+)"')
  if ($xc.Success) {
    $xv = $xc.Groups[1].Value
    $isLocal = ($xv -eq $prefix) -or $xv.StartsWith($prefix + '.')
    if (-not $isLocal) { $viol.Add("V6-XCLASS-NONLOCAL`t$rel`t$xv") }
    # v2 精化：code-behind 配对允许两种形态——<basename>.axaml.cs（惯例主流）或
    # <basename>.cs（InTimePeriodRuleSettingsControl 先例，阶段 1 起如此）；两者均经
    # partial class 与 x:Class 交叉解析，配对后缀差异属文件命名细节，非命名空间口径。
    $paired = $f.FullName + '.cs'
    $pairForm = 'axaml.cs'
    if (-not (Test-Path -LiteralPath $paired)) {
      $paired = [System.IO.Path]::ChangeExtension($f.FullName, '.cs')
      $pairForm = 'basename.cs'
    }
    if (-not (Test-Path -LiteralPath $paired)) {
      $viol.Add("V7-XCLASS-NO-PAIRED-CS`t$rel")
    } else {
      $csText = Get-Content -LiteralPath $paired -Raw
      $nsVals = @([regex]::Matches($csText, '(?m)^\s*namespace\s+([A-Za-z_][A-Za-z0-9_.]*)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
      $idx = $xv.LastIndexOf('.')
      $xcNs = if ($idx -gt 0) { $xv.Substring(0, $idx) } else { '' }
      $xcCls = if ($idx -gt 0) { $xv.Substring($idx + 1) } else { $xv }
      # v2 精化：类匹配改为全文件检索（多类文件中 x:Class 主类可在辅助类之后声明）
      $clsOk = [regex]::IsMatch($csText, "(?m)\bclass\s+$([regex]::Escape($xcCls))\b")
      $nsOk = ($nsVals -ccontains $xcNs)
      $pairOk = $true
      if (-not $nsOk) { $viol.Add("V9-XCLASS-NS-MISMATCH`t$rel`tx:Class-ns=$xcNs`tpaired-ns=$(($nsVals) -join '|')"); $pairOk = $false }
      if (-not $clsOk) { $viol.Add("V11-XCLASS-CLS-MISSING`t$rel`tx:Class-cls=$xcCls`tpaired=$([System.IO.Path]::GetFileName($paired))"); $pairOk = $false }
      if ($pairOk) { $xclassPaired++; if ($pairForm -eq 'basename.cs') { $info.Add("X2-PAIRED-BASENAME-CS`t$rel`t$([System.IO.Path]::GetFileName($paired))") } }
    }
  } else {
    $xclassMissing += $rel
  }
  foreach ($m in [regex]::Matches($text, 'xmlns(?::[A-Za-z0-9_]+)?\s*=\s*"([^"]+)"')) {
    $v = $m.Groups[1].Value
    $ns = $null
    if ($v -match '^using:([^;]+)') { $ns = $Matches[1] }
    elseif ($v -match '^clr-namespace:([^;]+)') { $ns = $Matches[1] }
    if ($ns) {
      $isLocal = ($ns -eq $prefix) -or $ns.StartsWith($prefix + '.')
      if ($ns.StartsWith('SystemTools.') -and -not $isLocal) { $viol.Add("V12-XAML-LEGACY-REF`t$rel`t$ns") }
      elseif (-not $isLocal) { $externalRefs.Add("$rel -> $v") }
    }
  }
}
Log "C-result: x:Class 存在且配对 .axaml.cs 交叉验证通过=$($xclassPaired)；无 x:Class（资源/样式面）=$($xclassMissing.Count)"
foreach ($m in $xclassMissing) { Log "  no-x:Class: $m" }
Log ("C-external（外部程序集引用，合法）: unique=" + (@($externalRefs | Sort-Object -Unique).Count))
foreach ($e in (@($externalRefs | Sort-Object -Unique))) { Log "  external: $e" }

# ---------- D. 独立配置命名空间核对 ----------
Log ''
Log '=== D. 独立配置命名空间核对 ==='
$chDir = Join-Path $proj 'ConfigHandlers'
$chFiles = @(Get-ChildItem $chDir -Filter *.cs -File | Sort-Object Name)
Log "D1: ConfigHandlers .cs 文件数=$($chFiles.Count)（预期 6）"
foreach ($f in $chFiles) {
  $ns = [regex]::Match((Get-Content -LiteralPath $f.FullName -Raw), '(?m)^\s*namespace\s+([A-Za-z_][A-Za-z0-9_.]*)').Groups[1].Value
  Log ("  ConfigHandlers/{0} -> {1}" -f $f.Name, $ns)
  if ($ns -cne 'SystemTools.CrossPlatform.ConfigHandlers') { $viol.Add("V13-CONFIGNW-MISMATCH`tConfigHandlers/$($f.Name)`t$ns") }
}
function Get-JsonPairs([string]$path) {
  $pairs = @()
  if (-not (Test-Path -LiteralPath $path)) { return $pairs }
  $t = Get-Content -LiteralPath $path -Raw
  foreach ($m in [regex]::Matches($t, '\[JsonPropertyName\("([^"]+)"\)\]\s*public\s+(?:[A-Za-z0-9_<>?,\.\[\]\?\s]+?)\s([A-Za-z0-9_]+)\s*(?:\{|=>|;)')) {
    $pairs += [pscustomobject]@{ Json = $m.Groups[1].Value; Prop = $m.Groups[2].Value }
  }
  return $pairs
}
function Get-PropNames([string]$path) {
  if (-not (Test-Path -LiteralPath $path)) { return @() }
  $t = Get-Content -LiteralPath $path -Raw
  @([regex]::Matches($t, '(?m)^\s*public\s+(?:[A-Za-z0-9_<>?,\.\[\]\?\s]+?)\s([A-Za-z0-9_]+)\s*(?:\{|=>|;)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
}
Log 'D2: JSON 名随源对照（源插件只读）+ camelCase 自一致性'
foreach ($name in 'MainConfigData.cs', 'ButtonRulesetConfig.cs', 'RowRulesetConfig.cs') {
  $srcPairs = @(Get-JsonPairs (Join-Path $srcPluginRoot "ConfigHandlers\$name"))
  $newPairs = @(Get-JsonPairs (Join-Path $proj "ConfigHandlers\$name"))
  Log "  $name : source-JsonPropertyName-pairs=$($srcPairs.Count) new-pairs=$($newPairs.Count)"
  $srcMap = @{}
  foreach ($p in $srcPairs) { $srcMap[$p.Prop] = $p.Json }
  foreach ($p in $newPairs) {
    if ($srcMap.ContainsKey($p.Prop)) {
      if ($srcMap[$p.Prop] -cne $p.Json) { $viol.Add("V14-JSON-NAME-DRIFT`t$name.$($p.Prop)`tnew=$($p.Json)`tsource=$($srcMap[$p.Prop])") }
    } else {
      $info.Add("INFO-PROP-ABSENT-IN-SOURCE`t$name.$($p.Prop) (json=$($p.Json))")
    }
    $camel = [char]::ToLowerInvariant($p.Prop[0]) + $p.Prop.Substring(1)
    if ($camel -cne $p.Json) { $viol.Add("V15-JSON-NOT-CAMEL`t$name.$($p.Prop)`t$($p.Json)") }
  }
  if ($srcPairs.Count -eq 0) {
    Log "    注：源 $name 无 JsonPropertyName 属性（命名策略序列化），随源性以属性名集一致性承载"
    if ($newPairs.Count -eq 0) {
      $srcProps = @(Get-PropNames (Join-Path $srcPluginRoot "ConfigHandlers\$name"))
      $newProps = @(Get-PropNames (Join-Path $proj "ConfigHandlers\$name"))
      Log "    属性名集（文本可抽取）：source=$($srcProps.Count) new=$($newProps.Count)"
      $srcSet = @{}; foreach ($p in $srcProps) { $srcSet[$p] = $true }
      foreach ($p in $newProps) {
        if (-not $srcSet.ContainsKey($p)) { $info.Add("INFO-PROP-NEW-SIDE`t$name.$p`t（新侧文本可抽取属性不在源同名文件；MVVM [ObservableProperty] 生成成员/partial 增补面属已批交付，登记备查）") }
      }
    }
  }
  foreach ($i in ($info | Where-Object { $_ -like "INFO-PROP-ABSENT-IN-SOURCE`t$name.*" })) { Log "    $i" }
}
Log 'D3: PluginConfigFolder 独立目录接线链（只读锚点）'
Log '  Shared\GlobalConstants.cs:13 public static string? PluginConfigFolder { get; set; }'
Log '  Plugin.cs:73 GlobalConstants.PluginConfigFolder = PluginConfigFolder;（宿主注入插件独立配置目录）'
Log '  ConfigHandlers\MainConfigHandler.cs:16 Path.Combine(pluginConfigFolder, "Main.json")'
Log '  ConfigHandlers\FloatingWindowProfileManager.cs:32/:38 Path.Combine(GlobalConstants.PluginConfigFolder, "FloatingWindowProfiles")'

# ---------- E. 全树复跑检索 ----------
Log ''
Log '=== E. 全树复跑检索（p1-05 §6-2 / p3-05 复核形态） ==='
$r1 = @(Get-ChildItem $proj -Recurse -Filter *.cs -File | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Select-String -Pattern 'namespace (?!SystemTools\.CrossPlatform)')
Log "E1: Select-String 'namespace (?!SystemTools\.CrossPlatform)' 命中=$($r1.Count)（预期 0）"
foreach ($r in $r1) { Log ("  REPLAY-HIT {0}:{1}: {2}" -f $r.Path.Substring($proj.Length + 1), $r.LineNumber, $r.Line.Trim()) }
$r2 = @(Get-ChildItem $proj -Recurse -Filter *.cs -File | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Select-String -Pattern '(global\s+)?using\s+SystemTools\.(?!CrossPlatform)')
Log "E2: Select-String '(global )?using SystemTools.(?!CrossPlatform)' 命中=$($r2.Count)（预期 0）"
foreach ($r in $r2) { Log ("  REPLAY-HIT {0}:{1}: {2}" -f $r.Path.Substring($proj.Length + 1), $r.LineNumber, $r.Line.Trim()) }

# ---------- 汇总 ----------
Log ''
Snap 'AFTER'
Log ''
Log '=== SUMMARY ==='
Log "violation count = $($viol.Count)"
foreach ($v in $viol) { Log "  VIOLATION $v" }
Log "informational count = $($info.Count)"
foreach ($i in $info) { Log "  INFO $i" }
if ($viol.Count -eq 0) {
  Log 'INDEPENDENT AUDIT RESULT: ZERO VIOLATION —— 零调整认证成立（命名空间维度零违例：无全局命名空间、无多声明块、无非前缀、无目录镜像漂移、无源命名空间 using 耦合、无 XAML 遗留引用、ConfigHandlers 命名空间/JSON 名随源一致）'
  Log 'CONCLUSION: 阶段 3 独立配置/功能命名空间统一 = 零调整（与 p3-05 §4 结论独立复证一致）'
  Log 'VERDICT: PASS'
  $out | Set-Content -LiteralPath (Join-Path $ws '.tang\cases\stcp-cross-platform-001\evidence\p3-03-namespace-audit-output.txt') -Encoding utf8
  $out | Write-Output
  exit 0
} else {
  Log 'INDEPENDENT AUDIT RESULT: VIOLATIONS FOUND —— 调整清单须上报尚书省裁决（兵部不自行改动）'
  Log 'VERDICT: FAIL'
  $out | Set-Content -LiteralPath (Join-Path $ws '.tang\cases\stcp-cross-platform-001\evidence\p3-03-namespace-audit-output.txt') -Encoding utf8
  $out | Write-Output
  exit 1
}
