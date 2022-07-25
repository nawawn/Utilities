@{
    #'Example of Win32 App for Intune'
    Orca = @{
        ODataType    = '#microsoft.graph.win32LobApp'
        FilePath     = 'C:\Temp\OrcaMSI\Orca.intunewin'
        Description  = 'Orca MSI Explorer'
        Publisher    = 'Microsoft'
        InstallCmd   = 'msiexec /i Orca.msi /qn'
        UninstallCmd = 'msiexec /x {85F4CBCB-9BBC-4B50-A7D8-E1106771498D} /qn'
        InstallExp   = 'system'
        RestartMode  = 'suppress'
        DetectionRule = @{
            Type = 'MSI'
            Script = @{
                ScriptFile = 'c:\temp\Check-MyApplication.ps1'
                RunAs32Bit = $false
                EnforceSignatureCheck = $false
            }
            MSI = @{
                ProductCode = '{85F4CBCB-9BBC-4B50-A7D8-E1106771498D}'
            }
            File = @{
                Existence = $true
                Path      = 'C:\Program Files (x86)\Orca'
                FileOrFolder  = 'Orca.exe'
                DetectionType = 'exists'
            }
            Registry = @{
                Existence = $true
                KeyPath   = 'HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{85F4CBCB-9BBC-4B50-A7D8-E1106771498D}'
                ValueName = 'UninstallString'
                DetectionType = 'exists'
            }           
        }
        Assignment = @{
            Group = @{
                Include = $true
                GroupID = '6388083c-6a27-4dcd-a96d-80e8c9d3324d'
                Intent  = 'available'
            }           
        }
    }
    'Microsoft ODBC SQL Driver' = @{
        ODataType    = '#microsoft.graph.win32LobApp'
        FilePath     = 'C:\Temp\Microsoft\msodbcsql.intunewin'
        Description  = 'Microsodft ODBC SQL'
        Publisher    = 'Microsoft'
        InstallCmd   = 'msiexec /i msodbcsql.msi /qn'
        UninstallCmd = 'msiexec /x {7453C0F5-03D5-4412-BB8F-360574BE29AF} /qn'        
        InstallExp   = 'system'
        RestartMode  = 'suppress'
        DetectionRule = @{
            Type = 'MSI'
            MSI = @{
                ProductCode = '{7453C0F5-03D5-4412-BB8F-360574BE29AF}'
            }
        }
        Assignment = @{
            Group = @{
                Include = $true
                GroupID = '5b4ec678-c1fd-4f89-9338-91b28493f5b9'
                Intent  = 'required'
            }
            AllUsers = @{
                Intent = 'available'
            }
            AllDevices = @{
                Intent = 'available'
            }
        }
    }
}

#$Config.Keys
