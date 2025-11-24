

function Set-PlayniteConfig {
    param (
        OptionalParameters
    )
    {
    "BackupFile": "d:\\backups\\PlayniteBackup-2022-07-05-10-23-57.zip",
    "DataDir": "c:\\Users\\user\\AppData\\Roaming\\Playnite\\",
    "LibraryDir": "c:\\Users\\user\\AppData\\Roaming\\Playnite\\library",
    "RestoreItems": [
        0,
        1,
        2,
        3,
        4,
        5
    ],
    "ClosedWhenDone": true,
    "CancelIfGameRunning": true
}

Playnite.DesktopApp.exe --restorebackup "c:\test\restore_config.json"

    
}