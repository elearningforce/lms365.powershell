# There are two Main goals of this script:
# 1. Install LMS365 Azure AD applications as Azure AD Enterprice Application
# 2. Reduce permisssions of LMS365 AAD application to minimun set as possible


# To Install LMS365 Azure AD applications as Azure AD Enterprice Application we use admin_consent request, therefor after global administator's approval our appears as Enterprice Applications in customer tenant
# admin_consent flow runs by requesting GraphAPI token using LMS365 application as client_id. The request is configured by .NET ADAL library. 
# we use urn:ietf:wg:oauth:2.0:oob as redirect uri, it garantee that no tokens will be send to our backend but all tokens will be recieved locally.
# after admin_consent has been accepted the script waits till Enterprice Applications are fully provisioned and accessable via AzureAD module

# The second goal is achived using AzureAD PS module(which utilize GraphAPI). The script modify delegated and application permissions of LMS365

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

# it is just small wrapper of ADAL.NET with one function Get-AdToken
# could be replaced by https://www.powershellgallery.com/packages/ADAL.PS/3.19.4.2 the module was developed by Microsoft employee.
Import-Module "$PSScriptRoot\..\Modules\ADAL\ADAL.psd1" -Force

# Provides functions to install LMS365 see descriprion below.
Import-Module "$PSScriptRoot\..\Modules\LMS365Administration\LMS365Administration.psd1" -Force

Write-Verbose "Install AzureAD Preview Module" -Verbose
# Install AzureADPreview https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.85
Install-AzureADModule

Write-Verbose "Connect to AzureAD" -Verbose
# Connects to AzureAD, which will show browser dialog for authentication.
Connect-AzureAD -TenantId $tId -AccountId $GlobalAdminUserName

Write-Verbose "Install LMS365 Azure AD Applications" -Verbose
# Requests token to GraphAPI via LMS365 app. It will show browser dialog with admin_consent. 
# During this process, NO auth tokens(refresh_token, id_token, access_tokens) will be passed to our backend because redirect uri is `urn:ietf:wg:oauth:2.0:oob`.
Install-LMS365App -TenantId $tId -UserName $GlobalAdminUserName

Write-Verbose "Reduce LMS365 permissions to SharePoint" -Verbose

# Update delegated permissions of LMS365 app using PATCH https://graph.microsoft.com/beta/oAuth2Permissiongrants/.
Set-LMS365DelegatedPermission -TenantId $tId -UserName $GlobalAdminUserName -Resource "SharePoint" -DesiredScopes "MyFiles.Read"
Set-LMS365DelegatedPermission -TenantId $tId -UserName $GlobalAdminUserName -Resource "GraphAPI" -DesiredScopes "User.Invite.All,RoleManagement.Read.Directory,User.Read.All"

# Remove application permissions of LMS365 using AzureAD PS Module function Remove-AzureADServiceAppRoleAssignment.
Remove-LMS365ApplicationPermission -TenantId $tId -UserName $GlobalAdminUserName -Resource "GraphAPI" -ScopeToDelete "Directory.Read.All"
Add-LMS365ApplicationPermission -TenantId $tId -UserName $GlobalAdminUserName -Resource "GraphAPI" -ScopeToAdd "GroupMember.Read.All"

# Just combine lms365 url for futher installation.
$provsionUrl = Get-LMS365TenantProvisionUrl -TenantId $tId -Region $Region
Write-Host "Please proceed installation process manually under regular user(not global admin):" -ForegroundColor Green
Write-Host $provsionUrl -ForegroundColor Green


