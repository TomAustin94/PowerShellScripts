# Import the Active Directory module
Import-Module ActiveDirectory

# Function to generate a random password
function Generate-RandomPassword {
    param (
        [int]$Length = 14
    )

    if ($Length -lt 14) {
        throw "Password must be at least 14 characters long."
    }

    $characters = [char[]]([char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>?')
    $password = -join ((1..$Length) | ForEach-Object { $characters[(Get-Random -Minimum 0 -Maximum $characters.Length)] })
    return $password
}

# Import the CSV file
$UserList = Import-Csv -Path "C:\path\to\users.csv"

# Determine script directory and create 'New Users' folder if it doesn't exist
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$newUsersDir = Join-Path -Path $scriptDir -ChildPath 'New Users'
if (-not (Test-Path -Path $newUsersDir)) {
    New-Item -ItemType Directory -Path $newUsersDir | Out-Null
    Write-Host 'New Users folder created.'
} else {
    Write-Host 'New Users folder already exists.'
}

# Loop through each user in the CSV
foreach ($User in $UserList) {
    $Password = Generate-RandomPassword

    # Create the user with a WhatIf parameter
    New-ADUser -Name "$($User.FirstName) $($User.LastName)" `
               -GivenName $User.FirstName `
               -Surname $User.LastName `
               -SamAccountName $User.SamAccountName `
               -UserPrincipalName "$($User.SamAccountName)@example.com" `
               -Path $User.OU `
               -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -WhatIf
}

# Prompt for confirmation
$confirmation = Read-Host "Do you want to proceed with the creation of the users? (y/n)"
if ($confirmation -eq 'y') {
    foreach ($User in $UserList) {
        $Password = Generate-RandomPassword

        # Create the user
        New-ADUser -Name "$($User.FirstName) $($User.LastName)" `
                   -GivenName $User.FirstName `
                   -Surname $User.LastName `
                   -SamAccountName $User.SamAccountName `
                   -UserPrincipalName "$($User.SamAccountName)@example.com" `
                   -Path $User.OU `
                   -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true

        # Create a .txt file with login details
        $loginDetails = "Username: $($User.SamAccountName)`nPassword: $Password"
        $filePath = Join-Path -Path $newUsersDir -ChildPath "$($User.SamAccountName).txt"
        $loginDetails | Out-File -FilePath $filePath
        Write-Host "User $($User.SamAccountName) created and login details saved to $filePath"
    }
} else {
    Write-Host "User creation cancelled."
}
