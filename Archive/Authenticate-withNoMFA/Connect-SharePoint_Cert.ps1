. "$PSScriptRoot\Generate-RefreshToken.ps1"
. "$PSScriptRoot\Generate-AccessToken.ps1"

function Connect-SharePoint_Cert {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $URL,
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

            $Session = Connect-PnPOnline -Url $URL -Thumbprint $ThumbPrint -Tenant $Tenant -ClientID $ApplicationID
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


$Orgname = 'CanadaComputing'
# $Site = 'sites/UAT_Dealroom'
# $URL = "https://$Orgname-admin.sharepoint.com/$Site"
# $URL = "https://$Orgname.sharepoint.com/$Site"
$URL = "https://$Orgname-admin.sharepoint.com/"
$Tenant = "$Orgname.onmicrosoft.com"
$ApplicationID = 'ef10965f-e08c-410a-a7c7-759fde63edd1'
$ThumbPrint = 'C61A21E209614FD67D4B4D9CCDBA34BDB6C7C47C'

Connect-SharePoint_Cert -URL $URL -ThumbPrint $ThumbPrint -Tenant $Tenant -ClientID $ApplicationID

Get-PnPSite
Get-PnPContext


