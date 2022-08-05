Function Get-PDCEmulator{
    Param(
        [String]$Domain
    )
    Begin{
        If ($Domain){ $ADDomain = Get-ADDomain -Identity $Domain }
        Else { $ADDomain = Get-ADDomain -Current LocalComputer   }       
    }
    Process{
        Return ($ADDomain.PDCEmulator)
    }
}

Function Get-ADGroupReport{
    [CmdletBinding(DefaultParameterSetName='Domain')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Domain')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Server')]
        [Alias('Name')]
        [String]$GroupName,
        [Parameter(ParameterSetName = 'Domain')]
        [String]$Domain,
        [Parameter(ParameterSetName = 'Server')]
        [String]$Server
    )
    Begin{
        $Property = @('Name','SamAccountName','distinguishedName','objectClass',@{n='MemberOf';e={$one.Name}})
    }
    Process{
        If ($Domain) {
            $Server = Get-PDCEmulator -Domain $Domain
        }
        If (-Not($Server)){
            $Server = Get-PDCEmulator
        }
        $Group = Get-ADGroup -Filter "Name -like '$GroupName'" -Server $Server        
        Foreach ($one in $Group){
            $SubGroup = Get-ADGroupMember -Identity $one -Server $Server | Where-Object {$_.objectClass -eq 'group'}
            Get-ADGroupMember -Identity $one -Server $Server | Select-Object $Property
        }
        Foreach ($one in $SubGroup){
            Get-ADGroupMember -Identity $one -Server $Server | Select-Object $Property
        }
    }
<#
.Synopsis
   Generate the AD Group Report
.DESCRIPTION
   The cmdlet will extract the users, computers and groups from a given AD Group.
   The command only resolves the direct group member within the given group. It does not resolve recursively.
   The cmdlet can take the Domain Name or the Server Name to execute the query from.
.EXAMPLE
   Get-ADGroupReport -GroupName 'VPN-User*' -Domain mydomain.local
.EXAMPLE
   Get-ADGroupReport -GroupName 'VPN-User*' -Server Myserver.mydomain.local
.EXAMPLE
   Export the Output to CSV
   Get-ADGroupReport -GroupName 'VPN-User*' -Domain mydomain.local | Export-Csv C:\temp\VPN-UserGroup.csv -notype
#>
}
