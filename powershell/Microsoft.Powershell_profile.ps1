Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function ViExit

Set-Alias -Name vim -Value "C:\Program Files (x86)\Vim\vim81\gvim.exe";
