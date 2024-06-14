#! All commands are case sensitive for example status works but Status does NOT work

# git config --global user.email "Abdullah@canadacomputing.ca"
# git config --global user.name "Abdullah Ollivierre"

& "C:\Program Files\Git\mingw64\bin\git.exe" status
& "C:\Program Files\Git\mingw64\bin\git.exe" fetch

& "C:\Program Files\Git\mingw64\bin\git.exe" add -A

$commit_message = $null
$commit_message = Read-Host -Prompt 'Please enter commit message'

& "C:\Program Files\Git\mingw64\bin\git.exe" commit -m $commit_message

#The following error is normal and can be supressed but sending git.exe to null

#!git.exe : To https://dev.azure.com/CanadaComputingInc/Unified365toolbox/_git/Unified365toolbox
# At C:\Users\Abdullah.Ollivierre\AzureRepos2\Unified365toolbox\Git_Commands\Invoke-GitCommandsv2.ps1:15 char:1
# + & "C:\Program Files\Git\mingw64\bin\git.exe" push -u origin master #( ...
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (To https://dev....ified365toolbox:String) [], RemoteException
#     + FullyQualifiedErrorId : NativeCommandError

#    dad2b52..b47015d  master -> master

# [void](& "C:\Program Files\Git\mingw64\bin\git.exe" push -u origin master) #(or the name of your branch instead of master)
# & "C:\Program Files\Git\mingw64\bin\git.exe" push -u origin master #(or the name of your branch instead of master)
& "C:\Program Files\Git\mingw64\bin\git.exe" push #(or the name of your branch instead of master)

& "C:\Program Files\Git\mingw64\bin\git.exe" pull