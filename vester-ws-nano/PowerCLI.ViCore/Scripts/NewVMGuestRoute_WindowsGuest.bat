:: *************************************************************************
:: Copyright 2009 VMware, Inc.  All rights reserved.
:: *************************************************************************

::
:: This script is used by New-VmGuestRoute cmdlet to create routes on the guest OS
::
:: PARAMETERS
::	 destination - destination address
::   netmask - route netmask
::   gateway - gateway ip
::   interface - interface id
::
:: USAGE
::   The script is invoked with the following line:
::      NewVMGuestRoute_WindowsGuest.bat <destination> <netmask> <gateway> <interface>
::
:: OUTPUT
::   If this script prints output it is displayed as an error message to the user
::
::

@echo off

set destination=%1

if not [%2]==[""] (
  set mask=MASK %2
)

if not [%3]==[""] (
  set gateway=%3
)

if not [%4]==[""] (
  set interface=IF %4
)

route -p ADD %destination% %mask%  %gateway% %interface%