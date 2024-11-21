# Get-MFAAuthenticationMethods.ps1
Gets a full list  of users in an Azure tenant, then enumerates supported Authentication methods including the full range of MFA authentication methods. It prints the results to the screen and into a CSV file for reporting. 

# Usage
1. An Azure/M365 account with global read permissions [User.Read.All & UserAuthenticationMethod.Read.All]. 
2. Check Microsoft Entra Privileged Identity to make sure you activate any just in time permissions.
3. Get a PowerShell shell. 
4. run "Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber"
5. run "Connect-MgGraph" and authenticate.
6. execute the script "./Get-MFAAuthenticationMethods.ps1"

I created this because typically I would use https://github.com/ruudmens/LazyAdmin/blob/master/Office365/MFAStatus.ps1 but I have had issues with it recently perhaps due to changes in the API. 

This script works correctly as of 11/09/2024. If it stops working please let me know with the error messages you recieved. Thanks :)
