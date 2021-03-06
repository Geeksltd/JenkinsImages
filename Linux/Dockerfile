FROM jenkins/jenkins:lts

USER root

# Install the required tools
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-get install -y --no-install-recommends apt-utils

# Automatically installing all plugins
COPY plugins.txt plugins.txt
RUN /usr/local/bin/install-plugins.sh < plugins.txt

# Install dotnet core SDK
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget -q https://packages.microsoft.com/config/debian/9/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2

# replace-in-file
RUN dotnet tool install -g replace-in-file

# Install kubectl
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Install Docker
RUN apt-get install -y software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN apt install -y docker-ce

# Install AWS CLI
RUN apt-get install -y python python-pip
RUN pip install awscli

# Install git
RUN apt install git

# Customise the jenkins instance
COPY JenkinsMetadata/init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy

# The following environmnet variables should be provided at runtime.
#DOCKER_HOST
#PROJECT_JENKINS_FILE_GIT_URL
#BRANCH 
#PROJECT
#JENKINS_ADMIN_PASSWORD
#PROJECT_REPOSITORY_URL
#PROJECT_REPOSITORY_USERNAME
#PROJECT_REPOSITORY_PASSWORD

EXPOSE 8080
EXPOSE 5000