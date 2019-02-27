$ErrorActionPreference = "Stop"

getDBChangeScripts.ps1

$sqlDir="SQL"  
Get-ChildItem "$pshome\${sqlDir}\*.ps1" | foreach{.$_} 