function Connect-PartnerCenterUsingAccesstoken {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

        # $ApplicationId_7001 = $null
        # $ApplicationId_7001 = "0d32e246-74a4-4930-af3f-4972652d75bb"

        # $ApplicationSecret_7001 = $null
        # $ApplicationSecret_7001 = "9Ifl1NCGNlytwF8F62mwROkSRypwLvvOIlzWMPTJJpc="

        $TenantID_7001 = $null
        $TenantID_7001 = "dc3227a4-53ba-48f1-b54b-89936cd5ca53"

        $RefreshToken_7001 = $null
        $RefreshToken_7001 = "0.ARcApCcy3LpT8Ui1S4mTbNXKU0biMg2kdDBJrz9JcmUtdbsXAB8.AgABAAAAAAB2UyzwtQEKR7-rWbgdcBZIAQDs_wIA9P9pUxrVuXTg2zH4nC-eDuKt76Y8r544qqPu0Jw1DRa6Szg_xUeEDmiDPA64kaWOq8yW4evU8al0GB0h877MvgrTPpMPJMmE5FnOEz2VQNmwMia9uxNmUVwZyAyziJOIiPYH0sji3IBN0T3jRVww39_sylhbomngbZVMlEI3SyjU82UYxte4IIGR8Xvy6E8V7HPkYiVrG92mbJaSwGOaoX3Mjda3IqF4ZtdZrEXV-EhCG3Og78CtaTBBNKAyxhBb_owYceDIFfcV4W3PEZtzFNPQBZOscZrd31ojm8Nbcje-s1pHEZIyDuqba_2rcfJ7P0tGZnb-BGskwoGjhrf8uZEY50EyWiBG4D-E4Bhy4msNL19SHzEqd_WhvyNcCRJbGaI6eFBB7q81F0JQO_TTPoXlgmSeszCyBUyBPp8-R_kpshlZLrgdSVo1aARYdT1tuds635TNZa6IVfeE0f9QssIpb-dSw_kp3TEv5ijzYTEqPIZVHQWKROfZd3sDRaIjRgYDLbS50LiUU-G7xAtx2ATleDzLahpnMTCscIInmLJcE9NyFPixF3yamvTWkcXTAx9Ghn6XhnKsEZA15kjoAzK4s6NDGoL8M8Uaf4mYM_vMB42z1roksREn6GAAJ_5wjOeDSdBAHRaDn1_4BJ_FYX_eoAl8eeoqDejBRLtEOM7HrmtxHV-9aZjmw2C5TjJOUdOKOuZApBQ_p6Do01bhbjSO57ZCo6737sn0fv7zjCFkEKth1yu-JBXKcWqfvAdAAHWHIl4AwIB2XOjjlck6j5Am9YuwC2W9nEyGIqYO-3bGDz0-PmADXzqsr2xguVPrd1jRMyTvWNcocN7XT0KhgQDOJtybwmm4vfZXZzk76aVBPCtDE2LCBl_-CGC097VbNus2EFtZlQTjXhFAHOsxo9JEKm2vgnHv8dd3gtvV5yRZ2iYfqjs0hRtiZX1sjkluqey4rmZNuCrCY-K2o7hkMP_cDuPTik0UuFPBgNN7SJAQYipUp-_KdknxgmeAkhu-iNkIgiDnZ_ZLUj2vFa6giKlxiPKEHhSI1UtflQWhPPn4BZjdKurkIGhkHto7aJ3-IRKq1X_G6fTvvCNNLMxY-9m8LzExrHo82keOXw"

        # $Prompt = $null   
        # $Prompt = "Enter Refresh Token"

        # $refreshToken = $null
        # $refreshToken = 'Enter the refresh token value here'
        # $refreshToken = $RefreshToken_7001

        $Appcredential_7001 = $null
        $Appcredential_7001 = Get-Credential

        # $RefreshToken_7001 = $null
        # $RefreshToken_7001 = Read-Host -Prompt $Prompt -AsSecureString

        # Write-host 'Converting the password APP secret to a secure string' -ForegroundColor Green
        # $PasswordToSecureString_9001 = $null
        # $PasswordToSecureString_9001 = $Script:password_9001.value | ConvertTo-SecureString -asPlainText -Force
        

        # Write-host 'Creating the Application Credential object containing the APP ID and the APP secret' -ForegroundColor Green
        # $Script:credential_9001 = $null
        # $Script:credential_9001 = New-Object System.Management.Automation.PSCredential($($Script:app_9001.AppId), $PasswordToSecureString_9001)
        
        # $tenantId = $null
        # $tenantId = '<Your Tenant Id>'
        # $tenantId = $TenantID_7001

        # $newPartnerAccessTokenSplat_7001 = $null
        # $newPartnerAccessTokenSplat_7001 = @{
        #     RefreshToken = $RefreshToken_7001
        #     Credential   = $Appcredential_7001
        #     Tenant       = $TenantID_7001
        #     Resource     = 'https://api.partnercenter.microsoft.com'
        # }


        # Generating an access token using a refresh token
        $newPartnerAccessTokenSplat_7001 = $null
        $newPartnerAccessTokenSplat_7001 = @{
            ApplicationId    = $Appcredential_7001.UserName
            Credential       = $Appcredential_7001
            RefreshToken     = $RefreshToken_7001
            Scopes           = 'https://api.partnercenter.microsoft.com/user_impersonation'
            ServicePrincipal = $true
            Tenant           = $TenantID_7001
        }

        $pcToken_7001 = $null
        $pcToken_7001 = New-PartnerAccessToken @newPartnerAccessTokenSplat_7001

        $newConnectPartnerCenterSplat_7001 = $null
        $newConnectPartnerCenterSplat_7001 = @{
            AccessToken   = $pcToken_7001.AccessToken
            # ApplicationId = $Appcredential_7001.UserName
            Tenant        = $TenantID_7001
            # Credential    = $Appcredential_7001
            # Environment = 'AzureCloud'
        }

        # $newConnectPartnerCenterSplat_7001 = $null
        # $newConnectPartnerCenterSplat_7001 = @{
        #     Refreshtoken  = $RefreshToken_7001
        #     ApplicationId = $Appcredential_7001.UserName
        #     # Tenant        = $TenantID_7001
        #     Credential    = $Appcredential_7001
        # }
        
    }
    
    process {

        try {

            #Region Authentication Method4 (using Service Prinicapl [Access token based]) (Partner Center 1.5)
            Connect-PartnerCenter  @newConnectPartnerCenterSplat_7001
            #Endregion Authentication Method4 (using Service Prinicapl [Access token based]) (Partner Center 1.5)
            
        }
        catch {

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            # Write-Host $PSItem -ForegroundColor Red
            $PSItem
            Write-Host $PSItem.ScriptStackTrace -ForegroundColor Red
            
            
            $ErrorMessage_1 = $_.Exception.Message
            write-host $ErrorMessage_1  -ForegroundColor Red
            Write-Output "Ran into an issue: $PSItem"
            Write-host "Ran into an issue: $PSItem" -ForegroundColor Red
            throw "Ran into an issue: $PSItem"
            throw "I am the catch"
            throw "Ran into an issue: $PSItem"
            $PSItem | Write-host -ForegroundColor
            $PSItem | Select-Object *
            $PSCmdlet.ThrowTerminatingError($PSitem)
            throw
            throw "Something went wrong"
            Write-Log $PSItem.ToString()
            
        }
        finally {
            
        }
        
    }
    
    end {
        
    }
}


Connect-PartnerCenterUsingAccesstoken