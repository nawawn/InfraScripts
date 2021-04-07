Function Get-SoftwareInfo{
    Param(
        $DisplayName
    )
    
    Process{  
        $registryViews = @([Microsoft.Win32.RegistryView]::Registry32, [Microsoft.Win32.RegistryView]::Registry64)

        foreach($view in $registryViews) {
            $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)
            $SubKey = $key.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")

            $SubKeyName = $SubKey.GetSubKeyNames() | Where-Object{$subKey.OpenSubKey($_).GetValue("DisplayName") -eq $DisplayName} | Select -First 1

            If ($subKeyName) {
                $InstallDate = $SubKey.OpenSubKey($subKeyName).GetValue("InstallDate")
                $InstallLocation = $SubKey.OpenSubKey($subKeyName).GetValue("InstallLocation")
                $UninstallString = $SubKey.OpenSubKey($subKeyName).GetValue("UninstallString")
                $BundleProviderKey = $SubKey.OpenSubKey($subKeyName).GetValue("BundleProviderKey")
                [PsCustomObject][Ordered]@{
                    DisplayName = $DisplayName
                    InstallDate = $InstallDate
                    InstallLocation = $InstallLocation
                    UninstallString = $UninstallString
                    BundleProviderKey = $BundleProviderKey
                }
                #New-Object -TypeName PsObject -Property $hash              
            }
        }
    }
}