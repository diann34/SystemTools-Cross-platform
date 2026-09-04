param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

function Get-ProductFiles($root) {
  Get-ChildItem -LiteralPath $root -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\','/'
    $skip = $false
    foreach ($seg in $rel -split '/') {
      if ($seg -in @('bin','obj','.git','.idea','.codex-tests','cipx','ClassIsland','.tools','.tang','Properties')) { $skip = $true }
    }
    if (-not $skip) {
      [PSCustomObject]@{
        Rel = $rel
        Len = $_.Length
        Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
      }
    }
  }
}

$o = Get-ProductFiles $orig
$c = Get-ProductFiles $cp

$oMap = @{}; foreach ($f in $o) { $oMap[$f.Rel] = $f }
$cMap = @{}; foreach ($f in $c) { $cMap[$f.Rel] = $f }

$all = ($oMap.Keys + $cMap.Keys) | Sort-Object -Unique
$rows = foreach ($k in $all) {
  $inO = $oMap.ContainsKey($k); $inC = $cMap.ContainsKey($k)
  if ($inO -and $inC) {
    if ($oMap[$k].Hash -eq $cMap[$k].Hash) { [PSCustomObject]@{S='SAME'; Rel=$k; O=$oMap[$k].Len; C=$cMap[$k].Len} }
    else { [PSCustomObject]@{S='DIFF'; Rel=$k; O=$oMap[$k].Len; C=$cMap[$k].Len} }
  } elseif ($inO) { [PSCustomObject]@{S='ORIG-ONLY'; Rel=$k; O=$oMap[$k].Len; C=0} }
  else { [PSCustomObject]@{S='CP-ONLY'; Rel=$k; O=0; C=$cMap[$k].Len} }
}

$same = @($rows | Where-Object S -eq 'SAME')
$diff = @($rows | Where-Object S -eq 'DIFF')
$oo   = @($rows | Where-Object S -eq 'ORIG-ONLY')
$co   = @($rows | Where-Object S -eq 'CP-ONLY')

Write-Output ("SAME={0} DIFF={1} ORIG-ONLY={2} CP-ONLY={3}" -f $same.Count, $diff.Count, $oo.Count, $co.Count)
Write-Output ""
Write-Output "### DIFF (present in both, content differs) ###"
$diff | ForEach-Object { "{0}  [orig {1}B / cp {2}B]" -f $_.Rel, $_.O, $_.C }
Write-Output ""
Write-Output "### ORIG-ONLY (dropped in cross-platform) ###"
$oo | ForEach-Object { "{0}  [{1}B]" -f $_.Rel, $_.O }
Write-Output ""
Write-Output "### CP-ONLY (new in cross-platform) ###"
$co | ForEach-Object { "{0}  [{1}B]" -f $_.Rel, $_.C }
