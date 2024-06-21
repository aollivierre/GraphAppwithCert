# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         # Get the logged-in user for the Graph API session
#         Write-EnhancedLog -Message "Fetching current user information from Microsoft Graph API." -Level "INFO"
#         $currentUserResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/me" -Method GET
#         Write-EnhancedLog -Message "Response from Microsoft Graph API: $($currentUserResponse | ConvertTo-Json -Compress)" -Level "DEBUG"

#         $currentUser = $currentUserResponse

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath | Out-Null
#         }

#         # Define certificate subject details
#         $Issuer  = "CN=$($currentUser.DisplayName)-$($currentUser.userPrincipalName)"
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId-$Issuer/L=City/ST=State/C=US"
        

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"
#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout $certKeyPath -out $certCrtPath -subj '$subject'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"
#         Invoke-Expression $opensslCmd

#         # Check if certificate files were created
#         if (-not (Test-Path -Path $certKeyPath) -or -not (Test-Path -Path $certCrtPath)) {
#             Write-EnhancedLog -Message "Failed to create certificate using OpenSSL" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"

#         # Convert the certificate and key to PFX format
#         $opensslPfxCmd = "openssl pkcs12 -export -out $pfxFilePath -inkey $certKeyPath -in $certCrtPath -passout pass:$PfxPassword"
#         Write-EnhancedLog -Message "Running OpenSSL command to convert certificate to PFX format: $opensslPfxCmd" -Level "INFO"
#         Invoke-Expression $opensslPfxCmd

#         # Check if the PFX file was created
#         if (-not (Test-Path -Path $pfxFilePath)) {
#             Write-EnhancedLog -Message "Failed to create PFX file using OpenSSL" -Level "ERROR"
#             throw "PFX file creation failed"
#         }

#         Write-EnhancedLog -Message "PFX file created successfully at $pfxFilePath" -Level "INFO"

#         # Import the PFX file into the certificate store if needed
#         if ($CertStoreLocation) {
#             $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
#             $cert = Import-PfxCertificate -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
#             Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
#         } else {
#             $cert = $null
#         }

#         return $cert

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_ 
#         throw $_
#     }
# }






# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         # Get the logged-in user for the Graph API session
#         Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] Fetching current user information from Microsoft Graph API."
#         $currentUserResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/me" -Method GET
#         Write-Output "[$(Get-Date)] [DEBUG] [Function: Create-SelfSignedCertOpenSSL] Response from Microsoft Graph API: $($currentUserResponse | ConvertTo-Json -Compress)"

