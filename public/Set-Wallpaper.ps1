function Set-Wallpaper {
<#
    .SYNOPSIS
    Sets the Windows wallpaper and lock screen image.

    .DESCRIPTION
    This function allows you to set a custom image as the Windows desktop wallpaper and lock screen image.

    .PARAMETER WallpaperPath
    The file path to the image to be used as the desktop wallpaper.

    .PARAMETER LockScreenPath
    The file path to the image to be used as the lock screen image.

    .EXAMPLE
    Set-WallpaperAndLockScreen -WallpaperPath "$HOME\Images\wallpaper.jpg" -LockScreenPath "$HOME\Images\lockscreen.jpg"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$WallpaperPath,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$LockScreenPath
    )

    Test-Dependency -Command "gsudo" -Source "gerardog.gsudo" -App

    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    public const int SPI_SETDESKWALLPAPER = 20;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDCHANGE = 0x02;

    public static void SetWallpaper(string path) {
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
"@

    Write-Host "Setting desktop wallpaper to $WallpaperPath..." -ForegroundColor Cyan
    try {
        # Set the desktop wallpaper
        [Wallpaper]::SetWallpaper($WallpaperPath)

        Write-Host "Desktop wallpaper set successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to set desktop wallpaper: $_"
    }

    Write-Host "Setting lock screen image to $LockScreenPath..." -ForegroundColor Cyan
    try {
        # Set the lock screen image
        $lockScreenKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
        gsudo Set-ItemProperty -Path $lockScreenKey -Name "LockScreenImagePath" -Value $LockScreenPath -Force
        gsudo Set-ItemProperty -Path $lockScreenKey -Name "LockScreenImageStatus" -Value 1 -Force

        Write-Host "Lock screen image set successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to set lock screen image: $_"
    }
}