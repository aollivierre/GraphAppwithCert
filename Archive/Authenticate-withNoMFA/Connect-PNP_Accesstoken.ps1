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

            # $myaccesstoken = "0.AAAAc5Sd4AYaF0eYwVKAZ-qzpPPZ5j5EVZhGnpmbveZ5Ar5RABQ.AgABAAAAAAB2UyzwtQEKR7-rWbgdcBZIAQDs_wIA9P8QXXpf7S8Gpw5rCAmtTIegsFYGRzlTqdqABXoXh8NqUWADlo3W02UA96MN5dV7Fz4dfT7fUTJtLey8aL1r3QetkBjPyxjZK_MUkyYVjeHVZO3hYd-TP9duomTwHwBkdjFMeKJHqdRsZi9LgSFVxVb_lmbGG_tx-3gxiBKF8DRcA_sCDVNR4Tr4UiaDPUYHhkVxD67T1sJvX5xpRnXteRudLULYSbv9JbUpd41_NhLtFI6TaBWlxIRP_3P8l4cmx7C9EXYd-HdDMPv5MjM8ficMrBT3B2hhvrld6vt6rdi6u7ZBM0gtdY8FboX5_i_TU87ocCkAwm3ulzfq6N2bIMR_wqH68MaiVgiilmx53SGNcbqnpRO-2zIoUYqKn2gWK9GsKZ7hzpnXzuayUEeHUUZbDe1t1t_qWzsvjoAul-tWRu3w-TfojoxLEbJPjwfre67gY_ECFphCq3POUMYPfkj7-rHYYfgfJeXIDWcX2iRm9owiqHFxO08j0NTfvQnnpncNpk5OifKGbLmfCJHRr7hYX8MVf-bhfwWvfBGgC2NfwyZ-Pmo8eJc2wJ3-yqRm_Ny-VSIkudL-2rJZiIsOtnu52OK2BVbP_c_M_A-8CHh0lgoVKRxL0Uhxd8U_EBfB-FIisIri5us9N0Oply3EGPGNRvA6Hn5vTY1hYvAnhfOln_4sSg6HMn-XTaRoQfUK-7O3ynMoN6W9gAZV8MmRQB-fitOUveq7hROuQyAceHud90RVep-jPoYPhvYzxunoa99Eu9mLyO_EJ7iUBoeOXLZHhSeYeChgTCo1nkGZWRKQQWcLi4RMJxahDnhseMjdVttTrVOvE9pdL63GJUafmjVWESxOS-w44_wUaugaTVfW4YWW-HSdWIJU-MSg7ENyQk0_m54qG0OF49UxKFUkAt9G_PmSVlGp6ooVYlOkj8W7heqgncY_TVLDRGjh2Jgu_w7-ZIq1KhUYxA-F48Z7F6ZT-68cUwgErjIYHku7mOxffhqefbyN-3tnbv_uHB1ilNqJU5_muIpXdwzgxXCvnAveBuB0165QFZ9DUQ_W89wPj5rnIt6w-6Raxw"

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