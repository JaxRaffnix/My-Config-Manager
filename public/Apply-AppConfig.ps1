function Apply-AppConfig {
    <#
    .SYNOPSIS
        Applies application configurations defined in an external YAML file.

    .DESCRIPTION
        Reads a YAML configuration file that defines one or more applications, ensures each app is installed
        via Test-Dependency, and applies the configuration keys/values idempotently.
        Supports placeholder replacement from $Parameters for dynamic values like usernames/emails.

    .PARAMETER ConfigPath
        Path to the YAML configuration file describing applications and their settings.

    .EXAMPLE
        Apply-AppConfig -ConfigPath "./config/appconfig.yaml" -Parameters @{ "git.user.name"="Alice"; "git.user.email"="alice@example.com" }

    .NOTES
        Author: Jan Hoegen
        Part of: My-System-Setup
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ConfigPath = "$PSScriptRoot/../config/appconfig.yaml"

    )
    Test-Dependency -Command "ConvertFrom-Yaml" -Module -Source "powershell-yaml"

    if (-not (Test-Path $ConfigPath)) {
        throw "Configuration file not found at '$ConfigPath'."
    }
    try {
        $config = (Get-Content -Path $ConfigPath -Raw) | ConvertFrom-Yaml
    } catch {
        throw "Failed to parse configuration: $_"
    }

    foreach ($appName in $config.apps.Keys) {
        $app = $config.apps.$appName

        Write-Verbose "Processing application '$appName'..."

        # Ensure dependency is installed
        if ($PSCmdlet.ShouldProcess("App $appName", "Check dependency")) {
            Test-Dependency -Command $app.command -App -Source $app.source
        }

        # Apply each config key
        foreach ($key in $app.config.Keys) {
            $value = $app.config.$key

            # TODO: parameterize the values. use a environment variable
            
            if ($PSCmdlet.ShouldProcess("App $appName", "Set $key = $value")) {
                try {
                    # For Git, we can assume command-line config keys
                    # This could be extended for other apps
                    switch ($appName.ToLower()) {
                        'git' {
                            $current = git config --global $key 2>$null
                            if ($current -ne $value) {
                                git config --global $key $value
                                Write-Verbose "Set Git $key = $value"
                            } else {
                                Write-Verbose "Git $key already set to $value, skipping."
                            }
                        }
                        'office' {
                           
                        }

                        'oh-my-posh' {
                        if ($PSCmdlet.ShouldProcess("Oh-My-Posh", "Setup Oh-My-Posh environment")) {

                            
                        }
                    }

                        default {
                            Write-Error "No handler implemented for '$appName'."
                        }
                    }
                } catch {
                    Write-Error "Failed to set '$key' for '$appName': $_"
                }
            }
        }
    }
    Write-Host "All app configurations applied successfully." -ForegroundColor Green
}
 