Function Start-MouseWiggle{
    Begin {
        Add-Type -AssemblyName System.Windows.Forms
    }
    Process{    
        While($true){
            Start-Sleep -Seconds 5
            $x = (random 1000)
            $y = (random 1000)
            Write-Host "->move $x,$y " -NoNewline
            [Windows.Forms.Cursor]::Position = New-Object Drawing.Point $x,$y
        }
    }
}
Start-MouseWiggle
