<#
p2-03 兵部 · 批内补充编译自检（非官方构建门禁）
方法同 p1-03-supplementary-compile-check.ps1（v2 形态）：当前进程内 Roslyn，每文件一棵 SyntaxTree。
本批升级点（阶段 2 条件文件语境）：
  1. 引用集从 p1-10-build-fallback-win-rerun.log 的 csc 命令行 /reference: token 提取
     （与真实构建相同引用语境，含 Avalonia / FluentAvalonia / ClassIsland SDK 双分支 NuGet 面）；
  2. 预处理符号取自同一日志 /define: 集（Platforms_Windows 等）；并做【双向符号验证】：
     Pass A（Windows 语境）= 原符号集，验证条件文件 Windows 分支 + 服务/行动/触发器全量；
     Pass B（非 Windows 语境）= 同集把 Platforms_Windows 换成 Platforms_Linux，
     验证条件文件 #else 分支 + 全部其余交付文件在非 Windows 符号语境下编译通过；
  3. 对 p2-03 批 12 个交付 .cs + 1 个共享类型增补（MainConfigData）+ 同语境真实支撑集
     （MainConfigHandler/GlobalConstants/FloatingWindowProfile/FloatingWindowProfileManager/
     ButtonRulesetConfig/RowRulesetConfig）全量重编；
  4. 检查专用存根（非交付文件）：SystemToolsNotificationProvider（继承 SDK
     NotificationProviderBase，ShowNotification 消费面 100% 真实，p1-03 先例）；
     MVVM 8.2.1 源生成器等价成员存根（FloatingWindowProfile/FloatingWindowTriggerConfig/
     ButtonRulesetConfig/RowRulesetConfig 的 [ObservableProperty] 生成属性，按生成器命名映射）；
     InitializeComponent 存根（Avalonia XamlIl 源生成管线不在本检查内，p1-02 先例）；
  5. IWindowPlatformService.SetWindowFeature/WindowFeatures(Topmost/Bottommost) 消费面随
     ClassIsland.Platforms.Abstractions.dll 真实引用编译——与工部构建语境同源。
仅诊断，不产出程序集文件。官方三平台 dotnet build 门禁仍属阶段级验证。
#>
$ErrorActionPreference = 'Stop'
$ws = (Get-Item ($PSScriptRoot + '\..\..\..\..')).FullName
Set-Location $ws

# ---------- 1) 批内交付 .cs（兵部 p2-03：12 新文件）+ 共享类型增补 + 同语境真实支撑集 ----------
$prefix = 'src\SystemTools.CrossPlatform'
$files = @(
  "$prefix\Actions\ShowFloatingWindowAction.cs",
  "$prefix\Actions\ToggleFloatingWindowLayerAction.cs",
  "$prefix\Settings\ShowFloatingWindowSettings.cs",
  "$prefix\Settings\ToggleFloatingWindowLayerSettings.cs",
  "$prefix\Settings\FloatingWindowTriggerSettings.cs",
  "$prefix\Controls\ShowFloatingWindowSettingsControl.cs",
  "$prefix\Controls\ToggleFloatingWindowLayerSettingsControl.cs",
  "$prefix\Triggers\FloatingWindowTrigger.cs",
  "$prefix\Config\FloatingWindowTriggerConfig.cs",
  "$prefix\Services\FloatingWindowService.cs",
  "$prefix\Services\SystemShutdownMonitor.cs",
  "$prefix\Views\SystemMotionPreferences.cs",
  "$prefix\ConfigHandlers\MainConfigData.cs",
  "$prefix\ConfigHandlers\MainConfigHandler.cs",
  "$prefix\Shared\GlobalConstants.cs",
  "$prefix\ConfigHandlers\FloatingWindowProfile.cs",
  "$prefix\ConfigHandlers\FloatingWindowProfileManager.cs",
  "$prefix\ConfigHandlers\ButtonRulesetConfig.cs",
  "$prefix\ConfigHandlers\RowRulesetConfig.cs"
)
$missing = @($files | Where-Object { -not (Test-Path $_) })
if ($missing.Count -gt 0) { throw ("清单文件缺失: " + ($missing -join ', ')) }
"批内交付+支撑 .cs：$($files.Count)（预期 19）"
if ($files.Count -ne 19) { throw '交付/支撑文件数不等于 19，清单漂移' }

