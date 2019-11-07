# This is a

$CONFIG_HOME = "C:\tools\personal-configs";

function Get-PersonalConfigs {
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
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
}

# TODO: Move tools to c:\tools
function Get-ChocoPackages {

    choco install git -y;
    choco install cmder -y;
    choco install ripgrep -y;
    choco install emacs -y;
    choco install sysinternals -y;
    choco install rust-ms -y;
    choco install vswhere -y;

}

# TODO: Download dependency walker tool

# TOOD: Create generic set symlink function

# NOTE: This must be run BEFORE the files/directories references are created
# Creates symlink to $CONFIG_HOME for easy git management
function Set-VimrcSymLink {
    # Creates new symbolic link file in $home/.vimrc that is linked to $CONFIG_HOME\.vimrc
    New-Item -ItemType SymbolicLink -Path $home -Name .vimrc -Value $CONFIG_HOME\vim\.vimrc;

    New-Item -ItemType SymbolicLink -Path $home -Name vimfiles -Value $CONFIG_HOME\vim\vimfiles;

    New-Item -ItemType SymbolicLink -Path $home -Name .gitconfig -Value $CONFIG_HOME\.gitconfig;

    New-Item -ItemType SymbolicLink -Path $home -Name .gitconfig_global -value $CONFIG_HOME\.gitconfig_global;

    New-Item -ItemType Junction -Path $home -Name .emacs.d -Value $CONFIG_HOME\emacs\.emacs.d;
}

function Set-GitGlobalSettings {
    iex (git config --global core.excludesfile ~/.gitignore_global);
}

function Set-PSProfileSymLink {
    # Check if file already exists
    #   True, delete it
    # else
    #   Create symlink to the powershell profile ps1 in personal-configs
}

# TODO: Create function that symlinks all of ~/vimfiles to c:\tools\personal-configs

# TODO: Create function to setup cmder
# Cmder should point to $Profile (this is mainly to support FcShell) (or change conemu settings and remove the default `-NoProfile` setting

function Set-EmacsDaemonStartup {
    $startup_file = "$([Environment]::GetFolderPath('Startup'))\StartEmacsServer.bat";

    # Location of runemacs.exe will differ if installed via Chocolatey (C:\users\<username>) or Traditional means (%APPDATA%)
    New-Item $startup_file -type file;
    Set-Content -Path $startup_file -Value "set HOME=%APPDATA%";
    Add-Content -Path $startup_file -Value "del /Q ""%HOME%/.emacs.d/server/*""";
    Add-Content -Path $startup_file -Value "runemacs.exe --daemon";
}

function Get-Fonts {
    $roboto_mono_uris = @("Regular", "Medium", "MediumItalic", "Thin", "ThinItalic", "Bold", "BoldItalic", "Italic", "Light", "LightItalic");

    Foreach ($font_type in $roboto_mono_uris) {
        try {
            $roboto_url = "https://github.com/google/fonts/blob/master/apache/robotomono/RobotoMono-$font_type.ttf";
            Invoke-WebRequest -Uri $roboto_url -OutFile "C:\Windows\fonts\RobotoMono-$font_type.ttf";
        }
        catch {
            Write-Host "Invalid Invoke-WebRequest to $roboto_url";
        }
    }

    $roboto_mono_fonts = @("Regular", "Medium", "Medium Italic", "Thin", "Thin Italic", "Bold", "Bold Italic", "Italic", "Light", "Light Italic");
    $ttf_suffx = "(TrueType)";

    Foreach ($type in $roboto_mono_fonts) {
        if ($type -eq "Regular") {
            reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Roboto Mono (TrueType)" /t REG_SZ /d "RobotoMono-Regular.ttf";
        }
        else {
            reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Roboto Mono $type (TrueType)" /t REG_SZ /d "RobotoMono-$($type -replace '\s','').ttf";
        }
    }
}

# MAIN
Get-PersonalConfigs;
Get-ChocoPackages;
