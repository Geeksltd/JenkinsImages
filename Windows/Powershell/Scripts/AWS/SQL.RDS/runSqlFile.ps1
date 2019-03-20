function runSqlFile()
{
param(
    [Parameter(mandatory=$true)][string]$file,
    [string]$databaseServer=$env:DATABASE_SERVER,
    [Parameter(mandatory=$true)][string]$databaseName,
    [string]$databaseUsername = $env:DATABASE_MASTER_USERNAME,
    [string]$databasePassword = $env:DATABASE_MASTER_PASSWORD
    )

 Write-Host "Running ..." 
 Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -InputFile $file -DisableCommands -AbortOnError
 Write-Host "Finished running ..."
}