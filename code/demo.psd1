@{
  AllNodes = @(
    @{
      NodeName = "localhost"
      PSDSCAllowPlainTextPassword = $true
    }
  )

  TimeZoneId = "Pacific Standard Time"

  Registry = @(
    @{
      Key = "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
      Values = @{
        Hidden = 1
        HideFileExt = 0
        LaunchTo = 1
        ShowSuperHidden = 1
      }
    },
    @{
      Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
      Values = @{
        Hidden = 1
        HideFileExt = 0
        LaunchTo = 1
        ShowSuperHidden = 1
      }
    },
    @{
      Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
      Values = @{
        NoAutorun = 1
      }
    },
    @{
      Key = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
      Values = @{
        Disabled = 1
      }
    },
    @{
      Key = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"
      Values = @{
        DisableFirstRunCustomize = 1
      }
    },
    @{
      Key = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
      Values = @{
        LongPathsEnabled = 1
      }
    }
  )
}
