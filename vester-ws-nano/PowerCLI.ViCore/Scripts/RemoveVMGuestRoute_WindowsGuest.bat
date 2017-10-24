:: *************************************************************************
:: Copyright 2009 VMware, Inc.  All rights reserved.
:: *************************************************************************

::
:: This script is used by Remove-VmGuestRoute cmdlet to delete routes on the guest OS
::
:: PARAMETERS
::	  destination - destination address
::   netmask - route netmask
::   gateway - gateway ip
::   interface - interface id
::   persistent - "true" if the route is persistent and otherwise "false". Persistent means that the route is available after OS(network) restart.
::
:: USAGE
::   The script is invoked with the following line:
::      RemoveVMGuestRoute_WindowsGuest.bat <destination> <netmask> <gateway> <interface>
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

route DELETE %destination% %mask%  %gateway%