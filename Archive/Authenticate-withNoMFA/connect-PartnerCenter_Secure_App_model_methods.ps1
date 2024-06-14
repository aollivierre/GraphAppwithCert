#!Username/password credential authorization has been removed in Partner Center PowerShell due to the partner security requirements. If you use credential authorization for automation purposes, instead implement the Secure Application Model so you can authenticate using an access token generated using a refresh token.

# A Service Principal is an application within Azure Active Directory, which is authorized to access resources or resource group in Azure. ... You can assign permissions to the service principal that are different than your own Azure account permissions.

#Region Authentication Method 0 Sign in interactively [launching a browser]
Connect-PartnerCenter
# WARNING: Attempting to launch a browser for authorization code login.
# WARNING: We have launched a browser for you to login. For the old experience with device code flow, please run 'Connect-PartnerCenter -UseDeviceAuthentication'.
# Account                                  Environment                                          TenantId
# -------                                  -----------                                          --------
# bf72cc2b-b88d-4570-afc6-dc785e5e5f80     AzureCloud                                           dc3227a4-53ba-48f1-b54b-89936cd5ca53
#EndRegion Authentication Method 0 Sign in interactively

#Region Authentication Method1 (using Service Principal [Refresh token based]) (PartnerCenter 3.0)

$credential = Get-Credential #The first command gets the service principal credentials (application identifier and secret), and then stores them in the $credential variable. This is required if the refresh token was generate using a web application because Azure Active Directory requires the application identifier and secret be included with the request.
$refreshToken = '<refreshToken>'

$connectPartnerCenterSplat = @{
    ApplicationId = 'xxxx-xxxx-xxxx-xxxx'
    Credential = $credential
    RefreshToken = $refreshToken
}

Connect-PartnerCenter @connectPartnerCenterSplat
#Endregion Authentication Method1 (using Service Principal [Refresh token based]) (PartnerCenter 3.0)

#Region Authentication Method2 (using Service Principal [App Secret/Secret Based]) PartnerCenter 3.0
# Sign in with a service principal
# Service principals are non-interactive Azure accounts. Like other user accounts, their permissions are managed with Azure Active Directory. By granting a service principal only the permissions it needs, your automation scripts stay secure.

# To sign in with a service principal, use the -ServicePrincipal argument with the Connect-PartnerCenter cmdlet. You will also need the service principal's application identifier, sign-in credentials, and the tenant identifier associate with the service principal. How you sign in with a service principal will depend on whether it is configured for password-based or certificate-based authentication.
Connect-PartnerCenter -Credential -ServicePrincipal -ApplicationId -Tenant
#endRegion Authentication Method2 (using Service Principal)

#Region Authentication Method3 (using Service Prinicapl [Certificate based]) PartnerCenter 3.0
# Import a PFX/a certificate in PowerShell 5.1
$credentials = Get-Credential -Message "Provide PFX private key password"
$importPfxCertificateSplat = @{
    FilePath = 'path to certificate'
    Password = $credentials.Password
    CertStoreLocation = 'cert:\CurrentUser\My'
}

Import-PfxCertificate @importPfxCertificateSplat certificate>


# Import a PFX/a certificate in PowerShell 6.X and later
$storeName = [System.Security.Cryptography.X509Certificates.StoreName]::My 
$storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
$store = [System.Security.Cryptography.X509Certificates.X509Store]::new($storeName, $storeLocation)
$certPath = <path to certificate>
$credentials = Get-Credential -Message "Provide PFX private key password"
$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
$certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certPath, $credentials.Password, $flag)
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$store.Add($Certificate)
$store.Close()


$connectPartnerCenterSplat = @{
    CertificateThumbprint = '<thumbprint>'
    ServicePrincipal = $true
    Tenant = 'xxxx-xxxx-xxxx-xxxx'
}

Connect-PartnerCenter @connectPartnerCenterSplat
#endregion Authentication Method3 (using Certificate)

#Region Authentication Method4 (using Service Prinicapl [Access token based]) (Partner Center 1.5)
$refreshToken = 'Enter the refresh token value here'

$credential = Get-Credential
$tenantId = '<Your Tenant Id>'
$newPartnerAccessTokenSplat = @{
    RefreshToken = $refreshToken
    Credential = $credential
    Tenant = $tenantId
    Resource = 'https://api.partnercenter.microsoft.com'
}

$pcToken = New-PartnerAccessToken @newPartnerAccessTokenSplat

$newConnectPartnerCenterSplat = @{
    AccessToken = $pcToken.AccessToken
    ApplicationId = $appId
    Tenant = $tenantId
}

Connect-PartnerCenter  @newConnectPartnerCenterSplat

#Endregion Authentication Method4 (using Service Prinicapl [Access token based]) (Partner Center 1.5)

# The following command gets a list of available environments:(optional)
# Get-PartnerEnvironment | Select-Object Name
