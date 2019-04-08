function getLastSuccessfulDeploymentCommitDate(){
    param($lastSuccessfulDeploymentCommit)
if(!$lastSuccessfulDeploymentCommit)
{
    return [DateTime]::MinValue;
}

return [DateTime]::Parse($(git show -s --format="%ci" $lastSuccessfulDeploymentCommit))
}

function getDBChangeScriptsSince(){
param([Parameter(mandatory=$true, ValueFromPipeline=$true)]$lastDeploymentDate)
    
    $dbChangesDir="DB-Changes"
    $result = New-Object Collections.Generic.List[string]

    if(Test-Path -Path $dbChangesDir)
    {
        foreach($file in Get-ChildItem $dbChangesDir)
        {
            $fileDate = getDateFromFileName($file);    
            
            if($fileDate -ne $null -and $fileDate -gt $lastDeploymentDate)
            {
                $result.Add($file.FullName)
            }
        }
    }

    return $result;
}


function getDBChangeScripts(){
    param($lastSuccessfulDeploymentCommit)
    return $(getLastSuccessfulDeploymentCommitDate  $lastSuccessfulDeploymentCommit | getDBChangeScriptsSince)
}

function getDateFromFileName($fileName)
{
    try{
        return [datetime]::parseexact($fileName,"yyyy-MM-dd@HH-mm-ss.SQL",$null);
    }
    catch [Exception]{
        return $null;
    }
}
