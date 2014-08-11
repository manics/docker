FROM omedocker/hadoop-1.2.1
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum install -y \
	http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# Temporarily enable centosplus repo to Workaround a CentOS bug:
# https://bugs.centos.org/view.php?id=7126
# TODO: remove this repo when fixed
#RUN yum install -y \
RUN yum --enablerepo centosplus install -y \
	java-1.7.0-openjdk-devel boost-python-devel openssl-devel \
	python-pip python-importlib python-devel python-argparse \
	git gcc gcc-c++ patch
RUN JAVA_HOME=/etc/alternatives/java_sdk HADOOP_CONF_DIR=/etc/hadoop \
	pip install git+https://github.com/manics/pydoop.git@omero-fixes

#EXPOSE
#CMD

