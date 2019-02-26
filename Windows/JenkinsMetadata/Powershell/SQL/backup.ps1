function backupDatabase()
{
    param(
        [Parameter(mandatory=$true)][string]$databaseName,
        [Parameter(mandatory=$true)][string]$s3_object_arn_to_backup_to,
        [Parameter(mandatory=$true)][string]$databaseServer,
        [Parameter(mandatory=$true)][string]$databaseUsername,
        [Parameter(mandatory=$true)][string]$databasePassword,
        )

    $command = "exec msdb.dbo.rds_backup_database 
                @source_db_name='$databaseName', 
                @s3_arn_to_backup_to='$s3_object_arn_to_backup_to',
                @overwrite_S3_backup_file=1,
                @type='FULL';"

    runSqlCommand($command,$databaseServer,$databaseName,$databaseUsername,$databasePassword)

}
