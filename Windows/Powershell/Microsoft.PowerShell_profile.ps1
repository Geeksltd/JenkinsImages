$ErrorActionPreference = "Stop"

$scriptsDir="Scripts"  
Get-ChildItem "$pshome\${scriptsDir}\*.ps1" -Recurse | foreach{.$_} 