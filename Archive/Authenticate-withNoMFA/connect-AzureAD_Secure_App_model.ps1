$TenantID_6001 = $null
$TenantID_6001 = "dc3227a4-53ba-48f1-b54b-89936cd5ca53" #Canada Computing AD



$Appcredential_3001 = Get-Credential
$refreshToken_3001 = "0.ARcApCcy3LpT8Ui1S4mTbNXKU8Y2ti7cWr1MhJ4dC2RK1sMXAB8.AgABAAAAAABeStGSRwwnTq2vHplZ9KL4AQDs_wMA9P-CKkftsRp8w9grT6jYTMt9qnAI5zbyp6vyIXKD9gKCw2W_0C_G8BvtXopkd2e2UDM4FFn0xgRvqcA_-HPD3cYEmLOfC6v2iScJkIscFZHkT3qhDbygyb__L09k0mAOdJuKPgT-WfNyqIfGkezVEeaXE7Xza2_RVXmg7qMbKNBweFB8EZxN96mJ7J8owdsX3HdrHbcrKvYdxqwGeRMifSjDnSmp3vCYMK7Dlc3GriKU4Y9uOZyNV3noMTZ3vigTH_ynMQ3ymhDYTFrNVfUsSCcXcDF6dg2GNSIvorxdvPDgDoVdMYVnfrGKXwn6b_gtxVxK5zIlfHOkaKNGOE6aNoFuszRsht1M0wEn08FicGYuwa34NhQB-COWo1KCCR_4w1je9F_oSQUYPkqVpLiGwnUgK3J3Kk2nvSB5BOT4Wcgva_DCNKwucze2vfIYjaItreQmYkuBXsxufFhTvB7l6o9yo3U028K3LS5X2fbxuckhOEv9E5poeniTW26V1NJ4_-EZXTGvCBrRVnpvn0ka-M70CzwsMpu6UUlr-NKdqKrFjW0unMtPRxLX8HkhI5XrUSTtsyoTkgkvAjwGmlXGFfuTZt01Ymq2NuJazBCr00Kpi14D056O09sJZH09wT06SoSI67KRiVPdFifu3bcLTi0Yxp7UFeNezInKHzuccMppjUVD6yRQbQw7L6SDC9Tw_JnK799Vy07J0RnudNzx4MQgSXeinAP0VsXXfg4OHM5MNp_tPLl4HICBpM7cWcLkWKr4kCRH_kE6aARZnHUE6ER8ROx9aA1ikAexrQAh0YwTpZwp-l9WLz0vvPa5ETffeA_HbC26qa6M-6XTqBDibfbuuexuAb0d0yiHsTpJPEkZsBRVmdjOC6Xuc4-gu-gZsug-k9Izr7-2qtWWnw1qzTPrJtybkSKmVN2AN6jQSLKVrMR9E3u1D2NodrOKURsDdJjiRt-s6VXVk0Vkmc3IrAvha3yT-5x8gXsFVQNnSrjYZa0NiSXekvfUxz9Zpt3ZffC4F7EVXFHl7LpyUUfjQGRLjs1TytzReWtN9yNllcsFgJaNOKpbHsvL_OtykRUxEy3A45hP86y3f-XexhzEokDEuWTZQxXx"
# $refreshToken_3001 = "0.ARcApCcy3LpT8Ui1S4mTbNXKU0biMg2kdDBJrz9JcmUtdbsXAB8.AgABAAAAAAB2UyzwtQEKR7-rWbgdcBZIAQDs_wIA9P9pUxrVuXTg2zH4nC-eDuKt76Y8r544qqPu0Jw1DRa6Szg_xUeEDmiDPA64kaWOq8yW4evU8al0GB0h877MvgrTPpMPJMmE5FnOEz2VQNmwMia9uxNmUVwZyAyziJOIiPYH0sji3IBN0T3jRVww39_sylhbomngbZVMlEI3SyjU82UYxte4IIGR8Xvy6E8V7HPkYiVrG92mbJaSwGOaoX3Mjda3IqF4ZtdZrEXV-EhCG3Og78CtaTBBNKAyxhBb_owYceDIFfcV4W3PEZtzFNPQBZOscZrd31ojm8Nbcje-s1pHEZIyDuqba_2rcfJ7P0tGZnb-BGskwoGjhrf8uZEY50EyWiBG4D-E4Bhy4msNL19SHzEqd_WhvyNcCRJbGaI6eFBB7q81F0JQO_TTPoXlgmSeszCyBUyBPp8-R_kpshlZLrgdSVo1aARYdT1tuds635TNZa6IVfeE0f9QssIpb-dSw_kp3TEv5ijzYTEqPIZVHQWKROfZd3sDRaIjRgYDLbS50LiUU-G7xAtx2ATleDzLahpnMTCscIInmLJcE9NyFPixF3yamvTWkcXTAx9Ghn6XhnKsEZA15kjoAzK4s6NDGoL8M8Uaf4mYM_vMB42z1roksREn6GAAJ_5wjOeDSdBAHRaDn1_4BJ_FYX_eoAl8eeoqDejBRLtEOM7HrmtxHV-9aZjmw2C5TjJOUdOKOuZApBQ_p6Do01bhbjSO57ZCo6737sn0fv7zjCFkEKth1yu-JBXKcWqfvAdAAHWHIl4AwIB2XOjjlck6j5Am9YuwC2W9nEyGIqYO-3bGDz0-PmADXzqsr2xguVPrd1jRMyTvWNcocN7XT0KhgQDOJtybwmm4vfZXZzk76aVBPCtDE2LCBl_-CGC097VbNus2EFtZlQTjXhFAHOsxo9JEKm2vgnHv8dd3gtvV5yRZ2iYfqjs0hRtiZX1sjkluqey4rmZNuCrCY-K2o7hkMP_cDuPTik0UuFPBgNN7SJAQYipUp-_KdknxgmeAkhu-iNkIgiDnZ_ZLUj2vFa6giKlxiPKEHhSI1UtflQWhPPn4BZjdKurkIGhkHto7aJ3-IRKq1X_G6fTvvCNNLMxY-9m8LzExrHo82keOXw"


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
#     AadAccessToken = 'eyJ0eXAiOiJKV1QiLCJub25jZSI6InAzeVNMLW5ZcEcyR1lfNmU2VmRFLUhUbTd5TEJrczFpWUNCREhtc0JKY3MiLCJhbGciOiJSUzI1NiIsIng1dCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDcvIiwiaWF0IjoxNjEwMDYzNjA0LCJuYmYiOjE2MTAwNjM2MDQsImV4cCI6MTYxMDE1MDMwNCwiYWlvIjoiRTJKZ1lGaTZhTzdmd3pNY2EzNnR1Q1BCWFZFaURRQT0iLCJhcHBfZGlzcGxheW5hbWUiOiJQU0F1dG9tYXRpb25fTTM2NVNlY3VyZUFwcDEiLCJhcHBpZCI6IjBkMzJlMjQ2LTc0YTQtNDkzMC1hZjNmLTQ5NzI2NTJkNzViYiIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0Ny8iLCJpZHR5cCI6ImFwcCIsInJoIjoiMC5BUm9BdjRqNWN2R0dyMEdScXkxODBCSGJSMGJpTWcya2REQkpyejlKY21VdGRic2FBQUEuIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IldXIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3IiwidXRpIjoiYUEzR3lmM3B5VUNjd0RPNHhvcEdBQSIsInZlciI6IjEuMCIsInhtc190Y2R0IjoxMjg5MjQxNTQ3fQ.FWe3x3rfRW9-NXU2jiEI_pOWJfTPU2_QY0WSUYqRJXIB9YyJFgnqzts9hNg0n0IEDw6BflkTT-bVWcNEfhLsNX71lPh40CuwqsovzanqgzirkJxkZyI-s49dV-kvP3nEzZs1olYuxlRcVkBgfbp2We8iFJx_4I6P11EaXROInELbzOJxDZiZLDt1LwcwURy61roz8RLkfsWVll3bJTxO_Ho60hor_AhippB5KMafq822nO28fJpYkfuCi24Mz6IJzbbNS7MWMp09vV2nSQ2JVPC7zTJ6rxyPFJFpchUtopk46guIh3G114LO8m7MTpgB6N1PeM0ZHOaJtheQ9sJK4g'
#     AccountId = 'Abdullah@canadacomputing.ca'
#     MsAccessToken = 'eyJ0eXAiOiJKV1QiLCJub25jZSI6InAzeVNMLW5ZcEcyR1lfNmU2VmRFLUhUbTd5TEJrczFpWUNCREhtc0JKY3MiLCJhbGciOiJSUzI1NiIsIng1dCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDcvIiwiaWF0IjoxNjEwMDYzNjA0LCJuYmYiOjE2MTAwNjM2MDQsImV4cCI6MTYxMDE1MDMwNCwiYWlvIjoiRTJKZ1lGaTZhTzdmd3pNY2EzNnR1Q1BCWFZFaURRQT0iLCJhcHBfZGlzcGxheW5hbWUiOiJQU0F1dG9tYXRpb25fTTM2NVNlY3VyZUFwcDEiLCJhcHBpZCI6IjBkMzJlMjQ2LTc0YTQtNDkzMC1hZjNmLTQ5NzI2NTJkNzViYiIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0Ny8iLCJpZHR5cCI6ImFwcCIsInJoIjoiMC5BUm9BdjRqNWN2R0dyMEdScXkxODBCSGJSMGJpTWcya2REQkpyejlKY21VdGRic2FBQUEuIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IldXIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3IiwidXRpIjoiYUEzR3lmM3B5VUNjd0RPNHhvcEdBQSIsInZlciI6IjEuMCIsInhtc190Y2R0IjoxMjg5MjQxNTQ3fQ.FWe3x3rfRW9-NXU2jiEI_pOWJfTPU2_QY0WSUYqRJXIB9YyJFgnqzts9hNg0n0IEDw6BflkTT-bVWcNEfhLsNX71lPh40CuwqsovzanqgzirkJxkZyI-s49dV-kvP3nEzZs1olYuxlRcVkBgfbp2We8iFJx_4I6P11EaXROInELbzOJxDZiZLDt1LwcwURy61roz8RLkfsWVll3bJTxO_Ho60hor_AhippB5KMafq822nO28fJpYkfuCi24Mz6IJzbbNS7MWMp09vV2nSQ2JVPC7zTJ6rxyPFJFpchUtopk46guIh3G114LO8m7MTpgB6N1PeM0ZHOaJtheQ9sJK4g'
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