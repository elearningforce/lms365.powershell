
$AzureResources = @{
    GraphAPI            = "00000003-0000-0000-c000-000000000000"
    WellKnownPSClientId = "1950a258-227b-4e31-a9cf-717495945fc2"
    SharePoint          = "00000003-0000-0ff1-ce00-000000000000"
}
 
. "$PSScriptRoot\Helpers.ps1"
. "$PSScriptRoot\Add-LMS365ApplicationPermission.ps1"
. "$PSScriptRoot\Install-LMS365App.ps1"
. "$PSScriptRoot\Remove-LMS365ApplicationPermission.ps1"
. "$PSScriptRoot\Set-LMS365DelegatedPermission.ps1"
. "$PSScriptRoot\Get-LMS365TenantProvisionUrl"
. "$PSScriptRoot\Vars.Production.ps1"
. "$PSScriptRoot\Set-LMS365QAVars.ps1"
