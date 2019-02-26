function getLastSuccessfulDeploymentCommitDate(){

$lastDeploymentTagDate=[DateTime]::Parse($(git tag --contains=$DEPLOY_TAG_PREFIX --sort=-taggerdate --format="%(taggerdate:iso)" | Select-Object -first 1))

if($LASTEXITCODE -eq 129){
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