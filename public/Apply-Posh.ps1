# old yaml file:
# oh-my-posh:
#     description: "Setup Oh-My-Posh prompt, install font, configure editors, and update PowerShell profile"
#     dependencies:
#       - command: "oh-my-posh"
#       - source: "jandedobbeleer.oh-my-posh"
#     config:
#       fontName: "MesloLGS NF"
#       profilePath: "$PROFILE"
#       windowsTerminalSettings: "$env:LOCALAPPDATA\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json"

# 1. Ensure oh-my-posh is installed
Test-Dependency -Command "oh-my-posh" -App -Source "jandedobbeleer.oh-my-posh"

$font = $app.config.fontName
$profilePath = $app.config.profilePath
$wtSettings = $app.config.windowsTerminalSettings
$vscodeSettings = $app.config.vscodeSettings
$initLine = 'oh-my-posh init pwsh | Invoke-Expression'

# 2. Install Meslo font if not present
$fontInstalled = (Get-CimInstance Win32_FontInfoAction | Where-Object { $_.Caption -like "*$font*" }).Count -gt 0
if (-not $fontInstalled) {
    Write-Verbose "Installing Oh-My-Posh font '$font'..."
    oh-my-posh font install $font
} else {
    Write-Verbose "Font '$font' already installed, skipping."
}

# 3. Update PowerShell profile
if (-not (Test-Path $profilePath)) { New-Item -Path $profilePath -ItemType File -Force | Out-Null }
if (-not (Get-Content $profilePath | Select-String -Pattern [regex]::Escape($initLine))) {
    Add-Content -Path $profilePath -Value "`n$initLine"
    Write-Verbose "Added Oh-My-Posh init line to PowerShell profile."
} else {
    Write-Verbose "PowerShell profile already contains Oh-My-Posh init line."
}

# 4. Configure Windows Terminal font
if (Test-Path $wtSettings) {
    $wtJson = Get-Content $wtSettings -Raw | ConvertFrom-Json
    if (-not $wtJson.profiles) { $wtJson | Add-Member -MemberType NoteProperty -Name profiles -Value @{} }
    if (-not $wtJson.profiles.defaults) { $wtJson.profiles | Add-Member -MemberType NoteProperty -Name defaults -Value @{} }
    $wtJson.profiles.defaults.font.face = $font
    $wtJson | ConvertTo-Json -Depth 10 | Set-Content $wtSettings -Encoding UTF8
    Write-Verbose "Windows Terminal default font set to '$font'."
} else {
    Write-Warning "Windows Terminal settings.json not found, skipping font update."
}