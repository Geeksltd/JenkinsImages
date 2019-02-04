$Credentials=(aws sts assume-role --role-arn [#BuildServerAgent_ROLE_ARN#] --duration-seconds 43200 --role-session-name [#PROJECT_NAME#] | ConvertFrom-Json | select -expand Credentials)
$AccessKeyId=$Credentials.AccessKeyId
$SecretAccessKey=$Credentials.SecretAccessKey
$SessionToken=$Credentials.SessionToken
docker run -it --rm -p 8080:8080 `
--env DOCKER_HOST=$("tcp://"+(Test-Connection -ComputerName $env:computername -count 1).IPV4Address.ipaddressTOstring + ":2375") `
--env PROJECT_JENKINS_FILE_GIT_URL=https://github.com/Geeksltd/MasterJenkinsfile.git `
--env BRANCH=[#BRANCH#] `
--env PROJECT=[#PROJECT#] `
--env PROJECT_TASK_FAMILY_NAME=[#PROJECT_TASK_FAMILY_NAME#] `
--env PROJECT_ECS_SERVICE_NAME=[#PROJECT#] `
--env JENKINS_ADMIN_PASSWORD=$((New-Guid).ToString()) `
--env PROJECT_REPOSITORY_URL=[#PROJECT_REPOSITORY_URL#] `
--env PROJECT_REPOSITORY_USERNAME=[#PROJECT_REPOSITORY_USERNAME#] `
--env PROJECT_REPOSITORY_PASSWORD="[#PROJECT_REPOSITORY_PASSWORD#]" `
--env CONTIANER_REPOSITORY_URL=[#CONTIANER_REPOSITORY_URL#] `
--env AWS_ACCESS_KEY_ID=$AccessKeyId `
--env AWS_SECRET_ACCESS_KEY=$SecretAccessKey `
--env AWS_SESSION_TOKEN=$SessionToken `
--env REGION=$(((Invoke-WebRequest -uri http://169.254.169.254/latest/dynamic/instance-identity/document).Content | ConvertFrom-Json).region)
-v D:\JenkinsJobs\[#PROJECT#]\:[#JENKINS_HOME#]\jobs\[#PROJECT#]\builds `
geeksltd/jenkins-windows:1.03