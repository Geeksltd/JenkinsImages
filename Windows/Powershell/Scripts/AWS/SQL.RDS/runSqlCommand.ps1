function runSqlCommand()
{
param(
    [Parameter(mandatory=$true)][string]$command,
    [string]$databaseServer=$env:DATABASE_SERVER,
    [Parameter(mandatory=$true)][string]$databaseName,
    [string]$databaseUsername=$env:DATABASE_MASTER_USERNAME,
    [string]$databasePassword=$env:DATABASE_MASTER_PASSWORD
    )
 
 Write-Host "Running ..."  
 $result = Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command -DisableCommands -AbortOnError
 Write-Host "Finished running ..."

 return $result;
}