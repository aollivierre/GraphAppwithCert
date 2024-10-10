$global:mode = 'dev'
$global:SimulatingIntune = $false
# $ExitOnCondition = $false

[System.Environment]::SetEnvironmentVariable('EnvironmentMode', $global:mode, 'Machine')
[System.Environment]::SetEnvironmentVariable('EnvironmentMode', $global:mode, 'process')

# Alternatively, use this PowerShell method (same effect)
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'EnvironmentMode' -Value 'dev'

$global:mode = $env:EnvironmentMode
$global:LOG_ASYNC = $false


# Toggle based on the environment mode
switch ($mode) {
    'dev' {
        Write-Host "Running in development mode" -ForegroundColor Yellow
        # Your development logic here
    }
    'prod' {
        Write-Host "Running in production mode" -ForegroundColor Green
        # Your production logic here
    }
    default {
        Write-Host "Unknown mode. Defaulting to production." -ForegroundColor Red
        # Default to production
    }
}






function Write-BuildEntraAppRegCertBased {
    param (
        [string]$Message,
        [string]$Level = "INFO",
        [switch]$Async = $false  # Control whether logging should be async or not
    )

    # Check if the Async switch is not set, then use the global variable if defined
    if (-not $Async) {
        $Async = $global:LOG_ASYNC
    }

    # Get the PowerShell call stack to determine the actual calling function
    $callStack = Get-PSCallStack
    $callerFunction = if ($callStack.Count -ge 2) { $callStack[1].Command } else { '<Unknown>' }

    # Prepare the formatted message with the actual calling function information
    $formattedMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] [$callerFunction] $Message"

    if ($Async) {
        # Enqueue the log message for async processing
        $logItem = [PSCustomObject]@{
            Level        = $Level
            Message      = $formattedMessage
            FunctionName = $callerFunction
        }
        $global:LogQueue.Enqueue($logItem)
    }
    else {
        # Display the log message based on the log level using Write-Host
        switch ($Level.ToUpper()) {
            "DEBUG" { Write-Host $formattedMessage -ForegroundColor DarkGray }
            "INFO" { Write-Host $formattedMessage -ForegroundColor Green }
            "NOTICE" { Write-Host $formattedMessage -ForegroundColor Cyan }
            "WARNING" { Write-Host $formattedMessage -ForegroundColor Yellow }
            "ERROR" { Write-Host $formattedMessage -ForegroundColor Red }
            "CRITICAL" { Write-Host $formattedMessage -ForegroundColor Magenta }
            default { Write-Host $formattedMessage -ForegroundColor White }
        }

        # Append to log file synchronously
        $logFilePath = [System.IO.Path]::Combine($env:TEMP, 'setupAADMigration.log')
        $formattedMessage | Out-File -FilePath $logFilePath -Append -Encoding utf8
    }
}



#region FIRING UP MODULE STARTER
#################################################################################################
#                                                                                               #
#                                 FIRING UP MODULE STARTER                                      #
#                                                                                               #
#################################################################################################


# Wait-Debugger

# Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")

# Wait-Debugger

# Import-Module 'C:\code\ModulesV2\EnhancedModuleStarterAO\EnhancedModuleStarterAO.psm1'

# Define a hashtable for splatting
# $moduleStarterParams = @{
#     Mode                   = $global:mode
#     SkipPSGalleryModules   = $false
#     SkipCheckandElevate    = $false
#     SkipPowerShell7Install = $false
#     SkipEnhancedModules    = $false
#     SkipGitRepos           = $true
# }

# # Call the function using the splat
# Invoke-ModuleStarter @moduleStarterParams


# Define the mutex name (should be the same across all scripts needing synchronization)
$mutexName = "Global\MyCustomMutexForModuleInstallation"

# Create or open the mutex
$mutex = [System.Threading.Mutex]::new($false, $mutexName)

# Set initial back-off parameters
$initialWaitTime = 5       # Initial wait time in seconds
$maxAttempts = 10           # Maximum number of attempts
$backOffFactor = 2         # Factor to increase the wait time for each attempt

$attempt = 0
$acquiredLock = $false

