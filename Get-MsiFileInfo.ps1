Function Get-MsiFileInfo{ 
    [CmdletBinding()]
    Param(
        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({
            if (([System.IO.FileInfo]$_).Extension -eq ".msi") { $true }
            else { throw "Path must be an msi file." } 
        })]
        [Alias ("FullName")]
        [System.IO.FileInfo]$Path   
    )
    Begin{    
        $Query = "SELECT * FROM Property"    
    }
    Process {
        $MsiValue = @{}  
        Write-Verbose "Open and Read property from MSI database"
        $MsiObj = New-Object -ComObject WindowsInstaller.Installer           
        $MsiDb  = $MsiObj.GetType().InvokeMember('OpenDatabase','InvokeMethod',$null,$MsiObj, @($Path.FullName, 0))        
        $View   = $MsiDb.GetType().InvokeMember('OpenView', 'InvokeMethod', $null, $MsiDb, ($Query))
        $View.GetType().InvokeMember('Execute', 'InvokeMethod', $null, $View, $null)
        While($Record = $View.GetType().InvokeMember('Fetch', 'InvokeMethod', $null, $View, $null)){             
            $Name  = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 1)                          
            $Value = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 2)              
            $MsiValue.Add($Name, $Value)  
        }
        $MsiValue.Add('FileName', $Path.Name)
        $MsiValue.Add('FilePath', $Path.FullName)
        
        Write-Verbose "Commit database and close view"
        $MsiDb.GetType().InvokeMember('Commit', 'InvokeMethod', $null, $MsiDb, $null)
        $View.GetType().InvokeMember('Close', 'InvokeMethod', $null, $View, $null) 
        $MsiDb = $null
        $View  = $null
        
        #Run garbage collection and release ComObject
        [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($MsiObj)
        [System.GC]::Collect()

        return ([PSCustomObject]$MsiValue)
    }
<#
.Synopsis
   Read MSI file properties
.EXAMPLE
   Get-MsiFileInfo -Path 'C:\temp\Microsoft\msodbcsql.msi'
.EXAMPLE
   $Property = @("ProductCode","ProductVersion","ProductName","Manufacturer","ProductLanguage")
   Get-ChildItem c:\temp\*.msi -File -Recurse | Get-MsiFileInfo | ft $Property
#>
}
