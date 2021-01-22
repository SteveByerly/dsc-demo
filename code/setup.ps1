<#
  .SYNOPSIS
    Installs the DSC modules used in this example
#>
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version "Latest"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$script:ExternalModuleNames = @(
  # DSC
  "ComputerManagementDSC",
  "PSDscResources",
  "SqlServerDsc",
  "xPSDesiredStateConfiguration",
  "xWindowsUpdate"
)

function Install-RequiredModules {
  [CmdletBinding()]
  param ()

  Write-Verbose -Message "Installing base PowerShell modules"
  foreach ($moduleName in $script:ExternalModuleNames) {
    Write-Verbose -Message "Installing module: $ModuleName"
    $null = Install-Module -Name $ModuleName -Scope "AllUsers" -AllowClobber -Force
  }
}

Install-RequiredModules
