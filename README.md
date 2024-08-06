# PowerShellScripts
A collection of PowerShell Scripts I've written to support my role as a Systems Administrator.

The Scripts included are:

## Active Directory

1. Single User Creation - Including a random password generator & a text file output to be given to the user during their induction period.
2. Bulk User Creation from a CSV - Same as the above but allowing to create multiple users at once. Each user gets their own text file output. 
3. Bulk User Password Reset - This resets a collection of user passwords from a CSV file. The intention for this is to help recover from any infections or large password breaches.
4. Inactive Account CleanUp - Any Accounts which haven't been logged into in a period of time are deactivated & moved to the chosen OU.
5. User Accounts Due to Expire - Any User Accounts which are due to expire in a set time period (default is 30 days.)
6. User Group Membership Report - OutPut to a CSV file a list of users and the groups they're apart of. 
7. Security Log Export - This allows you to easily export a list of security instances to an easy to read CSV (e.g. Access Logs.)

## Network Administration and Configuration

### Network Configuration and Monitoring

1. Get Network Adaptor - Returns information about your network adaptor.
2. Get Network Adaptor Stats - Returns stats about your network adaptor
3. Manage IP - Manage your IP configuration (both static and DHCP)
4. Network Latency - Check your network latency. 
