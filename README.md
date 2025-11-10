# My-System-Config

- add terminal json to apply config
- powertoys peek keybind?

the apps yaml does not work. structure code execution and config data differently.

TODO: 
```
New-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "ExecutionPolicy" -Value "Bypass" -PropertyType String -Force

Set-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" `
  -Name "NoLogo" -Value 1 -Type DWord
```


`git config --global core.editor "code --wait"`


zu path hinzufügen: `"C:\Program Files\Inkscape\bin"`

- oh my posh installer script

issue:
- `Set-GitConfiguration` aborts if user name and email already match. The other settings are ignored.


manual steps:
- **Visual Studio Code:** Settings and extensions are managed via your GitHub account.
- **KeepassXC:** Enable browser integration for Google Chrome in the settings. Enable lock after x seconds. Set Auto Type Shortcut to `CTRL+ALT+A`.
- **MikTeX:** Check for upgrades.
- **Thunderbird:** Include Adress Book and Calender from `jan.hoegen.akathebozz@gmail.com`