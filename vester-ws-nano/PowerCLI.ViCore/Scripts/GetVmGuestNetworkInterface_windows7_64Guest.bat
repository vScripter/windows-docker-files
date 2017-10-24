:: *************************************************************************
:: Copyright 2009 VMware, Inc.  All rights reserved.
:: *************************************************************************

::
:: This script is used by Get-VmGuestNetworkAdapter cmdlet to retrieve network adapters available on the guest OS
::
:: PARAMETERS
::	   None
::
:: OUTPUT
::   This script prints lines containing the following information:
::      Name=<name>;Description=<description>;IPAddress=<ip>;SubnetMask=<netmask>;DefaultGateway=<gateway>;Mac=<mac>;IPPolicy=<ipPolicy>;DnsPolicy=<dnsPolicy>;DnsServer=<dnsServer1>[,dnsServer2];WinsPolicy=<winsPolicy>;WinsServer=<winsServer1>[,winsServer2];RouteInterfaceId=<routeInterfaceId>;
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
::   routeInterfaceId - the id of the interface that route command requires;
::

@echo off
 
setlocal ENABLEDELAYEDEXPANSION

set output_file=%TEMP%\ipconfig_output.txt

ipconfig /all > %output_file%

set Name=
set Description=
set IPAddress=
set SubnetMask=
set DefaultGateway=
set Mac=
set IPPolicy=
set DnsPolicy=
set DnsServer=
set WinsPolicy=
set WinsServer=
set InterfaceIndex=

set isFirstAdapter=1
set isLineDnsServer=0;

for /F "tokens=1,2 delims=:" %%A in (%output_file%) do (
  
  rem get the second dns server
  
    
  if !isLineDnsServer!==1 (
    
    rem determine if the line is dns or not
    echo %%A | find /I ". . . ." >nul
    if not !errorlevel!==0 (
       rem Trim spaces
       set test=%%A
       for /f "tokens=* delims= " %%M in ("!test!") do (
         set DnsServer=!DnsServer:~0,-1!,%%M;
       )
    )
    
    set !isLineDnsServer=0
  )


  rem Trim value
    set value=%%B
    set value=!value:~1!

    rem Name
    echo %%A | find  /I "Description" >nul
    if !errorlevel!==0 (
      set Description=Description=!value!;
    )
    
    rem wins1
    echo %%A | find  /I "Primary WINS Server" >nul
    if !errorlevel!==0 (
      set WinsServer=WinsServer=!value!;
    )
    
    rem wins2
    echo %%A | find  /I "Secondary WINS Server" >nul
    if !errorlevel!==0 (
      set WinsServer=!WinsServer:~0,-1!,!value!;
    )
    
    rem IPAddress
    echo %%A | find /I "IPv4 Address" >nul
    if !errorlevel!==0 (
	  rem remove (preferred) string
      set IPAddress=IPAddress=!value:~0,-12!;
    )
    
    rem rem SubnetMask
    echo %%A | find /I "Subnet Mask" >nul
    if !errorlevel!==0 (
      set SubnetMask=SubnetMask=!value!;
    )
    
    rem DefaultGateway
    echo %%A | find /I "Default Gateway" >nul
    if !errorlevel!==0 (
      set DefaultGateway=DefaultGateway=!value!;
    )
    
    rem Mac    
    echo %%A | find /I "Physical Address" >nul
    if !errorlevel!==0 (

		set processed_mac=
		FOR /F "tokens=1,2,3,4,5,6 delims=-" %%M IN ("!value!") DO set processed_mac=%%M %%N %%O %%P %%Q %%R
		FOR /F "tokens=1 delims=." %%M IN ('"route print | find "!processed_mac!" /i"') DO set InterfaceIndex=%%M
		set InterfaceIndex=RouteInterfaceId=!InterfaceIndex:~1!;
        set Mac=Mac=!value!;
    )
    
    
    rem dnsAddress    
    echo %%A | find /I "DNS Servers" >nul
    if !errorlevel!==0 (
      set DnsServer=DnsServer=!value!;
      set isLineDnsServer=1
    )
    
    rem IpPolicy    
    echo %%A | find /I "DHCP Enabled" >nul
    if !errorlevel!==0 (
      if "!value:~0,3!"=="No" (
        set IPPolicy=IPPolicy=Static;
      ) else (
        set IPPolicy=IPPolicy=Dhcp;
      )
    )    
    
    rem Echo new nic options
    echo %%A | find /I " adapter " >nul

    
    if !errorlevel!==0 (
	  
	  rem get the adapter name
	  set temp=%%A
	  call :GetAdapterName
	  

      rem If second adapter then print
      if !isFirstAdapter!==1 (
        set tempName=!Name!
        set Name=Name=!temp!;
        set isFirstAdapter=0
      ) else (
        set tempName=!temp!
        
        echo !Name!!Description!!IPAddress!!SubnetMask!!DefaultGateway!!Mac!!IPPolicy!!DnsPolicy!!DnsServer!!WinsPolicy!!WinsServer!!InterfaceIndex!

        if not [!temp!]==[] (
             set Name=Name=!temp!;
        )

        set Description=
        set IPAddress=
        set SubnetMask=
        set DefaultGateway=
        set Mac=
        set IPPolicy=
        set DnsPolicy=
        set DnsServer=
        set WinsPolicy=
        set WinsServer=
        set InterfaceIndex=
      )

      netsh interface ip show dns name="!temp!" | find /I "dhcp" >nul
      if !errorlevel!==0 (
          set DnsPolicy=DnsPolicy=dhcp;
      ) else (
          set DnsPolicy=DnsPolicy=static;
      )

      netsh interface ip show wins name="!temp!" | find /I "dhcp" >nul
      if !errorlevel!==0 (
          set WinsPolicy=WinsPolicy=dhcp;
      ) else (
	       set WinsPolicy=WinsPolicy=static;
      )
    )
)

echo %Name%%Description%%IPAddress%%SubnetMask%%DefaultGateway%%Mac%%IPPolicy%%DnsPolicy%%DnsServer%%WinsPolicy%%WinsServer%%InterfaceIndex%

:GetAdapterName
set temp=!temp:~1!
echo !temp! | find /I " adapter " >nul
if !errorlevel!==0 (
   goto GetAdapterName 
) else (
   set temp=!temp:~8!
)