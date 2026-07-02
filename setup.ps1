[CmdletBinding()]
Param(
    [switch]$DryRun
)

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin -and -not $DryRun) {
    Write-Warning "This script requires Administrator privileges to create symbolic links and install packages."
    Write-Host "Please run this script from an elevated PowerShell prompt."
    exit
}

# Dynamic Pathing
$REPO_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $REPO_ROOT) { $REPO_ROOT = Get-Location }

# Load locally installed choco packages to support idempotency checks
$localPackages = @()
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Checking local Chocolatey packages..."
    $localPackages = choco list --local-only --limit-output | ForEach-Object { ($_ -split '\|')[0] }
}

# Safe/Dry-Run/Idempotent Wrappers
function Safe-NewItem {
    Param($Path, $Name, $ItemType, $Value, [switch]$Force)
    $destPath = Join-Path $Path $Name
    
    # Check for Idempotency
    if (Test-Path $destPath) {
        $item = Get-Item $destPath
        if ($item.LinkType -eq "SymbolicLink" -or $item.LinkType -eq "Junction") {
            if ($item.Target -eq $Value) {
                Write-Host "Link $destPath already points to $Value. Skipping."
                return
            }
        }
    }
    
    if ($DryRun) {
        Write-Host "[DRY RUN] Would create symbolic link: $destPath -> $Value" -ForegroundColor Cyan
    } else {
        # Remove existing if force is specified and it's not correct
        if ($Force -and (Test-Path $destPath)) {
            Remove-Item $destPath -Force -Recurse -ErrorAction SilentlyContinue
        }
        New-Item -ItemType $ItemType -Path $Path -Name $Name -Value $Value -Force | Out-Null
    }
}

function Safe-MoveItem {
    Param($Path, $Destination, [switch]$Force)
    if ($DryRun) {
        Write-Host "[DRY RUN] Would move file/dir: $Path -> $Destination" -ForegroundColor Cyan
    } else {
        Move-Item -Path $Path -Destination $Destination -Force
    }
}

function Safe-CopyItem {
    Param($Path, $Destination, [switch]$Force)
    if ($DryRun) {
        Write-Host "[DRY RUN] Would copy: $Path -> $Destination" -ForegroundColor Cyan
    } else {
        Copy-Item -Path $Path -Destination $Destination -Force | Out-Null
    }
}

function Safe-RemoveItem {
    Param($Path, [switch]$Recurse, [switch]$Force)
    if ($DryRun) {
        Write-Host "[DRY RUN] Would remove path: $Path" -ForegroundColor Cyan
    } else {
        Remove-Item -Path $Path -Force -Recurse:$Recurse -ErrorAction SilentlyContinue
    }
}

function Safe-SetItemProperty {
    Param($Path, $Name, $Value, [switch]$Force)
    # Idempotency check for Registry properties
    if (Test-Path $Path) {
        $propValue = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction SilentlyContinue
        if ($propValue -eq $Value) {
            Write-Host "Registry property $Path\$Name is already set to $Value. Skipping."
            return
        }
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would set Registry property: $Path\$Name = $Value" -ForegroundColor Cyan
    } else {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Force | Out-Null
    }
}

function Invoke-External {
    Param(
        [string]$Description,
        [scriptblock]$Script
    )
    if ($DryRun) {
        Write-Host "[DRY RUN] Would run: $Description" -ForegroundColor Cyan
    } else {
        & $Script
    }
}

function Backup-File ($path) {
    if (Test-Path $path) {
        # Check if the target is already a valid symlink pointing to our repo
        $item = Get-Item $path
        if ($item.LinkType -eq "SymbolicLink" -or $item.LinkType -eq "Junction") {
            # Let Safe-NewItem handle link verification without performing unnecessary backups
            return
        }
        
        $backup = "$path.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        if ($DryRun) {
            Write-Host "[DRY RUN] Would backup $path to $backup" -ForegroundColor Cyan
        } else {
            Write-Host "Backing up $path to $backup"
            Move-Item -Path $path -Destination $backup -Force
        }
    }
}

function Get-Choco {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Invoke-External "Chocolatey bootstrap install" {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    } else {
        Write-Host "Chocolatey is already installed."
    }
}

function Install-Packages {
    Write-Host "Installing packages via Chocolatey..."
    $packages = @(
        "googlechrome",
        "git",
        "cmder",
        "ripgrep",
        "sysinternals",
        "syncthing",
        "rust-ms",
        "vswhere",
        "msbuild-structured-log-viewer",
        "cmake",
        "vscode",
        "poshgit",
        "7zip",
        "helix",
        "alacritty"
    )
    foreach ($pkg in $packages) {
        if ($localPackages -contains $pkg) {
            Write-Host "Package $pkg is already installed via Chocolatey. Skipping."
        } else {
            Invoke-External "choco install $pkg -y" { choco install $pkg -y }
        }
    }
}

