Function Get-ChildItemCount{
    Param($Path)
    Process{
        $TopFolders = Get-ChildItem -Path $Path -Directory
        Foreach($Folder in $TopFolders){
            [PsCustomObject]@{
                Name = $Folder.BaseName
                Count = (Get-ChildItem -Path $Folder -Recurse).Count
            }  
        }
    }
}

Function Get-DirectoryReport{
    Param(
        [String]$Root
    )
    Begin{ $here = Get-Location }
    Process{
        If (Test-Path -Path $Root){
            Set-Location $Root
        }
        Else { 
            Write-Warning "Invalid Path"
            return
        }
        Get-ChildItem -Path $Root -Recurse | Foreach{        
            New-Object -TypeName PSObject -Property @{
                Name         = $_.Name
                Type         = If($_.PSIsContainer){'Directory'} else{'File'}
                ParentPath   = $_.PSParentPath.replace('Microsoft.PowerShell.Core\FileSystem::','') | Resolve-Path -Relative
                RelativePath = $_ | Resolve-Path -Relative
                Depth        = ($_ | Resolve-Path -Relative).split('\\').Count
            }
        }
    }
    End{ Set-Location $here }
}

Function Out-RelativePath{
    Param(
        $Path
    )
    Begin{ $here = Get-Location }
    Process{        
        Set-Location $Path
        $list = Get-ChildItem -Recurse | Resolve-path -Relative 
        Foreach($l in $list){
            "'" + $l + "'`,"
            #If it's the last one, then no comma.
            If($l -eq $list[-1]){
                "'" + $l + "'"
            }
        }    
    }
    End{ Set-Location $here }
}

Function Get-DirStructure{
    Param(
        $Path
    )
    Get-DirectoryReport -Root $Path | 
        Sort-Object Depth,@{e='Type';'Desc'=$False} |
        Foreach{    
        for ($n = 1; $n -le $($_.Depth); $n++){ 
            If ($_.Type -eq 'File'){
                Write-Host ">" -NoNewline 
            }
            Else {Write-Host "+" -NoNewline}    
        }
        Write-Host "$($_.Name)`r"
    }
}