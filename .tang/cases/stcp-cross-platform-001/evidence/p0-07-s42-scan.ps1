<#
p0-07 / 刑部(quality-security, verification) · 04-spec §S4.2 禁用符号/包名可重放扫描器
案卷 stcp-cross-platform-001

用法（在仓库任意目录）：
  pwsh -NoProfile -File .tang\cases\stcp-cross-platform-001\evidence\p0-07-s42-scan.ps1 -Path <目录或文件> [-Scope Source|Assets|All]

- 默认 -Scope All。
  Source 面：*.cs / *.csproj / *.yml / *.yaml，排除路径含 \bin\、\obj\、\.git\ 的文件。
  Assets 面：仅路径含 \bin\ 的文件——*.deps.json 内容做包名扫描，全部文件名做原生资产名扫描。
- 符号规则（R*/X*/I*）作用于 .cs 原文（含注释行，门禁从严：注释中的符号出现也计命中，由复核人处置）。
- 包名规则（P*）作用于 .csproj/.yml/.deps.json；.csproj/.yml 中的注释行单独标记为
  [COMMENT-ONLY]（csproj XML 注释按 <!-- --> 状态机逐行判定，YAML 按行首 # 判定），
  门禁判定只计非注释行命中，注释提及如实列出。
- 规则-条款映射（详见 p0-07-quality-gates.md §2）：
  R*  = 04-spec §S4.2 ①-⑨ 字面条款；X* = §S4.2 加强（变体形态，标注 +）；
  P*  = §S4.2 包名条款（①④⑤⑩ 及 VoskWorker）；N* = §S4.2 ⑨⑩ 资产文件名；
  I*  = 机制观察规则，不计入门禁命中，仅供 C 档机制证据交叉验证。
- R-2（2026-09-03，尚书省裁定落档 p0-07-quality-gates.md §11）：平台条件文件两形态——(a) 全文件以裸
  `#if PLATFORMS_WINDOWS` 首行、裸 `#endif` 末行包裹的 .cs；(b) 文件名 `*Windows.cs` 且全部禁用符号行均处于
  该 guard 内。qualifying 条件文件内、处于正向 `#if/#elif PLATFORMS_WINDOWS` guard 中的 R*/X* 门禁符号命中 →
  CONDITIONAL 计数（非门禁，逐文件清单留证，供终检核对属 06 明示 Windows-专属项）；guard 外命中、#else 分支
  命中、非两形态文件的内部 guard 命中一律仍为 GateHits（从严不变）。guard 行须为裸条件文本（尾部注释/复合
  条件/取反 !PLATFORMS_WINDOWS 不识别，从严）；`//` 行注释不参与 guard 状态；块注释内伪指令未剔除（罕见，
  复核方留意）。P*/N*/I* 语义零改动。CONDITIONAL>0 时 VERDICT 仍 PASS（报告列清单）；退出码仅由 GateHits 决定。
- 退出码：0 = 门禁命中为零（PASS）；1 = 存在门禁命中（FAIL）；2 = 参数/路径错误。
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Path,
  [ValidateSet('Source', 'Assets', 'All')][string]$Scope = 'All'
)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Path)) { Write-Output "ERROR: path not found: $Path"; exit 2 }

