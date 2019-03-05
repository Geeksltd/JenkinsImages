FROM jenkins/jenkins:lts as plugins

#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#automatically installing all plugins
COPY plugins.txt plugins.txt
RUN /usr/local/bin/install-plugins.sh < plugins.txt

FROM microsoft/windowsservercore

# Install Chocolatey
ENV CHOCOLATEY_LIB "%ProgramData%\\chocolatey\\bin"
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && \
    setx PATH "%CHOCOLATEY_LIB%\\;%PATH%";

# .net core sdk
RUN choco install dotnetcore-sdk -y && \
    setx PATH "%ProgramData%\\dotnet\\;%PATH%;";

# replace-in-file
RUN dotnet tool install -g replace-in-file

# accelerate-package-restore
RUN dotnet tool install -g accelerate-package-restore

# Kubectl
RUN choco install -g kubernetes-cli -y && \
	setx PATH "%CHOCOLATEY_LIB%\\kubernetes-cli\\tools\\kubernetes\\client\\;%PATH%;";

# Docker
RUN choco install -g docker -y && \
	setx PATH "%CHOCOLATEY_LIB%\\docker\\tools\\;%PATH%;";

# AWS cli
RUN choco install -g awscli -y && \
	setx PATH "%PROGRAMFILES%\\Amazon\\AWSCLI\\;%PATH%;";

# JAVA
ENV JAVA_HOME c:\\Java\\jre1.8.0_91
RUN powershell -Command \
    wget 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185' -Outfile 'C:\jreinstaller.exe' ; \
    Start-Process -filepath C:\jreinstaller.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91" ; \
    del C:\jreinstaller.exe
RUN setx PATH "%PATH%;%JAVA_HOME%\bin"

# Jenkins
ENV JENKINS_VERSION 2.0
ENV JENKINS_HOME c:\\jenkins\\jenkins 
ENV jenkins.install.state INITIAL_SETUP_COMPLETED
ENV JAVA_OPTS="-Dpermissive-script-security.enabled=true" 

RUN mkdir %JENKINS_HOME%
RUN powershell -Command "wget -Uri http://mirrors.jenkins.io/war/latest/jenkins.war -UseBasicParsing -OutFile c:\\jenkins\jenkins.war"
COPY --from=plugins /usr/share/jenkins/ref/plugins/ $JENKINS_HOME\\plugins
COPY JenkinsMetadata\\config.xml .jenkins\\config.xml
COPY JenkinsMetadata\\init.groovy $JENKINS_HOME\\init.groovy

# git
RUN choco install -g git -y && \
	setx PATH "%PROGRAMFILES%\\git\\bin\\;%PATH%;";

# Install AWSPowerShell
RUN powershell -Command "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force"
RUN powershell -Command "Install-Module -Name AWSPowerShell -Force"

# Install AWS.ECS.Tools
RUN dotnet tool install -g Amazon.ECS.Tools --version 3.0.0

# Copy powershell scripts
ENV POWERSHELL_HOME C:\\Windows\\System32\\WindowsPowerShell\\v1.0
COPY Powershell $POWERSHELL_HOME

#Install SqlServer cmd
RUN powershell -Command "Install-Module -Name SqlServer -Force"

# The following environmnet variables should be provided at runtime.
#DOCKER_HOST
#PROJECT_JENKINSFILE_GIT_URL
#PROJECT_JENKINSFILE_NAME
#BRANCH 
#PROJECT
#JENKINS_ADMIN_PASSWORD
#PROJECT_REPOSITORY_URL
#PROJECT_REPOSITORY_USERNAME
#PROJECT_REPOSITORY_PASSWORD
#PROJECT_TASK_FAMILY_NAME
#PROJECT_ECS_SERVICE_NAME
#ECS_CLUSTER_NAME
#TASK_ROLE_NAME
#DEPLOYMENT_TAG_PREFIX

EXPOSE 8080
EXPOSE 5000
CMD java -jar c:\\jenkins\\jenkins.war
