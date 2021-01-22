<#
  .SYNOPSIS
    Compiles and applies the Demo DSC Configuration
#>

$ErrorActionPreference = "Stop"
Set-StrictMode -Version "Latest"

# ---------------------------------------------------------
# Constants
# ---------------------------------------------------------
$script:ConfigDir = $PSScriptRoot

# ---------------------------------------------------------
# Utils
# ---------------------------------------------------------
function Get-InstanceConfigurationOutputPath {
  [CmdletBinding()]
  [OutputType([String])]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Name
  )

  Write-Verbose -Message "Configuring DSC output directory"

  $outputPath = Join-Path -Path $script:ConfigDir -ChildPath $Name
  $pathExists = Test-Path -Path $outputPath

  if (-not $pathExists){
    Write-Verbose -Message "Creating DSC output directory: $outputPath"
    $null = New-Item -ItemType "Directory" -Path $outputPath
  }

  $outputPath
}

# ---------------------------------------------------------
# Main
# ---------------------------------------------------------
function Start-InstanceConfiguration {
  [CmdletBinding()]
  param ()

  Write-Output "[START] Configuring Instance"

  $outputPath = Get-InstanceConfigurationOutputPath -Name "Demo"

  $configPath = Join-Path -Path $script:ConfigDir -ChildPath "Demo.psm1" -Resolve
  Import-Module -Name $configPath

  $dataPath = Join-Path -Path $script:ConfigDir -ChildPath "Demo.psd1" -Resolve
  $configurationData = Import-PowerShellDataFile -Path $dataPath

  DemoConfiguration -OutputPath $outputPath -ConfigurationData $configurationData

  Write-Verbose -Message "Applying configuration to node: $outputPath"
  Start-DscConfiguration -Path $outputPath -Force -Wait

  Write-Output "[FINISHED] Configuring Instance"
}

Start-InstanceConfiguration
