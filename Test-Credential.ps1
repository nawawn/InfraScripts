$cred = Get-Credential
$username = $cred.username
$password = $cred.GetNetworkCredential().password

 # Get current domain using logged-on user's credentials
$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
$domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
 
if ($domain.name -eq $null){
    Write-Output "Authentication failed - please verify your username and password." 
}
else{
    Write-Output "Successfully authenticated with domain $($domain.name)"
}
