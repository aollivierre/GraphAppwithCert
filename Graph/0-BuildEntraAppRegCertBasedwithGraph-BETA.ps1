$global:mode = 'dev'
$global:SimulatingIntune = $false
# $ExitOnCondition = $false

[System.Environment]::SetEnvironmentVariable('EnvironmentMode', $global:mode, 'Machine')
[System.Environment]::SetEnvironmentVariable('EnvironmentMode', $global:mode, 'process')

# Alternatively, use this PowerShell method (same effect)
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'EnvironmentMode' -Value 'dev'

$global:mode = $env:EnvironmentMode
$global:LOG_ASYNC = $false #Enable Async mode (all levels except Warnings, Errors and Criticals are treated as Debug which means they are written to the log file without showing on the console)
$global:LOG_SILENT = $false  # Enable silent mode (all levels are treated as Debug)


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






function Write-BuildEntraAppRegCertBasedLog {
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
    Write-BuildEntraAppRegCertBasedLog -Message "Attempt $attempt to acquire the lock..."

    # Try to acquire the mutex with a timeout
    $acquiredLock = $mutex.WaitOne([TimeSpan]::FromSeconds($initialWaitTime))

    if (-not $acquiredLock) {
        # If lock wasn't acquired, wait for the back-off period before retrying
        Write-BuildEntraAppRegCertBasedLog "Failed to acquire the lock. Retrying in $initialWaitTime seconds..." -Level 'WARNING'
        Start-Sleep -Seconds $initialWaitTime

        # Increase the wait time using the back-off factor
        $initialWaitTime *= $backOffFactor
    }
}

try {
    if ($acquiredLock) {
        Write-BuildEntraAppRegCertBasedLog -Message "Acquired the lock. Proceeding with module installation and import."

        # Start timing the critical section
        $executionTime = [System.Diagnostics.Stopwatch]::StartNew()

        # Critical section starts here

        # Conditional check for dev and prod mode
        if ($global:mode -eq "dev") {
            # In dev mode, import the module from the local path
            Write-BuildEntraAppRegCertBasedLog -Message "Running in dev mode. Importing module from local path."
            Import-Module 'C:\code\ModulesV2\EnhancedModuleStarterAO\EnhancedModuleStarterAO.psm1'
        }
        elseif ($global:mode -eq "prod") {
            # In prod mode, execute the script from the URL
            Write-BuildEntraAppRegCertBasedLog -Message "Running in prod mode. Executing the script from the remote URL."
            # Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")


            # Check if running in PowerShell 5
            if ($PSVersionTable.PSVersion.Major -ne 5) {
                Write-BuildEntraAppRegCertBasedLog -Message "Not running in PowerShell 5. Relaunching the command with PowerShell 5."

                # Reset Module Paths when switching from PS7 to PS5 process
                Reset-ModulePaths

                # Get the path to PowerShell 5 executable
                $ps5Path = "$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

                # Relaunch the Invoke-Expression command with PowerShell 5
                & $ps5Path -Command "Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1')"
            }
            else {
                # If running in PowerShell 5, execute the command directly
                Write-BuildEntraAppRegCertBasedLog -Message "Running in PowerShell 5. Executing the command."
                Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")
            }


        }
        else {
            Write-BuildEntraAppRegCertBasedLog -Message "Invalid mode specified. Please set the mode to either 'dev' or 'prod'." -Level 'WARNING'
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
            Write-BuildEntraAppRegCertBasedLog -Message  "Not running in PowerShell 5. Relaunching the function call with PowerShell 5."

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
            Write-BuildEntraAppRegCertBasedLog -Message "Running in PowerShell 5. Executing Invoke-ModuleStarter."
            Invoke-ModuleStarter @moduleStarterParams
        }

        
        # Critical section ends here
        $executionTime.Stop()

        # Measure the time taken and log it
        $timeTaken = $executionTime.Elapsed.TotalSeconds
        Write-BuildEntraAppRegCertBasedLog -Message "Critical section execution time: $timeTaken seconds"

        # Optionally, log this to a file for further analysis
        # Add-Content -Path "C:\Temp\CriticalSectionTimes.log" -Value "Execution time: $timeTaken seconds - $(Get-Date)"

        Write-BuildEntraAppRegCertBasedLog -Message "Module installation and import completed."
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
        Write-BuildEntraAppRegCertBasedLog -Message "Released the lock."
    }

    # Dispose of the mutex object
    $mutex.Dispose()
}

#endregion FIRING UP MODULE STARTER



#Region Randomly Generating Cert Export Password in Memory
#################################################################################################
#                                                                                               #
#                                 Randomly Generating Cert Export Password in Memory            #
#                                                                                               #
#################################################################################################



$CertPasswordPlain = $null

