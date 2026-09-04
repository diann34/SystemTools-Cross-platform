<#
p3-01 兵部 · 批内补充编译自检（非官方构建门禁；Roslyn 升级法，方法沿 p2-06-supplementary-compile-check.ps1）
  1. 引用集从 p1-10-build-fallback-win-rerun.log 的 csc 命令行 /reference: token 提取
     （与真实构建相同引用语境，含 Avalonia 12.1.1 / Avalonia.Controls.DataGrid 12.0.0 /
       FluentAvalonia / CommunityToolkit.Mvvm / ClassIsland SDK 双分支面）；
  2. 预处理符号取自同一日志 /define: 集；【双向符号验证】：
     Pass A（Windows 语境）= 原符号集（含 Platforms_Windows）；
     Pass B（非 Windows 语境）= 同集去 Platforms_Windows/WINDOWS* 换 Platforms_Linux/LINUX
     （本批零新增条件面，双 Pass 语义等价，按派工约束 5 仍执行双向）；
  3. 入检树 = 工程全量真实 .cs（排 bin/obj，含本批 3 个交付 .cs 及其引用闭包）
     + 检查专用存根（非交付文件）：
       a) MVVM 8.2.1 源生成器等价成员 partial 存根（p2-03/p2-06 先例）：FloatingWindowProfile/
          ButtonRulesetConfig/RowRulesetConfig/FloatingWindowTriggerConfig（p2-06 存根沿用）+
          FloatingTriggerItem/FloatingTriggerRow（p3-02 类型）+ UnifiedFeatureItem/
          SystemToolsSettingsViewModel 可观察成员（p3-01 类型）——生成属性包装真实字段；
       b) 隐式 using 存根（p1-02 CS0104 升级法）；
       c) XAML 生成 InitializeComponent 存根：SystemToolsSettingsPage/MoreFeaturesOptionsSettingsPage
          （本批两交付 .axaml.cs 的调用点；他页 XAML 生成面缺失按噪声单列，p1-06 §7-6 先例）；
  4. 判定：本批 3 个交付文件归属诊断 error 必须 = 0（双 Pass）；他文件 XAML 生成面 / MVVM 生成器
     未接线预期噪声按文件单列不计判定。
仅诊断，不产出程序集文件。官方三平台 dotnet build 门禁仍属阶段级验证（工部）。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Item ($PSScriptRoot + '\..\..\..\..')).FullName
Set-Location $ws

# ---------- 1) 工程全量真实 .cs ----------
$all = @(Get-ChildItem -Recurse 'src\SystemTools.CrossPlatform' -Filter *.cs -File |
    Where-Object { $_.FullName -notmatch '\\bin\\|\\obj\\' } |
    ForEach-Object { $_.FullName })
if ($all.Count -lt 100) { throw ("工程 .cs 数异常: " + $all.Count) }
$judged = @(
  (Resolve-Path 'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsPage.axaml.cs').Path,
  (Resolve-Path 'src\SystemTools.CrossPlatform\SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs').Path,
  (Resolve-Path 'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs').Path
)
foreach ($j in $judged) { if ($all -notcontains $j) { throw ("交付文件未入检: " + $j) } }
"入检真实 .cs：$($all.Count)（工程全量，排 bin/obj）；判定文件 3 个（p3-01 交付面）"

# ---------- 2) 引用集与预处理符号（工部真实构建 csc 命令行，p2-03/p2-06 同法） ----------
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
foreach ($must in @('CommunityToolkit.Mvvm','Avalonia.Controls.DataGrid','ClassIsland.Platforms.Abstractions','FluentAvalonia')) {
  if (-not ($refs | Where-Object { $_ -like "*$must*" })) { throw ("引用集缺 $must") }
}

$defineMatch = [regex]::Match($logText, '/define:([^\s/"]+)')
if (-not $defineMatch.Success) { throw '日志未找到 /define: token' }
$definesWin = $defineMatch.Groups[1].Value
"Windows 语境符号集（真实构建同源）：$definesWin"
if ($definesWin -notmatch 'Platforms_Windows') { throw '符号集不含 Platforms_Windows（大小写核对失败）' }
$definesNonWin = ($definesWin -split ';') | Where-Object { $_ -ne 'Platforms_Windows' -and $_ -notlike 'WINDOWS*' }
$definesNonWin = @($definesNonWin) + @('Platforms_Linux','LINUX') -join ';'
"非 Windows 语境符号集（双向验证）：$definesNonWin"

