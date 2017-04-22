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