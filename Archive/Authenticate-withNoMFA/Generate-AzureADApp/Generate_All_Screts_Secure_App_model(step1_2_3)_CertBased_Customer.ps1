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
    
        
        $NewSelfSigned_ROOT_CertificateParam = $null
        $NewSelfSigned_ROOT_CertificateParam = @{

            Type              = 'custom'
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
        Write-Host 'a Base64 String from the Root Cert has been created' -foregroundcolor green
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

        $newAzADServicePrincipalSplat = $null
        $newAzADServicePrincipalSplat = @{
            DisplayName = $AppDisplayname
            EndDate     = $EndDate
            StartDate   = $StartDate
            CertValue   = $CertValue
        }
        
    }
    
    process {

        try {
        
            write-host 'a new service principal is now being created' $spn_9001 -ForegroundColor Green
        

            $spn_9001 = $null
            $spn_9001 = New-AzADServicePrincipal @newAzADServicePrincipalSplat #this automatically create an app as well if you do not specify an existing app
            
            write-host 'a new service principal is now created' $spn_9001 -ForegroundColor Green

            Start-Sleep 20
        }
        catch {

            Write-Error 'There was an error with Creating the new Az AD Service Principal and creating the new Azure AD app... halting execution'

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

            #endregion CatchAll

            exit
            
        }
        finally {
            
        }
        
    }
    
    end {
        return $spn_9001
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
    )
    begin {
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

    }
    
    process {

        try {

    
            $ErrorActionPreference = "Stop"
            Write-Host -ForegroundColor Green "updating the Azure AD application and related resources..."

            $newAzureADApplicationSplat_9001 = $null
            $newAzureADApplicationSplat_9001 = @{
                ObjectID                = $ObjectID
                AvailableToOtherTenants = $true
                DisplayName             = $AppDisplayname
                IdentifierUris          = "https://$($TenantDomain)/$((New-Guid).ToString())" #also known as Application ID URI
 
                RequiredResourceAccess  = $graphAppAccess_9001
                ReplyUrls               = @("urn:ietf:wg:oauth:2.0:oob", "https://localhost", "http://localhost", "http://localhost:8400") #also known as Redirect URI
            }

            set-AzureADApplication @newAzureADApplicationSplat_9001
            Start-Sleep 20
      
    
        }
    
   
        catch {
    
            # Write-Error 'There was an error with Updating AzADApplicationProperties... halting execution'

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

            #endregion CatchAll

            exit

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
        [string]$ObjectID
    )
    
    begin {
        
    }
    
    process {

        try {

            $ApplicationSecret = $null
            $ApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $ObjectID
            
            # Write-host 'Converting the password APP secret to a secure string' -ForegroundColor Green
            # $PasswordToSecureString_9001 = $null
            # $PasswordToSecureString_9001 = $ApplicationSecretValue | ConvertTo-SecureString -asPlainText -Force
            
    
            # Write-host 'Creating the Application Credential object containing the APP ID and the APP secret' -ForegroundColor Green
            # $AppCredential = $null
            # $AppCredential = New-Object System.Management.Automation.PSCredential($ApplicationID, $PasswordToSecureString_9001)
        }
        catch {
            
        }
        finally {
            
        }
        
    }
    
    end {

        return $ApplicationSecret
        
    }
}
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
    }
    
    process {


        try {

            write-host "Please approve Exchange consent form." -ForegroundColor Green
            
            $ExchangeToken = $null
            $ExchangeToken = New-PartnerAccessToken @newPartnerAccessTokenSplat_Exchangetoken_9001

            write-host "Last initation required: Please browse to https://login.microsoftonline.com/$($TenantID)/adminConsent?client_id=$($ApplicationID)"
            write-host "Press any key after auth. An error report about incorrect URIs is expected!"
            [void][System.Console]::ReadKey($true)

            
        }
        catch {

            Write-Error 'An Error happened when Generating an Access token.. script execution will be halted'

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
            AppDisplayname         = $AppDisplayname
            ApplicationID_ClientID = $ApplicationID
            ApplicationSecret      = $ApplicationSecretValue

            CertSubject            = $RootCert.Subject
            CertThumbprint         = $Thumprint
            TenantID_9001          = $TenantID
            RefreshToken           = $RefreshToken
            ExchangeRefreshToken   = $ExchangeRefreshToken
        }
        
    }
    
    process {

        try {
            
            Write-Host "================ Secrets ================"
            Write-Host "`$AppDisplayname        = $($AppDisplayname)"
            Write-Host "`$ApplicationID_ClientID          = $($ApplicationID)"
            Write-Host "`$ApplicationSecretValue     = $($ApplicationSecretValue)"
            Write-Host "`$Thumprint     = $($Thumbprint)"
            Write-Host "`$TenantID        = $TenantID"
            write-host "`$RefreshToken          = $($RefreshToken)" -ForegroundColor Blue
            write-host "`$Exchange RefreshToken = $($ExchangeRefreshToken)" -ForegroundColor Green
            Write-Host "================ Secrets ================"
            Write-Host "    SAVE THESE IN A SECURE LOCATION     " 



        }
        catch {

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
            
        }
        finally {
            
        }
        
    }
    
    end {
        
        # return $Secure_App_Model_Secrets_Object_9001
    }
}

#Set your Global Parameters below
#Yes you can dynamically get these parameters intead of statically setting them but if the Dynamic function breaks for whatever reason those Global Parameters will then be missing and cause the entire script fail so you need to be smart about being really specific to avoid issues espicially with connecting the main service like Azure as you may have mutiple subscriptions

