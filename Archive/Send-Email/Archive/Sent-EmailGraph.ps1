# Provide the sender and recipient email address
$fromAddress = 'Alerts@canadacomputing.ca'
$toAddress = 'Abdullah@canadacomputing.ca'

# Specify the email subject and the message
$mailSubject = 'This is a test message from Azure via Microsoft Graph API'
$mailMessage = 'This is a test message from Azure via Microsoft Graph API'

# DO NOT CHANGE ANYTHING BELOW THIS LINE
# Build the Microsoft Graph API request
$params = @{
  "URI"         = "<https://graph.microsoft.com/v1.0/users/$fromAddress/sendMail>"
  "Headers"     = @{
    "Authorization" = ("Bearer {0}" -F $token)
  }
  "Method"      = "POST"
  "ContentType" = 'application/json'
  "Body" = (@{
    "message" = @{
      "subject" = $mailSubject
      "body"    = @{
        "contentType" = 'Text'
        "content"     = $mailMessage
      }
      "toRecipients" = @(
        @{
          "emailAddress" = @{
            "address" = $toAddress
          }
        }
      )
    }
  }) | ConvertTo-JSON -Depth 10
}

# Send the message
Invoke-RestMethod @params -Verbose