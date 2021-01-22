$ErrorActionPreference = "Stop"
Set-StrictMode -Version "Latest"

[DscResource()]
class S3FileResource {
  [DscProperty(Key)]
  [ValidateNotNullOrEmpty()]
  [String]
  $ObjectKey

  [DscProperty(Key)]
  [ValidateNotNullOrEmpty()]
  [String]
  $BucketName

  [DscProperty(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [String]
  $Destination

  [DscProperty(NotConfigurable)]
  [Nullable[Datetime]]
  $CreationTime

  [S3FileResource] Get() {
    $hasFile = $this.ValidateDestination()

    if ($hasFile) {
      $file = Get-ChildItem -LiteralPath $this.Destination
      $this.CreationTime = $file.CreationTime
    } else {
      $this.CreationTime = $null
    }

    return $this
  }

  [void] Set() {
    Write-Verbose -Message "Downloading $($this.ObjectKey) to $($this.Destination)"
    $null = Read-S3Object -BucketName $this.BucketName -Key $this.ObjectKey -File $this.Destination
  }

  [bool] Test() {
    return $this.ValidateDestination()
  }

  [bool] ValidateDestination() {
    $item = Get-ChildItem -LiteralPath $this.Destination -ErrorAction "Ignore"

    if ($null -eq $item) {
      return $false
    }

    if ($item.PSProvider.Name -ne "FileSystem") {
      throw "Destination is not a filesystem path: $($this.Destination)"
    }

    if ($item.PSIsContainer) {
      throw "Destination is a directory: $($this.Destination)"
    }

    return $true
  }
}
