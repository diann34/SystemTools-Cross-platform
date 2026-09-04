<#
p3-03 兵部 · Roslyn 全量解析复跑（非写入型，p1-06/p2-06 验证批先例形态）
目的：命名空间认证的 Roslyn 支撑证据——163 个 .cs 全量经 Microsoft.CodeAnalysis.CSharp
解析器解析，语法级 error 诊断 = 0（证明命名空间/using 层面无语法性破坏）。
边界：仅解析诊断，不产出程序集/obj/bin（本批写入范围限定 evidence/，沙箱与派工约束⑤）；
语义级编译门禁引 p2-10 NuGet 后备双 TFM 构建（exit=0、编译错误=0，权威口径），
其与本审计时点树的唯一差异（并行批 p3-01 对 SystemToolsSettingsViewModel.cs 的触碰）
语义级验证归 p3-01 批内编译门禁。
退出码：0 = 解析 error=0；1 = 存在解析 error。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Location).Path
$proj = Join-Path $ws 'src\SystemTools.CrossPlatform'
$out = New-Object System.Collections.Generic.List[string]
function Log([string]$s) { $script:out.Add($s) }

$roslynDir = $null
foreach ($cand in @(Get-ChildItem 'C:\Program Files\dotnet\sdk' -Directory | Sort-Object Name -Descending)) {
  $p = Join-Path $cand.FullName 'Roslyn\bincore\Microsoft.CodeAnalysis.CSharp.dll'
  if (Test-Path $p) { $roslynDir = $p; break }
}
if (-not $roslynDir) { throw 'Roslyn bincore 未找到' }
Log "Roslyn: $roslynDir"
Add-Type -Path ($roslynDir -replace 'Microsoft\.CodeAnalysis\.CSharp\.dll$', 'Microsoft.CodeAnalysis.dll')
Add-Type -Path $roslynDir

$files = @(Get-ChildItem $proj -Recurse -Filter *.cs -File | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Sort-Object FullName)
Log "parse-scope .cs files: $($files.Count)"
$parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::new(
  [Microsoft.CodeAnalysis.CSharp.LanguageVersion]::CSharp13,
  [Microsoft.CodeAnalysis.DocumentationMode]::Parse,
  [Microsoft.CodeAnalysis.SourceCodeKind]::Regular)

$errorCount = 0
$warningCount = 0
foreach ($f in $files) {
  $tree = [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content -LiteralPath $f.FullName -Raw), $parseOpts, $f.FullName)
  $diags = @($tree.GetDiagnostics())
  $errs = @($diags | Where-Object { $_.Severity -eq [Microsoft.CodeAnalysis.DiagnosticSeverity]::Error })
  $warns = @($diags | Where-Object { $_.Severity -eq [Microsoft.CodeAnalysis.DiagnosticSeverity]::Warning })
  $errorCount += $errs.Count
  $warningCount += $warns.Count
  foreach ($d in $errs) {
    $ls = $d.Location.GetLineSpan()
    Log ("PARSE-ERROR {0}:{1}: {2} CS{3}: {4}" -f $f.FullName.Substring($proj.Length + 1), ($ls.StartLinePosition.Line + 1), $d.Severity, $d.Id, $d.GetMessage())
  }
}
Log "Roslyn parse diagnostics: files=$($files.Count) error=$errorCount warning=$warningCount"
if ($errorCount -eq 0) {
  Log 'VERDICT: PASS（Roslyn 全量解析 error=0）'
  $out | Set-Content -LiteralPath (Join-Path $ws '.tang\cases\stcp-cross-platform-001\evidence\p3-03-roslyn-parse-output.txt') -Encoding utf8
  $out | Write-Output
  exit 0
} else {
  Log 'VERDICT: FAIL（存在解析 error，逐条见上）'
  $out | Set-Content -LiteralPath (Join-Path $ws '.tang\cases\stcp-cross-platform-001\evidence\p3-03-roslyn-parse-output.txt') -Encoding utf8
  $out | Write-Output
  exit 1
}
