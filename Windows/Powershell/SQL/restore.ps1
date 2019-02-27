function restoreDatabase()
{
    param(
        [Parameter(mandatory=$true)][string]$databaseName,
        [Parameter(mandatory=$true)][string]$s3_object_arn_to_restore_from,
        [Parameter(mandatory=$true)][string]$databaseServer,        
        [Parameter(mandatory=$true)][string]$databaseUsername,
        [Parameter(mandatory=$true)][string]$databasePassword
        )

    $command = "exec msdb.dbo.rds_restore_database 
                @restore_db_name='$databaseName', 
                @s3_arn_to_restore_from='$s3_object_arn_to_restore_from';"

    
    runAwsSqlCommand $command $databaseServer 'master' $databaseUsername $databasePassword
}