 



# the module provides wrapper of .net adal library
Import-Module "$PSScriptRoot\Modules\ADAL\ADAL.psd1" -Force
Import-Module "$PSScriptRoot\Modules\LMS365Administration\LMS365Administration.psd1" -Force

Write-Verbose "Connect to AzureAD" -Verbose
$tenantId = "e9ae84ce-21f7-4a5a-8143-bd947aba0b96"
$glAccount = "fb@bangliving.dk"

# $tenantId = "f43b0299-3c54-4c2e-a647-11b6df2ae863"
# $glAccount = "admin@zimaprishla.onmicrosoft.com"
Connect-AzureAD -TenantId $tenantId -AccountId $glAccount

# $lms365App = Get-LMS365AppServicePrincipal
# $lms365App.AppRoles

Set-LMS365DelegatedPermission -TenantId $tenantId -UserName $glAccount -Resource "GraphAPI" -DesiredScopes "User.Invite.All"

$lms365 = Get-LMS365AppServicePrincipal
$spOAuth2PermissionsGrants = Get-AzureADOAuth2PermissionGrant -All $true | Where-Object { $_.clientId -eq $lms365.ObjectId }
Remove-AzureADOAuth2PermissionGrant -ObjectId "lNhUro6tK06LBelxsMXzZtLEsuvrFAhHhzGIvfSIg-U"

Remove-LMS365ApplicationPermission -Resource GraphAPI -ScopeToDelete "Group.Read.All"
Add-LMS365ApplicationPermission -TenantId $tenantId -UserName $glAccount -Resource GraphAPI -ScopeToAdd "GroupMember.Read.All"


