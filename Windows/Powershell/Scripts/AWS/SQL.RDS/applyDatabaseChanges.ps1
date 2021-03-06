function applyDatabaseChanges()
{
    param(
        [Parameter(mandatory=$true)][string]$databaseName,
        [Parameter(mandatory=$true)][string]$referenceDatabaseName,
        [Parameter(mandatory=$true)][string]$backup_s3_bucket,
        [Parameter(mandatory=$true, ValueFromPipeline=$true)]$lastSuccessfulDeploymentCommit
        )

	$changeScripts = getDBChangeScripts $lastSuccessfulDeploymentCommit;

    if($changeScripts.Length -eq 0)
    {
        Write-Host "No database changes detected.";
        return;
    }

    $dateTag=$([DateTime]::Now.ToString("dd.MM.yyyy@hh.mm.ss"))      
    $backupFileOnS3 = $backup_s3_bucket + "/" +  $dateTag + ".bak";

    
    Write-Host "Renaming the current database:" $databaseName    
    renameDatabase $databaseName $referenceDatabaseName

    Write-Host "Backing up:" $referenceDatabaseName    
    backupDatabase $referenceDatabaseName $backupFileOnS3

    Write-Host "Restoring:" $databaseName    
    restoreDatabase $databaseName $backupFileOnS3

    Write-Host "Running change scripts on:" $databaseName    
    runChangeScripts $databaseName $changeScripts

    return $referenceDatabaseName;
}