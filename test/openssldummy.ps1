Set-Location /workspaces/graphappwithcert/test

# Step 1: Define a simple command to run OpenSSL
$opensslCmd = "openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout dummy_from_ps.key -out dummy_from_ps.crt -subj '/CN=DummyCertFromPS/O=DummyOrg/C=US'"

# Step 2: Use Start-Process to execute the command
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "/bin/bash"
$processInfo.Arguments = "-c `"$opensslCmd`""
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

# Step 3: Output the results
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