# Try acquiring the mutex with dynamic back-off
while (-not $acquiredLock -and $attempt -lt $maxAttempts) {
    $attempt++
    Write-BuildEntraAppRegCertBased -Message "Attempt $attempt to acquire the lock..."

    # Try to acquire the mutex with a timeout
    $acquiredLock = $mutex.WaitOne([TimeSpan]::FromSeconds($initialWaitTime))

    if (-not $acquiredLock) {
        # If lock wasn't acquired, wait for the back-off period before retrying
        Write-BuildEntraAppRegCertBased "Failed to acquire the lock. Retrying in $initialWaitTime seconds..." -Level 'WARNING'
        Start-Sleep -Seconds $initialWaitTime

        # Increase the wait time using the back-off factor
        $initialWaitTime *= $backOffFactor
    }
}

try {
    if ($acquiredLock) {
        Write-BuildEntraAppRegCertBased -Message "Acquired the lock. Proceeding with module installation and import."

        # Start timing the critical section
        $executionTime = [System.Diagnostics.Stopwatch]::StartNew()

        # Critical section starts here

        # Conditional check for dev and prod mode
        if ($global:mode -eq "dev") {
            # In dev mode, import the module from the local path
            Write-BuildEntraAppRegCertBased -Message "Running in dev mode. Importing module from local path."
            Import-Module 'C:\code\ModulesV2\EnhancedModuleStarterAO\EnhancedModuleStarterAO.psm1'
        }
        elseif ($global:mode -eq "prod") {
            # In prod mode, execute the script from the URL
            Write-BuildEntraAppRegCertBased -Message "Running in prod mode. Executing the script from the remote URL."
            # Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")


            # Check if running in PowerShell 5
            if ($PSVersionTable.PSVersion.Major -ne 5) {
                Write-BuildEntraAppRegCertBased -Message "Not running in PowerShell 5. Relaunching the command with PowerShell 5."

                # Reset Module Paths when switching from PS7 to PS5 process
                Reset-ModulePaths

                # Get the path to PowerShell 5 executable
                $ps5Path = "$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

                # Relaunch the Invoke-Expression command with PowerShell 5
                & $ps5Path -Command "Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1')"
            }
            else {
                # If running in PowerShell 5, execute the command directly
                Write-BuildEntraAppRegCertBased -Message "Running in PowerShell 5. Executing the command."
                Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")
            }


        }
        else {
            Write-BuildEntraAppRegCertBased -Message "Invalid mode specified. Please set the mode to either 'dev' or 'prod'." -Level 'WARNING'
            exit 1
        }

        # Optional: Wait for debugger if needed
        # Wait-Debugger


        # Define a hashtable for splatting
        $moduleStarterParams = @{
            Mode                   = $global:mode
            SkipPSGalleryModules   = $false
            SkipCheckandElevate    = $false
            SkipPowerShell7Install = $false
            SkipEnhancedModules    = $false
            SkipGitRepos           = $true
        }

        # Check if running in PowerShell 5
        if ($PSVersionTable.PSVersion.Major -ne 5) {
            Write-BuildEntraAppRegCertBased -Message  "Not running in PowerShell 5. Relaunching the function call with PowerShell 5."

            # Get the path to PowerShell 5 executable
            $ps5Path = "$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"


            Reset-ModulePaths

            # Relaunch the Invoke-ModuleStarter function call with PowerShell 5
            & $ps5Path -Command {
                # Recreate the hashtable within the script block for PowerShell 5
                $moduleStarterParams = @{
                    Mode                   = 'prod'
                    SkipPSGalleryModules   = $false
                    SkipCheckandElevate    = $false
                    SkipPowerShell7Install = $false
                    SkipEnhancedModules    = $false
                    SkipGitRepos           = $true
                }
                Invoke-ModuleStarter @moduleStarterParams
            }
        }
        else {
            # If running in PowerShell 5, execute the function directly
            Write-BuildEntraAppRegCertBased -Message "Running in PowerShell 5. Executing Invoke-ModuleStarter."
            Invoke-ModuleStarter @moduleStarterParams
        }

        
        # Critical section ends here
        $executionTime.Stop()

        # Measure the time taken and log it
        $timeTaken = $executionTime.Elapsed.TotalSeconds
        Write-BuildEntraAppRegCertBased -Message "Critical section execution time: $timeTaken seconds"

        # Optionally, log this to a file for further analysis
        # Add-Content -Path "C:\Temp\CriticalSectionTimes.log" -Value "Execution time: $timeTaken seconds - $(Get-Date)"

        Write-BuildEntraAppRegCertBased -Message "Module installation and import completed."
    }
    else {
        Write-Warning "Failed to acquire the lock after $maxAttempts attempts. Exiting the script."
        exit 1
    }
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    # Release the mutex if it was acquired
    if ($acquiredLock) {
        $mutex.ReleaseMutex()
        Write-BuildEntraAppRegCertBased -Message "Released the lock."
    }

    # Dispose of the mutex object
    $mutex.Dispose()
}

