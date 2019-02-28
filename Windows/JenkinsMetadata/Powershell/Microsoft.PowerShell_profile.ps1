$ErrorActionPreference = "Stop"

$sqlDir="SQL"  
Get-ChildItem "$pshome\${sqlDir}\*.ps1" | foreach{.$_} 