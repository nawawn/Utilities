@{
    Agent = @{
        Contact  = 'mycontact@mydomain.com'
        Location = 'LondonOffice'
    }
    Trap = @{
        CommunityName = 'Public'
        Destination   = '192.168.0.10'
    }
    Security = @{
        CommunityName  = 'Public'
        CommunityRight = 'READ ONLY'        
    }
    AcceptSNMPHost = @{
        HostNameIP = @('localhost','192.168.0.10')
    }
}