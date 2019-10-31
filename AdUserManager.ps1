Function Resolve-AdEmployeeID{
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ValueFromRemainingArguments,Position = 0)]      
        $EmployeeID
    )
    Process{
        $Property = @('DistinguishedName','Name','DisplayName','EmployeeID','EmployeeNumber','UserPrincipalName')
        Get-ADUser -Filter "EmployeeID -eq $EmployeeID" -Properties $Property | Select-Object $Property    
    }
}

Function Get-AdUserManager{
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,Position = 0)]      
        [Alias('Identity')]
        $Name
    )
    Begin{
        $Hashtable = @{}
    }
    Process{
        $Property = @('DistinguishedName','Name','UserPrincipalName')
        
        $Manager = (Get-ADUser -Identity $Name -Properties Manager).Manager
        If ($Manager){
            $ManagerInfo = Get-ADUser -Identity $Manager -Properties $Property | Select-Object $Property
            $Hashtable.Add('Manager',   $($ManagerInfo.Name))
            $Hashtable.Add('ManagerDN', $($ManagerInfo.DistinguishedName))
            $Hashtable.Add('ManagerUPN',$($ManagerInfo.UserPrincipalName))
        }
        Else{
            $Hashtable.Add('Manager',   '')
            $Hashtable.Add('ManagerDN', '')
            $Hashtable.Add('ManagerUPN','')
        }
        $UserInfo = Get-ADUser -Identity $Name -Properties $Property | Select-Object $Property        
        $Hashtable.Add('Name',$($UserInfo.Name))
        $Hashtable.Add('DistinguishedName',$($UserInfo.DistinguishedName))
        $Hashtable.Add('UserPrincipalName',$($UserInfo.UserPrincipalName))        
    }
    End{
        Return (New-Object PSObject -Property $Hashtable)
    }
}

Function Test-AdUserManager{
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,Position = 0)]
        [Alias('UserName')]     
        $Name,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromRemainingArguments,Position = 1)]      
        [ValidateNotNullOrEmpty()]
        $Manager
    )
    Process{
        $MgrDN = (Get-ADUser -Identity $Name -Properties Manager).Manager
        Return ((Get-Aduser -Identity $Manager) -like (Get-Aduser -Identity $MgrDN))
    }
}

Function Set-AdUserManager{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,Position = 0)]
        [ValidateNotNullOrEmpty()][Alias('UserName')]     
        $Name,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromRemainingArguments,Position = 1)]      
        [ValidateNotNullOrEmpty()]
        $Manager
    )
    Process{
        If ($PScmdlet.ShouldProcess("$Name", "Setting Manager attribute")){
            Set-ADUser -Identity $Name -Manager $Manager
        }
    }
}