# replace with your application ID
$client_id = '7ddf059f-071e-4a5c-973f-8d0e2bde9b24'
# replace with your secret key
$client_secret = 'yFY85xfIMijJQUBcZwlgiGDnEy92Yqdv4c3OH6r/vc4='
# replace with your tenant ID
$tenant_id = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'

# DO NOT CHANGE ANYTHING BELOW THIS LINE
$request = @{
        Method = 'POST'
        URI    = "<https://login.microsoftonline.com/$tenant_id/oauth2/v2.0/token>"
        body   = @{
            grant_type    = "client_credentials"
            scope         = "<https://graph.microsoft.com/.default>"
            client_id     = $client_id
            client_secret = $client_secret
        }
    }
# Get the access token
$token = (Invoke-RestMethod @request).access_token
# view the token value
$token