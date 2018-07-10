<#
    Borrowed with gratitude from Stefan Scherer
    https://github.com/StefanScherer/dockerfiles-windows/blob/master
#>

$ErrorActionPreference = 'Stop';

if ( $env:APPVEYOR_PULL_REQUEST_NUMBER -Or ! $env:APPVEYOR_REPO_BRANCH.Equals("master")) {
  Write-Host "Nothing to deploy." -ForegroundColor 'Yellow'
  Exit 0
}

$files = ""
Write-Host "Starting deploy" -ForegroundColor 'Yellow'
docker login --username="$env:DOCKER_USER" --password-stdin="$env:DOCKER_PASS"

if ( $env:APPVEYOR_PULL_REQUEST_NUMBER ) {
  Write-Host "Pull request $($env:APPVEYOR_PULL_REQUEST_NUMBER)" -ForegroundColor 'Yellow'
  $files = $(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master))
} else {
  Write-Host "Branch $($env:APPVEYOR_REPO_BRANCH)" -ForegroundColor 'Yellow'
  $files = $(git diff --name-only HEAD~1)
}

Write-Host "Changed files:" -ForegroundColor 'Yellow'

$dirs = @{}

$files | ForEach-Object {
  Write-Host $_ -ForegroundColor 'Yellow'
  $dir = $_ -replace "\/[^\/]+$", ""
  $dir = $dir -replace "/", "\"
  if (Test-Path "$dir\push.ps1") {
    Write-Host "Storing $($dir) for deployment" -ForegroundColor 'Yellow'
    $dirs.Set_Item($dir, 1)
  } else {
    $dir = $dir -replace "\\[^\\]+$", ""
    if (Test-Path "$dir\push.ps1") {
      Write-Host "Storing $($dir) for deployment" -ForegroundColor 'Yellow'
      $dirs.Set_Item($dir, 1)
    }
  }
}

$dirs.GetEnumerator() | Sort-Object Name | ForEach-Object {
  $dir = $_.Name
  Write-Host "Building in directory $($dir)" -ForegroundColor 'Yellow'
  Push-Location $dir
  .\push.ps1
  Pop-Location
}