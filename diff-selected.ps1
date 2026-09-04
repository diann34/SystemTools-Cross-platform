param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

# 1) List the 5 identical files
function Get-ProductFiles($root) {
  Get-ChildItem -LiteralPath $root -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\','/'
    $skip = $false
    foreach ($seg in $rel -split '/') {
      if ($seg -in @('bin','obj','.git','.idea','.codex-tests','cipx','ClassIsland','.tools','.tang','Properties')) { $skip = $true }
    }
    if (-not $skip) {
      [PSCustomObject]@{ Rel = $rel; Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash }
    }
  }
}
$o = Get-ProductFiles $orig
$c = Get-ProductFiles $cp
$cMap = @{}; foreach ($f in $c) { $cMap[$f.Rel] = $f.Hash }
Write-Output "=== IDENTICAL FILES ==="
foreach ($f in $o) {
  if ($cMap.ContainsKey($f.Rel) -and $cMap[$f.Rel] -eq $f.Hash) { Write-Output $f.Rel }
}

# 2) Line-level diff stats for every common file (added/removed counts)
Write-Output ""
Write-Output "=== LINE DIFF STATS (common files, removed/added) ==="
$stats = foreach ($f in $o) {
  if ($cMap.ContainsKey($f.Rel) -and $cMap[$f.Rel] -ne $f.Hash) {
    $a = Get-Content -LiteralPath (Join-Path $orig $f.Rel)
    $b = Get-Content -LiteralPath (Join-Path $cp $f.Rel)
    $diff = Compare-Object -ReferenceObject $a -DifferenceObject $b
    $removed = @($diff | Where-Object SideIndicator -eq '<=').Count
    $added   = @($diff | Where-Object SideIndicator -eq '=>').Count
    [PSCustomObject]@{ Rel = $f.Rel; Removed = $removed; Added = $added }
  }
}
$stats | Sort-Object { ($_.Removed + $_.Added) } -Descending | ForEach-Object {
  "{0}  -{1}/+{2}" -f $_.Rel, $_.Removed, $_.Added
}
