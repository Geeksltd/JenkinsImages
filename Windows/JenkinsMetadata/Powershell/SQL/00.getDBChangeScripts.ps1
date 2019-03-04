function getLastSuccessfulDeploymentCommitDate(){

$lastDeploymentTagDate=[DateTime]::Parse($(git describe --match "$DEPLOYMENT_TAG_PREFIX*" | git log -1 --format=%ai))

if($LASTEXITCODE -ne 0){
    $lastDeploymentTagDate = [DateTime]::MinValue;
}

return $lastDeploymentTagDate;
}

function getDBChangeScriptsSince(){
param([Parameter(mandatory=$true, ValueFromPipeline=$true)]$lastDeploymentDate)

    $result = New-Object Collections.Generic.List[string]
    foreach($file in Get-ChildItem DB-Changes)
    {
        $fileDate = getDateFromFileName($file);    
        
        if($fileDate -ne $null -and $fileDate -gt $lastDeploymentDate)
        {
            $result.Add($file)
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
