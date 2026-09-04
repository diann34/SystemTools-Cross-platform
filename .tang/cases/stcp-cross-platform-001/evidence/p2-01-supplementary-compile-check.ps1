<#
p2-01 兵部 · 批内补充编译自检（非官方构建门禁；方法沿 p1-02/p1-03 v2 形态升级）
- 进程内 Roslyn，每文件一棵 SyntaxTree（与真实构建 1:1）；仅诊断，不产出程序集文件。
- 本批升级点：**双向符号验证**（派工约束 4 + 尚书省 guard 符号统一微修裁决）——同一文件集编译两轮：
    Round W：定义编译生效符号 Platforms_Windows（宿主 CrossPlatformProps.props:37 对 Windows TFM
             实际注入；微修裁决后不再需要任何 csproj DefineConstants 接线）→ Windows 路径
             （SystemPowerCommandWindows.cs / ProcessMemoryMaintenanceNativeWindows.cs guard 内实现）必须通过；
    Round N：不定义任何符号 → 非 Windows no-op 存根路径（SystemPowerCommandStub.cs /
             ProcessMemoryMaintenanceNativeNoOp.cs）必须通过。
  两轮 error=0 才判 PASS（Windows/非 Windows 双分支编译闭合证据，即 props 注入现态的双向证明）。
- 引用集：.NET 10 共享框架 + 宿主同版本链（.tools\manifest-schema-check\bin\Release\net10.0，
  p1-02/p1-03 同源；Avalonia 12.1.1 / FluentAvalonia / ClassIsland.Core / Platforms.Abstractions / Shared）。
- 隐式全局 using 树（.NET SDK 隐式集 7 项）复现构建期 ImplicitUsings 注入语境（p1-02 CS0104 升级法）。
- 跨批依赖：真实文件纳入 Settings\ShortcutKeyNotificationSettings.cs、ConfigHandlers\MainConfigHandler.cs、
  Shared\GlobalConstants.cs（只读引用，不修改）；SystemToolsNotificationProvider 以检查专用存根承接
  （继承 SDK NotificationProviderBase，ShowNotification 公共方法来自基类，p1-03 同法）。
- 官方三平台构建门禁仍属阶段级验证；本检查为批内语义级自检。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Item ($PSScriptRoot + '\..\..\..\..')).FullName
Set-Location $ws

# ---------- 1) 批内交付 .cs（兵部 p2-01：21 新 + 1 修改 = 22） ----------
$prefix = 'src\SystemTools.CrossPlatform'
$files = @(
  "$prefix\Actions\ShutdownAction.cs",
  "$prefix\Actions\AdvancedShutdownAction.cs",
  "$prefix\Actions\CancelShutdownAction.cs",
  "$prefix\Actions\LockScreenAction.cs",
  "$prefix\Actions\ImmediateRestartAction.cs",
  "$prefix\Actions\ImmediateShutdownAction.cs",
  "$prefix\Actions\SleepAction.cs",
  "$prefix\Actions\SystemPowerCommandWindows.cs",
  "$prefix\Actions\SystemPowerCommandStub.cs",
  "$prefix\Settings\ShutdownSettings.cs",
  "$prefix\Settings\AdvancedShutdownSettings.cs",
  "$prefix\Controls\ShutdownSettingsControl.cs",
  "$prefix\Controls\AdvancedShutdownSettingsControl.cs",
  "$prefix\Views\AdvancedShutdownDialog.axaml.cs",
  "$prefix\Views\ExtendShutdownDialog.axaml.cs",
  "$prefix\Services\ClassIslandMemoryAutoCleanupService.cs",
  "$prefix\Services\IProcessMemoryMaintenanceService.cs",
  "$prefix\Services\ProcessMemoryMaintenanceService.cs",
  "$prefix\Services\ProcessMemoryMaintenanceNativeWindows.cs",
  "$prefix\Services\ProcessMemoryMaintenanceNativeNoOp.cs",
  "$prefix\ConfigHandlers\MainConfigData.cs"
)
# 跨批只读引用（不修改）；ButtonRulesetConfig/RowRulesetConfig 为 MainConfigData 既有成员类型（p1-03 交付）
$files += @(
  "$prefix\Settings\ShortcutKeyNotificationSettings.cs",
  "$prefix\ConfigHandlers\MainConfigHandler.cs",
  "$prefix\ConfigHandlers\ButtonRulesetConfig.cs",
  "$prefix\ConfigHandlers\RowRulesetConfig.cs",
  "$prefix\Shared\GlobalConstants.cs"
)
$missing = @($files | Where-Object { -not (Test-Path $_) })
if ($missing.Count -gt 0) { throw ("清单文件缺失: " + ($missing -join ', ')) }
"批内交付 .cs：21（含条件文件 4）+ 跨批只读引用 5 = $($files.Count)"

