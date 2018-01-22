# Shared PowerShell Scripts for Infrastructure Stuff

<strong>CollectServices.ps1</strong> </br>
This script simply creates csv files which include details about services running on a server using the server name as a file name.

<strong>ServicesCheck.tests.ps1</strong> </br>
This Pester script uses all the csv files gathered by 'CollectServices.ps1' and check against the server if the services inside the csv are running.

These scripts pass the Invoke-ScriptAnalyzer test. I will add more scripts as soon as I get the chance to refactor them...

<strong>Get-nHostReport.ps1</strong> </br>
This script queries all the servers in AD and extract AD info, installed programs info, running services info and installed hotfixes info on an html report per server.