#endregion FIRING UP MODULE STARTER


#fix permissions of the client app to add Intune permissions

# Load the secrets from the JSON file
#First, load secrets and create a credential object:
# Assuming secrets.json is in the same directory as your script
# $certsecretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.json"

# # Load the secrets from the JSON file
# $certsecrets = Get-Content -Path $certsecretsPath -Raw | ConvertFrom-Json

# #  Variables from JSON file
# $CertPassword = $certsecrets.certexportpassword








# Define the path to the PSD1 file for storing cert secrets
$certsecretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.psd1"

# Check if the PSD1 file exists
if (-Not (Test-Path -Path $certsecretsPath)) {
    # If the file doesn't exist, prompt the user for the cert secret
    $CertPassword = Read-Host -AsSecureString "Enter the certificate export password"

    # Convert the secure string to an encrypted standard string for storage
    $CertPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CertPassword)
    )

    # Create a hashtable to store the cert secret
    $certsecrets = @{
        certexportpassword = $CertPasswordPlain
    }

    # Save the hashtable to a PSD1 file
    $certsecrets | Export-Clixml -Path $certsecretsPath
    Write-Host "Cert secrets stored in '$certsecretsPath'."
}
else {
    # Load the secrets from the PSD1 file
    $certsecrets = Import-Clixml -Path $certsecretsPath

    # Extract the certificate password
    $CertPassword = $certsecrets.certexportpassword
}

# Now you can use $CertPassword in your script


#################################################################################################################################
################################################# END VARIABLES #################################################################
#################################################################################################################################


##########################################################################################################################
############################################STARTING THE MAIN FUNCTION LOGIC HERE#########################################
##########################################################################################################################


################################################################################################################################
################################################ START GRAPH CONNECTING ########################################################
################################################################################################################################
# Path to the scopes.json file
$jsonFilePath = "$PSscriptroot\scopes.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Extract the scopes
$scopes = $jsonContent.Scopes -join " "

# Connect to Microsoft Graph with the specified scopes
# Connect to Graph interactively
disconnect-Graph
Disconnect-MgGraph -Verbose
disconnect-Graph

# Call the function to connect to Microsoft Graph
Connect-ToMicrosoftGraphIfServerCore -Scopes $scopes




# $dbg


# Get the tenant details
$tenantDetails = $null
$tenantDetails = Get-TenantDetails
if ($null -eq $tenantDetails) {
    Write-EnhancedLog -Message "Unable to proceed without tenant details" -Level "ERROR"
    throw "Tenant Details name is empty. Cannot proceed without a valid tenant details"
    exit
}

#################################################################################################################################
################################################# END Connecting to Graph #######################################################
#################################################################################################################################

#Endregion #########################################DEALING WITH MODULES########################################################

# Example usage
$jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "applist.json"
Remove-AppListJson -jsonPath $jsonPath


Remove-AppRegistrationsAndDeletedItems -AppDisplayNamePattern "*graphapp-test*"

# Validate certificate creation

# Main script execution
Write-EnhancedLog -Message "Script Started" -Level "INFO"

