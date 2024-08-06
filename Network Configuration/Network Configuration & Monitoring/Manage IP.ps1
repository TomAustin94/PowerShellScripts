# Define the parameters for the script
param (
    [string]$ComputerName,
    [string]$IPAddress,
    [string]$SubnetMask,
    [string]$Gateway,
    [string]$DNS1,
    [string]$DNS2,
    [string]$DHCPServer,
    [switch]$Static,
    [switch]$DHCP
)

# Function to set a static IP address
function Set-StaticIP {
    param (
        [string]$ComputerName,
        [string]$IPAddress,
        [string]$SubnetMask,
        [string]$Gateway,
        [string]$DNS1,
        [string]$DNS2
    )

    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        param (
            $IPAddress, $SubnetMask, $Gateway, $DNS1, $DNS2
        )
        
        # Get the network adapter
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
        
        # Set the static IP address
        New-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -IPAddress $IPAddress -PrefixLength $SubnetMask -DefaultGateway $Gateway
        
        # Set the DNS servers
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses ($DNS1, $DNS2)
        
        Write-Host "Static IP configuration applied successfully."
    } -ArgumentList $IPAddress, $SubnetMask, $Gateway, $DNS1, $DNS2
}

# Function to set DHCP
function Set-DHCP {
    param (
        [string]$ComputerName
    )

    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        # Get the network adapter
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
        
        # Enable DHCP
        Set-DhcpClient -InterfaceIndex $adapter.InterfaceIndex -Dhcp Enabled
        
        Write-Host "DHCP configuration applied successfully."
    }
}

# Function to add a DHCP reservation
function Add-DHCPReservation {
    param (
        [string]$DHCPServer,
        [string]$ComputerName,
        [string]$IPAddress
    )

    # Get the MAC address of the computer
    $macAddress = (Get-WmiObject -ComputerName $ComputerName -Query "SELECT MACAddress FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True").MACAddress

    # Add the DHCP reservation
    Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress $IPAddress -ClientId $macAddress -Description "$ComputerName reservation"
    
    Write-Host "DHCP reservation added successfully."
}

# Main logic
if ($Static) {
    Set-StaticIP -ComputerName $ComputerName -IPAddress $IPAddress -SubnetMask $SubnetMask -Gateway $Gateway -DNS1 $DNS1 -DNS2 $DNS2
} elseif ($DHCP) {
    Set-DHCP -ComputerName $ComputerName
    Add-DHCPReservation -DHCPServer $DHCPServer -ComputerName $ComputerName -IPAddress $IPAddress
} else {
    Write-Host "Please specify either -Static or -DHCP switch."
}
