function rollbackDatabase()
{
	 param(        
    [Parameter(mandatory=$true)]$databaseName,    
    [Parameter(mandatory=$true)][string]$backupDatabaseName
    )

     $failedDatabaseName = $databaseName"_FAILED"
     renameDatabase $databaseName $failedDatabaseName
     renameDatabase $backupDatabaseName $databaseName
}
