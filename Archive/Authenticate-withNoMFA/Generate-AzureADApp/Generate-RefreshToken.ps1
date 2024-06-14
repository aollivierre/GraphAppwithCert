function Generate-RefreshToken {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantID,
    [Parameter(Mandatory = $false)]
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
    $Scope

    
    
  )
  
  begin {
    
  }
  
  process {

    try {

      
      # Secure_App_Model_Consent(Step2)
      
      # This where you will authenticate interactively using the authorization code flow or device code flow. The response from Azure Active Directory will contain an access token and a refresh token. The refresh token value should be stored somewhere secure, such as Azure Key Vault. This value will be used by your application, or script, instead of user credential when authenticating.
      
      #Consent(Step2 in the secure app model) (Refresh Token Generation, this is your secret to store in Azure Keyvault and to use instead of the creds)
      
      # $credential = Get-Credential #The first command gets the service principal credentials (application identifier and secret), and then stores them in the $credential variable
      
      # $Script:TenantID_3001 = $null
      # $Script:TenantID_3001 = "e09d9473-1a06-4717-98c1-528067eab3a4" #FGC Health AD
      # $Global:TenantId_9001 = $null
      # $Script:TenantID_3001 = Get-AzureADTenantDetail.ObjectId
      # $TenantID = $Script:TenantID_3001
      
      # $Thumbprint_3001 = $null
      # $Thumbprint_3001 = '6D95B992C9EB7BF764650D1E1D3D656350916DB1'
      # $Thumbprint_3001 = $Script:ROOT_CERT.Thumbprint
      # $Thumbprint_3001 = $Thumbprint
      # $Thumbprint = $Thumbprint_3001
      
      # $ApplicationId_3001 = $null
      # $ApplicationId_3001 = '787faab2-3701-4a9e-ac96-168f17b6e2de'
      # $ApplicationId_3001 = $Script:spn_9001.ApplicationId
      # $ApplicationID = $ApplicationId_3001


      # $Scope_3001 = $null
      # $Scope_3001 = 'https://graph.microsoft.com/.default'


      
      
      $newRefreshTokenSplat_3001 = $null
      $newRefreshTokenSplat_3001 = 
      
      @{
        ApplicationId         = $ApplicationID
        # Scopes                = 'https://api.partnercenter.microsoft.com/user_impersonation'
        # Scopes                = 'https://management.azure.com/user_impersonation'
        Scopes                = $Scope
        # Scopes                = 'https://graph.microsoft.com/.default'
        ServicePrincipal      = $true
        # Credential            = $credential
        CertificateThumbprint = $Thumbprint
        Tenant                = $TenantID
        UseAuthorizationCode  = $true #When using the UseAuthorizationCode parameter you will be prompted to authentication interactively using the authorization code flow.
      }
      

      Write-host 'Generating a new Refresh token with the scope' $Scope

      $New_RefreshToken_3001 = $null
      $New_RefreshToken_3001 = New-PartnerAccessToken @newRefreshTokenSplat_3001
      
      
      #The second command will generate a new access token using the service principal credentials stored in the $credential variable and the authorization code flow. The output from this command will contain several values, including a refresh token. That value should be stored somewhere secure such as Azure Key Vault because it will be used instead of user credentials in future operations.
            
    }
    catch {

      Write-Error 'There is an error with Generating Refresh Token... Halting execution'        
      #Region CatchAll

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

      #endregion CatchAll

      Exit

    }
    finally {

     
            
    }
    
  }
  
  end {

    # return $Script:New_RefreshToken_3001.RefreshToken
    # Write-host $Script:New_RefreshToken_3001.RefreshToken
    # return $Script:New_RefreshToken_3001.RefreshToken
    # return $New_RefreshToken_3001.RefreshToken
    return $New_RefreshToken_3001
    
  }
}

# Generate-RefreshToken -TenantID $Script:TenantID_3001 -ApplicationID $ApplicationId_3001 -ThumbPrint $Thumbprint_3001
# Generate-RefreshToken


# $Credential = Get-Credential


# $subscriptionID = '408a6c03-bd25-471b-ae84-cf82b3dff420' #Microsoft Azure Sponsorship
# $TenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' #Canada Computing Azure AD Tenant
# $ApplicationID = '0d32e246-74a4-4930-af3f-4972652d75bb'
# # $AccountID = 'Abdullah@canadacomputing.ca'
# # $AppDisplayname = 'CCI_OneDrive_APP_1'
# $Scope = 'https://graph.microsoft.com/.default'

# # $RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken
# $generateRefreshTokenSplat = @{
#     TenantID = $TenantID
#     ApplicationID = $ApplicationID
#     Scope = $Scope
#     # credential = $Credential
#     # ServicePrincipal = $true
# }

# $RefreshToken = (Generate-RefreshToken @generateRefreshTokenSplat).Refreshtoken


# $RefreshToken












# $credential = Get-Credential
# $refreshToken = ''
# New-PartnerAccessToken -ApplicationId $ApplicationID -Credential $credential -RefreshToken $refreshToken -Scopes $Scope -ServicePrincipal -Tenant $TenantID