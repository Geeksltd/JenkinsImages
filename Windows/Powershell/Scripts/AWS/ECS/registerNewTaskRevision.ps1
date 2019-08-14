function registerNewTaskRevision()
{
     param(
        [Parameter(mandatory=$true)][string]$newImage,
        [string]$taskName=$env:PROJECT_TASK_FAMILY_NAME,
        [string]$region=$env:REGION        
        )    
    
    $taskinfo= aws ecs describe-task-definition --task-definition $taskName --region $region --profile $env:AWS_PROFILE | ConvertFrom-Json;
    $newTaskDefinition=$taskinfo.taskDefinition[0] | Select-Object -Property * -ExcludeProperty status,compatibilities,taskDefinitionArn,requiresAttributes,revision;
    $newTaskDefinition.containerDefinitions[0].image=$newImage;   
    $jsonArg = $newTaskDefinition | ConvertTo-Json -Depth 10;

    $newTaskDefinition = aws ecs register-task-definition --profile $env:AWS_PROFILE --region $region --family $taskName --cli-input-json $($jsonArg.Replace("`"","\`""))
    return ($newTaskDefinition | ConvertFrom-Json).taskDefinition.taskDefinitionArn;
}

function ToPsObject($keyValuePair)
{   
    $obj = New-Object -TypeName PSObject;
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $keyValuePair.Key
    $obj | Add-Member -MemberType NoteProperty -Name value -Value $keyValuePair.Value           
    return $obj;
}