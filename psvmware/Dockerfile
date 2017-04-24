FROM microsoft/windowsservercore

LABEL \
author="Kevin Kirkpatrick" \
description="This image is pre-configured with PowerShell \
Modules maintained by VMware, as well as the \
VMware community."

CMD ["C:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"]

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Write-Output 'Setting up environment...'; \
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
Install-Module GitHubRepository -Force -Confirm:$false; \
Install-Module VMware.PowerCLI -Force -Confirm:$false; \
Install-Module powervra -Force -Confirm:$false; \
Install-Module powervro -Force -Confirm:$false; \
Install-GitHubRepository -Owner vmware -Repository powernsx -Branch master -DestinationPath $env:programfiles\WindowsPowerShell\Modules; \
mkdir c:\src; \
Install-GitHubRepository -Owner vmware -Repository PowerCLI-Example-Scripts -Branch master -DestinationPath c:\src\; \
Rename-Item c:\src\PowerCLI-Example-Scripts vmware -Force;

COPY Microsoft.PowerShell_profile.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell