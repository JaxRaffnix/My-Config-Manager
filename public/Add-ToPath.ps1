function Add-ToPath {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ConfigFile = (Join-Path (Split-Path $PSScriptRoot -Parent) "config/user_path.txt")
    )

    if (-not (Test-Path -Path $ConfigFile)) {
        throw Write-Error "Config file not found: $ConfigFile"
    }

    if (-not (Get-Content -Path $ConfigFile | Where-Object { $_ -ne "" })) {
        Throw "Config file is empty: $ConfigFile"
    }

    foreach ($line in Get-Content -Path $ConfigFile) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
            if ($currentPath -notlike "*$line*") {
                [Environment]::SetEnvironmentVariable("Path", "$currentPath;$line", [EnvironmentVariableTarget]::User)
                Write-Host "Added '$line' to user PATH." -ForegroundColor Green
            }
            else {
                Write-Verbose "'$line' is already in the user PATH."
            }
        }
    }

    Write-Host "Added Paths to User Space successfully!" -ForegroundColor Green
}