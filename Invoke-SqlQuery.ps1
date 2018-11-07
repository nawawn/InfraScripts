<#
.Synopsis
   Execute SQL statement on the given SQL server
.DESCRIPTION
   Invoke-SqlQuery -ServerName <SQLServerName> -Database <Database> -Query <SQL Statement>
   This command is useful when you do not have Invoke-SqlCmd available on your computer.
.EXAMPLE
   Invoke-SqlQuery -ServerName SQLserver01 -Database master -Query "Select * from sys.databases" | select name,user_access_desc,recovery_model_desc,state_desc
.EXAMPLE
   Invoke-SqlQuery -ServerName SQLserver02 -Database Photo_Ordering -Query "SELECT Top 5 * FROM dbo.Photo_Order"
#>
function Invoke-SqlQuery
{    
    Param
    (            
        [Parameter(Mandatory=$true)][String]$ServerName,
        [Parameter(Mandatory=$true)][String]$Database,
        [Parameter(Mandatory=$true)][String]$Query        
    )
    Begin
    {
        $SqlConn = New-Object System.Data.SqlClient.SqlConnection
        $Connstr = "Server=$ServerName;Database=$Database;Integrated Security=True;"
        $SqlConn.ConnectionString = $Connstr
    }
    Process
    {
        $SqlConn.Open()    
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand($Query,$SqlConn)    
        $SqlDA  = New-Object System.Data.SqlClient.SqlDataAdapter($SqlCmd)
        $SqlDS  = New-Object System.Data.DataSet
        [void]$SqlDA.fill($SqlDS)
        $Data = $SqlDS.Tables
    }
    End
    {
        $SqlConn.Close()
        return ($Data)        
    }
}
