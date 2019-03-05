function runAwsSqlCommand()
{
param(
    [Parameter(mandatory=$true)][string]$command,
    [string]$databaseServer=$DATABASE_SERVER,
    [Parameter(mandatory=$true)][string]$databaseName,
    [string]$databaseUsername=$DATABASE_MASTER_USERNAME,
    [string]$databasePassword=$DATABASE_MASTER_PASSWORD
    )

 $startDate = Get-Date
 $timeOutminutes = 45
 $retryIntervalSeconds = 5

 Write-Host "Running ..."
 $awsResponse = Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command -DisableCommands -AbortOnError
 $task_id=$awsResponse.task_id 
 Write-Host "Finished running ..."
 
 Write-Host "Checking status for task id $task_id for $databaseName ..."
do {
    
    $getStatusCommand="exec msdb.dbo.rds_task_status @task_id=$task_id"
    $awsStatusResponse = Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $getStatusCommand  -DisableCommands -AbortOnError
    Write-Host $awsStatusResponse.lifecycle $awsStatusResponse."% complete" %
    
    if($awsStatusResponse.lifecycle -eq "SUCCESS") {    
        Write-Host "Completed in " $awsStatusResponse."duration(mins)" "min(s)"
        break
    }
    
    start-sleep -seconds $retryIntervalSeconds

    } while ($startDate.AddMinutes($timeOutminutes) -gt (Get-Date))
}