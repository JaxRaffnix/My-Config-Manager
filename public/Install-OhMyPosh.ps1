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
        [string]$FontName = "meslo"

    )

    Write-Host "Setting up Oh-My-Posh environment..." -ForegroundColor Cyan

    Test-Dependency -Command "oh-my-posh" -App -Source "JanDeDobbeleer.OhMyPosh"

    # TODO: i dont think this validation works.
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
}

# Install-OhMyPosh