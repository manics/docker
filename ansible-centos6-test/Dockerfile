FROM centos:centos6
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN yum install -y openssh-server sudo
RUN ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
	ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N '' && \
	sed -i -re s'/(session\s+)required(\s+pam_loginuid.so)/\1optional\2/' \
		/etc/pam.d/sshd

RUN useradd ansible && \
	echo "ansible ALL=NOPASSWD: ALL" > /etc/sudoers.d/ansible

USER ansible
RUN mkdir /home/ansible/.ssh && chmod 700 /home/ansible/.ssh
ADD ansible_test_id_rsa.pub /home/ansible/.ssh/authorized_keys

USER root
EXPOSE 22
CMD /usr/sbin/sshd -De