try {
    # Get the unique app name
    $appName = Get-AppName -AppJsonFile "$PSScriptRoot\app.json"


    $params = @{
        Appname = $appName
    }
    Log-Params -Params $params

    # Validate that the app does not already exist
    Write-EnhancedLog -Message 'first validation'
    # Run-DumpAppListToJSON -JsonPath $jsonPath
    $appExists = Validate-AppCreation -AppName $appName -JsonPath $jsonPath
    # $DBG
    if ($appExists) {
        Write-EnhancedLog -Message "App already exists" -Level "ERROR"
        throw "App already exists"
    }
    else {
        Write-EnhancedLog -Message "App does not exist" -Level "INFO"
    }

    # Create the app registration
    $appDetails = Create-AppRegistration -AppName $appName -PermsFile "$PSScriptRoot\permissions.json"
    $app = $appDetails.App
    $apptenantDetails = $null
    $apptenantDetails = $appDetails.TenantDetails

    # Write-EnhancedLog -Message 'calling Validate-AppCreationWithRetry for the second validation'
    # Validate-AppCreationWithRetry -AppName $AppName -JsonPath $JsonPath
    

    # Create the self-signed certificate with tenant and app details
    # Create the folder structure based on tenant name and tenant ID
    # $tenantFolder = Join-Path -Path $PSScriptRoot -ChildPath "$($tenantDetails.DisplayName)_$($tenantDetails.Id)"
    $tenantFolder = Join-Path -Path $PSScriptRoot -ChildPath "$($apptenantDetails.DisplayName)"
    # $secretsFolder = Join-Path -Path "$tenantFolder" -ChildPath "secrets"

    # # Check if the folder exists
    # if (Test-Path -Path "$secretsFolder") {
    #     # Remove the existing folder and its contents
    #     Remove-Item -Path "$secretsFolder" -Recurse -Force
    #     Write-Host "Removed existing secrets folder: $secretsFolder"
    # }
    
    # # Create a new folder
    # New-Item -ItemType Directory -Path "$secretsFolder" -Force | Out-Null
    # Write-Host "Created new secrets folder: $secretsFolder"
    


    # $Certname = "GraphCert-$($tenantDetails.DisplayName)-$($app.AppId)"
    $Certname = "GraphCert-$($apptenantDetails.DisplayName)"
    # Define the parameters as a hashtable
    $params = @{
        CertName    = $Certname
        TenantName  = $apptenantDetails.DisplayName
        AppId       = $app.AppId
        # OutputPath  = "$secretsFolder"
        OutputPath  = "$tenantFolder"
        PfxPassword = $certPassword
    }

    # $DBG

    # Call the function using splatting
    #Create and Export *.PFX and *.key files for the actual graph connection later on OUTSIDE of this script
    $cert = Create-SelfSignedCert @params

    # $DBG

    $thumbprint = $cert.Thumbprint

    # Call the function with the required parameters
    # Define the variables
    $certThumbprint = $thumbprint

    #Export the CERT to a *.CER file to associatae with the new Entra ID App reg (however when you connect you need to use *.PFX format of that file if not using the cert from the store)
    $certPath = ExportCertificatetoCER -CertThumbprint $certThumbprint -ExportDirectory $tenantFolder -Certname $Certname

    # $DBG

    # Output the exported certificate path
    Write-EnhancedLog -Message "The certificate was exported to: $certPath" -Level "INFO"

    # Validate the certificate creation
    Validate-CertCreation -Thumbprint $thumbprint

    $params = @{
        certPath = $certPath
    }
    Log-Params -Params $params


    # Define the application ID and certificate path
    $appId = $app.id
    $clientId = $app.AppId
  
    # Call the function to Associate the Cert With App
    Add-KeyCredentialToApp -AppId $appId -CertPath $certPath

    Grant-AdminConsentToApiPermissions -clientId $clientId -SPPermissionsPath $PSScriptRoot

    # # Open the certificate store

    # Call the function
    Open-CertificateStore


    # Output the secrets
    # Define the parameters as a hashtable
    $SecretsFile = Join-Path -Path $tenantFolder -ChildPath "secrets.json"

    $params = $null
    $params = @{
        AppDisplayName   = $app.DisplayName
        ApplicationID    = $app.AppId
        TenantID         = $tenantDetails.TenantId
        SecretsFile      = $secretsfile
        CertName         = $Certname
        Thumbprint       = $thumbprint
        CertPassword     = $CertPassword
        TenantName       = $tenantDetails.TenantName
        TenantDomainName = $tenantDetails.tenantDomain
        OutputPath       = $tenantFolder
    }

    # Call the function using splatting
    Output-Secrets @params



    # Define the destination path
    $destinationPath = "C:\code\Intune-Win32-Deployer\secrets"

    # Check if the tenant folder exists
    if (-Not (Test-Path -Path $tenantFolder)) {
        Write-Error "The specified tenant folder '$tenantFolder' does not exist."
        throw "Invalid tenant folder"
    }

    # # Get the folder name from the tenant folder path
    # $tenantFolderName = Split-Path -Path $tenantFolder -Leaf

    # # Define the full destination path for the tenant folder
    # $fullDestinationPath = Join-Path -Path $destinationPath -ChildPath $tenantFolderName

    # Copy the tenant folder to the destination
    try {
        Copy-Item -Path $tenantFolder -Destination $destinationPath -Recurse -Force
        Write-Host "Successfully copied '$tenantFolder' to '$destinationPath'."
    }
    catch {
        Write-Error "Failed to copy the tenant folder: $_"
        throw
    }





    Write-EnhancedLog -Message "Script Completed Successfully" -Level "INFO"
}
catch {
    Write-EnhancedLog -Message "Script failed: $_" -Level "ERROR"
    Handle-Error -ErrorRecord $_
}