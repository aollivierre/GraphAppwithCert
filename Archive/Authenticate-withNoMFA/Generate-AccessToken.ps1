# Using the securely stored refresh token, generated through the consent step, you will request a new access token from Azure Active Directory. See refresh the access token for more information regarding the refresh token value.

#Exchange(Step 3 in the secure app model)(Access Token generation based on the Refresh token generated in step 1)

# $credential = Get-Credential #The first command gets the service principal credentials (application identifier and secret), and then stores them in the $credential variable

. "$PSScriptRoot\Generate-RefreshToken.ps1"

function Generate-AccessToken {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TenantID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Thumbprint,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ApplicationID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Scope,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $refreshToken

        # [Parameter(Mandatory = $true)]
        # [ValidateNotNullOrEmpty()]
        # [String]
        # $Param2
        
    )
    
    begin {
        
    }
    
    process {


        try {
            
            # $refreshToken = '<REDACTED>'
            # $refreshToken = '<REDACTED>'

            $SessionParam_8001 = $null
            $SessionParam_8001 =
            @{
                ApplicationId         = $ApplicationID
                # Scopes = 'https://api.partnercenter.microsoft.com/user_impersonation'
                Scopes                = $Scope
                ServicePrincipal      = $true
                # Credential = $credential
                CertificateThumbprint = $Thumbprint
                Tenant                = $TenantID
                RefreshToken          = $refreshToken
            }

            $AccessToken = New-PartnerAccessToken @SessionParam_8001 #The third command will generate a new access token using the service principal credentials stored in the $credential variable and the refresh token stored in the $refreshToken variable for authentication.

            
        }
        catch {
            
            Write-Error 'An Error happened when Cleaning App AD Apps .. script execution will be halted'
         
            #Region CatchAll
         
            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
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
         
            #EndRegion CatchAll
         
            Exit
         
         
        }
        finally {
            
        }
        
    }
    
    end {

        return $AccessToken
        
    }
}


# $TenantID = 'e09d9473-1a06-4717-98c1-528067eab3a4'
# $ApplicationID = '3ee6d9f3-5544-4698-9e99-9bbde67902be'
# $ThumbPrint = '94544DFEA2D0862CB06A34F6AA59D9AC53592782'


# $Scope = 'https://management.azure.com/user_impersonation'
# $RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken

# $Scope = 'https://graph.microsoft.com/.default'
# $AccessToken = (Generate-AccessToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope -Refreshtoken $RefreshToken)


# $AccessToken.AccessToken
