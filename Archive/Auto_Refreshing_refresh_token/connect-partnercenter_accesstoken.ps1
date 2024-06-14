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


# New-SecMgmtAccessToken



$credential = Get-Credential
$Refreshtoken = New-PartnerAccessToken -ApplicationId 'ef10965f-e08c-410a-a7c7-759fde63edd1' -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Credential $credential -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseAuthorizationCode #this requires interaction


$Refreshtoken | Get-Member
$Refreshtoken | Select-Object * | Format-List

$Refreshtoken.RefreshToken #this won't decode in jwt.ms
# 0.ARcApCcy3LpT8Ui1S4mTbNXKU1-WEO-M4ApBp8d1n95j7dEXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_ehYJZ_h-T8nH_4pCBuI-njsHZrsJzIs7EZFur82xzLJD3cp9gi2NVTiPCf9jZUNBTOLeYMnDJxgSD1w-VPzRZkYwEXy3G7U5_PIXzC-Zce0f_eY_mftGD0PPJz091TR30_T8X1cCZzYxdDcTtaVma063oecjZf4e5MvbIZuzyCqVuJjpViGi7TZAGT9q1QFm4bJR5H4Rl8WSOYOzPBGw28SLoE0iwcIyH9viCL0Kz5iKWsG3zqObWCEGinlafXvRwnLeEK3nRWEBED-IkfV7H_w8ny4vAFadC2NsM-m9ZjNXc44Cb2-Rp1OdM7FyoL402D54GfqCcIEQu0e3Rtvc0onPanms7tKH8_XMSEz6FhtfrlARIgAia2XiesWXq70FxY3vKqFJKDh8GXN_ZE37tm5q_Vle1rtryvRv2ZNiHPTO3cxr8SX0GtRtQHFBxx-c4kmGWQsIpo3BsWRJEAbMu8Wh57Obq51V4eHiEa3nso402u392LK8xJX2h6moRuLy8tFXMxKkfybI-vM5L2jsulX0rwaAiB-7p2vnaIANkyw7yLuPqC24S3d7WolXShGr5MN1TKXOkqzj-Z3VdVV_401JqkjHEN3hsrs8-REjedHTY8Ehg2Q6TizAkvM-kJczUtWniD0jWFDwCS4GV1v6BJlGomyM9XJo_k1yN-9OQfM23J4bEkKMAgVedBfCXD2byeQG-AAq07aWuZtyFbIsGEvaep21_yg56rVRoBCLLvN2DGWDUIOGtYmOb3gCWgdhbwx0usXCJB3X2g2Yp5JspT-RWRiiDppX9sP9V4Ck_Nn6b3pREOzzoJ1aG6Ky7eXx-5nNjUy5C7QcG2x7hoce-LIlAO1ax3CQR-dqPspzknR02-ND8sNWiLUFC8Lrwd3QVmMGlJe2rhjJkxSL6v0YzkUVg6-d9cWr7ryrBDmkVUzFcRdM62vyAvhtQFELVhPGbKp-dJ9DTS7DG1Z-K8DrtB1pyNwjKGNecJbNA5reTIk1KaSIqsFHC9rde1_VxEm_WfjPdb76aLL_uBWMxPtXnoSEqkY93zQA19tYm3HScCVq2MinzbwM



$Refreshtoken.AccessToken #this will decode in jwt.ms
# eyJ0eXAiOiJKV1QiLCJub25jZSI6IllpS1hsM2JMa1Bndmc4MDRrN3hFWWdIOTBmWTFDZlV1OTdnRUdoRF9PMUkiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kYzMyMjdhNC01M2JhLTQ4ZjEtYjU0Yi04OTkzNmNkNWNhNTMvIiwiaWF0IjoxNjIwMDUwNDExLCJuYmYiOjE2MjAwNTA0MTEsImV4cCI6MTYyMDA1NDMxMSwiYWNjdCI6MCwiYWNyIjoiMSIsImFjcnMiOlsidXJuOnVzZXI6cmVnaXN0ZXJzZWN1cml0eWluZm8iLCJ1cm46bWljcm9zb2Z0OnJlcTEiLCJ1cm46bWljcm9zb2Z0OnJlcTIiLCJ1cm46bWljcm9zb2Z0OnJlcTMiLCJjMSIsImMyIiwiYzMiLCJjNCIsImM1IiwiYzYiLCJjNyIsImM4IiwiYzkiLCJjMTAiLCJjMTEiLCJjMTIiLCJjMTMiLCJjMTQiLCJjMTUiLCJjMTYiLCJjMTciLCJjMTgiLCJjMTkiLCJjMjAiLCJjMjEiLCJjMjIiLCJjMjMiLCJjMjQiLCJjMjUiXSwiYWlvIjoiQVVRQXUvOFRBQUFBRWtaNnY3S0djTFdhMWgzUXU0VzR3OUJzbStiSVBYMTJDYkIrNVBVNlgzZDE1NG1ueDFvek1SMnFWeExxUUxEc2YxUmtLN3dqU21RTnI2cDB5d3cwd2c9PSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiQ0NJX1BTQXV0b21hdGlvbl9NMzY1U2VjdXJlQXBwXzEiLCJhcHBpZCI6ImVmMTA5NjVmLWUwOGMtNDEwYS1hN2M3LTc1OWZkZTYzZWRkMSIsImFwcGlkYWNyIjoiMSIsImlkdHlwIjoidXNlciIsImlwYWRkciI6IjUwLjcxLjE1NS4xMTgiLCJuYW1lIjoiQWRtaW4tQWJkdWxsYWgiLCJvaWQiOiIwMTYxYmQ3OC0xMjI0LTQ0MjEtODRmNC1jYWNiNzIzZmJiMTEiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDExMzZDMDNFMSIsInJoIjoiMC5BUmNBcENjeTNMcFQ4VWkxUzRtVGJOWEtVMS1XRU8tTTRBcEJwOGQxbjk1ajdkRVhBTDQuIiwic2NwIjoicHJvZmlsZSBvcGVuaWQgZW1haWwiLCJzaWduaW5fc3RhdGUiOlsia21zaSJdLCJzdWIiOiItUHJYbXJTQko0NDVDc0VPWkVHSllWS2NOUzdUUW9kS3RzSTh3Q0ZDdENzIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6Ik5BIiwidGlkIjoiZGMzMjI3YTQtNTNiYS00OGYxLWI1NGItODk5MzZjZDVjYTUzIiwidW5pcXVlX25hbWUiOiJBZG1pbi1BYmR1bGxhaEBjYW5hZGFjb21wdXRpbmcuY2EiLCJ1cG4iOiJBZG1pbi1BYmR1bGxhaEBjYW5hZGFjb21wdXRpbmcuY2EiLCJ1dGkiOiJkTVQ5azBfcktFS21yZzlMZUprQUFnIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6IjVEZjNWbEx3SjFfVWE3eVdSVTdWYXpCQnZZQzdKNnNtMk52Z1V5N0RDaW8ifSwieG1zX3RjZHQiOjE0NjI1NTUxNjh9.Q0-_wBr0a7bwpMYJEoKmDRVslP50zLGVfBj5G-ei_8BNQ3RkIxeWjp0hqDY-bDgJwxeVtFoGv8wnlk6U8hUxIsBvYLI5WO7wqWU-R_M0d5zA-l5CYOZdF9ErmkWiYmh-XIHMXeVdix3t1MjmbREPksLd7eIbmK-OSBjSG694SuCueALo-yxBrn_JVMgT4z5P5eVv6fT6rsF9WNCwmkmUncT5rNmn0h_OMCat-s__vwPsPRzE5Kh3QLxeiVZ__rBGCjWr7zqzCvURyQuLbhTPcOHIjHRSVlaLg0Ka69bhRggePr2GLsZnbkok35APSYBenn1pEkgJeOT4Lmp5Y20CJA

