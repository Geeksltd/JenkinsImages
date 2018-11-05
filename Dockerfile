FROM jenkins/jenkins:lts

#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#automatically installing all plugins
COPY plugins.txt plugins.txt
RUN /usr/local/bin/install-plugins.sh < plugins.txt

USER root
# Install Docker
RUN apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce

# Install kubectl
# Set the Kubernetes version as found in the UCP Dashboard or API
ENV k8sversion=v1.8.11

# Get the kubectl binary.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$k8sversion/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	sudo mv ./kubectl /usr/local/bin/kubectl

# Install git
RUN apt-get install --assume-yes git

# Install AWS Cli
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli

COPY ./JenkinsMetadata/config.xml .
ONBUILD ENV REF_FOLDER=/usr/share/jenkins/ref
ONBUILD ARG PROJECT_JENKINS_GIT_URL
ONBUILD ARG BRANCH
ONBUILD ARG PROJECT
ONBUILD USER jenkins
ONBUILD RUN mkdir -p $REF_FOLDER/jobs/$PROJECT/
ONBUILD RUN mv config.xml $REF_FOLDER/jobs/$PROJECT/
ONBUILD RUN sed -i "s#%GIT_URL%#$PROJECT_JENKINS_GIT_URL#g;s#%BRANCH%#$BRANCH#g;" $REF_FOLDER/jobs/$PROJECT/config.xml