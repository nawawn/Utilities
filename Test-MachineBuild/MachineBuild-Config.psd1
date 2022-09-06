@{
    Software = @(
        'Microsoft Visual Studio Code',
        'Adobe Acrobat DC (64-bit)',
        'Git',
        'VLC media player',
        'Node.js',
        'Google Chrome',
        'Microsoft 365 Apps for enterprise - en-us'

    )
    Folder = @(
        'D:\MySoftware',
        'C:\Temp'
    )
    Registry = @(
        @{
            Path  = 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
            Name  = 'fDenyTSConnections'
            Value = 0
        },
        @{
            Path  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
            Name  = 'SecurityHealth'
            Value = 'C:\WINDOWS\system32\SecurityHealthSystray.exe'
        }
    )
    Service = @(
        @{
            Name   = 'TermService'
            Status = 'Running'
        },
        @{
            Name   = 'mpssvc'
            Status = 'Running'
        },
        @{
            Name   = 'XboxGipSvc'
            Status = 'Stopped'
        }
    )
}