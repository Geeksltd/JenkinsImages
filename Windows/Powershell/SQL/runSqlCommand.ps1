function runSqlCommand()
{
param(
    [Parameter(mandatory=$true)][string]$command,
    [Parameter(mandatory=$true)][string]$databaseServer,
    [Parameter(mandatory=$true)][string]$databaseName,
    [Parameter(mandatory=$true)][string]$databaseUsername,
    [Parameter(mandatory=$true)][string]$databasePassword
    )

 Write-Host "Running ..."
 Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command -DisableCommands -AbortOnError
 Write-Host "Finished running ..."
}