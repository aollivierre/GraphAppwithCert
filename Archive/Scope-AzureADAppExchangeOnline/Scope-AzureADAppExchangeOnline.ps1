<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
These steps are specific to Exchange Online resources and do not apply to other Microsoft Graph workloads.

Configure ApplicationAccessPolicy
To configure an application access policy and limit the scope of application permissions:

Connect to Exchange Online PowerShell. For details, see Connect to Exchange Online PowerShell.

Identify the app’s client ID and a mail-enabled security group to restrict the app’s access to.

Identify the app’s application (client) ID in the Azure app registration portal.
Create a new mail-enabled security group or use an existing one and identify the email address for the group.
Create an application access policy.

Run the following command, replacing the AppId, PolicyScopeGroupId, and Description arguments.

sh

Copy
New-ApplicationAccessPolicy -AppId e7e4dbfc-046f-4074-9b3b-2ae8f144f59b -PolicyScopeGroupId EvenUsers@contoso.com -AccessRight RestrictAccess -Description "Restrict this app to members of distribution group EvenUsers."
Test the newly created application access policy.

Run the following command, replacing the AppId and Identity arguments.

sh

Copy
Test-ApplicationAccessPolicy -Identity user1@contoso.com -AppId e7e4dbfc-046-4074-9b3b-2ae8f144f59b 
The output of this command will indicate whether the app has access to User1’s mailbox.

Note: Changes to application access policies can take up to 30 minutes to take effect in Microsoft Graph REST API calls.
     
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)

Parameters
-AccessRight
The AccessRight parameter specifies the permission that you want to assign in the application access policy. Valid values are:

RestrictAccess
DenyAccess
.OUTPUTS
    Output (if any)


RunspaceId       : c4006063-ae7e-45b1-8bb3-8f06dd59d8aa
ScopeName        : Alerts
ScopeIdentity    : Alerts
Identity         : dc3227a4-53ba-48f1-b54b-89936cd5ca53\42ef544e-182d-459e-ad74-c8982d5d45c6:S-1-5-21-251628874-2902965060-1589719393-34039692;9c0e9372-4460-41f4-af93-2de3911392 
                   18
AppId            : 42ef544e-182d-459e-ad74-c8982d5d45c6
ScopeIdentityRaw : S-1-5-21-251628874-2902965060-1589719393-34039692;9c0e9372-4460-41f4-af93-2de391139218
Description      : Restrict this app to members of distribution group EvenUsers.
AccessRight      : RestrictAccess
ShardType        : All
IsValid          : True
ObjectState      : Unchanged
.NOTES
    General notes
    Was able to create a mail enabled security group from PowerShell and From Admin Center but it won't show up in Admin Center but can query it from Powershell
    so I decided to use the actual recipient directly (Alerts@canadacomputing.ca) instead of using a mail enabled security group
#>

Connect-ExchangeOnline

# Get-Recipient -Identity 'CCI_Alerts_SMTP_MESG20201201152552' | Select-Object PrimarySMTPAddress, IsValidSecurityPrincipal
# $PolicyScopeGroupId = (Get-Recipient -Identity 'CCI_Alerts_SMTP_MESG20201201152552').ExternalDirectoryObjectId

$AppID = '7ddf059f-071e-4a5c-973f-8d0e2bde9b24'
# $PolicyScopeGroupId = 'EvenUsers@contoso.com' # mail enabled security group
# $PolicyScopeGroupId = '3d987df1-6787-4920-a3a2-db0cd7125f3b' # mail enabled security group
$PolicyScopeGroupId = 'Alerts@canadacomputing.ca' # the actual user instead of a mail sec group. We verified this user is a ValidSecurityPrincipal
$AccessRight = 'RestrictAccess'
$Description = "Restrict the app CCI_Send_Email_6 with APPID $AppID to members of $PolicyScopeGroupId"

New-ApplicationAccessPolicy -AppId $AppID -PolicyScopeGroupId $PolicyScopeGroupId -AccessRight $AccessRight -Description $Description


Get-ApplicationAccessPolicy

# $AppAccessPolicyIdentity = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53\42ef544e-182d-459e-ad74-c8982d5d45c6:S-1-5-21-251628874-2902965060-1589719393-34039692;9c0e9372-4460-41f4-af93-2de3911392'

# Remove-ApplicationAccessPolicy -Identity $AppAccessPolicyIdentity


Get-ApplicationAccessPolicy | Remove-ApplicationAccessPolicy



# Get-Recipient -Identity <RecipientIdentity> | Select-Object IsValidSecurityPrincipal

# Get-Recipient -Identity 'd85bcc88-d283-4417-a04d-9d1a9091efa1' | Select-Object IsValidSecurityPrincipal
# Get-Recipient -Identity 'SMTP Enabled Accounts - Alerts@canadacomputing.ca' | Select-Object IsValidSecurityPrincipal

# Get-Recipient -Identity '9c0e9372-4460-41f4-af93-2de391139218' | Select-Object IsValidSecurityPrincipal
# Get-Recipient -Identity 'Alerts@canadacomputing.ca' | Select-Object PrimarySMTPAddress, IsValidSecurityPrincipal
# Get-Recipient -Identity 'Alerts@canadacomputing.ca' | Select-Object *

# Get-Recipient -Identity '123@canadacomputing.ca' | Select-Object PrimarySMTPAddress, IsValidSecurityPrincipal

#There are 4 types of groups that you can create in Microsoft 365 
#1 Microsoft 365 Group >> does not work for us
#2 Mail Enabled Security Group >> works for us
#3 Distibution List >> Does not work for us
#4 Security Group >> Does not work for us


# Get-EXORecipient does not expose the IsValidSecurityPrincipal property so we need to use Get-Recipient instead
# Get-EXORecipient -Identity 'CCI_Alerts_SMTP_MESG20201201152552' | Select-Object PrimarySMTPAddress, IsValidSecurityPrincipal
# Get-EXORecipient -Identity 'CCI_Alerts_SMTP_MESG20201201152552' | Select-Object *
# Get-EXORecipient -Identity 'CCI_Alerts_SMTP_MESG20201201152552' | Get-Member

# Get-Recipient | Out-HtmlView


# New-DistributionGroup -Name "CCI_Alerts_SMTP_MESG" -Type "Security" -Members 'Alerts@canadacomputing.ca' #Security: A mail-enabled security group. These groups can have permissions assigned.
# Remove-DistributionGroup -Identity "CCI_Alerts_SMTP_MESG"
# Remove-DistributionGroup -Identity "CCIAlertsSMTPMESG"


# (Get-DistributionGroup).count

# Mail Enabled Security Group SMTP Enabled Accounts - Alerts@canadacomputing.ca
# -PolicyScopeGroupID The PolicyScopeGroupID parameter specifies the recipient to define in the policy. You can use any value that uniquely identifies the recipient. You can also specify a mail enabled security group to restrict/deny access to a large number of user mailboxes. For example:
# Name Distinguished name (DN) Display name Email address GUID This parameter only accepts recipients that are security principals (users or groups that can have permissions assigned to them). The following types of recipients are not security principals, so you can't use them with this parameter:
# Discovery mailboxes Dynamic distribution groups Distribution groups Shared mailboxes
# https://docs.microsoft.com/en-us/powershell/module/exchange/new-applicationaccesspolicy?view=exchange-ps
