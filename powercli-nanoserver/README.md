[![This image on DockerHub](https://img.shields.io/docker/pulls/vscripter/powercli-nanoserver.svg)](https://hub.docker.com/r/vscripter/powercli-nanoserver/)

# powercli-nanoserver
Windows Nano Server Docker image running popular PowerShell modules & Scripts from VMware, as well as the VMware community.

More information can be found regarding PowerCLI Core in the documentation found [here](http://powercli-core.readthedocs.io/en/latest/).

> _Note: The main difference between this Docker Image and the Image distributed by VMware, is that this runs on Windows Nano Server (vs. Ubuntu/Photon OS)._

:heavy_exclamation_mark: To provide a cleaner startup experience, CEIP has been *ENABLED*, by default. If you would like to disable it, run `Set-PowerCLIConfiguration -Scope User -ParticipateInCeip $false`. _(for more information about CEIP run `help about_ceip`)_

## Image Summary
### Modules

| Module Name | Source |
|:----|:----|
| PowerCLI | [VMware Flings](https://labs.vmware.com/flings/powercli-core) |
| powervro | PowerShell Gallery |
| powervra | PowerShell Gallery |

### Scripts

## Pull
You can pull the image down from [Docker Hub](https://hub.docker.com/r/vscripter/powercli-nanoserver/) by running:

`docker pull vscripter/powercli-nanoserver`

## Run
Basic summary of switches used in the examples, below:
* `--rm` - Automatically remove the container when it exits
* `-i` - Interactive; Keep STDIN open even if not attached
* `-t` - tty; Allocate a pseudo-TTY
* `-d` - Detach; Run container in background and print container ID
* `-v` - Bind mount a volume
* `--name` - Set a name for the container

Start a container, interactively, and remove the container once exited.

`docker run --rm -it --name psvmw vscripter/powercli-nanoserver`

Start a container, run it in the background, name it `psvmw` map the local directory `c:\src` to the container directory `c:\src` and remove the container, once it is stopped.

`docker run --rm -dt -v "c:\src:c:\src" vscripter/powercli-nanoserver`

Run a PowerShell command in a container named `psvmw`, that is running in the background:

`docker exec psvmw powershell Get-ChileItem -Path c:\src`

Stop a container named `psvmw` that is running in the background

`docker stop psvmw`

If you have the `Docker` PowerShell module installed on your local machine, you can enter a PSSession to a running container (`psvmw`) by running:

`Enter-PSSession -ContainerId (Get-Container -Name psvmw).ID`


