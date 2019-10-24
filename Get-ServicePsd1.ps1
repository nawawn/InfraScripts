Function Get-ServicePSD1{
    Param(
            [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName,Position=0)]
            [String]$ComputerName
        )

    Begin{
        $begin = '@{'
        $end   = '}'
        Write-Output $begin
    }
    Process{
        $ServiceList = (Get-Service -ComputerName $ComputerName) 
        [String]$Running = (($ServiceList.where{$_.Status -eq 'Running'}).Name) | %{"'"+ "$_" + "',"}
        [String]$Stopped = (($ServiceList.where{$_.Status -eq 'Stopped'}).Name) | %{"'"+ "$_" + "',"}
        Write-Output "$Computername = @{"       
        Write-Output "`t Running = @{"
        Write-Output "`t`t Name = $((-Join $Running).TrimEnd(','))"
        Write-Output "`t}"
        Write-Output "`t Stopped = @{"
        Write-Output "`t`t Name = $((-Join $Stopped).TrimEnd(','))"
        Write-Output "`t}"
        Write-Output "}"                
    }
    End{
        Write-Output $end
    }
<#
.EXAMPLE
   Get-ServicePSD1 -ComputerName localhost
.OUTPUTS
   @{
	    SQLServer = @{
		    Running = @{
			    Name = 	'MSSQLSERVER','MsDtsServer100','SQLBrowser','SQLSERVERAGENT'	
		    }
		    Stopped = @{
			    Name = 'ReportServer'
		    }	
	    }
    }
#>
}

Get-ServicePSD1 -ComputerName localhost