param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

# For big files: show only the added lines (what's new) and a summary of removed regions
function Show-DiffAdded($rel, $maxLines) {
  Write-Output ""
  Write-Output ("########## ADDED LINES in CP: {0} ##########" -f $rel)
  $a = Get-Content -LiteralPath (Join-Path $orig $rel)
  $b = Get-Content -LiteralPath (Join-Path $cp $rel)
  $set = Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false
  $added = @($set | Where-Object SideIndicator -eq '=>' | ForEach-Object { "+ " + $_.InputObject })
  if ($added.Count -eq 0) { Write-Output "(nothing added)" }
  elseif ($added.Count -gt $maxLines) {
    Write-Output ($added[0..($maxLines-1)] -join "`n")
    Write-Output ("... [truncated at {0} of {1} added lines]" -f $maxLines, $added.Count)
  } else { Write-Output ($added -join "`n") }
}

function Show-DiffRemoved($rel, $maxLines) {
  Write-Output ""
  Write-Output ("########## REMOVED LINES from ORIG: {0} ##########" -f $rel)
  $a = Get-Content -LiteralPath (Join-Path $orig $rel)
  $b = Get-Content -LiteralPath (Join-Path $cp $rel)
  $set = Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false
  $removed = @($set | Where-Object SideIndicator -eq '<=' | ForEach-Object { "- " + $_.InputObject })
  # filter out pure-brace noise
  $removed = @($removed | Where-Object { $_.Trim() -notmatch '^[-]?s*[{}();]*$' })
  if ($removed.Count -eq 0) { Write-Output "(nothing significant)" }
  elseif ($removed.Count -gt $maxLines) {
    Write-Output ($removed[0..($maxLines-1)] -join "`n")
    Write-Output ("... [truncated at {0} of {1} removed lines]" -f $maxLines, $removed.Count)
  } else { Write-Output ($removed -join "`n") }
}

Show-DiffRemoved 'Services/FloatingWindowService.cs' 120
Show-DiffAdded 'Services/FloatingWindowService.cs' 60
