$StartupPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$ProgramName="Kanata"
# change the executable path
$KanataPath=(get-command kanata_winiov2.exe).Path
# change the config path
$KanataConfigPath="$PSScriptRoot/default.kbd"
$StartupCommand="C:\Windows\system32\conhost.exe --headless $KanataPath --cfg $KanataConfigPath"
Set-ItemProperty -LiteralPath "$StartupPath" -Name "$ProgramName" -Value "$StartupCommand"
