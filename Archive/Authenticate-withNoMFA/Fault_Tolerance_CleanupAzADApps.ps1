function Fault_Tolerance_CleanupAzADApps {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppDisplayname
        
    )
    
    begin {
        
    }
    
    process {


        try {


            #AzureAD
            Get-AzureADServicePrincipal | Where-Object { $_.Displayname -eq $AppDisplayname } | Remove-AzureADServicePrincipal
            Get-AzureADApplication | Where-Object { $_.Displayname -eq $AppDisplayname } | Remove-AzureADApplication
            
            #Az
            Get-AzADApplication | Where-Object { $_.Displayname -eq $AppDisplayname } | Remove-AzADApplication
            Get-AzADServicePrincipal | Where-Object { $_.Displayname -eq $AppDisplayname } | 
            Remove-AzADServicePrincipal
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

        Get-AzureADServicePrincipal | Where-Object { $_.Displayname -eq $AppDisplayname }
        Get-AzureADApplication | Where-Object { $_.Displayname -eq $AppDisplayname }
        

        Get-AzADApplication | Where-Object { $_.Displayname -eq $AppDisplayname }
        Get-AzADServicePrincipal | Where-Object { $_.Displayname -eq $AppDisplayname }
        
    }
}

$AppDisplayname = 'FGC_PSAutomation_M365SecureApp1'
Fault_Tolerance_CleanupAzADApps -AppDisplayname $AppDisplayname