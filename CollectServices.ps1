

<#
.Synopsis
   Prepare PowerShell ISE to start coding a module.
.DESCRIPTION
    The Script will collect Automatic Running services into a csv file with the server name as the file name.
.EXAMPLE
    .\CollectServices.ps1
#>
#if you have a list of servers in a text file, use this
#$Servers = (Get-Content C:\temp\Services\ServerName.txt)

$Servers = (Get-ADComputer -Filter {OperatingSystem -like "*Server*"}).Name
If (!(Test-Path -Path C:\temp\Services))
{
    New-Item -Path C:\temp\Services -ItemType Directory
}
foreach ($Node in $Servers) {
    If(Test-Connection $Node -Count 1 -Quiet){
        Write-Output "$Node is Online."
        Get-Service -ComputerName $Node | 
            Where-Object{($_.Status -eq "Running") -and ($_.StartType -eq "Automatic")} | 
            Sort-Object Name | Select-Object Name,Status,StartType | Export-Csv C:\temp\Services\$Node.csv -NoTypeInformation
    }
    Else {Write-Output "$Node is Offline."}  
}