$Refreshtoken.ExpiresOn



# DateTime      : 5/3/2021 3:05:11 PM
# UtcDateTime   : 5/3/2021 3:05:11 PM
# LocalDateTime : 5/3/2021 10:05:11 AM
# Date          : 5/3/2021 12:00:00 AM
# Day           : 3
# DayOfWeek     : Monday
# DayOfYear     : 123
# Hour          : 15
# Millisecond   : 0
# Minute        : 5
# Month         : 5
# Offset        : 00:00:00
# Second        : 11
# Ticks         : 637556511110000000
# UtcTicks      : 637556511110000000
# TimeOfDay     : 15:05:11
# Year          : 2021


$AccessToken = 'eyJ0eXAiOiJKV1QiLCJub25jZSI6Ikx2VExxeldHUGM4SFh3b3dRTUd4RUtaQk92eUwzWE90Y2c5STFFZmFwekUiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kYzMyMjdhNC01M2JhLTQ4ZjEtYjU0Yi04OTkzNmNkNWNhNTMvIiwiaWF0IjoxNjIwMDYyODA1LCJuYmYiOjE2MjAwNjI4MDUsImV4cCI6MTYyMDA2NjcwNSwiYWNjdCI6MCwiYWNyIjoiMSIsImFjcnMiOlsidXJuOnVzZXI6cmVnaXN0ZXJzZWN1cml0eWluZm8iLCJ1cm46bWljcm9zb2Z0OnJlcTEiLCJ1cm46bWljcm9zb2Z0OnJlcTIiLCJ1cm46bWljcm9zb2Z0OnJlcTMiLCJjMSIsImMyIiwiYzMiLCJjNCIsImM1IiwiYzYiLCJjNyIsImM4IiwiYzkiLCJjMTAiLCJjMTEiLCJjMTIiLCJjMTMiLCJjMTQiLCJjMTUiLCJjMTYiLCJjMTciLCJjMTgiLCJjMTkiLCJjMjAiLCJjMjEiLCJjMjIiLCJjMjMiLCJjMjQiLCJjMjUiXSwiYWlvIjoiQVNRQTIvOFRBQUFBZm80ZWZvV1ZxNHRtNHZnVENIWk54TDdoSDZ3ZDRLcmp6VzVMeEhEeDVCQT0iLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6IkNDSV9QU0F1dG9tYXRpb25fTTM2NVNlY3VyZUFwcF8xIiwiYXBwaWQiOiJlZjEwOTY1Zi1lMDhjLTQxMGEtYTdjNy03NTlmZGU2M2VkZDEiLCJhcHBpZGFjciI6IjEiLCJpZHR5cCI6InVzZXIiLCJpcGFkZHIiOiIyMDguODEuNC45OCIsIm5hbWUiOiJBZG1pbi1BYmR1bGxhaCIsIm9pZCI6IjAxNjFiZDc4LTEyMjQtNDQyMS04NGY0LWNhY2I3MjNmYmIxMSIsInBsYXRmIjoiMyIsInB1aWQiOiIxMDAzMjAwMTEzNkMwM0UxIiwicmgiOiIwLkFSY0FwQ2N5M0xwVDhVaTFTNG1UYk5YS1UxLVdFTy1NNEFwQnA4ZDFuOTVqN2RFWEFMNC4iLCJzY3AiOiJwcm9maWxlIG9wZW5pZCBlbWFpbCIsInNpZ25pbl9zdGF0ZSI6WyJpbmtub3dubnR3ayJdLCJzdWIiOiItUHJYbXJTQko0NDVDc0VPWkVHSllWS2NOUzdUUW9kS3RzSTh3Q0ZDdENzIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6Ik5BIiwidGlkIjoiZGMzMjI3YTQtNTNiYS00OGYxLWI1NGItODk5MzZjZDVjYTUzIiwidW5pcXVlX25hbWUiOiJBZG1pbi1BYmR1bGxhaEBjYW5hZGFjb21wdXRpbmcuY2EiLCJ1cG4iOiJBZG1pbi1BYmR1bGxhaEBjYW5hZGFjb21wdXRpbmcuY2EiLCJ1dGkiOiJsdW1CMWpITDNraXJIMWlKd21QMUFRIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6IjVEZjNWbEx3SjFfVWE3eVdSVTdWYXpCQnZZQzdKNnNtMk52Z1V5N0RDaW8ifSwieG1zX3RjZHQiOjE0NjI1NTUxNjh9.bC4_xuADF2IhyowOMPYRI59mNwPQ-nuzIrzEOuRtFVvCQqRP88X8setfSWu0pIoU4UA_s64pMxMOdrwSnuDmAMo2SBC4jSXOvoe5bF6V8i0trxLG9otUc82OpF3SyfeQXapgd3oZfSCol7JpspE_ZW1RO_KLdAfshnnY_sCfpC6rT9HBB8zzcBheL5wFUoidkvTBAxhPQi3OQcQ5ZNwJ4Ryc_mAyKSog-UEMbWKcewCWjf0NHnWpLIbqDA2LIPqm5m-YbEv897AJEbfl0PUA6gIqmC1jSQpT9fxo-LhI4jaXmG6MRUvYhkpxTDeQzI4uP_41BqIpOQEqf3I22oQgIA'
Connect-PartnerCenter -AccessToken $AccessToken




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer

#the command above does not meet our needs because it requires interaction due to UseAuthorizationCode param . The command above issues an access token (which comes as the next step after a refresh token and expires in one hour based on GMT -5 which i CST -6)





