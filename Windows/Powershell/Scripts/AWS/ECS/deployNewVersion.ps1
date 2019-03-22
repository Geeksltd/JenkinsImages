function registerNewTaskRevision()
{
     param(
        [Parameter(mandatory=$true)][string]$newImage,
        [string]$taskName=$env:PROJECT_TASK_FAMILY_NAME
        )
    
    $taskinfo= aws ecs describe-task-definition --task-definition $taskName --region $REGION | ConvertFrom-Json;
    $newTaskDefinition=$taskinfo.taskDefinition[0] | Select-Object -Property * -ExcludeProperty status,compatibilities,taskDefinitionArn,requiresAttributes,revision;
    $newTaskDefinition.containerDefinitions[0].iamge=$newImage;
    $jsonArg = $newTaskDefinition | ConvertTo-Json -Depth 10;

    $newTaskDefinition = aws ecs register-task-definition --family $PROJECT_TASK_FAMILY_NAME --cli-input-json $($jsonArg.Replace("`"","\`""))
    return ($taskDefinition | ConvertFrom-Json).taskDefinition.taskDefinitionArn;
}