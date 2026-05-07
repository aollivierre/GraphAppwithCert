. "$PSScriptRoot\Generate-RefreshToken.ps1"
. "$PSScriptRoot\Secure_App_Model_Exchange(Step3).ps1"

function Connect-PNP_ServicePrincipalCert {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Orgname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ThumbPrint,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Tenant,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ClientID

    )
    
    begin {
        
    }
    
    process {


        try {


            #Example
            # Connect-PnPOnline -ClientId  -CertificatePath 'c:\mycertificate.pfx' -CertificatePassword (ConvertTo-SecureString -AsPlainText 'myprivatekeypassword' -Force) -Url https://contoso.sharepoint.com -Tenant 'contoso.onmicrosoft.com'

            # $ClientCertificate = (Get-ChildItem -Path Cert:\CurrentUser\My\$Thumbprint)

            # $ClientCertificate = Get-ChildItem $CertStoreLocation | Where-Object { $_.Subject -match $Subject }
            $URL = "https://$Orgname-admin.sharepoint.com"
            # $URL = "https://$Orgname.sharepoint.com"
            # Connect-SPOService -Url $URL

            # $Session = Connect-PnPOnline -Url $URL -ClientCertificate $ClientCertificate
            $Session = Connect-PnPOnline -Url $URL -Thumbprint $ThumbPrint -Tenant $Tenant

            # Connect-PnPOnline -Url https://contoso.sharepoint.com -ClientId '' -Tenant 'contoso.onmicrosoft.com' -Thumbprint 34CFAA860E5FB8C44335A38A097C1E41EEA206AA
            # Connect-PnPOnline -Url https:// -ClientId '' -Tenant 'contoso.onmicrosoft.com' -Thumbprint 34CFAA860E5FB8C44335A38A097C1E41EEA206AA

            # $myaccesstoken = "<OAUTH_REFRESH_TOKEN_PLACEHOLDER>"

            # $AccessToken.AccessToken


            # $token = Request-PnPAccessToken -ClientId $ApplicationID -Resource $URL -Credentials (Get-Credential) -TenantUrl $URL
            # $token = Request-PnPAccessToken -ClientId $ApplicationID -Resource $URL -TenantUrl $URL
            # Connect-PnPOnline -AccessToken $token

        #    $Session = Connect-PnPOnline -Url $URL -AccessToken $AccessToken


            
            
        }
        catch {
            
            Write-Error 'An Error happened when Conneting to SPO Service.. script execution will be halted'
         
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

        return $Session
        
    }
}


# $Thumbprint = '3A16F907D2BFFF1C22F447E55429C16F8BD3AC6E'
# $Subject = 'FGC_PSAutomation_M365SecureApp1'
# $CertStoreLocation = "Cert:\CurrentUser\My"
$Orgname = 'FGCHealth'
$Tenant = 'FGCHealth.onmicrosoft.com'

# $TenantID = 'e09d9473-1a06-4717-98c1-528067eab3a4'
$ApplicationID = '3ee6d9f3-5544-4698-9e99-9bbde67902be'
$ThumbPrint = '94544DFEA2D0862CB06A34F6AA59D9AC53592782'


# $Scope = 'https://management.azure.com/user_impersonation'
# $RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken

# $Scope = 'https://graph.microsoft.com/.default'
# $AccessToken = (Generate-AccessToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope -Refreshtoken $RefreshToken).AccessToken


# Connect-PNP_ServicePrincipalCert -Orgname $Orgname -CertStoreLocation $CertStoreLocation -Subject $Subject
Connect-PNP_ServicePrincipalCert -Orgname $Orgname -ThumbPrint $ThumbPrint -Tenant $Tenant -ClientID $ApplicationID
# Connect-PNP_ServicePrincipalCert -Orgname $Orgname
# Connect-PNP_ServicePrincipalCert -Orgname $Orgname -AccessToken $AccessToken
# Connect-PNP_ServicePrincipalCert -Orgname $Orgname -ApplicationID $ApplicationID

Get-PnPSite
Get-PnPContext


