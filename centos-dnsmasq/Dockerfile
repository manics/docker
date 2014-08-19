FROM centos
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum -y install dnsmasq
RUN echo NETWORKING=yes > /etc/sysconfig/network && \
	mkdir /etc/dnsmasq.hosts && \
	echo conf-dir=/etc/dnsmasq.d >> /etc/dnsmasq.conf

ADD docker.dnsmasq.conf /etc/dnsmasq.d/
ADD resolv.dnsmasq.conf /etc/
