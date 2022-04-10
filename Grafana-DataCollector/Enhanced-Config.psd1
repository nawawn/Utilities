@{
    Description = 'Counter list, avoid wildcard entry where possible'
    InfluxUri   = 'http://localhost:8086/'
    Database    = 'hyperv'
    Interval    = 5
    
    AllRole = @(
    @{    
        Role = "*"
        Counter = @(
            '\processor(_total)\% processor time',
            '\Memory\Available Mbytes',
            '\Network Interface(*)\Bytes Total/sec',
            '\Network Adapter(*)\Bytes Total/sec',
            '\LogicalDisk(_total)\Avg. Disk sec/Read',
            '\LogicalDisk(_total)\Avg. Disk sec/Write',
            '\LogicalDisk(_total)\Avg. Disk Read Queue Length',
            '\LogicalDisk(_total)\Avg. Disk Write Queue Length',
            '\LogicalDisk(_total)\Disk Transfers/sec', 
            '\PhysicalDisk(_total)\Avg. Disk sec/Read',
            '\PhysicalDisk(_total)\Avg. Disk sec/Write',            
            '\PhysicalDisk(_total)\Disk Transfers/sec'
            '\PhysicalDisk(_total)\Avg. Disk Read Queue Length',
            '\PhysicalDisk(_total)\Avg. Disk Write Queue Length'
        )
    }, 
    @{    
        Role = 'Hyper-V'
        Counter = @(
            '\Hyper-V Hypervisor Logical Processor(_total)\% Total Run Time',
            '\Hyper-V Hypervisor Virtual Processor(_total)\% Total Run Time',
            '\Hyper-V Hypervisor Root Virtual Processor(_total)\% Total Run Time',
            '\Hyper-V Dynamic Memory Balancer(system balancer)\Available Memory',
            '\Hyper-V Virtual Network Adapter(*)\Bytes/sec'               
        )
    },
    @{
        Role = 'SQL'
        Counter = @(
            '\Paging File(_Total)\% Usage',
            '\System\Processor Queue Length',
            '\SQLServer:Access Methods\Forwarded Records/sec',
            '\SQLServer:Access Methods\Page Splits/sec',
            '\SQLServer:Buffer Manager\Buffer cache hit ratio',
            '\SQLServer:Buffer Manager\Page life expectancy',
            '\SQLServer:General Statistics\Processes blocked',
            '\SQLServer:SQL Statistics\Batch Requests/sec',
            '\SQLServer:SQL Statistics\SQL Compilations/sec',
            '\SQLServer:SQL Statistics\SQL Re-Compilations/sec'
        )
    },
    @{
        Role = 'Exchange'
        Counter = @(
    
        )
    },
    @{
        Role = 'IIS'
        Counter = @(
            '\HTTP Service Request Queues(*)\CurrentQueueSize',
            '\Web Service(_total)\Get Requests/sec',
            '\Web Service(_total)\Post Requests/sec',
            '\Web Service(_total)\Current Connections'
        )
    })
}

#AllRole.Where{$_.Role -eq "IIS"}.Counter
#AllRole.Role
