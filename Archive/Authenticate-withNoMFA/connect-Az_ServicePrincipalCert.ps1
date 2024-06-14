$Thumbprint = '6D95B992C9EB7BF764650D1E1D3D656350916DB1'
$TenantId = 'e09d9473-1a06-4717-98c1-528067eab3a4'
$ApplicationId = '787faab2-3701-4a9e-ac96-168f17b6e2de'
Connect-AzAccount -CertificateThumbprint $Thumbprint -ApplicationId $ApplicationId -Tenant $TenantId -ServicePrincipal