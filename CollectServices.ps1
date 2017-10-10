<#
.Synopsis
   Collect running services from servers.
.DESCRIPTION
    The Script will collect Automatic Running services into a csv file with the server name as the file name.
    The resulting file will be stored under C:\Temp\Services.
.EXAMPLE
    .\CollectServices.ps1
#>
#if you have a list of servers in a text file, use this'
#$Servers = (Get-Content C:\temp\Services\ServerName.txt)

$Servers = (Get-ADComputer -Filter {OperatingSystem -like "*Server*"}).Name

If (!(Test-Path -Path C:\Temp\Services)){
    New-Item -Path C:\Temp\Services -ItemType Directory
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