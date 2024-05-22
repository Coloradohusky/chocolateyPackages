$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '' # no 32-bit exe exists
$url64      = 'https://piston.feed-the-beast.com/app/ftb-app-1.25.9-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'FTB Electron App*'

  checksum      = '' # no 32-bit exe exists
  checksumType  = 'sha256'
  checksum64    = '6B182BCEEC0E43912245BA8FE75B314884DAD866AABA235426DCF514F2DD0140'
  checksumType64= 'sha256'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs