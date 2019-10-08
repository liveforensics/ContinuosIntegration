FROM centos:7.5.1804

# ADD epel.repo /etc/yum.repos.d/epel.repo

RUN yum -y update

RUN yum -y install openssh-server initscripts 
RUN /usr/sbin/sshd-keygen
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

# install java
RUN yum -y install java-11-openjdk git nano tree net-tools python2

# RUN yum -y install git nano tree net-tools

# Add user jenkins to the image
RUN adduser jenkins && \
# Set password for the jenkins user (you may want to alter this).
echo "jenkins:jenkins" | chpasswd && \
mkdir /home/jenkins/.m2 && \
mkdir /home/jenkins/jenkinsroot

# ADD settings.xml /home/jenkins/.m2/
COPY authorized_keys /root/.ssh/authorized_keys
COPY authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/ && \
    chmod -R go= /home/jenkins/.ssh

# Standard SSH port
EXPOSE 22

# set the root password
RUN echo "root:test" | chpasswd

# set command to run
CMD ["/usr/sbin/sshd", "-D"]