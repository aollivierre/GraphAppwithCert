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
        $AccessToken
        # [Parameter(Mandatory = $true)]
        # [ValidateNotNullOrEmpty()]
        # [String]
        # $ApplicationID
        # [Parameter(Mandatory = $true)]
        # [ValidateNotNullOrEmpty()]
        # [String]
        # $CertStoreLocation
        
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

            # Connect-PnPOnline -Url $URL -ClientCertificate $ClientCertificate

            # $myaccesstoken = "<REDACTED-REFRESH-TOKEN>"

            # $AccessToken.AccessToken


            # $token = Request-PnPAccessToken -ClientId $ApplicationID -Resource $URL -Credentials (Get-Credential) -TenantUrl $URL
            # $token = Request-PnPAccessToken -ClientId $ApplicationID -Resource $URL -TenantUrl $URL
            # Connect-PnPOnline -AccessToken $token

           $Session = Connect-PnPOnline -Url $URL -AccessToken $AccessToken


            
            
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
$Orgname = 'CanadaComputing'

$TenantID = 'e09d9473-1a06-4717-98c1-528067eab3a4'
$ApplicationID = '0d32e246-74a4-4930-af3f-4972652d75bb'
$ThumbPrint = '94544DFEA2D0862CB06A34F6AA59D9AC53592782'


$Scope = 'https://management.azure.com/user_impersonation'
$RefreshToken = (Generate-RefreshToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope).Refreshtoken

$Scope = 'https://graph.microsoft.com/.default'
$AccessToken = (Generate-AccessToken -TenantID $TenantID -ApplicationID $ApplicationID -ThumbPrint $ThumbPrint -Scope $Scope -Refreshtoken $RefreshToken).AccessToken


# Connect-PNP_ServicePrincipalCert -Orgname $Orgname -CertStoreLocation $CertStoreLocation -Subject $Subject
# Connect-PNP_ServicePrincipalCert -Orgname $Orgname
Connect-PNP_ServicePrincipalCert -Orgname $Orgname -AccessToken $AccessToken
# Connect-PNP_ServicePrincipalCert -Orgname $Orgname -ApplicationID $ApplicationID

Get-PnPSite
Get-PnPContext


#! Connecting with -Accestoken seems to be broken of this version of PNP Module as it returns the following error
# Get-PnPSite : The current connection holds no SharePoint context. Please use one of the Connect-PnPOnline commands which uses the 
# -Url argument to connect.
# At C:\Users\Abdullah.Ollivierre\AzureRepos2\Unified365toolbox\Authenticate-withNoMFA\Connect-PNP_ServicePrincipalCert.ps1:132 char:1  
# + Get-PnPSite
# + ~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (:) [Get-PnPSite], InvalidOperationException
#     + FullyQualifiedErrorId : System.InvalidOperationException,PnP.PowerShell.Commands.Site.GetSite