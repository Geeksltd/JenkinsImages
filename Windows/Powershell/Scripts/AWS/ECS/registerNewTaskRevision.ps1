function registerNewTaskRevision()
{
     param(
        [Parameter(mandatory=$true)][string]$newImage,
        [string]$taskName=$env:PROJECT_TASK_FAMILY_NAME,
        [string]$region=$env:REGION,
        [System.Collections.Hashtable]$environmentVariables
        )
    
    $taskinfo= aws ecs describe-task-definition --task-definition $taskName --region $region | ConvertFrom-Json;
    $newTaskDefinition=$taskinfo.taskDefinition[0] | Select-Object -Property * -ExcludeProperty status,compatibilities,taskDefinitionArn,requiresAttributes,revision;
    $newTaskDefinition.containerDefinitions[0].image=$newImage;   
    $envsDic = ConvertToEnvironmentVariables($environmentVariables);    
    $newTaskDefinition.containerDefinitions[0].environment=$envsDic;
    $jsonArg = $newTaskDefinition | ConvertTo-Json -Depth 10;

    $newTaskDefinition = aws ecs register-task-definition --region $region --family $taskName --cli-input-json $($jsonArg.Replace("`"","\`""))
    return ($newTaskDefinition | ConvertFrom-Json).taskDefinition.taskDefinitionArn;
}

function ConvertToEnvironmentVariables([System.Collections.Hashtable] $environmentVariables)
{
    $result = New-Object System.Collections.Generic.List[System.Object];
    
    if($environmentVariables){      
    $environmentVariables.GetEnumerator() | ForEach-Object { $item = ToPsObject($_); $result.Add($item) }   
    }

    return ,$result.ToArray();
}

function ToPsObject($keyValuePair)
{   
    $obj = New-Object -TypeName PSObject;
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $keyValuePair.Key
    $obj | Add-Member -MemberType NoteProperty -Name value -Value $keyValuePair.Value           
    return $obj;
}