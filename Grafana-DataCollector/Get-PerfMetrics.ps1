<# Hyper-V Performance Counter to check the bottleneck
Reference URL:
http://wiki.webperfect.ch/index.php?title=Hyper-V:_Performance_(Counters)
https://docs.microsoft.com/en-us/windows-server/administration/performance-tuning/role/hyper-v-server/detecting-virtualized-environment-bottlenecks
#>

$Config = Import-PowerShellDataFile -Path ".\Metrics-Config.psd1"

Function Get-PerfMetrics{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    Param(
        [String]$ComputerName = $env:COMPUTERNAME,
        [String[]]$Counter
    )
    Begin{
        $DefaultEAP = $ErrorActionPreference        
        $Metrics    = @{}
    }
    Process{        
        Foreach($item in $Counter){
            Write-Verbose "PROCESSING... $item"
            $Sample = (Get-Counter -Counter $item -ComputerName $ComputerName).CounterSamples
            If ($Sample){
                Foreach($value in $Sample){
                    $Path        = $($value.Path) -Replace [regex]::Escape("\\$ComputerName\"),""
                    $CookedValue = $value.CookedValue
                    
                    Write-Verbose "$Path - $CookedValue"                    
                    $Metrics[$Path] = $CookedValue
                }
            }
        }       
    }
    End{
        $ErrorActionPreference = $DefaultEAP
        return ($Metrics)
    }
<#
.Synopsis
   Show the counter and its value
.EXAMPLE
   Get-PerfMetrics -Counter "\LogicalDisk(*)\Disk Transfers/sec" -Verbose
.EXAMPLE
   $Metrics = Get-PerfMetrics -Counter $Config.Counter -Verbose
   $Metrics.Keys
.OUTPUTS
   Hashtable
#>
}

#region - Controller Script
While($true){
    $Metrics = Get-PerfMetrics -Counter $Config.Counter
    
    Write-Influx -Measure Server -Tags @{Server=$env:COMPUTERNAME} -Metrics $Metrics -Database $Config.Database -Server $Config.InfluxUri
    #Write-InfluxUDP -IP 1.2.3.4 -Port 8089 -Measure Server -Tags @{Server=$env:COMPUTERNAME} -Metrics $Metrics
    Start-Sleep -Seconds $Config.Interval
}
#endregion