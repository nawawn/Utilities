Function Remove-UserProfile{
    Param(
        [Parameter()]
        [Int]$Day,
        [String]$FolderPath,
        [String[]]$Exclude
    )
    Begin{
        If($Day -gt 0){
            Write-Warning "The Day value should be in negative."
            Return
        }
        $FolderList  = Get-ChildItem -Path $FolderPath -Exclude $Exclude -Directory |
                        Where{[DateTime]$_.ListWriteTime -lt (Get-Date).AddDays($Day)} |
                        Select-Object -ExpandProperty Name
        $ProfileList = Get-CimInstance -ClassName Win32_UserProfile | 
                        Where{$_.LocalPath.split('\')[-1] -in $FolderList}
    }
    Process{
        If($ProfileList){
            (Get-Date).ToString() | Add-Content -Path "$FolderPath\DeletionLog.txt"
            $ProfileList.LocalPath | Add-Content -Path "$FolderPath\DeletionLog.txt"
            Foreach ($User in $ProfileList){
                Remove-CimInstance -InputObject $User -ErrorVariable errLog
                If ($errLog){
                    $errLog | Add-Content -Path "$FolderPath\DeletionLog.txt"
                }
            }           
        }
    }
}

$Config = Import-PowerShellDataFile -Path "$PSScriptRoot\UserProfile-Config.psd1"
Remove-UserProfile -Day $Config.Day -FolderPath $Config.FolderPath -Exclude $Config.Exclude
