Function Get-SoftwareInfo{
    Param(
        $DisplayName
    )    
    Process{  
        $registryViews = @([Microsoft.Win32.RegistryView]::Registry32, [Microsoft.Win32.RegistryView]::Registry64)

        foreach($view in $registryViews) {
            $key    = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)
            $SubKey = $key.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
            $SubKeyName = $SubKey.GetSubKeyNames() | Where-Object{$subKey.OpenSubKey($_).GetValue("DisplayName") -eq $DisplayName} | Select -First 1

            If ($subKeyName) {
                [PsCustomObject][Ordered]@{
                    DisplayName     = $DisplayName
                    RgeHive         = $view
                    InstallDate     = $SubKey.OpenSubKey($subKeyName).GetValue("InstallDate")
                    InstallLocation = $SubKey.OpenSubKey($subKeyName).GetValue("InstallLocation")
                    UninstallString = $SubKey.OpenSubKey($subKeyName).GetValue("UninstallString")
                    BundleProviderKey = $SubKey.OpenSubKey($subKeyName).GetValue("BundleProviderKey")    
                }              
            }
        }
    }
<#
.Synopsis
   Get some information about the software installed.
.DESCRIPTION
   The cmdlet retrieves both 32-bit and 64-bit registry key for a given software display name.
.EXAMPLE
   Get-SoftwareInfo -DisplayName 'Microsoft Visual Studio Code'

    DisplayName       : Microsoft Visual Studio Code
    InstallDate       : 20210414
    InstallLocation   : C:\Program Files\Microsoft VS Code\
    UninstallString   : "C:\Program Files\Microsoft VS Code\unins000.exe"
    BundleProviderKey : 
#>
}

Function Get-InstalledProgram{
    Param(
        [String]$ComputerName = $env:COMPUTERNAME
    )
    Begin{        
        $RegistryView = @([Microsoft.Win32.RegistryView]::Registry32, [Microsoft.Win32.RegistryView]::Registry64)
        $RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $SoftwareHKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    }
    Process{    
        Foreach($View in $RegistryView){
            $Key    = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $ComputerName, $View)
            $SubKey = $Key.OpenSubKey($SoftwareHKey)
            $KeyList = $SubKey.GetSubKeyNames()
            Write-Verbose "Uninstall Key Count: $($KeyList.Count) $View"
            Foreach($Item in $KeyList){          
                [PsCustomObject][Ordered]@{
                    DisplayName = $subKey.OpenSubKey($Item).GetValue('DisplayName')
                    RegHive     = $subKey.OpenSubKey($Item).View
                    Publisher   = $subKey.OpenSubKey($Item).GetValue('Publisher')
                    InstallDate = $subKey.OpenSubKey($Item).GetValue('InstallDate')                        
                    Version     = $subKey.OpenSubKey($Item).GetValue('DisplayVersion')
                    UninstallString = $subKey.OpenSubKey($Item).GetValue('UninstallString')
                }            
            }
        }
    }
<#
.Synopsis
   Get the list of Programs installed on the remote computer.
.DESCRIPTION
   The cmdlet retrieves both 32-bit and 64-bit registry key for all the software.
.EXAMPLE
   Get-InstalledProgram -ComputerName MyPC
#>
}