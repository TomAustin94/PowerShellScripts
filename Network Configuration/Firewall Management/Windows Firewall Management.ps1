# User-Friendly Firewall Configuration Script

# Ensure the script is run with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    Write-Host "This script needs administrator privileges to run." -ForegroundColor Red
    Write-Host "Please right-click on PowerShell and select 'Run as Administrator', then run this script again." -ForegroundColor Yellow
    Pause
    Exit
}

# Function to add a new firewall rule
function Add-FirewallRule {
    param (
        [string]$Name,
        [string]$DisplayName,
        [string]$Description,
        [string]$Direction,
        [string]$Action,
        [string]$Protocol,
        $LocalPort,
        [string]$Program
    )

    New-NetFirewallRule -Name $Name `
                        -DisplayName $DisplayName `
                        -Description $Description `
                        -Direction $Direction `
                        -Action $Action `
                        -Protocol $Protocol `
                        -LocalPort $LocalPort `
                        -Program $Program
}

# Function to remove a firewall rule
function Remove-FirewallRule {
    param (
        [string]$Name
    )

    Remove-NetFirewallRule -Name $Name -ErrorAction SilentlyContinue
}

# Main menu function
function Show-Menu {
    Clear-Host
    Write-Host "======= Windows Firewall Configuration Tool =======" -ForegroundColor Cyan
    Write-Host "1: Add a new firewall rule"
    Write-Host "2: Remove an existing firewall rule"
    Write-Host "3: Enable Windows Firewall for all profiles"
    Write-Host "4: Block all incoming connections on Public profile"
    Write-Host "5: Allow outbound connections by default on all profiles"
    Write-Host "6: Display current firewall rules"
    Write-Host "Q: Quit"
    Write-Host "=================================================" -ForegroundColor Cyan
}

# Function to add a new rule interactively
function Add-NewRule {
    Write-Host "Adding a new firewall rule" -ForegroundColor Green
    $name = Read-Host "Enter rule name"
    $displayName = Read-Host "Enter display name"
    $description = Read-Host "Enter description"
    $direction = Read-Host "Enter direction (Inbound/Outbound)"
    $action = Read-Host "Enter action (Allow/Block)"
    $protocol = Read-Host "Enter protocol (TCP/UDP/Any)"
    $localPort = Read-Host "Enter local port (number or Any)"
    $program = Read-Host "Enter program path (or press Enter for any program)"

    Add-FirewallRule -Name $name -DisplayName $displayName -Description $description `
                     -Direction $direction -Action $action -Protocol $protocol `
                     -LocalPort $localPort -Program $program

    Write-Host "Rule added successfully!" -ForegroundColor Green
    Pause
}

# Main script loop
do {
    Show-Menu
    $input = Read-Host "Please make a selection"

    switch ($input) {
        '1' {
            Add-NewRule
        }
        '2' {
            $ruleName = Read-Host "Enter the name of the rule to remove"
            Remove-FirewallRule -Name $ruleName
            Write-Host "Rule removed (if it existed)." -ForegroundColor Green
            Pause
        }
        '3' {
            Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
            Write-Host "Windows Firewall enabled for all profiles." -ForegroundColor Green
            Pause
        }
        '4' {
            Set-NetFirewallProfile -Profile Public -DefaultInboundAction Block
            Write-Host "Blocked all incoming connections on Public profile." -ForegroundColor Green
            Pause
        }
        '5' {
            Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow
            Write-Host "Allowed outbound connections by default on all profiles." -ForegroundColor Green
            Pause
        }
        '6' {
            Get-NetFirewallRule | Format-Table Name,DisplayName,Enabled,Direction,Action
            Pause
        }
        'Q' {
            return
        }
    }
} until ($input -eq 'Q')
