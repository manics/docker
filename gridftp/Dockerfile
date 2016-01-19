# GridFTP container SETUP for sshftp://
# Based on https://github.com/esnet/docker/tree/master/dtn-anonymous-gridftp
FROM centos:centos6
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN yum install -y http://www.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo-latest.noarch.rpm
RUN yum install -y globus-data-management-client globus-data-management-server globus-xio-udt-driver
RUN yum install -y openssh-server openssh-clients && \
    /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
    /usr/bin/ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''

RUN globus-gridftp-server-enable-sshftp

RUN adduser gridftp

ADD run.sh /

# The following ports are used:
# GridFTP:2811, 50000-51000  
# ranges not supported, so need to use docker run -P to expose all ports

VOLUME /home/gridftp
CMD /run.sh