#         $currentUser = $currentUserResponse

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($currentUser.DisplayName)-$($currentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"
#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] Running OpenSSL command to generate certificate: $opensslCmd"

#         $opensslOutput = Invoke-Expression -Command $opensslCmd 2>&1
#         if ($LASTEXITCODE -ne 0) {
#             Write-Output "[$(Get-Date)] [ERROR] [Function: Create-SelfSignedCertOpenSSL] OpenSSL command failed with output: $opensslOutput"
#             throw "Certificate creation failed"
#         }

#         Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] Certificate created successfully using OpenSSL"

#         # Convert the certificate and key to PFX format
#         $opensslPfxCmd = "openssl pkcs12 -export -out `"$pfxFilePath`" -inkey `"$certKeyPath`" -in `"$certCrtPath`" -passout pass:$PfxPassword"
#         Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] Running OpenSSL command to convert certificate to PFX format: $opensslPfxCmd"

#         $opensslPfxOutput = Invoke-Expression -Command $opensslPfxCmd 2>&1
#         if ($LASTEXITCODE -ne 0) {
#             Write-Output "[$(Get-Date)] [ERROR] [Function: Create-SelfSignedCertOpenSSL] OpenSSL PFX command failed with output: $opensslPfxOutput"
#             throw "PFX file creation failed"
#         }

#         Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] PFX file created successfully at $pfxFilePath"

#         # Import the PFX file into the certificate store if needed
#         if ($CertStoreLocation) {
#             $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
#             $cert = Import-PfxCertificate -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
#             Write-Output "[$(Get-Date)] [INFO] [Function: Create-SelfSignedCertOpenSSL] Certificate imported successfully into store location $CertStoreLocation"
#         } else {
#             $cert = $null
#         }

#         return $cert

#     } catch {
#         Write-Output "[$(Get-Date)] [ERROR] [Function: Create-SelfSignedCertOpenSSL] An error occurred while creating the self-signed certificate: $_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw $_
#     }
# }






# We'll create the following functions:

# Get-CurrentUser
# Generate-Certificate
# Convert-CertificateToPfx
# Import-PfxCertificateToStore
# Create-SelfSignedCertOpenSSL




function Get-CurrentUser {
    try {
        Write-EnhancedLog -Message "Fetching current user information from Microsoft Graph API." -Level "INFO"
        $currentUserResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/me" -Method GET
        Write-EnhancedLog -Message "Response from Microsoft Graph API: $($currentUserResponse | ConvertTo-Json -Compress)" -Level "DEBUG"
        return $currentUserResponse
    } catch {
        Write-EnhancedLog -Message "An error occurred while fetching the current user information." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}



# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId-$Issuer/L=City/ST=State/C=US"
        

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $opensslOutput = Invoke-Expression -Command $opensslCmd 2>&1
#         if ($LASTEXITCODE -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with output: $opensslOutput" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }




# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $opensslOutput = & $opensslCmd 2>&1
#         $exitCode = $LASTEXITCODE
#         Write-EnhancedLog -Message "OpenSSL command output: $opensslOutput" -Level "DEBUG"

#         if ($exitCode -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $exitCode" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }



# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $processInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $processInfo.FileName = "/bin/bash"
#         $processInfo.Arguments = "-c `"$opensslCmd`""
#         $processInfo.RedirectStandardOutput = $true
#         $processInfo.RedirectStandardError = $true
#         $processInfo.UseShellExecute = $false
#         $processInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $processInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode). Error: $stderr" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL. Output: $stdout" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $processInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $processInfo.FileName = "/bin/bash"
#         $processInfo.Arguments = "-c `"$opensslCmd`""
#         $processInfo.RedirectStandardOutput = $true
#         $processInfo.RedirectStandardError = $true
#         $processInfo.UseShellExecute = $false
#         $processInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $processInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-EnhancedLog -Message "Standard Output: $stdout" -Level "DEBUG"
#         Write-EnhancedLog -Message "Standard Error: $stderr" -Level "DEBUG"

#         if ($process.ExitCode -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode)" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         # Execute the command and capture output and errors
#         $opensslOutput = Invoke-Expression -Command $opensslCmd 2>&1

#         Write-EnhancedLog -Message "OpenSSL Output: $opensslOutput" -Level "DEBUG"

#         # Check for errors in the output
#         if ($LASTEXITCODE -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $LASTEXITCODE" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         $opensslCmd = "openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `'$subject`'"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-EnhancedLog -Message "OpenSSL Output: $stdout" -Level "DEBUG"
#         Write-EnhancedLog -Message "OpenSSL Error: $stderr" -Level "DEBUG"

#         if ($process.ExitCode -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode)" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }






# function Generate-Certificate {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-EnhancedLog -Message "Certificate Subject: $subject" -Level "DEBUG"
#         Write-EnhancedLog -Message "Certificate Issuer: $Issuer" -Level "DEBUG"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         # Step-by-step command construction
#         $cmdPart1 = "openssl req -x509 -nodes -days 30"
#         $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         $cmdPart3 = "-out `"$certCrtPath`""
#         $cmdPart4 = "-subj `'$subject`'"

#         $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
#         Write-EnhancedLog -Message "Running OpenSSL command to generate certificate: $opensslCmd" -Level "INFO"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "/bin/bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-EnhancedLog -Message "OpenSSL Output: $stdout" -Level "DEBUG"
#         Write-EnhancedLog -Message "OpenSSL Error: $stderr" -Level "DEBUG"

#         if ($process.ExitCode -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode)" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }



# function Generate-Certificate {
#     param (
#         [string]$CertName = "DummyCert",
#         [string]$TenantName = "DummyTenant",
#         [string]$AppId = "DummyAppId",
#         [string]$OutputPath = "/workspaces/graphappwithcert/dummy",  # Adjust path as needed
#         [PSCustomObject]$CurrentUser = @{
#             DisplayName = "DummyUser"
#             userPrincipalName = "dummy@domain.com"
#         }
#     )

#     try {
#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: $subject"
#         Write-Host "Certificate Issuer: $Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         # Step-by-step command construction
#         $cmdPart1 = "openssl req -x509 -nodes -days 30"
#         $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         $cmdPart3 = "-out `"$certCrtPath`""
#         $cmdPart4 = "-subj `'$subject`'"

#         $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: $opensslCmd"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "/bin/bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-Host "OpenSSL Output: $stdout"
#         Write-Host "OpenSSL Error: $stderr"

#         if ($process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host $_.Exception.Message
#         throw $_
#     }
# }

# # Test the function with dummy values
# # Generate-Certificate










# function Generate-Certificate {
#     param (
#         [string]$CertName = "DummyCert",
#         [string]$TenantName = "DummyTenant",
#         [string]$AppId = "DummyAppId",
#         [string]$OutputPath = "/desired/output/path",  # Replace with actual output path
#         [PSCustomObject]$CurrentUser = @{
#             DisplayName = "DummyUser"
#             userPrincipalName = "dummy@domain.com"
#         }
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: $subject"
#         Write-Host "Certificate Issuer: $Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         # Step-by-step command construction
#         $cmdPart1 = "openssl req -x509 -nodes -days 30"
#         $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         $cmdPart3 = "-out `"$certCrtPath`""
#         $cmdPart4 = "-subj `'$subject`'"

#         $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: $opensslCmd"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "/bin/bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-Host "OpenSSL Output: $stdout"
#         Write-Host "OpenSSL Error: $stderr"

#         if ($process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"
#         return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host $_.Exception.Message
#         throw $_
#     }
# }

# Test the function with updated output path
# Generate-Certificate








# function Generate-Certificate {
#     param (
#         [string]$CertName = "DummyCert",
#         [string]$TenantName = "DummyTenant",
#         [string]$AppId = "DummyAppId",
#         [string]$OutputPath = "/workspaces/graphappwithcert/dummy",  # Adjust path as needed
#         [string]$RealCertName,
#         [string]$RealTenantName,
#         [string]$RealAppId,
#         [PSCustomObject]$CurrentUser = @{
#             DisplayName = "DummyUser"
#             userPrincipalName = "dummy@domain.com"
#         }
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: $subject"
#         Write-Host "Certificate Issuer: $Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         # Step-by-step command construction
#         $cmdPart1 = "openssl req -x509 -nodes -days 30"
#         $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         $cmdPart3 = "-out `"$certCrtPath`""
#         $cmdPart4 = "-subj `'$subject`'"

#         $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: $opensslCmd"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "/bin/bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-Host "OpenSSL Output: $stdout"
#         Write-Host "OpenSSL Error: $stderr"

#         if ($process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         # Rename files to real values
#         $realCertKeyPath = Join-Path -Path $OutputPath -ChildPath "$RealCertName-$RealAppId.key"
#         $realCertCrtPath = Join-Path -Path $OutputPath -ChildPath "$RealCertName-$RealAppId.crt"

#         Rename-Item -Path $certKeyPath -NewName $realCertKeyPath
#         Rename-Item -Path $certCrtPath -NewName $realCertCrtPath

#         Write-Host "Files renamed successfully to real values"
#         return @{ KeyPath = $realCertKeyPath; CrtPath = $realCertCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host $_.Exception.Message
#         throw $_
#     }
# }

# Example call with dummy and real values
# Generate-Certificate -RealCertName "RealCertName" -RealTenantName "RealTenantName" -RealAppId "RealAppId"







# function Generate-Certificate {
#     param (
#         [string]$CertName = "DummyCert",
#         [string]$TenantName = "DummyTenant",
#         [string]$AppId = "DummyAppId",
#         [string]$OutputPath = "/workspaces/graphappwithcert/dummy",  # Adjust path as needed
#         [string]$RealCertName,
#         [string]$RealTenantName,
#         [string]$RealAppId,
#         [PSCustomObject]$CurrentUser = @{
#             DisplayName = "DummyUser"
#             userPrincipalName = "dummy@domain.com"
#         }
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
#         $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: $subject"
#         Write-Host "Certificate Issuer: $Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
#         $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

#         # Step-by-step command construction
#         $cmdPart1 = "openssl req -x509 -nodes -days 30"
#         $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         $cmdPart3 = "-out `"$certCrtPath`""
#         $cmdPart4 = "-subj `'$subject`'"

#         $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: $opensslCmd"

#         $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         $startInfo.FileName = "/bin/bash"
#         $startInfo.Arguments = "-c `"$opensslCmd`""
#         $startInfo.RedirectStandardOutput = $true
#         $startInfo.RedirectStandardError = $true
#         $startInfo.UseShellExecute = $false
#         $startInfo.CreateNoWindow = $true

#         $process = New-Object System.Diagnostics.Process
#         $process.StartInfo = $startInfo
#         $process.Start() | Out-Null

#         $stdout = $process.StandardOutput.ReadToEnd()
#         $stderr = $process.StandardError.ReadToEnd()

#         $process.WaitForExit()

#         Write-Host "OpenSSL Output: $stdout"
#         Write-Host "OpenSSL Error: $stderr"

#         if ($process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         # Rename files to real values
#         $realCertKeyPath = Join-Path -Path $OutputPath -ChildPath "$RealCertName-$RealAppId.key"
#         $realCertCrtPath = Join-Path -Path $OutputPath -ChildPath "$RealCertName-$RealAppId.crt"

#         Rename-Item -Path $certKeyPath -NewName $realCertKeyPath
#         Rename-Item -Path $certCrtPath -NewName $realCertCrtPath

#         Write-Host "Files renamed successfully to real values"
#         return @{ KeyPath = $realCertKeyPath; CrtPath = $realCertCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host $_.Exception.Message
#         throw $_
#     }
# }







# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser,
#         [string]$RealCertName,
#         [string]$RealTenantName,
#         [string]$RealAppId
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName = "DummyCert",
#         [string]`$TenantName = "DummyTenant",
#         [string]`$AppId = "DummyAppId",
#         [string]`$OutputPath,
#         [string]`$RealCertName,
#         [string]`$RealTenantName,
#         [string]`$RealAppId,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=DummyCert-DummyAppId/O=DummyTenant/OU=DummyAppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "DummyCert-DummyAppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "DummyCert-DummyAppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         `$cmdPart3 = "-out `"$certCrtPath`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"$opensslCmd`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         # Rename files to real values
#         `$realCertKeyPath = Join-Path -Path `$OutputPath -ChildPath "$RealCertName-$RealAppId.key"
#         `$realCertCrtPath = Join-Path -Path `$OutputPath -ChildPath "$RealCertName-$RealAppId.crt"

#         Rename-Item -Path `$certKeyPath -NewName `$realCertKeyPath
#         Rename-Item -Path `$certCrtPath -NewName `$realCertCrtPath

#         Write-Host "Files renamed successfully to real values"
#         return @{ KeyPath = `$realCertKeyPath; CrtPath = `$realCertCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName "DummyCert" -TenantName "DummyTenant" -AppId "DummyAppId" -OutputPath `"$OutputPath`" -RealCertName `"$RealCertName`" -RealTenantName `"$RealTenantName`" -RealAppId `"$RealAppId`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }











# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser,
#         [string]$RealCertName,
#         [string]$RealTenantName,
#         [string]$RealAppId
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName = "DummyCert",
#         [string]`$TenantName = "DummyTenant",
#         [string]`$AppId = "DummyAppId",
#         [string]`$OutputPath,
#         [string]`$RealCertName,
#         [string]`$RealTenantName,
#         [string]`$RealAppId,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"${certKeyPath}`""
#         `$cmdPart3 = "-out `"${certCrtPath}`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"$opensslCmd`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         # Rename files to real values
#         `$realCertKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.key"
#         `$realCertCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.crt"

#         Rename-Item -Path `$certKeyPath -NewName `$realCertKeyPath
#         Rename-Item -Path `$certCrtPath -NewName `$realCertCrtPath

#         Write-Host "Files renamed successfully to real values"
#         return @{ KeyPath = `$realCertKeyPath; CrtPath = `$realCertCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName "DummyCert" -TenantName "DummyTenant" -AppId "DummyAppId" -OutputPath `"$OutputPath`" -RealCertName `"$RealCertName`" -RealTenantName `"$RealTenantName`" -RealAppId `"$RealAppId`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }



# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser,
#         [string]$RealCertName,
#         [string]$RealTenantName,
#         [string]$RealAppId
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName = "DummyCert",
#         [string]`$TenantName = "DummyTenant",
#         [string]`$AppId = "DummyAppId",
#         [string]`$OutputPath,
#         [string]`$RealCertName,
#         [string]`$RealTenantName,
#         [string]`$RealAppId,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         `$cmdPart3 = "-out `"$certCrtPath`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"$opensslCmd`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         # Rename files to real values
#         `$realCertKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.key"
#         `$realCertCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.crt"

#         Rename-Item -Path `$certKeyPath -NewName `$realCertKeyPath -Force
#         Rename-Item -Path `$certCrtPath -NewName `$realCertCrtPath -Force

#         Write-Host "Files renamed successfully to real values"
#         return @{ KeyPath = `$realCertKeyPath; CrtPath = `$realCertCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName "DummyCert" -TenantName "DummyTenant" -AppId "DummyAppId" -OutputPath `"$OutputPath`" -RealCertName `"$RealCertName`" -RealTenantName `"$RealTenantName`" -RealAppId `"$RealAppId`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }





# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName,
#         [string]`$TenantName,
#         [string]`$AppId,
#         [string]`$OutputPath,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"${certKeyPath}`""
#         `$cmdPart3 = "-out `"${certCrtPath}`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"$opensslCmd`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         return @{ KeyPath = `$certKeyPath; CrtPath = `$certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName `"$CertName`" -TenantName `"$TenantName`" -AppId `"$AppId`" -OutputPath `"$OutputPath`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }






# # Define dummy parameters for testing
# $CertName = "DummyCert"
# $TenantName = "DummyTenant"
# $AppId = "DummyAppId"
# $OutputPath = "/workspaces/graphappwithcert/dummy"
# $CurrentUser = [PSCustomObject]@{
#     DisplayName = "DummyUser"
#     userPrincipalName = "dummy@domain.com"
# }
# $RealCertName = "RealCertName"
# $RealTenantName = "RealTenantName"
# $RealAppId = "RealAppId"

# # Call the function with dummy values
# Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $CurrentUser -RealCertName $RealCertName -RealTenantName $RealTenantName -RealAppId $RealAppId






















# function Convert-CertificateToPfx {
#     param (
#         [string]$CertKeyPath,
#         [string]$CertCrtPath,
#         [string]$PfxPath,
#         [string]$PfxPassword
#     )

#     try {
#         $opensslPfxCmd = "openssl pkcs12 -export -out `"$PfxPath`" -inkey `"$CertKeyPath`" -in `"$CertCrtPath`" -passout pass:$PfxPassword"
#         Write-EnhancedLog -Message "Running OpenSSL command to convert certificate to PFX format: $opensslPfxCmd" -Level "INFO"

#         $opensslPfxOutput = Invoke-Expression -Command $opensslPfxCmd 2>&1
#         if ($LASTEXITCODE -ne 0) {
#             Write-EnhancedLog -Message "OpenSSL PFX command failed with output: $opensslPfxOutput" -Level "ERROR"
#             throw "PFX file creation failed"
#         }

#         Write-EnhancedLog -Message "PFX file created successfully at $PfxPath" -Level "INFO"
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while converting the certificate to PFX format." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





function Convert-CertificateToPfx {
    param (
        [string]$CertKeyPath,
        [string]$CertCrtPath,
        [string]$PfxPath,
        [string]$PfxPassword
    )

    try {
        $opensslPfxCmd = "openssl pkcs12 -export -out `"$PfxPath`" -inkey `"$CertKeyPath`" -in `"$CertCrtPath`" -passout pass:$PfxPassword"
        Write-EnhancedLog -Message "Running OpenSSL command to convert certificate to PFX format: $opensslPfxCmd" -Level "INFO"

        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = "/bin/bash"
        $processInfo.Arguments = "-c `"$opensslPfxCmd`""
        $processInfo.RedirectStandardOutput = $true
        $processInfo.RedirectStandardError = $true
        $processInfo.UseShellExecute = $false
        $processInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        $process.Start() | Out-Null

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        Write-EnhancedLog -Message "Standard Output: $stdout" -Level "DEBUG"
        Write-EnhancedLog -Message "Standard Error: $stderr" -Level "DEBUG"

        if ($process.ExitCode -ne 0) {
            Write-EnhancedLog -Message "OpenSSL PFX command failed with exit code $($process.ExitCode)" -Level "ERROR"
            throw "PFX file creation failed"
        }

        Write-EnhancedLog -Message "PFX file created successfully at $PfxPath" -Level "INFO"
    } catch {
        Write-EnhancedLog -Message "An error occurred while converting the certificate to PFX format." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}



function Import-PfxCertificateToStore {
    param (
        [string]$PfxPath,
        [string]$PfxPassword,
        [string]$CertStoreLocation
    )

    try {
        $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
        $cert = Import-PfxCertificate -FilePath $PfxPath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
        Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
        return $cert
    } catch {
        Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}




# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         $currentUser = Get-CurrentUser

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }


#         Write-EnhancedLog -Message "calling Generate-Certificate" -Level "INFO"
#         $certPaths = Generate-Certificate -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $currentUser
#         Write-EnhancedLog -Message "Done calling Generate-Certificate" -Level "INFO"

#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

#         if ($PSVersionTable.OS -match "Windows") {
#             try {
#                 $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
#                 $cert = Import-PfxCertificateToStore -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
#                 Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
#             } catch {
#                 Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
#                 Handle-Error -ErrorRecord $_
#                 throw $_
#             }
#         } else {
#             Write-EnhancedLog -Message "Running on a non-Windows OS, skipping the import of the PFX certificate to the store." -Level "INFO"
#             $cert = $null
#         }

#         return $cert
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }















# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         $currentUser = Get-CurrentUser

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         Write-EnhancedLog -Message "calling Generate-Certificate" -Level "INFO"
#         $certPaths = Generate-Certificate -CertName "DummyCert" -TenantName "DummyTenant" -AppId "DummyAppId" -OutputPath $OutputPath -RealCertName $CertName -RealTenantName $TenantName -RealAppId $AppId -CurrentUser $currentUser
#         Write-EnhancedLog -Message "Done calling Generate-Certificate" -Level "INFO"

#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

#         if ($PSVersionTable.OS -match "Windows") {
#             try {
#                 $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
#                 $cert = Import-PfxCertificateToStore -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
#                 Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
#             } catch {
#                 Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
#                 Handle-Error -ErrorRecord $_
#                 throw $_
#             }
#         } else {
#             Write-EnhancedLog -Message "Running on a non-Windows OS, skipping the import of the PFX certificate to the store." -Level "INFO"
#             $cert = $null
#         }

#         return $cert
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }















# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         $currentUser = Get-CurrentUser

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         $certPaths = Generate-Certificate -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $currentUser
#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

#         if ($CertStoreLocation) {
#             $cert = Import-PfxCertificateToStore -PfxPath $pfxFilePath -PfxPassword $PfxPassword -CertStoreLocation $CertStoreLocation
#         } else {
#             $cert = $null
#         }

#         return $cert
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }












# function Create-SelfSignedCertOpenSSL {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [string]$PfxPassword
#     )

#     try {
#         $currentUser = Get-CurrentUser

#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
#         }

#         Write-EnhancedLog -Message "calling Run-GenerateCertificateScript" -Level "INFO"
#         $certPaths = Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $currentUser -RealCertName $CertName -RealTenantName $TenantName -RealAppId $AppId
#         Write-EnhancedLog -Message "Done calling Run-GenerateCertificateScript" -Level "INFO"

#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

#         Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

#         if ($PSVersionTable.OS -match "Windows") {
#             try {
#                 $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
#                 $cert = Import-PfxCertificateToStore -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
#                 Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
#             } catch {
#                 Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
#                 Handle-Error -ErrorRecord $_
#                 throw $_
#             }
#         } else {
#             Write-EnhancedLog -Message "Running on a non-Windows OS, skipping the import of the PFX certificate to the store." -Level "INFO"
#             $cert = $null
#         }

#         return $cert
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName,
#         [string]`$TenantName,
#         [string]`$AppId,
#         [string]`$OutputPath,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
#         `$cmdPart3 = "-out `"$certCrtPath`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `$certKeyPath -out `$certCrtPath -subj `$subject`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         return @{ KeyPath = `$certKeyPath; CrtPath = `$certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName `"$CertName`" -TenantName `"$TenantName`" -AppId `"$AppId`" -OutputPath `"$OutputPath`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }








# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$OutputPath,
#         [PSCustomObject]$CurrentUser
#     )

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName,
#         [string]`$TenantName,
#         [string]`$AppId,
#         [string]`$OutputPath,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"${certKeyPath}`""
#         `$cmdPart3 = "-out `"${certCrtPath}`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"$opensslCmd`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         return @{ KeyPath = `$certKeyPath; CrtPath = `$certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName `"$CertName`" -TenantName `"$TenantName`" -AppId `"$AppId`" -OutputPath `"$OutputPath`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }







# function Run-GenerateCertificateScript {
#     param (
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$AppId,
#         [PSCustomObject]$CurrentUser
#     )

#     $OutputPath = "/workspaces/cert"

#     $scriptContent = @"
# function Generate-Certificate {
#     param (
#         [string]`$CertName,
#         [string]`$TenantName,
#         [string]`$AppId,
#         [string]`$OutputPath,
#         [PSCustomObject]`$CurrentUser
#     )

#     try {
#         # Ensure output directory exists
#         if (-not (Test-Path -Path `$OutputPath)) {
#             New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
#         }

#         # Define certificate subject details
#         `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
#         `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
#         # Log subject and issuer
#         Write-Host "Certificate Subject: `$subject"
#         Write-Host "Certificate Issuer: `$Issuer"

#         # Generate the self-signed certificate using OpenSSL
#         `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
#         `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

#         # Step-by-step command construction
#         `$cmdPart1 = "openssl req -x509 -nodes -days 30"
#         `$cmdPart2 = "-newkey rsa:2048 -keyout `"${certKeyPath}`""
#         `$cmdPart3 = "-out `"${certCrtPath}`""
#         `$cmdPart4 = "-subj `'$subject`'"

#         `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
#         Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

#         `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
#         `$startInfo.FileName = "/bin/bash"
#         `$startInfo.Arguments = "-c `"openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `$certKeyPath -out `$certCrtPath -subj `$subject`""
#         `$startInfo.RedirectStandardOutput = `$true
#         `$startInfo.RedirectStandardError = `$true
#         `$startInfo.UseShellExecute = `$false
#         `$startInfo.CreateNoWindow = `$true

#         `$process = New-Object System.Diagnostics.Process
#         `$process.StartInfo = `$startInfo
#         `$process.Start() | Out-Null

#         `$stdout = `$process.StandardOutput.ReadToEnd()
#         `$stderr = `$process.StandardError.ReadToEnd()

#         `$process.WaitForExit()

#         Write-Host "OpenSSL Output: `$stdout"
#         Write-Host "OpenSSL Error: `$stderr"

#         if (`$process.ExitCode -ne 0) {
#             Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
#             throw "Certificate creation failed"
#         }

#         Write-Host "Certificate created successfully using OpenSSL"

#         return @{ KeyPath = `$certKeyPath; CrtPath = `$certCrtPath }
#     } catch {
#         Write-Host "An error occurred while generating the certificate."
#         Write-Host `$.Exception.Message
#         throw `$
#     }
# }

# # Generate the certificate
# Generate-Certificate -CertName `"$CertName`" -TenantName `"$TenantName`" -AppId `"$AppId`" -OutputPath `"$OutputPath`" -CurrentUser `"$CurrentUser`"
# "@

#     try {
#         # Create a temporary file in /tmp directory
#         $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }













function Create-SelfSignedCertOpenSSL {
    param (
        [string]$CertName,
        [string]$CertStoreLocation = "Cert:\CurrentUser\My",
        [string]$TenantName,
        [string]$AppId,
        [string]$OutputPath,
        [string]$PfxPassword
    )

    try {
        $currentUser = Get-CurrentUser

        # Create output directory if it doesn't exist
        if (-not (Test-Path -Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }

        Write-EnhancedLog -Message "calling Run-GenerateCertificateScript" -Level "INFO"
        $DBG
        $certPaths = Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $currentUser -RealCertName $CertName -RealTenantName $TenantName -RealAppId $AppId
        Write-EnhancedLog -Message "Done calling Run-GenerateCertificateScript" -Level "INFO"

        $DBG

        $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

        Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

        if ($PSVersionTable.OS -match "Windows") {
            try {
                $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
                $cert = Import-PfxCertificateToStore -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
                Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
            } catch {
                Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
                Handle-Error -ErrorRecord $_
                throw $_
            }
        } else {
            Write-EnhancedLog -Message "Running on a non-Windows OS, skipping the import of the PFX certificate to the store." -Level "INFO"
            $cert = $null
        }

        return $cert
    } catch {
        Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}
