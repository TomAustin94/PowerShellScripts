# Import the Active Directory module
Import-Module ActiveDirectory

# Function to disable user account and move it to the specified OU
function Disable-And-Move-ADUser {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SamAccountName,
        
        [Parameter(Mandatory=$true)]
        [string]$DistinguishedName
    )

    try {
        # Disable the user account
        Disable-ADAccount -Identity $SamAccountName -ErrorAction Stop
        Write-Output "Disabled account: $SamAccountName"

        # Move the user account to the 'Disabled Users' OU
        Move-ADObject -Identity $DistinguishedName -TargetPath "OU=Disabled Users,DC=domain,DC=com" -ErrorAction Stop
        Write-Output "Moved account: $SamAccountName to 'Disabled Users' OU"
    } catch {
        Write-Error "Failed to process account: $SamAccountName. Error: $_"
    }
}

# Get the list of enabled users who have not logged in for the last 90 days
$staleUsers = Get-ADUser -Filter {(Enabled -eq $True) -and (LastLogonDate -lt (Get-Date).AddDays(-90))} -Properties SamAccountName, DistinguishedName

# Check if there are any users to process
if ($staleUsers.Count -eq 0) {
    Write-Output "No stale user accounts found."
    exit
}

# Display the list of users to be disabled and moved
Write-Output "The following user accounts will be disabled and moved to the 'Disabled Users' OU:"
$staleUsers | Select-Object SamAccountName, LastLogonDate | Format-Table -AutoSize

# Confirm with the user before proceeding
$confirmation = Read-Host "Are you sure you want to disable and move these accounts? (Y/N)"
if ($confirmation -ne 'Y') {
    Write-Output "Operation cancelled by user."
    exit
}

# Process each stale user account
foreach ($user in $staleUsers) {
    Disable-And-Move-ADUser -SamAccountName $user.SamAccountName -DistinguishedName $user.DistinguishedName
}

Write-Output "Script completed."
