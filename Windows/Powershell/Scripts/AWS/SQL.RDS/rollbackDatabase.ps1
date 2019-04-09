function rollbackDatabase()
{
	 param(        
    [Parameter(mandatory=$true)]$currentDatabaseName,    
    [Parameter(mandatory=$true)][string]$databaseNameToRestore
    )   
     
     $failedDatabaseName = "${databaseNameToRestore}_$(Get-Date -format "_ddMMyy@hh.mm.ss.fff")_FAILED"
     
     renameDatabase $currentDatabaseName $failedDatabaseName
     renameDatabase $databaseNameToRestore $currentDatabaseName
}
