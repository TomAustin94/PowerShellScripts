# Define the number of days to check for expiring accounts
$daysToCheck = 30

# Define the output file path
$outputFilePath = "C:\ExpiringAccounts.csv"

# Calculate the date threshold
$dateThreshold = (Get-Date).AddDays($daysToCheck)

# Fetch AD users whose accounts are expiring within the specified number of days
try {
    $expiringAccounts = Get-ADUser -Filter {AccountExpirationDate -lt $dateThreshold} -Properties AccountExpirationDate | 
                        Select-Object Name, SamAccountName, AccountExpirationDate

    # Export the results to a CSV file
    $expiringAccounts | Export-Csv -Path $outputFilePath -NoTypeInformation

    Write-Output "Expiring accounts have been successfully exported to $outputFilePath"
} catch {
    Write-Error "An error occurred while fetching or exporting the expiring accounts: $_"
}
