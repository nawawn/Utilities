Function Send-TeamAlert{
    Param(
        [String]$Message
    )
    Begin{
        $Uri = 'Paste your MS Teams Uri here https://outlook.office.com/webhook/guid@guid/incomingwebhook/somemoreguid'
    }
    Process{
        $Body = @{
            text = $Message
        } | ConvertTo-Json
        Invoke-RestMethod -Uri $Uri -Method Post -Body $Body -ContentType 'application/json'
    }
}

$Emoji = @{
    Passed = '&#x1f44d'
    Failed = '&#x1f44e'
}
$Result  = (Invoke-Pester .\Test-MachineBuild.Tests.ps1 -PassThru).Result
$Message = "**{0} - Build QC Result: {1}" -f $($Evn:ComputerName), $($Emoji[$Result])

Send-TeamAlert -Message $Message