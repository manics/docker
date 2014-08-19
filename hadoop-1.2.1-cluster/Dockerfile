FROM omedocker/centos-dnsmasq
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum -y install java-1.7.0-openjdk \
	http://www.mirrorservice.org/sites/ftp.apache.org/hadoop/common/hadoop-1.2.1/hadoop-1.2.1-1.x86_64.rpm

RUN sed -i.bak 's/JAVA_HOME=.*/JAVA_HOME=\/etc\/alternatives\/jre/' \
	/etc/hadoop/hadoop-env.sh

# Fix rpm script permissions
RUN pushd /usr/sbin && \
	chmod +x \
		rcc slaves.sh start-all.sh start-balancer.sh start-dfs.sh \
		start-jobhistoryserver.sh start-mapred.sh \
		stop-all.sh stop-balancer.sh stop-dfs.sh stop-jobhistoryserver.sh \
		stop-mapred.sh && \
	popd

RUN yum install -y openssh-server openssh-clients

# http://stackoverflow.com/a/21618386
RUN sed -i.bak \
	's/session    required     pam_loginuid.so/session    optional     pam_loginuid.so/' \
	/etc/pam.d/sshd

ADD setup_ssh.sh /
RUN /setup_ssh.sh

ADD configure.sh /
ADD deploy-configure.sh /
ADD run.sh /
ADD tail_hadoop_logs.sh /

EXPOSE 8020 9000 50010 50030 50070 50075 50470 51111
ENTRYPOINT ["/bin/bash", "/run.sh"]
