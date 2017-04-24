# generic globl powershell profile

# created 20160421 - Kevin Kirkpatrick (Twitter|GitHub @vScriper)

# create PSDrive
if (Test-Path 'c:\src\vmware'){
    [void](New-PSDrive -Name P -PSProvider FileSystem -Root 'c:\src\vmware')
    Set-Location P:\
}

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

} # end function Start-PowerCLI

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

} # end function Start-PowerCLI


Set-Alias -Name Start-PowerCLI -Value Start-Environment


# setup custom console colors
$hostUI                        = $host.PrivateData
$hostUI.ErrorForegroundColor   = 'White'
$hostUI.ErrorBackgroundColor   = 'Red'
$hostUI.DebugForegroundColor   = 'White'
$hostUI.DebugBackgroundColor   = 'DarkCyan'
$hostUI.VerboseBackgroundColor = 'DarkBlue'
$hostUI.VerboseForegroundColor = 'Cyan'


Write-Host -Object '[PS Profile Load] Profile load complete.' -ForegroundColor Cyan -BackgroundColor DarkBLue

# set the console widow title
$consoleStatusCheck        = Get-ConsoleStatus
$host.UI.RawUI.WindowTitle = "User: $($consoleStatusCheck.User)    Computer: $($consoleStatusCheck.ComputerName)    Admin: $($consoleStatusCheck.IsAdmin)    PSVersion: $($consoleStatusCheck.PSMajorVersion)"


Write-Host ' '
Write-Host 'ComputerName: ' -NoNewline   ; Write-Host "  $($consoleStatusCheck.ComputerName)" -ForegroundColor Green
Write-Host 'User: ' -NoNewline 			 ; Write-Host "          $($consoleStatusCheck.User)" -ForegroundColor Green
Write-Host 'IsAdmin: ' -NoNewline        ; Write-Host "       $($consoleStatusCheck.IsAdmin)" -ForegroundColor Green
Write-Host 'PSVersion: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSVersion)" -ForegroundColor Green
Write-Host 'PSEdition: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSEdition)" -ForegroundColor Green
Write-Host ' '
