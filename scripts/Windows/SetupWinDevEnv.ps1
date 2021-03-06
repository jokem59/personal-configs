# Run from Admin powershell

$CONFIG_HOME = "C:\tools\personal-configs";
$POWERSHELL_PROFILE = "Microsoft.PowerShell_profile.ps1";
$USER_PSMODULE_PATH = $env:PSModulePath.Split(';')[0];
$STARTUP_FOLDER = "~/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup";

function Get-PersonalConfigs {
    Write-Host "Getting personal configs...";
    $GIT_TEMP = "C:\gittemp"
    # Create directory C:\tools
    # git clone into C:\tools
    New-Item -ItemType Directory -Path $CONFIG_HOME;
    git clone https://github.com/jokem59/personal-configs.git $GIT_TEMP;
    Move-Item -Path $GIT_TEMP/.git -Destination $CONFIG_HOME;
    Move-Item -Path $GIT_TEMP/* -Destination $CONFIG_HOME;
    Remove-Item -Path $GIT_TEMP -Recurse -Force;
}

function Get-Choco {
    Write-Host "Getting Choco...";
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
}

# TODO: Move tools to c:\tools
function Get-ChocoPackages {
    Write-Host "Getting Choco Packages...";
    choco install googlechrome -y;
    choco install git -y;
    choco install cmder -y;
    choco install ripgrep -y;
    choco install emacs -y;
    choco install sysinternals -y;
    choco install syncthing -y;
    choco install rust-ms -y;
    choco install vswhere -y;
    choco install msbuild-structured-log-viewer -y;
    choco install cmake -y;
    choco install vscode -y;
    choco install poshgit -y;
    choco install 7zip -y;
}

function Install-PostGitModule {
    mkdir $USER_PSMODULE_PATH;
    mkdir "$USER_PSMODULE_PATH\poshgit";

    $poshModule = Get-ChildItem c:/tools/poshgit *src* -Recurse -Directory;
    cp "$poshModule.FullName/*" "$USER_PSMODULE_PATH\poshgit";

    Install-Module posh-git;
}

# TODO: Download dependency walker tool

# TOOD: Create generic set symlink function

# NOTE: This must be run BEFORE the files/directories references are created
# Creates symlink to $CONFIG_HOME for easy git management
function Set-SymLinks {
    Write-Host "Setting symlinks/junctions...";
    # Creates new symbolic link file in $home/.vimrc that is linked to $CONFIG_HOME\.vimrc
    New-Item -ItemType SymbolicLink -Path $home -Name .vimrc -Value $CONFIG_HOME\vim\.vimrc;

    New-Item -ItemType SymbolicLink -Path $home -Name vimfiles -Value $CONFIG_HOME\vim\vimfiles;

    New-Item -ItemType SymbolicLink -Path $home -Name .gitconfig -Value $CONFIG_HOME\.gitconfig;

    New-Item -ItemType SymbolicLink -Path $home -Name .gitconfig_global -value $CONFIG_HOME\.gitignore_global;

    New-Item -ItemType Junction -Path $home -Name .emacs.d -Value $CONFIG_HOME\emacs\.emacs.d;

    $splitIndex = $profile.IndexOf($POWERSHELL_PROFILE);
    $profilePath = $profile.Substring(0, $splitIndex);
    New-Item -ItemType SymbolicLink -Path $profilePath -Name $POWERSHELL_PROFILE -Value $CONFIG_HOME\powershell\$POWERSHELL_PROFILE;

    New-Item -ItemType SymbolicLink -Path "C:\tools\Cmder\vendor\conemu-maximus5" -Name ConEmu.xml -Value $CONFIG_HOME\cmder\ConEmu.xml;

    New-Item -ItemType SymbolicLink -Path $STARTUP_FOLDER -Name "Syncthing.lnk" -Value "C:\ProgramData\chocolatey\bin\Syncthing.exe";
}

function Set-GitGlobalSettings {
    Write-Host "Setting git global settings...";
    iex (git config --global core.excludesfile ~/.gitignore_global);
}

# TODO: Create function to setup cmder
# Cmder should point to $Profile (this is mainly to support FcShell) (or change conemu settings and remove the default `-NoProfile` setting

function Set-EmacsDaemonStartup {
    Write-Host "Setting Emacs daemon on startup...";
    $startup_file = "$([Environment]::GetFolderPath('Startup'))\StartEmacsServer.bat";

    # Location of runemacs.exe will differ if installed via Chocolatey (C:\users\<username>) or Traditional means (%APPDATA%)
    New-Item $startup_file -type file;
    Set-Content -Path $startup_file -Value "set HOME=%APPDATA%";
    Add-Content -Path $startup_file -Value "del /Q ""%HOME%/.emacs.d/server/*""";
    Add-Content -Path $startup_file -Value "runemacs.exe --daemon";
}

function Get-Fonts {
    Write-Host "Getting fonts...";
    $roboto_mono_uris = @("Regular", "Medium", "MediumItalic", "Thin", "ThinItalic", "Bold", "BoldItalic", "Italic", "Light", "LightItalic");

    Foreach ($font_type in $roboto_mono_uris) {
        try {
            $roboto_url = "https://github.com/google/fonts/raw/master/apache/robotomono/static/RobotoMono-$font_type.ttf";
            Invoke-WebRequest -Uri $roboto_url -OutFile "C:\Windows\fonts\RobotoMono-$font_type.ttf";
        }
        catch {
            Write-Host "Invalid Invoke-WebRequest to $roboto_url";
        }
    }

    $fontFiles = New-Object 'System.Collections.Generic.List[System.IO.FileInfo]';
    $roboFont = Get-ChildItem "$($env:systemdrive)\Windows\Fonts\RobotoMono*";
    $roboFont | Foreach-Object {$fontFiles.Add($_)};

    $fonts = $null;
    foreach ($fontFile in $fontFiles) {
        if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install Font")) {
            if (!$fonts) {
                $shellApp = New-Object -ComObject shell.application;
                $fonts = $shellApp.NameSpace(0x14);
            }
            $fonts.CopyHere($fontFile.FullName);
        }
    }
}

function Set-EnvVariables {
    $env:home = $HOME;
    [System.Environment]::SetEnvironmentVariable('HOME', $env:USERPROFILE, [System.EnvironmentVariableTarget]::Machine);
}

function Copy-FindToGFind {
    $systemDrive = [System.Environment]::SystemDirectory;
    Move-Item -Path "tools\findutils-4.2.30-5-w64-bin\bin\find.exe" -Destination "$systemDrive\gfind.exe";
}

# MAIN
Set-ExecutionPolicy Bypass;
Get-Choco;
Get-ChocoPackages;
Get-PersonalConfigs;
Set-SymLinks;
Get-Fonts;
Set-GitGlobalSettings;
# Set-EmacsDaemonStartup;
Install-PostGitModule;
Copy-FindToGFind;
