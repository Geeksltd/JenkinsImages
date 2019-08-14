function updateService()
{
    param(
        [Parameter(mandatory=$true)][string]$newTaskDefinitionArn,
        [string]$serviceName=$env:PROJECT_ECS_SERVICE_NAME,
        [string]$clusterName=$env:ECS_CLUSTER_NAME,
        [string]$region=$env:REGION
        )

    aws ecs update-service --profile $env:AWS_PROFILE --cluster $clusterName --service $serviceName --task-definition $newTaskDefinitionArn --region $region
}