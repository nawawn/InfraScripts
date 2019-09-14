# Shared PowerShell Scripts for Infrastructure Stuff

__CollectServices.ps1__
This script simply creates csv files which include details about services running on a server using the server name as a file name.

__ServicesCheck.tests.ps1__
This Pester script uses all the csv files gathered by 'CollectServices.ps1' and check against the server if the services inside the csv are running.

__Get-nHostReport.ps1__
This script queries all the servers in AD and extract AD info, installed programs info, running services info and installed hotfixes info on an html report per server.

__New-ChildSubFolder.ps1__
This script creates a subfolder under all child folders of a given path.

__Invoke-SqlQuery.ps1__
This script queries the database and return the result. It is useful when you don't have the Invoke-SqlCmd cmdlet available on your computer.

__Remove-PepperFlash.ps1__
This script removes all the residues of Google Chrome Flash player (PPAPI) after a new version is installed. You may need to specify the acceptable version.

__Get-PepperFlash.ps1__
This script gets all of the Pepper Flash installed on the computer.

__Remove-AdUserHomeDir.ps1__
This script remove the Home Directory of a given AD User.

__New-AESencryption.ps1__
This script can be used to generate AES key and encrypted password to store in a text file. These files can then be used to create PSCredential in your automation script.

__Enter-Credential.ps1__
This script continues to prompt the username and password if they are incorrect.

__New-Password.ps1__
This interactive script continues to prompt for new password if they don't meet the password complexity and minimum lenght requirement.

__Test-Credential.ps1__
This interactive script check if the given credential is authenticated successfully.

__Get-SPFolderItemReport.ps1__
This script can generate the report with all folder and file list from a SharePoint site library.

__Get-FolderReport.ps1__
This script has three functions, Get-DirectoryReport, Out-RelativePath and Get-DirStructure.

__Update-RegLegacySW.ps1__
Registry fix work around to install legacy software when you have folder redirection turned on in your environment. This changes will be over written by the Group Policies when the machine restart.

__Watch-Process.ps1__
This script monitors a process and sends an email when it terminates. 

__Monitor-Process.ps1__
This is an another implementation of the Watch-Process.ps1 script splitting into functions. This also includes an extra function to send an alert message to a MS Team channel. 
 


