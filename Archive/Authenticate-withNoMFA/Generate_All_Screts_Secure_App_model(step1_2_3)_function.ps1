function Generate-AzureADAppServicePrincipal {
    [CmdletBinding()]
    Param 
    ( 
        [Parameter(Mandatory = $false)]
        [switch]$ConfigurePreconsent,
        [Parameter(Mandatory = $true)]
        [string]$DisplayName_9001,
        [Parameter(Mandatory = $false)]
        [string]$Script:TenantId_9001
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
        
        $partnerCenterAppAccess_9001 = $null
        $partnerCenterAppAccess_9001 = [Microsoft.Open.AzureAD.Model.RequiredResourceAccess]@{
            ResourceAppId  = "fa3d9a0c-3fb0-42cc-9193-47c7ecd2edbd";
            ResourceAccess =
            [Microsoft.Open.AzureAD.Model.ResourceAccess]@{
                Id   = "1cebfa2a-fb4d-419e-b5f9-839b4383e05a";
                Type = "Scope"
            }
        }

        $Script:AppDisplayName_9001 = $null
        $Script:AppDisplayName_9001 = $DisplayName_9001

    }
    
    process {

        try {

    
            $ErrorActionPreference = "Stop"

            # Check if the Azure AD PowerShell module has already been loaded.
            if ( ! ( Get-Module AzureAD ) ) {
                # Check if the Azure AD PowerShell module is installed.
                if ( Get-Module -ListAvailable -Name AzureAD ) {
                    # The Azure AD PowerShell module is not load and it is installed. This module
                    # must be loaded for other operations performed by this script.
                    Write-Host -ForegroundColor Green "Loading the Azure AD PowerShell module..."
                    Import-Module AzureAD
                }
                else {
                    Install-Module AzureAD
                }
            }

            try {
                Write-Host -ForegroundColor Green "When prompted please enter the appropriate credentials... Warning: Window might have pop-under in VSCode"

                if ([string]::IsNullOrEmpty($Script:TenantId_9001)) {
                    Connect-AzureAD | Out-Null

                    $Script:TenantId_9001 = $null
                    $Script:TenantId_9001 = $(Get-AzureADTenantDetail).ObjectId
                }
                else {
                    Connect-AzureAD -TenantId $Script:TenantId_9001 | Out-Null
                }
            }
            catch [Microsoft.Azure.Common.Authentication.AadAuthenticationCanceledException] {
                # The authentication attempt was canceled by the end-user. Execution of the script should be halted.
                Write-Host -ForegroundColor Yellow "The authentication attempt was canceled. Execution of the script will be halted..."
                Exit
            }
            catch {
                # An unexpected error has occurred. The end-user should be notified so that the appropriate action can be taken.
                Write-Error "An unexpected error has occurred. Please review the following error message and try again." `
                    "$($Error[0].Exception)"
            }


            $SessionInfo_9001 = $null
            $SessionInfo_9001 = Get-AzureADCurrentSessionInfo

            Write-Host -ForegroundColor Green "Creating the Azure AD application and related resources..."

            $newAzureADApplicationSplat_9001 = $null
            $newAzureADApplicationSplat_9001 = @{
                AvailableToOtherTenants = $true
                DisplayName             = $Script:AppDisplayName_9001
                IdentifierUris          = "https://$($SessionInfo_9001.TenantDomain)/$((New-Guid).ToString())" #also known as Application ID URI
                # RequiredResourceAccess  = $adAppAccess_9001, $graphAppAccess_9001, $partnerCenterAppAccess_9001
                RequiredResourceAccess  = $graphAppAccess_9001, $partnerCenterAppAccess_9001
                ReplyUrls               = @("urn:ietf:wg:oauth:2.0:oob", "https://localhost", "http://localhost", "http://localhost:8400") #also known as Redirect URI
            }

            $Script:app_9001 = $null
            $Script:app_9001 = New-AzureADApplication @newAzureADApplicationSplat_9001

            $Script:password_9001 = $null
            $Script:password_9001 = New-AzureADApplicationPasswordCredential -ObjectId $Script:app_9001.ObjectId
            
            $Script:spn_9001 = $null
            $Script:spn_9001 = New-AzureADServicePrincipal -AppId $Script:app_9001.AppId -DisplayName $DisplayName_9001

            #commenting the following when creating an AAD app in a customers's tenant
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

function Generate-SecureAppModelRefreshToken {
    [CmdletBinding()]
    param (
        
    )
    
    begin {


        Write-host 'Converting the password APP secret to a secure string' -ForegroundColor Green
        $PasswordToSecureString_9001 = $null
        $PasswordToSecureString_9001 = $Script:password_9001.value | ConvertTo-SecureString -asPlainText -Force
        

        Write-host 'Creating the Application Credential object containing the APP ID and the APP secret' -ForegroundColor Green
        $Script:credential_9001 = $null
        $Script:credential_9001 = New-Object System.Management.Automation.PSCredential($($Script:app_9001.AppId), $PasswordToSecureString_9001)

        $newPartnerAccessTokenSplat_9001 = $null
        $newPartnerAccessTokenSplat_9001 = @{
            ApplicationId        = "$($app_9001.AppId)"
            Scopes               = 'https://api.partnercenter.microsoft.com/user_impersonation'
            ServicePrincipal     = $true
            Credential           = $Script:credential_9001
            Tenant               = $($Script:spn_9001.AppOwnerTenantID)
            UseAuthorizationCode = $true
        }
        
    }
    
    process {
        
        try {
            
            
            write-host "Installing PartnerCenter Module." -ForegroundColor Green
            install-module PartnerCenter -Force
            write-host "Sleeping for 30 seconds to allow app creation on O365" -foregroundcolor green
            start-sleep 30
            write-host "Please approve General consent form." -ForegroundColor Green

            $Script:Consent_token_9001 = $null
            $Script:Consent_token_9001 = New-PartnerAccessToken @newPartnerAccessTokenSplat_9001

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

function Generate-SecureAppModelAccessToken {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

        $newPartnerAccessTokenSplat_Exchangetoken_9001 = $null
        $newPartnerAccessTokenSplat_Exchangetoken_9001 = @{
            ApplicationId           = 'a0c73c16-a7e3-4564-9a95-2bdf47383716'
            Scopes                  = 'https://outlook.office365.com/.default'
            Tenant                  = $($spn_9001.AppOwnerTenantID)
            UseDeviceAuthentication = $true
        }

        
    }
    
    process {


        try {

            write-host "Please approve Exchange consent form." -ForegroundColor Green
            
            $Script:Exchange_token_9001 = $null
            $Script:Exchange_token_9001 = New-PartnerAccessToken @newPartnerAccessTokenSplat_Exchangetoken_9001

            write-host "Last initation required: Please browse to https://login.microsoftonline.com/$($spn_9001.AppOwnerTenantID)/adminConsent?client_id=$($app_9001.AppId)"
            write-host "Press any key after auth. An error report about incorrect URIs is expected!"
            [void][System.Console]::ReadKey($true)

            
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

function Output-SecureAppSecrets {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

        Write-Host 'storing Secure App Model Secrets in an object '

        $Secure_App_Model_Secrets_Object_9001 = $null
        $Secure_App_Model_Secrets_Object_9001 = [PSCustomObject]@{
            AppDisplayname       = $Script:AppDisplayName_9001
            ApplicationId        = $Script:app_9001.AppId
            ApplicationSecret    = $Script:password_9001.Value
            TenantID_9001        = $Script:spn_9001.AppOwnerTenantID
            RefreshToken         = $Script:Consent_token_9001.refreshtoken
            ExchangeRefreshToken = $Script:Exchange_Token_9001.Refreshtoken
        }
        
    }
    
    process {

        try {
            
            Write-Host "================ Secrets ================"
            Write-Host "`$AppDisplayname        = $($Script:AppDisplayName_9001)"
            Write-Host "`$ApplicationId         = $($Script:app_9001.AppId)"
            Write-Host "`$ApplicationSecret     = $($Script:password_9001.Value)"
            Write-Host "`$TenantID        = $($Script:spn_9001.AppOwnerTenantID)"
            write-host "`$RefreshToken          = $($Script:Consent_token_9001.refreshtoken)" -ForegroundColor Blue
            write-host "`$Exchange RefreshToken = $($Script:Exchange_Token_9001.Refreshtoken)" -ForegroundColor Green
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
        
    }
}

Generate-AzureADAppServicePrincipal -DisplayName_9001 'FGC_PSAutomation_M365SecureApp1'
Generate-SecureAppModelRefreshToken
Generate-SecureAppModelAccessToken
Output-SecureAppSecrets




#try running this script again and see if it complains about the app already existing if it does then add a fucntion to check if an app exist and then remove all objects related to that app including the service princiapal of the app and the permissions of that app
#actually it did not complain as the display (friendly name) of the app can be the same but the app ID must be different so you can create multiple Azure AD apps with the same display (friendly name)
