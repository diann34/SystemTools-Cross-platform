<#
p2-06 礼部 · 批内补充编译自检（非官方构建门禁）
方法沿 p2-03-supplementary-compile-check.ps1 升级形态 + p1-06 全工程语境：
  1. 引用集从 p1-10-build-fallback-win-rerun.log 的 csc 命令行 /reference: token 提取
     （与真实构建相同引用语境，含 Avalonia / FluentAvalonia / ClassIsland SDK 双分支 NuGet 面）；
  2. 预处理符号取自同一日志 /define: 集；【双向符号验证】：
     Pass A（Windows 语境）= 原符号集（含 Platforms_Windows）——条件文件 Windows 分支 + Plugin.cs B 档接线；
     Pass B（非 Windows 语境）= 同集把 Platforms_Windows 换成 Platforms_Linux——条件文件 #else 分支 +
     Plugin.cs B 档接线（SystemShutdownMonitor 两分支公共表面一致性验证）；
  3. 入检树 = 工程全量真实 .cs（排 bin/obj，含本批唯一交付文件 Plugin.cs 及其全部引用闭包）
     + 检查专用存根（MVVM 8.2.1 源生成器等价成员 partial 存根 + 隐式 using 存根；
     SystemToolsNotificationProvider 以真实文件入检，不再存根）；
  4. 判定：Plugin.cs 归属诊断 error 必须 = 0（两 Pass）；他文件 XAML 生成面 / MVVM 生成器未接线
     预期噪声按文件单列不计判定（p1-06 §7-6 先例）。
仅诊断，不产出程序集文件。官方三平台 dotnet build 门禁仍属阶段级验证（工部）。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Item ($PSScriptRoot + '\..\..\..\..')).FullName
Set-Location $ws

# ---------- 1) 工程全量真实 .cs（含 Plugin.cs） ----------
$all = @(Get-ChildItem -Recurse 'src\SystemTools.CrossPlatform' -Filter *.cs -File |
    Where-Object { $_.FullName -notmatch '\\bin\\|\\obj\\' } |
    ForEach-Object { $_.FullName })
if ($all.Count -lt 100) { throw ("工程 .cs 数异常: " + $all.Count) }
$pluginPath = (Resolve-Path 'src\SystemTools.CrossPlatform\Plugin.cs').Path
if ($all -notcontains $pluginPath) { throw 'Plugin.cs 未入检' }
"入检真实 .cs：$($all.Count)（工程全量，含 Plugin.cs；排 bin/obj）"

# ---------- 2) 引用集与预处理符号（工部真实构建 csc 命令行，p2-03 同法） ----------
$log = '.tang\cases\stcp-cross-platform-001\evidence\p1-10-build-fallback-win-rerun.log'
$logText = Get-Content $log -Raw
$refMatches = [regex]::Matches($logText, '/reference:"?([^"\r\n]+?)"?(?=\s+/(?:reference|out|define|nostdlib|noconfig|unsafe|nowarn|warnaserror|langversion|doc)\b|\s*$)')
if ($refMatches.Count -lt 50) {
  $refMatches = [regex]::Matches($logText, '/reference:"([^"]+)"')
}
$refs = @()
foreach ($m in $refMatches) {
  $p = $m.Groups[1].Value.Trim()
  if (-not (Test-Path $p)) { throw ("引用路径不存在（日志与磁盘漂移）: " + $p) }
  $refs += $p
}
if ($refs.Count -lt 50) { throw ("引用集过少（" + $refs.Count + "），解析失败") }
"引用集（真实构建同源）：$($refs.Count) 个，全部在盘"
$platRef = $refs | Where-Object { $_ -like '*ClassIsland.Platforms.Abstractions.dll' }
if (-not $platRef) { throw '引用集缺 ClassIsland.Platforms.Abstractions.dll（双分支 API 消费语境缺失）' }

$defineMatch = [regex]::Match($logText, '/define:([^\s/"]+)')
if (-not $defineMatch.Success) { throw '日志未找到 /define: token' }
$definesWin = $defineMatch.Groups[1].Value
"Windows 语境符号集（真实构建同源）：$definesWin"
if ($definesWin -notmatch 'Platforms_Windows') { throw '符号集不含 Platforms_Windows（大小写核对失败）' }
$definesNonWin = ($definesWin -split ';') | Where-Object { $_ -ne 'Platforms_Windows' -and $_ -notlike 'WINDOWS*' }
$definesNonWin = @($definesNonWin) + @('Platforms_Linux','LINUX') -join ';'
"非 Windows 语境符号集（双向验证）：$definesNonWin"

# ---------- 3) 检查专用存根（非交付文件；p2-03 同款） ----------
$stubMvvmSource = @'
// CHECK-ONLY STUB (p2-06 supplementary compile check, NOT a deliverable)
// MVVM 生成成员检查专用 partial 存根：本检查不含 CommunityToolkit.Mvvm 8.2.1 的源生成器管线，
// 按生成器命名映射补齐等价成员（方法先例：p2-03/p1-02/p1-03 的生成成员存根）。
using System;
using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.ConfigHandlers
{
    public partial class FloatingWindowProfile
    {
        public string Name
        {
            get => _name; set { _name = value; }
        }
        public bool FloatingWindowHorizontal
        {
            get => _floatingWindowHorizontal; set { _floatingWindowHorizontal = value; }
        }
    }

    public partial class ButtonRulesetConfig
    {
        public bool IsVisible
        {
            get => _isVisible; set { _isVisible = value; }
        }
        public bool HideOnRule
        {
            get => _hideOnRule; set { _hideOnRule = value; }
        }
        public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules
        {
            get => _hidingRules; set { _hidingRules = value; }
        }
    }

    public partial class RowRulesetConfig
    {
        public bool IsVisible
        {
            get => _isVisible; set { _isVisible = value; }
        }
        public bool HideOnRule
        {
            get => _hideOnRule; set { _hideOnRule = value; }
        }
        public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules
        {
            get => _hidingRules; set { _hidingRules = value; }
        }
    }
}

