:: *************************************************************************
:: Copyright 2009 VMware, Inc.  All rights reserved.
:: *************************************************************************

::
:: This script is used by Set-VmGuestNetworkAdapter cmdlet to modify network adapters available on the guest OS
::
:: PARAMETERS
::	   None
::
:: Usage
::   The scritp is invoked with the following line:
::      SetVMGuestNetworkInterface_WindowsGuest.bat <device_name> <ipPolicy> <ip> <netmask> <gateway> <dnsPolicy> <dnsServer1> <dnsServer2> <winsPolicy> <winsServer1> <winsServer2>;
::
::   name - the name of the network adapter
::   description - available description;
::   ip - assigned ip;
::   netmask - the subnet mask of the network adapter;
::   gateway - configured gateway;
::   mac - mac address;
::   ipPolicy - "static" if you have manually assigned IP information and "dhcp" if dhcp server is used
::   dnsPolicy - "static" if you have manually assigned IP information and "dhcp" if dhcp server is used
::   dnsServer1 = primary dns
::   dnsServer2 - secondary dns;
::   winsPolicy - "static" if you have manually assigned IP information and "dhcp" if dhcp server is used
::   winsServer1 - primary secondary wins
::   winsServer2 - secondary wins
::

@echo off

setlocal ENABLEDELAYEDEXPANSION

set connectionName=%1
set ipPolicy=%2

if not [%3]==[""] (
  set ipAddress=addr=%3
  
  ping %ipAddress% >nul
  if !errorlevel!==0 (
     echo "There is an IP Conflict with another computer on the network" 
     exit /b
  )
)

if not [%4]==[""] (
  set subnetMask=mask=%4
)

if not [%5]==[""] (
  set gateway=gateway=%5 gwmetric=default
)

set dnsPolicy=%6
set dns1=%7
set dns2=%8

set winsPolicy=%9


rem shift to get parameter 10 and 11
shift
shift

set wins1=%8
set wins2=%9

rem IP, SubnetMask, Gateway
if not [%ipPolicy%]==[""] (
  if "%ipPolicy%" == "static" (
    if ["%gateway%"]==["gateway=[empty] gwmetric=default"] (
		netsh interface ip delete address "local area connection" gateway=all
		set gateway=
	) 
	
	netsh interface ip set address %connectionName% source=static %ipAddress% %subnetMask% !gateway!
	
	set dnsPolicy=static
	set winsPolicy=static
	
  ) else (
    netsh interface ip set address name=%connectionName% source=dhcp
  )
)





rem DNS
if not [%dnsPolicy%]==[""] (

  if "%dnsPolicy%" == "static" (
  
    if ["%dns1%"]==["[empty]"] (
		netsh interface ip delete dns %connectionName% all 
    ) else (
    
		if not [%dns1%] == [""] (
		   netsh interface ip delete dns %connectionName% all 
		   netsh interface ip add dns %connectionName% %dns1% 
		)
	    
		if not [%dns2%] == [""] (
		  netsh interface ip add dns %connectionName% %dns2% index=2 
		)
    )
  ) else (
    netsh interface ip set dns name=%connectionName% source=dhcp 
  )
)

rem wins
if not [%winsPolicy%]==[""] (
  if "%winsPolicy%" == "static" (

	if ["%wins1%"]==["[empty]"] (
		netsh interface ip delete wins %connectionName% all
    ) else (
		if not [%wins1%] == [""] (
		   netsh interface ip delete wins %connectionName% all 
		   netsh interface ip add wins %connectionName% %wins1% 
		)
	    
		if not [%wins2%] == [""] (
		  netsh interface ip add wins %connectionName% %wins2% index=2 
		)
    )
  ) else (
    netsh interface ip set wins name=%connectionName% source=dhcp 
  )
)