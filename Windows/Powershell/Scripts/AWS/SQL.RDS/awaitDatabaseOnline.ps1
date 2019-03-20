function awaitDatabaseOnline()
{
param(    
    [string]$databaseServer=$env:DATABASE_SERVER,
    [Parameter(mandatory=$true)][string]$databaseName,
    [string]$databaseUsername=$env:DATABASE_MASTER_USERNAME,
    [string]$databasePassword=$env:DATABASE_MASTER_PASSWORD
    )

 $timeOutminutes=5
 $retryIntervalSeconds = 2

 Write-Host "Checking status for $databaseName ..."
do {
    
    $getStatusCommand="SELECT state_desc FROM sys.databases where name='$databaseName'"
    $awsStatusResponse = runSqlCommand $getStatusCommand -databaseName 'master'
    $status = $awsStatusResponse.state_desc
    Write-Host $databaseName " Status : " $status
    
    if($status -eq "ONLINE") {    
        Write-Host  $databaseName "is online";
        return;
    }
    
    start-sleep -seconds $retryIntervalSeconds

    } while ($startDate.AddMinutes($timeOutminutes) -gt (Get-Date))

    // timed out
    throw "Database status check timed out for $databaseName after $timeOutminutes minutes";
}