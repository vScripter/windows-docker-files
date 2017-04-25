:: *************************************************************************
:: Copyright 2009 VMware, Inc.  All rights reserved.
:: *************************************************************************

::
:: This script is used by Get-VmGuestRoute cmdlet to retrieve configured routes on the guest OS
::
:: PARAMETERS
::	   None
::
:: OUTPUT
::   This script prints lines containing the following information:
::      Destination=<destination>;Netmask=<netmask>;Gateway=<gateway>;Interface=<interface>;
::
::   destination - destination address
::   netmask - route netmask
::   gateway - gateway ip
::   interface - interface id
::

@echo off
   
setlocal ENABLEDELAYEDEXPANSION

set output_file=%TEMP%\route_output.txt

route print > %output_file%

set begin=0

for /F "tokens=1,2,3,4,5 delims= " %%A in (%output_file%) do (
  
  if !begin!==1 (


    if "%%A" == "Default" (
      goto :end
    )

    echo %%A | find  /I "=========" >nul
    if !errorlevel!==0 (
      goto :end
    )

    set value=%%D
    
    :: trim whitespaces
    echo !value! | find "	" >nul
    if !errorlevel!==0 (
      set value=!value:~0,-1!
    )
	
	rem check if the route is persistent
	set isPersistent=false
	set ipInfo=Destination=%%A;Netmask=%%B;Gateway=%%C;
	set isPersistentRoutesSection=0
	for /F "tokens=1,2,3,4,5 delims= " %%F in (%output_file%) do (  
		
		if "%%F %%G" == "Persistent Routes:" (
			set isPersistentRoutesSection=1
		)
		if !isPersistentRoutesSection! == 1 (
			set tempIpInfo=Destination=%%F;Netmask=%%G;Gateway=%%H;
			if "!ipInfo!" == "!tempIpInfo!" (
				set isPersistent=true
			)
		)
		
	)
    
    echo Destination=%%A;Netmask=%%B;Gateway=%%C;Interface=!value!;Persistent=!isPersistent!;
  )

  if "%%A" == "Network" (
    set begin=1
  )
)

:end

::::::::::::::  Clean up  ::::::::::::::::
:cleanup
if exist %output_file% del %output_file%