FROM hadoop-1.2.1
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum install -y \
	http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y java-1.7.0-openjdk-devel boost-python-devel openssl-devel \
	python-pip python-importlib python-devel \
	git gcc gcc-c++
RUN JAVA_HOME=/etc/alternatives/java_sdk HADOOP_CONF_DIR=/etc/hadoop \
	pip install git+https://github.com/manics/pydoop.git@compile_mac_10_9

EXPOSE 8020 9000 50010 50030 50070 50075 50470 51111
CMD ["/bin/bash", "-e", "/run.sh"]

