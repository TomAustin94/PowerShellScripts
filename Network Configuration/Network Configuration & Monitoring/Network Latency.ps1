# Network Latency Testing Script

# Function to perform ping test and log results
function Test-NetworkLatency {
    param (
        [string[]]$Endpoints,
        [int]$Interval,
        [string]$LogFile
    )

    while ($true) {
        foreach ($endpoint in $Endpoints) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $pingResult = Test-Connection -ComputerName $endpoint -Count 1 -ErrorAction SilentlyContinue

            if ($pingResult) {
                $latency = $pingResult.ResponseTime
                $status = "Success"
            } else {
                $latency = "N/A"
                $status = "Failed"
            }

            $logEntry = "$timestamp, $endpoint, $status, $latency ms"
            Write-Output $logEntry
            Add-Content -Path $LogFile -Value $logEntry
        }

        Start-Sleep -Seconds $Interval
    }
}

# User-friendly prompts for input
$endpoints = Read-Host "Enter the network endpoints (comma-separated, e.g., google.com, yahoo.com)"
$interval = Read-Host "Enter the interval in seconds between each test"
$logFile = Read-Host "Enter the path to the log file (e.g., C:\Logs\NetworkLatencyLog.txt)"

# Convert comma-separated endpoints to array
$endpointArray = $endpoints -split ','

# Start the latency test
Test-NetworkLatency -Endpoints $endpointArray -Interval [int]$interval -LogFile $logFile
