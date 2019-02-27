<#URL Reference for secure string to simple string: 
https://social.technet.microsoft.com/wiki/contents/articles/4546.working-with-passwords-secure-strings-and-credentials-in-windows-powershell.aspx
#>

Write-Output "Interactive Script for creating a new password"

[Int]$MinLength = 8
[Bool]$HasMinlen = $false
[Bool]$IsMatched = $false
[Bool]$IsComplex = $false

function Test-Complexity([String]$Text){
<#
.DESCRIPTION
   This is the helper function to test the password complexity.
.EXAMPLE
   Test-Complexity -Text "Abcd1234:"
#>
    If ($Text -cmatch "[A-Z]"){  [Bool]$HasUcase   = $true }
    If ($Text -cmatch "[a-z]"){  [Bool]$HasLcase   = $true }
    If ($Text -match "[0-9]") {  [Bool]$HasNumber  = $true }
    If (!($Text -match "[ ]")){  [Bool]$HasNoSpace = $true }
    If ($Text -match "[^a-zA-Z0-9]+"){ [Bool]$HasNonalpha = $true }

    return ($HasUcase -and $HasLcase -and $HasNumber -and $HasNoSpace -and $HasNonalpha) 
}

Do {
    $SecurePass = Read-Host -Prompt "Enter a new password" -AsSecureString
    $ConfirmPass = Read-Host -Prompt "Confirm your password" -AsSecureString
    
    $SecureText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePass))
    $ConfirmText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmPass))
        
    If ($SecurePass.length -ge $MinLength) {
        $HasMinlen = $true
    }
    Else { "Length not accepted" }
    
    If ($SecureText -ceq $ConfirmText) {
         $ISMatched = $true
    }
    Else { "They do not match" }
    
    If (Test-Complexity -Text $SecureText){
        $IsComplex = $true
    }
    Else{ "Not complex enough" }

}Until($HasMinlen -and $ISMatched -and $IsComplex)
Write-Output "Password is accepted"
return $SecureText