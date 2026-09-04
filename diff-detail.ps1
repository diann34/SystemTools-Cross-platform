param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

function Show-Diff($rel, $maxLines) {
  Write-Output ""
  Write-Output ("########## DIFF: {0} ##########" -f $rel)
  $a = Get-Content -LiteralPath (Join-Path $orig $rel)
  $b = Get-Content -LiteralPath (Join-Path $cp $rel)
  $set = Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false
  # order: removed lines (in a, not b) then added (in b, not a) - use SyncRoot ordering
  $removed = @($set | Where-Object SideIndicator -eq '<=' | ForEach-Object { "- " + $_.InputObject })
  $added   = @($set | Where-Object SideIndicator -eq '=>' | ForEach-Object { "+ " + $_.InputObject })
  $lines = $removed + $added
  if ($lines.Count -eq 0) { Write-Output "(only whitespace/formatting differences)" }
  elseif ($lines.Count -gt $maxLines) {
    Write-Output ($lines[0..($maxLines-1)] -join "`n")
    Write-Output ("... [truncated at {0} of {1} diff lines]" -f $maxLines, $lines.Count)
  } else {
    Write-Output ($lines -join "`n")
  }
}

Show-Diff 'Controls/Components/NetworkStatusComponent.axaml' 30
Show-Diff 'Settings/ShutdownSettings.cs' 30
Show-Diff 'Themes/NotchStyle/Styles.axaml' 15
Show-Diff 'Actions/KillProcessAction.cs' 90
Show-Diff 'Controls/KillProcessSettingsControl.cs' 60
Show-Diff 'Rules/Handlers/ProcessRunningRuleHandler.cs' 30
