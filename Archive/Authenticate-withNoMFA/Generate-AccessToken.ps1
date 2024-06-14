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
            
            # $refreshToken = '<refreshToken>'
            # $refreshToken = '0.AAAAc5Sd4AYaF0eYwVKAZ-qzpPPZ5j5EVZhGnpmbveZ5Ar5RABQ.AgABAAAAAAB2UyzwtQEKR7-rWbgdcBZIAQDs_wIA9P8QXXpf7S8Gpw5rCAmtTIegsFYGRzlTqdqABXoXh8NqUWADlo3W02UA96MN5dV7Fz4dfT7fUTJtLey8aL1r3QetkBjPyxjZK_MUkyYVjeHVZO3hYd-TP9duomTwHwBkdjFMeKJHqdRsZi9LgSFVxVb_lmbGG_tx-3gxiBKF8DRcA_sCDVNR4Tr4UiaDPUYHhkVxD67T1sJvX5xpRnXteRudLULYSbv9JbUpd41_NhLtFI6TaBWlxIRP_3P8l4cmx7C9EXYd-HdDMPv5MjM8ficMrBT3B2hhvrld6vt6rdi6u7ZBM0gtdY8FboX5_i_TU87ocCkAwm3ulzfq6N2bIMR_wqH68MaiVgiilmx53SGNcbqnpRO-2zIoUYqKn2gWK9GsKZ7hzpnXzuayUEeHUUZbDe1t1t_qWzsvjoAul-tWRu3w-TfojoxLEbJPjwfre67gY_ECFphCq3POUMYPfkj7-rHYYfgfJeXIDWcX2iRm9owiqHFxO08j0NTfvQnnpncNpk5OifKGbLmfCJHRr7hYX8MVf-bhfwWvfBGgC2NfwyZ-Pmo8eJc2wJ3-yqRm_Ny-VSIkudL-2rJZiIsOtnu52OK2BVbP_c_M_A-8CHh0lgoVKRxL0Uhxd8U_EBfB-FIisIri5us9N0Oply3EGPGNRvA6Hn5vTY1hYvAnhfOln_4sSg6HMn-XTaRoQfUK-7O3ynMoN6W9gAZV8MmRQB-fitOUveq7hROuQyAceHud90RVep-jPoYPhvYzxunoa99Eu9mLyO_EJ7iUBoeOXLZHhSeYeChgTCo1nkGZWRKQQWcLi4RMJxahDnhseMjdVttTrVOvE9pdL63GJUafmjVWESxOS-w44_wUaugaTVfW4YWW-HSdWIJU-MSg7ENyQk0_m54qG0OF49UxKFUkAt9G_PmSVlGp6ooVYlOkj8W7heqgncY_TVLDRGjh2Jgu_w7-ZIq1KhUYxA-F48Z7F6ZT-68cUwgErjIYHku7mOxffhqefbyN-3tnbv_uHB1ilNqJU5_muIpXdwzgxXCvnAveBuB0165QFZ9DUQ_W89wPj5rnIt6w-6Raxw'

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
