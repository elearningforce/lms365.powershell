## Provision LMS365 tenant ##

### Prerequisites ###

- PowerShell 5.0
- Azure AD Global Admin account i.e. the user who is allowed to grant consent for LMS365 Application
- Installed [AzureADPreview](https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.85) PS module or Windows account that can run console as administrator
- Understanding of which LMS365 region suits for your data
![alt](https://content.screencast.com/users/ann.ageucheva/folders/Snagit/media/0a986bc3-fa38-47b0-bcce-8a981f75f505/07.06.2020-16.47.png)
Regions: *NorthEurope, CentralUS, JapanEast, AustraliaEast, CanadaCentral, UKSouth, GermanyWestCentral*

### How to manually Provision LMS365 into a new Office 365 tenant ###

1. Download or clone the repository
2. Open `[repository dir]./Scripts/Provision.ps1` file in PS editor and modify the parameters

```PowerShell
$TenantId = "GUID represents id of your tenant"
$GlobalAdminUserName ="admin@yourtenant.onmicrosoft.com"
$Region = "CentralUS"  #"NorthEurope", "CentralUS", "JapanEast", "AustraliaEast", "CanadaCentral", "UKSouth", "GermanyWestCentral"
```
3. Run the `[repository dir]./Scripts/Provision.ps1`
4. After script is done you will see the url the following format - please copy it you will need it in step 7:
![alt](https://i.imgur.com/D0xfhLo.png)
NOTE: Above url should be used to proceed installation as the LMS business owner user account without any administrative priviledges in Azure AD
5. Verify under Enterprise Applications that all [LMS365 applications are available](https://helpcenter.elearningforce.com/hc/en-us/articles/360004770257-LMS365-Azure-Active-Directory-architecture)
6. [Manually download and install the LMS365 SPFX package on your Tenant](https://helpcenter.elearningforce.com/hc/en-us/articles/360001535949-How-to-manually-update-the-SPFX-package-for-your-Tenant)
7. Prepare a Modern SharePoint Communication site collection and make the LMS Business Owner the [primary site collection administrator](https://docs.microsoft.com/en-us/sharepoint/sites/change-site-collection-administrators#change-the-primary-or-secondary-site-collection-administrator) - Owner role is not sufficient.
8. Provide the LMS Bussines Owner the URL generated in step 4 above and complete the provisioning of the LMS365 tenant database

### How to manually create & configure LMS365 Course Catalog ###
1. Login as the LMS Business Owner and open the SharePoint site collection planned to host the LMS Course Catalog
2. Register the LMS365 Permission App manually without uploading app package via https://{tenantdomain}.sharepoint.com/sites/{sitecollection}/_layouts/15/appinv.aspx
3. Look up the App details using ID: f0f74104-da78-4591-a616-9949e9836b40
4. Paste the following into App Permission Request XML:
```
    <AppPermissionRequests AllowAppOnlyPolicy="true">
        <AppPermissionRequest Scope="http://sharepoint/content/sitecollection" Right="FullControl" />
        <AppPermissionRequest Scope="http://sharepoint/content/sitecollection/web" Right="FullControl" />
    </AppPermissionRequests>
```  
5. Click Create
6. Open https://lms.365.systems in a new tab in the same browser session
7. Press F12 to open the Browser Developer Tools and select the Console tab
8. Enter 'createCatalogManually()' and press enter to launch the 'Add Course Catalog' dialog
9. Paste the URL to the SharePoint Site Collection in the Site Url field
10. Add any additional Catalog Adminstrators from your organization and click 'Save'
11. Now the LMS365 Catalog, Dashboard pages should be created and you are ready to start creating your training



