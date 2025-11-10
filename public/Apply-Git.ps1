<#
.SYNOPSIS
    Applies a predefined Git configuration file globally.

.DESCRIPTION
    This script checks for Git, then merges or replaces the user's global
    Git configuration (~/.gitconfig) with the provided template file.
#>

param(
    [string]$ConfigFile = "$(Split-Path $PSScriptRoot)/../config/git/global.gitconfig"
)

# --- Check Git installation ---
Test-Dependency git git.git -App

# --- Verify config file exists ---
if (-not (Test-Path $ConfigFile)) {
    Throw "❌ Git configuration file not found: $ConfigFile"
}

# --- Apply config file ---
$globalConfig = "$HOME\.gitconfig"
Write-Host "→ Applying Git config from: $ConfigFile"
Write-Host "→ Target global config: $globalConfig"

# Backup old config if exists
# if (Test-Path $globalConfig) {
#     $backupPath = "$globalConfig.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
#     Copy-Item $globalConfig $backupPath
#     Write-Host "🗄️  Existing .gitconfig backed up to: $backupPath"
# }

# Merge configs (preserve any existing settings)
git config --global --add include.path $ConfigFile

Write-Host "`n✅ Git now includes your custom configuration:"
# git config --global --list
