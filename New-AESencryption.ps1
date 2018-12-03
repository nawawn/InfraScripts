Function Get-RandomAESKey{
    # Key sizes - 128, 160, 192, 224, and 256 bits
    # Key Sizes - 16, 20, 24, 28 and 32 bytes respectively
    [OutputType([Byte[]])]
    Param(
        [ValidateNotNullOrEmpty()]
        [ValidateSet(16, 20, 24, 28, 32)]
        [int]$Byte = 16
    )
    $Key = New-Object System.Byte[] -ArgumentList $Byte
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    Return $Key
}

Function New-EncryptedString{
    [OutputType([String])]
    Param(
        [Parameter(Mandatory)][String]$String,
        [Parameter(Mandatory)][Byte[]]$Key
    )
    $EncryptedString = ConvertTo-SecureString -String $String -AsPlainText -Force | ConvertFrom-SecureString -Key $key
    Return $EncryptedString
}

Function New-PSCredential{
    [OutputType([PSCredential])]
    Param(
        [Parameter(Mandatory)][String]$UserName,
        [Parameter(Mandatory)][String]$EncryptedFilePath,
        [Parameter(Mandatory)][String]$AESKeyPath        
    )
    $EncryptedString = Get-Content $EncryptedFilePath
    $Key = Get-Content $AESKeyPath
    Return (New-Object -TypeName System.Management.Automation.PSCredential($UserName,($EncryptedString | ConvertTo-SecureString -Key $Key)))
}

#region Controller
Param(
    $OutFilePath = "C:\temp"
)
$KeyFile = "$OutFilePath\AES.Key"
$PassFile = "$OutFilePath\Pass.txt"

Get-RandomAESKey -Byte 32 | Out-File "$OutFilePath\AES.key"
New-EncryptedString -String 'P4ssword123456789!' -Key (Get-Content "$OutFilePath\AES.key") | Out-File "$OutFilePath\Pass.txt"
$Cred = New-PSCredential -UserName "Naw.Awn" -EncryptedFilePath $PassFile -AESKeyPath $KeyFile

If (Test-Path $KeyFile){ Write-Output "Key file is created in $KeyFile"}
If (Test-Path $PassFile){Write-Output "Pass file is saved in $PassFile" }

#endregion Controller