$ErrorActionPreference = 'Stop'
$packageName    = 'backblaze'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://secure.backblaze.com/win32/install_backblaze.exe'
$checksum       = '7744A41DBB9D90DDA5347D2B426F6B05DC86B8DF2ABA148F85F18AC46D0418FD'
$url64          = ''
$checksum64     = ''

# SETTINGS:
# -h generates help message
# -version prints installation version info and exits
# -nogui suppress main GUI, still allows error popup dialogs
# -unpackonly does not run installer, just unpacks this archive
# -installdir <dir> uses "dir" as final location of install
# -createaccount <emailaddr> <password> creates this new account
# -signinaccount <emailaddr> <password> signs into this existing account
# -createaccount_or_signinaccount <emailaddr> <group ID> <group Token> [region] creates this new account OR signs into this existing account and invites to the group

# Get the package parameters and then back them up for the uninstaller
# This works around choco#1479 https://github.com/chocolatey/choco/issues/1479
$pp = Get-PackageParameters
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$paramsFile = Join-Path (Split-Path -Parent $toolsPath) 'PackageParameters.xml'
Write-Debug "Writing package parameters to $paramsFile"
Export-Clixml -Path $paramsFile -InputObject $pp

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url
  url64          = $url64
  validExitCodes = @(0)
  silentArgs     = '-nogui'
  softwareName   = 'Backblaze'
  checksum       = $checksum
  checksum64     = $checksum64
  checksumType   = 'sha256' 
  checksumType64 = 'sha256'
}

if ($pp.InstallDir) {
  $packageArgs.silentArgs += " -installdir " + $pp.InstallDir
  Write-Host "Install dir set to '$pp.InstallDir'"
}

if ($pp.EmailAddr) {
  $packageArgs.silentArgs += " -signinaccount" + $pp.EmailAddr
} else {
  Write-Error "Enter your login email address with /EmailAddr"
}

if ($pp.Password) {
  $packageArgs.silentArgs += " " + $pp.Password
} else {
  Write-Error "Enter your login password with /Password"
}

Start-CheckandStop "Backblaze"
Install-ChocolateyPackage @packageArgs
Start-Sleep -s 5
if ($ProcessWasRunning -eq $False) {Start-CheckandStop "Backblaze"}