$credential = Get-Credential
$refreshToken = '0.ARcApCcy3LpT8Ui1S4mTbNXKU1-WEO-M4ApBp8d1n95j7dEXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_ehYJZ_h-T8nH_4pCBuI-njsHZrsJzIs7EZFur82xzLJD3cp9gi2NVTiPCf9jZUNBTOLeYMnDJxgSD1w-VPzRZkYwEXy3G7U5_PIXzC-Zce0f_eY_mftGD0PPJz091TR30_T8X1cCZzYxdDcTtaVma063oecjZf4e5MvbIZuzyCqVuJjpViGi7TZAGT9q1QFm4bJR5H4Rl8WSOYOzPBGw28SLoE0iwcIyH9viCL0Kz5iKWsG3zqObWCEGinlafXvRwnLeEK3nRWEBED-IkfV7H_w8ny4vAFadC2NsM-m9ZjNXc44Cb2-Rp1OdM7FyoL402D54GfqCcIEQu0e3Rtvc0onPanms7tKH8_XMSEz6FhtfrlARIgAia2XiesWXq70FxY3vKqFJKDh8GXN_ZE37tm5q_Vle1rtryvRv2ZNiHPTO3cxr8SX0GtRtQHFBxx-c4kmGWQsIpo3BsWRJEAbMu8Wh57Obq51V4eHiEa3nso402u392LK8xJX2h6moRuLy8tFXMxKkfybI-vM5L2jsulX0rwaAiB-7p2vnaIANkyw7yLuPqC24S3d7WolXShGr5MN1TKXOkqzj-Z3VdVV_401JqkjHEN3hsrs8-REjedHTY8Ehg2Q6TizAkvM-kJczUtWniD0jWFDwCS4GV1v6BJlGomyM9XJo_k1yN-9OQfM23J4bEkKMAgVedBfCXD2byeQG-AAq07aWuZtyFbIsGEvaep21_yg56rVRoBCLLvN2DGWDUIOGtYmOb3gCWgdhbwx0usXCJB3X2g2Yp5JspT-RWRiiDppX9sP9V4Ck_Nn6b3pREOzzoJ1aG6Ky7eXx-5nNjUy5C7QcG2x7hoce-LIlAO1ax3CQR-dqPspzknR02-ND8sNWiLUFC8Lrwd3QVmMGlJe2rhjJkxSL6v0YzkUVg6-d9cWr7ryrBDmkVUzFcRdM62vyAvhtQFELVhPGbKp-dJ9DTS7DG1Z-K8DrtB1pyNwjKGNecJbNA5reTIk1KaSIqsFHC9rde1_VxEm_WfjPdb76aLL_uBWMxPtXnoSEqkY93zQA19tYm3HScCVq2MinzbwM'

New-PartnerAccessToken -ApplicationId 'ef10965f-e08c-410a-a7c7-759fde63edd1' -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'

#The command above does not work and returns the following error as it does not launch an interactive browser session to allow the user to interactively select the global admin account
# New-PartnerAccessToken : AADSTS65001: The user or administrator has not consented to use the application with ID 'ef10965f-e08c-410a-a7c7-759fde63edd1' named 'CCI_PSAutomation_M365SecureApp_1'. Send an interactive 
# authorization request for this user and resource.
# Trace ID: 4a7ff2ef-e582-4980-91a3-46818161c700
# Correlation ID: d07f2565-1222-4dc5-97ab-df1d0fea0623
# Timestamp: 2021-05-03 14:18:37Z
# At line:4 char:1
# + New-PartnerAccessToken -ApplicationId 'ef10965f-e08c-410a-a7c7-759fde ...
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : CloseError: (:) [New-PartnerAccessToken], MsalUiRequiredException
#     + FullyQualifiedErrorId : Microsoft.Store.PartnerCenter.PowerShell.Commands.NewPartnerAccessToken




$credential = Get-Credential
$refreshToken = '0.ARcApCcy3LpT8Ui1S4mTbNXKU1-WEO-M4ApBp8d1n95j7dEXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_ehYJZ_h-T8nH_4pCBuI-njsHZrsJzIs7EZFur82xzLJD3cp9gi2NVTiPCf9jZUNBTOLeYMnDJxgSD1w-VPzRZkYwEXy3G7U5_PIXzC-Zce0f_eY_mftGD0PPJz091TR30_T8X1cCZzYxdDcTtaVma063oecjZf4e5MvbIZuzyCqVuJjpViGi7TZAGT9q1QFm4bJR5H4Rl8WSOYOzPBGw28SLoE0iwcIyH9viCL0Kz5iKWsG3zqObWCEGinlafXvRwnLeEK3nRWEBED-IkfV7H_w8ny4vAFadC2NsM-m9ZjNXc44Cb2-Rp1OdM7FyoL402D54GfqCcIEQu0e3Rtvc0onPanms7tKH8_XMSEz6FhtfrlARIgAia2XiesWXq70FxY3vKqFJKDh8GXN_ZE37tm5q_Vle1rtryvRv2ZNiHPTO3cxr8SX0GtRtQHFBxx-c4kmGWQsIpo3BsWRJEAbMu8Wh57Obq51V4eHiEa3nso402u392LK8xJX2h6moRuLy8tFXMxKkfybI-vM5L2jsulX0rwaAiB-7p2vnaIANkyw7yLuPqC24S3d7WolXShGr5MN1TKXOkqzj-Z3VdVV_401JqkjHEN3hsrs8-REjedHTY8Ehg2Q6TizAkvM-kJczUtWniD0jWFDwCS4GV1v6BJlGomyM9XJo_k1yN-9OQfM23J4bEkKMAgVedBfCXD2byeQG-AAq07aWuZtyFbIsGEvaep21_yg56rVRoBCLLvN2DGWDUIOGtYmOb3gCWgdhbwx0usXCJB3X2g2Yp5JspT-RWRiiDppX9sP9V4Ck_Nn6b3pREOzzoJ1aG6Ky7eXx-5nNjUy5C7QcG2x7hoce-LIlAO1ax3CQR-dqPspzknR02-ND8sNWiLUFC8Lrwd3QVmMGlJe2rhjJkxSL6v0YzkUVg6-d9cWr7ryrBDmkVUzFcRdM62vyAvhtQFELVhPGbKp-dJ9DTS7DG1Z-K8DrtB1pyNwjKGNecJbNA5reTIk1KaSIqsFHC9rde1_VxEm_WfjPdb76aLL_uBWMxPtXnoSEqkY93zQA19tYm3HScCVq2MinzbwM'

New-PartnerAccessToken -ApplicationId 'ef10965f-e08c-410a-a7c7-759fde63edd1' -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseDeviceAuthentication


