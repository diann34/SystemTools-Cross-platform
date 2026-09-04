<#
p4-01 刑部 · 裁量实施补充编译双验（非官方构建门禁；方法沿 p3-02-supplementary-compile-check.ps1 升级形态）。
增量（相对 p3-02 版）：
  ① 双向符号（Round-W = /define:Platforms_Windows 编译 Windows 分支；Round-N = /define:Platforms_Linux
     编译 #else/存根分支）——对应 p2-08 §3-2 真实双 TFM define 形态，覆盖 O-5 触达的条件文件
     Services\SystemShutdownMonitor.cs 的跨分支符号复验；
  ② 引用面追加 WindowsDesktop.App.Ref（net10.0 ref 程序集，供 System.Windows.Forms 元数据解析；
     与共享框架运行时引用按程序集名去重，先见者胜）；
  ③ 判定面 = 本任务 2 个裁量触达文件（SystemToolsSettingsPage.axaml.cs / SystemShutdownMonitor.cs）
     双轮 error=0；全工程其余源码树诊断按 p3-01/p3-02 既有口径单列（XAML 生成成员缺位噪声，
     不入判定）。存根语境沿 p3-02 存块原文（未改动）。
仅诊断，不产出程序集。
#>
$ErrorActionPreference = 'Stop'
$batchFiles = @(
  'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\Services\SystemShutdownMonitor.cs'
)
$stubSource = @'
// CHECK-ONLY STUBS (p4-01 supplementary compile check, NOT a deliverable; verbatim from p3-02 stub block)
namespace SystemTools.CrossPlatform.SettingsPage
{
    public partial class SystemToolsSettingsPage { private void InitializeComponent() { } }
    public partial class MoreFeaturesOptionsSettingsPage { private void InitializeComponent() { } }
    public partial class FloatingWindowEditorSettingsPage { private void InitializeComponent() { } }
    public partial class PluginDebugSettingsPage { private void InitializeComponent() { } }
    public partial class AboutSettingsPage
    {
        private void InitializeComponent() { }
        public Avalonia.Controls.Image PluginIcon { get => null; set { } }
    }
    public partial class AiChatSettingsPage
    {
        private void InitializeComponent() { }
        public Avalonia.Controls.ScrollViewer MessageScrollViewer { get => null; set { } }
        public Avalonia.Controls.Button ReturnToBottomButton { get => null; set { } }
        public Avalonia.Controls.TextBox MessageInput { get => null; set { } }
        public SystemTools.CrossPlatform.Controls.AiAttachmentDropOverlay AttachmentDropOverlay { get; set; } = null!;
        public Avalonia.Controls.ListBox ConversationList { get => null; set { } }
    }

    public partial class FloatingTriggerItem
    {
        public string ButtonId { get => string.Empty; set { } }
        public string Icon { get => string.Empty; set { } }
        public string ButtonName { get => string.Empty; set { } }
        public SystemTools.CrossPlatform.ConfigHandlers.ButtonRulesetConfig Config { get => new(); set { } }
        partial void OnIconChanged(string value);
    }
    public partial class FloatingTriggerRow
    {
        public System.Collections.ObjectModel.ObservableCollection<FloatingTriggerItem> Buttons { get => new(); set { } }
        public int RowIndex { get => 0; set { } }
        public SystemTools.CrossPlatform.ConfigHandlers.RowRulesetConfig RowRuleset { get => new(); set { } }
    }

    public partial class SystemToolsSettingsViewModel
    {
        public System.Collections.ObjectModel.ObservableCollection<UnifiedFeatureItem> FeatureItems { get => new(); set { } }
        public System.Collections.ObjectModel.ObservableCollection<UnifiedFeatureItem> FeatureSearchResults { get => new(); set { } }
        public bool IsFeatureDrawerOpen { get => false; set { } }
        public object? FeatureDrawerContent { get => null; set { } }
    }
    public partial class UnifiedFeatureItem
    {
        public string Id { get => string.Empty; set { } }
        public string DisplayName { get => string.Empty; set { } }
        public bool IsEnabled { get => false; set { } }
        public FeatureItemType ItemType { get => FeatureItemType.Action; set { } }
        public string? GroupName { get => null; set { } }
    }

