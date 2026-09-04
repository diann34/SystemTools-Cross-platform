<#
p1-03 兵部 · 批内补充编译自检 v2（非官方构建门禁；p1-10 修复复验用）
方法同 p1-02-supplementary-compile-check.ps1（v2 形态）：当前进程内 Roslyn，每文件一棵 SyntaxTree。
升级点：
  1. 引用集从工部 p1-10-build-fallback-win-rerun.log 的 csc 命令行 /reference: token 提取
     （与真实构建完全相同的引用语境，含 Avalonia 12.1.1 ref 链 / FluentAvalonia / ClassIsland SDK）；
  2. 预处理符号取自同一日志 /define: 集（Platforms_Windows 等），条件编译语境一致；
  3. 对兵部 p1-03 批 44 个交付 .cs 全量重编（p1-02 为 15 文件）；
  4. 跨批依赖以检查专用存根承接（非交付文件）：SystemToolsNotificationProvider（继承 SDK
     NotificationProviderBase，ShowNotification 消费面 100% 真实）、AiChatWindowService（ShowAsync→Task，
     签名对照 p1-04 真实交付 Services\AiChatWindowService.cs:21）。真实成员面由工部官方构建验证。
仅诊断，不产出程序集文件。官方三平台 dotnet build 门禁仍属阶段级验证。
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot  # .tang/cases/stcp-cross-platform-001/evidence -> .tang/cases/stcp-cross-platform-001
$ws   = (Get-Item ($PSScriptRoot + '\..\..\..\..')).FullName
Set-Location $ws

# ---------- 1) 批内 44 个交付 .cs（兵部 p1-03） ----------
$prefix = 'src\SystemTools.CrossPlatform'
$names = @{
  'Actions' = @('KillProcessAction','ShowToastAction','ToggleFloatingWindowProfileAction','SwitchFloatingWindowThemeAction','BackgroundPlayAudioAction','ActionFlowExecutionConfirmationAction','TriggerCustomTriggerAction','ToggleWorkflowAction','ShowAiChatDialogAction','FullscreenClockAction','ClearAllNotificationsAction','LoadTemporaryClassPlanAction','OpenAppSettingsAction','OpenProfileEditorAction','OpenClassSwapWindowAction')
  'Settings' = @('KillProcessSettings','ShowToastSettings','ToggleFloatingWindowProfileSettings','SwitchFloatingWindowThemeSettings','BackgroundPlayAudioSettings','ActionFlowExecutionConfirmationSettings','TriggerCustomTriggerSettings','ToggleWorkflowSettings','FullscreenClockSettings','LoadTemporaryClassPlanSettings','ShortcutKeyNotificationSettings')
  'Controls' = @('KillProcessSettingsControl','ShowToastSettingsControl','ToggleFloatingWindowProfileSettingsControl','SwitchFloatingWindowThemeSettingsControl','BackgroundPlayAudioSettingsControl','ActionFlowExecutionConfirmationSettingsControl','TriggerCustomTriggerSettingsControl','ToggleWorkflowSettingsControl','FullscreenClockSettingsControl','LoadTemporaryClassPlanSettingsControl','ShortcutKeyNotificationSettingsControl')
  'ConfigHandlers' = @('MainConfigData','MainConfigHandler','FloatingWindowProfile','FloatingWindowProfileManager','ButtonRulesetConfig','RowRulesetConfig')
}
$files = @()
foreach ($dir in $names.Keys) { foreach ($n in $names[$dir]) { $files += Join-Path $prefix "$dir\$n.cs" } }
$files += Join-Path $prefix 'Shared\GlobalConstants.cs'
$missing = @($files | Where-Object { -not (Test-Path $_) })
if ($missing.Count -gt 0) { throw ("清单文件缺失: " + ($missing -join ', ')) }
"批内交付 .cs：$($files.Count)（预期 44）"
if ($files.Count -ne 44) { throw '交付文件数不等于 44，清单漂移' }

# ---------- 2) 检查专用存根（非交付文件） ----------
$stubServicesSource = @'
// CHECK-ONLY STUBS (p1-03 supplementary compile check, NOT deliverables)
namespace SystemTools.CrossPlatform.Services;

// 消费面存根：继承 SDK NotificationProviderBase，ShowNotification 公共方法来自基类（引用集内真实 SDK 类型）。
public class SystemToolsNotificationProvider : ClassIsland.Core.Abstractions.Services.NotificationProviders.NotificationProviderBase
{
}

// 签名忠实存根：对照 p1-04 真实交付 Services\AiChatWindowService.cs:21（public async Task ShowAsync()）。
public sealed class AiChatWindowService
{
    public async Task ShowAsync() { await Task.CompletedTask; }
}
'@
$stubMvvmSource = @'
// CHECK-ONLY STUB (p1-03 supplementary compile check, NOT a deliverable)
// MVVM 生成成员检查专用 partial 存根：本检查不含 CommunityToolkit.Mvvm 8.2.1 的 [ObservableProperty]
// 源生成器管线（真实构建由源生成器产出下列属性），按生成器命名映射补齐等价成员，
// 使独立编译与真实构建语境等效（方法先例：p1-02 的 InitializeComponent 存根）。
namespace SystemTools.CrossPlatform.ConfigHandlers;

public partial class FloatingWindowProfile
{
    public string Name { get => _name; set => _name = value; }
    public bool FloatingWindowHorizontal { get => _floatingWindowHorizontal; set => _floatingWindowHorizontal = value; }
}