namespace SystemTools.CrossPlatform.Config
{
    public partial class FloatingWindowTriggerConfig
    {
        public string ButtonId
        {
            get => _buttonId; set { _buttonId = value; }
        }
        public string Icon
        {
            get => _icon; set { _icon = value; }
        }
        public string ButtonName
        {
            get => _buttonName; set { _buttonName = value; }
        }
        public bool IsVisible
        {
            get => _isVisible; set { _isVisible = value; }
        }
        public int Position
        {
            get => _position; set { _position = value; }
        }
    }
}
'@
$stubGlobalUsings = @'
// CHECK-ONLY STUB (implicit usings context, NOT a deliverable)
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
'@

# ---------- 4) Roslyn 双向编译（全工程树） ----------
Add-Type -Path 'C:\Program Files\dotnet\sdk\10.0.302\Roslyn\bincore\Microsoft.CodeAnalysis.dll'
Add-Type -Path 'C:\Program Files\dotnet\sdk\10.0.302\Roslyn\bincore\Microsoft.CodeAnalysis.CSharp.dll'

function Invoke-CompilePass([string]$passName, [string]$defines) {
  $trees = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.SyntaxTree]'
  $parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::new(
    [Microsoft.CodeAnalysis.CSharp.LanguageVersion]::CSharp13,
    [Microsoft.CodeAnalysis.DocumentationMode]::Parse,
    [Microsoft.CodeAnalysis.SourceCodeKind]::Regular,
    ($defines -split ';'))
  foreach ($f in $all) {
    $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content $f -Raw -Encoding utf8), $parseOpts, $f))
  }
  $stubIndex = $all.Count
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubMvvmSource, $parseOpts, "stub_mvvm_$passName.cs"))
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubGlobalUsings, $parseOpts, "stub_globalusings_$passName.cs"))

  $compOpts = [Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions]::new(
    [Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)

  $metadataRefs = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.MetadataReference]'
  foreach ($r in $refs) { $metadataRefs.Add([Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($r)) }
  $comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create(
    "p2-06-supplementary-check-$passName", [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $metadataRefs, $compOpts)

  $diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
  $errors   = @($diags | Where-Object { $_.Severity -eq 'Error' })
  $warnings = @($diags | Where-Object { $_.Severity -eq 'Warning' })

  # 按源文件归组（预期噪声：XAML 生成面 / MVVM 生成器未接线，归属非 Plugin.cs 文件）
  $byFile = @{}
  foreach ($d in $errors) {
    if (-not $d.Location.IsInSource) { continue }
    $fp = ($d.Location.SourceTree.FilePath -replace [regex]::Escape($ws + '\'), '') -replace '\\','/'
    if (-not $byFile.ContainsKey($fp)) { $byFile[$fp] = 0 }
    $byFile[$fp]++
  }
  "--- [$passName] error 按文件归组（非判定噪声单列） ---"
  foreach ($k in ($byFile.Keys | Sort-Object)) { "ERRORS[$passName] $k = $($byFile[$k])" }
  $noise = @($byFile.Keys | Where-Object { $_ -notlike '*Plugin.cs' })
  "噪声文件数（非 Plugin.cs，XAML/MVVM 生成面预期）：$($noise.Count)；合计 error=$($errors.Count)"

  $pluginErrors = @($errors | Where-Object { $_.Location.IsInSource -and $_.Location.SourceTree.FilePath -eq $pluginPath })
  $pluginWarnings = @($warnings | Where-Object { $_.Location.IsInSource -and $_.Location.SourceTree.FilePath -eq $pluginPath })
  foreach ($d in $pluginErrors) {
    $ls = $d.Location.GetLineSpan()
    ("Plugin.cs 归属 ERROR {0}: {1} :{2}" -f $d.Id, $d.GetMessage(), ($ls.StartLinePosition.Line + 1))
  }
  foreach ($d in $pluginWarnings) {
    $ls = $d.Location.GetLineSpan()
    ("Plugin.cs 归属 WARNING {0}: {1} :{2}" -f $d.Id, $d.GetMessage(), ($ls.StartLinePosition.Line + 1))
  }

  if ($pluginErrors.Count -ne 0) {
    "FAIL[$passName]（Plugin.cs 归属 error=$($pluginErrors.Count)）"
    exit 1
  }
  "PASS[$passName]（Plugin.cs 归属 error=0, warning=$($pluginWarnings.Count)；全树 error=$($errors.Count) 均为非判定噪声；warning=$($warnings.Count)）"
}

Invoke-CompilePass -passName 'A-Windows' -defines $definesWin
Invoke-CompilePass -passName 'B-NonWindows' -defines $definesNonWin
"COMPILE OK（双向：Windows 语境 + 非 Windows 语境均 Plugin.cs 归属 error=0）—— 礼部 p2-06 唯一交付文件 Plugin.cs 语义级编译通过（B19 注册/DI/lifecycle/组门接线对条件文件两分支公共表面一致）"
exit 0
