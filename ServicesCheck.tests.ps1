<# 
.Description
    The script will check all the running services against csv files collected by 'CollectServices.ps1'.
.Example
    Invoke-Pester .\ServicesCheck.tests.ps1
#>

#This script is written by Naw Awn using Pester.

Start-Transcript C:\Temp\Services\ServicesCheck.Log -Force

$CsvPath= "C:\Temp\Services"
 
Describe 'Service status check'{
    $Files = (Get-ChildItem $CsvPath\*.csv)
    Context 'Csv Files Check'{          
        Foreach($file in $Files){ 
            It "$file Size should be greater than 0KB"{ 
                $file.length | Should BeGreaterThan 0 
            }
            It 'should have more than 1 row' {
	            (Import-Csv -path $file.FullName).Count | should BeGreaterThan 1
	        }
        } 
    }      
    Context 'Server Check'{ 
        Foreach($Computer in $Files.basename){ 
            $PingResult = (Test-Connection $Computer -Count 1 -Quiet) 
            It "$Computer should be up and runing"{ 
                $PingResult | Should Be $true                 
            }
            
            If (!($PingResult)) { Continue }
            Context "$Computer Service Check"{ 
                $Services = (Import-Csv $CsvPath\$Computer.csv)      
                Foreach($Service in $Services){ 
                    It "$Computer $Service should be runnning"{ 
                        (Get-Service -ComputerName $Computer -Name $Service.Name).Status | Should Be 'Running' 
                    } 
                } 
            } 
        } 
    } 
}
 
Stop-Transcript
