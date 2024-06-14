<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>



$appId = '82bc3e1b-ed77-476a-8723-623a747f8739' #web app
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$refreshToken = $AccessTokenN30.RefreshToken #Initial Interactive Access Token that contains our initial Refresh Token that was stored at first in the Azure Key Vault
$tenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
$AccessTokenN = New-PartnerAccessToken -ApplicationId $appId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Tenant $tenantID

$AccessTokenN.accesstoken #to be passed to step 3 to connect-partnercenter