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
        $RefreshToken_7001 = "<REDACTED-REFRESH-TOKEN>"

        # $Prompt = $null   
        # $Prompt = "Enter Refresh Token"

        # $refreshToken = $null
        # $refreshToken = '<REDACTED>'
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