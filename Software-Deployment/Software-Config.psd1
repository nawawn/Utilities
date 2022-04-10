@{
    Description = 'Software To Install'
    AllSoftware = @(
    @{
        Name = '7-Zip'
        URI  = 'https://www.7-zip.org/a/7z2107-x64.msi'
        InstallCmd = 'msiexec.exe /i 7z2107-x64.msi /qn /norestart'
        DependsOn  = ''
    },
    @{
        Name = 'Adobe Reader'
        URI  = ''
        InstallCmd = ''
        DependsOn  = ''
    },
    @{
        Name = 'draw.io'
        URI  = 'https://github.com/jgraph/drawio-desktop/releases/download/v17.2.4/draw.io-17.2.4.msi'
        InstallCmd = 'msiexec.exe /i draw.io-17.2.4.msi /qn /norestart'
        DependsOn  = ''
    },    
    @{
        Name = 'Google Chrome'
        URI  = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'
        InstallCmd = 'msiexec.exe /i googlechromestandaloneenterprise64.msi /qn /norestart'
        DependsOn = ''
    },
    @{
        Name = 'KeePass2'
        URI  = 'https://sourceforge.net/projects/keepass/files/KeePass 2.x/2.50/KeePass-2.50.msi'
        InstallCmd = 'msiexec.exe /i KeePass-2.50.msi /qn /norestart'
        DependsOn  = ''
    },
    @{
        Name = 'Notepad++'
        URI  = 'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.3.3/npp.8.3.3.Installer.x64.exe'
        InstallCmd = 'npp.8.3.3.Installer.x64.exe /S'
        DependsOn  = ''
    },
    @{
        Name = 'WinMerge'
        URI  = 'https://github.com/WinMerge/winmerge/releases/download/v2.16.18/WinMerge-2.16.18-x64-Setup.exe'
        InstallCmd = 'WinMerge-2.16.18-x64-Setup.exe /Silent'
        DependsOn  = ''        
    },
    @{
        Name = 'VLC media player'
        URI  = 'https://get.videolan.org/vlc/3.0.16/win64/vlc-3.0.16-win64.msi'
        InstallCmd = 'msiexec.exe /i vlc-3.0.16-win64.msi /qn /norestart'
        DependsOn  = ''
    },
    @{
        Name = 'Libre Office'
        URI  = 'https://download.documentfoundation.org/libreoffice/stable/7.3.2/win/x86_64/LibreOffice_7.3.2_Win_x64.msi'
        InstallCmd = 'msiexec.exe /i LibreOffice_7.3.2_Win_x64.msi /qn /norestart'
        DependsOn  = ''
    },
    @{
        Name = 'Orca'
        URI  = 'https://www.technipages.com/downloads/OrcaMSI.zip'
        InstallCmd = 'msiexec.exe /i Orca.msi /qn /norestart'
        DependsOn  = ''
    },
    @{
        Name = 'MS Visual Studio'
        URI  = 'https://aka.ms/vs/17/release/vs_community.exe'
        InstallCmd = 'vs_community.exe --passive'
        DependsOn  = ''
    })
}

#$Uri = 'https://aka.ms/vs/17/release/vs_community.exe'
#Invoke-WebRequest -Uri $Uri -UseBasicParsing -OutFile .\googlechromestandaloneenterprise64.msi -UserAgent 'Wget'
#Start-BitsTransfer -Source $Uri -Destination .\googlechromestandaloneenterprise64.msi
