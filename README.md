## Provision LMS365 tenant ##

### Prerequisites ###

- PowerShell 5.0
- Azure AD global admin account i.e. the user who allowed to accept consent.
- Installed [AzureADPreview](https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.85) PS module or Windows account who can run console as administrator
- Understanding what is the LMS365 region suits for your data
![alt](https://i.imgur.com/VIKlWNW.png)
Regions: *NorthEurope, CentralUS, JapanEast, AustraliaEast, CanadaCentral*

### How to manually Provision LMS365 into a new Office 365 tenant ###

1. Download or clone the repository.
2. Open `[repository dir]./Scripts/Provision.ps1` file in PS editor and modify the parameters

```PowerShell
$TenantId = "GUID represents id of your tenant"
$GlobalAdminUserName ="admin@yourtenant.onmicrosoft.com"
$Region = "CentralUS"  #"NorthEurope", "CentralUS", "JapanEast", "AustraliaEast", "CanadaCentral"
```
3. Run the `[repository dir]./Scripts/Provision.ps1`
4. After script is done you will see the url the following format - please copy it you will need it in step 7:
![alt](https://i.imgur.com/D0xfhLo.png)
NOTE: Above url should be used to proceed installation as the LMS business owner user account without any administrative priviledges in Azure AD
5. Verify under Enterprise Applications that all [LMS365 applications are available](https://helpcenter.elearningforce.com/hc/en-us/articles/360004770257-LMS365-Azure-Active-Directory-architecture)
6. [Manually download and install the LMS365 SPFX package into your Tenant](https://helpcenter.elearningforce.com/hc/en-us/articles/360001535949-How-to-manually-update-the-SPFX-package-for-your-Tenant)
7. Prepare a Modern SharePoint Communication site collection and make the LMS Business Owner the [https://docs.microsoft.com/en-us/sharepoint/sites/change-site-collection-administrators#change-the-primary-or-secondary-site-collection-administrator](primary site collection administrator - Owner is not sufficient)
8. Provide the LMS Busines Owner the URL generated in step 4 above

### How to manually create & configure LMS365 Course Catalog ###
1. Login as the LMS Business Owner and open the SharePoint site collection planed to host the LMS Course Catalog
2. Register the LMS365 Permission App manually without uploading app package via https://{tenantdomain}.sharepoint.com/sites/{sitecollection}/_layouts/15/appinv.aspx
3. Lookup the App details using ID: f0f74104-da78-4591-a616-9949e9836b40
4. Paste the following into App Permission Request XML:
```
    <AppPermissionRequests AllowAppOnlyPolicy="true">
        <AppPermissionRequest Scope="http://sharepoint/content/sitecollection" Right="FullControl" />
        <AppPermissionRequest Scope="http://sharepoint/content/sitecollection/web" Right="FullControl" />
    </AppPermissionRequests>
```  
5. Click Create
6. Open https://lms.365.systems in a new tab in the same browser session
7. Press F12 top open the Browser Developer Tools and select the Console tab
8. Enter 'createCatalogManually()' and press enter to launch the 'Add Course Catalog' dialog
9. Paste the URL to the SharePoint Site Collection
10. Add any additional Catalog Adminstrators from your organization and click 'Save'
11. Now the LMS365 Catalog, Dashboard pages should be created and you are ready to start creating your training