# ---------- 2) 引用集与预处理符号（工部真实构建 csc 命令行） ----------
$log = '.tang\cases\stcp-cross-platform-001\evidence\p1-10-build-fallback-win-rerun.log'
$logText = Get-Content $log -Raw
$refMatches = [regex]::Matches($logText, '/reference:"?([^"\r\n]+?)"?(?=\s+/(?:reference|out|define|nostdlib|noconfig|unsafe|nowarn|warnaserror|langversion|doc)\b|\s*$)')
if ($refMatches.Count -lt 50) {
  # 宽松回退：所有 /reference: 后的路径 token
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
"SDK 平台抽象引用：$platRef"

$defineMatch = [regex]::Match($logText, '/define:([^\s/"]+)')
if (-not $defineMatch.Success) { throw '日志未找到 /define: token' }
$definesWin = $defineMatch.Groups[1].Value
"Windows 语境符号集（真实构建同源）：$definesWin"
if ($definesWin -notmatch 'Platforms_Windows') { throw '符号集不含 Platforms_Windows（大小写核对失败）' }
$definesNonWin = ($definesWin -split ';') | Where-Object { $_ -ne 'Platforms_Windows' -and $_ -notlike 'WINDOWS*' }
$definesNonWin = @($definesNonWin) + @('Platforms_Linux','LINUX') -join ';'
"非 Windows 语境符号集（双向验证）：$definesNonWin"

# ---------- 3) 检查专用存根（非交付文件） ----------
$stubServicesSource = @'
// CHECK-ONLY STUBS (p2-03 supplementary compile check, NOT deliverables)
namespace SystemTools.CrossPlatform.Services;

// 消费面存根：继承 SDK NotificationProviderBase，ShowNotification 公共方法来自基类（引用集内真实 SDK 类型）。
public class SystemToolsNotificationProvider : ClassIsland.Core.Abstractions.Services.NotificationProviders.NotificationProviderBase
{
}
'@
$stubMvvmSource = @'
// CHECK-ONLY STUB (p2-03 supplementary compile check, NOT a deliverable)
// MVVM 生成成员检查专用 partial 存根：本检查不含 CommunityToolkit.Mvvm 8.2.1 的源生成器管线，
// 按生成器命名映射补齐等价成员（方法先例：p1-02/p1-03 的生成成员存根）。
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

# ---------- 4) Roslyn 双向编译 ----------
Add-Type -Path 'C:\Program Files\dotnet\sdk\10.0.302\Roslyn\bincore\Microsoft.CodeAnalysis.dll'
Add-Type -Path 'C:\Program Files\dotnet\sdk\10.0.302\Roslyn\bincore\Microsoft.CodeAnalysis.CSharp.dll'

function Invoke-CompilePass([string]$passName, [string]$defines) {
  $sources = @()
  foreach ($f in $files) { $sources += (Get-Content $f -Raw -Encoding utf8) }
  $sources += $stubServicesSource
  $sources += $stubMvvmSource
  $sources += $stubGlobalUsings

  $trees = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.SyntaxTree]'
  for ($i = 0; $i -lt $sources.Count; $i++) {
    $parseOpts = [Microsoft.CodeAnalysis.CSharp.CSharpParseOptions]::new(
      [Microsoft.CodeAnalysis.CSharp.LanguageVersion]::CSharp13,
      [Microsoft.CodeAnalysis.DocumentationMode]::Parse,
      [Microsoft.CodeAnalysis.SourceCodeKind]::Regular,
      ($defines -split ';'))
    $fileName = if ($i -lt $files.Count) { [IO.Path]::GetFileName($files[$i]) } else { "stub_$i.cs" }
    $trees.Add([Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($sources[$i], $parseOpts, $fileName))
  }

  $compOpts = [Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions]::new(
    [Microsoft.CodeAnalysis.OutputKind]::DynamicallyLinkedLibrary)
  # 注：本批交付零 unsafe 面，默认选项即与真实构建 /unsafe- 语境等效；选项类型不可变（With* 模式），无需额外设置。

  $metadataRefs = New-Object 'System.Collections.Generic.List[Microsoft.CodeAnalysis.MetadataReference]'
  foreach ($r in $refs) { $metadataRefs.Add([Microsoft.CodeAnalysis.MetadataReference]::CreateFromFile($r)) }
  $comp = [Microsoft.CodeAnalysis.CSharp.CSharpCompilation]::Create(
    "p2-03-supplementary-check-$passName", [Microsoft.CodeAnalysis.SyntaxTree[]]$trees, $metadataRefs, $compOpts)

  $diags = @($comp.GetDiagnostics() | Where-Object { $_.Severity -ne 'Hidden' })
  $errors   = @($diags | Where-Object { $_.Severity -eq 'Error' })
  $warnings = @($diags | Where-Object { $_.Severity -eq 'Warning' })
  foreach ($d in $diags) {
    $loc = if ($d.Location.IsInSource) {
      $ls = $d.Location.GetLineSpan(); "{0}:{1}" -f $d.Location.SourceTree.FilePath, ($ls.StartLinePosition.Line + 1)
    } else { '<no-source>' }
    ("{0} {1}: {2} [{3}]" -f $d.Severity, $d.Id, $d.GetMessage(), $loc)
  }
  if ($errors.Count -eq 0) {
    "PASS[$passName]（error=0, warning=$($warnings.Count)）—— 符号集：$defines"
    return $warnings.Count
  } else {
    "FAIL[$passName]（error=$($errors.Count), warning=$($warnings.Count)）"
    exit 1
  }
}

$wA = Invoke-CompilePass -passName 'Windows' -defines $definesWin
$wB = Invoke-CompilePass -passName 'NonWindows' -defines $definesNonWin
"Pass A 输出捕获：$wA"
"Pass B 输出捕获：$wB"
"COMPILE OK（双向：Windows 语境 + 非 Windows 语境均 error=0）—— 兵部 p2-03 批 12 交付 .cs + MainConfigData 增补段 + 同语境支撑集语义级编译通过（条件文件双向符号验证含 SystemShutdownMonitor/SystemMotionPreferences 两分支）"
exit 0
