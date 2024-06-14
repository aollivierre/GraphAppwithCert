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

# =============================================================================================

#Test #1 (Single Tenant App) within dev tenant and using dev tenant admin (admin-Abdullah)
$appId = '82bc3e1b-ed77-476a-8723-623a747f8739' #web app
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessTokenN30 = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Credential $credential -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$AccessTokenN30.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used


# =============================================================================================

#Test #2
#As A single tenant APP (Partner Center API App) with dev tenant admin Admin-Abdullah@canadacomputing.ca

#of course providing a different tenant ID does not work as the APP ID exist in the dev tenant but not in the customer's tenant


# Request Id: 084759f8-e909-4fb0-9eab-12f19f2c8403
# Correlation Id: aee18978-8797-4693-846c-62562155ccc0
# Timestamp: 2021-05-30T15:17:55Z
# Message: AADSTS700016: Application with identifier '82bc3e1b-ed77-476a-8723-623a747f8739' was not found in the directory 'e09d9473-1a06-4717-98c1-528067eab3a4'. This can happen if the application has not been installed by the administrator of the tenant or consented to by any user in the tenant. You may have sent your authentication request to the wrong tenant.


$appId = '82bc3e1b-ed77-476a-8723-623a747f8739' #web app
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessTokenN30 = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$AccessTokenN30.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used





# =============================================================================================

#Test #3
#As a multi tenant App (Partner Center API APP) that exist in the Dev/Partner with dev tenant admin Admin-Abdullah@canadacomputing.ca

# Request Id: cddadfca-9fb7-4e06-b1ef-3dda8bb39b02
# Correlation Id: d1f9389b-ce65-48e2-a4d5-e513f01f16eb
# Timestamp: 2021-05-30T18:23:26Z
# Message: AADSTS90099: The application '82bc3e1b-ed77-476a-8723-623a747f8739' (Partner Center API) has not been authorized in the tenant 'e09d9473-1a06-4717-98c1-528067eab3a4'. Applications must be authorized to access the customer tenant before partner delegated administrators can use them.


# =============================================================================================


#Test #4
#As a multi tenant App (Partner Center API APP) that exist in the Dev/Partner tenant with tenant admin Admin-CCI@fgchealth.com

# Authentication failed. You can return to the application. Feel free to close this browser tab.



# Error details: error invalid_client error_description: AADSTS650052: The app needs access to a service ('https://api.partnercenter.microsoft.com') that your organization 'e09d9473-1a06-4717-98c1-528067eab3a4' has not subscribed to or enabled. Contact your IT Admin to review the configuration of your service subscriptions. Trace ID: 652dbc08-addd-4486-82cd-dc60b0f72001 Correlation ID: d042d0a3-ee82-4ff7-9de3-ed7f9db84c9e Timestamp: 2021-05-30 18:21:39Z



# =============================================================================================



#Test #5
#As A multi tenant APP (Multi Tenant Azure AD App) that exist in the dev/partner tenant with tenant admin Admin-CCI@fgchealth.com


# Request Id: e73fc8c6-6f32-4907-a93e-b362b16ef002
# Correlation Id: 50264261-4330-4f56-90c5-b42278acc9cd
# Timestamp: 2021-05-30T19:30:53Z
# Message: AADSTS650052: The app needs access to a service ('https://api.partnercenter.microsoft.com') that your organization 'e09d9473-1a06-4717-98c1-528067eab3a4' has not subscribed to or enabled. Contact your IT Admin to review the configuration of your service subscriptions.



$appId = 'c3638d6d-996a-4faf-962e-29829b528f52' #web app
$secret =  ConvertTo-SecureString 'yaK.k-nY6xY1cT.Iq61LCkuyfox-yG.5SW' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessTokenN30 = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://graph.windows.net/.default' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$AccessTokenN30.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used

# =============================================================================================


#Test #6
#As A multi tenant APP (Multi Tenant Azure AD App) that exist in the dev/partner tenant with tenant admin Admin-CCI@fgchealth.com

# Request Id: 938e5e2c-9210-46cc-a380-dcca5fe11901
# Correlation Id: 74e98a50-3dd4-43ec-825e-cdcf08a03e0a
# Timestamp: 2021-05-30T19:33:17Z
# Message: AADSTS650056: Misconfigured application. This could be due to one of the following: the client has not listed any permissions for 'AAD Graph' in the requested permissions in the client's application registration. Or, the admin has not consented in the tenant. Or, check the application identifier in the request to ensure it matches the configured client application identifier. Or, check the certificate in the request to ensure it's valid. Please contact your admin to fix the configuration or consent on behalf of the tenant. Client app ID: c3638d6d-996a-4faf-962e-29829b528f52.



