# There are two Main goals of this script:
# 1. Install LMS365 Azure AD applications as Azure AD Enterprise Application
# 2. Reduce permissions of LMS365 AAD application to minimum set as possible
 
 
# To Install LMS365 Azure AD applications as Azure AD Enterprise Application we use admin_consent request, therefor after global administrator's approval our apps appears as Enterprise Applications in customer tenant
# admin_consent flow runs by requesting GraphAPI token using LMS365 application as client_id. The request is configured by .NET ADAL library. 
# We use urn:ietf:wg:oauth:2.0:oob as a redirect uri, it guarantees that no tokens will be sent to our backend but all tokens will be received locally.
# after admin_consent has been accepted the script waits till Enterprise Applications are fully provisioned and accessible via AzureAD module
 
# The second goal(Reduce permissions) is achieved using AzureAD PS module(which utilizes GraphAPI and AzureADPreview module). The script modifies delegated and application permissions of LMS365
$TenantId = "GUID represents id of your tenant"
$GlobalAdminUserName ="admin@yourtenant.onmicrosoft.com"

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
Connect-AzureAD -TenantId $TenantId -AccountId $GlobalAdminUserName

Write-Verbose "Reduce LMS365 permissions to SharePoint" -Verbose

# Update delegated permissions of LMS365 app using PATCH https://graph.microsoft.com/beta/oAuth2Permissiongrants/.
Set-LMS365DelegatedPermission -TenantId $TenantId -UserName $GlobalAdminUserName -Resource "SharePoint" -DesiredScopes "MyFiles.Read"
