Function Send-EmailAlert{
    Param(
        [ValidateNotNullorEmpty()][String]$Process = "notepad",
        [AllowNull()][PSCredential]$Credential
    )
    Begin{
        $Start = Get-Date
    }
    Process{

        While(Get-Process $Process -ErrorAction 'SilentlyContinue'){
            Get-Process $Process | Select Handles,PM,CPU,@{n='Time';e={Get-Date}}
            Start-Sleep 60        
        }
        
        $Stop = Get-Date
        $Msg = "The process started on $Start and finished at $Stop"
        
        $MailParam = @{}
        $MailParam.Add('From',      "machine@mydomain.com")
        $MailParam.Add('To',        "naw.awn@mydomain.com"  )
        $MailParam.Add('Subject',   "$Process Job Completed"  )
        $MailParam.Add('Body',       $Msg                     )
        $MailParam.Add('SmtpServer',"ExchangeServer"              )
        If ($Credential){ $MailParam.Add('Credential',$Credential) }

        Send-MailMessage @MailParam
        New-TimeSpan -Start $Start -End $Stop
    }
<#
.EXAMPLE
   $Cred = Get-Credential
   Send-EmailAlert -Process 'notepad' -Credential $Cred
#>
}
