Param(
    $OutFilePath = 'C:\temp',
    $Byte = 16,
    $UserName,
    $Password
)

Function Get-RandomAESKey{
    # Key sizes - 128, 192, and 256 bits
    # Key Sizes - 16, 24, and 32 bytes respectively
    [OutputType([Byte[]])]
    Param(
        [ValidateNotNullOrEmpty()]
        [ValidateSet(16, 24, 32)]
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
        [Parameter(Mandatory)][String]$AESKeyFilePath        
    )
    $EncryptedString = Get-Content $EncryptedFilePath
    $Key = Get-Content $AESKeyFilePath
    Return (New-Object -TypeName System.Management.Automation.PSCredential($UserName,($EncryptedString | ConvertTo-SecureString -Key $Key)))
}

#region Controller

$KeyFile = "$OutFilePath\AES.Key"
$PassFile = "$OutFilePath\Pass.txt"

Get-RandomAESKey -Byte $Byte | Out-File "$OutFilePath\AES.key"
New-EncryptedString -String $Password -Key (Get-Content "$OutFilePath\AES.key") | Out-File "$OutFilePath\Pass.txt"

If (Test-Path $KeyFile){ Write-Output "Key file is created in $KeyFile"}
If (Test-Path $PassFile){Write-Output "Pass file is saved in $PassFile" }

#When you need to create credential using those files
$Cred = New-PSCredential -UserName $UserName -EncryptedFilePath $PassFile -AESKeyPath $KeyFile
Return $Cred

#endregion Controller
