
function Get-DeviceStateInIntune {
    param (
        [string]$deviceId
    )

    Write-EnhancedLog "Checking device state in Intune for Device ID: $deviceId" -Color Cyan

    $intuneUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?$filter=deviceId eq '$deviceId'"
    $response = Invoke-WebRequest -Uri $intuneUrl -Headers $headers -Method Get
    $data = ($response.Content | ConvertFrom-Json).value

    if ($data -and $data.Count -gt 0) {
        return "Present"
    } else {
        return "Absent"
    }
}
