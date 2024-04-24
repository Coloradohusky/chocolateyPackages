$ErrorActionPreference = 'Stop'
$packageName    = 'resilio-sync-home'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://download-cdn.resilio.com/stable/windows/Resilio-Sync.exe'
$checksum       = 'F68CE817832191F8B8C5FE5BFCAA47DCBA548DB995571EB220473FF92AD14D23'
$url64          = 'https://download-cdn.resilio.com/stable/windows64/Resilio-Sync_x64.exe'
$checksum64     = 'DC9C72E709CC7A2EA74999CE3756E6F4879CD6EAE50A888A1F8CA011A1D6EFA3'

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
  url64          = $url64
  validExitCodes = @(0, 1)
  silentArgs     = '/S'
  softwareName   = 'Resilio Sync'
  checksum       = $checksum
  checksum64     = $checksum64
  checksumType   = 'sha256' 
  checksumType64 = 'sha256' 
}

Start-CheckandStop "Resilio Sync"
Install-ChocolateyPackage @packageArgs
Start-Sleep -s 5
if ($ProcessWasRunning -eq $False) {Start-CheckandStop "Resilio Sync"}