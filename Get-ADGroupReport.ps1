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
        [Alias('Name')][String]$GroupName,
        
        [Parameter(ParameterSetName = 'Domain')][String]$Domain,
        [Parameter(ParameterSetName = 'Server')][String]$Server
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
            #$SubGroup = Get-ADGroupMember -Identity $one -Server $Server | Where-Object {$_.objectClass -eq 'group'}
            Get-ADGroupMember -Identity $one -Server $Server -Recursive | Select-Object $Property -Unique
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
.EXAMPLE
   Add the output to another AD Group
   Get-ADGroupReport -GroupName 'VPN-User*' -Domain mydomain.local | %{Add-ADGroupMember -Identity NewADGroup -Members $_.SamAccountName}
#>
}

Function Get-ADGroupMemberDiff{
    Param(
        $InputObject,
        $MembersObject
    )
    Begin{
        $Property = @('Name','SamAccountName','distinguishedName','objectClass','MemberOf')
    }
    Process{
        Compare-Object -ReferenceObject $InputObject -DifferenceObject $MembersObject -Property 'SamAccountName' -PassThru |
            Where-Object{$_.SideIndicator -eq '<='} |
            Select-Object $Property
    }
}

Function Update-ADGroupMember{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ADGroup]$ADGroupObject,        
        [Parameter(Mandatory, ValueFromPipeline)]
        [String[]]$Members,
        [switch]$Force
    )
    Process{
        Foreach($item in $Members){
            $Operation = "Add $item"
            $GroupName = $ADGroupObject.Name
            If ($Force -Or $PSCmdlet.ShouldProcess($GroupName,$Operation)){
                Add-ADGroupMember -Identity $ADGroupObject -Members $item
            }
        }   
    }
}

#region Controller Script
#Variables
$FromGroupList = @("Group1", "Group2", "Group3")
$FromDomain = 'from.domain.local'
$ToADGroup  = 'AD Group Name to update members'
$ToADServer = 'ServerName for AD Group to update'
$LogFile = 'C:\Temp\ADGroupUpdate.Log'

#Controller
$InputObject   = $FromGroupList | Get-ADGroupReport -Domain $FromDomain
$GroupToUpdate = Get-ADGroup -Identity $ToADGroup -Server $ToADServer
$CurrentMember = $GroupToUpdate | Get-ADGroupMember
$MembersDiff   = Get-ADGroupMemberDiff -InputObject $InputObject -MembersObject $CurrentMember
#Use either -Force or -Confirm:$false to stop prompting for yes/no
$MembersDiff | Update-ADGroupMember -Identity $GroupToUpdate -Members $_.SamAccountName

#Basic Logging updates
$AddLine = "{0} {1}: {2}" -f (Get-Date),"[Operation]", "Add"
$StrDiff = $MembersDiff | Out-String
$LogString = New-Object System.Collections.ArrayList
[void]$LogString.Add($AddLine)
[void]$LogString.Add($StrDiff)
Add-Content -Path $LogFile -Value $LogString

#endregion