#The command above does not work (although it is not officially documented I tried using the UseDeviceAuthentication param) and returns the following error
# New-PartnerAccessToken : Parameter set cannot be resolved using the specified named parameters.
# At line:4 char:1
# + New-PartnerAccessToken -ApplicationId 'ef10965f-e08c-410a-a7c7-759fde ...
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : InvalidArgument: (:) [New-PartnerAccessToken], ParameterBindingException
#     + FullyQualifiedErrorId : AmbiguousParameterSet,Microsoft.Store.PartnerCenter.PowerShell.Commands.NewPartnerAccessToken















    <#
This snippet assumes a valid refresh token.  To see how to get one of those, check out:
https://www.thelazyadministrator.com/2019/07/22/connect-and-navigate-the-microsoft-graph-api-with-powershell/#3_Authentication_and_Authorization_Different_Methods_to_Connect
#>

$clientId           = "1950a258-227b-4e31-a9cf-717495945fc2"  # This is the standard client ID for Windows Azure PowerShell
$redirectUrl        = [System.Uri]"urn:ietf:wg:oauth:2.0:oob" # This is the standard Redirect URI for Windows Azure PowerShell
$tenant             = "CanadaComputing.onmicrosoft.com"             # TODO - your tenant name goes here
$resource           = "https://graph.microsoft.com/";
$serviceRootURL     = "https://graph.microsoft.com//$tenant"
$authUrl            = "https://login.microsoftonline.com/$tenant";
$postParams         = @{ resource = "$resource"; client_id = "$clientId" }

$response = Invoke-RestMethod -Method POST -Uri "$authurl/oauth2/devicecode" -Body $postParams
Write-Host $response.message
#I got tired of manually copying the code, so I did string manipulation and stored the code in a variable and added to the clipboard automatically
$code = ($response.message -split "code " | Select-Object -Last 1) -split " to authenticate."
Set-Clipboard -Value $code
Start-Process "https://microsoft.com/devicelogin" # must complete before the rest of the snippet will work

# Get the initial token
$tokenParams = @{ 
    grant_type  = "device_code"
    resource    = $resource
    client_id   = $clientId
    code        = $response.device_code 
}
$tokenResponse = Invoke-RestMethod -Method POST -Uri "$authurl/oauth2/token" -Body $tokenParams

# Use the Refresh Token
$refreshToken = $tokenResponse.refresh_token
$refreshTokenParams = @{ 
    grant_type = "refresh_token"
    client_id = "$clientId"
    refresh_token = $refreshToken
}
$tokenResponse = Invoke-RestMethod -Method POST -Uri "$authurl/oauth2/token" -Body $refreshTokenParams



#the snippet of code above does not work as it launches a web browser and it fails right away and returns the following error
# To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ECYAN6ZFU to authenticate.
# Invoke-RestMethod : {"error":"authorization_pending","error_description":"AADSTS70016: OAuth 2.0 device flow error. Authorization is pending. Continue polling.\r\nTrace ID: 
# 5810b037-c97b-48b8-95c3-fa5e39754302\r\nCorrelation ID: 543970af-30fa-446a-b99f-946c4360a36e\r\nTimestamp: 2021-05-03 15:01:36Z","error_codes":[70016],"timestamp":"2021-05-03 
# 15:01:36Z","trace_id":"5810b037-c97b-48b8-95c3-fa5e39754302","correlation_id":"543970af-30fa-446a-b99f-946c4360a36e","error_uri":"https://login.microsoftonline.com/error?code=70016"}
# At line:28 char:18
# + ... nResponse = Invoke-RestMethod -Method POST -Uri "$authurl/oauth2/toke ...
# +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
#     + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand
# Invoke-RestMethod : {"error":"invalid_request","error_description":"AADSTS900144: The request body must contain the following parameter: 'refresh_token'.\r\nTrace ID: 
# 6fe07573-b479-4398-86f5-6129a719f400\r\nCorrelation ID: 83830b31-8a69-4158-8538-b91e492daf04\r\nTimestamp: 2021-05-03 15:01:36Z","error_codes":[900144],"timestamp":"2021-05-03 
# 15:01:36Z","trace_id":"6fe07573-b479-4398-86f5-6129a719f400","correlation_id":"83830b31-8a69-4158-8538-b91e492daf04","error_uri":"https://login.microsoftonline.com/error?code=900144"}
# At line:37 char:18
# + ... nResponse = Invoke-RestMethod -Method POST -Uri "$authurl/oauth2/toke ...
# +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
#     + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand








function RefreshAccessToken{
    <#
    .SYNOPSIS
    Refreshes an access token based on refresh token

    .RETURNS
    Returns a refreshed access token
    
    .PARAMETER Token
    -Token is the existing refresh token

    .PARAMETER tenantID
    -This is the tenant ID eg. domain.onmicrosoft.com

    .PARAMETER ClientID
    -This is the app reg client ID

    .PARAMETER Secret
    -This is the client secret

    .PARAMETER Scope
    -A comma delimited list of access scope, default is: "Group.ReadWrite.All,User.ReadWrite.All"
    
    #>
    Param(
        [parameter(Mandatory = $true)]
        [String]
        $Token,
        [parameter(Mandatory = $true)]
        [String]
        $tenantID,
        [parameter(Mandatory = $true)]
        [String]
        $ClientID,
        [parameter(Mandatory = $false)]
        [String]
        $Scope = "Group.ReadWrite.All,User.ReadWrite.All",
        [parameter(Mandatory = $true)]
        [String]
        $Secret
    )

$ScopeFixup = $Scope.replace(',','%20')
$apiUri = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token"
$body = "client_id=$ClientID&scope=$ScopeFixup&refresh_token=$Token&redirect_uri=http%3A%2F%2Flocalhost%2F&grant_type=refresh_token&client_secret=$Secret"
write-verbose $body -Verbose
$Refreshedtoken = (Invoke-RestMethod -Uri $apiUri -Method Post -ContentType 'application/x-www-form-urlencoded' -body $body  )

return $Refreshedtoken

}


# $Secret = 'e0FHNRgwQ1Wh3JDuCc9FP/22Kuj+WwccpH5bTlg5344='

