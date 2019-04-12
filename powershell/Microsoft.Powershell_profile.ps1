Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function ViExit

$env:home = $HOME;

Set-Alias -Name vim -Value "C:\Program Files (x86)\Vim\vim81\gvim.exe";
$env:home = $HOME;

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

# Dev Command Prompt Functionality in Powershell
function devcmd {
    $installationPath = vswhere.exe -prerelease -latest -property installationPath;
    if ($installationPath -and (test-path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
        & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -no_logo && set" | foreach-object {
            $name, $value = $_ -split '=', 2;
            set-content env:\"$name" $value;
        }
    }
}
