
Function Get-InstalledProgram{
    Param(
        [String]$ComputerName = $env:COMPUTERNAME
    )
    Begin{        
        $RegistryView = @([Microsoft.Win32.RegistryView]::Registry32, [Microsoft.Win32.RegistryView]::Registry64)
        $RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $SoftwareHKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    }
    Process{
        <# ToDo for the next update
        $LastUse  = @{}
        $Prefetch = "\\{0}\C`$\Windows\Prefetch\*.pf" -f $ComputerName
        $AppList = Get-ChildItem $Prefetch -ErrorAction Stop
        $AppList | Foreach-Object{ $LastUse[$_.Name] = Get-Date $_.LastWriteTime -Format yyyyMMdd }
        #>    
        Foreach($View in $RegistryView){
            $Key    = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $ComputerName, $View)
            $SubKey = $Key.OpenSubKey($SoftwareHKey)
            $KeyList = $SubKey.GetSubKeyNames()
            Write-Verbose "Uninstall Key Count: $($KeyList.Count) $View"
            Foreach($Item in $KeyList){          
                [PsCustomObject][Ordered]@{
                    DisplayName = $subKey.OpenSubKey($Item).GetValue('DisplayName')
                    RegHive     = $subKey.OpenSubKey($Item).View
                    Publisher   = $subKey.OpenSubKey($Item).GetValue('Publisher')
                    InstallDate = $subKey.OpenSubKey($Item).GetValue('InstallDate')                        
                    Version     = $subKey.OpenSubKey($Item).GetValue('DisplayVersion')
                    UninstallString = $subKey.OpenSubKey($Item).GetValue('UninstallString')
                }            
            }
        }
    }
}


