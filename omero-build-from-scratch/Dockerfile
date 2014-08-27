FROM centos:centos6
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN yum install -y \
	http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
	curl -o /etc/yum.repos.d/zeroc-ice-el6.repo \
		http://download.zeroc.com/Ice/3.5/el6/zeroc-ice-el6.repo
RUN yum install -y wget unzip zip tar git \
	java-1.7.0-openjdk-devel \
	python-genshi python-setuptools python-pip epydoc \
	ice-python ice-servers ice-python-devel ice-java-devel ice-c++-devel \
	font-config
RUN pip install sphinx

ADD texlive.profile /
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
	tar -zxvf install-tl-unx.tar.gz && \
	cd install-tl-*/ && \
	./install-tl -profile /texlive.profile && \
	ln -s /opt/texlive/2014/texmf-var/fonts/conf/texlive-fontconfig.conf \
		/etc/fonts/conf.d/09-texlive.conf && \
	fc-cache -rsfv
RUN echo 'PATH=/opt/texlive/2014/bin/x86_64-linux:$PATH' > \
	/etc/profile.d/texlive.sh

