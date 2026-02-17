# My-System-Config



TODO: 
```
New-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "ExecutionPolicy" -Value "Bypass" -PropertyType String -Force

Set-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "NoLogo" -Value 1 -Type DWord
```

- add `Import-Module Terminal-Icons` to $PROFILE. use `Get-PSProfile` for that

- if thunderbird includes emails: move thunderbird functionality to backup project.
- If thunderbird should not include email backups: simplify backup data.
- **SOLUTION: THUNDERBIRD SETTINGS IN MY SYSTEM CONFIG, EMAILS IN BACKUP PROJECT**

- Remove explorer gallery


zu path hinzufügen: `"C:\Program Files\Inkscape\bin"`

- oh my posh installer script

issue:
- `Set-GitConfiguration` aborts if user name and email already match. The other settings are ignored.


manual steps:
- **Visual Studio Code:** Settings and extensions are managed via your GitHub account.
- **KeepassXC:** Enable browser integration for Google Chrome in the settings. Enable lock after x seconds. Set Auto Type Shortcut to `CTRL+ALT+A`.
- **MikTeX:** Check for upgrades.
- **Thunderbird:** Include Adress Book and calendar from `jan.hoegen.akathebozz@gmail.com`