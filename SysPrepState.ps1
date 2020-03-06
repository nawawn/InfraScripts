# Build the script according to the suggestion from the website below
# https://www.repairwin.com/how-to-sysprep-windows-more-than-three-3-times-rearm/
# Written by Naw Awn
Function Get-SysprepState{
    [CmdletBinding()]
    Param()

    Process{
        $GenState   = (Get-ItemProperty "HKLM:\System\Setup\Status\SysprepStatus").GeneralizationState
        $CleanState = (Get-ItemProperty "HKLM:\System\Setup\Status\SysprepStatus").CleanupState
        $SkipRearm  = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform").SkipRearm
        $Panther    = (Test-Path -Path "$Env:WinDir\system32\Sysprep\Panther")
        $hash = @{
            'GeneralizationState' = $GenState
            'CleanupState'        = $CleanState
            'SkipRearm'           = $SkipRearm
            'Panther'             = $Panther
        }
        Return (New-Object PSObject -Property $hash)
    }
}

Function Reset-SysPrepState{
    [CmdletBinding()]
    Param()

    Process{
        If (Test-Path -Path 'HKLM:\System\Setup\Status\SysprepStatus'){
            Write-Verbose "Setting GeneralizationState value to 7"
            Set-ItemProperty -Path "HKLM:\System\Setup\Status\SysprepStatus" -Name GeneralizationState -Value 7
            
            Write-Verbose "Setting CleanupState value to 2"
            Set-ItemProperty -Path "HKLM:\System\Setup\Status\SysprepStatus" -Name CleanupState -Value 2
            
            Write-Verbose "Setting SkipRearm value to 1"
            Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform' -Name SkipRearm -Value 1

            Write-Verbose "Uninstalling MSDTC..."
            Uninstall-Dtc -Confirm:$False
            
            Start-Sleep 5
            
            Write-Verbose "Reinstalling MSDTC and setting startup to Manual..."
            Install-Dtc -LogPath "$Enn:WinDir\Temp" -StartType "DemandStart"
        }
        If (Test-Path -Path "$Env:Windir\System32\Sysprep\Panther"){
            Write-Verbose "Removing Panther folder from Sysprep"
            Remove-Item "$Env:Windir\System32\Sysprep\Panther" -Recurse -Confirm:$false
        }
    }
}

Get-SysprepState | Out-Default
#Reset-SysPrepState -verbose
