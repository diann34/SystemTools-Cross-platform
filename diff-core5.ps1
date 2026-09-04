param()

$orig = 'E:\My Github Projects\SystemTools'
$cp   = 'E:\My Github Projects\SystemTools-Cross-platform\src\SystemTools.CrossPlatform'

function Show-Diff($rel, $maxLines) {
  Write-Output ""
  Write-Output ("########## DIFF: {0} ##########" -f $rel)
  $a = Get-Content -LiteralPath (Join-Path $orig $rel)
  $b = Get-Content -LiteralPath (Join-Path $cp $rel)
  $set = Compare-Object -ReferenceObject $a -DifferenceObject $b -IncludeEqual:$false
  $removed = @($set | Where-Object SideIndicator -eq '<=' | ForEach-Object { "- " + $_.InputObject })
  $added   = @($set | Where-Object SideIndicator -eq '=>' | ForEach-Object { "+ " + $_.InputObject })
  $removed = @($removed | Where-Object { $_.Trim() -notmatch '^[-]?s*[{}();]*$' })
  $lines = $removed + $added
  if ($lines.Count -eq 0) { Write-Output "(only whitespace)" }
  elseif ($lines.Count -gt $maxLines) {
    Write-Output ($lines[0..($maxLines-1)] -join "`n")
    Write-Output ("... [truncated at {0} of {1}]" -f $maxLines, $lines.Count)
  } else { Write-Output ($lines -join "`n") }
}

Show-Diff 'Themes/ClassWidgets/manifest.yml' 20
Show-Diff 'SettingsPage/AboutSettingsPage.axaml' 80
Show-Diff 'Views/AiChatFloatingWindow.axaml' 80
Show-Diff 'SettingsPage/PluginDebugSettingsPage.axaml' 40
Show-Diff 'Shared/GlobalConstants.cs' 50
