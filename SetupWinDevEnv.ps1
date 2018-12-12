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
    choco install vim -y;
    choco install sysinternals -y;

}

# TODO: Download dependency walker tool

# TOOD: Create generic set symlink function

# NOTE: This must be run BEFORE the files/directories references are created
# Creates symlink to $CONFIG_HOME for easy git management
function Set-VimrcSymLink {
    # Creates new symbolic link file in $home/.vimrc that is linked to $CONFIG_HOME\.vimrc
    New-Item -ItemType SymbolicLink -Path $home -Name .vimrc -Value $CONFIG_HOME\.vimrc;

    New-Item -ItemType SymbolicLink -Path $home -Name vimfiles -Value $CONFIG_HOME\vimfiles;

    New-Item -ItemType Junction -Path $home -Name vimwiki -Value $CONFIG_HOME\vimwiki;

}

function Set-PSProfileSymLink {
    # Check if file already exists
    #   True, delete it
    # else
    #   Create symlink to the powershell profile ps1 in personal-configs
}

# TODO: Create function that symlinks all of ~/vimfiles to c:\tools\personal-configs

# TODO: Create function to setup cmder
# Cmder should point to $Profile (this is mainly to support FcShell)


# MAIN
Get-PersonalConfigs;
Get-ChocoPackages;
