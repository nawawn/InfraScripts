#Requires -RunAsAdministrator

<#
.Synopsis
   Get All PepperFlash installed under all users' AppData
.DESCRIPTION
   The script loops all user's subfolder and get all the version of PepperFlash for Google Chrome
.EXAMPLE
   Just run the .ps1 file you save as.
   Get-PepperFlash.ps1
.EXAMPLE
   Check against a remote computer. This assumes you have your script file under c:\temp folder.
   Invoke-Command -ComputerName 'RemotePCName' -FilePath C:\temp\Get-PepperFlash.ps1
#>

$UsersFolder = 'C:\Users'
$AllUsersFolder = Get-ChildItem $UsersFolder | where{$_.BaseName -ne 'Public'}
$PepperFlash = 'AppData\Local\Google\Chrome\User Data\PepperFlash'

Foreach ($Folder in $AllUsersFolder){
    $UserPepperFlash = Join-Path -Path $Folder.FullName -ChildPath $PepperFlash
    #Write-Output $UserPepperFlash
    Test-Path -Path $UserPepperFlash{
        Get-ChildItem $UserPepperFlash
        }      
    }    
}