function Install-PoshGit {
    Write-Host "Installing posh-git module..."
    if (Get-Module -ListAvailable -Name posh-git) {
        Write-Host "PowerShell module posh-git is already installed. Skipping."
        return
    }
    Invoke-External "Install PowerShell Module posh-git" {
        Install-Module posh-git -Force -AllowClobber -Scope CurrentUser -ErrorAction SilentlyContinue
    }
}

function Set-SymLinks {
    Write-Host "Setting up symbolic links and junctions..."
    
    # Vim config
    Backup-File "$home\.vimrc"
    Safe-NewItem -Path $home -Name .vimrc -ItemType SymbolicLink -Value "$REPO_ROOT\vim\.vimrc" -Force
    
    Backup-File "$home\vimfiles"
    Safe-NewItem -Path $home -Name vimfiles -ItemType SymbolicLink -Value "$REPO_ROOT\vim\vimfiles" -Force

    # Git config
    Backup-File "$home\.gitconfig"
    Safe-NewItem -Path $home -Name .gitconfig -ItemType SymbolicLink -Value "$REPO_ROOT\.gitconfig" -Force

    Backup-File "$home\.gitignore_global"
    Safe-NewItem -Path $home -Name .gitignore_global -ItemType SymbolicLink -Value "$REPO_ROOT\.gitignore" -Force
    
    # Helix config
    $helixConfigDir = "$home\.config\helix"
    if (-not (Test-Path "$home\.config") -and -not $DryRun) { New-Item -ItemType Directory -Path "$home\.config" | Out-Null }
    Backup-File $helixConfigDir
    Safe-NewItem -Path "$home\.config" -Name helix -ItemType SymbolicLink -Value "$REPO_ROOT\helix" -Force

    # Alacritty config
    $alacrittyConfigDir = "$home\.config\alacritty"
    Backup-File $alacrittyConfigDir
    Safe-NewItem -Path "$home\.config" -Name alacritty -ItemType SymbolicLink -Value "$REPO_ROOT\alacritty" -Force

    # Mo config
    $moConfigDir = "$env:APPDATA\mo"
    if (-not (Test-Path $moConfigDir) -and -not $DryRun) { New-Item -ItemType Directory -Path $moConfigDir | Out-Null }
    Backup-File "$moConfigDir\config.toml"
    Safe-NewItem -Path $moConfigDir -Name config.toml -ItemType SymbolicLink -Value "$REPO_ROOT\mo\config.toml" -Force

    # PowerShell Profile config
    $splitIndex = $profile.IndexOf("Microsoft.PowerShell_profile.ps1")
    if ($splitIndex -ge 0) {
        $profilePath = $profile.Substring(0, $splitIndex)
        if (-not (Test-Path $profilePath) -and -not $DryRun) { New-Item -ItemType Directory -Path $profilePath | Out-Null }
        Backup-File "$profilePath\Microsoft.PowerShell_profile.ps1"
        Safe-NewItem -Path $profilePath -Name "Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Value "$REPO_ROOT\powershell\Microsoft.PowerShell_profile.ps1" -Force
    }

    # Cmder config
    if (Test-Path "C:\tools\Cmder\vendor\conemu-maximus5" -or $DryRun) {
        Backup-File "C:\tools\Cmder\vendor\conemu-maximus5\ConEmu.xml"
        Safe-NewItem -Path "C:\tools\Cmder\vendor\conemu-maximus5" -Name ConEmu.xml -ItemType SymbolicLink -Value "$REPO_ROOT\cmder\ConEmu.xml" -Force
    }

    # Syncthing startup shortcut
    $startupFolder = "$home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    if (Test-Path $startupFolder -or $DryRun) {
        Backup-File "$startupFolder\Syncthing.lnk"
        Safe-NewItem -Path $startupFolder -Name "Syncthing.lnk" -ItemType SymbolicLink -Value "C:\ProgramData\chocolatey\bin\Syncthing.exe" -Force
    }
}

function Install-Gitu {
    Write-Host "Installing gitu Git TUI via Cargo..."
    # If gitu is already in path, skip
    if (Get-Command gitu -ErrorAction SilentlyContinue) {
        Write-Host "gitu is already installed. Skipping."
        return
    }
    Invoke-External "cargo install gitu" {
        if (Get-Command cargo -ErrorAction SilentlyContinue) {
            cargo install gitu
        } else {
            Write-Warning "Cargo is not in the PATH. Cannot install gitu yet."
        }
    }
}

