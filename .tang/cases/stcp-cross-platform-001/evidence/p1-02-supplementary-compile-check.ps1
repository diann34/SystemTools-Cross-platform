<#
p1-02 兵部 · 批内补充编译自检 v2（非官方构建门禁）
v1 用 Add-Type 单编译单元拼接触发 CS1529（using 必须先于编译单元全部元素），系检查方法失真，非交付代码缺陷。
v2 改用当前进程内 Roslyn：每文件一棵 SyntaxTree（与真实构建 1:1），对 11 个交付 .cs 做语法+语义编译诊断；
仅诊断，不产出程序集文件。官方三平台 dotnet build 门禁仍属阶段级验证（p1-05 §5.2-3）。
#>
$ErrorActionPreference = 'Stop'
$files = @(
  'src\SystemTools.CrossPlatform\Rules\ProcessRunningRuleSettings.cs',
  'src\SystemTools.CrossPlatform\Rules\UsingClassPlanRuleSettings.cs',
  'src\SystemTools.CrossPlatform\Rules\UsingTimeLayoutRuleSettings.cs',
  'src\SystemTools.CrossPlatform\Rules\InTimePeriodRuleSettings.cs',
  'src\SystemTools.CrossPlatform\Rules\Handlers\ProcessRunningRuleHandler.cs',
  'src\SystemTools.CrossPlatform\Rules\Handlers\UsingClassPlanRuleHandler.cs',
  'src\SystemTools.CrossPlatform\Rules\Handlers\UsingTimeLayoutRuleHandler.cs',
  'src\SystemTools.CrossPlatform\Rules\Handlers\InTimePeriodRuleHandler.cs',
  'src\SystemTools.CrossPlatform\Triggers\ActionInProgressTrigger.cs',
  'src\SystemTools.CrossPlatform\Config\ActionInProgressTriggerConfig.cs',
  'src\SystemTools.CrossPlatform\Settings\ActionInProgressTriggerSettings.cs',
  'src\SystemTools.CrossPlatform\Controls\ProcessRunningRuleSettingsControl.cs',
  'src\SystemTools.CrossPlatform\Controls\UsingClassPlanRuleSettingsControl.cs',
  'src\SystemTools.CrossPlatform\Controls\UsingTimeLayoutRuleSettingsControl.cs',
  'src\SystemTools.CrossPlatform\Controls\InTimePeriodRuleSettingsControl.cs'
)
# 检查专用存根（非交付文件）：模拟 Avalonia XAML 编译器从 InTimePeriodRuleSettingsControl.axaml
# 生成的 InitializeComponent，使独立 C# 编译可覆盖该控件；真实构建中由 XAML 编译器生成同名成员。
$stubSource = @'
// CHECK-ONLY STUB (p1-02 supplementary compile check, NOT a deliverable)
namespace SystemTools.CrossPlatform.Controls;

public partial class InTimePeriodRuleSettingsControl
{
    private void InitializeComponent() { }
}
'@
$tools    = Join-Path (Get-Location) '.tools\manifest-schema-check\bin\Release\net10.0'
$sharedFr = Join-Path $PSHOME 'Microsoft.CodeAnalysis.CSharp.dll'

# 1) 确保进程内 Roslyn 可用（Add-Type 已加载则直接用；否则从 $PSHOME 加载）
if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
  if (Test-Path $sharedFr) { Add-Type -Path $sharedFr | Out-Null }
  if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) { throw '进程内 Roslyn 不可用' }
}
"Roslyn: $([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree].Assembly.FullName)"

# 2) 每文件一棵语法树（LanguageVersion=Latest，源码种类 Regular）
$parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::Default.WithLanguageVersion([Microsoft.CodeAnalysis.CSharp.LanguageVersion]::Latest)
$trees = @()
foreach ($f in $files) {
  $raw = Get-Content -Raw $f
  $trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($raw, $parseOpts, (Resolve-Path $f).Path)
}
$trees += [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubSource, $parseOpts, '<check-stub:InitializeComponent>')
# 检查专用全局 using 树（非交付文件）：复现构建期 ImplicitUsings 注入语境
# （.NET SDK 隐式集 7 项），用于筛查裸名跨命名空间歧义（如 CS0104 Timer/Task/Process 类）。
$implicitUsingsSource = @'
// CHECK-ONLY global usings (p1-02 supplementary compile check, NOT a deliverable)
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
'@
$trees = @([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($implicitUsingsSource, $parseOpts, '<check-stub:implicit-usings>')) + $trees
"语法树：$($trees.Count)（$($files.Count) 个交付 .cs + 2 个检查专用存根：隐式全局 using + InitializeComponent；axaml 由真实构建的 Avalonia XAML 编译器覆盖，不在本检查范围）"

# 3) 元数据引用：.NET 共享框架（优先，BCL 门面齐全）+ .tools（宿主同版本 SDK 链），按文件名去重
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

# 4) 编译（OutputKind=Dll，Nullable=Enable，未解析仅诊断不产出）
$compOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions([Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
$compOpts = $compOpts.WithNullableContextOptions([Microsoft.CodeAnalysis.NullableContextOptions]::Enable)
$comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create('p1-02-supplementary-check', [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $refs, $compOpts)

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
  "COMPILE OK（error=0, warning=$($warnings.Count)）—— $($files.Count) 个交付 .cs 语义级编译通过（+1 检查专用存根）"
  exit 0
} else {
  "COMPILE FAIL（error=$($errors.Count), warning=$($warnings.Count)）"
  exit 1
}
