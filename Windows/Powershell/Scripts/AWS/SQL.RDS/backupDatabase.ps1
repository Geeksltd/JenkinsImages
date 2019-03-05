function backupDatabase()
{
    param(
        [Parameter(mandatory=$true)][string]$databaseName,
        [Parameter(mandatory=$true)][string]$s3_object_arn_to_backup_to        
        )

    $command = "exec msdb.dbo.rds_backup_database 
                @source_db_name='$databaseName', 
                @s3_arn_to_backup_to='$s3_object_arn_to_backup_to',
                @overwrite_S3_backup_file=1,
                @type='FULL';"

    runAwsSqlCommand $command -databaseName $databaseName
}