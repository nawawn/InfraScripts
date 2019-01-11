<#
.Synopsis
   Check the username and password
.DESCRIPTION
   The scripts continue to prompt username and password until they have correctly been entered.
.EXAMPLE
   Just run the ps1 file. Enter-Credential.ps1
#>

Function Test-Credential{
    Param(
        $UserName,
        $Password    
    )
    $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
    $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
    return (-Not($null -eq $domain.name))
}

do{
    $User = Read-Host "Enter the Domain\Username to run the Scheduled Task"
    $Pass = Read-Host "Password" -AsSecureString
    $Cred = New-Object System.Management.Automation.PSCredential($User,$Pass)
    $Password = $Cred.GetNetworkCredential().Password    
    If (Test-Credential -UserName $User -Password $Password){
        $IsCorrect = $true
    }
    Else {
        Write-Warning "Incorrect Username or Password!"
        $IsCorrect = $false
    }
}
Until ($IsCorrect)
