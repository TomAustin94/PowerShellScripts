# Import the Active Directory module
Import-Module ActiveDirectory

# Define parameters for the script
param (
    [string]$OutputFilePath = "C:\UserGroupMembership.csv"
)

# Function to get user group membership
function Get-UserGroupMembership {
    param (
        [string]$SamAccountName
    )
    try {
        $user = Get-ADUser -Identity $SamAccountName -Properties MemberOf
        return [PSCustomObject]@{
            Name   = $user.Name
            Groups = ($user.MemberOf -join ",")
        }
    }
    catch {
        Write-Warning "Failed to retrieve groups for user: $SamAccountName"
    }
}

# Get all users from Active Directory
$users = Get-ADUser -Filter *

# Initialize an array to store user group memberships
$userGroupMemberships = @()

# Initialize a progress bar
$totalUsers = $users.Count
$currentUser = 0

# Loop through each user and get their group memberships
foreach ($user in $users) {
    $currentUser++
    Write-Progress -Activity "Processing Users" -Status "Processing $($user.SamAccountName)" -PercentComplete (($currentUser / $totalUsers) * 100)
    
    $userGroupMembership = Get-UserGroupMembership -SamAccountName $user.SamAccountName
    if ($userGroupMembership) {
        $userGroupMemberships += $userGroupMembership
    }
}

# Export the results to a CSV file
$userGroupMemberships | Export-Csv -Path $OutputFilePath -NoTypeInformation

Write-Host "User group memberships have been exported to $OutputFilePath"
