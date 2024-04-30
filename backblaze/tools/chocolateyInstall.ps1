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

$installDir = 'C:\Program Files (x86)\Backblaze'

Start-CheckandStop "bzbui"
Start-CheckandStop "bzserv"
Start-CheckandStop "bzbuitray"
Start-CheckandStop "bzfilelist"
Start-CheckandStop "bzfilelist64"
Start-CheckandStop "bztransmit"
Start-CheckandStop "bztransmit64"
Install-ChocolateyPackage @packageArgs
Start-Sleep -s 5
if ($ProcessWasRunning -eq $False) {Start-CheckandStop "Backblaze"}

# TODO: fix with --ia '-installdir "<installdir>"'
# nvm -installdir doesn't even work
if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath "$desktop\Backblaze Control Panel.lnk" `
    -TargetPath "$installDir\bzbui.exe" -WorkingDirectory "$installDir" `
    -WindowStyle 3
  Write-Host "Added desktop shortcut at '$desktop\Backblaze Control Panel.lnk'"
}