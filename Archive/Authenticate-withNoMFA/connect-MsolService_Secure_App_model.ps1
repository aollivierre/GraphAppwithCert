$credential = Get-Credential
$refreshToken = '<RefreshToken>'

$newPartnerAccessTokenSplat = @{
    ApplicationId = 'xxxx-xxxx-xxxx-xxxx'
    Credential = $credential
    RefreshToken = $refreshToken
    Scopes = 'https://graph.windows.net/.default'
    ServicePrincipal = $true
    Tenant = 'yyyy-yyyy-yyyy-yyyy'
}

$aadGraphToken = New-PartnerAccessToken @newPartnerAccessTokenSplat
$newPartnerAccessTokenSplat = @{
    ApplicationId = 'xxxx-xxxx-xxxx-xxxx'
    Credential = $credential
    RefreshToken = $refreshToken
    Scopes = 'https://graph.microsoft.com/.default'
    ServicePrincipal = $true
    Tenant = 'yyyy-yyyy-yyyy-yyyy'
}

$graphToken = New-PartnerAccessToken @newPartnerAccessTokenSplat

$connectMsolServiceSplat = @{
    AdGraphAccessToken = $aadGraphToken.AccessToken
    MsGraphAccessToken = $graphToken.AccessToken
}

Connect-MsolService @connectMsolServiceSplat