$csRules = @(
  @{Id='R01'; Pat='using\s+Windows\.Win32\b';                          Clause='S4.2-(1) using Windows.Win32 / PInvoke.* (CsWin32)'},
  @{Id='R02'; Pat='\bPInvoke\.';                                       Clause='S4.2-(1) PInvoke.* (CsWin32)'},
  @{Id='R03'; Pat='using\s+System\.Windows\.Forms\b';                  Clause='S4.2-(2) using System.Windows.Forms'},
  @{Id='R04'; Pat='System\.Windows\.Forms\.';                          Clause='S4.2-(2) System.Windows.Forms.*'},
  @{Id='R05'; Pat='using\s+Microsoft\.Win32\b';                        Clause='S4.2-(3) using Microsoft.Win32 (registry)'},
  @{Id='R06'; Pat='Microsoft\.Win32\.';                                Clause='S4.2-(3) Microsoft.Win32.* (registry)'},
  @{Id='R07'; Pat='using\s+System\.Management\b';                      Clause='S4.2-(4) using System.Management (WMI)'},
  @{Id='R08'; Pat='System\.Management\.';                              Clause='S4.2-(4) System.Management.* (WMI)'},
  @{Id='R09'; Pat='using\s+System\.Speech\b';                          Clause='S4.2-(5) using System.Speech'},
  @{Id='R10'; Pat='System\.Speech\.';                                  Clause='S4.2-(5) System.Speech.*'},
  @{Id='R11'; Pat='using\s+Windows\.Media\b|Windows\.Media\.';         Clause='S4.2-(6) WinRT Windows.Media.* (Ocr/Control)'},
  @{Id='R12'; Pat='using\s+Windows\.Security\b|Windows\.Security\.';   Clause='S4.2-(7) WinRT Windows.Security.*'},
  @{Id='R13'; Pat='\bDllImport\b';                                     Clause='S4.2-(8) DllImport'},
  @{Id='R14'; Pat='\bLibraryImport\b';                                 Clause='S4.2-(8) LibraryImport'},
  @{Id='R15'; Pat='\bcmd\.exe\b';                                      Clause='S4.2-(9) process cmd.exe'},
  @{Id='R16'; Pat='\brobocopy\.exe\b';                                 Clause='S4.2-(9) process robocopy.exe'},
  @{Id='R17'; Pat='\brundll32\.exe\b';                                 Clause='S4.2-(9) process rundll32.exe'},
  @{Id='R18'; Pat='\bDisplaySwitch\.exe\b';                            Clause='S4.2-(9) process DisplaySwitch.exe'},
  @{Id='R19'; Pat='\bffmpeg\.exe\b';                                   Clause='S4.2-(9) process ffmpeg.exe'},
  @{Id='R20'; Pat='SystemTools\.VoskWorker\.exe';                      Clause='S4.2-(9) process SystemTools.VoskWorker.exe'},
  @{Id='R21'; Pat='["'']shutdown(\.exe)?["'']|\bshutdown\.exe\b';      Clause='S4.2-(9) process shutdown (quoted/exe)'},
  @{Id='X01'; Pat='["'']cmd["'']|\bcmd\s+/c';                          Clause='S4.2-(9)+ cmd variant (no .exe / cmd /c)'},
  @{Id='X02'; Pat='["'']rundll32["'']';                                Clause='S4.2-(9)+ rundll32 variant (no .exe)'},
  @{Id='X03'; Pat='\bSendKeys\b';                                      Clause='S4.2-(2)+ WinForms SendKeys'},
  @{Id='X04'; Pat='["''](user32|ntdll|kernel32|psapi|advapi32|winbio|gdi32)\.dll["'']'; Clause='S4.2-(8)+ native lib name string'},
  @{Id='X05'; Pat='\bGetFfmpegPath\b';                                 Clause='S4.2-(9)+ ffmpeg native accessor'},
  @{Id='X06'; Pat='\w+\.bat\b';                                        Clause='S4.2-(9)+ Windows batch process/generation'},
  @{Id='X07'; Pat='\bWindowsIdentity\b|\bWindowsPrincipal\b';          Clause='S4.2-(9)+ Windows identity/elevation'},
  @{Id='X08'; Pat='["'']runas["'']';                                   Clause='S4.2-(9)+ UAC verb runas'},
  @{Id='I01'; Pat='\bkeybd_event\b';                                   Clause='INFO Win32 key injection'},
  @{Id='I02'; Pat='\bmouse_event\b';                                   Clause='INFO Win32 mouse injection'},
  @{Id='I03'; Pat='\bGetForegroundWindow\b|\bSetWindowPos\b';          Clause='INFO foreground/window-position'},
  @{Id='I04'; Pat='\bSystemParametersInfo\b';                          Clause='INFO user32 personalization'},
  @{Id='I05'; Pat='\bManagementScope\b|\bManagementObjectSearcher\b';  Clause='INFO WMI mechanism'},
  @{Id='I06'; Pat='\bSetWindowsHookEx\b';                              Clause='INFO low-level hook'},
  @{Id='I07'; Pat='\bCopyFromScreen\b';                                Clause='INFO GDI screen capture'},
  @{Id='I08'; Pat='\bIMMDevice\b|\bIAudioEndpointVolume\b';            Clause='INFO Core Audio COM'},
  @{Id='I09'; Pat='\bRegisterDeviceNotification\b';                    Clause='INFO device notification'},
  @{Id='I10'; Pat='Get-PnpDevice|Disable-PnpDevice|Enable-PnpDevice';  Clause='INFO PnP PowerShell'},
  @{Id='I11'; Pat='\bVosk\b';                                          Clause='INFO Vosk voice'}
)
$pkgRules = @(
  @{Id='P01'; Pat='CsWin32';                 Clause='S4.2-(1) package CsWin32'},
  @{Id='P02'; Pat='System\.Management';      Clause='S4.2-(4) package System.Management'},
  @{Id='P03'; Pat='System\.Speech';          Clause='S4.2-(5) package System.Speech'},
  @{Id='P04'; Pat='DlibDotNet';              Clause='S4.2-(10) package DlibDotNet'},
  @{Id='P05'; Pat='OpenCvSharp4';            Clause='S4.2-(10) package OpenCvSharp4*'},
  @{Id='P06'; Pat='NAudio\.Wasapi';          Clause='S4.2-(10) package NAudio.Wasapi'},
  @{Id='P07'; Pat='SystemTools\.VoskWorker'; Clause='S4.2-(9) VoskWorker runtime/package'}
)
$nameRules = @(
  @{Id='N01'; Pat='(?i)(OpenCvSharpExtern|DlibDotNetNative|ffmpeg|avcodec|avformat|avutil|swscale|onnxruntime)'; Clause='S4.2-(10) native asset name'},
  @{Id='N02'; Pat='(?i)VoskWorker'; Clause='S4.2-(9) VoskWorker asset name'}
)

