function runSqlCommand()
{
param(
    [Parameter(mandatory=$true)][string]$command,
    [Parameter(mandatory=$true)][string]$databaseServer,
    [Parameter(mandatory=$true)][string]$databaseName,
    [Parameter(mandatory=$true)][string]$databaseUsername,
    [Parameter(mandatory=$true)][string]$databasePassword,
    )

 $startDate = Get-Date
 $timeOutminutes = 45
 $retryIntervalSeconds = 10

do {
    $awsResponse = Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command  -AbortOnError
    Write-Host $awsResponse.lifecycle $awsResponse."% complete"
    
    if($awsResponse.lifecycle -eq "SUCCESS") {break}
    
    start-sleep -seconds $retryIntervalSeconds

    } while ($startDate.AddMinutes($timeOutminutes) -gt (Get-Date))
}