# Import-FirewallRules.ps1
# This script imports firewall rules from a CSV file and creates them in Windows Firewall.

param (
    [string]$InputCsvPath = "C:\Path\To\Your\FirewallRules.csv"
)

# Function to import firewall rules
function Import-FirewallRules {
    param (
        [string]$InputCsv
    )

    # Import the CSV file
    try {
        $firewallRules = Import-Csv -Path $InputCsv
    } catch {
        Write-Error "Failed to import firewall rules from $InputCsv. Error: $_"
        return
    }

    # Loop through each rule and create it
    foreach ($rule in $firewallRules) {
        try {
            New-NetFirewallRule -Name $rule.Name `
                                -DisplayName $rule.DisplayName `
                                -Description $rule.Description `
                                -Enabled $rule.Enabled `
                                -Profile $rule.Profile `
                                -Direction $rule.Direction `
                                -Action $rule.Action `
                                -EdgeTraversalPolicy $rule.EdgeTraversalPolicy `
                                -Program $rule.Program `
                                -LocalAddress $rule.LocalAddress `
                                -RemoteAddress $rule.RemoteAddress `
                                -LocalPort $rule.LocalPort `
                                -RemotePort $rule.RemotePort `
                                -Protocol $rule.Protocol
        } catch {
            Write-Error "Failed to create firewall rule: $($rule.Name). Error: $_"
        }
    }

    Write-Output "Firewall rules have been successfully imported from $InputCsv"
}

# Execute the function
Import-FirewallRules -InputCsv $InputCsvPath
