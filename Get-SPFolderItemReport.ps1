[CmdletBinding()]
Param()

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

Function Get-SPFolder{
    Param(
        $Url,
        $Library
    )
    #[Microsoft.SharePoint.SPFolder]
    return ((Get-SPWeb $Url).GetFolder($Library))
}

Function Get-SPFile{
    Param(
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        $Folder
    )    
    Process{
        #[Microsoft.SharePoint.SPListItem]
        return ($Folder.Files)
    }
}

Function Get-SPSubFolders{
    Param(
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        $ParentFolder
    )    
    Process{
        return ($ParentFolder.SubFolders)
    }
}

#region Controller()
$OutFile   = "E:\temp\SharePointItemList.csv"
$SpUrl     = "http://sharepoint/site"
$SPLibrary = "LibraryName"

$AllDir = @()
$Temp   = @()
$Result = @()

$AllDir += (Get-SPFolder -Url $SpUrl -Library $SpLibrary)
$Temp   = $AllDir

While($Temp){
    $Result = Foreach($f in $Temp){
        Get-SPSubFolders -ParentFolder $f
    }
    $Result | Select-Object Name,ServerRelativeUrl
    $Temp = $Result
    $AllDir += $Temp
}

If (!(Test-Path -Path $OutFile)){
    New-Item $OutFile -Force
}
$Property = @(
    'Name','Author','ModifiedBy','CheckOutStatus','CheckedOutBy','CheckedOutDate','LockType','LockedByUser','LockedDate','ServerRelativeUrl'
)

$SPItemList = Foreach($Dir in $AllDir){    
    Get-SPFile -Folder $Dir | Select-Object -Property $Property
} 

#Write-Verbose "Generating a csv file with all Folder List."
#$AllDir | Select-Object Name,ServerRelativeUrl | Export-Csv D:\temp\OurFilesFolderList.csv -NoTypeInformation

Write-Verbose "Generating a csv file with all File List."
$SPItemList | Export-Csv -Path $OutFile -NoTypeInformation

#endregion Controller