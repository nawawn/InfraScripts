Function Replace-Char{
    [OutputType([String])]
    Param(        
        [Parameter(Mandatory)][String]$String,
        [Parameter(Mandatory)][Int64]$Index,
        [Parameter(Mandatory)][Char]$Char
    )
    Process{
        $leftPart  = $String.Substring(0,$Index)
        $rightPart = $String.Substring($Index+1)

        Return ($leftPart + $Char + $rightPart)
    }
<#
.DESCRIPTION
   Replace a single character on a given string.
.EXAMPLE
   $String = "This dollar sign $ will be replaced with a sterling pound £ sign. This one $ won't be replaced."
   Replace-Char -String $String -Index ($String.IndexOf('$')) -Char "£"

   This dollar sign £ will be replaced with a sterling pound £ sign. This one $ won't be replaced.
#>
}