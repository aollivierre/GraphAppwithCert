. "$PSScriptRoot\Fault_Tolerance_CleanupAzSessions.ps1"
. "$PSScriptRoot\Fault_Tolerance_Connect-AzureADfromAzContext.ps1"
. "$PSScriptRoot\Fault_Tolerance_CleanupModules_Az.ps1"
. "$PSScriptRoot\Fault_Tolerance_CleanupModules_PartnerCenter.ps1"
. "$PSScriptRoot\Generate-RefreshToken.ps1"

function Generate-AzADServicePrincipalCert {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TenantDomain
    )
    
    begin {

        # $AppDisplayname = $null
        # $AppDisplayname = $AppDisplayname_9001

            
        # $RootCert = $null
        # $CertValue = $null

        # $Sessioninfo = $null
        # $Sessioninfo = Get-AzureADCurrentSessionInfo



        # $cert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" `
        #     -Subject "CN=exampleappScriptCert" `
        #     -KeySpec KeyExchange
        # $CertValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
    
        
        $NewSelfSigned_ROOT_CertificateParam = $null
        $NewSelfSigned_ROOT_CertificateParam = @{

            Type              = 'custom'
            # KeySpec           = 'signature'
            KeySpec           = 'KeyExchange'
            subject           = "cn=$($AppDisplayname)"
            KeyExportPolicy   = 'Exportable'
            HashAlgorithm     = 'sha256'
            KeyLength         = '2048'
            CertStoreLocation = "Cert:\CurrentUser\My"
            KeyUsageProperty  = 'sign'
            KeyUsage          = 'CertSign'
            DnsName           = "$TenantDomain"

            

        }
    }
    
    process {
        
        try {

            #Create ROOT Cert
            Write-Host 'creating a root cert' -ForegroundColor Green
            $RootCert = New-SelfSignedCertificate @NewSelfSigned_ROOT_CertificateParam

            
        }
        catch {

            Write-Error 'There was an error with Creating Cert ... halting execution'

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

            exit
            
        }
        finally {
            
        }
    }
    
    end {

        
        Write-Host 'Root Cert with the subject '"$($RootCert.Subject)" ' has been created' -ForegroundColor Green
        Write-Host 'Root Cert with the Thumbprint '"$($RootCert.Thumbprint)" ' has been created' -ForegroundColor Green

        Write-Host 'Creating a Base64 String from the Root Cert' -ForegroundColor Green
        # $CertValue = [System.Convert]::ToBase64String($RootCert.GetRawCertData())

        # Write-Host 'a Base64 String from the Root Cert has been created' $CertValue
        Write-Host 'a Base64 String from the Root Cert has been created' -foregroundcolor green

        
        # $ThumbPrint = $null
        # $ThumbPrint = $RootCert.Thumbprint


        # return $ThumbPrint
        return $RootCert
        
    }
}

function Generate-NewAzADServicePrincipal_App {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StartDate,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EndDate,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertValue
     
    )
    
    begin {


        # $AppDisplayname = $null
        # $AppDisplayname = $AppDisplayname_9001

        $newAzADServicePrincipalSplat = $null
        $newAzADServicePrincipalSplat = @{
            # AppId = $Script:app_9001.AppId
            # ApplicationId = $Script:app_9001.AppId
            DisplayName = $AppDisplayname
            EndDate     = $RootCert.NotAfter
            StartDate   = $RootCert.NotBefore
            CertValue   = $CertValue
        }
        
    }
    
    process {

        try {
        

 

            # $Script:spn_9001 = $null
            # $Script:spn_9001 = New-AzureADServicePrincipal @newAzureADServicePrincipalSplat


            write-host 'a new service principal is now being created' $Script:spn_9001 -ForegroundColor Green
        

            $Script:spn_9001 = $null
            $Script:spn_9001 = New-AzADServicePrincipal @newAzADServicePrincipalSplat #this automatically create an app as well if you do not specify an existing app
            
            write-host 'a new service principal is now created' $Script:spn_9001 -ForegroundColor Green

            Start-Sleep 20
        }
        catch {

            Write-Error 'There was an error with Creating the new Az AD Service Principal and creating the new Azure AD app... halting execution'

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

            exit
            
        }
        finally {
            
        }
        
    }
    
    end {

        
        # $ApplicationID = $null
        # $ApplicationID = $Script:spn_9001.ApplicationId

        # $ObjectID = $null
        # # $ObjectID = (Get-AzADApplication -ApplicationId $Script:spn_9001.ApplicationId).ObjectId
        # $ObjectID = (Get-AzADApplication -ApplicationId $ApplicationID).ObjectId

        # return $ApplicationID, $ObjectID

        return $Script:spn_9001
        
    }
}

