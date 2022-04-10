@{
    Description = 'Counter list, avoid wildcard entry where possible'
    InfluxUri   = 'http://localhost:8086/'
    Database    = 'hyperv'
    Interval    = 5 #Adjust this according to your counter
    Counter = @(
        '\Processor Information(_total)\% Processor Time'
        '\Hyper-V Hypervisor Logical Processor(_total)\% Total Run Time',
        '\Hyper-V Hypervisor Virtual Processor(_total)\% Total Run Time',
        '\Hyper-V Hypervisor Root Virtual Processor(_total)\% Total Run Time',        
        '\Memory\Available Mbytes',
        '\Hyper-V Dynamic Memory Balancer(system balancer)\Available Memory',        
        '\Network Interface(*)\Bytes Total/sec',
        '\Network Adapter(*)\Bytes Total/sec',
        '\Hyper-V Virtual Network Adapter(*)\Bytes/sec',        
        '\LogicalDisk(_total)\Avg. Disk sec/Read',
        '\LogicalDisk(_total)\Avg. Disk sec/Write',
        '\LogicalDisk(_total)\Avg. Disk Read Queue Length',
        '\LogicalDisk(_total)\Avg. Disk Write Queue Length',
        '\LogicalDisk(_total)\Disk Transfers/sec',
        '\PhysicalDisk(_total)\Avg. Disk sec/Read',
        '\PhysicalDisk(_total)\Avg. Disk sec/Write',
        '\PhysicalDisk(_total)\Avg. Disk Read Queue Length',
        '\PhysicalDisk(_total)\Avg. Disk Write Queue Length',
        '\PhysicalDisk(_total)\Disk Transfers/sec'
    )
    Generic = @(
        "\Hyper-V Hypervisor Logical Processor(*)\% Total Run Time",
        "\Hyper-V Hypervisor Virtual Processor(*)\% Total Run Time",
        "\Hyper-V Hypervisor Root Virtual Processor(*)\% Total Run Time",
        "\Memory\Available Mbytes",
        "\Hyper-V Dynamic Memory Balancer(*)\Available Memory",
        "\Network Interface(*)\Bytes Total/sec",
        "\Network Adapter(*)\Bytes Total/sec",
        "\Hyper-V Virtual Network Adapter(*)\Bytes/sec",
        "\PhysicalDisk(*)\Avg. Disk sec/Read",
        "\PhysicalDisk(*)\Avg. Disk sec/Write",
        "\PhysicalDisk(*)\Avg. Disk Read Queue Length",
        "\PhysicalDisk(*)\Avg. Disk Write Queue Length",
        "\PhysicalDisk(*)\Disk Transfers/sec",
        "\LogicalDisk(*)\Avg. Disk sec/Read",
        "\LogicalDisk(*)\Avg. Disk sec/Write",
        "\LogicalDisk(*)\Avg. Disk Read Queue Length",
        "\LogicalDisk(*)\Avg. Disk Write Queue Length",
        "\LogicalDisk(*)\Disk Transfers/sec"
    )   
}