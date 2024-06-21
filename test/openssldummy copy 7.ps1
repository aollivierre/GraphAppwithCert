function Write-EnhancedLog {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp : [$Level] $Message"
}

function Handle-Error {
    param (
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )
    $errorMessage = "Exception Message: $($ErrorRecord.Exception.Message)"
    $fullException = "Full Exception: $($ErrorRecord | Out-String)"
    Write-EnhancedLog -Message $errorMessage -Level "ERROR"
    Write-EnhancedLog -Message $fullException -Level "ERROR"
}

function Create-DummyCertWithOpenSSL {
    param (
        [string]$OutputDir = "/workspaces/cert"
    )

    try {
        # Ensure the output directory exists
        if (-not (Test-Path -Path $OutputDir)) {
            New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
            Write-EnhancedLog -Message "Created output directory: $OutputDir" -Level "INFO"
        } else {
            Write-EnhancedLog -Message "Output directory already exists: $OutputDir" -Level "INFO"
        }

        # Define a simple command to run OpenSSL
        $opensslCmd = "openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout $OutputDir/dummy.key -out $OutputDir/dummy.crt -subj '/CN=DummyCert/O=DummyOrg/C=US'"
        Write-EnhancedLog -Message "Running OpenSSL command: $opensslCmd" -Level "INFO"

        # Use Start-Process to execute the command
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

        # Capture the output
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        # Output the results
        Write-EnhancedLog -Message "Standard Output: $stdout" -Level "INFO"
        Write-EnhancedLog -Message "Standard Error: $stderr" -Level "INFO"

        if ($process.ExitCode -ne 0) {
            Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode)" -Level "ERROR"
            throw "Certificate creation failed"
        } else {
            Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
        }
    } catch {
        Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}

# Test the function
Create-DummyCertWithOpenSSL
