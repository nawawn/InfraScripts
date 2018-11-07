# Shared PowerShell Scripts for Infrastructure Stuff

__CollectServices.ps1__
This script simply creates csv files which include details about services running on a server using the server name as a file name.

__ServicesCheck.tests.ps1__
This Pester script uses all the csv files gathered by 'CollectServices.ps1' and check against the server if the services inside the csv are running.

These scripts pass the Invoke-ScriptAnalyzer test. 

__Get-nHostReport.ps1__
This script queries all the servers in AD and extract AD info, installed programs info, running services info and installed hotfixes info on an html report per server.

__New-SubFolder.ps1__
This script creates a subfolder under all child folders of a given path.

__Invoke-SqlQuery.ps1__
This script queries the database and return the result. It is useful when you don't have the Invoke-SqlCmd available on your computer. 