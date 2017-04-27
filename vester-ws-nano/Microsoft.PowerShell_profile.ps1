# generic globl powershell profile

# created 20160421 - Kevin Kirkpatrick (Twitter|GitHub @vScriper)

# create PSDrive and set it as the starting location
if (Test-Path 'c:\src\vmware'){
    [void](New-PSDrive -Name P -PSProvider FileSystem -Root 'c:\src\vmware')
    Set-Location P:\
}

# import profile configuration
$profileFunctionsPath = Join-Path $PSScriptRoot 'PSEnv.Functions.ps1'

if (Test-Path $profileFunctionsPath){
	Import-Module $profileFunctionsPath
} else {
	throw "Functions File Not Found {$profileFunctionsPath}"
} # end if

# Import proper version of Pester
[void](Import-Module -FullyQualifiedName @{ModuleName='Pester';ModuleVersion='4.0.3'})
[void](Import-Module Vester)

# setup custom console colors
$hostUI                        = $host.PrivateData
$hostUI.ErrorForegroundColor   = 'White'
$hostUI.ErrorBackgroundColor   = 'Red'
$hostUI.DebugForegroundColor   = 'White'
$hostUI.DebugBackgroundColor   = 'DarkCyan'
$hostUI.VerboseBackgroundColor = 'DarkBlue'
$hostUI.VerboseForegroundColor = 'Cyan'

$consoleStatusCheck = $null
$consoleStatusCheck = Get-ConsoleStatus

Write-Host ' '
Write-Host 'ComputerName: ' -NoNewline   ; Write-Host "  $($consoleStatusCheck.ComputerName)" -ForegroundColor Green
Write-Host 'User: ' -NoNewline 			 ; Write-Host "          $($consoleStatusCheck.User)" -ForegroundColor Green
Write-Host 'IsAdmin: ' -NoNewline        ; Write-Host "       $($consoleStatusCheck.IsAdmin)" -ForegroundColor Green
Write-Host 'PSVersion: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSVersion)" -ForegroundColor Green
Write-Host 'PSEdition: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSEdition)" -ForegroundColor Green
Write-Host ' '
Write-Host ' '

Start-PowerCLI