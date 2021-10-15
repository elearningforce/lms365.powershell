
[CmdletBinding()]
param (
    [string] $LMS365TenantAPIKey,
    [ValidateSet('https://ne-api-dev.365.systems', 'https://va-api.usgcc365.systems', 'https://ne-api-qa.365.systems')]
    [string] $LMS365ApiEndPoint,
    [ValidateSet('AzureCloud', 'USGovernment')]
    [string] $AzureEnvironment
)
$ErrorActionPreference = "Stop"

# https://docs.microsoft.com/en-us/powershell/module/msonline/?view=azureadps-1.0
# The module is required to register SharePoint service principal
Write-Verbose "Checking MSOnline PS module installation..." -Verbose
Install-Module MSOnline

function New-ClientSecret {
  
  $bytes = New-Object Byte[] 32
  $rand = [System.Security.Cryptography.RandomNumberGenerator]::Create()
  $rand.GetBytes($bytes)
  $rand.Dispose()
  [System.Convert]::ToBase64String($bytes)
}

$dtStart = [datetime]::UtcNow
$dtEnd = $dtStart.AddYears(40)

$clientID = [guid]::NewGuid()
$appDomain = "lms.365usgcc.systems"
$appName = $appDomain
$appUrl = "https://$appDomain" 
$clientSecret = New-ClientSecret

$servicePrincipalName = @("$clientID/$appDomain")


Write-Verbose "Connecting: Please specify tenant admin account." -Verbose
Connect-MsolService -AzureEnvironment $AzureEnvironment

Write-Verbose "Connected: Registering access addin credentials with client id $clientID" -Verbose
$parameters = @{
  ServicePrincipalNames = $servicePrincipalName
  AppPrincipalId = $clientID
  DisplayName = $appName
  Type = "Symmetric"
  Usage = "Verify"
  Value = $clientSecret
  Addresses = (New-MsolServicePrincipalAddresses -Address $appUrl)
  StartDate = $dtStart
  EndDate = $dtEnd
}

New-MsolServicePrincipal @parameters
$parameters = @{
  AppPrincipalId = $clientId 
  Type = "Symmetric" 
  Usage = "Sign" 
  Value = $clientSecret 
  StartDate = $dtStart 
  EndDate = $dtEnd
}
New-MsolServicePrincipalCredential @parameters

$parameters = @{
  AppPrincipalId = $clientId
  Type = "Password" 
  Usage = "Verify" 
  Value = $clientSecret 
  StartDate = $dtStart 
  EndDate = $dtEnd
}
New-MsolServicePrincipalCredential @parameters

Write-Verbose "SharePoint access addin credentials have been registered." -Verbose
Write-Host "Client Id:     $clientID" -ForegroundColor Green
Write-Host "Client Secret: $clientSecret" -ForegroundColor Green

Write-Verbose "Registering the credentials in LMS365." -Verbose
$parameters = @{
  Headers = @{ Authorization = "Basic $([Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$LMS365TenantAPIKey`:$LMS365TenantAPIKey")))"}
  Method = "POST"
  Uri = "$LMS365ApiEndPoint/securitySettings"
  Body = (@{
    AccessAddinCredentials = @{
      ClientId = $clientId
      ClientSecret = $clientSecret
    }
  } | ConvertTo-Json)
  ContentType = "application/json"
}
Invoke-RestMethod @parameters

Write-Verbose "Done!"
