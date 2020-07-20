Function Open-OneInstance{
    Param(
        [String]$FilePath = 'C:\Windows\system32\notepad.exe',
        [String[]]$Argument   
    )
    Begin{
        $Mutex = New-Object System.Threading.Mutex($false, [System.IO.Path]::GetFileName($FilePath))
        $Param = @{}
        $Param['FilePath'] = $FilePath
        If ($Argument){ $Param['ArgumentList'] = $Argument }
    }
    Process{
        try {
            [Void]$Mutex.WaitOne()
            $returnValue = Start-Process @Param -Wait -PassThru
        }
        finally {
            $Mutex.ReleaseMutex()
            $Mutex.Dispose()
        }
    }
    End{
        [System.Environment]::ExitCode($returnValue.ExitCode)
    }
<#
.Synopsis
   Open only one instance of an application by script 
.DESCRIPTION
   When running an application, this cmdlets open only one instance at a time.
   The same application can be run outside of the script but running it from the script will limit to only one at a time.
.EXAMPLE
   Open-OneInstance -FilePath 'C:\Windows\system32\notepad.exe'
.INPUTS
   Executable file and its arguments
#>
}
