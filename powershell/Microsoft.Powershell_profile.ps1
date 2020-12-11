Write-Host "*********************";
Write-Host "*  Loading Profile  *";
Write-Host "*********************";

if ($env:USERDNSDOMAIN -ne $NULL)
{
    Import-Module "~\OneDrive\Documents\WindowsPowerShell\Work_Profile.psm1";
}

Set-PSReadlineOption -BellStyle None;
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete;

Set-PSReadlineOption -EditMode Emacs;
Set-PSReadlineKeyHandler -Chord Ctrl+x,k -Function ViExit;
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function Cut;
Set-PSReadlineKeyHandler -Chord Alt+w -Function Copy;
Set-PSReadlineKeyHandler -Chord Ctrl+y -Function Paste;
Set-PSReadlineKeyHandler -Chord Ctrl+k -Function KillLine;
Set-PSReadlineKeyHandler -Chord "Ctrl+x,h" -Function SelectAll;
Set-PSReadlineKeyHandler -Chord "Ctrl+/" -Function UndoAll;
Set-PSReadlineKeyHandler -Chord "Ctrl+Shift+?" -Function Redo;

$env:home = $HOME;

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile";
}

function em {
    param($p1, $p2, $p3, $p4)
    if ($p1)
    {
         emacsclientw.exe -n --no-wait --alternate-editor="runemacs.exe" $p1 $p2 $p3 $p4;
        return;
    }

    $emacs = Get-Process | Where-Object {$_.Name -like "emacs"};
    if ($emacs)
    {
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAp {
      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      public static extern bool SetForegroundWindow(IntPtr hWnd);
      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
        $h = $emacs.MainWindowHandle;
        [void] [WinAp]::SetForegroundWindow($h);

#        [void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic");
#        [Microsoft.VisualBasic.Interaction]::AppActivate($emacs.Id);
    }
    else
    {
        emacsclientw.exe -n --no-wait --alternate-editor="runemacs.exe" -e '';
    }
}

function ConvertTo-MsvcVersion {
param
(
    [string]
    $ImageName,

    [ValidateSet('VcToolsetVer','Year', 'CMakeGeneratorNum')]
    [string]
    $Format = 'VcToolsetVer'
)
    ./ConvertTo-MsvcVersion.ps1 -ImageName $ImageName -Format $Format;
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

<#
    Following this: https://stackoverflow.com/questions/1398445/directory-structure-for-a-c-library
    ./         Makefile and configure scripts.
    ./src      General sources
    ./include  Header files that expose the public interface and are to be installed
    ./lib      Library build directory
    ./bin      Tools build directory
    ./tools    Tools sources
    ./test     Test suites that should be run during a `make test`

#>
function New-CppProject {
    mkdir src;
    mkdir include;
    mkdir lib;
    mkdir bin;
    mkdir tools;
    mkdir test;
    mkdir docs;
    mkdir build;
}

function Get-StringHash256 {
    param(
        [Parameter(Mandatory=$true)]
        $String
    )

    $stream = [IO.MemoryStream]::new([byte[]][char[]]$String);
    return Get-FileHash -InputStream $stream -Algorithm SHA256;
}
