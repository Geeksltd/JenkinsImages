function registerNewTaskRevision()
{
     param(
        [Parameter(mandatory=$true)][string]$newImage,
        [string]$taskName=$env:PROJECT_TASK_FAMILY_NAME,
        [string]$region=$env:REGION
        )
    
    $taskinfo= aws ecs describe-task-definition --task-definition $taskName --region $region | ConvertFrom-Json;
    $newTaskDefinition=$taskinfo.taskDefinition[0] | Select-Object -Property * -ExcludeProperty status,compatibilities,taskDefinitionArn,requiresAttributes,revision;
    $newTaskDefinition.containerDefinitions[0].image=$newImage;
    $jsonArg = $newTaskDefinition | ConvertTo-Json -Depth 10;

    $newTaskDefinition = aws ecs register-task-definition --region $region --family $taskName --cli-input-json $($jsonArg.Replace("`"","\`""))
    return ($newTaskDefinition | ConvertFrom-Json).taskDefinition.taskDefinitionArn;
}