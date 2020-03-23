
@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'LMS365Administration.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0.0'
    
    # ID used to uniquely identify this module
    GUID = '77E7AFBF-A02A-4D1B-A400-43825EA2E87E'
    
    # Author of this module
    Author = 'Ilya Velesevich'
    
    # Company or vendor of this module
    CompanyName = 'Elearningforce'
    
    # Copyright statement for this module
    Copyright = '(c) 2020 Elearningforce. All rights reserved.'
  
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '3.0'
    
    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module
    DotNetFrameworkVersion = '4.5'
    
    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @(
    #     
    # )
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    FileList = @(
        '.\Helpers.ps1',
        '.\Add-LMS365ApplicationPermission.ps1',
        '.\Install-LMS365App.ps1',
        '.\Remove-LMS365ApplicationPermission.ps1',
        '.\Set-LMS365DelegatedPermission.ps1',
        '.\Get-LMS365TenantProvisionUrl',
        '.\Vars.Production.ps1'
    )
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Add-LMS365ApplicationPermission',
        'Install-AzureADModule',
        'Install-LMS365App',
        'Remove-LMS365ApplicationPermission',
        'Set-LMS365DelegatedPermission',
        'Get-LMS365TenantProvisionUrl'
    )
    
    # Cmdlets to export from this module
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = @()
    
    # Aliases to export from this module
    AliasesToExport = @()
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    # FileList = @()
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
    