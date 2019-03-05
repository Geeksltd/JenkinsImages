function runSqlCommand()
{
param(
    [Parameter(mandatory=$true)][string]$command,
    [string]$databaseServer=$DATABASE_SERVER,
    [Parameter(mandatory=$true)][string]$databaseName,
    [string]$databaseUsername=$DATABASE_MASTER_USERNAME,
    [string]$databasePassword=$DATABASE_MASTER_PASSWORD
    )
 
 Write-Host "Running ..."
 Write-Host $command
 Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command -DisableCommands -AbortOnError
 Write-Host "Finished running ..."
}