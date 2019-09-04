[CmdletBinding()]
Param(
    [Switch]$CheckIn = $False
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

Function Set-OwnershipCheckin{
    Param($File)
    Process{
        Write-Verbose "Take ownership of the file - $($File.LeafName)"
        $File.TakeOverCheckOut()                    
        Write-Verbose "Check in the file - $($File.LeafName)"
        $List.GetItemById($File.ListItemId).File.Checkin("Checked in by Administrator")        
    }
}
#Site Collection Variable
$SiteURL="http://sharepoint/library/folder"
  
#Get the Site Collection
$Site = Get-SPSite $SiteURL

$FileList = @()
$Property = @('LeafName','CheckedOutBy','CheckedOutByName','CheckedOutByEmail','TimeLastModified','DirName')

#Loop through each sub-site of the site collection
ForEach($Web in $Site.AllWebs){
    Write-Output "Searching for Checked out Files with no Checked in Version at:" $Web.Url
    #Loop through each list
    ForEach($List in $Web.Lists) {
        #Get Checked out files with no checkin versions
        $CheckedOutFiles = $List.CheckedOutFiles
 
        #Loop through each checked out File
        ForEach ($File in $CheckedOutFiles){
            If ($File){
                $FileList += $File | Select-Object -Property $Property
                
                If ($CheckIn){
                    Set-OwnershipCheckin -File $File
                }                
            }
        }
        #$FileList
    }
}
$FileList | Export-Csv  -Path D:\temp\NoVersionCheckedOut.csv -NoTypeInformation
