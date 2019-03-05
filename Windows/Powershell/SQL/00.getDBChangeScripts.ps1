function getLastSuccessfulDeploymentCommitDate(){
$lastDeploymentTag=$(git tag --sort=committerdate -l -n "$DEPLOYMENT_TAG_PREFIX*" | Select-Object -First 1) 
if(!$lastDeploymentTag)
{
    return [DateTime]::MinValue;
}

$lastDeploymentCommit = $(git rev-list -1 $lastDeploymentTag.Trim())
return [DateTime]::Parse($(git show -s --format="%ci" $lastDeploymentCommit))
}

function getDBChangeScriptsSince(){
param([Parameter(mandatory=$true, ValueFromPipeline=$true)]$lastDeploymentDate)

    $result = New-Object Collections.Generic.List[string]
    foreach($file in Get-ChildItem DB-Changes)
    {
        $fileDate = getDateFromFileName($file);    
        
        if($fileDate -ne $null -and $fileDate -gt $lastDeploymentDate)
        {
            $result.Add($file.FullName)
        }
    }

    return $result;
}


function getDBChangeScripts(){
    return $(getLastSuccessfulDeploymentCommitDate | getDBChangeScriptsSince)
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