# Check if the password has already been generated (can be done with a variable check in the script scope)
if (-not $CertPasswordPlain) {
    # If the password doesn't exist, generate a random password for the certificate
    Add-Type -AssemblyName 'System.Web'
    $CertPassword = [System.Web.Security.Membership]::GeneratePassword(128, 2)

    # Convert the random password to a secure string
    $secureCertPassword = ConvertTo-SecureString $CertPassword -AsPlainText -Force

    # Store the plain-text password for use (decrypting when needed)
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureCertPassword)
    $CertPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)

    # Output the length of the password instead of the password itself
    Write-BuildEntraAppRegCertBasedLog -Message "Certificate password has been generated. Length: $($CertPasswordPlain.Length)"
}
else {
    # If the password already exists in memory, confirm its existence by its length
    Write-BuildEntraAppRegCertBasedLog -Message "Certificate password already exists in-memory. Length: $($CertPasswordPlain.Length)"
}

# Now you can use $CertPasswordPlain in your script as the certificate export password

#endregion Randomly Generating Cert Export Password in Memory



#################################################################################################################################
################################################# END VARIABLES #################################################################
#################################################################################################################################


##########################################################################################################################
############################################STARTING THE MAIN FUNCTION LOGIC HERE#########################################
##########################################################################################################################


################################################################################################################################
################################################ START GRAPH CONNECTING ########################################################
################################################################################################################################


# Clear the token cache manually
$global:MgGraphClient = $null
$global:MgGraphTokenCache = $null

Disconnect-Graph
Disconnect-MgGraph -Verbose

Write-Host "Microsoft Graph token cache cleared from the session."




# Path to the scopes.json file
$jsonFilePath = "$PSscriptroot\scopes.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Extract the scopes
$scopes = $jsonContent.Scopes -join " "

# Connect to Microsoft Graph with the specified scopes
# Connect to Graph interactively

# disconnect-Graph

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
    # $appDetails = Create-AppRegistration -AppName $appName -PermsFile "$PSScriptRoot\permissions.json"
    $appDetails = Create-AppRegistration -AppName $appName -PermsFile "$PSScriptRoot\permissions.psd1"

    # Wait-Debugger

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
        PfxPassword = $CertPasswordPlain
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

    # Grant-AdminConsentToApiPermissions -clientId $clientId -SPPermissionsPath $PSScriptRoot







    # Define the App ID of your app registration
    # $appId = "cde88ec5-f074-4fff-8fb4-89d071cd0022"  # Replace with your actual App ID

    # Define the list of redirect URIs you want to add
    $redirectUris = @(
        "http://localhost",
        "https://login.microsoftonline.com/common/oauth2/nativeclient",
        "msalcde88ec5-f074-4fff-8fb4-89d071cd0022://auth",
        "ms-appx-web://microsoft.aad.brokerplugin/cde88ec5-f074-4fff-8fb4-89d071cd0022",
        "urn:ietf:wg:oauth:2.0:oob"
    )

    # Update the application registration to include the new redirect URIs
    Update-MgApplication -ApplicationId $appId -PublicClient @{'RedirectUris' = $redirectUris }

    Write-EnhancedLog -Message "Redirect URIs updated successfully for App ID: $appId"







 

    Add-Type -AssemblyName System.Windows.Forms

    try {
        # Attempt to grant admin consent to the Entra Reg app
        Write-EnhancedLog -Message "Attempting to grant admin consent for client ID: $clientId..." -Level 'INFO'
        Grant-AdminConsentToApiPermissions -clientId $clientId -SPPermissionsPath $PSScriptRoot

        Write-EnhancedLog -Message "Admin consent granted successfully." -Level 'INFO'
    }
    catch {
        # Handle the exception gracefully if admin rights are insufficient
        $errorMessage = "Failed to grant admin consent for client ID: $clientId. Reason: $($_.Exception.Message)"
    
        # Log the error using Write-EnhancedLog
        Write-EnhancedLog -Message $errorMessage -Level 'ERROR'
    
        # Show a friendly GUI reminder to the user with a forced window at the center of the screen
        $message = "Warning: Admin consent requires Global Admin rights. Please ensure you have the necessary permissions to grant admin consent."

        # Create and configure a form for the message box
        $form = New-Object System.Windows.Forms.Form
        $form.StartPosition = 'CenterScreen'
        $form.TopMost = $true
        $form.Width = 400
        $form.Height = 200
        $form.Text = "Warning"

        # Create a label for the warning message
        $label = New-Object System.Windows.Forms.Label
        $label.Text = $message
        $label.AutoSize = $false
        $label.Width = 360
        $label.Height = 80
        $label.Left = 20
        $label.Top = 20
        $label.TextAlign = 'MiddleCenter'
        $label.Font = New-Object System.Drawing.Font("Arial", 10)
        $label.BorderStyle = 'FixedSingle'
        $form.Controls.Add($label)

        # Create an OK button
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Text = "OK"
        $okButton.Left = 150
        $okButton.Top = 110
        $okButton.Width = 100
        $okButton.Add_Click({
                $form.Close()  # Close the form when OK is clicked
            })
        $form.Controls.Add($okButton)

        # Show the form as a modal dialog to ensure it's in the center and top-most
        $form.ShowDialog()

        # Log that the pop-up was shown
        Write-EnhancedLog -Message "Displayed admin consent warning to the user." -Level 'WARNING'
    
        # Continue with the next steps in the script
        Write-EnhancedLog -Message "Proceeding to the next step..." -Level 'INFO'
    }

    # Next steps in your script continue here...


    # Wait-Debugger



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
        CertPassword     = $CertPasswordPlain
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