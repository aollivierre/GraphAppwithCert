function Generate-Certificate {
    param (
        [string]$CertName = "DummyCert",
        [string]$TenantName = "DummyTenant",
        [string]$AppId = "DummyAppId",
        [string]$OutputPath = "/workspaces/graphappwithcert/dummy",  # Adjust path as needed
        [PSCustomObject]$CurrentUser = @{
            DisplayName = "DummyUser"
            userPrincipalName = "dummy@domain.com"
        }
    )

    try {
        # Ensure output directory exists
        if (-not (Test-Path -Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }

        # Define certificate subject details
        $subject = "/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
        $Issuer  = "CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"
        
        # Log subject and issuer
        Write-Host "Certificate Subject: $subject"
        Write-Host "Certificate Issuer: $Issuer"

        # Generate the self-signed certificate using OpenSSL
        $certKeyPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.key"
        $certCrtPath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.crt"

        # Step-by-step command construction
        $cmdPart1 = "openssl req -x509 -nodes -days 30"
        $cmdPart2 = "-newkey rsa:2048 -keyout `"$certKeyPath`""
        $cmdPart3 = "-out `"$certCrtPath`""
        $cmdPart4 = "-subj `'$subject`'"

        $opensslCmd = "$cmdPart1 $cmdPart2 $cmdPart3 $cmdPart4"
        Write-Host "Running OpenSSL command to generate certificate: $opensslCmd"

        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "/bin/bash"
        $startInfo.Arguments = "-c `"$opensslCmd`""
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $process.Start() | Out-Null

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        Write-Host "OpenSSL Output: $stdout"
        Write-Host "OpenSSL Error: $stderr"

        if ($process.ExitCode -ne 0) {
            Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
            throw "Certificate creation failed"
        }

        Write-Host "Certificate created successfully using OpenSSL"
        return @{ KeyPath = $certKeyPath; CrtPath = $certCrtPath }
    } catch {
        Write-Host "An error occurred while generating the certificate."
        Write-Host $_.Exception.Message
        throw $_
    }
}

# Test the function with dummy values
Generate-Certificate
