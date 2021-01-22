#REQUIRES -Modules ComputerManagementDsc, xPSDesiredStateConfiguration, xWindowsUpdate

$ErrorActionPreference = "Stop"
Set-StrictMode -Version "Latest"

Configuration DemoConfiguration {
  param ()

  # Dependencies
  # ---------------------------------------------------------
  Import-DscResource -Module "ComputerManagementDsc"
  Import-DscResource -Module "xPSDesiredStateConfiguration"
  Import-DscResource -Module "xWindowsUpdate"

  Node "localhost" {
    # Constants
    # ---------------------------------------------------------
    $baseConfig = $ConfigurationData
    $registryConfig = $baseConfig.Registry

    # System Settings and Environment
    # ---------------------------------------------------------
    xEnvironment "TestKey" {
      Ensure = "Present"
      Name = "TestKey"
      Target = @("Machine", "Process")
      Value = "TestValue"
    }

    TimeZone "Default" {
      IsSingleInstance = "Yes"
      TimeZone = $baseConfig.TimeZoneId
    }

    foreach ($registryGroup in $registryConfig) {
      $registryKey = $registryGroup.Key
      $registryValues = $registryGroup.Values

      foreach ($registryValue in $registryValues.GetEnumerator()) {
        $valueName = $registryValue.key
        $valueData = $registryValue.value

        xRegistry "${registryKey}-${valueName}" {
          Ensure = "Present"
          Force = $true
          Key = $registryKey
          ValueData = $valueData
          ValueName = $valueName
          ValueType = "DWord"
        }
      }
    }

    # Windows Update
    # ---------------------------------------------------------
    xWindowsUpdateAgent "WindowsUpdate" {
      Category = @("Important", "Optional", "Security")
      IsSingleInstance = "Yes"
      Notifications = "Disabled"
      Source = "WindowsUpdate"
      UpdateNow = $true
    }

    PendingReboot "WindowsUpdate" {
      DependsOn = "[xWindowsUpdateAgent]WindowsUpdate"

      Name = "WindowsUpdate"
    }

    # Security
    # ---------------------------------------------------------
    IEEnhancedSecurityConfiguration "DisabledAdministrators" {
      Enabled = $false
      Role = "Administrators"
      SuppressRestart = $true
    }

    IEEnhancedSecurityConfiguration "DisabledUsers" {
      Enabled = $false
      Role = "Users"
      SuppressRestart = $true
    }

    UserAccountControl "DisableAdminConsent" {
      ConsentPromptBehaviorAdmin = 0
      EnableInstallerDetection = 0
      IsSingleInstance = "Yes"
      PromptOnSecureDesktop = 0
      SuppressRestart = $true
    }

    # Remote Connections
    # ---------------------------------------------------------
    RemoteDesktopAdmin "EnableRemoteDesktop" {
      Ensure = "Present"
      IsSingleInstance = "Yes"
      UserAuthentication = "Secure"
    }

    WindowsCapability "OpenSSHServer" {
      Ensure = "Present"
      Name = "OpenSSH.Server~~~~0.0.1.0"
    }
  }
}
