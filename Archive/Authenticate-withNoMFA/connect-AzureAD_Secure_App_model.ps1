$TenantID_6001 = $null
$TenantID_6001 = "dc3227a4-53ba-48f1-b54b-89936cd5ca53" #Canada Computing AD



$Appcredential_3001 = Get-Credential
$refreshToken_3001 = "<OAUTH_REFRESH_TOKEN_PLACEHOLDER>"
# $refreshToken_3001 = "<OAUTH_REFRESH_TOKEN_PLACEHOLDER>"


# $AccountId_3001 = $null
# $AccountId_3001 = 'Abdullah@canadacomputing.ca'

$newPartnerAccessTokenSplat_aadGraphToken = @{
    ApplicationId = $Appcredential_3001.UserName
    Credential = $Appcredential_3001
    RefreshToken = $refreshToken_3001
    Scopes = 'https://graph.windows.net/.default'
    ServicePrincipal = $true
    Tenant = $TenantID_6001
}

$aadGraphToken = New-PartnerAccessToken @newPartnerAccessTokenSplat_aadGraphToken



$newPartnerAccessTokenSplat_graphToken = @{
    ApplicationId = $Appcredential_3001.UserName
    Credential = $Appcredential_3001
    RefreshToken = $refreshToken_3001
    Scopes = 'https://graph.microsoft.com/.default'
    ServicePrincipal = $true
    Tenant = $TenantID_6001
}

$graphToken = New-PartnerAccessToken @newPartnerAccessTokenSplat_graphToken

$connectAzureADSplat = @{
    AadAccessToken = $aadGraphToken.AccessToken
    AccountId = 'Abdullah@canadacomputing.ca'
    MsAccessToken = $graphToken.AccessToken
}

Connect-AzureAD @connectAzureADSplat


# When connecting to an environment where you have admin on behalf of privileges, you will need to specify the tenant identifier for the target environment through the Tenant parameter. With respect to the Cloud Solution Provider program this means you will specify the tenant identifier of the customer's Azure Active Directory tenant using the Tenant parameter.



# $connectAzureADSplat = @{
#     AadAccessToken = '<JWT_TOKEN_PLACEHOLDER>'
#     AccountId = 'Abdullah@canadacomputing.ca'
#     MsAccessToken = '<JWT_TOKEN_PLACEHOLDER>'
# }

# Connect-AzureAD @connectAzureADSplat


<#
Get-AzureADServicePrincipal -All:$True

Get-AzureADServicePrincipal -ObjectId '908deb25-aa3f-47a1-90d0-77352a7f0451'

Get-AzRoleAssignment -ServicePrincipalName '908deb25-aa3f-47a1-90d0-77352a7f0451' #Using the Object ID for the service principal
Get-AzRoleAssignment -ServicePrincipalName '0d32e246-74a4-4930-af3f-4972652d75bb' #using the APP ID

$newAzRoleAssignmentSplat = @{
    ApplicationId = '0d32e246-74a4-4930-af3f-4972652d75bb'
    RoleDefinitionName = 'owner'
}

New-AzRoleAssignment @newAzRoleAssignmentSplat

#>