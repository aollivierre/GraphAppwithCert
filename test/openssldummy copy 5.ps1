# Define a simple command to run OpenSSL
$opensslCmd = "openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout dummy.key -out dummy.crt -subj '/CN=DummyCert/O=DummyOrg/C=US'"

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
Write-Host "Standard Output:"
Write-Host $stdout

Write-Host "Standard Error:"
Write-Host $stderr

if ($process.ExitCode -ne 0) {
    Write-Host "OpenSSL command failed with exit code $($process.ExitCode)"
    throw "Certificate creation failed"
} else {
    Write-Host "Certificate created successfully using OpenSSL"
}
