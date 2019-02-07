docker run -it --rm -p 8080:8080 `
--name [#PROJECT#]-[#BRANCH#] `
--env DOCKER_HOST=$("tcp://"+(Test-Connection -ComputerName $env:computername -count 1).IPV4Address.ipaddressTOstring + ":2375") `
--env PROJECT_JENKINSFILE_GIT_URL=https://github.com/Geeksltd/MasterJenkinsfile.git `
--env PROJECT_JENKINSFILE_NAME=[#PROJECT_JENKINSFILE_NAME#] `
--env BRANCH=[#BRANCH#] `
--env PROJECT=[#PROJECT#] `
--env TASK_ROLE_NAME=[#TASK_ROLE_NAME#] `
--env ECS_CLUSTER_NAME=[#ECS_CLUSTER_NAME#] `
--env PROJECT_TASK_FAMILY_NAME=[#PROJECT_TASK_FAMILY_NAME#] `
--env PROJECT_ECS_SERVICE_NAME=[#PROJECT_ECS_SERVICE_NAME#] `
--env JENKINS_ADMIN_PASSWORD=$((New-Guid).ToString()) `
--env PROJECT_REPOSITORY_URL=[#PROJECT_REPOSITORY_URL#] `
--env PROJECT_REPOSITORY_USERNAME=[#PROJECT_REPOSITORY_USERNAME#] `
--env PROJECT_REPOSITORY_PASSWORD="[#PROJECT_REPOSITORY_PASSWORD#]" `
--env CONTIANER_REPOSITORY_URL=[#CONTIANER_REPOSITORY_URL#] `
--env REGION=$(((Invoke-WebRequest -uri http://169.254.169.254/latest/dynamic/instance-identity/document).Content | ConvertFrom-Json).region) `
-v D:\JenkinsJobs\[#PROJECT#]\:[#JENKINS_HOME#]\jobs\[#PROJECT#]\builds `
-v D:\BuildServerAgentAWSCredentials\:~\.aws\ `
geeksltd/jenkins-windows:1.03