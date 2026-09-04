<#
p1-06 礼部 · 批内补充编译自检（非官方构建门禁，方法沿 p1-02 先例 v2）
当前会话沙箱禁止 dotnet 子进程（命名管道边界），本检查以进程内 Roslyn 对
Plugin.cs + SettingsPage 8 个 .cs（6 页 code-behind + 2 ViewModel）+ 全工程源码树
做语法+语义编译诊断；仅诊断，不产出程序集文件。
XAML 编译器生成的成员（InitializeComponent / x:Name 字段 / [ObservableProperty]
生成属性与 partial 声明）由检查专用存根提供（非交付文件）。
判定：只统计本批 9 个交付 .cs 的诊断；他批文件因缺 XAML 生成成员产生的预期噪声
单列不计入判定（其正确性由各批次自检与真实构建覆盖）。
#>
$ErrorActionPreference = 'Stop'
$batchFiles = @(
  'src\SystemTools.CrossPlatform\Plugin.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\AiChatSettingsViewModel.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsViewModel.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\SystemToolsSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\AiChatSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\FloatingWindowEditorSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\AboutSettingsPage.axaml.cs',
  'src\SystemTools.CrossPlatform\SettingsPage\PluginDebugSettingsPage.axaml.cs'
)
$stubSource = @'
// CHECK-ONLY STUBS (p1-06 supplementary compile check, NOT a deliverable)
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
$trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($stubSource, $parseOpts, '<check-stubs:p1-06>'))
$projCount = (Get-ChildItem src\SystemTools.CrossPlatform -Recurse -Filter *.cs | Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' } | Measure-Object).Count
"语法树：$($trees.Count)（本批 9 + 全工程 $($projCount - 9) + 1 存根）"

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
$comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create('p1-06-supplementary-check', $trees.ToArray(), $refs, $compOpts)

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
"===== 他批文件错误（预期 XAML 生成面噪声，单列不计判定）共 $($otherErrors.Count) 条 ====="
foreach ($d in ($otherErrors | Select-Object -First 12)) {
  $ls = $d.Location.GetLineSpan()
  ("{0} {1}: {2} [{3}:{4}]" -f $d.Severity, $d.Id, $d.GetMessage(), (Split-Path $d.Location.SourceTree.FilePath -Leaf), ($ls.StartLinePosition.Line + 1))
}
if ($batchErrors.Count -eq 0) {
  "COMPILE OK（本批 error=0, warning=$($batchWarnings.Count)）—— Plugin.cs + SettingsPage 8 个 .cs 语义级编译通过"
  exit 0
} else {
  "COMPILE FAIL（本批 error=$($batchErrors.Count), warning=$($batchWarnings.Count)）"
  exit 1
}
