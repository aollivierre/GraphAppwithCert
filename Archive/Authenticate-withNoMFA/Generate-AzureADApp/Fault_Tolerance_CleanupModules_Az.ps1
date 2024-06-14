function Fault_Tolerance_CleanupModules_Az  {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
        try {
            

            if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
                Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
                  'Az modules installed at the same time is not supported.')
            } else {
                Install-Module -Name 'Az' -AllowClobber -Scope AllUsers -force
                # Import-Module -Name 'Az' -Verbose -Force
                Import-Module -Name 'Az' -Force
            Get-Module -Name 'Az'-ListAvailable | Select-object Name, Version, Modulebase
            }
            
            
            
            $PSVersionTable.PSVersion
            Get-module Az | Select-Object name, Version, ModuleBase
            Import-Module Az
            Find-module Az -AllowPrerelease -AllVersions
            Install-Module Az -Force
            Install-Module -Name Az -AllowPrerelease
        }
        catch {
            
        }
        finally {
            
        }
    }
    
    end {
        
    }
}



# Fault_Tolerance_CleanupModules_Az