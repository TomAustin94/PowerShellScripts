# Import necessary modules
Import-Module -Name 'WatchGuardAPI'  # Ensure you have the WatchGuard API module installed

# Define WatchGuard Firewall credentials and API endpoint
$firewallHost = "10.0.1.1"  # Replace with your firewall's IP address
$apiKey = "your_watchguard_api_key"  # Replace with your WatchGuard API key
$adminUser = "admin"
$adminPassword = "password"  # Replace with your admin password

# Function to authenticate and get a session token
function Get-SessionToken {
    $body = @{
        username = $adminUser
        password = $adminPassword
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "https://$firewallHost/api/v2/login" -Method Post -Body $body -ContentType "application/json"
    return $response.token
}

# Function to get firewall policies
function Get-FirewallPolicies {
    $token = Get-SessionToken
    $headers = @{
        "Authorization" = "Bearer $token"
    }

    $response = Invoke-RestMethod -Uri "https://$firewallHost/api/v2/policies" -Method Get -Headers $headers
    return $response.policies
}

# Function to update a firewall policy
function Update-FirewallPolicy {
    param (
        [string]$policyId,
        [bool]$enableLogging
    )

    $token = Get-SessionToken
    $headers = @{
        "Authorization" = "Bearer $token"
    }

    $body = @{
        logging = $enableLogging
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "https://$firewallHost/api/v2/policies/$policyId" -Method Patch -Headers $headers -Body $body -ContentType "application/json"
    return $response
}

# Example usage
# Get all firewall policies
$policies = Get-FirewallPolicies
Write-Output "Current Firewall Policies:"
$policies | ForEach-Object { Write-Output $_.name }

# Update a specific policy to enable logging
$policyId = "example_policy_id"  # Replace with the actual policy ID
$updateResponse = Update-FirewallPolicy -policyId $policyId -enableLogging $true
Write-Output "Policy Update Response:"
Write-Output $updateResponse
