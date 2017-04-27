FROM microsoft/nanoserver

# Setup metadata (MAINTAINER is deprecated)
LABEL \
author="Kevin Kirkpatrick" \
description="This image is pre-configured with PowerShell \
Modules maintained by VMware, as well as the \
VMware community."

# copy modules from build dir; couldn't get Expand-Archive to work correctly in nano server, thus, no auto-install
COPY Vester /Modules/Vester
COPY PowerCLI.ViCore /Modules/PowerCLI.ViCore
COPY PowerCLI.Cis /Modules/PowerCLI.Cis
COPY PowerCLI.Vds /Modules/PowerCLI.Vds

# set powershell to run on container start
CMD ["C:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"]

# setup shell environment to PowerShell for RUN commands
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# setup remainder of environment
RUN Write-Output 'Setting up environment...'; \
mkdir $home\Documents\WindowsPowerShell\Modules | Out-Null; \
mkdir C:\Users\ContainerAdministrator\AppData\Roaming\VMware\PowerCLI | Out-Null; \
Get-ChildItem C:\Modules -Directory -Filter PowerCLI* | foreach { Move-Item $_.FullName $env:programfiles\WindowsPowerShell\Modules -Force}; \
Get-ChildItem C:\Modules -Directory -Filter Vester | foreach { Move-Item $_.FullName $home\Documents\WindowsPowerShell\Modules -Force}; \
Get-Item C:\Modules | Remove-Item -Force; \
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
Install-Module powervra -Force -Confirm:$false; \
Install-Module powervro -Force -Confirm:$false; \
Install-Module Pester -Force -Confirm:$false -SkipPublisherCheck;

# copy PowerCLI settings file over which enables CEIP, by default (also provides a cleaner startup experience)
COPY PowerCLI_Settings.xml /Users/ContainerAdministrator/AppData/Roaming/VMware/PowerCLI

# setup PowerShell Profile
COPY PSEnv.Functions.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell
COPY Microsoft.PowerShell_profile.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell