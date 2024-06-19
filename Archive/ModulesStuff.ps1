# Function to validate if a module is available
function Validate-Module {
    param (
        [string]$ModuleName
    )
    return (Get-Module -ListAvailable -Name $ModuleName) -ne $null
}

# Function to install required modules
function Install-Modules {
    param (
        [array]$Modules
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    foreach ($module in $Modules) {
        if (-not (Validate-Module -ModuleName $module)) {
            Write-EnhancedLog -Message "Installing module: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
            Install-Module -Name $module -Force -scope
            Write-EnhancedLog -Message "Module: $module has been installed" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        }
        else {
            Write-EnhancedLog -Message "Module $module is already installed" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        }

        # Validate after installation
        if (Validate-Module -ModuleName $module) {
            Write-EnhancedLog -Message "Validation successful: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }
        else {
            Write-EnhancedLog -Message "Validation failed: $module" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        }
    }
}

# Function to import required modules
function Import-Modules {
    param (
        [array]$Modules
    )

    foreach ($module in $Modules) {
        if (Validate-Module -ModuleName $module) {
            Write-EnhancedLog -Message "Importing module: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
            Import-Module -Name $module
            Write-EnhancedLog -Message "Module: $module has been imported" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

            # Validate after importing
            if (Validate-Module -ModuleName $module) {
                Write-EnhancedLog -Message "Validation successful: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
            }
            else {
                Write-EnhancedLog -Message "Validation failed: $module" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
            }
        }
    }
}

# Main script execution
function Main {
    # Read modules from module.json file
    $moduleJsonPath = "$PSscriptroot/modules.json"
    if (Test-Path -Path $moduleJsonPath) {
        $moduleData = Get-Content -Path $moduleJsonPath | ConvertFrom-Json
        $requiredModules = $moduleData.requiredModules
        $importedModules = $moduleData.importedModules

        # Validate, Install, and Import Modules
        Install-Modules -Modules $requiredModules
        Import-Modules -Modules $importedModules
    }
    else {
        Write-EnhancedLog -Message "module.json file not found." -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}

# Execute main function
Main
