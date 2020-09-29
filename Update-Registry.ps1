Function Update-Registry{
    [CmdletBinding()]
    Param(
        $Path,
        $Key,
        $Value,
        $Type
    )
    Process{
        If (!(Test-Path -Path $Path)) {
            Write-Warning "Registry Path not found, creating $Path" 
            New-Item -Path $Path -Force
            New-ItemProperty -Path $Path -Name $Key -PropertyType $Type -Value $Value -Force       
            #Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $Type            
        }
        Else {            
            New-ItemProperty -Path $Path -Name $Key -PropertyType $Type -Value $Value -Force
            Write-Verbose "Setting has been updated - $Key : $Value"
        }
    }
}

#Disable DNS Probing 
$DisDNSProbe = @{
    Path  = 'HKLM:\System\Currentcontrolset\Services\Nlasvc\Parameters\Internet'
    Key   = 'EnableActiveProbing'
    Value = 0
    Type  = 'DWord'
}
Update-Registry @DisDNSProbe

#Disable Widnows Defender
$DisDefender = @{
    Path  = 'HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService'
    Key   = 'Start'
    Value = 4
    Type  = 'DWord'
}
Update-Registry @DisDefender

#Disable Windows Security Center
$DisSecCenter = @{
    Path  = 'HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc'
    Key   = 'Start'
    Value = 4
    Type  = 'DWord'
}
Update-Registry @DisSecCenter

#Disable Simple File Sharing
$DisSimSharing = @{
    Path  = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
    Key   = 'ForceGuest'
    Value = 0
    Type  = 'DWord'
}
Update-Registry @DisSimSharing

#Disable Fast User Switching
$DisFastSwitch = @{
    Path  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Key   = 'HideFastUserSwitching'
    Value = 1
    Type  = 'DWord'
}
Update-Registry @DisFastSwitch

#Disable NTFS LastAccessTime update
$DisLastAccess = @{
    Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
    Key   = 'NtfsDisableLastAccessUpdate'
    Value = 3
    Type  = 'DWord'
}
Update-Registry @DisLastAccess

#Set high priority to foreground applications
$SetForegroundApp = @{
    Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl'
    Key   = 'Win32PrioritySeparation'
    Value = 26
    Type  = 'DWord'
}
Update-Registry @SetForegroundApp

#Disable UAC
$DisUAC = @{
    Path  = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system'
    Key   = 'EnableLUA'
    Value = 0
    Type  = 'DWord'
}
Update-Registry @DisUAC

#Disable Shared Experiences (Shared Access)
$DisSharedXp = @{
    Path  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
    Key   = 'EnableCdp'
    Value = 1
    Type  = 'DWord'
}
Update-Registry @DisSharedXp

#Run Once powershell script after reboot 
$RunOnce1 = @{
    Path  = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
    Key   = 'MyScript'
    Value = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass "C:\temp\MyScript.ps1"'
    Type  = 'String'
}
Update-Registry @RunOnce1 -Verbose
