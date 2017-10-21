# InfraScripts - Shared PowerShell Scripts for Infrastructure Stuff

CollectServices.ps1 </br>
This script simply creates csv files which include details about services running on a server using the server name as a file name.

ServicesCheck.tests.ps1 </br>
This Pester script uses all the csv files gathered by 'CollectServices.ps1' and check against the server if the services inside the csv are running.

These scripts pass the Invoke-ScriptAnalyzer test. I will add more scripts as soon as I get the chance to refactor them...
