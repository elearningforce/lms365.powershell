param(
    # Id of target tenant.
    [Parameter(Mandatory =$true)]
    [guid]
    $TenantId,
    # User who has Global admin or application administrator role.
    [Parameter(Mandatory = $true)]
    [string]
    $GlobalAdminUserName,
    # Geo region where LMS365 infrastructure will be deployed.
    [Parameter(Mandatory = $true)]
    [ValidateSet("NorthEurope", "CentralUS", "JapanEast", "AustraliaEast", "CanadaCentral")]
    [string]
    $Region
)

$tId = $TenantId.ToString()

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\..\Modules\ADAL\ADAL.psd1" -Force
Import-Module "$PSScriptRoot\..\Modules\LMS365Administration\LMS365Administration.psd1" -Force

Write-Verbose "Install AzureAD Preview Module" -Verbose
Install-AzureADModule

Write-Verbose "Connect to AzureAD" -Verbose
Connect-AzureAD -TenantId $tId -AccountId $GlobalAdminUserName

Write-Verbose "Install LMS365 Azure AD Applications" -Verbose
Install-LMS365App -TenantId $tId -UserName $GlobalAdminUserName

Write-Verbose "Reduce LMS365 permissions to SharePoint" -Verbose
Set-LMS365DelegatedPermission -TenantId $tId -UserName $GlobalAdminUserName -Resource "SharePoint" -DesiredScopes "MyFiles.Read"

$provsionUrl = Get-LMS365TenantProvisionUrl -TenantId $tId -Region $Region
Write-Host "Please proceed installation process manually under regular user(not global admin):" -ForegroundColor Green
Write-Host $provsionUrl -ForegroundColor Green


