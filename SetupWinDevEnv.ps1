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

function Get-ChocoPackages {

    choco install git;
    choco install cmder;
    choco install ripgrep;
    choco install vim;
    choco install cmake;
}

# TOOD: Create generic set symlink function

# Creates symlink to $CONFIG_HOME for easy git management
function Set-VimrcSymLink {
    New-Item -ItemType SymbolicLink -Path $home -Name .vimrc -Value $CONFIG_HOME\.vimrc;

    New-Item -ItemType SymbolicLink -Path $home -Name vimfiles -Value $CONFIG_HOME\vimfiles;
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


# MAIN
Get-PersonalConfigs;
Get-ChocoPackages;