function Update-AzADApplicationProperties {
    [CmdletBinding()]
    Param 
    ( 
        [Parameter(Mandatory = $false)]
        [switch]$ConfigurePreconsent,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ObjectID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantDomain
        # [Parameter(Mandatory = $false)]
        # [string]$TenantID
    )
    begin {
        
        #! This application is using Azure AD Graph API, which is on a deprecation path. Starting June 30th, 2020 we will no longer add any new features to Azure AD Graph API. We strongly recommend that you upgrade your application to use Microsoft Graph API instead of Azure AD Graph API to access Azure Active Directory resources. 
        # $adAppAccess_9001 = $null
        # $adAppAccess_9001 = [Microsoft.Open.AzureAD.Model.RequiredResourceAccess]@{
        #     ResourceAppId  = "00000002-0000-0000-c000-000000000000";
        #     ResourceAccess =
        #     [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
        #         Id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04";
        #         Type = "Role"
        #     },
        #     [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
        #         Id   = "a42657d6-7f20-40e3-b6f0-cee03008a62a";
        #         Type = "Scope"
        #     },
        #     [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
        #         Id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6";
        #         Type = "Scope"
        #     }
        # }

        $graphAppAccess_9001 = $null
        $graphAppAccess_9001 = [Microsoft.Open.AzureAD.Model.RequiredResourceAccess]@{
            ResourceAppId  = "00000003-0000-0000-c000-000000000000"; #Microsoft Graph
            # Take advantage of the tremendous amount of data in Office 365, Enterprise Mobility + Security, and Windows 10. Access Azure AD, Excel, Intune, Outlook/Exchange, OneDrive, OneNote, SharePoint, Planner, and more through a single endpoint.
            ResourceAccess =
            [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
                Id   = "bf394140-e372-4bf9-a898-299cfc7564e5";
                Type = "Role"
            },
            [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
                Id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61";
                Type = "Role"
            }
        }
        
        # $partnerCenterAppAccess_9001 = $null
        # $partnerCenterAppAccess_9001 = [Microsoft.Open.AzureAD.Model.RequiredResourceAccess]@{
        #     ResourceAppId  = "fa3d9a0c-3fb0-42cc-9193-47c7ecd2edbd";
        #     ResourceAccess =
        #     [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
        #         Id   = "1cebfa2a-fb4d-419e-b5f9-839b4383e05a";
        #         Type = "Scope"
        #     }
        # }

        # $AppDisplayname = $null
        # $AppDisplayname = $AppDisplayname_9001

        # $TenantID = $null
        # $TenantID = $(Get-AzureADTenantDetail).ObjectId

        # $NewAzADServicePrincipal_App_3001 = $null
        # $NewAzADServicePrincipal_App_3001 = Generate-NewAzADServicePrincipal_App

        # $ObjectID_3001 = $null
        # $ObjectID_3001 = $NewAzADServicePrincipal_App_3001

    }
    
    process {

        try {

    
            $ErrorActionPreference = "Stop"

            # $Sessioninfo = $null
            # $Sessioninfo = Get-AzureADCurrentSessionInfo

            Write-Host -ForegroundColor Green "updating the Azure AD application and related resources..."

            $newAzureADApplicationSplat_9001 = $null
            $newAzureADApplicationSplat_9001 = @{
                
                # ObjectID                = $ObjectID
                ObjectID                = $ObjectID
                AvailableToOtherTenants = $true
                DisplayName             = $AppDisplayname
                IdentifierUris          = "https://$($TenantDomain)/$((New-Guid).ToString())" #also known as Application ID URI
                # RequiredResourceAccess  = $adAppAccess_9001, $graphAppAccess_9001, $partnerCenterAppAccess_9001
                # RequiredResourceAccess  = $graphAppAccess_9001, $partnerCenterAppAccess_9001
                RequiredResourceAccess  = $graphAppAccess_9001
                ReplyUrls               = @("urn:ietf:wg:oauth:2.0:oob", "https://localhost", "http://localhost", "http://localhost:8400") #also known as Redirect URI
            }

            # $Script:app_9001 = $null
            # $Script:app_9001 = set-AzureADApplication @newAzureADApplicationSplat_9001
            set-AzureADApplication @newAzureADApplicationSplat_9001
            # $Script:app_9001 = New-AzureADApplication @newAzureADApplicationSplat_9001

            Start-Sleep 20

            $ApplicationSecret = $null
            # $ApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $Script:app_9001.ObjectId
            $ApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $ObjectID
            
      




            #!commenting the following when creating an AAD app in a customers's tenant, if you are creating it in a csp partner account then uncomment the following block
            # $adminAgentsGroup_9001 = $null
            # $adminAgentsGroup_9001 = Get-AzureADGroup -Filter "DisplayName eq 'AdminAgents'"
            # Add-AzureADGroupMember -ObjectId $adminAgentsGroup_9001.ObjectId -RefObjectId $Script:spn_9001.ObjectId
    
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

function Generate-AzureADAppCredential {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationSecretValue,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationID
    )
    
    begin {
        
    }
    
    process {

        try {
            
            Write-host 'Converting the password APP secret to a secure string' -ForegroundColor Green
            $PasswordToSecureString_9001 = $null
            $PasswordToSecureString_9001 = $ApplicationSecretValue | ConvertTo-SecureString -asPlainText -Force
            
    
            Write-host 'Creating the Application Credential object containing the APP ID and the APP secret' -ForegroundColor Green
            $AppCredential = $null
            # $AppCredential = New-Object System.Management.Automation.PSCredential($($Script:spn_9001.ApplicationId), $PasswordToSecureString_9001)
            $AppCredential = New-Object System.Management.Automation.PSCredential($ApplicationID, $PasswordToSecureString_9001)
        }
        catch {
            
        }
        finally {
            
        }
        
    }
    
    end {
        
    }
}


#Region Generate-SecureAppModelRefreshToken
<#
function Generate-SecureAppModelRefreshToken {
    [CmdletBinding()]
    param (
        
    )
    
    begin {



        $newPartnerRefreshTokenSplat_9001 = $null
        $newPartnerRefreshTokenSplat_9001 = @{
            ApplicationId        = $ApplicationID
            Scopes               = 'https://api.partnercenter.microsoft.com/user_impersonation'
            ServicePrincipal     = $true
            Credential           = $AppCredential
            # Tenant               = $($Script:spn_9001.AppOwnerTenantID)
            Tenant               = $TenantID
            UseAuthorizationCode = $true
        }
        
    }
    
    process {
        
        try {
            
            
            # write-host "Installing PartnerCenter Module." -ForegroundColor Green
            # install-module PartnerCenter -Force
            write-host "Sleeping for 30 seconds to allow app creation on O365" -foregroundcolor green
            start-sleep 30
            write-host "Please approve General consent form." -ForegroundColor Green

            $Script:Consent_token_9001 = $null
            $Script:Consent_token_9001 = New-PartnerAccessToken @newPartnerRefreshTokenSplat_9001

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
#>
#Endregion Generate-SecureAppModelRefreshToken

function Generate-SecureAppModelAccessToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ExchangeApplicationID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ExchangeScope
    )
    
    begin {

        $newPartnerAccessTokenSplat_Exchangetoken_9001 = $null
        $newPartnerAccessTokenSplat_Exchangetoken_9001 = @{
            ApplicationId           = $ExchangeApplicationID  #The application identifier a0c73c16-a7e3-4564-9a95-2bdf47383716 is for the Exchange Online PowerShell Azure Active Direcotry application. When requesting an access, or refresh, token for use with Exchange Online PowerShell you will need to use this value.
            # Scopes                  = 'https://outlook.office365.com/.default'
            Scopes                  = $ExchangeScope
            # Tenant                  = $($spn_9001.AppOwnerTenantID)
            Tenant                  = $TenantID
            UseDeviceAuthentication = $true
        }

        # $NewAzADServicePrincipal_App_3001 = $null
        # $NewAzADServicePrincipal_App_3001 = Generate-NewAzADServicePrincipal_App

        # $ApplicationID_3001 = $null
        # $ApplicationID_3001 = $NewAzADServicePrincipal_App_3001[0]


        
    }
    
    process {


        try {

            write-host "Please approve Exchange consent form." -ForegroundColor Green
            
            $ExchangeToken = $null
            $ExchangeToken = New-PartnerAccessToken @newPartnerAccessTokenSplat_Exchangetoken_9001



            # write-host "Last initation required: Please browse to https://login.microsoftonline.com/$($spn_9001.AppOwnerTenantID)/adminConsent?client_id=$($app_9001.AppId)"
            write-host "Last initation required: Please browse to https://login.microsoftonline.com/$($TenantID)/adminConsent?client_id=$($ApplicationID)"
            # write-host "Last initation required: Please browse to https://login.microsoftonline.com/$($TenantID)/adminConsent?client_id=$($ApplicationID_3001)"
            write-host "Press any key after auth. An error report about incorrect URIs is expected!"
            [void][System.Console]::ReadKey($true)

            
        }
        catch {

            Write-Error 'An Error happened when Generating an Access token.. script execution will be halted'

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

            #EndRegion CatchAll

            Exit
        }
        finally {
            
        }
        
    }
    
    end {
        
        return $ExchangeToken
    }
}

function Output-SecureAppSecrets {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false)]
        [String]$AppDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationId,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationSecretValue,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Thumprint,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RefreshToken,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ExchangeRefreshToken
        
    )
    
    begin {

        Write-Host 'storing Secure App Model Secrets in an object '

        $Secure_App_Model_Secrets_Object_9001 = $null
        $Secure_App_Model_Secrets_Object_9001 = [PSCustomObject]@{
            AppDisplayname       = $AppDisplayname
            ApplicationId        = $ApplicationID
            ApplicationSecret    = $ApplicationSecretValue

            CertSubject          = $RootCert.Subject
            CertThumbprint       = $Thumprint
            # TenantID_9001        = $Script:spn_9001.AppOwnerTenantID
            TenantID_9001        = $TenantID
            # RefreshToken         = $Script:Consent_token_9001.refreshtoken
            RefreshToken         = $RefreshToken
            ExchangeRefreshToken = $ExchangeRefreshToken
        }
        
    }
    
    process {

        try {
            
            Write-Host "================ Secrets ================"
            Write-Host "`$AppDisplayname        = $($AppDisplayname)"
            Write-Host "`$ApplicationId         = $($ApplicationID)"
            Write-Host "`$ApplicationSecretValue     = $($ApplicationSecretValue)"
            Write-Host "`$Thumprint     = $($Thumbprint)"
            # Write-Host "`$TenantID        = $($Script:spn_9001.AppOwnerTenantID)"
            Write-Host "`$TenantID        = $TenantID"
            write-host "`$RefreshToken          = $($RefreshToken)" -ForegroundColor Blue
            write-host "`$Exchange RefreshToken = $($ExchangeRefreshToken)" -ForegroundColor Green
            Write-Host "================ Secrets ================"
            Write-Host "    SAVE THESE IN A SECURE LOCATION     " 



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
        
        return $Secure_App_Model_Secrets_Object_9001
    }
}



Fault_Tolerance_CleanupAzSessions

write-host "running az func"
$ConnectAzAccountwithContextReturn = $null
$ConnectAzAccountwithContextReturn = Fault_Tolerance_Connect-AzAccountwithContext -subscriptionName 'Microsoft Azure'
# $ConnectAzAccountwithContextReturn | gm

# $TenantID = $ConnectAzAccountwithContextReturn[0].$TenantID
$TenantID = ($ConnectAzAccountwithContextReturn).tenant.id

# $AccountID = $ConnectAzAccountwithContextReturn[1]
$AccountID = ($ConnectAzAccountwithContextReturn).account.id

Fault_Tolerance_Connect-AzureADfromAzContext -TenantID $TenantID -AccountID $AccountID -SubscriptionName 'Microsoft Azure'

$SessionInfo = $null
$SessionInfo = Get-AzureADCurrentSessionInfo
$TenantDomain = $SessionInfo.TenantDomain
$AppDisplayname = 'FGC_PSAutomation_M365SecureApp1' 

$RootCert = Generate-AzADServicePrincipalCert -AppDisplayname $AppDisplayname -TenantDomain $TenantDomain

$ThumbPrint = $RootCert.Thumbprint
$EndDate = $RootCert.NotAfter
$StartDate = $RootCert.NotBefore
$CertValue = [System.Convert]::ToBase64String($RootCert.GetRawCertData())

$GenerateNewAzADServicePrincipal_App_return = Generate-NewAzADServicePrincipal_App -AppDisplayname $AppDisplayname -StartDate $StartDate -EndDate $EndDate -CertValue $CertValue

$ApplicationID = $null
$ApplicationID = $GenerateNewAzADServicePrincipal_App_return.ApplicationId

$ObjectID = $null
# $ObjectID = (Get-AzADApplication -ApplicationId $Script:spn_9001.ApplicationId).ObjectId
$ObjectID = (Get-AzADApplication -ApplicationId $ApplicationID).ObjectId

Update-AzADApplicationProperties -AppDisplayname $AppDisplayname -ObjectID $ObjectID -TenantDomain $TenantDomain


Fault_Tolerance_CleanupModules_PartnerCenter
# Generate-SecureAppModelRefreshToken



$ApplicationSecret = $null
# $ApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $Script:app_9001.ObjectId
$ApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $ObjectID
$ApplicationSecretValue = $ApplicationSecret.Value

Generate-AzureADAppCredential -ApplicationSecret $ApplicationSecretValue -ApplicationID $ApplicationID
# Generate-RefreshToken -TenantID $Script:TenantId_9001 -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint

# $ThumbPrint = Generate-AzADServicePrincipalCert
$Scope = 'https://graph.microsoft.com/.default'
$DBG

$RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken

$ExchangeApplicationID = 'a0c73c16-a7e3-4564-9a95-2bdf47383716'
$ExchangeScope = 'https://outlook.office365.com/.default'
$ExchangeRefreshToken = (Generate-SecureAppModelAccessToken -TenantID $TenantID -ExchangeApplicationID $ExchangeApplicationID -ExchangeScope $ExchangeScope).refreshtoken

Output-SecureAppSecrets -TenantID $TenantID -AppDisplayname $AppDisplayname -ApplicationID $ApplicationID -ApplicationSecretValue $ApplicationSecretValue -Thumprint $ThumbPrint -RefreshToken $RefreshToken -ExchangeRefreshToken $ExchangeRefreshToken
Fault_Tolerance_CleanupAzSessions



#try running this script again and see if it complains about the app already existing if it does then add a fucntion to check if an app exist and then remove all objects related to that app including the service princiapal of the app and the permissions of that app
#actually it did not complain as the display (friendly name) of the app can be the same but the app ID must be different so you can create multiple Azure AD apps with the same display (friendly name)