$out = @()
$out += '=== S4.2 SCAN (stcp-cross-platform-001 / p0-07) ==='
$out += ('Path     : ' + $Path)
$out += ('Scope    : ' + $Scope)
$out += 'ScannerRev: R-2 (2026-09-03: R-1 single-file fix + R-2 PLATFORMS_WINDOWS conditional files; see p0-07-quality-gates.md section 11)'
$out += ('Time(UTC): ' + (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))

$item = Get-Item -LiteralPath $Path
if ($item.PSIsContainer) { $allFiles = Get-ChildItem -LiteralPath $item.FullName -Recurse -File | Sort-Object FullName }
else { $allFiles = @($item) }

$rootPrefix = if ($item.PSIsContainer) { $item.FullName.TrimEnd('\') + '\' } else { $item.DirectoryName + '\' }
$srcFiles = @(); $assetFiles = @()
foreach ($f in $allFiles) {
  $inBin  = $f.FullName -like '*\bin\*'
  $inExcl = $f.FullName -like '*\obj\*' -or $f.FullName -like '*\.git\*'
  if ($inExcl) { continue }
  $ext = $f.Extension.ToLower()
  if (-not $inBin -and ($ext -in '.cs','.csproj','.yml','.yaml')) { $srcFiles += $f }
  if ($inBin) { $assetFiles += $f }
}
if ($Scope -eq 'Source') { $assetFiles = @() }

$gateCount = 0; $infoCount = 0; $commentOnlyCount = 0; $conditionalCount = 0   # R-2
$gateHitFiles = @{}; $zeroHitFiles = @{}; $conditionalFiles = @{}             # R-2

function Add-Hit([string]$kind, [string]$rel, $rule, [int]$lineNo, [string]$text) {
  $t = $text.Trim()
  if ($t.Length -gt 160) { $t = $t.Substring(0, 160) + '...' }
  $script:out += ('[{0}] {1} | {2} | :{3}: | {4}' -f $kind, $rel, $rule.Id, $lineNo, $t)
}

foreach ($f in $srcFiles) {
  $rel = $f.FullName.Substring($rootPrefix.Length)
  $lines = @(Get-Content -LiteralPath $f.FullName)
  $isComment = New-Object 'System.Collections.Generic.List[bool]'
  if ($f.Extension.ToLower() -eq '.csproj') {
    $inXml = $false
    foreach ($l in $lines) {
      $startIn = $inXml
      $pos = 0
      while ($true) {
        if (-not $inXml) { $idx = $l.IndexOf('<!--', $pos); if ($idx -lt 0) { break }; $inXml = $true; $pos = $idx + 4 }
        else { $idx = $l.IndexOf('-->', $pos); if ($idx -lt 0) { break }; $inXml = $false; $pos = $idx + 3 }
      }
      $isComment.Add(($startIn -or ($l -match '<!--')))
    }
  } elseif (($f.Extension.ToLower() -eq '.yml') -or ($f.Extension.ToLower() -eq '.yaml')) {
    foreach ($l in $lines) { $isComment.Add(($l -match '^\s*#')) }
  } else {
    foreach ($l in $lines) { $isComment.Add($false) }
  }
  # R-2: conditional-file eligibility (two forms only) + line-level PLATFORMS_WINDOWS guard tracking
  $isCs = ($f.Extension.ToLower() -eq '.cs')
  $qualifies = $false
  if ($isCs) {
    if ($f.Name -like '*Windows.cs') { $qualifies = $true }
    $nb = @($lines | Where-Object { $_.Trim().Length -gt 0 })
    if (($nb.Count -ge 2) -and ($nb[0].Trim() -match '^#\s*if\s+PLATFORMS_WINDOWS\s*$') -and ($nb[$nb.Count - 1].Trim() -match '^#\s*endif\s*$')) { $qualifies = $true }
  }
  $guardStack = New-Object 'System.Collections.Generic.List[string]'
  $fileGate = @(); $fileInfo = @(); $fileCond = @()
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $guarded = $false
    if ($isCs) {
      $tl = $lines[$i].Trim()
      if (-not $tl.StartsWith('//')) {
        if ($tl -match '^#\s*if\s+PLATFORMS_WINDOWS\s*$') { $guardStack.Add('PW') }
        elseif ($tl -match '^#\s*if\b') { $guardStack.Add('OT') }
        elseif ($tl -match '^#\s*elif\s+PLATFORMS_WINDOWS\s*$') { if ($guardStack.Count -gt 0) { $guardStack.RemoveAt($guardStack.Count - 1) }; $guardStack.Add('PW') }
        elseif ($tl -match '^#\s*elif\b') { if ($guardStack.Count -gt 0) { $guardStack.RemoveAt($guardStack.Count - 1) }; $guardStack.Add('OT') }
        elseif ($tl -match '^#\s*else\b') { if ($guardStack.Count -gt 0) { $guardStack.RemoveAt($guardStack.Count - 1) }; $guardStack.Add('EL') }
        elseif ($tl -match '^#\s*endif\b') { if ($guardStack.Count -gt 0) { $guardStack.RemoveAt($guardStack.Count - 1) } }
      }
      $guarded = ($guardStack -contains 'PW')
    }
    foreach ($r in $csRules) {
      if ($lines[$i] -match $r.Pat) {
        if ($r.Id.StartsWith('I')) { Add-Hit 'INFO' $rel $r ($i + 1) $lines[$i]; $script:infoCount++; $fileInfo += $r.Id }
        elseif ($qualifies -and $guarded) { Add-Hit 'CONDITIONAL' $rel $r ($i + 1) $lines[$i]; $script:conditionalCount++; $fileCond += $r.Id }
        else { Add-Hit 'HIT-GATE' $rel $r ($i + 1) $lines[$i]; $script:gateCount++; $fileGate += $r.Id }
      }
    }
  }
  if (($f.Extension.ToLower() -in '.csproj', '.yml', '.yaml') -and ($Scope -ne 'Assets')) {
    for ($i = 0; $i -lt $lines.Count; $i++) {
      foreach ($r in $pkgRules) {
        if ($lines[$i] -match $r.Pat) {
          if ($isComment[$i]) { Add-Hit 'COMMENT-ONLY' $rel $r ($i + 1) $lines[$i]; $script:commentOnlyCount++ }
          else { Add-Hit 'HIT-GATE' $rel $r ($i + 1) $lines[$i]; $script:gateCount++; $fileGate += $r.Id }
        }
      }
    }
  }
  if ($fileGate.Count -gt 0) { $gateHitFiles[$rel] = ($fileGate | Select-Object -Unique) -join ',' }
  else { $zeroHitFiles[$rel] = (($fileInfo | Select-Object -Unique) -join ',') }
  if ($fileCond.Count -gt 0) { $conditionalFiles[$rel] = ($fileCond | Select-Object -Unique) -join ',' }
}

foreach ($f in $assetFiles) {
  $rel = $f.FullName.Substring($rootPrefix.Length)
  foreach ($r in $nameRules) {
    if ($f.Name -match $r.Pat) { Add-Hit 'HIT-GATE-NAME' $rel $r 0 $f.Name; $script:gateCount++ }
  }
  if ($f.Name -eq 'SystemTools.CrossPlatform.deps.json' -or $f.Extension -eq '.json') {
    $lines = @(Get-Content -LiteralPath $f.FullName)
    $fileGate = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
      foreach ($r in $pkgRules) {
        if ($lines[$i] -match $r.Pat) { Add-Hit 'HIT-GATE' $rel $r ($i + 1) $lines[$i]; $script:gateCount++; $fileGate += $r.Id }
      }
    }
    if ($fileGate.Count -gt 0) { $gateHitFiles[$rel] = ($fileGate | Select-Object -Unique) -join ',' }
  }
}

