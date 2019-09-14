Function Send-TeamAlert{
    Param(
        [String]$Message
    )
    Begin{
        $Uri = 'Paste your MS Team Uri here i.e. https://outlook.office.com/webhook/guid@guid/incomingwebhook/somemoreguid'
    }
    Process{
        $Body = @{
            text = $Message
        } | ConvertTo-Json

        Invoke-RestMethod -Uri $Uri -Method Post -Body $Body -ContentType 'application/json'
    }
}

Function Send-EmailAlert{
    Param(
        [String]$Message,
        [PSCredential]$Credential
    )
    Begin{
        $MailParam = @{}
        $MailParam.Add('From',      "machine@mydomain.com"   )
        $MailParam.Add('To',        "naw.awn@mydomain.com"   )
        $MailParam.Add('Subject',   "Process Status Alert"   )
        $MailParam.Add('Body',       $Message                )
        $MailParam.Add('SmtpServer',"ExchangeServer"         )
        If ($Credential){ $MailParam.Add('Credential',$Credential) }
    }
    Process{
        Send-MailMessage @MailParam
    }
}

Function Watch-Process{
    Param(
        [Parameter(Mandatory, ValueFromPipeline, 
            ValueFromPipelineByPropertyName,                    
            Position=0)]        
        [ValidateNotNullorEmpty()]$Name,
        [AllowNull()][PSCredential]$Credential,  
        [Switch]$TeamAlert,
        [Swtich]$EmailAlert          
    )
    Begin{
        $Start = Get-Date
    }
    Process{
        While(Get-Process -Name $Name -ErrorAction 'SilentlyContinue'){
            Get-Process -Name $Name | Select Handles,PM,CPU,@{n='Time';e={Get-Date}}
            Start-Sleep 60        
        }        
        $Stop = Get-Date
        $Info = "The {0} process started on {1} and finished at {2}."
        $Message = $Info -f $Name, $Start, $Stop
        Write-Verbose $Message
        New-TimeSpan -Start $Start -End $Stop
        
        If ($PSBoundParameters.ContainsKey('EmailAlert')){
            If ($Credential){
                Write-Verbose "Sending an email alert!"
                Send-EmailAlert -Message $Message -Credential $Credential
            }
            Else {
                Write-Verbose "Sending an email alert!"
                Send-EmailAlert -Message $Message
            }
        }
        If ($PSBoundParameters.ContainsKey('TeamAlert')){
            Write-Verbose "Sending an alert to Team Channel"
            Send-TeamAlert -Message $Message
        }
    }
<#
.DESCRIPTION
   This script can monitor a process and send an alert email and/or a message to MS Team when it terminates.
   Enter credential if the current running user has no right to send mail message from local exchange server.  
.EXAMPLE
   $Cred = Get-Credential
   Watch-Process -Name 'notepad' -TeamAlert -EmailAlert -Credential $Cred
.EXAMPLE
   Get-Process -Name 'notepad' | Watch-Process -TeamAlert -EmailAlert
#>
}

