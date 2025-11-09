function Install-MSOffice365 {
    param(
        [Parameter()]
        [string]$configPath = "$PSScriptRoot\..\config\msoffice365.xml",
        [string]$setupPath = "C:\Program Files (x86)\OfficeDeploymentTool\setup.exe"
    )

    Test-Dependency Microsoft.OfficeDeploymentTool # this is wrong argument call

    if (-not (Test-Path $setupPath)) {
        Throw "Office Deployment Tool not found at $setupPath"
    }

    Start-Process -FilePath $setupPath -ArgumentList "/configure `"$configPath`"" -Wait
}
