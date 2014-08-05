FROM hadoop-1.2.1-pydoop
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum install -y gcc-c++ git swig libtiff-devel fftw-static fftw-devel \
	python-devel python-pip argparse numpy scipy python-matplotlib
RUN pip install git+https://github.com/wnd-charm/wnd-charm.git


EXPOSE 8020 9000 50010 50030 50070 50075 50470 51111
CMD ["/bin/bash", "-e", "/run.sh"]