# ---------- 2) 检查专用存根（非交付文件） ----------
$stubSource = @'
// CHECK-ONLY STUB (p2-01 supplementary compile check, NOT a deliverable)
// 消费面存根：继承 SDK NotificationProviderBase，ShowNotification 公共方法来自基类（引用集内真实 SDK 类型）。
namespace SystemTools.CrossPlatform.Services;

public class SystemToolsNotificationProvider : ClassIsland.Core.Abstractions.Services.NotificationProviders.NotificationProviderBase
{
}
'@
$implicitUsingsSource = @'
// CHECK-ONLY global usings (p2-01 supplementary compile check, NOT a deliverable)
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
'@

# ---------- 3) 进程内 Roslyn 可用性 ----------
$tools    = Join-Path (Get-Location) '.tools\manifest-schema-check\bin\Release\net10.0'
$sharedFr = Join-Path $PSHOME 'Microsoft.CodeAnalysis.CSharp.dll'
if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
  if (Test-Path $sharedFr) { Add-Type -Path $sharedFr | Out-Null }
  if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) { throw '进程内 Roslyn 不可用' }
}
"Roslyn: $([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree].Assembly.FullName)"

# ---------- 4) 元数据引用（共享框架 + .tools，滤原生镜像，按文件名去重） ----------
$fxRoot = @('C:\Program Files\dotnet\shared\Microsoft.NETCore.App', "$env:DOTNET_ROOT\shared\Microsoft.NETCore.App") |
  Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $fxRoot) { throw '未找到 .NET 共享框架 Microsoft.NETCore.App' }
$fxDir = (Get-ChildItem $fxRoot -Directory | Sort-Object { [version]$_.Name } | Select-Object -Last 1).FullName
"共享框架：$fxDir"
$refPaths = New-Object 'System.Collections.Generic.List[string]'
$seen = @{}
$nativePattern = '^(coreclr|clrjit|clrgc.*|clretwrc|hostpolicy|hostfxr|mscordaccore.*|mscordbi|mscorrc|msquic|.*\.Native.*|e_shim)\.dll$'
foreach ($dir in @($fxDir, $tools)) {
  Get-ChildItem $dir -Filter '*.dll' -File | Sort-Object Name | ForEach-Object {
    if ($_.Name -match $nativePattern) { return }
    if (-not $seen.ContainsKey($_.Name)) { $seen[$_.Name] = $true; $refPaths.Add($_.FullName) }
  }
}
$refs = [Microsoft.CodeAnalysis.MetadataReference[]]($refPaths | ForEach-Object { [Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($_) })
"元数据引用数：$($refs.Count)（$fxDir + $tools，已滤原生镜像）"

# ---------- 5) 双向符号两轮编译 ----------
$rounds = @(
  @{ Name = 'Round-W(Platforms_Windows)'; Symbols = [string[]]@('Platforms_Windows') },
  @{ Name = 'Round-N(no-symbol)';         Symbols = [string[]]@() }
)

$anyError = $false
foreach ($round in $rounds) {
  ""
  "===== $($round.Name) ====="
  $parseOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpParseOptions(
    [Microsoft.CodeAnalysis.CSharp.LanguageVersion]::Latest,
    [Microsoft.CodeAnalysis.DocumentationMode]::Parse,
    [Microsoft.CodeAnalysis.SourceCodeKind]::Regular,
    $round.Symbols)
  $trees = @()
  $trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($implicitUsingsSource, $parseOpts, '<check-stub:implicit-usings>')
  $trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubSource, $parseOpts, '<check-stub:notification-provider>')
  foreach ($f in $files) {
    $raw = Get-Content -Raw $f
    $trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($raw, $parseOpts, (Resolve-Path $f).Path)
  }
  "语法树：$($trees.Count)（3 个交付 .cs 群 + 2 个检查专用树：隐式全局 using + NotificationProvider 存根）"

  $compOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions([Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
  $compOpts = $compOpts.WithNullableContextOptions([Microsoft.CodeAnalysis.NullableContextOptions]::Enable)
  $comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create(
    "p2-01-supplementary-check-$($round.Name)", [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $refs, $compOpts)

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
    "$($round.Name)：COMPILE OK（error=0, warning=$($warnings.Count)）"
  } else {
    "$($round.Name)：COMPILE FAIL（error=$($errors.Count), warning=$($warnings.Count)）"
    $anyError = $true
  }
}

""
if (-not $anyError) {
  "双向符号验证总判定：PASS（Round-W error=0 且 Round-N error=0）——Windows 路径与非 Windows no-op 路径均语义级编译通过"
  exit 0
} else {
  "双向符号验证总判定：FAIL"
  exit 1
}
