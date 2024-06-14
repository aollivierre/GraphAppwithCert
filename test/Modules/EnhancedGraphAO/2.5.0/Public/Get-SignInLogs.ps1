
function Get-SignInLogs {
    param (
        [string]$url
    )

    $allLogs = @()

    while ($url) {
        try {
            Write-EnhancedLog "Requesting URL: $url" -Color Cyan
            # Make the API request
            $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get
            $data = ($response.Content | ConvertFrom-Json)

            # Collect the logs
            $allLogs += $data.value

            # Check for pagination
            $url = $data.'@odata.nextLink'
        } catch {
            Write-EnhancedLog "Error: $($_.Exception.Message)" -Color Red
            break
        }
    }

    return $allLogs
}
