function Run-GenerateCertificateScript {
    param (
        [string]$CertName,
        [string]$TenantName,
        [string]$AppId,
        [string]$OutputPath,
        [PSCustomObject]$CurrentUser,
        [string]$RealCertName,
        [string]$RealTenantName,
        [string]$RealAppId
    )

    $scriptContent = @"
function Generate-Certificate {
    param (
        [string]`$CertName = "DummyCert",
        [string]`$TenantName = "DummyTenant",
        [string]`$AppId = "DummyAppId",
        [string]`$OutputPath,
        [string]`$RealCertName,
        [string]`$RealTenantName,
        [string]`$RealAppId,
        [PSCustomObject]`$CurrentUser
    )

    try {
        # Ensure output directory exists
        if (-not (Test-Path -Path `$OutputPath)) {
            New-Item -ItemType Directory -Path `$OutputPath -Force | Out-Null
        }

        # Define certificate subject details
        `$subject = "/CN=`$CertName-`$AppId/O=`$TenantName/OU=`$AppId/L=City/ST=State/C=US"
        `$Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
        # Log subject and issuer
        Write-Host "Certificate Subject: `$subject"
        Write-Host "Certificate Issuer: `$Issuer"

        # Generate the self-signed certificate using OpenSSL
        `$certKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.key"
        `$certCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$CertName-`$AppId.crt"

        # Step-by-step command construction
        `$cmdPart1 = "openssl req -x509 -nodes -days 30"
        `$cmdPart2 = "-newkey rsa:2048 -keyout `"${certKeyPath}`""
        `$cmdPart3 = "-out `"${certCrtPath}`""
        `$cmdPart4 = "-subj `'$subject`'"

        `$opensslCmd = "`$cmdPart1 `$cmdPart2 `$cmdPart3 `$cmdPart4"
        Write-Host "Running OpenSSL command to generate certificate: `$opensslCmd"

        `$startInfo = New-Object System.Diagnostics.ProcessStartInfo
        `$startInfo.FileName = "/bin/bash"
        `$startInfo.Arguments = "-c `"$opensslCmd`""
        `$startInfo.RedirectStandardOutput = `$true
        `$startInfo.RedirectStandardError = `$true
        `$startInfo.UseShellExecute = `$false
        `$startInfo.CreateNoWindow = `$true

        `$process = New-Object System.Diagnostics.Process
        `$process.StartInfo = `$startInfo
        `$process.Start() | Out-Null

        `$stdout = `$process.StandardOutput.ReadToEnd()
        `$stderr = `$process.StandardError.ReadToEnd()

        `$process.WaitForExit()

        Write-Host "OpenSSL Output: `$stdout"
        Write-Host "OpenSSL Error: `$stderr"

        if (`$process.ExitCode -ne 0) {
            Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
            throw "Certificate creation failed"
        }

        Write-Host "Certificate created successfully using OpenSSL"

        # Rename files to real values
        `$realCertKeyPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.key"
        `$realCertCrtPath = Join-Path -Path `$OutputPath -ChildPath "`$RealCertName-`$RealAppId.crt"

        Rename-Item -Path `$certKeyPath -NewName `$realCertKeyPath
        Rename-Item -Path `$certCrtPath -NewName `$realCertCrtPath

        Write-Host "Files renamed successfully to real values"
        return @{ KeyPath = `$realCertKeyPath; CrtPath = `$realCertCrtPath }
    } catch {
        Write-Host "An error occurred while generating the certificate."
        Write-Host `$.Exception.Message
        throw `$
    }
}

# Generate the certificate
Generate-Certificate -CertName "DummyCert" -TenantName "DummyTenant" -AppId "DummyAppId" -OutputPath `"$OutputPath`" -RealCertName `"$RealCertName`" -RealTenantName `"$RealTenantName`" -RealAppId `"$RealAppId`" -CurrentUser `"$CurrentUser`"
"@

    try {
        # Create a temporary file in /tmp directory
        $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
        Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

        # Start a new PowerShell session to run the script and wait for it to complete
        $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
            throw "The PowerShell script process exited with an error."
        }

        Write-Host "Script executed successfully."

    } catch {
        Write-Error "An error occurred in Run-GenerateCertificateScript: `$_"
        Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
        throw
    } finally {
        # Remove the temporary script file after execution
        if (Test-Path -Path $tempScriptPath) {
            Remove-Item -Path $tempScriptPath -ErrorAction Stop
        }
    }
}



# Define dummy parameters for testing
$CertName = "DummyCert"
$TenantName = "DummyTenant"
$AppId = "DummyAppId"
$OutputPath = "/workspaces/graphappwithcert/dummy"
$CurrentUser = [PSCustomObject]@{
    DisplayName = "DummyUser"
    userPrincipalName = "dummy@domain.com"
}
$RealCertName = "RealCertName"
$RealTenantName = "RealTenantName"
$RealAppId = "RealAppId"

# Call the function with dummy values
Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $CurrentUser -RealCertName $RealCertName -RealTenantName $RealTenantName -RealAppId $RealAppId
