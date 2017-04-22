# psvmware
Docker image running popular PowerShell modules from VMware, as well as the VMware community.


## Pull
You can pull the image down by running:

`docker pull vscripter/psvmware`

## Build
You can use this dockerfile to build the image from scratch, if you prefer that route over pulling it down.

* Change directories to where you save the dockerfile to and run:
  `docker build -t psvmware .`
* If you have the `git` binary available in your `PATH`, you can build directly from this repo:
  `docker build github.com/vScripter/windows-docker-files/psvmware`

## Run
Basic summary of switches used in the examples, below:
* `--rm` - Automatically remove the container when it exits
* `-i` - Interactive; Keep STDIN open even if not attached
* `-t` - tty; Allocate a pseudo-TTY
* `-d` - Detach; Run container in background and print container ID
* `-v` - Bind mount a volume
* `--name` - Set a name for the container

Start a container, interactively, and remove the container once exited.

  `docker run --rm -it --name psvmw vscripter/psvmware`

Start a container, run it in the background, name it `psvmw` map the local directory `c:\src` to the container directory `c:\src` and remove the container, once it is stopped.

  `docker run --rm -dt -v "c:\src:c:\src" vscripter/psvmware`

Run a PowerShell command in a container named `psvmw`, that is running in the background:

  `docker exec psvmw powershell Get-ChileItem -Path c:\src`

If you have the `Docker` PowerShell module installed on your local machine, you can enter a PSSession to a running container (`psvmw`) by running:

  `Enter-PSSession -ContainerId (Get-Container -Name psvmw).ID`