    public partial class AiChatSettingsViewModel
    {
        public SystemTools.CrossPlatform.Models.AiConversation? SelectedConversation { get; set; }
        public string InputText { get; set; } = string.Empty;
        public bool IsHistoryOpen { get; set; }
        public bool IsGenerating { get; set; }
        public bool IsUpdatingAttachments { get; set; }
        public string StatusText { get; set; } = string.Empty;
        partial void OnSelectedConversationChanged(SystemTools.CrossPlatform.Models.AiConversation? oldValue, SystemTools.CrossPlatform.Models.AiConversation? newValue);
        partial void OnInputTextChanged(string value);
        partial void OnIsGeneratingChanged(bool value);
        partial void OnIsUpdatingAttachmentsChanged(bool value);
        partial void OnStatusTextChanged(string value);
    }
}

namespace SystemTools.CrossPlatform.ConfigHandlers
{
    public partial class ButtonRulesetConfig
    {
        public bool IsVisible { get => false; set { } }
        public bool HideOnRule { get => false; set { } }
        public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules { get => new(); set { } }
    }
    public partial class RowRulesetConfig
    {
        public bool IsVisible { get => false; set { } }
        public bool HideOnRule { get => false; set { } }
        public ClassIsland.Core.Models.Ruleset.Ruleset HidingRules { get => new(); set { } }
    }
    public partial class FloatingWindowProfile
    {
        public string Name { get => string.Empty; set { } }
        public bool FloatingWindowHorizontal { get => false; set { } }
    }
}
'@
$tools    = Join-Path (Get-Location) '.tools\manifest-schema-check\bin\Release\net10.0'
$mvvmLib  = Join-Path $env:USERPROFILE '.nuget\packages\communitytoolkit.mvvm\8.2.1\lib\netstandard2.0\CommunityToolkit.Mvvm.dll'
$deskRefRoot = 'C:\Program Files\dotnet\packs\Microsoft.WindowsDesktop.App.Ref'
$deskRefDir = $null
if (Test-Path $deskRefRoot) {
  $deskRefDir = Join-Path (Get-ChildItem $deskRefRoot -Directory | Sort-Object { [version]$_.Name } | Select-Object -Last 1).FullName 'ref\net10.0'
}

if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
  Add-Type -Path (Join-Path $PSHOME 'Microsoft.CodeAnalysis.CSharp.dll') | Out-Null
  Add-Type -Path (Join-Path $PSHOME 'Microsoft.CodeAnalysis.dll') | Out-Null
}
"Roslyn: $([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree].Assembly.FullName)"

$allSrc = Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' }
$batchPaths = $batchFiles | ForEach-Object { (Resolve-Path $_).Path }

# ---- 引用面（构建一次，双轮复用）----
$fxRoot = @('C:\Program Files\dotnet\shared\Microsoft.NETCore.App', "$env:DOTNET_ROOT\shared\Microsoft.NETCore.App") |
  Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $fxRoot) { throw '未找到 .NET 共享框架 Microsoft.NETCore.App' }
