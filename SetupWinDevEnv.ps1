# This is a

$CONFIG_HOME = "C:\tools\personal-configs";

function Get-PersonalConfigs {
    # Create directory C:\tools
    # git clone into C:\tools
}

function Get-ChocoPackages {

    choco install cmder;
    choco install ripgrep;
    choco install vim;
}

# Creates symlink to $CONFIG_HOME for easy git management
function Set-VimrcSymLink {
    # Symbolic linke from ~/.vimrc to c:\tools\personal-configs\vimfiles\.vimrc for easy management
    New-Item -ItemType SymbolicLink -Path $home -Name .vimrc -Value $CONFIG_HOME\.vimrc;

    New-Item -ItemType SymbolicLink -Path $home -Name vimfiles -Value $CONFIG_HOME\vimfiles;
}


# TODO: Create function to setup cmder
# Cmder should point to $Profile (this is mainly to support FcShell)
