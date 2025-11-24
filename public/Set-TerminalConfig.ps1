function Set-TerminalConfig {
    <#
    .SYNOPSIS
        Restores a backup of the Windows Terminal settings file.

    .DESCRIPTION
        Copies a backup JSON file to the Windows Terminal settings location.
        Ensures the target directory exists before restoring.

    .PARAMETER BackupFile
        The path to the backup settings JSON file. Defaults to the module’s config folder.

    .EXAMPLE
        Set-TerminalConfig -BackupFile "C:\Backups\settings_backup_20251109_123456.json"

    .NOTES
        Requires access to the user's LocalAppData folder.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BackupFile = (Join-Path (Split-Path $PSScriptRoot -Parent) "config/windows-terminal.json")
    )

    # Define target path for Windows Terminal settings
    $settingsFile = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    # Check backup file
    if (-not (Test-Path -Path $BackupFile)) {
        throw Write-Error "Backup file not found: $BackupFile"
    }

    # Ensure the target folder exists
    $settingsDir = Split-Path -Path $settingsFile -Parent
    if (-not (Test-Path -Path $settingsDir)) {
        Write-Verbose "Creating directory: $settingsDir"
        New-Item -Path $settingsDir -ItemType Directory -Force | Out-Null
    }

    # Try to restore the backup
    Copy-Item -Path $BackupFile -Destination $settingsFile -Force
    Write-Host "Windows Terminal settings restored successfully!" -ForegroundColor Green
    # Write-Host "   $BackupFile → $settingsFile" -ForegroundColor DarkGray
}