# ---------- 3) 检查专用存根（非交付文件） ----------
$stubMvvmSource = @'
// CHECK-ONLY STUB (p3-01 supplementary compile check, NOT a deliverable)
// MVVM 8.2.1 源生成器等价成员 partial 存根（方法先例：p2-03/p1-02/p1-03/p2-06 生成成员存根）；
// 生成属性包装真实 partial 类中的 [ObservableProperty] 字段（字段在真实文件内，存根仅补生成属性面）。
using System;
using System.Collections.ObjectModel;
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

namespace SystemTools.CrossPlatform.SettingsPage
{
    using SystemTools.CrossPlatform.ConfigHandlers;

    public partial class FloatingTriggerItem
    {
        // MVVM 8.2.1 生成器等价 defining declaration（真实构建由源生成器产出；
        // 独立编译语境无生成器，故存根按生成器命名约定补齐，p2-06 存根方法同源）。
        partial void OnIconChanged(string value);

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
        public ButtonRulesetConfig Config
        {
            get => _config; set { _config = value; }
        }
    }

    public partial class FloatingTriggerRow
    {
        public ObservableCollection<FloatingTriggerItem> Buttons
        {
            get => _buttons; set { _buttons = value; }
        }
        public int RowIndex
        {
            get => _rowIndex; set { _rowIndex = value; }
        }
        public RowRulesetConfig RowRuleset
        {
            get => _rowRuleset; set { _rowRuleset = value; }
        }
    }

    public partial class UnifiedFeatureItem
    {
        public string Id
        {
            get => _id; set { _id = value; }
        }
        public string DisplayName
        {
            get => _displayName; set { _displayName = value; }
        }
        public bool IsEnabled
        {
            get => _isEnabled; set { _isEnabled = value; }
        }
        public FeatureItemType ItemType
        {
            get => _itemType; set { _itemType = value; }
        }
        public string? GroupName
        {
            get => _groupName; set { _groupName = value; }
        }
    }

    public partial class SystemToolsSettingsViewModel
    {
        public ObservableCollection<UnifiedFeatureItem> FeatureItems
        {
            get => _featureItems; set { _featureItems = value; }
        }
        public ObservableCollection<UnifiedFeatureItem> FeatureSearchResults
        {
            get => _featureSearchResults; set { _featureSearchResults = value; }
        }
        public bool IsFeatureDrawerOpen
        {
            get => _isFeatureDrawerOpen; set { _isFeatureDrawerOpen = value; }
        }
        public object? FeatureDrawerContent
        {
            get => _featureDrawerContent; set { _featureDrawerContent = value; }
        }
    }

    // XAML 生成 InitializeComponent 存根（仅覆盖本批两交付页的调用点；Avalonia XAML 编译器
    // 生成面在真实构建产出，独立编译语境按 p1-06 §7-6 噪声口径以存根补齐判定文件）。
    public partial class SystemToolsSettingsPage
    {
        public void InitializeComponent() { }
    }

