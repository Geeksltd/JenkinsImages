function restoreDatabase()
{
    param(
        [Parameter(mandatory=$true)][string]$databaseName,
        [Parameter(mandatory=$true)][string]$s3_object_arn_to_restore_from        
        )

    $command = "exec msdb.dbo.rds_restore_database 
                @restore_db_name='$databaseName', 
                @s3_arn_to_restore_from='$s3_object_arn_to_restore_from';"

    Invoke-Sqlcmd -ServerInstance $databaseServer -Database $databaseName -Username $databaseUsername -Password $databasePassword -Query $command
}