#Requires -Version 5.0
#Written by Naw Awn 20/06/2018

function New-SubFolder
{ 
    <#
.Synopsis
   Create a batch of subfolders
.DESCRIPTION
   The script will create a new subfolder under all the child paths of a given main path.
.EXAMPLE
   New-SubFolder -MainPath "\\Server\SharedFolder\Services" -NewSubFolder "Contract"
.EXAMPLE
   New-SubFolder -MainPath "C:\Temp" -NewSubFolder "Contact"
#>   
    Param
    (
        # Main Folder Path where you want to point to 
        [Parameter(Mandatory=$true)][String]
        $MainPath,

        # New Sub Folder name you want to create under each of child path from the main path
        [Parameter(Mandatory=$true)][String]
        $NewSubFolder
    )
    Begin
    {        
        $count = 0
        $exists = 0
        $ChildPaths = (Get-ChildItem $MainPath).where{$_.PSISContainer}
    }
    Process
    {
        Foreach($i in $ChildPaths.fullname){
            If (Test-Path $i\$NewSubFolder){
                Write-Warning "Already Exists! $i\$NewSubFolder"
                $exists++
                continue
            }
            New-Item -ItemType Directory -Path $i -Name $NewSubfolder
            
            $count++
            Write-Output "New folder created! $i\$NewSubfolder"
        }
    }
    End
    {
        Write-Output "Created Folder count: $count"
        Write-Output "Folder already exists: $exists"
    }
}