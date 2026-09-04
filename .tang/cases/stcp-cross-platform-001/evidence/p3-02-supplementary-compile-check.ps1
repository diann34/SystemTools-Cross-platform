<#
p3-02 兵部 · 批内补充编译自检（非官方构建门禁；方法沿 p1-06 §7-6 / p2-03 §6.3 升级形态。
当前会话沙箱禁止 dotnet 子进程（命名管道边界，本批实测 dotnet.exe 启动即拒：
\\.\pipe\LOCAL\dotnet_* 访问被拒），官方三平台构建门禁仍属阶段级验证（工部）。
以进程内 Roslyn 对全工程源码树 + 检查专用存根做语法+语义编译诊断；仅诊断，不产出程序集。
判定：只统计本批 5 个交付 .cs 的诊断（p3-02 四页 code-behind + 共享 VM）；他批文件
（含 p3-01 并行在写面）因缺 XAML 生成成员产生的预期噪声单列不计入判定。
存根语境相对 p1-06 版增量：① MVVM 生成成员存根 FloatingTriggerItem/FloatingTriggerRow
（p3-02 页属类型，[ObservableProperty] 生成属性 + OnIconChanged 声明钩子）；
② AiChatSettingsPage.AttachmentDropOverlay（p3-02 拖放遮罩 x:Name 生成字段）。
#>
$ErrorActionPreference = 'Stop'
$batchFiles = @(
  'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\AiChatSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\AboutSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\PluginDebugSettingsPage.axaml.cs'
)
$stubSource = @'
// CHECK-ONLY STUBS (p3-02 supplementary compile check, NOT a deliverable)
// 提供 Avalonia XAML 编译器与 CommunityToolkit.Mvvm 生成器在真实构建中生成的成员。
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

    // MVVM 生成成员存根（p3-02 页属类型；真实构建由 CommunityToolkit.Mvvm 生成器生成）
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

    // MVVM 生成成员存根（共享 VM [ObservableProperty] 字段：p3-01 并行段类型，仅为使共享 VM
    // 本批文件可编译，成员语义仍归 p3-01 申报）
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

    // MVVM 生成成员存根（AiChatSettingsViewModel，沿 p1-06 存块复刻：页面 code-behind 消费其
    // 生成属性 + 真实文件 partial 方法实现所需的 defining declaration）
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

// 共享配置类型生成成员（独立块级命名空间；禁用点状类名，避免类型名遮蔽 SystemTools 命名空间）
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

if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
  Add-Type -Path (Join-Path $PSHOME 'Microsoft.CodeAnalysis.CSharp.dll') | Out-Null
  Add-Type -Path (Join-Path $PSHOME 'Microsoft.CodeAnalysis.dll') | Out-Null
}
"Roslyn: $([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree].Assembly.FullName)"

$parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::Default.WithLanguageVersion([Microsoft.CodeAnalysis.CSharp.LanguageVersion]::Latest)
$trees = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.SyntaxTree]'
foreach ($f in $batchFiles) {
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content -Raw $f), $parseOpts, (Resolve-Path $f).Path))
}
# 全工程其余源码树（跨批类型语义绑定；排除 obj/bin 生成物；他批诊断噪声单列）
Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Where-Object {
  $p = $_.FullName
  ($p -notmatch '\\(bin|obj)\\') -and
  -not ($batchFiles | Where-Object { (Resolve-Path $_).Path -eq $p })
} | ForEach-Object {
  $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content -Raw $_.FullName), $parseOpts, $_.FullName))
}
$trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubSource, $parseOpts, '<check-stubs:p3-02>'))
$projCount = (Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Measure-Object).Count
"语法树：$($trees.Count)（本批 $($batchFiles.Count) + 全工程 $($projCount - $batchFiles.Count) + 1 存根）"

$fxRoot = @('C:\Program Files\dotnet\shared\Microsoft.NETCore.App', "$env:DOTNET_ROOT\shared\Microsoft.NETCore.App") |
  Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $fxRoot) { throw '未找到 .NET 共享框架 Microsoft.NETCore.App' }
$fxDir = (Get-ChildItem $fxRoot -Directory | Sort-Object { [version]$_.Name } | Select-Object -Last 1).FullName
"共享框架：$fxDir"
$refPaths = New-Object 'System.Collections.Generic.List[string]'
$seen = @{}
$nativePattern = '^(coreclr|clrjit|clrgc.*|clretwrc|hostpolicy|hostfxr|mscordaccore.*|mscorbi|mscorrc|msquic|.*\.Native.*|e_shim)\.dll$'
foreach ($dir in @($fxDir, $tools)) {
  Get-ChildItem $dir -Filter '*.dll' -File | Sort-Object Name | ForEach-Object {
    if ($_.Name -match $nativePattern) { return }
    if (-not $seen.ContainsKey($_.Name)) { $seen[$_.Name] = $true; $refPaths.Add($_.FullName) }
  }
}
if (Test-Path $mvvmLib) { $refPaths.Add($mvvmLib) } else { throw "未找到 CommunityToolkit.Mvvm 库：$mvvmLib" }
$refs = [Microsoft.CodeAnalysis.MetadataReference[]]($refPaths | ForEach-Object { [Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($_) })
"元数据引用数：$($refs.Count)（$fxDir + $tools + MVVM 8.2.1）"

$compOpts = New-Object Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions([Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
$compOpts = $compOpts.WithNullableContextOptions([Microsoft.CodeAnalysis.NullableContextOptions]::Enable)
$comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create('p3-02-supplementary-check', $trees.ToArray(), $refs, $compOpts)

$batchPaths = $batchFiles | ForEach-Object { (Resolve-Path $_).Path }
$diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
$batchDiags   = @($diags | Where-Object { $_.Location.IsInSource -and ($batchPaths -contains $_.Location.SourceTree.FilePath) })
$otherErrors  = @($diags | Where-Object { $_.Severity -eq 'Error' -and $_.Location.IsInSource -and -not ($batchPaths -contains $_.Location.SourceTree.FilePath) })
$batchErrors   = @($batchDiags | Where-Object { $_.Severity -eq 'Error' })
$batchWarnings = @($batchDiags | Where-Object { $_.Severity -eq 'Warning' })

"===== 本批 $($batchFiles.Count) 个交付 .cs 诊断 ====="
foreach ($d in $batchDiags) {
  $ls = $d.Location.GetLineSpan()
  ("{0} {1}: {2} [{3}:{4}]" -f $d.Severity, $d.Id, $d.GetMessage(), (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1))
}
"===== 他批文件错误（预期 XAML 生成面/并行批在写面噪声，单列不计判定）共 $($otherErrors.Count) 条 ====="
foreach ($d in ($otherErrors | Select-Object -First 12)) {
  $ls = $d.Location.GetLineSpan()
  ("{0} {1}: {2} [{3}:{4}]" -f $d.Severity, $d.Id, $d.GetMessage(), (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1))
}
if ($batchErrors.Count -eq 0) {
  "COMPILE OK（本批 error=0, warning=$($batchWarnings.Count)）—— p3-02 五个交付 .cs 语义级编译通过"
  exit 0
} else {
  "COMPILE FAIL（本批 error=$($batchErrors.Count), warning=$($batchWarnings.Count)）"
  exit 1
}
