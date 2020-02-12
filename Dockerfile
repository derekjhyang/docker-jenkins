FROM jenkins/jenkins:lts
LABEL maintainer="Derek Yang <hswayne77@gmail.com>"

USER root

RUN apt-get update && \
apt-get install -y wget git curl zip graphviz sudo vim python-dev python-pip python3 python3-pip nfs-common snapd build-essential \
        libffi-dev \
        libssl-dev \
        software-properties-common \
        openjdk-9-jre \
        openssh-server

ENV JENKINS_HOME /var/jenkins_home

# Install docker
RUN wget -O - https://get.docker.com | sh
RUN usermod -aG docker jenkins
RUN echo 'DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"' >> /etc/default/docker

# Install kubectl
RUN apt-get update && sudo apt-get install -y apt-transport-https \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -SsL https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz | tar -xz
RUN mv linux-amd64/helm /usr/bin/helm && chmod 755 /usr/bin/helm

# Install the plugins using jenkins itself.
COPY plugins.txt /plugins.txt
RUN  install-plugins.sh $(cat /plugins.txt)

# Set jenkins proper permissions
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref
USER jenkins