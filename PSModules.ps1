[CmdletBinding()]
Param(
    [Parameter(ParameterSetName='Install')]
    [Swtich]$Install,
    [Parameter(ParameterSetName='Update')]
    [Swtich]$Update
)

$Modules = @'
Az
AzureAD
MSOnline
Microsoft.Online.SharePoint.PowerShell
MicrosoftTeams
SQLServer
DbaTools
ImportExcel
Pester
Posh-SSH
PSSQLite
PowerShellGet
'@ -Split '\r\n'

If ($Install){
    Foreach ($m in $Modules){
        Write-Verbose "Installing $m Module"
        Install-Module -Name $m -Force -AllowClobber
    }
}

If ($Update){
    Foreach ($m in $Modules){
        Write-Verbose "Updating $m Module"
        Update-Module -Name $m -Force
    }
}