public partial class ButtonRulesetConfig
{
    public bool IsVisible { get => _isVisible; set => _isVisible = value; }
    public bool HideOnRule { get => _hideOnRule; set => _hideOnRule = value; }
    public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules { get => _hidingRules; set => _hidingRules = value; }
}

public partial class RowRulesetConfig
{
    public bool IsVisible { get => _isVisible; set => _isVisible = value; }
    public bool HideOnRule { get => _hideOnRule; set => _hideOnRule = value; }
    public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules { get => _hidingRules; set => _hidingRules = value; }
}
'@
$implicitUsingsSource = @'
// CHECK-ONLY global usings（.NET SDK 隐式集 7 项，复现构建期 ImplicitUsings 语境；NOT a deliverable）
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
'@

# ---------- 3) 引用集与预处理符号：从工部 p1-10 rerun 日志 csc 命令行提取 ----------
$log = Join-Path $PSScriptRoot 'p1-10-build-fallback-win-rerun.log'
if (-not (Test-Path $log)) { throw "工部构建日志不存在: $log" }
$logText = [System.IO.File]::ReadAllText($log)
$refMatches = [System.Text.RegularExpressions.Regex]::Matches($logText, '/reference:("(?:[^"]+)"|\S+)')
$refPaths = New-Object 'System.Collections.Generic.List[string]'
$seen = @{}
foreach ($m in $refMatches) {
  $p = $m.Groups[1].Value.Trim('"')
  if (-not $seen.ContainsKey($p)) {
    if (-not (Test-Path -LiteralPath $p)) { throw "日志引用路径在磁盘不存在（引用语境漂移）: $p" }
    $seen[$p] = $true; $refPaths.Add($p)
  }
}
"引用集：$($refPaths.Count) 个（自工部 p1-10 rerun 日志 csc /reference: 提取，全部在磁盘核在）"
$avaloniaRef = @($refPaths | Where-Object { $_ -match 'avalonia\\12\.1\.1\\ref\\net10\.0\\Avalonia\.Base\.dll' })
if ($avaloniaRef.Count -eq 0) { throw '引用集中未找到 Avalonia 12.1.1 ref（语境与报错构建不一致）' }

$defineMatch = [System.Text.RegularExpressions.Regex]::Match($logText, '/define:(\S+)')
if (-not $defineMatch.Success) { throw '日志中未找到 /define:' }
$symbols = $defineMatch.Groups[1].Value.Split(';') | Where-Object { $_ }
"预处理符号：$($symbols -join ' ')"

# ---------- 4) 进程内 Roslyn ----------
$sharedFr = Join-Path $PSHOME 'Microsoft.CodeAnalysis.CSharp.dll'
if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
  if (Test-Path $sharedFr) { Add-Type -Path $sharedFr | Out-Null }
  if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) { throw '进程内 Roslyn 不可用' }
}
"Roslyn: $([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree].Assembly.FullName)"

$parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::Default.WithLanguageVersion([Microsoft.CodeAnalysis.CSharp.LanguageVersion]::Latest)
if (-not ('System.Collections.Immutable.ImmutableArray' -as [type])) {
  Add-Type -Path (Join-Path $PSHOME 'System.Collections.Immutable.dll') | Out-Null
}
$symbolArray = [System.Collections.Immutable.ImmutableArray]::CreateRange([string[]]$symbols)
$parseOpts = $parseOpts.WithPreprocessorSymbols($symbolArray)
$trees = @()
foreach ($f in $files) {
  $raw = [System.IO.File]::ReadAllText((Resolve-Path $f).Path)
  $trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($raw, $parseOpts, (Resolve-Path $f).Path)
}
$trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubServicesSource, $parseOpts, '<check-stub:cross-batch-stubs>')
$trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubMvvmSource, $parseOpts, '<check-stub:mvvm-generated-members>')
$trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($implicitUsingsSource, $parseOpts, '<check-stub:implicit-usings>')
"语法树：$($trees.Count)（44 个交付 .cs + 3 个检查专用存根）"

$refs = [Microsoft.CodeAnalysis.MetadataReference[]]($refPaths | ForEach-Object { [Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($_) })
$compOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions([Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
$compOpts = $compOpts.WithNullableContextOptions([Microsoft.CodeAnalysis.NullableContextOptions]::Enable)
$comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create('p1-03-supplementary-check', [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $refs, $compOpts)

$diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
$errors   = @($diags | Where-Object { $_.Severity -eq 'Error' })
$warnings = @($diags | Where-Object { $_.Severity -eq 'Warning' })
foreach ($d in $diags) {
  $loc = if ($d.Location.IsInSource) {
    $ls = $d.Location.GetLineSpan(); "{0}:{1}" -f (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1)
  } else { '<no-source>' }
  ("{0} {1}: {2} [{3}]" -f $d.Severity, $d.Id, $d.GetMessage(), $loc)
}
if ($errors.Count -eq 0) {
  "COMPILE OK（error=0, warning=$($warnings.Count)）—— 兵部 p1-03 批 44 个交付 .cs 语义级编译通过（引用集与 p1-10 构建一致 + 3 检查专用存根）"
  exit 0
} else {
  "COMPILE FAIL（error=$($errors.Count), warning=$($warnings.Count)）"
  exit 1
}
