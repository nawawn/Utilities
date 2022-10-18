#This is for Server Deployment Only
Function Install-SNMPService{
    [CmdletBinding()]
    Param()
    Process{
        If ((Get-WindowsFeature SNMP-Service).Installed -ne $true){
            Write-Verbose "Installing SNMP Service and Management Tools..."
            Install-WindowsFeature SNMP-Service -IncludeManagementTools
        }
    }
}

Function Update-Registry{
    [CmdletBinding()]
    Param(
        $Path,
        $Key,
        $Value,
        $Type
    )
    Process{
        If (!(Test-Path -Path $Path)) {
            Write-Warning "Registry Path not found, creating $Path" 
            New-Item -Path $Path -Force
            New-ItemProperty -Path $Path -Name $Key -PropertyType $Type -Value $Value -Force       
            #Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $Type            
        }
        Else {            
            New-ItemProperty -Path $Path -Name $Key -PropertyType $Type -Value $Value -Force
            Write-Verbose "Setting has been updated - $Key : $Value"
        }
    }
}

Function Set-SNMPAgent{
    Param(
        [Parameter()]
        [MailAddress]$Contact,
        [String]$Location
    )
    Process{
        If ($Contact){
            $ContactParam = @{
                Path  = 'HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent'
                Key   = 'sysContact'
                Value = $Contact
                Type  = 'String'
            }
            Update-Registry @ContactParam
        }
        If ($Location){
            $LocationParam = @{
                Path  = 'HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent'
                Key   = 'sysLocation'
                Value = $Location
                Type  = 'String'
            }
            Update-Registry @LocationParam
        }
    }
}

Function Set-SNMPTrap{
    Param(
        [Parameter()]
        $CommunityName,
        $Destination
    )
    Begin{
        $Path  = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\$CommunityName"
    }
    Process{
        $Index = (Get-Item -Path $Path -ErrorAction SilentlyContinue).Property.Count
        If($Index -ge 1){
            $Index++
            $TrapParam = @{
                Path  = $Path
                Key   = $Index
                Value = $Destination
                Type  = 'String'
            }
            Update-Registry @TrapParam
        }
        Else{
            $Index = 1
            $TrapParam = @{
                Path  = $Path
                Key   = $Index
                Value = $Destination
                Type  = 'String'
            }
            Update-Registry @TrapParam
        }
    }
}

Function Set-SNMPSecurity{
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$CommunityName,
        [ValidateSet("NONE", "NOTIFY", "READ ONLY","READ WRITE", "READ CREATE")]
        [String]$CommunityRight = "READ ONLY"
    )
    Begin{
        $Hash = @{
            'NONE'        = 1
            'NOTIFY'      = 2
            'READ ONLY'   = 4
            'READ WRITE'  = 8
            'READ CREATE' = 16
        }
    }
    Process{
        $CommunityParam = @{
            Path  = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities"
            Key   = $CommunityName
            Value = $($Hash.$CommunityRight)
            Type  = 'DWord'
        }
        Update-Registry @CommunityParam
    }   
}

Function Add-AcceptSNMPHost{
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String[]]$HostNameIp
    )
    Begin{
        $Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers'
    }
    Process{
        $Index = (Get-Item -Path $Path -ErrorAction SilentlyContinue).Property.Count
        If ($Index -ge 1){
            $Index++
        }
        Else{
            $Index = 1
        }
        Foreach($Machine in $HostNameIp){
            $PermittedMgr = @{
                Path  = $Path
                Key   = $Index
                Value = $Machine
                Type  = 'String'
            }
            Update-Registry @PermittedMgr
            $Index++
        }       
    }    
}

<#
Install-SNMPService -Verbose
$AgentTab = @{
    Contact = 'snmp@mydomain.com'
    Location = 'London'
}
Set-SNMPAgent @AgentTab -Verbose
$TrapTab = @{
    CommunityName = 'Public'
    Destination   = '192.168.0.10'
}
Set-SNMPTrap @TrapTab -Verbose
$Security = @{
    CommunityName  = 'Public'
    CommunityRight = 'READ ONLY'
}
Set-SNMPSecurity @Security -Verbose
Add-AcceptSNMPHost -HostNameIp 'localhost','192.168.0.10' -Verbose
#>

Function Deploy-SNMPService{
    Param(
        [Parameter()]
        $ConfigFile
    )
    Process{
        If (-Not(Test-Path -Path $ConfigFile)){
            Write-Warning "Config File not found"
            return
        }
        If ((Get-Item -Path $ConfigFile).extension -ne ".psd1"){
            Write-Warning "Config File not valid. Expect psd1 file"
            return
        }
        $Config = Import-PowerShellDataFile -Path $ConfigFile      
        Install-SNMPService
        $AgentParam = $Config.Agent
        Set-SNMPAgent @AgentParam
        $TrapParam = $Config.Trap
        Set-SNMPTrap @TrapParam
        $SecurityParam = $Config.Security
        Set-SNMPSecurity @SecurityParam
        $AcceptHost = $Config.AcceptSNMPHost
        Add-AcceptSNMPHost @AcceptHost
    }
}

Deploy-SNMPService -ConfigFile .\SNMP-Config.psd1 -Verbose