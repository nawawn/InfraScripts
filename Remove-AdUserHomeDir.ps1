#Requires -Modules ActiveDirectory
Class RDLog{
    [String]$Name
    [String]$FolderPath
    [String]$Status
}
Function Remove-AdUserHomeDir{
    [CmdletBinding()]
    [OutputType([RDLog])]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Name
    )
    #Write-Outpupt $Name
    #Check if AD module is loaded
    try {
        If (!(Get-Module ActiveDirectory)){ Import-Module ActiveDirectory }
    }
    #[System.IO.FileNotFoundException]
    catch {
        Write-Warning "Unable to load the ActiveDirecotry Module!" 
        return
    }
    Try{
        $HomeDir = (Get-AdUser -Identity $Name -Properties HomeDirectory).HomeDirectory
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{ 
        Write-Warning "$Name not found in Active Directory!"
        return
    }

    $Log = New-Object RDLog
        
    If (($null -ne $HomeDir) -and (Test-Path $HomeDir)){
        Write-Verbose "Removing $HomeDir..."
        Remove-Item -Path $HomeDir -Force -Confirm:$false -ErrorVariable ErrVar
        $Log.UserName = $Name
        $Log.FolderPath = $HomeDir
        If ($ErrVar){ $Log.Status = $ErrVar.Exception}
        Else {$Log.Status = "Deleted"}
    }
    
    #return username,folderpath,status
    return $Log
<#
.Synopsis
   Remove Home directory for a given user
.DESCRIPTION
   The cmdlet retrieves the HomeDirectory value from the AD User Properties and delete the home folder.
.EXAMPLE
   Remove-AdUserHomeDir -Name Username
.EXAMPLE
   Get-AdUser username | Remove-AdUserHomeDir
#>
}