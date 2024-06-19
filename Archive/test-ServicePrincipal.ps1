# The following does not find the service principal BEFORE me clicking on Grant Admin Conset in the Entra ID Portal under app reg

# # Retrieve all service principals
# $servicePrincipals = Get-MgServicePrincipal

# # Filter service principals containing "graph" in their DisplayName
# # $graphServicePrincipals = $servicePrincipals | Where-Object { $_.DisplayName -like "*graphapp-test*" }
# $graphServicePrincipals = $servicePrincipals | Where-Object { $_.DisplayName -like "*graphapp-test*" }

# # Display the filtered service principals
# $graphServicePrincipals | Format-Table DisplayName, AppId, Id





# The following does find the app using the app ID BEFORE clicking Grant Admin Consent in the Entra ID portal

# # Retrieve all registered applications
# $appRegistrations = Get-MgApplication

# # Filter applications to find the one with your AppId
# $app = $appRegistrations | Where-Object { $_.AppId -eq "08216f27-1d3d-4a9f-9406-80f957e7fca6" }

# # Display the application details
# $app | Format-Table DisplayName, AppId, Id








# # Ensure you are connected to Microsoft Graph
# Connect-MgGraph -Scopes "Application.ReadWrite.All"

# Create a new service principal for the application
# New-MgServicePrincipal -AppId "f2108844-50d3-45cb-9c7c-6d1ac5b92912"

# # Verify the creation
# $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq 'f2108844-50d3-45cb-9c7c-6d1ac5b92912'"
# $servicePrincipal | Format-Table DisplayName, AppId, Id





# New-MgServicePrincipal -AppId "6065ddef-dc78-4a96-b430-27d50c4722d3"

# # Verify the creation
# $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '6065ddef-dc78-4a96-b430-27d50c4722d3'"
# $servicePrincipal | Format-Table DisplayName, AppId, Id












$graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles,oauth2PermissionScopes

# List all OAuth2 permission scopes
$graphServicePrincipal.oauth2PermissionScopes | Format-Table id, value

# List all app roles
$graphServicePrincipal.appRoles | Format-Table id, value

