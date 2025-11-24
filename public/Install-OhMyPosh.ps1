function Install-OhMyPosh {
    <#
    .SYNOPSIS
        Installs and configures Oh-My-Posh with the desired font for PowerShell and Windows Terminal.

    .DESCRIPTION
        Ensures Oh-My-Posh is installed via winget, installs the MesloLGS NF font if missing,
        and (optionally) configures the PowerShell profile or Windows Terminal font.
        The Windows Terminal JSON is assumed to be handled elsewhere.

    .PARAMETER FontName
        The name of the font to install. Default: 'MesloLGS NF'

    .PARAMETER ProfilePath
        Path to the PowerShell profile file. Defaults to $PROFILE.

    .PARAMETER WindowsTerminalSettings
        Path to the Windows Terminal settings.json file.
        Defaults to the user’s LocalAppData folder.

    .EXAMPLE
        Setup-OhMyPosh
        Installs Oh-My-Posh and the MesloLGS NF font if not present.

    .EXAMPLE
        Setup-OhMyPosh -FontName "CaskaydiaCove NF"
        Installs a different Nerd Font for Oh-My-Posh.

    .NOTES
        Requires winget and administrative privileges to install fonts.
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$FontName = "MesloLGS NF",

        [Parameter()]
        [string]$ProfilePath = $PROFILE,

        [Parameter()]
        [string]$WindowsTerminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    )

    Write-Host "🔧 Setting up Oh-My-Posh environment..." -ForegroundColor Cyan

    # --- 1. Ensure Oh-My-Posh is installed ---
    Test-Dependency -Command "oh-my-posh" -App -Source "JanDeDobbeleer.OhMyPosh"

    # --- 2. Install Meslo font if not present ---
    $fontInstalled = Get-CimInstance -ClassName Win32_FontInfoAction -ErrorAction SilentlyContinue |
        Where-Object { $_.Caption -like "*$FontName*" }

    if (-not $fontInstalled) {
        Write-Host "📦 Installing Oh-My-Posh font '$FontName'..." -ForegroundColor Yellow
        try {
            oh-my-posh font install $FontName | Out-Null
            Write-Host "✅ Font '$FontName' installed successfully." -ForegroundColor Green
        }
        catch {
            Write-Warning "⚠️ Failed to install font '$FontName': $_"
        }
    }
    else {
        Write-Verbose "Font '$FontName' already installed."
    }

    # --- 3. Optional: Configure PowerShell profile (disabled by default) ---
    # The following logic is intentionally disabled since Windows Terminal JSON
    # is already configured elsewhere in your project.
    # Uncomment to automatically inject the initialization line:
    #
    # $initLine = 'oh-my-posh init pwsh | Invoke-Expression'
    # if (-not (Test-Path $ProfilePath)) {
    #     Write-Verbose "Creating new PowerShell profile at $ProfilePath..."
    #     New-Item -Path $ProfilePath -ItemType File -Force | Out-Null
    # }
    # if (-not (Select-String -Path $ProfilePath -Pattern [regex]::Escape($initLine) -Quiet)) {
    #     Add-Content -Path $ProfilePath -Value "`n$initLine"
    #     Write-Host "✅ Added Oh-My-Posh init line to PowerShell profile." -ForegroundColor Green
    # } else {
    #     Write-Verbose "PowerShell profile already contains Oh-My-Posh init line."
    # }

    Write-Host "Oh-My-Posh setup complete." -ForegroundColor Cyan
}
