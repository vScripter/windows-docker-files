FROM microsoft/nanoserver

# Setup metadata (MAINTAINER is deprecated)
LABEL \
author="Kevin Kirkpatrick" \
description="This image is pre-configured with PowerShell \
Modules maintained by VMware, as well as the \
VMware community."

# copy modules from build dir; couldn't get Expand-Archive to work correctly in nano server, thus, no auto-install
COPY PowerCLI.ViCore /Modules/PowerCLI.ViCore
COPY PowerCLI.Cis /Modules/PowerCLI.Cis
COPY PowerCLI.Vds /Modules/PowerCLI.Vds
#COPY PowerNSX /Modules/PowerNSX

# copy PowerCLI settings file over which enables CEIP, by default (also provides a cleaner startup experience)
COPY PowerCLI_Settings.xml /Users/ContainerAdministrator/AppData/Roaming/VMware/PowerCLI

# set powershell to run on container start
CMD ["C:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"]

# setup shell environment to PowerShell for RUN commands
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# install PowerCLI
RUN Write-Output 'Installing PowerCLI...'; \
Get-ChildItem C:\Modules -Directory -Filter Power* | foreach { Move-Item $_.FullName 'C:\Program Files\WindowsPowerShell\Modules' -Force}; \
Get-Item C:\Modules | Remove-Item -Force;

# setup remainder of environment
RUN Write-Output 'Setting up environment...'; \
mkdir $home\Documents\WindowsPowerShell; \
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
#Install-Module PowervRA -Force -Confirm:$false; \
Install-Module PowervRO -Force -Confirm:$false; \
Install-Module PowerNSX -Force -Confirm:$false;

# setup PowerShell Profile
COPY PSEnv.Functions.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell
COPY Microsoft.PowerShell_profile.ps1 /Users/ContainerAdministrator/Documents/WindowsPowerShell

# kickoff test build