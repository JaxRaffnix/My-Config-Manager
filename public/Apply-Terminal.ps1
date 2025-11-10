function Backup-WindowsTerminalSettings {
    <#
    .SYNOPSIS
    Backups the Windows Terminal settings file.

    .DESCRIPTION
    Copies the current Windows Terminal settings.json file to a backup location with an optional timestamp.

    .PARAMETER BackupPath
    The folder where the backup will be stored. Defaults to Documents\WindowsTerminalBackup.

    .PARAMETER Timestamp
    Include a timestamp in the backup filename. Defaults to $true.

    .EXAMPLE
    Backup-WindowsTerminalSettings

    .EXAMPLE
    Backup-WindowsTerminalSettings -BackupPath "D:\Backups\Terminal" -Timestamp $false
    #>

    [CmdletBinding()]
    param(
        [string]$backupFile = "$PSSCRIPTROOT\config\windows-terminal.json",
        [switch]$Timestamp
    )

    $settingsFile = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    if (-not (Test-Path $settingsFile)) {
        Write-Error "Windows Terminal settings file not found at $settingsFile"
        return
    }

    if (-not (Test-Path $backupFile)) {
        New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
    }

    Copy-Item -Path $settingsFile -Destination $backupFile -Force
    Write-Host "Backup saved to: $backupFile" -ForegroundColor Green
}

function Restore-WindowsTerminalSettings {
    <#
    .SYNOPSIS
    Restores a backup of the Windows Terminal settings file.

    .DESCRIPTION
    Copies a backup JSON file to the Windows Terminal settings location.

    .PARAMETER BackupFile
    The path to the backup settings JSON file.

    .EXAMPLE
    Restore-WindowsTerminalSettings -BackupFile "C:\Backups\settings_backup_20251109_123456.json"
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$BackupFile
    )

    $settingsFile = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    if (-not (Test-Path $BackupFile)) {
        Write-Error "Backup file not found: $BackupFile"
        return
    }

    # Ensure the target folder exists
    $settingsDir = Split-Path $settingsFile
    if (-not (Test-Path $settingsDir)) {
        New-Item -Path $settingsDir -ItemType Directory -Force | Out-Null
    }

    Copy-Item -Path $BackupFile -Destination $settingsFile -Force
    Write-Host "Settings restored from backup: $BackupFile" -ForegroundColor Green
}
