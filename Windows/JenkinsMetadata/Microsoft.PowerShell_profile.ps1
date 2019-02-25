function getLastSuccessfulDeploymentCommitDate(){
[alias("GetLastDeploymentCommit")]

$lastDeploymentTagDate=git tag --contains="Test-Pangolin" --sort=-taggerdate --format="%(taggerdate:iso)" | Select-Object -first 1;
if($LASTEXITCODE ==129)
	$lastDeploymentTagDate = [datetime].MinValue;

return [datetime]::Parse($lastDeploymentTagDate);
}

function getDBChangeScriptsSince($lastDeploymentDate)
{
	foreach($file in Get-ChildItem DB)
	{
		$fileDate = getDateFromFileName($file);
		if($fileDate != null && ($fileDate -lt @lastDeploymentDate))
		$file
	}
}


function getDateFromFileName($fileName)
{
	try{
	}
	
}