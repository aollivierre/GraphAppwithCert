$ErrorActionPreference = 'Continue'

function Fault_Tolerance_CleanupAzSessions {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
 
    }
    
    process {

        try {
            
            # # Get-PSSession | Remove-PSSession -Verbose
            # [Void](Get-PSSession | Remove-PSSession)
            # [Void](Disconnect-SPOService)
            # [Void](Get-PSSession | Disconnect-PSSession)
            # # Closes one or more PowerShell sessions
            # [Void](Get-AzContext -ListAvailable:$True | Remove-AzContext -Force)
            # [Void](Get-AzContext -ListAvailable:$True | Clear-AzContext -Force)
            # [Void](Clear-AzContext -Force)
            # [Void](Get-AzContext  -ListAvailable:$True | Disconnect-AzAccount -Scope CurrentUser)
            # [Void](Disconnect-AzAccount -Scope CurrentUser)
            # [Void](Disconnect-AzureAD)
            # [Void](Set-AzContext -Context ([Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]::new()))
            # [Void](Get-AzDefault | Clear-AzDefault)
            # [Void](Disable-AzContextAutosave)

           

               # Get-PSSession | Remove-PSSession -Verbose
               Get-PSSession | Remove-PSSession
            #    Disconnect-SPOService
               Get-PSSession | Disconnect-PSSession
               # Closes one or more PowerShell sessions
               Get-AzContext -ListAvailable:$True | Remove-AzContext -Force
               Get-AzContext -ListAvailable:$True | Clear-AzContext -Force
               Clear-AzContext -Force
               Get-AzContext  -ListAvailable:$True | Disconnect-AzAccount -Scope CurrentUser
            #    Disconnect-AzAccount -Scope CurrentUser
            #    Disconnect-AzureAD
               Set-AzContext -Context ([Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]::new())
            #    Get-AzDefault | Clear-AzDefault
               Disable-AzContextAutosave
        }
        catch {

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

            
        }
        finally {
            
        }
        
    }
    
    end {

        Write-host 'Cleaned up All Az sessions' -ForegroundColor Green
        
    }
}

# Fault_Tolerance_CleanupAzSessions


