# Connect to Microsoft Graph with appropriate permissions (requires admin consent)
Connect-MgGraph -Scopes "User.Read.All", "UserAuthenticationMethod.Read.All"
# Initialize an array to store output data
$outputData = @()
# Get all users in the tenant
$users = Get-MgUser -All
# Track the total count of users for progress messages
$totalUsers = $users.Count
$currentUserIndex = 1
# Loop through each user
foreach ($user in $users) {
    # Display a status message for each user
    Write-Host "Processing user $currentUserIndex of ${totalUsers}: $($user.DisplayName) ($($user.UserPrincipalName))"
    $currentUserIndex++
    # Initialize a hashtable to store user details and authentication methods
    $userData = @{
        UserId = $user.Id
        DisplayName = $user.DisplayName
        Email = $user.UserPrincipalName
        AuthMethods = ""
    }
    # Get the authentication methods for the current user
    $userAuthMethods = Get-MgUserAuthenticationMethod -UserId $user.Id -ErrorAction SilentlyContinue
    if ($userAuthMethods) {
        # Loop through each authentication method
        foreach ($authMethod in $userAuthMethods) {
            # Extract AdditionalProperties for each authentication method
            $methodDetails = @()
            $authMethod.AdditionalProperties | ForEach-Object {
                foreach ($key in $_.Keys) {
                    $methodDetails += "${key}: $($_[$key])"
                }
            }
            # If there are details, join them into a single string and append to AuthMethods
            if ($methodDetails.Count -gt 0) {
                $userData.AuthMethods += ($methodDetails -join "; ") + "; "
            }
        }
        # Clean up trailing semicolon and space
        if ($userData.AuthMethods.EndsWith("; ")) {
            $userData.AuthMethods = $userData.AuthMethods.TrimEnd("; ")
        }
    } else {
        # If no authentication methods are found
        $userData.AuthMethods = "No authentication methods found"
    }
    # Add the user data to the output array
    $outputData += New-Object PSObject -Property $userData
}
# Display the output in a table format with each user in a row
$outputData | Format-Table -Property UserId, DisplayName, Email, AuthMethods -AutoSize
# Optionally, export the output to a CSV file for easy reference
$outputData | Export-Csv -Path "AuthenticationMethods.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Script completed successfully. Data saved to AuthenticationMethods.csv"