$refreshToken = '0.ARcApCcy3LpT8Ui1S4mTbNXKU1-WEO-M4ApBp8d1n95j7dEXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_ehYJZ_h-T8nH_4pCBuI-njsHZrsJzIs7EZFur82xzLJD3cp9gi2NVTiPCf9jZUNBTOLeYMnDJxgSD1w-VPzRZkYwEXy3G7U5_PIXzC-Zce0f_eY_mftGD0PPJz091TR30_T8X1cCZzYxdDcTtaVma063oecjZf4e5MvbIZuzyCqVuJjpViGi7TZAGT9q1QFm4bJR5H4Rl8WSOYOzPBGw28SLoE0iwcIyH9viCL0Kz5iKWsG3zqObWCEGinlafXvRwnLeEK3nRWEBED-IkfV7H_w8ny4vAFadC2NsM-m9ZjNXc44Cb2-Rp1OdM7FyoL402D54GfqCcIEQu0e3Rtvc0onPanms7tKH8_XMSEz6FhtfrlARIgAia2XiesWXq70FxY3vKqFJKDh8GXN_ZE37tm5q_Vle1rtryvRv2ZNiHPTO3cxr8SX0GtRtQHFBxx-c4kmGWQsIpo3BsWRJEAbMu8Wh57Obq51V4eHiEa3nso402u392LK8xJX2h6moRuLy8tFXMxKkfybI-vM5L2jsulX0rwaAiB-7p2vnaIANkyw7yLuPqC24S3d7WolXShGr5MN1TKXOkqzj-Z3VdVV_401JqkjHEN3hsrs8-REjedHTY8Ehg2Q6TizAkvM-kJczUtWniD0jWFDwCS4GV1v6BJlGomyM9XJo_k1yN-9OQfM23J4bEkKMAgVedBfCXD2byeQG-AAq07aWuZtyFbIsGEvaep21_yg56rVRoBCLLvN2DGWDUIOGtYmOb3gCWgdhbwx0usXCJB3X2g2Yp5JspT-RWRiiDppX9sP9V4Ck_Nn6b3pREOzzoJ1aG6Ky7eXx-5nNjUy5C7QcG2x7hoce-LIlAO1ax3CQR-dqPspzknR02-ND8sNWiLUFC8Lrwd3QVmMGlJe2rhjJkxSL6v0YzkUVg6-d9cWr7ryrBDmkVUzFcRdM62vyAvhtQFELVhPGbKp-dJ9DTS7DG1Z-K8DrtB1pyNwjKGNecJbNA5reTIk1KaSIqsFHC9rde1_VxEm_WfjPdb76aLL_uBWMxPtXnoSEqkY93zQA19tYm3HScCVq2MinzbwM'

RefreshAccessToken -ClientID 'ef10965f-e08c-410a-a7c7-759fde63edd1' -Token $refreshToken -tenantID 'canadacomputing.onmicrosoft.com' -Secret 'e0FHNRgwQ1Wh3JDuCc9FP/22Kuj+WwccpH5bTlg5344='



#the code snipper/function above does not work and returns the following error
# VERBOSE: client_id=ef10965f-e08c-410a-a7c7-759fde63edd1&scope=Group.ReadWrite.All%20User.ReadWrite.All&refresh_token=0.ARcApCcy3LpT8Ui1S4mTbNXKU1-WEO-M4ApBp8d1n95j7dEXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_ehYJZ_h-T8nH_4pCBuI-njsHZrsJzIs7EZFur82xzLJD3cp9gi2NVTiPCf9jZUNBTOLeYMnDJxgSD1w-VPzRZkYwEXy3G7U5_PIXzC-Zce0f_eY_mftGD0PPJz091TR30_T8X1cCZzYxdDcTtaVma063oecjZf4e5MvbIZuzyCqVuJjpViGi7TZAGT9q1QFm4bJR5H4Rl8WSOYOzPBGw28SLoE0iwcIyH9viCL0Kz5iKWsG3zqObWCEGinlafXvRwnLeEK3nRWEBED-IkfV7H_w8ny4vAFadC2NsM-m9ZjNXc44Cb2-Rp1OdM7FyoL402D54GfqCcIEQu0e3Rtvc0onPanms7tKH8_XMSEz6FhtfrlARIgAia2XiesWXq70FxY3vKqFJKDh8GXN_ZE37tm5q_Vle1rtryvRv2ZNiHPTO3cxr8SX0GtRtQHFBxx-c4kmGWQsIpo3BsWRJEAbMu8Wh57Obq51V4eHiEa3nso402u392LK8xJX2h6moRuLy8tFXMxKkfybI-vM5L2jsulX0rwaAiB-7p2vnaIANkyw7yLuPqC24S3d7WolXShGr5MN1TKXOkqzj-Z3VdVV_401JqkjHEN3hsrs8-REjedHTY8Ehg2Q6TizAkvM-kJczUtWniD0jWFDwCS4GV1v6BJlGomyM9XJo_k1yN-9OQfM23J4bEkKMAgVedBfCXD2byeQG-AAq07aWuZtyFbIsGEvaep21_yg56rVRoBCLLvN2DGWDUIOGtYmOb3gCWgdhbwx0usXCJB3X2g2Yp5JspT-RWRiiDppX9sP9V4Ck_Nn6b3pREOzzoJ1aG6Ky7eXx-5nNjUy5C7QcG2x7hoce-LIlAO1ax3CQR-dqPspzknR02-ND8sNWiLUFC8Lrwd3QVmMGlJe2rhjJkxSL6v0YzkUVg6-d9cWr7ryrBDmkVUzFcRdM62vyAvhtQFELVhPGbKp-dJ9DTS7DG1Z-K8DrtB1pyNwjKGNecJbNA5reTIk1KaSIqsFHC9rde1_VxEm_WfjPdb76aLL_uBWMxPtXnoSEqkY93zQA19tYm3HScCVq2MinzbwM&redirect_uri=http%3A%2F%2Flocalhost%2F&grant_type=refresh_token&client_secret=e0FHNRgwQ1Wh3JDuCc9FP/22Kuj+WwccpH5bTlg5344=
# Invoke-RestMethod : {"error":"invalid_client","error_description":"AADSTS7000215: Invalid client secret is provided.\r\nTrace ID: ea0faae7-6607-4e11-89bc-903662f80a02\r\nCorrelation ID: 
# 3dfc122e-08f4-480b-ac1c-969bae77be3c\r\nTimestamp: 2021-05-03 15:17:57Z","error_codes":[7000215],"timestamp":"2021-05-03 
# 15:17:57Z","trace_id":"ea0faae7-6607-4e11-89bc-903662f80a02","correlation_id":"3dfc122e-08f4-480b-ac1c-969bae77be3c","error_uri":"https://login.microsoftonline.com/error?code=7000215"}
# At line:47 char:20
# + ... hedtoken = (Invoke-RestMethod -Uri $apiUri -Method Post -ContentType  ...
# +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
#     + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand




$tenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
# Create a hashtable for the body, the data needed for the token request
# The variables used are explained above
$Body = @{
    # 'tenant' = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
    'tenant' = $tenantID
    'client_id' = '699c6660-9dd9-4e62-a42f-4091d9ef3966' #Native App
    'scope' = 'https://reseller.microsoft.com/.default'
    'client_secret' = 'zu3AO0CCc-P_.6oO~0okGLZ9JH_Z1woUUQ'
    'grant_type' = 'client_credentials'
}

