[CmdletBinding()]
Param(
    $OutPath = 'C:\temp\Software'
)

Function Download-File{
    Param(
        $Url,
        $OutPath
    )
    $File = $Url.Substring($Url.LastIndexOf('/')+1)
    $OutFile = Join-Path $OutPath -ChildPath $File
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $Url -OutFile $OutFile

}

#Add Your Url here on the next line
$Urls = @'
https://www.7-zip.org/a/7z1900-x64.msi
https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.11.2-win64.msi
https://github.com/git-for-windows/git/releases/download/v2.22.0.windows.1/Git-2.22.0-64-bit.exe
'@ -split '\r\n'

Foreach ($Url in $Urls){
    Write-Output "Downloading File from: $Url"
    Download-File -Url $Url -OutPath $OutPath
}
