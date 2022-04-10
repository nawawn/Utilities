#GUI Tool to install software

#Import the list from Config
$Config    = Import-PowerShellDataFile .\Software-Config.psd1
$Downloads = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'

#Download the software
Function Get-Software{
    Param(
        [URI]$Uri,
        [String]$Destination
    )
    Process{
        Switch($Uri.Scheme){
            'http' {Start-BitsTransfer -Source $Uri.OriginalString -Destination $Downloads\$($Uri.OriginalString.Split("/")[-1]); break}
            'https'{Start-BitsTransfer -Source $Uri.OriginalString -Destination $Downloads\$($Uri.OriginalString.Split("/")[-1]); break}            
            'file' {Copy-Item -Path $Uri.OriginalString -Destination $Downloads}
        }
        
    }
}

#Install the software

Function Install-Software{}