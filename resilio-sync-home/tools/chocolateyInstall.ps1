$ErrorActionPreference = 'Stop'
$packageName    = 'resilio-sync-home'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download-cdn.resilio.com/stable/windows/64/0/Resilio-Sync_x64.exe'
$checksum     = 'E97186C25658CBD6ABFAE9F3423B39BECCA0BA4A4944DCD82D1FD9E98DD08BF5'

# SETTINGS:
# Create Desktop icon (default: true)
# Open Resilio Sync after installation (default: true)
# Add an exception for Resilio Sync in Windows Firewall (default: true)
# Start Resilio Sync when Windows starts up (default: true)
# Install Resilio Sync as Windows service (default: false)
# Was unable to find flags to change these

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url
  validExitCodes = @(0, 1)
  silentArgs     = '/S'
  softwareName   = 'Resilio Sync'
  checksum       = $checksum
  checksumType   = 'sha256' 
}

Start-CheckandStop "Resilio Sync"
Install-ChocolateyPackage @packageArgs
Start-Sleep -s 5
if ($ProcessWasRunning -eq $False) {Start-CheckandStop "Resilio Sync"}