# How to install LMS365 manually (with high security demands) #

The process divides on two stages:

1. Provision LMS365 tenant
2. Create and configure course catalog

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
2. Open PowerShell console and cd `[repository dir]./Scripts` directory
3. Run:

```PowerShell
.\Provision.ps1 -TenantId "id of your tenant" -GlobalAdminUserName "admin@yourtenant.onmicrosoft.com" -Region "One above region"
```

4. After script is done you will see the url the following format:
![alt](https://i.imgur.com/D0xfhLo.png)
this is url you can open to proceed installation under normal user(not admin)

## Create and configure course catalog ##

TODO