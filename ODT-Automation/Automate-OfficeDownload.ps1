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

#Automate latest version of office download
$OfficeFolder  = ".\Office"
$LatestVersion = Get-MS365Version
$LocalVersion  = (Get-ChildItem $OfficeFolder -Directory | Select -ExpandProperty Name) -as [Version]

If ($LatestVersion -gt $LocalVersion){
    #Remove-Item $OfficeFolder -Force    
    $FilePath   = 'setup.exe'
    $Argument   = '/download Config.xml'
    $WorkingDir = $PSScriptRoot
    Start-Process -FilePath $FilePath -ArgumentList $Argument -WorkingDirectory $WorkingDir -Wait
}