$appId = 'c3638d6d-996a-4faf-962e-29829b528f52' #web app
$secret =  ConvertTo-SecureString 'yaK.k-nY6xY1cT.Iq61LCkuyfox-yG.5SW' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessTokenN30 = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://graph.windows.net/.default' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$AccessTokenN30.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used



# =============================================================================================


#Test #7
#As A multi tenant APP (Multi Tenant Azure AD App) that exist in the dev/partner tenant with tenant admin Admin-CCI@fgchealth.com

#got prompted to provide consent 


# Request Id: 2b0eed21-e18d-411d-9bf4-025f9dabec02
# Correlation Id: 3daf7179-4ae9-4028-a35e-8b270293a466
# Timestamp: 2021-05-30T20:35:47Z
# Message: AADSTS50011: The reply URL specified in the request does not match the reply URLs configured for the application: 'c3638d6d-996a-4faf-962e-29829b528f52'.

$appId = 'c3638d6d-996a-4faf-962e-29829b528f52' #web app
$secret =  ConvertTo-SecureString 'yaK.k-nY6xY1cT.Iq61LCkuyfox-yG.5SW' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessTokenN30 = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$AccessTokenN30.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used


# =============================================================================================

#Test #8
#As A multi tenant APP (Multi Tenant Azure AD App) that exist in the dev/partner tenant with tenant admin Admin-CCI@fgchealth.com
# updated the Redirect URI/Reply URLs to http://localhost:8400

#Success got prompted to provide consent and returned the refresh token


# Request Id: 2b0eed21-e18d-411d-9bf4-025f9dabec02
# Correlation Id: 3daf7179-4ae9-4028-a35e-8b270293a466
# Timestamp: 2021-05-30T20:35:47Z
# Message: AADSTS50011: The reply URL specified in the request does not match the reply URLs configured for the application: 'c3638d6d-996a-4faf-962e-29829b528f52'.


#The following web app 
$appId = 'c3638d6d-996a-4faf-962e-29829b528f52' #web app
$secret =  ConvertTo-SecureString 'yaK.k-nY6xY1cT.Iq61LCkuyfox-yG.5SW' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$graphToken = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$graphToken.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used


#The following web app 
$appId = 'c3638d6d-996a-4faf-962e-29829b528f52' #web app
$secret =  ConvertTo-SecureString 'yaK.k-nY6xY1cT.Iq61LCkuyfox-yG.5SW' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$aadGraphToken = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://graph.windows.net/.default' -ServicePrincipal -Credential $credential -Tenant 'e09d9473-1a06-4717-98c1-528067eab3a4' -UseAuthorizationCode #Initial Interactive Access Token that contains our initial Refresh Token

$aadGraphToken.RefreshToken #to be passed to step 2 (via azure Key vault) to generate a new access token. we do not care about the access token in step 1 for now although it can be used




Connect-AzureAD -AadAccessToken $aadGraphToken.AccessToken -AccountId 'admin-cci@fgchealth.com' -MsAccessToken $graphToken.AccessToken


#the following does not work as we are not including the tenant ID


# Get-AzureADUser : Error occurred while executing GetUsers 
# Code: Request_BadRequest
# Message: Invalid domain name in the request url.
# RequestId: c68fb66c-c8e6-4e35-90a1-b4b06c64d167
# DateTimeStamp: Sun, 30 May 2021 21:10:39 GMT
# HttpStatusCode: BadRequest
# HttpStatusDescription: Bad Request
# HttpResponseStatus: Completed
# At line:1 char:1
# + Get-AzureADUser
# + ~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (:) [Get-AzureADUser], ApiException
#     + FullyQualifiedErrorId : Microsoft.Open.AzureAD16.Client.ApiException,Microsoft.Open.AzureAD16.PowerS  
#    hell.GetUser

Connect-AzureAD -AadAccessToken $aadGraphToken.AccessToken -AccountId 'admin-abdullah@canadacomputing.ca' -MsAccessToken $graphToken.AccessToken


#The following works fine
Connect-AzureAD -AadAccessToken $aadGraphToken.AccessToken -AccountId 'admin-abdullah@canadacomputing.ca' -MsAccessToken $graphToken.AccessToken -TenantId 'e09d9473-1a06-4717-98c1-528067eab3a4'


#The following works fine
Connect-AzureAD -AadAccessToken $aadGraphToken.AccessToken -AccountId 'admin-cci@fgchealth.com' -MsAccessToken $graphToken.AccessToken
