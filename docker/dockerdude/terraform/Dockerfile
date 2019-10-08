FROM liveforensics/linuxstarter:1.0.0

RUN mkdir /home/jenkins/terraform

RUN yum -y install wget unzip && \
    wget https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_linux_amd64.zip 
    # unzip ./terraform_0.12.10_linux_amd64.zip –d /usr/local/bin