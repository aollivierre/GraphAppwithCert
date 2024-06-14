# if($null -eq (Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"})) {
#     Add-PSSnapin Microsoft.SharePoint.PowerShell;
# }

# $sourceWebURL = "http://sharepointsite"
# $sourceListName = "mylist"

# $spSourceWeb = Get-SPWeb $sourceWebURL
# $spSourceList = $spSourceWeb.Lists[$sourceListName]
# #$spSourceItems = $spSourceList.GetItems()
# #$spSourceItems = $spSourceList.GetItemById("1")
# $spSourceItems = $spSourceList.Items | Where-Object {$_['ID'] -eq 1}

# $spSourceItems | ForEach-Object {
#     Write-Host $_['ID']
#     Write-Host $_['Title']
# }

Get-PnPList -Identity Lists/NDA | select-object * | Out-GridView
(Get-PnPListItem -List NDA).count

# Get-PnPListItem -List NDA | select-object * | Out-GridView
$Items = Get-PnPListItem -List NDA
$DBG
(Get-PnPListItem -List NDA).item

Get-PnPListItem -List NDA | gm

$Identity = 'NDA'
$User = 'Admin-CCI@fgchealth.com'
$AddRole = 'Contribute'

Set-PnPListPermission -Identity $identity -User $User -AddRole $AddRole

$List = 'NDA'
$Identity = '50'
$User = 'Admin-CCI@fgchealth.com'
$AddRole = 'Contribute'


Set-PnPListItemPermission -List $List -Identity $Identity -User $User -AddRole $AddRole


