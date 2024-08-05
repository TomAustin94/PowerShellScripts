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

# Define user attributes
$UserName = "JohnDoe"
$GivenName = "John"
$Surname = "Doe"
$SamAccountName = "John.Doe"
$OU = "OU=Users,DC=example,DC=com"
$Password = Generate-RandomPassword

# Create the user with a WhatIf parameter
New-ADUser -Name $UserName `
           -GivenName $GivenName `
           -Surname $Surname `
           -SamAccountName $SamAccountName `
           -UserPrincipalName "$SamAccountName@example.com" `
           -Path $OU `
           -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
           -Enabled $true `
           -ChangePasswordAtLogon $true `
           -WhatIf

# Prompt for confirmation
$confirmation = Read-Host "Do you want to proceed with the creation of the user? (y/n)"
if ($confirmation -eq 'y') {
    New-ADUser -Name $UserName `
               -GivenName $GivenName `
               -Surname $Surname `
               -SamAccountName $SamAccountName `
               -UserPrincipalName "$SamAccountName@example.com" `
               -Path $OU `
               -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $true

    # Determine script directory and create 'New Users' folder if it doesn't exist
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $newUsersDir = Join-Path -Path $scriptDir -ChildPath 'New Users'
    if (-not (Test-Path -Path $newUsersDir)) {
        New-Item -ItemType Directory -Path $newUsersDir | Out-Null
        Write-Host 'New Users folder created.'
    } else {
        Write-Host 'New Users folder already exists.'
    }

    # Create a .txt file with login details
    $loginDetails = "Username: $SamAccountName`nPassword: $Password"
    $filePath = Join-Path -Path $newUsersDir -ChildPath "$SamAccountName.txt"
    $loginDetails | Out-File -FilePath $filePath
    Write-Host "User created and login details saved to $filePath"
} else {
    Write-Host "User creation cancelled."
}
