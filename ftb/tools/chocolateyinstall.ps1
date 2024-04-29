$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '' # no 32-bit exe exists
$url64      = 'https://piston.feed-the-beast.com/app/ftb-app-1.25.8-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'FTB Electron App*'

  checksum      = '' # no 32-bit exe exists
  checksumType  = 'sha256'
  checksum64    = '0479501BF34E6278646CEB674A2196024D5EFB9C560630E1281C0FDDEB5C61EF'
  checksumType64= 'sha256'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs