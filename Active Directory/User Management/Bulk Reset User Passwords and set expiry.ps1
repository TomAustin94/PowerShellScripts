# Import the CSV file containing user account information
$csvFilePath = "C:\UsersToReset.csv"

# Check if the CSV file exists
if (-Not (Test-Path -Path $csvFilePath)) {
    Write-Error "The CSV file $csvFilePath does not exist. Please check the file path and try again."
    exit
}

# Import the CSV file
$users = Import-Csv -Path $csvFilePath

# Initialize progress bar
$totalUsers = $users.Count
$currentUser = 0

# Loop through each user in the CSV file
foreach ($user in $users) {
    $currentUser++
    $progressPercent = ($currentUser / $totalUsers) * 100

    # Display progress
    Write-Progress -Activity "Resetting user passwords" -Status "Processing user $currentUser of $totalUsers" -PercentComplete $progressPercent

    try {
        # Set the new password for the user
        Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword (ConvertTo-SecureString $user.NewPassword -AsPlainText -Force) -ErrorAction Stop

        # Force the user to change their password at next logon
        Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true -ErrorAction Stop

        Write-Host "Password reset and change at logon enforced for user: $($user.SamAccountName)" -ForegroundColor Green
    } catch {
        Write-Error "Failed to reset password for user: $($user.SamAccountName). Error: $_"
    }
}

Write-Host "Password reset process completed." -ForegroundColor Yellow
