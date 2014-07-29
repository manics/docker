FROM centos
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum -y install java-1.7.0-openjdk \
	http://www.mirrorservice.org/sites/ftp.apache.org/hadoop/common/hadoop-1.2.1/hadoop-1.2.1-1.x86_64.rpm

RUN sed -i.bak 's/JAVA_HOME=.*/JAVA_HOME=\/etc\/alternatives\/jre/' \
	/etc/hadoop/hadoop-env.sh

# The setup script doesn't fully configure everything
# RUN hadoop-setup-single-node.sh --default
RUN echo -e 'y\ny\ny\nn\nn\ny' | hadoop-setup-single-node.sh

RUN sed -i.bak -re 's/localhost:([0-9]+)/0.0.0.0:\1/' \
	/etc/hadoop/hdfs-site.xml
RUN sed -i.bak -re 's/localhost:([0-9]+)/0.0.0.0:\1/' \
	/etc/hadoop/mapred-site.xml

RUN useradd omero && echo omero:omero | chpasswd

RUN /etc/init.d/hadoop-namenode start && \
	/etc/init.d/hadoop-datanode start && \
	su hdfs -c 'hadoop fs -mkdir /mapred' && \
	su hdfs -c 'hadoop fs -chown mapred /mapred' && \
	/etc/init.d/hadoop-jobtracker start && \
	/etc/init.d/hadoop-tasktracker start && \
	hadoop-create-user.sh -u omero

#RUN /etc/init.d/hadoop-jobtracker stop && \
#	/etc/init.d/hadoop-tasktracker stop && \
#	/etc/init.d/hadoop-namenode stop && \
#	/etc/init.d/hadoop-datanode stop

ADD run.sh /

EXPOSE 8020 9000 50010 50030 50070 50075 50470 51111
CMD ["/bin/bash", "-e", "/run.sh"]

