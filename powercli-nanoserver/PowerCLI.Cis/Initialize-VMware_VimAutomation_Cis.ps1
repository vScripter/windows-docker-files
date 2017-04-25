function global:Get-CisCommand([string] $Name = "*") {
  get-command -module PowerCLI.Cis -Name $Name
}

# Set any aliases here...