function Install-Fonts {
    Write-Host "Installing Roboto Mono fonts..."
    # Check if a Roboto Mono font is already registered
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts") {
        $existing = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "*Roboto Mono*" -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Host "Roboto Mono fonts are already installed. Skipping."
            return
        }
    }

    $fontFiles = Get-ChildItem "$REPO_ROOT\fonts\robotomono\static\*.ttf" -ErrorAction SilentlyContinue
    if (-not $fontFiles) {
        $roboto_mono_uris = @("Regular", "Medium", "MediumItalic", "Thin", "ThinItalic", "Bold", "BoldItalic", "Italic", "Light", "LightItalic")
        $fontDir = "$env:TEMP\RobotoMonoFonts"
        if (-not $DryRun) { New-Item -ItemType Directory -Path $fontDir -Force | Out-Null }
        foreach ($font_type in $roboto_mono_uris) {
            $roboto_url = "https://github.com/google/fonts/raw/master/apache/robotomono/static/RobotoMono-$font_type.ttf"
            Invoke-External "Download font RobotoMono-$font_type.ttf" {
                Invoke-WebRequest -Uri $roboto_url -OutFile "$fontDir\RobotoMono-$font_type.ttf" -ErrorAction SilentlyContinue
            }
        }
        $fontFiles = Get-ChildItem "$fontDir\*.ttf" -ErrorAction SilentlyContinue
    }
    
    $shellApp = New-Object -ComObject shell.application
    $fontsNamespace = $shellApp.NameSpace(0x14)
    foreach ($file in $fontFiles) {
        Write-Host "Installing font: $($file.Name)"
        Safe-CopyItem -Path $file.FullName -Destination "$env:windir\Fonts" -Force
        $fontName = $file.BaseName.Replace("-", " ") + " (TrueType)"
        Safe-SetItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $fontName -Value $file.Name -Force
    }
}

function Set-GitGlobalSettings {
    Write-Host "Setting git global settings..."
    $globalIgnore = git config --global core.excludesfile
    if ($globalIgnore -eq "~/.gitignore_global" -or $globalIgnore -eq "$home\.gitignore_global") {
        Write-Host "Global git ignore is already configured. Skipping."
        return
    }
    Invoke-External "git config --global core.excludesfile ~/.gitignore_global" {
        git config --global core.excludesfile ~/.gitignore_global
    }
}

function Copy-FindToGFind {
    $systemDirectory = [System.Environment]::SystemDirectory
    if (Test-Path "$systemDirectory\gfind.exe") {
        Write-Host "gfind.exe is already present. Skipping."
        return
    }
    if (Test-Path "$REPO_ROOT\scripts\Windows\tools\findutils-4.2.30-5-w64-bin\bin\find.exe" -or $DryRun) {
        Safe-CopyItem -Path "$REPO_ROOT\scripts\Windows\tools\findutils-4.2.30-5-w64-bin\bin\find.exe" -Destination "$systemDirectory\gfind.exe" -Force
    }
}

function Run-FullSetup {
    Get-Choco
    Install-Packages
    Set-SymLinks
    Install-Fonts
    Set-GitGlobalSettings
    Install-PoshGit
    Copy-FindToGFind
    Install-Gitu
    Write-Host "Full Windows environment setup complete!" -ForegroundColor Green
}

function Run-SelectiveSetup {
    Write-Host "--- Selective Component Setup ---"
    
    function Ask-Install ($name) {
        $ans = Read-Host "Install/Configure $name? [y/N]"
        return ($ans -like "y*" -or $ans -like "Y*")
    }

    if (Ask-Install "Chocolatey package manager") { Get-Choco }
    if (Ask-Install "Chocolatey software packages") { Install-Packages }
    if (Ask-Install "Symbolic links & junctions") { Set-SymLinks }
    if (Ask-Install "Roboto Mono fonts") { Install-Fonts }
    if (Ask-Install "Posh-git PowerShell module") { Install-PoshGit }
    if (Ask-Install "Global git ignore configurations") { Set-GitGlobalSettings }
    if (Ask-Install "findutils (gfind) Windows helper") { Copy-FindToGFind }
    if (Ask-Install "gitu Git TUI (Requires Cargo)") { Install-Gitu }
}

function Show-Menu {
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "  Unified personal-configs Windows Setup " -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Repository Path: $REPO_ROOT"
    Write-Host "Dry-Run Mode: $(if ($DryRun) { 'ENABLED' } else { 'DISABLED' })"
    Write-Host "-----------------------------------------"
    Write-Host "1) Full Developer Setup (Install Choco, all tools, fonts, links)"
    Write-Host "2) Create Symlinks Only"
    Write-Host "3) Install Fonts Only"
    Write-Host "4) Selective/Custom Installation"
    Write-Host "5) Toggle Dry-Run Mode"
    Write-Host "6) Exit"
    Write-Host "========================================="
    
    $choice = Read-Host "Please select an option [1-6]"
    switch ($choice) {
        "1" { Run-FullSetup }
        "2" { Set-SymLinks }
        "3" { Install-Fonts }
        "4" { Run-SelectiveSetup }
        "5" { 
            $DryRun = -not $DryRun
            Show-Menu
        }
        "6" { exit }
        Default { Show-Menu }
    }
}

Show-Menu
