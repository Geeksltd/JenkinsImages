function runChangeScripts()
{
    param(
	[Parameter(mandatory=$true)][string]$databaseName,
    [Parameter(mandatory=$true)][Collections.Generic.List[string]]$changeScripts
    )


    foreach($file in $changeScripts)
    {
        Write-Host "Running " + $file
        runSqlFile $file -databaseName $databaseName
        Write-Host "Finished running " + $file
    }

}