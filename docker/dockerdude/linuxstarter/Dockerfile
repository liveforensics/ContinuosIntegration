FROM centos:7.5.1804

# ADD epel.repo /etc/yum.repos.d/epel.repo
# Define env variables only once and don't define it any more
ENV SPLUNK_HOME /splunkforwarder
ENV SPLUNK_ROLE splunk_heavy_forwarder
ENV SPLUNK_PASSWORD changeme
ENV SPLUNK_START_ARGS --accept-license


RUN yum -y update
RUN yum install -y epel-release \
    && yum install -y wget expect jq
RUN yum -y install openssh-server initscripts 
RUN /usr/sbin/sshd-keygen
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

# install java
RUN yum -y install java-11-openjdk git nano tree net-tools python2

# Download, unpack, remove
RUN wget -O splunkforwarder-7.2.4-8a94541dcfac-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.2.4&product=universalforwarder&filename=splunkforwarder-7.2.4-8a94541dcfac-Linux-x86_64.tgz&wget=true' \
    && tar -xvf splunkforwarder-7.2.4-8a94541dcfac-Linux-x86_64.tgz \
    && rm -f splunkforwarder-7.2.4-8a94541dcfac-Linux-x86_64.tgz

# Everything is simple with shell scripts, but inputs.conf, splunkclouduf.spl and first_start.sh should have an explanation. I'll tell more about it below.
COPY [ "inputs.conf", "docker-stats/props.conf", "/splunkforwarder/etc/system/local/" ]
COPY [ "docker-stats/docker_events.sh", "docker-stats/docker_inspect.sh", "docker-stats/docker_stats.sh", "docker-stats/docker_top.sh", "/splunkforwarder/bin/scripts/" ]
COPY splunkclouduf.spl /splunkclouduf.spl
COPY first_start.sh /splunkforwarder/bin/

#  Grant execute permissions, add user, execute pre-configuration
RUN chmod +x /splunkforwarder/bin/scripts/*.sh \
    && groupadd -r splunk \
    && useradd -r -m -g splunk splunk \
    && echo "%sudo ALL=NOPASSWD:ALL" >> /etc/sudoers \
    && chown -R splunk:splunk $SPLUNK_HOME \
    && /splunkforwarder/bin/first_start.sh \
    && /splunkforwarder/bin/splunk install app /splunkclouduf.spl -auth admin:changeme \
    && /splunkforwarder/bin/splunk restart

# Copy init scripts
COPY [ "init/entrypoint.sh", "init/checkstate.sh", "/sbin/" ]

# It depends. If you need it locally - go on.
VOLUME [ "/splunkforwarder/etc", "/splunkforwarder/var" ]

# Add user jenkins to the image
RUN adduser jenkins && \
# Set password for the jenkins user (you may want to alter this).
echo "jenkins:jenkins" | chpasswd && \
mkdir /home/jenkins/.m2 

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