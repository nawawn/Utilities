Function Get-MS365Version{
    [OutputType([Version])]
    Param(
        [ValidateSet('Beta','MonthlyPreview','Monthly','MEC','SACT','LTSB2021','SAC','LTSB')]
        [String]$Channel = 'Monthly'
    )    
    Process{
        $Uri    = 'https://clients.config.office.net/releases/v1.0/OfficeReleases'     
        $Result = [PSObject](Invoke-RestMethod -Method Get -Uri $Uri).Where{$_.channel -eq $Channel} 
        
        Return ([Version]$Result.latestVersion)
    }
}

Function Download-LatestOfice{
    Param(
        [Parameter()]
        $WorkingDir    = (Resolve-Path -Path $PSScriptRoot),
        $XmlConfigFile = 'download-config.xml'
    )
    Begin{        
        $OfficeFolder  = Join-Path -Path $WorkingDir -ChildPath 'Office'
        $LatestVersion = Get-MS365Version
        $LocalVersion  = (Get-ChildItem "$OfficeFolder\Data" -Directory | Select -ExpandProperty Name) -as [Version]
    }
    Process{
        If (Test-Path -Path "$WorkingDir\$XmlConfigFile"){
            Write-Warning "Unable to locate the XML config file."
            Return
        }
        If ($LatestVersion -gt $LocalVersion){
            If (Test-Path -Path $OfficeFolder){
                Write-Verbose "Removing the older version..."
                Remove-Item $OfficeFolder -Recurse -Force                
            }
        }        
        $Proc = @{
            FilePath     = Resolve-Path "$WorkingDir\Setup.exe"
            ArgumentList = ("/download $XmlConfigFile")
            WorkingDirectory = $WorkingDir
        }
        Write-Verbose "Downloading the new office release..."
        Start-Process @Proc -Wait -NoNewWindow
    }    
}
Download-LatestOfice -Verbose