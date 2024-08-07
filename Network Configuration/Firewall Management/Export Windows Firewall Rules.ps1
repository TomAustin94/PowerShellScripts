# Export-FirewallRules.ps1
# This script exports all Windows Firewall rules to a CSV file.

param (
    [string]$OutputCsvPath = "C:\Path\To\Your\FirewallRules.csv"
)

# Function to export firewall rules
function Export-FirewallRules {
    param (
        [string]$OutputCsv
    )

    # Get all firewall rules
    $firewallRules = Get-NetFirewallRule | Select-Object -Property Name, DisplayName, Description, Enabled, Profile, Direction, Action, EdgeTraversalPolicy, Program, LocalAddress, RemoteAddress, LocalPort, RemotePort, Protocol

    # Export the rules to a CSV file
    try {
        $firewallRules | Export-Csv -Path $OutputCsv -NoTypeInformation
        Write-Output "Firewall rules have been successfully exported to $OutputCsv"
    } catch {
        Write-Error "Failed to export firewall rules to $OutputCsv. Error: $_"
    }
}

# Execute the function
Export-FirewallRules -OutputCsv $OutputCsvPath