$fxDir = (Get-ChildItem $fxRoot -Directory | Sort-Object { [version]$_.Name } | Select-Object -Last 1).FullName
"共享框架：$fxDir"
$refPaths = New-Object 'System.Collections.Generic.List[string]'
$seen = @{}
$nativePattern = '^(coreclr|clrjit|clrgc.*|clretwrc|hostpolicy|hostfxr|mscordaccore.*|mscorbi|mscorrc|msquic|.*\.Native.*|e_shim)\.dll$'
$dirs = @($fxDir, $tools)
if ($deskRefDir -and (Test-Path $deskRefDir)) { $dirs += $deskRefDir }
foreach ($dir in $dirs) {
  Get-ChildItem $dir -Filter '*.dll' -File | Sort-Object Name | ForEach-Object {
    if ($_.Name -match $nativePattern) { return }
    if (-not $seen.ContainsKey($_.Name)) { $seen[$_.Name] = $true; $refPaths.Add($_.FullName) }
  }
}
if (Test-Path $mvvmLib) { $refPaths.Add($mvvmLib) } else { throw "未找到 CommunityToolkit.Mvvm 库：$mvvmLib" }
$formsRef = $refPaths | Where-Object { (Split-Path $_ -Leaf) -eq 'System.Windows.Forms.dll' }
"元数据引用数：$($refPaths.Count)（fx + tools + desktop-ref($deskRefDir) + MVVM 8.2.1）；System.Windows.Forms 引用：$formsRef"
$refs = [Microsoft.CodeAnalysis.MetadataReference[]]($refPaths | ForEach-Object { [Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($_) })

$compOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions([Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
$compOpts = $compOpts.WithNullableContextOptions([Microsoft.CodeAnalysis.NullableContextOptions]::Enable)

function Invoke-Round([string]$roundName, [string[]]$defines) {
  $parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::Default.WithLanguageVersion([Microsoft.CodeAnalysis.CSharp.LanguageVersion]::Latest)
  if ($defines.Count -gt 0) { $parseOpts = $parseOpts.WithPreprocessorSymbols($defines) }
  $trees = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.SyntaxTree]'
  foreach ($f in $batchFiles) {
    $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content -Raw $f), $parseOpts, (Resolve-Path $f).Path))
  }
  foreach ($f in ($allSrc | Where-Object { -not ($batchPaths -contains $_.FullName) })) {
    $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content -Raw $f.FullName), $parseOpts, $f.FullName))
  }
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubSource, $parseOpts, "<check-stubs:p4-01:$roundName>"))
  $comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create("p4-01-supplementary-check-$roundName", $trees.ToArray(), $refs, $compOpts)
  $diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
  $batchDiags   = @($diags | Where-Object { $_.Location.IsInSource -and ($batchPaths -contains $_.Location.SourceTree.FilePath) })
  $otherErrors  = @($diags | Where-Object { $_.Severity -eq 'Error' -and $_.Location.IsInSource -and -not ($batchPaths -contains $_.Location.SourceTree.FilePath) })
  $batchErrors   = @($batchDiags | Where-Object { $_.Severity -eq 'Error' })
  $batchWarnings = @($batchDiags | Where-Object { $_.Severity -eq 'Warning' })
  ""
  Write-Host "===== Round $roundName（define: $($defines -join ', ')）—— 本批 $($batchFiles.Count) 个裁量触达文件诊断 ====="
  foreach ($d in $batchDiags) {
    $ls = $d.Location.GetLineSpan()
    Write-Host ("{0} {1}: {2} [{3}:{4}]" -f $d.Severity, $d.Id, $d.GetMessage(), (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1))
  }
  Write-Host "===== 他文件错误（预期 XAML 生成面噪声，单列不入判定）共 $($otherErrors.Count) 条 ====="
  foreach ($d in ($otherErrors | Select-Object -First 8)) {
    $ls = $d.Location.GetLineSpan()
    Write-Host ("{0} {1}: {2} [{3}:{4}]" -f $d.Severity, $d.Id, $d.GetMessage(), (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1))
  }
  if ($batchErrors.Count -eq 0) {
    Write-Host "COMPILE OK（Round $roundName：本批 error=0, warning=$($batchWarnings.Count)）"
    return $true
  } else {
    Write-Host "COMPILE FAIL（Round $roundName：本批 error=$($batchErrors.Count), warning=$($batchWarnings.Count)）"
    return $false
  }
}

$roundW = Invoke-Round -roundName 'W' -defines @('Platforms_Windows')
$roundN = Invoke-Round -roundName 'N' -defines @('Platforms_Linux')
""
if ($roundW -and $roundN) { "COMPILE OK（Round-W + Round-N 双向符号 error=0）—— p4-01 两个裁量触达文件跨分支语义编译通过"; exit 0 } else { "COMPILE FAIL（双向符号存在 error）"; exit 1 }
