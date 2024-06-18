$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '' # no 32-bit exe exists
$url64      = 'https://piston.feed-the-beast.com/app/ftb-app-1.25.13-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'FTB Electron App*'

  checksum      = '' # no 32-bit exe exists
  checksumType  = 'sha256'
  checksum64    = '4D79958F4EA0E09CDA48C66EC90A78DEF616D54BFF4E743393DCF75582DDB2E1'
  checksumType64= 'sha256'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs