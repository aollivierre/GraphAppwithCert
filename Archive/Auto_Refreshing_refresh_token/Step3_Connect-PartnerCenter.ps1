<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

$AccessTokenVal = $AccessTokenN.accesstoken #using the access token from step 1. In step 1 we are always generating a new access token from a refresh token
Connect-PartnerCenter -AccessToken $AccessTokenVal