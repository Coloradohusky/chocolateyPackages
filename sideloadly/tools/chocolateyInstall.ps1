$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://sideloadly.io/SideloadlySetup32.exe'
$url64      = 'https://sideloadly.io/SideloadlySetup64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64
  softwareName  = 'Sideloadly'
  checksum      = 'E15F3110708416F5D1CB387A39E7489F8065A440446EBDBAC51B0EE1DEF0D302'
  checksumType  = 'sha256'
  checksum64    = 'D33BF91B11F6B1322724AAF76A5F0564285B990833A7D2877917446A9C8B30AE'
  checksumType64= 'sha256'
  silentArgs   = '/S'
  validExitCodes= @(0)
}

$pp = Get-PackageParameters
$paramsFile = Join-Path (Split-Path -Parent $toolsDir) 'PackageParameters.xml'
Write-Debug "Writing package parameters to $paramsFile"
Export-Clixml -Path $paramsFile -InputObject $pp

Install-ChocolateyPackage @packageArgs

$LocalAppData = Get-EnvironmentVariable -Name 'LOCALAPPDATA' -Scope Process

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath "$desktop\Sideloadly.lnk" `
    -TargetPath "$LocalAppData\Sideloadly\sideloadly.exe" -WorkingDirectory "$toolsDir" `
    -WindowStyle 3
  Write-Host "Added desktop shortcut at '$desktop\Sideloadly.lnk'"
}