# Assemble a hashtable for splatting parameters, for readability
# The tenant id is used in the uri of the request as well as the body
$Params = @{
    'Uri' = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params
$AuthResponse.access_token



$AccessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL3Jlc2VsbGVyLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kYzMyMjdhNC01M2JhLTQ4ZjEtYjU0Yi04OTkzNmNkNWNhNTMvIiwiaWF0IjoxNjIwMDU5MTUzLCJuYmYiOjE2MjAwNTkxNTMsImV4cCI6MTYyMDA2MzA1MywiYWlvIjoiRTJaZ1lKamNJbkxOZVYwNCs2NUk5L3NNYlplM0F3QT0iLCJhcHBpZCI6IjgyYmMzZTFiLWVkNzctNDc2YS04NzIzLTYyM2E3NDdmODczOSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2RjMzIyN2E0LTUzYmEtNDhmMS1iNTRiLTg5OTM2Y2Q1Y2E1My8iLCJvaWQiOiJkYTZlMDQyNi00OWM4LTQ5ZDMtYjBmMy0yOTI1NDZlYjJiMjgiLCJyaCI6IjAuQVJjQXBDY3kzTHBUOFVpMVM0bVRiTlhLVXhzLXZJSjM3V3BIaHlOaU9uUl9oemtYQUFBLiIsInN1YiI6ImRhNmUwNDI2LTQ5YzgtNDlkMy1iMGYzLTI5MjU0NmViMmIyOCIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJOQSIsInRpZCI6ImRjMzIyN2E0LTUzYmEtNDhmMS1iNTRiLTg5OTM2Y2Q1Y2E1MyIsInV0aSI6IjRwUHBCNjFJemtxSEhheThRNjNTQUEiLCJ2ZXIiOiIxLjAifQ.k-hP3ZO9sIgoy_9Bx-zEurxNxn9UShZVuS5avIhTr-RMeZZkrCA9eIeluX5L-cHJrPgCNJFj1iTNLBjbJgYxXY51dBkNz1L4n26RiUgB7um9jWOqMVKn6w3MDhJx0Blkzdi26sscdb4U4yNzatU8G2TETWv02nF1q3K4RdlYkVq7MlYUD_Nh9r3SEgWK01fbcjOGoUJkoQ8egFWF1VY5Szmb73ZA-iEV8Yda6_Qad7AzBcZ3YtDFaEh27L0HwCUt-ITLJjdnc7aHqdIAK9gn7ojfvHIrHHtjeC7RnuyktWGha66QQK30zEz3qj80CJzvC22lTFc3rvmnevKdCpb18A'
Connect-PartnerCenter -AccessToken $AccessToken




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer



#the above snippet does not work even though I am supplying the Web app NOT the native app (the web app was created from the Partner Dashboard app management section. It does generate an access token wihout interaction and without a refresh token but it returns the following error when using the Get-PartnerCustomer cmdlet
# Get-PartnerCustomer :  (invalid_grant)
# At line:5 char:13
# + $customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# +             ~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : CloseError: (:) [Get-PartnerCustomer], PartnerException
#     + FullyQualifiedErrorId : Microsoft.Store.PartnerCenter.PowerShell.Commands.GetPartnerCustomer










Install-Module -Name MSAL.PS -Scope CurrentUser


$connectionDetails = @{
    'TenantId'    = 'canadacomputing.ca'
    'ClientId'    = 'ef10965f-e08c-410a-a7c7-759fde63edd1'
    'Interactive' = $true
}

$token = Get-MsalToken @connectionDetails


#The above code is for interactive and it pops up a window to login (not a browser) but it returns the following error

# Sorry, but we’re having trouble signing you in.
# AADSTS50011: The reply URL specified in the request does not match the reply URLs configured for the application: 'ef10965f-e08c-410a-a7c7-759fde63edd1'. 
# Troubleshooting details
# If you contact your administrator, send this info to them.
# Copy info to clipboard   
# Request Id:  55b61f64-7894-4f06-990b-03cd86a50401 
# Correlation Id:  d5860fee-7020-484d-810d-988e160db2a7 
# Timestamp:  2021-05-03T16:51:43Z 
# Message:  AADSTS50011: The reply URL specified in the request does not match the reply URLs configured for the application: 'ef10965f-e08c-410a-a7c7-759fde63edd1'.  
# Flag sign-in errors for review: Enable flagging 
# If you plan on getting help for this problem, enable flagging and try to reproduce the error within 20 minutes. Flagged events make diagnostics available and are raised to admin attention.


#and then followed by the error

# Get-MsalToken : User canceled authentication.
# At line:7 char:10
# + $token = Get-MsalToken @connectionDetails
# +          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : AuthenticationError: (Microsoft.Ident...arameterBuilder:AcquireTokenInteractiveParameterBuilder) [Write-Error], MsalClientException
#     + FullyQualifiedErrorId : GetMsalTokenFailureAuthenticationError,Get-MsalToken













$connectionDetails = @{
    'TenantId'    = 'canadacomputing.onmicrosoft.com'
    'ClientId'    = '82bc3e1b-ed77-476a-8723-623a747f8739'
    'ClientSecret' = 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' | ConvertTo-SecureString -AsPlainText -Force
}

$AccessToken = Get-MsalToken @connectionDetails


$AccessToken.AccessToken



$AccessToken = 'eyJ0eXAiOiJKV1QiLCJub25jZSI6Il9xY1BWTXA5UE5qTHp5YUhIZkl0OFNpNEthZVF1VHFsLUVpTDBEc3RCRkkiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kYzMyMjdhNC01M2JhLTQ4ZjEtYjU0Yi04OTkzNmNkNWNhNTMvIiwiaWF0IjoxNjIwMDYwOTU4LCJuYmYiOjE2MjAwNjA5NTgsImV4cCI6MTYyMDA2NDg1OCwiYWlvIjoiRTJaZ1lEQTJMbTArR2FuT1Z6emI4UDNwUFJQZUFRQT0iLCJhcHBfZGlzcGxheW5hbWUiOiJQYXJ0bmVyIENlbnRlciBBUEkiLCJhcHBpZCI6IjgyYmMzZTFiLWVkNzctNDc2YS04NzIzLTYyM2E3NDdmODczOSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2RjMzIyN2E0LTUzYmEtNDhmMS1iNTRiLTg5OTM2Y2Q1Y2E1My8iLCJpZHR5cCI6ImFwcCIsIm9pZCI6ImRhNmUwNDI2LTQ5YzgtNDlkMy1iMGYzLTI5MjU0NmViMmIyOCIsInJoIjoiMC5BUmNBcENjeTNMcFQ4VWkxUzRtVGJOWEtVeHMtdklKMzdXcEhoeU5pT25SX2h6a1hBQUEuIiwic3ViIjoiZGE2ZTA0MjYtNDljOC00OWQzLWIwZjMtMjkyNTQ2ZWIyYjI4IiwidGVuYW50X3JlZ2lvbl9zY29wZSI6Ik5BIiwidGlkIjoiZGMzMjI3YTQtNTNiYS00OGYxLWI1NGItODk5MzZjZDVjYTUzIiwidXRpIjoidU9nUmFPMVktRWE2Q3ZOYzNYYmdBQSIsInZlciI6IjEuMCIsInhtc190Y2R0IjoxNDYyNTU1MTY4fQ.L5IFjOchROUu9sKlNpRAhLTyO1l47azZCQ4KoYTDHPWbbvITKJOav2cD90J8bWkCZH2FsWRxoiJEiePfsyd4pb_iOiPgGpCj1hVcASi2KgF4TvaHWJRqHP8zZY4U7FQckswoNPrn3dbeMzzy-4S5C-T0Uht06A-zNCzwRPEyspg2GCauQuC4lDiCVwLjl7_6g2t-Hz2OgxGekokTRAMAp4E_n2bXd8qfWQzzGU9iZE_K972tHtf-mDvqNQerIiI9iXEN0G2taYK28DWepdOBcoy4R0gAv17FqvrX0z8bAc9OI3LRc3BY2EmF1_YqmXyzSnyFhOqi4FHVMZEZKYogiQ'
Connect-PartnerCenter -AccessToken $AccessToken




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer



#the above code does not work. It does generate access token but the grant is invalid 
# Get-PartnerCustomer :  (invalid_grant)
# At line:5 char:13
# + $customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# +             ~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : CloseError: (:) [Get-PartnerCustomer], PartnerException
#     + FullyQualifiedErrorId : Microsoft.Store.PartnerCenter.PowerShell.Commands.GetPartnerCustomer





$appId = '82bc3e1b-ed77-476a-8723-623a747f8739'
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$Refreshtoken = New-PartnerAccessToken -ApplicationId '82bc3e1b-ed77-476a-8723-623a747f8739' -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Credential $credential -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseAuthorizationCode #this requires interaction




$AccessToken = $Refreshtoken.AccessToken
Connect-PartnerCenter -AccessToken $AccessToken




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer


































function Get-PCAppUserAuthenticationBearer {
    <#
    .SYNOPSIS
       Function to retrieve App+User bearer token from Microsoft CSP API
    .DESCRIPTION
       This function connects to Azure AD to generate an oAuth token.
       Aquired token is then used against the partner center REST API to generate a App+User jwt token. https://api.partnercenter.microsoft.com/generatetoken

       You can read more about the authentication method here: https://msdn.microsoft.com/en-us/library/partnercenter/mt634709.aspx
    .PARAMETER ClientID
        The ClientID of the application used for authentication against Azure AD.
    .PARAMETER TenantId
        The TenantId of the Azure AD that you wish to authenticate against. Ie: test.onmicrosoft.com
    .PARAMETER Credential
        Pass a Powershell credential object or type in username and password
    .EXAMPLE
        Get-PCAppUserAuthenticationBearer -TenantID https://test.onmicrosoft.com -ClientID <Native App GUID> -username <admin@test.onmicrosft.com> -password <password>
        Returns a object containing the response from azure ad and a generated CSP bearer. Use the CSP bearer for further authenticating against the CSP API's and AAD token for reference

    .NOTES
        Version 1.0
        Martin Ehrnst
        September 2017
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantID,
        [Parameter(Mandatory = $true)]
        [string]$ClientID,
        [Parameter(Mandatory = $true)]
        # [System.Management.Automation.PSCredential]$Credential = (get-credential)
        [System.Management.Automation.PSCredential]$Credential
    )




    #clear error variable
    $error.clear()

    $ErrorActionPreference = "Stop"
    $username = $Credential.UserName
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(($Credential.Password))
    $StringPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    #try to access azure ad to generate a token
    try {
        $loginurl = "https://login.windows.net/$tenantId/oauth2/token"

        $params = @{resource = "https://api.partnercenter.microsoft.com"; grant_type = "password"; client_id = $ClientId; username = $username; password = $StringPassword; scope = "openid"}
        $res = Invoke-RestMethod -Uri $loginurl -Method POST -Body $params
        $oAuth = "Bearer " + $res.access_token
    }

    catch {
        write-error -message "$error"
    }

    try {

        $CSPAuthHeader = @{
            "Content-Type"  = "application/x-www-form-urlencoded"
            "Authorization" = $oAuth
        }
        $CspAuthBody = "grant_type=jwt_token"

        $CSPAppUserToken = (Invoke-restmethod -uri 'https://api.partnercenter.microsoft.com/generatetoken' -Method Post -Body $CspAuthBody -Headers $CSPAuthHeader).access_token
    
    }

    catch {
        write-error -message "$error"
    }

    $CspBearer = "Bearer " + $CSPAppUserToken

    $Tokens = @{

        "AzureAd" = $res
        "CSPBearer" = $CspBearer
    }

    $tokens
}