$subscriptionID = '408a6c03-bd25-471b-ae84-cf82b3dff420' #Microsoft Azure Sponsorship
$TenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' #Canada Computing Azure AD Tenant
$AccountID = 'Admin-Abdullah@canadacomputing.ca'
$AppDisplayname = 'CCI_Send_Email_6'
$Scope = 'https://graph.microsoft.com/.default'
$ExchangeApplicationID = 'a0c73c16-a7e3-4564-9a95-2bdf47383716'
$ExchangeScope = 'https://outlook.office365.com/.default'

Fault_Tolerance_CleanupAzSessions

$fault_Tolerance_ConnectAzAccountwithContextSplat = @{
    TenantID       = $TenantID
    subscriptionID = $subscriptionID
}

Fault_Tolerance_Connect-AzAccountwithContext @fault_Tolerance_ConnectAzAccountwithContextSplat
    
$fault_Tolerance_ConnectAzureADfromAzContextSplat = @{
    TenantID  = $TenantID
    AccountID = $AccountID
}
    
Fault_Tolerance_Connect-AzureADfromAzContext @fault_Tolerance_ConnectAzureADfromAzContextSplat
    
$SessionInfo = $null
$SessionInfo = Get-AzureADCurrentSessionInfo
$TenantDomain = $SessionInfo.TenantDomain


$generateAzADServicePrincipalCertSplat = @{
    AppDisplayname = $AppDisplayname
    TenantDomain   = $TenantDomain
}

$RootCert = Generate-AzADServicePrincipalCert @generateAzADServicePrincipalCertSplat
# $RootCert

$StartDate = [datetime]::Parse($RootCert.GetEffectiveDateString())
$StartDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($StartDate, [System.TimeZoneInfo]::Local.Id, 'GMT Standard Time')

$EndDate = [datetime]::Parse($RootCert.GetExpirationDateString())
$EndDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($EndDate, [System.TimeZoneInfo]::Local.Id, 'GMT Standard Time')

$ThumbPrint = $RootCert.Thumbprint
# $EndDate = $RootCert.NotAfter
# $StartDate = $RootCert.NotBefore

# $StartDate = [System.DateTime]::Now
# $EndDate = $StartDate.AddYears(1)

$CertValue = [System.Convert]::ToBase64String($RootCert.GetRawCertData())

$generateNewAzADServicePrincipal_AppSplat = @{
    AppDisplayname = $AppDisplayname
    StartDate      = $StartDate
    EndDate        = $EndDate
    CertValue      = $CertValue
}
$GenerateNewAzADServicePrincipal_App_return = Generate-NewAzADServicePrincipal_App @generateNewAzADServicePrincipal_AppSplat

$ApplicationID = $null
$ApplicationID = $GenerateNewAzADServicePrincipal_App_return.ApplicationId

$ObjectID = $null
$ObjectID = (Get-AzADApplication -ApplicationId $ApplicationID).ObjectId

#!Todo - Insufficient privileges to complete the following operation. will need to look into it
$updateAzADApplicationPropertiesSplat = @{
    AppDisplayname = $AppDisplayname
    ObjectID       = $ObjectID
    TenantDomain   = $TenantDomain
}

Update-AzADApplicationProperties @updateAzADApplicationPropertiesSplat

Fault_Tolerance_CleanupModules_PartnerCenter

$ApplicationSecret = $null
$ApplicationSecret = Generate-AzureADAppCredential -ObjectID $ObjectID
$ApplicationSecretValue = $ApplicationSecret.Value

$RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken


$ExchangeRefreshToken = (Generate-SecureAppModelAccessToken -TenantID $TenantID -ExchangeApplicationID $ExchangeApplicationID -ExchangeScope $ExchangeScope).refreshtoken

$outputSecureAppSecretsSplat = @{
    TenantID             = $TenantID
    AppDisplayname       = $AppDisplayname
    ApplicationID        = $ApplicationID
    ApplicationSecret    = $ApplicationSecretValue
    Thumprint            = $ThumbPrint
    RefreshToken         = $RefreshToken
    ExchangeRefreshToken = $ExchangeRefreshToken
}

Output-SecureAppSecrets @outputSecureAppSecretsSplat
Fault_Tolerance_CleanupAzSessions

# Get-MsalToken -ClientId '42ef544e-182d-459e-ad74-c8982d5d45c6' -Scope 'https://graph.microsoft.com/Mail.send' -RedirectUri 'http://localhost:8400' -ClientSecret 'ljHWESA27XIanM/ktRMGH5p5VmxrLeZ9tNjNnkmyUTg='


# Get-MsalToken -ClientId '0d32e246-74a4-4930-af3f-4972652d75bb' -Scope 'https://graph.microsoft.com/Mail.send' -RedirectUri 'http://localhost:8400' -ClientSecret '9Ifl1NCGNlytwF8F62mwROkSRypwLvvOIlzWMPTJJpc='

# $getMsalTokenSplat = @{
#     ClientId     = '0d32e246-74a4-4930-af3f-4972652d75bb'
#     Scopes       = 'https://graph.microsoft.com/.default'
#     RedirectUri  = 'http://localhost:8400'
#     ClientSecret = (ConvertTo-SecureString '9Ifl1NCGNlytwF8F62mwROkSRypwLvvOIlzWMPTJJpc=' -AsPlainText -Force)
# }

# Get-MsalToken @getMsalTokenSplat


