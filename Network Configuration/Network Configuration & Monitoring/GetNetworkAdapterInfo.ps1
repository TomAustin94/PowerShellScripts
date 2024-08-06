# Function to retrieve and display network adapter information
function Get-NetworkAdapterInfo {
    # Get all network adapters
    $networkAdapters = Get-NetAdapter

    # Loop through each network adapter and gather detailed information
    foreach ($adapter in $networkAdapters) {
        Write-Host "========================================="
        Write-Host "Adapter Name: " $adapter.Name
        Write-Host "Interface Description: " $adapter.InterfaceDescription
        Write-Host "MAC Address: " $adapter.MacAddress
        Write-Host "Status: " $adapter.Status
        Write-Host "Link Speed: " $adapter.LinkSpeed
        Write-Host "========================================="

        # Get IP configuration details
        $ipConfig = Get-NetIPConfiguration -InterfaceAlias $adapter.Name
        foreach ($ip in $ipConfig.IPv4Address) {
            Write-Host "IPv4 Address: " $ip.IPAddress
        }
        foreach ($ip in $ipConfig.IPv6Address) {
            Write-Host "IPv6 Address: " $ip.IPAddress
        }
        Write-Host "Default Gateway: " $ipConfig.IPv4DefaultGateway.NextHop
        Write-Host "DNS Servers: " $ipConfig.DnsServer.ServerAddresses
        Write-Host ""
    }
}

# Call the function to display network adapter information
Get-NetworkAdapterInfo
