<#
.SYNOPSIS
    PowerShell Environment Functions File
.DESCRIPTION
    This configuration file is used to store functions that are read in by a PowerShell profile

    Check for the presense of a PSEnv.Config.ps1 module file which might call this file
.NOTES
    Version: 1.0.0
#>


function Get-ConsoleStatus {

    [cmdletbinding()]
    param()

    PROCESS {
        # check to see if running as Admin and then setup the the custom PS console window title to include some good info
        [bool]$runAsAdminCheck         = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        [System.String]$psVersionCheck = $psversiontable.PSVersion.ToString()

        [string]$userName = $null
        $userName         = "$ENV:USERDOMAIN" + '\' + "$ENV:USERNAME"

        $psEditonCheck = $null
        if ($psVersionTable.PSEdition) {
            $psEditonCheck = $psVersionTable.PSEdition
        }

        [PSCustomObject] @{
            ComputerName = $Env:ComputerName
            User         = $userName
            IsAdmin      = $runAsAdminCheck
            PSVersion    = $psVersionCheck
            PSEdition    = $psEditonCheck
        }

    } # end PROCESS block

} # end function Get-ConsoleStatus

function Start-Environment {

    [CmdletBinding()]
    param(
        [parameter(Position = 0)]
        [System.String[]]
        $moduleList = @(
            'VMware.PowerCLI',
            'powernsx',
            'powervro',
            'powervra'
        )
    )

    PROCESS {

        try {
            foreach ($module in $moduleList) {
                Write-Verbose -Message "Importing Module { $module }"
                Import-Module -Name $module -ErrorAction 'Stop' | Out-Null
            } # end foreach
        } catch {
            Write-Warning -Message "[ERROR] Could not load PSModule { $module }. $_"
        } # end try/catch

    } # end PROCESS block

} # end function Start-Environment

function Get-Environment {

    [CmdletBinding()]
    param(
        [parameter(Position = 0)]
        [System.String[]]
        $moduleList = @(
            'VMware*',
            'powernsx',
            'powervro',
            'powervra'
        )
    )

    PROCESS {

       Get-Module -Name $moduleList -ListAvailable | Select-Object Name,Version,CompanyName,Description | Format-Table -AutoSize

    }

} # end function Get-Environment