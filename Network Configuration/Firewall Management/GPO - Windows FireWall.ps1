# Define parameters
param (
    [string]$GpoName = "Firewall GPO",
    [string]$OuDn = "OU=YourOU,DC=domain,DC=com",
    [string]$RuleName = "Allow Inbound TCP 80",
    [string]$RuleDescription = "Allow inbound TCP traffic on port 80",
    [string]$RuleDirection = "Inbound",
    [string]$RuleAction = "Allow",
    [string]$RuleProtocol = "TCP",
    [int]$RulePort = 80
)

# Import the GroupPolicy module
Import-Module GroupPolicy

# Create a new GPO
$gpo = New-GPO -Name $GpoName -Comment "GPO to configure Windows Firewall rules"

# Get the GPO's GUID
$gpoGuid = $gpo.Id

# Define the path to the GPO
$gpoPath = "LDAP://CN={$gpoGuid},CN=Policies,CN=System,DC=domain,DC=com"

# Create the firewall rule
$firewallRuleXml = @"
<rule version="1">
    <name>$RuleName</name>
    <description>$RuleDescription</description>
    <direction>$RuleDirection</direction>
    <action>$RuleAction</action>
    <protocol>$RuleProtocol</protocol>
    <localport>$RulePort</localport>
</rule>
"@

# Define the registry path for the firewall rule
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules"

# Apply the firewall rule to the GPO
Set-GPRegistryValue -Name $GpoName -Key $regPath -ValueName $RuleName -Type String -Value $firewallRuleXml

# Link the GPO to the specified OU
New-GPLink -Name $GpoName -Target $OuDn

# Output success message
Write-Output "GPO '$GpoName' created and linked to '$OuDn'. Firewall rule '$RuleName' configured successfully."