# Get-PCAppUserAuthenticationBearer -TenantID https://canadacomputing.onmicrosft.com -ClientID '699c6660-9dd9-4e62-a42f-4091d9ef3966'-username admin-abdullah@canadacomputing.ca -password 'zu3AO0CCc-P_.6oO~0okGLZ9JH_Z1woUUQ'
# Get-PCAppUserAuthenticationBearer -TenantID https://canadacomputing.onmicrosft.com -ClientID '699c6660-9dd9-4e62-a42f-4091d9ef3966'


$username = 'admin-abdullah@canadacomputing.ca' #global admin
$secret =  ConvertTo-SecureString 'UfIOAD^Ax7g5w!8d' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $secret)
$Accesstoken = Get-PCAppUserAuthenticationBearer -TenantID 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -ClientID '699c6660-9dd9-4e62-a42f-4091d9ef3966' -Credential $credential


$Accesstoken.AzureAd.access_token




$AccessToken = $Accesstoken.AzureAd.access_token
Connect-PartnerCenter -AccessToken $AccessToken




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer



















$appId = '699c6660-9dd9-4e62-a42f-4091d9ef3966'
$secret =  ConvertTo-SecureString 'zu3AO0CCc-P_.6oO~0okGLZ9JH_Z1woUUQ' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Credential $credential -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseAuthorizationCode



#the above does not work with native/public client and the following error is returned
# WARNING: Attempting to launch a browser for authorization code login.
# WARNING: We have launched a browser for you to login. For the old experience with device code flow, please run 'New-PartnerAccessToken -UseDeviceAuthentication'.
# New-PartnerAccessToken : A configuration issue is preventing authentication - check the error message from the server for details.You can modify the configuration in the application registration portal. See https://aka.ms/msal-net-invalid-client for details.  
# Original exception: AADSTS700025: Client is public so neither 'client_assertion' nor 'client_secret' should be presented.
# Trace ID: 79ef8837-e71f-4697-b204-192552aad200
# Correlation ID: a01abb2c-32bb-497d-8b39-3940b0ba2057
# Timestamp: 2021-05-03 18:08:53Z
# At line:4 char:1
# + New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://api.par ...
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : CloseError: (:) [New-PartnerAccessToken], MsalServiceException
#     + FullyQualifiedErrorId : Microsoft.Store.PartnerCenter.PowerShell.Commands.NewPartnerAccessToken







$appId = '82bc3e1b-ed77-476a-8723-623a747f8739' #web app
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$AccessToken = New-PartnerAccessToken -ApplicationId $appId -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Credential $credential -Tenant 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' -UseAuthorizationCode



$appId = '82bc3e1b-ed77-476a-8723-623a747f8739' #web app
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
$refreshToken = '0.ARcApCcy3LpT8Ui1S4mTbNXKUxs-vIJ37WpHhyNiOnR_hzkXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P_aCSSr7FuZcYvmjvimYM9OBlM7OxJyij3a6qA9rnLwa-hk425YQELWnEDui7H8VXy89HkZ3iJ1Pt19wELe95tFX_4rgBojEK1V3WZ-TMsK0ys-eia4NlKtZ7NaYid5JSQ2ocqugEC2XD8In7UMmbiW30l5F-6CqlEa175jDgCVw0j24WAEqPcK6BJhWBIjfQc-7YXqj9i_5Nu8o5QV2J6WHyZo2fSEkJZcwxOW3-9CMOCQOtAkZ8tTelrnFq4R6kb2eI6H2E_np-4z5PfEcdDycEQ-uP4d-J9xDI8Mdc5AUU6MKmjPO1pD4vkdHoR2G9i2H8K7Gf2_HO4-UPP8AHrsayiENiyg0wmjQOSZHsdF0Zt0Kg27WLSd3McT8TWQV6fMPlp_MPl6cFz5g2g-0dZlIrK67CHH-2KwuAhZB-3r2wp8CJ57dTfkjU2RRoxiqiUksp_CIX8PrNLGLw9hsPz855cZoC_0qCQOGb1-kN9I0CwQrYXoi_yTedWPixgNDDORX78iMUzgWAQ21aCENwpii3tnY3vtNl0mu5seB4XdeoQSTBqTXBOD03FXzdfy_jd0gDXTp4lip854Xv-JvHkyICTui3vqNk1Xydr6WZjgKLFq1s8wJWLWm50J0irh4TBYK3cFofjArdOpgnTOC_Rcmg5ItXhNii8zWKxP4YiDe1gaWalP16LVNVOkeFvxVfp83PEiI4Qo0UoThShqhKnHjpC98C9uQrp3rcp6KIxIlJLo6N8IRvWHgHzBwtrBwQkX6Fpmwr5U9SV-oAYtbAuUCXhmA90AoC-0EnYfy5bwc1WsR9NDUCjSSa1f6vfp6zrRryohjuUgdaz1QYuXR3trgtZgEAbkQnnbNJugBT8u39KUJslFjx97ZUdPpU94tBEp8-_EDCCKK9DvvXsR2uLPX-3EBvGbnwo'
$tenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
$AccessToken2 = New-PartnerAccessToken -ApplicationId $appId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Tenant $tenantID


$AccessTokenVal = $AccessToken2.accesstoken
Connect-PartnerCenter -AccessToken $AccessTokenVal




$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer







$appId = '82bc3e1b-ed77-476a-8723-623a747f8739'
$secret =  ConvertTo-SecureString 'IeQo_~O0l2-.TBo8Gd31Uw836ORYYI.ML5' -AsPlainText -Force
$refreshToken = '0.ARcApCcy3LpT8Ui1S4mTbNXKUxs-vIJ37WpHhyNiOnR_hzkXAL4.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P9mN6xcJptFFgbOMwVonFuFM3ICWsnAJkVqLsGdECEi-3K8FaS5BFyqZVESoXJujPgXX1GekRFurfjMeycK2Az8dmPyaCtsOXB7jjvaibPiPJLNb708Uce9j1ooGgVckIma66rQWYnOYEqOAmv8oMlebzDGarPSIQOK8luTf6THOpKcevcj_TSpkZ9JFYReOOx6cZFQi0oHmvl2TsRHvksA6g-8C75_JzjSbpqGtf7245YTg4SKYZEONyQe2ln36LXCwS55UY2Vz1x7esWJR_fsRdpzLWcrN_3SUfTr-a_HoGYtuyUAqZuVZZPG7rbummsVMumSlLouwF17ZQeOo-Z6jK2zEasNcVgijcicUDG6l-Z5flfEVmUsnlCEmkkmX_3b8W0yFKy44nvf0RQj9YbEqPlidzYitRJnjDlM5RxAKbvEDXImlgmZWaiY3bhV9VzsaS4e9L2RqNjU0cJXhqKHYT3-bB3L4MwzFlUMVJuP1H8ri0g0ThUwl0fWeEyMGs2S2bvdz0WlmcnExnGkoW1akTvp72OGrWL3CJS31k3fyKnsOlksVYTJF7xrSTslAQ_joj9tXFMKAd6dnit4TPrtwU1K4xXvw64v5ny7LGjQOpksaoxNC9gn4a3WoHewoiONw0A3DpNHMhzgR7jVxomnQuei9zdDUAEe6jGdJl7m0JiDgC9QU51_4AI9Ot2xBhUPN5fq9TS2uKRAvcnVvwDZM5dLa21y-eEDvRp3M21eIAzgbjwoTJTwnvB7PDc9_vGDU17-Mcu_x1HHyiwxPusfZ_ZadNcGUqvQ2mQ07N87ue8ZDoUDjC4WCU8myeFdIepwyPXMM56Ro-Gl6V7uY1z09GwSgP7OX0hwaToy_ql_dA-rOFPNBpIhjYZ1Gt_ZZbX6jcnHn1ZcPk4StejJe28WOhcs7m7XElxvHdhQdm0568fJL_VfTkkk4Qlu8i15GFIkP_jTQy5cCzpZ3gIo'
$tenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
$credential = New-Object System.Management.Automation.PSCredential($appId, $secret)
Connect-PartnerCenter -ApplicationId $appId -Credential $credential -RefreshToken $refreshToken



$name = 'Canada Computing Testing'
# $name = 'Symbicore'
# $Domain = 'fgchealth.com'

$customer = Get-PartnerCustomer | Where-Object { $_.Name -eq $name }
# $customer = Get-PartnerCustomer
# $customer.CustomerId
$customer
