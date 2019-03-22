function updateService()
{
    param(
        [Parameter(mandatory=$true)][string]$newTaskDefinitionArn,
        [string]$serviceName=$env:PROJECT_ECS_SERVICE_NAME,
        [string]$clusterName=$env:ECS_CLUSTER_NAME,
        )

    aws ecs update-servivce --cluster $clusterName --service $serviceName --task-definition $newTaskDefinitionArn --region $REGION
}