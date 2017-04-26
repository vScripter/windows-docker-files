FROM microsoft/windowsservercore

# Setup metadata (MAINTAINER is deprecated)
LABEL \
author="Kevin Kirkpatrick" \
description="This image is pre-configured with PowerShell \
Modules maintained by VMware, as well as the \
VMware community."

# set powershell to run on container start
CMD ["C:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"]

# setup shell environment to PowerShell for RUN commands
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install modules and scripts
RUN Write-Output 'Setting up environment...'; \
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
Install-Module GitHubRepository -Force -Confirm:$false; \
Install-Module VMware.PowerCLI -Force -Confirm:$false; \
Install-Module powervra -Force -Confirm:$false; \
Install-Module powervro -Force -Confirm:$false; \
Install-GitHubRepository -Owner vmware -Repository powernsx -Branch master -DestinationPath $env:programfiles\WindowsPowerShell\Modules; \
mkdir c:\src; \
Install-GitHubRepository -Owner vmware -Repository PowerCLI-Example-Scripts -Branch master -DestinationPath c:\src\; \
Rename-Item c:\src\PowerCLI-Example-Scripts vmware -Force; \
mkdir $env:appdata\VMware\PowerCLI;

# copy PowerCLI settings file over which enables CEIP, by default (also provides a cleaner startup experience)
COPY PowerCLI_Settings.xml /Users/ContainerAdministrator/AppData/Roaming/VMware/PowerCLI

# Setup PowerShell Profile
COPY PSEnv.Functions.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell
COPY Microsoft.PowerShell_profile.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell