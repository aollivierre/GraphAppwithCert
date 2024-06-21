function Run-GenerateCertificateScript {
    param (
        [string]$CertName,
        [string]$TenantName,
        [string]$AppId,
        [PSCustomObject]$CurrentUser
    )

    $OutputPath = "/workspaces/cert"

    $scriptContent = @"
#!/bin/bash

# Ensure output directory exists
if [ ! -d `"$OutputPath`" ]; then
    mkdir -p `"$OutputPath`"
fi

# Define certificate subject details
subject="/CN=$CertName-$AppId/O=$TenantName/OU=$AppId/L=City/ST=State/C=US"
issuer="CN=$($CurrentUser.DisplayName)-$($CurrentUser.userPrincipalName)"

echo "Certificate Subject: $subject"
echo "Certificate Issuer: $issuer"

# Generate the self-signed certificate using OpenSSL
certKeyPath="$OutputPath/$CertName-$AppId.key"
certCrtPath="$OutputPath/$CertName-$AppId.crt"

opensslCmd="openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout `"$certKeyPath`" -out `"$certCrtPath`" -subj `"$subject`""

echo "Running OpenSSL command to generate certificate: $opensslCmd"

# Run the OpenSSL command
eval $opensslCmd

if [ $? -ne 0 ]; then
    echo "OpenSSL command failed"
    exit 1
fi

echo "Certificate created successfully using OpenSSL"
echo "KeyPath: $certKeyPath"
echo "CrtPath: $certCrtPath"

"@

    try {
        # Create a temporary file in /tmp directory
        $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".sh")
        Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

        # Start a new bash session to run the script and wait for it to complete
        $process = Start-Process bash -ArgumentList $tempScriptPath -PassThru -ErrorAction Stop
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            Write-Error "The bash script process exited with code $($process.ExitCode)."
            throw "The bash script process exited with an error."
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




# Define dummy parameters
$CertName = "DummyCert"
$TenantName = "DummyTenant"
$AppId = "DummyAppId"
$CurrentUser = [PSCustomObject]@{
    DisplayName = "DummyUser"
    userPrincipalName = "dummy@domain.com"
}

# Call the function with dummy values
Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -CurrentUser $CurrentUser
