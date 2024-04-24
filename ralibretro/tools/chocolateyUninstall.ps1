$packageName   = 'ralibretro'
$zip32         = 'RALibretro.zip'
$zip64         = 'RALibretro-x64.zip'

$specificFolder = "RALibretro"
if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  $specificFolder = "RALibretro"
  $zip = $zip32
} else {
  $specificFolder = "RALibretro-x64"
  $zip = $zip64
}

Uninstall-ChocolateyZipPackage "$packageName" "$zip"

# Get package parameters
$pp = Get-PackageParameters
if ($null -eq $pp -or $pp.Count -eq 0) {
  # Work around for choco#1479 https://github.com/chocolatey/choco/issues/1479
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

$installDir = Join-Path $(Get-ToolsLocation) $specificFolder
if ($pp.InstallDir -or $pp.InstallationPath ) { $installDir = $pp.InstallDir + $pp.InstallationPath }

if ($installDir -ne $toolsPath) {
  Uninstall-BinFile ralibretro -path "$installDir\RALibretro.exe"
}

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Remove-Item "$desktop\RALibretro.lnk" -ErrorAction SilentlyContinue -Force | Out-Null
}

# remove files and folders generated by RALibretro
Remove-Item "$installDir" -ErrorAction SilentlyContinue -Force | Out-Null
Remove-Item "$installDir\RA_Integration.dll" -ErrorAction SilentlyContinue -Force | Out-Null
Remove-Item "$installDir\RALibretro.json" -ErrorAction SilentlyContinue -Force | Out-Null
Remove-Item "$installDir\RAPrefs_RALibRetro.cfg" -ErrorAction SilentlyContinue -Force | Out-Null