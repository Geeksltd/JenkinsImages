function rollbackDatabase()
{
	 param(        
    [Parameter(mandatory=$true)]$currentDatabaseName,    
    [Parameter(mandatory=$true)][string]$newDatabaseName
    )   
     renameDatabase $currentDatabaseName $newDatabaseName
}
