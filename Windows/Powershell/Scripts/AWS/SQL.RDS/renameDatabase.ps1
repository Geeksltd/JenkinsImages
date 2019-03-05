function renameDatabase()
{
    param(        
    [Parameter(mandatory=$true)][string]$currentDatabaseName,    
    [Parameter(mandatory=$true)][string]$newDatabaseName
    )	


    $command = "    
    DECLARE @kill varchar(8000) = '';  
    DECLARE @currentDbName nvarchar(128) = N'$currentDatabaseName'
    DECLARE @newDBName nvarchar(128) = N'$newDatabaseName'

IF (EXISTS (SELECT name 
FROM master.dbo.sysdatabases 
WHERE ('[' + name + ']' = @currentDbName 
OR name = @currentDbName)))
BEGIN

    SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
    FROM sys.dm_exec_sessions
    WHERE database_id  = db_id(@currentDbName)

    EXEC(@kill);

    EXEC rdsadmin.dbo.rds_modify_db_name @currentDbName, @newDBName    

END"    
    runSqlCommand $command -databaseName 'master'    
}