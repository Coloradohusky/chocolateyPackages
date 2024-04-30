$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Backblaze'
  fileType      = 'EXE'
  silentArgs   = '--nogui'
  validExitCodes= @(0)
}

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

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    } else {
	  $packageArgs['file'] = "$($_.UninstallString)"
	  $fileStringSplit = $packageArgs['file'] -split '\s+(?=(?:[^"]|"[^"]*")*$)'
	  if ($fileStringSplit.Count -gt 1) {
		  $packageArgs['file'] = $fileStringSplit[0]
		  $packageArgs['silentArgs'] += " $($fileStringSplit[1..($fileStringSplit.Count-1)])"
	  }
	}
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
