# Prompt the user for the log name
$logName = Read-Host "Enter the log name (e.g., Security)"

# Prompt the user for the instance ID
$instanceId = Read-Host "Enter the instance ID (e.g., 4624)"

# Prompt the user for the number of days to look back
$days = Read-Host "Enter the number of days to look back (e.g., 30)"

# Calculate the date to filter events
$startDate = (Get-Date).AddDays(-[int]$days)

# Prompt the user for the output file path
$outputPath = Read-Host "Enter the full path for the output CSV file (e.g., C:\LogonEvents.csv)"

# Get the event log and export it to a CSV file
try {
    Get-EventLog -LogName $logName -InstanceId $instanceId -After $startDate | Export-Csv -Path $outputPath -NoTypeInformation
    Write-Host "Event log exported successfully to $outputPath"
} catch {
    Write-Error "An error occurred: $_"
}
