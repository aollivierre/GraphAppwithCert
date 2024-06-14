
function Validate-UriAccess {
    param (
        [string]$uri
    )

    Write-EnhancedLog "Validating access to URI: $uri" -Color Cyan
    try {
        $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method Get
        if ($response.StatusCode -eq 200) {
            Write-EnhancedLog "Access to $uri PASS" -Color Green
            return $true
        } else {
            Write-EnhancedLog "Access to $uri FAIL" -Color Red
            return $false
        }
    } catch {
        Write-EnhancedLog "Access to $uri FAIL - $_" -Color Red
        return $false
    }
}
