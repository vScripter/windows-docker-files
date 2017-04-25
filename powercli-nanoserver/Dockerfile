FROM microsoft/nanoserver

LABEL \
author="Kevin Kirkpatrick" \
description="This image is pre-configured with PowerShell \
Modules maintained by VMware, as well as the \
VMware community."

# copy modules from build dir; couldn't get Expand-Archive to work correctly in nano server, thus, no auto-install
COPY PowerCLI.ViCore /Modules/PowerCLI.ViCore
COPY PowerCLI.Cis /Modules/PowerCLI.Cis
COPY PowerCLI.Vds /Modules/PowerCLI.Vds

# set powershell to run on container start
CMD ["C:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"]

# setup shell environment to PowerShell for RUN commands
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# install PowerCLI
RUN Write-Output 'Installing PowerCLI...'; \
Get-ChildItem C:\Modules -Directory -Filter PowerCLI* | foreach { Move-Item $_.FullName 'C:\Program Files\WindowsPowerShell\Modules' -Force};

# setup remainder of environment
RUN Write-Output 'Setting up environment...'; \
mkdir $home\Documents\WindowsPowerShell; \
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
Install-Module powervra -Force -Confirm:$false; \
Install-Module powervro -Force -Confirm:$false; \
mkdir c:\src;

# setup PowerShell Profile
COPY Microsoft.PowerShell_profile.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell