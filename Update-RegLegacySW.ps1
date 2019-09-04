#Use this script to work around the error below
#Error 1325. < > is not a valid short file name

Function Update-Registry{
<#
.Synopsis
   Change user profile registry key
.DESCRIPTION
   Use this script to work around the error 1325. < > is not a valid short file name when you install an old software.
.EXAMPLE
   To update the user profile registry with the %USERPROFILE% value, just run the command with a switch
   Update-Registry -USERPROFILE
.EXAMPLE
   To reverse back, just run the command without any switch
   Update-Registry
#>
    [CmdletBinding()]
    Param (        
        [Switch]$USERPROFILE
    )

    Begin{
        $RegPath  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' 
        $UserName = $env:USERNAME               
        $DefaultValue = @{
            'Desktop'     = "\\blm-fis-01\userdata\$UserName\MyDesktop"
            'Favorites'   = "\\blm-fis-01\userdata\$UserName\MyDocuments\IEFavorites"
            'My Pictures' = "\\blm-fis-01\userdata\$UserName\MyDocuments\My Pictures"
            'My Video'    = "\\blm-fis-01\userdata\$UserName\MyDocuments\My Videos"
            'Personal'    = "\\blm-fis-01\userdata\$UserName\MyDocuments"
        }
        $UsrProfValue = @{
            'Desktop'     = '%USERPROFILE%\Desktop'
            'Favorites'   = '%USERPROFILE%\Favorites'
            'My Pictures' = '%USERPROFILE%\Pictures'
            'My Video'    = '%USERPROFILE%\Videos'
            'Personal'    = '%USERPROFILE%\Documents'
        }
    }
    Process{
        If ($USERPROFILE){
            $Value = $UsrProfValue
        }
        Else{
            $Value = $DefaultValue
        }

        If (Test-Path $RegPath){
            Foreach ($item in $Value.Keys){
                Write-Verbose "Replace $item with the value $($Value[$item])"
                Set-ItemProperty -Path $RegPath -Name $Item -Value $($Value[$item])
            }
        }
        Else {
            Write-Warning "Unable to find the registry path!"
        }
    }
}

Update-Registry
#Update-Registry -USERPROFILE