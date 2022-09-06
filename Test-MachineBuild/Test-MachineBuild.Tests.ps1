Param(
    [Parameter()]
    $ConfigFile = '.\MachineBuild-Config.psd1'
)
BeforeDiscovery {
    $Data = Import-PowerShellDataFile $ConfigFile    
}

BeforeAll{
    Function Get-InstalledProgram{
        Param(
            [String]$ComputerName
        )
        Begin{
            $RegistryView = @([Microsoft.Win32.RegistryView]::Registry32,[Microsoft.Win32.RegistryView]::Registry64)
            $RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine
            $SoftwareHKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
        }
        Process{        
            Foreach($View in $RegistryView){
                try{
                    $Key = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $ComputerName, $View)
                }catch{                
                    $MsgBody  = "Unable to access registry on {0}. Error code: {1:x}" -f $ComputerName, $_.Exception.HResult
                    Write-Warning $MsgBody
                    continue
                }
                $SubKey  = $Key.OpenSubKey($SoftwareHKey)
                $KeyList = $SubKey.GetSubKeyNames()
                Foreach($Item in $KeyList){
                    [PSCustomObject][Ordered]@{
                        DisplayName = $SubKey.OpenSubKey($Item).GetValue('DisplayName')
                        RegHive     = $SubKey.OpenSubKey($Item).View
                        Publisher   = $SubKey.OpenSubKey($Item).GetValue('Publisher')
                        InstallDate = $SubKey.OpenSubKey($Item).GetValue('InstallDate')
                        Version     = $SubKey.OpenSubKey($Item).GetValue('DisplayVersion')
                        InstallSource   = $SubKey.OpenSubKey($Item).GetValue('InstallSource')
                        UninstallString = $SubKey.OpenSubKey($Item).GetValue('UninstallString')
                    }   
                }        
            }    
        }
    }

    Function Test-Registry{
        [OutputType([Bool])]
        Param(
            $Path,
            $Name,
            $Value
        )
        Process{
            Try{    $Result = Get-ItemPropertyValue -Path $Path -Name $Name }
            catch{  $Result = $null   }
            return ($Result -eq $Value)
        }
    }
    [Void](New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT)
    $InstalledSW = Get-InstalledProgram -ComputerName $Env:ComputerName | where{$_.DisplayName}
}

Describe "Software Installation" {           
    It "<_> should be installed" -Foreach $($Data.Software) {
        ($_ -in $($InstalledSW.DisplayName)) | Should -Be $true
    }    
}

Describe "Files and Folders"{       
    It "<_> should exist" -Foreach $($Data.Folder) {
        Test-Path -Path $_ | Should -Be $true
    }        
}

Describe "Registry key values"{
    It "<Name> Should have <Value>" -Foreach $($Data.Registry) {
        Test-Registry -Path $_.Path -Name $_.Name -Value $_.Value | Should -Be $true
    }    
}

Describe "Service Status"{    
    It "<Name> Should be <Status>" -Foreach $($Data.Service) {
        (Get-Service -Name $_.Name).Status  | Should -Be $_.Status
    }
}
