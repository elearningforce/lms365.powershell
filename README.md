## Provision LMS365 tenant ##

### Prerequisites ###

- PowerShell 5.0
- Azure AD account who has at least application administrator permissions or global admin.
- Installed [AzureADPreview](https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.85) PS module or Windows account who can run console as administrator
- Understanding what is the LMS365 region suits for your data
![alt](https://i.imgur.com/VIKlWNW.png)
Regions: *NorthEurope, CentralUS, JapanEast, AustraliaEast, CanadaCentral*

### How to run provisioning ###

1. Download or clone the repository.
2. Open `[repository dir]./Scripts/Provision.ps1` file in PS editor and modify the parameters

```PowerShell
$TenantId = "GUID represents id of your tenant"
$GlobalAdminUserName ="admin@yourtenant.onmicrosoft.com"
$Region = "CentralUS"  #"NorthEurope", "CentralUS", "JapanEast", "AustraliaEast", "CanadaCentral"
```
3. Run the `[repository dir]./Scripts/Provision.ps1`
4. After script is done you will see the url the following format:
![alt](https://i.imgur.com/D0xfhLo.png)
this is url you can open to proceed installation under normal user(not admin)
