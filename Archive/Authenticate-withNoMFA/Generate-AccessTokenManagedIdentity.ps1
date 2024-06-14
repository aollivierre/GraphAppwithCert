# $InvokeWebRequestSplat = @{
#     Uri = 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F'
#     Headers = @{Metadata="true"}
# }

# Invoke-WebRequest @InvokeWebRequestSplat


# Get an access token for managed identities for Azure resources
$invokeWebRequestSplat = @{
    Uri = 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F'
    Headers = @{Metadata="true"}
    UseBasicParsing = $true

}

$response = Invoke-WebRequest @invokeWebRequestSplat


$content =$response.Content | ConvertFrom-Json
$access_token = $content.access_token
Write-Output "The managed identities for Azure resources access token is $access_token"

# Use the access token to get resource information for the VM
$invokeWebRequestSplat = @{
    Uri = 'https://management.azure.com/subscriptions/<SUBSCRIPTION-ID>/resourceGroups/<RESOURCE-GROUP>/providers/Microsoft.Compute/virtualMachines/<VM-NAME>?api-version=2017-12-01'
    Method = 'GET'
    ContentType = "application/json"
    Headers = @{ Authorization ="Bearer $access_token"}
}

$vmInfoRest = (Invoke-WebRequest @invokeWebRequestSplat).content


Write-Outpute-Output "JSON returned from call to get VM info:"
Write-Output $vmInfoRest