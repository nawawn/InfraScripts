﻿$ErrorActionPreference = 'SilentlyContinue'

Function Get-HostReport {
    <#
    .SYNOPSIS
    Get the system report for a computer.
    .DESCRIPTION
    The report includes computer details, application details, running services and installed updates on an html page.
    .EXAMPLE
    Get-HostReport -Computer localhost 
    #>
    
    Param(
        [Parameter(Mandatory=$True, HelpMessage = "Enter a Computer Name")]
        [Alias('host')][String]$Computer
    )
    BEGIN{
        $Head = @"
        <style type="text/css">    
            tr:nth-child(even) {background: #f8f8f8}
            tr:nth-child(odd) {background: #dae5f4}    
        </style>   
"@    
    }
    PROCESS{
        $AD = Get-ADComputer $Computer -Properties * | 
            ConvertTo-Html Name,Description,IPv4Address,OperatingSystem,OperatingSystemServicePack -Fragment -PreContent "<h3>$Computer Server Report</h3><hr>" -PostContent "<br/>"
        
        $Pro = Get-CimInstance -ClassName Win32_Product -ComputerName $Computer | 
            Select-Object @{n="Name";e={$_.Caption}},Vendor,Version | ConvertTo-Html -Fragment -PostContent "<br/>"

        $Srv = (Get-Service -ComputerName $Computer).Where{$_.Status -eq "Running" -or $_.StartType -eq "Automatic"} | 
            ConvertTo-Html DisplayName,Name,Status,StartType -Fragment -PostContent "<br/>"
        
        $Hfx = Get-HotFix -ComputerName $Computer | 
            Sort-Object InstalledOn -Desc | ConvertTo-Html Description,HotfixID,InstalledOn,InstalledBy -Fragment -PostContent "<br/>"      
        
        ConvertTo-Html -Head $Head -Body "$AD $Pro $Srv $Hfx" -Title "Computer Report" | Out-File "C:\Temp\HostReport\$Computer.html"
    }
    END{
        If (Test-Path -Path "C:\Temp\HostReport\$Computer.html"){ Write-Output "$Computer Report generated."}  
    }
}

Function Test-DomainAdmin {
    [OutputType([Bool])]
    $thisUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $WinPrincipal = New-Object System.Security.Principal.WindowsPrincipal($thisUser)

    return ($WinPrincipal.IsInRole("Domain Admins"))
}

#region Main()
If (!(Test-DomainAdmin)){ Write-Warning "Domain Admin right is required!"; return }
If (!(Get-Module ActiveDirectory)){ Import-Module ActiveDirectory }
If (!(Test-Path -Path "C:\Temp\HostReport")){ New-Item -Path "C:\Temp\HostReport" -ItemType Directory }

#$Servers = (Get-Content C:\temp\ServerName.txt)
$Servers = (Get-ADComputer -Filter {OperatingSystem -like "*Server*"}).Name

Foreach($Server in $Servers)
{    
    If(Test-Connection $Server -count 1 -Quiet){ 
        Write-Output "Generating Report for $Server"
        Get-HostReport -Computer $Server
    }

    Else { 
        Write-Output "Unable to reach $Server" 
    }
}
#endregion EndMain

#How do I run this script?
#Just save the file in .ps1 and run it from PowerShell console with the domain admin right.