$out += '--- SUMMARY ---'
$out += ('SourceFiles   : ' + $srcFiles.Count)
$out += ('AssetFiles    : ' + $assetFiles.Count)
$out += ('GateHits      : ' + $gateCount)
$out += ('CommentOnly   : ' + $commentOnlyCount + ' (non-gating, listed above)')
$out += ('InfoHits      : ' + $infoCount)
$out += ('ConditionalHits: ' + $conditionalCount + ' (R-2 non-gating; verify listed files against 06 documented Windows-specific items)')
$out += '--- GATE-HIT FILES ---'
if ($gateHitFiles.Count -eq 0) { $out += '(none)' } else { foreach ($k in ($gateHitFiles.Keys | Sort-Object)) { $out += ($k + ' : ' + $gateHitFiles[$k]) } }
$out += '--- CONDITIONAL FILES (R-2: guarded Windows-specific symbols; non-gating) ---'
if ($conditionalFiles.Count -eq 0) { $out += '(none)' } else { foreach ($k in ($conditionalFiles.Keys | Sort-Object)) { $out += ($k + ' : ' + $conditionalFiles[$k]) } }
$out += '--- ZERO-HIT SOURCE FILES (gate rules; INFO rules in parens) ---'
if ($zeroHitFiles.Count -eq 0) { $out += '(none)' } else { foreach ($k in ($zeroHitFiles.Keys | Sort-Object)) { $z = $zeroHitFiles[$k]; if ($z) { $out += ($k + ' : (' + $z + ')') } else { $out += $k } } }
if ($gateCount -eq 0) { $v = 'VERDICT: PASS (zero gate hits)'; if ($conditionalCount -gt 0) { $v = $v + ' [CONDITIONAL=' + $conditionalCount + ' R-2: verify against 06 documented items]' }; $out += $v } else { $out += 'VERDICT: FAIL (gate hits present)' }
$out | Write-Output
if ($gateCount -eq 0) { exit 0 } else { exit 1 }
