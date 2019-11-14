FROM liveforensics/linuxstarter:1.0.0

RUN mkdir /home/jenkins/ansible

COPY inputs.conf /opt/splunkforwarder/etc/system/local/inputs.conf
COPY outputs.conf /opt/splunkforwarder/etc/system/local/outputs.conf

RUN yum -y install epel-release ansible