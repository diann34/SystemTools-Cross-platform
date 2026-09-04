param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

function Show-Diff($rel, $maxLines, $mode) {
  Write-Output ""
  Write-Output ("########## {0}: {1} ##########" -f $mode.ToUpper(), $rel)
  $a = Get-Content -LiteralPath (Join-Path $orig $rel)
  $b = Get-Content -LiteralPath (Join-Path $cp $rel)
  $set = Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false
  $removed = @($set | Where-Object SideIndicator -eq '<=' | ForEach-Object { "- " + $_.InputObject })
  $added   = @($set | Where-Object SideIndicator -eq '=>' | ForEach-Object { "+ " + $_.InputObject })
  $removed = @($removed | Where-Object { $_.Trim() -notmatch '^[-]?s*[{}();]*$' })
  $lines = if ($mode -eq 'added') { $added } else { $removed }
  if ($lines.Count -eq 0) { Write-Output "(nothing)" }
  elseif ($lines.Count -gt $maxLines) {
    Write-Output ($lines[0..($maxLines-1)] -join "`n")
    Write-Output ("... [truncated at {0} of {1}]" -f $maxLines, $lines.Count)
  } else { Write-Output ($lines -join "`n") }
}

# Plugin.cs: what actions/triggers got dropped from registration
Show-Diff 'Plugin.cs' 200 'removed'
