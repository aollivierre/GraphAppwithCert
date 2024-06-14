#region function Create-NewAzureAdUser

# Connect-AzureAD

function Create-NewAzureAdUser {
    [CmdletBinding()]
    param (

    )

    begin {

        $DefualtDomain = ""
$DefualtDomain = foreach ($AcceptedDomain in (Get-AcceptedDomain)) {
    if (($AcceptedDomain.DomainType -eq 'Authoritative') -and ($AcceptedDomain.Default -eq $true)) {
        $AcceptedDomain
    }
}
        $DefaultDomainName = $DefualtDomain.Name
        # $DefaultDomainName = "CanadaComputing.ca"
        $User = "test777"
        $MailNickNameValue = "test777"
        $O365password = '8%e1bTq!feUxLb6*'

        $objectID = "$($User)@$($DefaultDomainName)"
        $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
        $PasswordProfile.Password = $O365password

        # $O365passwordsec = ConvertTo-SecureString -String $O365password -AsPlainText -Force
        

        $UserParam =

        @{
            DisplayName       = $User
            PasswordProfile   = $PasswordProfile
            UserPrincipalName = $objectID
            AccountEnabled    = $true
            MailNickName      = $MailNickNameValue
        }

    }

    process {

        try {

            New-AzureADUser @UserParam
            Write-Host "User" $objectID "Has Been Created with Password" $O365password -ForegroundColor Green

        }
        catch {

            
            #just displaying the exception AKA terminating error that forced to exit the TRY block and enter the catch block
            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            Write-host $PSItem -ForegroundColor Red
            $PSItem
            Write-host $PSItem.ScriptStackTrace -ForegroundColor Red

        }
        finally {

            Write-Host "Displaying the Final Statement" -ForegroundColor Yellow

        }

    }

    end {
    }
}
#endregion function Create-NewAzureAdUser

Create-NewAzureAdUser

# Get-AzureADUser


