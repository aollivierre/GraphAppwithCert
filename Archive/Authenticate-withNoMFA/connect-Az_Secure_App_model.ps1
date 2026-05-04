# if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
#     Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
#       'Az modules installed at the same time is not supported.')
# } else {
#     Install-Module -Name 'Az' -AllowClobber -Scope AllUsers -force
#     Import-Module -Name 'Az' -Verbose -Force
# Get-Module -Name 'Az'-ListAvailable | Select-object Name, Version, Modulebase
# }

$TenantID_3001 = $null
$TenantID_3001 = "dc3227a4-53ba-48f1-b54b-89936cd5ca53" #Canada Computing AD
# $TenantID_3001 = "e09d9473-1a06-4717-98c1-528067eab3a4" #FGC Health AD

$RefreshToken_3001 = $null
# $RefreshToken_3001 = "<REDACTED-REFRESH-TOKEN>"

$AccountId_3001 = $null
# $AccountId_3001 = 'Abdullah@canadacomputing.ca'
$AccountId_3001 = 'Admin-CCI@Fgchealth.com'
# $AccountId_3001 = 'testrandmouser@testrandomuserfortestingsecureappmodel.com'

# $Appcredential_3001 = $null
# $Appcredential_3001 = Get-Credential

$Thumbprint_3001 =  $null
$Thumbprint_3001 = '6D95B992C9EB7BF764650D1E1D3D656350916DB1'

# $credential = Get-Credential
# $refreshToken = '<REDACTED>'

$ApplicationId_3001 = $null
$ApplicationId_3001 = '787faab2-3701-4a9e-ac96-168f17b6e2de'

$newPartnerAccessTokenSplat_azureToken_3001 = $null
$newPartnerAccessTokenSplat_azureToken_3001 = @{
    # ApplicationId    = $Appcredential_3001.UserName
    ApplicationId    = $ApplicationId_3001
    # Credential       = $Appcredential_3001
    # RefreshToken     = $RefreshToken_3001 #comment out if you are usnig the UseAuthorizationCode parameter
    Scopes           = 'https://management.azure.com/user_impersonation'
    ServicePrincipal = $true
    Tenant           = $TenantID_3001
    CertificateThumbprint = $Thumbprint_3001
    UseAuthorizationCode = $true #use only the first time to provide consent if you get a consent error
}

$azuretoken_3001 = $null
$azuretoken_3001 = New-PartnerAccessToken @newPartnerAccessTokenSplat_azureToken_3001


$newPartnerAccessTokenSplat_graphToken_3001 = $null
$newPartnerAccessTokenSplat_graphToken_3001 = @{
    # ApplicationId    = $Appcredential_3001.UserName
    ApplicationId    = $ApplicationId_3001
    # Credential       = $Appcredential_3001
    CertificateThumbprint = $Thumbprint_3001
    RefreshToken     = $RefreshToken_3001
    Scopes           = 'https://graph.windows.net/.default'
    ServicePrincipal = $true
    Tenant           = $TenantID_3001
    # UseAuthorizationCode = $true #use only the first time to provide consent if you get a consent error
}

$graphToken_3001 = $null
# $graphToken_3001 = New-PartnerAccessToken @newPartnerAccessTokenSplat_graphToken_3001

# Az Module
$connectAzAccountSplat_3001 = $null
$connectAzAccountSplat_3001 = @{
    AccessToken      = $azuretoken_3001.AccessToken
    AccountId        = $AccountId_3001
    GraphAccessToken = $graphToken_3001.AccessToken
    Tenant           = $TenantID_3001
}

Connect-AzAccount @connectAzAccountSplat_3001



# When connecting to an environment where you have admin on behalf of privileges, you will need to specify the tenant identifier for the target environment through the Tenant parameter. With respect to the Cloud Solution Provider program this means you will specify the tenant identifier of the customer's Azure Active Directory tenant using the Tenant parameter.

