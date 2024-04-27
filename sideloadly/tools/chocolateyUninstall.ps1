$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Sideloadly'
  fileType      = 'EXE'
  silentArgs   = '/S'
  validExitCodes= @(0)
}

$LocalAppData = Get-EnvironmentVariable -Name 'LOCALAPPDATA' -Scope Process

if ($packageArgs['fileType'] -eq 'MSI') {
  $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
  $packageArgs['file'] = ''
} else {
  $packageArgs['file'] = "$LocalAppData\Sideloadly\Uninstall.exe"
}

Start-CheckandStop "Sideloadly"
Start-CheckandStop "sideloadlydaemon"
Uninstall-ChocolateyPackage @packageArgs

$pp = Get-PackageParameters
if ($null -eq $pp -or $pp.Count -eq 0) {
  $toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $paramsFile = Join-Path (Split-Path -Parent $toolsPath) 'PackageParameters.xml'
  if (Test-Path -Path $paramsFile) {
    Write-Debug "Loading package parameters from $paramsFile"
    $pp = Import-Clixml -Path $paramsFile
  } else {
    Write-Debug "No package parameters available; shims and desktop shortcut won't be removed if they were created"
    $pp = @{}
  }
}

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Remove-Item "$desktop\Sideloadly.lnk" -ErrorAction SilentlyContinue -Force | Out-Null
}

