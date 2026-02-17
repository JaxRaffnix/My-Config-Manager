function Set-GitConfig {
    param (
        [ValidateNotNullOrEmpty()]
        [string]$ConfigFile = (Join-Path (Split-Path $PSScriptRoot -Parent) "config/global.gitconfig")
    )

    if (-not (Test-Path -Path $ConfigFile)) {
        throw Write-Error "Config file not found: $ConfigFile"
    }

    Test-Dependency -Command "git" -Source "Git.git" -App

    try {
        git config --global --add include.path "$ConfigFile"
    }
    catch {
        Write-Error "Failed to set Git config: $_"
    }   
}