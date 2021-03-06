﻿#Requires -RunAsAdministrator

<#
.Synopsis
   Remove PepperFlash under all users' AppData
.DESCRIPTION
   The script loops all user's subfolder and remove the unwanted version of PepperFlash for Google Chrome.
   Specify the version you would like to keep by using KeepVer parameter.
.EXAMPLE
   Just run the .ps1 file you save as.
   Remove-PepperFlash.ps1
.EXAMPLE   
   Remove-PepperFlash.ps1 -KeepVer "32.0.0.0"
#>
Param(
    [System.Version]$KeepVer = "31.0.0.0"
)

If (!(Get-Variable -Name UsersFolder)){
    New-Variable -Name UsersFolder -Value 'C:\Users' -Description "Constant Variable for Users folder" -Option ReadOnly
}
$AllUsersFolder = Get-ChildItem $UsersFolder | where{$_.BaseName -ne 'Public'}
$PepperFlash = 'AppData\Local\Google\Chrome\User Data\PepperFlash'

Foreach ($Folder in $AllUsersFolder){
    $UserPepperFlash = Join-Path -Path $Folder.FullName -ChildPath $PepperFlash
    #Write-Output $UserPepperFlash
    If (Test-Path -Path $UserPepperFlash){
        Get-ChildItem $UserPepperFlash | where{[System.Version]$_.BaseName -lt $KeepVer} | Remove-Item -Force -Recurse        
    }
}
