# PowerShell Script to Monitor Network Traffic and Bandwidth Usage

# Function to get network adapter statistics
function Get-NetworkTraffic {
    param (
        [string]$AdapterName
    )

    # Get the network adapter statistics
    $adapterStats = Get-NetAdapterStatistics -Name $AdapterName

    # Calculate the bandwidth usage
    $bytesSent = $adapterStats.OutboundBytes
    $bytesReceived = $adapterStats.InboundBytes
    $totalBytes = $bytesSent + $bytesReceived

    # Convert bytes to megabytes
    $mbSent = [math]::Round($bytesSent / 1MB, 2)
    $mbReceived = [math]::Round($bytesReceived / 1MB, 2)
    $totalMB = [math]::Round($totalBytes / 1MB, 2)

    # Display the results
    Write-Output "Network Adapter: $AdapterName"
    Write-Output "Bytes Sent: $bytesSent bytes ($mbSent MB)"
    Write-Output "Bytes Received: $bytesReceived bytes ($mbReceived MB)"
    Write-Output "Total Data: $totalBytes bytes ($totalMB MB)"
    Write-Output "----------------------------------------"
}

# Main script
# List all network adapters
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

# Monitor network traffic for each adapter
foreach ($adapter in $networkAdapters) {
    Get-NetworkTraffic -AdapterName $adapter.Name
}

# Optional: Add a loop to continuously monitor the traffic
while ($true) {
    Clear-Host
    foreach ($adapter in $networkAdapters) {
        Get-NetworkTraffic -AdapterName $adapter.Name
    }
    Start-Sleep -Seconds 5
}
