$ErrorActionPreference = "Stop"

$sqlDir="Scripts"  
Get-ChildItem "$pshome\${sqlDir}\*.ps1" -Recurse | foreach{.$_} 