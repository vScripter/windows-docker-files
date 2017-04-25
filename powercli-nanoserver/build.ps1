$ErrorActionPreference = 'Stop';
Write-Host Starting build

Write-Host Updating base images
#docker pull microsoft/windowsservercore
docker pull microsoft/nanoserver

docker build -t powercli-nanoserver .

docker images