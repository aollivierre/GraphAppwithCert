function Fault_Tolerance_CleanupModules_PartnerCenter {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {


        try {
            # Azure Partner Center
            # Install-Module -Name "PartnerCenter" -Verbose -Force -AllowClobber -Scope CurrentUser
            Install-Module -Name "PartnerCenter" -Force -AllowClobber -Scope CurrentUser
            # Import-Module -Name "PartnerCenter" -Verbose -Force
            Import-Module -Name "PartnerCenter" -Force
            Get-Module -Name "PartnerCenter"-ListAvailable | Select-object Name, Version, ModuleBase

            # Find-Module PartnerCenter -AllowPrerelease -AllVersions
        }
        catch {

            Write-Error 'There was an error with CleaningupModules and Reinstalling Partner Center Modules ... halting execution'

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
            
        }
        finally {
            
        }
        
    }
    
    end {
        
    }
}




# Fault_Tolerance_CleanupModules_PartnerCenter

