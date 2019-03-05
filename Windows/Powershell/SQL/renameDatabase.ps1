function renameDatabase()
{
    param(        
    [Parameter(mandatory=$true)][string]$currentDatabaseName,    
    [Parameter(mandatory=$true)][string]$newDatabaseName
    )	


    $killConnectionsCommand = "DECLARE @kill varchar(8000) = '';  
                               SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
                               FROM sys.dm_exec_sessions
                               WHERE database_id  = db_id('$currentDatabaseName')

                               EXEC(@kill);"
    runSqlCommand -command $killConnectionsCommand -databaseName 'master'

    
    $renameCommand = "EXEC rdsadmin.dbo.rds_modify_db_name N'$currentDatabaseName', N'$newDatabaseName'";   
    runSqlCommand -command $renameCommand -databaseName 'master'    
}