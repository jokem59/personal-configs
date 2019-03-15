Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function ViExit

Set-Alias -Name vim -Value "C:\Program Files (x86)\Vim\vim81\gvim.exe";

function emacs {
    param($p1, $p2, $p3, $p4)
    if ($p1)
    {
        emacsclientw.exe -n --no-wait --alternate-editor="runemacs.exe" $p1 $p2 $p3 $p4;
        return;
    }

    $emacs = Get-Process | Where-Object {$_.Name -like "emacs"};
    if ($emacs)
    {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic");
        [Microsoft.VisualBasic.Interaction]::AppActivate($emacs.Id);
    }
    else
    {
        emacsclientw.exe -n --no-wait --alternate-editor="runemacs.exe" -e '';
    }
}
