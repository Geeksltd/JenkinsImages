docker run -it --rm -p 8080:8080 `
--env DOCKER_HOST=$("tcp://" + (Test-Connection -ComputerName $env:computername -count 1).IPV4Address.ipaddressTOstring + ":2375") `
--env PROJECT_JENKINS_FILE_GIT_URL=https://github.com/Geeksltd/MasterJenkinsfile.git `
--env BRANCH=[#BRANCH#] `
--env PROJECT=[#PROJECT#] `
--env JENKINS_ADMIN_PASSWORD=$((New-Guid).ToString()) `
--env PROJECT_REPOSITORY_URL=[#PROJECT_REPOSITORY_URL#] `
--env PROJECT_REPOSITORY_USERNAME=[#PROJECT_REPOSITORY_USERNAME#] `
--env PROJECT_REPOSITORY_PASSWORD=[#PROJECT_REPOSITORY_PASSWORD#] `
--env CONTIANER_REPOSITORY_URL=[#CONTIANER_REPOSITORY_URL#]
geeksltd/jenkins-windows