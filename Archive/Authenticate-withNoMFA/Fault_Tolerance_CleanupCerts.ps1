function Fault_Tolerance_CleanupCerts {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Subject,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertStoreLocation
        
    )
    
    begin {
        
    }
    
    process {


        try {


            #Delete by thumbprint
            # Get-ChildItem Cert:\LocalMachine\My\D20159B7772E33A6A33E436C938C6FE764367396 | Remove-Item

            #Delete by subject/serialnumber/issuer/whatever
            Get-ChildItem $CertStoreLocation | Where-Object { $_.Subject -match $Subject } | Remove-Item
            
        }
        catch {
            
            Write-Error 'An Error happened when Cleaning up Certs .. script execution will be halted'
         
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
        
    }
}


$Subject = 'FGC_PSAutomation_M365SecureApp1'
$CertStoreLocation = "Cert:\CurrentUser\My"
Fault_Tolerance_CleanupCerts -subject $Subject -CertStoreLocation $CertStoreLocation