$getMsalTokenSplat = @{
    ClientId     = '0d32e246-74a4-4930-af3f-4972652d75bb'
    Scopes       = 'https://graph.microsoft.com/.default'
    RedirectUri  = 'https://login.microsoftonline.com'
    ClientSecret = (ConvertTo-SecureString '9Ifl1NCGNlytwF8F62mwROkSRypwLvvOIlzWMPTJJpc=' -AsPlainText -Force)
}

$AccessToken = (Get-MsalToken @getMsalTokenSplat).AccessToken
$AccessToken