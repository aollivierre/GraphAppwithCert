$refresh_token = New-PartnerAccessToken -Module ExchangeOnline



# Use the following to generate a new access token using the refresh, and then create the session where you will connect to Exchange Online PowerShell

$customerId = '<CustomerId>'
$customerDomainName = '<CustomerDomainName>'
# $refreshToken = '<RefreshTokenValue>'
$refreshToken = $refreshToken
$upn = '<UPN-used-to-generate-the-refresh-token>'

$newPartnerAccessTokenSplat = @{
    RefreshToken = $refresh_token.RefreshToken
    Scopes = 'https://outlook.office365.com/.default'
    Tenant = $customerId
    ApplicationId = 'a0c73c16-a7e3-4564-9a95-2bdf47383716' #The application identifier a0c73c16-a7e3-4564-9a95-2bdf47383716 is for the Exchange Online PowerShell Azure Active Direcotry application. When requesting an access, or refresh, token for use with Exchange Online PowerShell you will need to use this value.
}
$access_token = New-PartnerAccessToken @newPartnerAccessTokenSplat

$convertToSecureStringSplat = @{
    AsPlainText = $true
    Force = $true
    String = "Bearer $($access_token.AccessToken)"
}
$tokenValue = ConvertTo-SecureString @convertToSecureStringSplat

$credential = New-Object System.Management.Automation.PSCredential($upn, $tokenValue)

$newPSSessionSplat = @{
    ConfigurationName = 'Microsoft.Exchange'
    ConnectionUri = "https://outlook.office365.com/powershell-liveid?DelegatedOrg=$($customerDomainName)&BasicAuthToOAuthConversion=true"
    Credential = $credential
    Authentication = 'Basic'
    AllowRedirection = $true
}
$session = New-PSSession @newPSSessionSplat

Import-PSSession $session