    public partial class MoreFeaturesOptionsSettingsPage
    {
        public void InitializeComponent() { }
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
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubMvvmSource, $parseOpts, "stub_mvvm_$passName.cs"))
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubGlobalUsings, $parseOpts, "stub_globalusings_$passName.cs"))

  $compOpts = [Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions]::new(
    [Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)

  $metadataRefs = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.MetadataReference]'
  foreach ($r in $refs) { $metadataRefs.Add([Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($r)) }
  $comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create(
    "p3-01-supplementary-check-$passName", [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $metadataRefs, $compOpts)

  $diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
  $errors   = @($diags | Where-Object { $_.Severity -eq 'Error' })
  $warnings = @($diags | Where-Object { $_.Severity -eq 'Warning' })

  # 按源文件归组（预期噪声：XAML 生成面 / MVVM 生成器未接线，归属非判定文件）
  $byFile = @{}
  foreach ($d in $errors) {
    if (-not $d.Location.IsInSource) { continue }
    $fp = ($d.Location.SourceTree.FilePath -replace [regex]::Escape($ws + '\'), '') -replace '\\','/'
    if (-not $byFile.ContainsKey($fp)) { $byFile[$fp] = 0 }
    $byFile[$fp]++
  }
  "--- [$passName] error 按文件归组（非判定噪声单列） ---"
  foreach ($k in ($byFile.Keys | Sort-Object)) { "ERRORS[$passName] $k = $($byFile[$k])" }
  $judgedRel = @($judged | ForEach-Object { ($_ -replace [regex]::Escape($ws + '\'), '') -replace '\\','/' })
  $noiseKeys = @($byFile.Keys | Where-Object { $judgedRel -notcontains $_ })
  "噪声文件数（非判定文件，XAML/MVVM 生成面预期）：$($noiseKeys.Count)；全树 error=$($errors.Count)"

  # 段归属分类：共享 VM（SystemToolsSettingsViewModel.cs）为 p3-01/p3-02 并行批共存文件，
  # 以 `===== p3-02 增补开始/结束 =====` 界标实测行区间划出 p3-02 段；该段归属诊断单列不计判定
  # （尚书省裁决④：对方段缺陷只上报不修复）；p3-01 交付段（VM 其余行 + 两页交付文件）诊断 = 判定。
  $vmPath = (Resolve-Path 'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs').Path
  $vmLines = Get-Content $vmPath
  $p302Ranges = @()
  $openLine = $null
  for ($i = 0; $i -lt $vmLines.Count; $i++) {
    if ($vmLines[$i] -match '===== p3-02 增补开始' -and $null -eq $openLine) { $openLine = $i + 1 }
    if ($vmLines[$i] -match '===== p3-02 增补结束' -and $null -ne $openLine) { $p302Ranges += ,@($openLine, ($i + 1)); $openLine = $null }
  }
  if ($openLine) { $p302Ranges += ,@($openLine, $vmLines.Count) }
  $rangesText = ($p302Ranges | ForEach-Object { ("{0}-{1}" -f $_[0], $_[1]) }) -join ', '
  "p3-02 界标段（实测，行号动态解析）：$rangesText"

  function Test-InP302Range([Microsoft.CodeAnalysis.Diagnostic]$d) {
    if ($d.Location.SourceTree.FilePath -ne $vmPath) { return $false }
    $line = $d.Location.GetLineSpan().StartLinePosition.Line + 1
    foreach ($r in $p302Ranges) { if ($line -ge $r[0] -and $line -le $r[1]) { return $true } }
    return $false
  }

  # 判定文件 + 段归属 + 存根归属诊断全量打印（stub 自身必须零诊断；p3-01 交付面必须零诊断；
  # p3-02 段归属诊断如实列示上报，不计判定）
  $stubErrors = @($errors | Where-Object { $_.Location.IsInSource -and $_.Location.SourceTree.FilePath -like '*stub_mvvm_*' })
  foreach ($d in $stubErrors) {
    $ls = $d.Location.GetLineSpan()
    ("STUB 归属 ERROR {0}: {1} :{2}" -f $d.Id, $d.GetMessage(), ($ls.StartLinePosition.Line + 1))
  }
  $judgedErrors = @()
  $p302OwnedErrors = @()
  foreach ($d in $errors) {
    if (-not $d.Location.IsInSource) { continue }
    if ($judged -contains $d.Location.SourceTree.FilePath) {
      if (Test-InP302Range $d) { $p302OwnedErrors += $d }
      else { $judgedErrors += $d }
    }
  }
  foreach ($d in $p302OwnedErrors) {
    $ls = $d.Location.GetLineSpan()
    ("p3-02 段归属 ERROR（上报不计判定）{0}: {1} :{2}" -f $d.Id, $d.GetMessage(), ($ls.StartLinePosition.Line + 1))
  }
  foreach ($d in $judgedErrors) {
    $ls = $d.Location.GetLineSpan()
    ("判定文件归属 ERROR {0}: {1} :{2} [{3}]" -f $d.Id, $d.GetMessage(), ($ls.StartLinePosition.Line + 1), ($d.Location.SourceTree.FilePath -replace [regex]::Escape($ws + '\'), ''))
  }

  if ($judgedErrors.Count -ne 0 -or $stubErrors.Count -ne 0) {
    "FAIL[$passName]（p3-01 判定面归属 error=$($judgedErrors.Count)；stub 归属 error=$($stubErrors.Count)；p3-02 段归属 error=$($p302OwnedErrors.Count)（已上报））"
    exit 1
  }
  "PASS[$passName]（p3-01 判定面 error=0；stub 归属 error=0；p3-02 段归属 error=$($p302OwnedErrors.Count)（如实列示上报，不计判定）；全树 error=$($errors.Count) 其余为非判定噪声；warning=$($warnings.Count)）"
}

Invoke-CompilePass -passName 'A-Windows' -defines $definesWin
Invoke-CompilePass -passName 'B-NonWindows' -defines $definesNonWin
"COMPILE OK（双向：Windows 语境 + 非 Windows 语境均 p3-01 判定 3 文件归属 error=0）—— 兵部 p3-01 交付面（SystemToolsSettingsPage.axaml.cs / MoreFeaturesOptionsSettingsPage.axaml.cs / SystemToolsSettingsViewModel.cs）语义级编译通过"
exit 0
