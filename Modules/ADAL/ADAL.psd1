@{

    # Script module or binary module file associated with this manifest.
    RootModule             = 'ADAL.psm1'
    # Version number of this module.
    ModuleVersion          = '1.0.0.0'
    # ID used to uniquely identify this module
    GUID                   = '1B959209-3F21-46EB-BAEC-F02C199E03D6'
    # Author of this module
    Author                 = 'Ilya Velesevich'
    # Company or vendor of this module
    CompanyName            = 'Elearningforce'
    # Copyright statement for this module
    Copyright              = '(c) 2020 Elearningforce. All rights reserved.'
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '3.0'
    DotNetFrameworkVersion = '4.5'
    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies     = @(
        '.\assemblies\Microsoft.IdentityModel.Clients.ActiveDirectory.dll'
    )
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules          = @(
        '.\Get-AdToken.ps1'
    )
    # Functions to export from this module
    FunctionsToExport      = @(
        'Get-ADToken'
    )
    # Cmdlets to export from this module
    CmdletsToExport        = @()
    # Variables to export from this module
    VariablesToExport      = @()
    # Aliases to export from this module
    AliasesToExport        = @()
}