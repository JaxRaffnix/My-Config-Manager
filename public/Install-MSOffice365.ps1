function Install-MicrosoftOffice {
    <#
    .SYNOPSIS
        Installs Microsoft 365 (Office 365) using a predefined XML configuration.

    .DESCRIPTION
        Automates the installation of Microsoft 365 using the Office Deployment Tool (ODT)
        and a configuration XML file stored in the module’s `config` folder.
        Downloads ODT if it’s not found and executes setup with elevated privileges.

    .PARAMETER ConfigFile
        Path to the XML configuration file for the Office Deployment Tool.
        Defaults to the module’s `config\msoffice365.xml`.

    .PARAMETER ODTPath
        Directory where setup.exe (Office Deployment Tool) is or should be located.

    .EXAMPLE
        Install-MicrosoftOffice
        Installs Office using the default config in your module’s config folder.

    .EXAMPLE
        Install-MicrosoftOffice -ConfigFile "D:\Configs\office-custom.xml" -ODTPath "C:\ODT"
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$ConfigFile = (Join-Path $PSScriptRoot '..\config\msoffice365.xml'),
        [string]$ODTPath = "C:\Program Files (x86)\OfficeDeploymentTool"
    )

    # Ensure config file exists
    if (-not (Test-Path $ConfigFile)) {
        throw "Configuration file not found: '$ConfigFile'"
    }

    # Verify or install Office Deployment Tool
    if (-not (Test-Path (Join-Path $ODTPath 'setup.exe'))) {
        try {
            # Install the ODT package using your dependency handler
            Test-Dependency -Command "setup.exe" -Source "Microsoft.OfficeDeploymentTool" -App
        }
        catch {
            Write-Warning "Office Deployment Tool not found or failed to install via Test-Dependency."
            throw
        }
    } else {
        Write-Verbose "Office Deployment Tool found at $ODTPath."
    }
    $SetupExe = Join-Path $ODTPath 'setup.exe'
    

    # Confirm install action
    if ($PSCmdlet.ShouldProcess("Microsoft 365", "Install using $ConfigFile")) {
        Write-Verbose "Starting Microsoft Office installation..."
        Write-Host "→ Config: $ConfigFile"
        Write-Host "→ Tool: $SetupExe"

        # Run as admin using gsudo
        Test-Dependency -Command "gsudo" -Source "gerardog.gsudo" -App
        gsudo Start-Process -FilePath $SetupExe -ArgumentList "/configure `"$ConfigFile`"" -Wait -Verb RunAs
        Write-Host "Microsoft Office installation complete." -ForegroundColor Green
    }
}
