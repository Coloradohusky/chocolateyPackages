$ErrorActionPreference = 'Stop'
$packageName    = 'resilio-sync-home'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://download-cdn.resilio.com/stable/windows/Resilio-Sync.exe'
$checksum       = '8101AB7A109A8BF48555B87F0E7F0ACA6311B3CD32DB2906D6DF4BE7B88C8947'
$url64          = 'https://download-cdn.resilio.com/stable/windows64/Resilio-Sync_x64.exe'
$checksum64     = '6B78A98202BDF72572B8F5590422CFAE7B24B8775499406FEC7ED1B68B98011D'

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