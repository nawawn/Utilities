#Requires -Modules Microsoft.Graph.Intune, IntuneWin32App, MSAL.PS

Function Deploy-IntuneWinApp{
    Param(
        [Parameter(Mandatory)]
        [String]$PSConfigFile = ".\IntuneWin32App-Config.psd1"
    )
    Process{
        If (-Not(Test-Path -Path $PSConfigFile)){
            Write-Warning "Configuration File Path not found!"
            return
        }
        If (".psd1" -ne (Get-ChildItem -Path $PSConfigFile).Extension){
            Write-Warning "Configuration File needs to be in psd1 format"
            return
        }
        If (-Not(Connect-MSGraph)){
            Connect-MSGraph
        }
        If (-Not($Global:AccessToken)){
            Connect-MSIntuneGraph
        }
        $Config = Import-PowerShellDataFile -Path $PSConfigFile
        Foreach ($App in $Config.Keys){
            Write-Verbose "$App - Setting up the application!"
            If ($Config[$App].ODataType -ne '#microsoft.graph.win32LobApp'){
                Write-Warning "$App - This type of application is not supported!"
                Continue
            }
            If (".intunewin" -ne (Get-ChildItem -Path $($Config[$App].FilePath)).Extension){
                Write-Warning "$App - File is not in the corret format. Expected .INTUNEWIN file!"
                Continue
            }
            Write-Verbose "$App - Setting up the Detection Rule"
            Switch($Config[$App].DetectionRule.Type){
                'Script' {
                    $ScriptRule = $($Config[$App].DetectionRule.Script)
                    $DetectionRule = New-IntuneWin32AppDetectionRuleScript @ScriptRule
                    break
                }
                'MSI' {
                    $MsiRule = $($Config[$App].DetectionRule.MSI)
                    $DetectionRule = New-IntuneWin32AppDetectionRuleMSI @MsiRule
                    break
                }
                'File' {
                    $FileRule = $($Config[$App].DetectionRule.File)
                    $DetectionRule = New-IntuneWin32AppDetectionRuleFile @FileRule
                    break
                }
                'Registry' {
                    $RegistryRule  = $($Config[$App].DetectionRule.Registry)
                    $DetectionRule = New-IntuneWin32AppDetectionRuleRegistry @RegistryRule
                    break
                }
                Default { Write-Warning "$App - Unknown Detection Rule Type" }           
            }
            If (-Not($DetectionRule)){
                Write-Warning "$App - Failed to create the detection Rule"
                Continue
            }

            Write-Verbose "$App - Creating the Application on Intune" 
            $NewApp = Add-IntuneWin32App -DisplayName $App -FilePath $Config[$App].FilePath -Description $Config[$App].Description `
                        -Publisher $Config[$App].Publisher -InstallExperience $Config[$App].InstallExp `
                        -InstallCommandLine $Config[$App].InstallCmd -UninstallCommandLine $Config[$App].UninstallCmd `
                        -RestartBehavior $Config[$App].RestartMode -DetectionRule $DetectionRule 
            
            Start-Sleep 2
            
            If (-Not($NewApp.Id)){
                Write-Warning "$App - Failed to create the application on Intune"
                Continue
            }

            Write-Verbose "$App - Assigning the Group and Intent"
            If ($Config[$App].Assignment.Group){
                $AssignGroup = $($Config[$App].Assignment.Group)
                Add-IntuneWin32AppAssignmentGroup -ID $NewApp.Id @AssignGroup
            }
            If ($Config[$App].Assignment.AllUsers){
                $AllUsers = $($Config[$App].Assignment.AllUsers)
                Add-IntuneWin32AppAssignmentAllUsers -ID $NewApp.Id @AllUsers
            }
            If ($Config[$App].Assignment.AllDevicess){
                $AllDevices = $($Config[$App].Assignment.AllDevices)
                Add-IntuneWin32AppAssignmentAllDevices -ID $NewApp.Id @AllDevices
            }      
            $DetectionRule = $null
            $NewApp        = $null
            $AssignGroup   = $null
            $AllUsers      = $null
            $AllDevices    = $null            
        }
    
    }

}