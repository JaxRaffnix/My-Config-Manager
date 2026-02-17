# My-System-Config

## To Do
```
New-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "ExecutionPolicy" -Value "Bypass" -PropertyType String -Force

Set-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "NoLogo" -Value 1 -Type DWord
```

- Remove explorer gallery

## Issues

- `Set-GitConfiguration` aborts if user name and email already match. The other settings are ignored.
- manually update windows ternminal settings and powershell profile if there are changes. Maybe write a script to do that.

## Manual Steps

- **Visual Studio Code:** Settings and extensions are managed via your GitHub account.
- **KeepassXC:** Enable browser integration for Google Chrome in the settings. Enable lock after x seconds. Set Auto Type Shortcut to `CTRL+ALT+A`.
- **MikTeX:** Check for upgrades.
- **Thunderbird:** Include Adress Book and calendar from `jan.hoegen.akathebozz@gmail.com`