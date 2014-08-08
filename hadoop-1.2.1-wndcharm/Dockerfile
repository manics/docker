FROM omedocker/hadoop-1.2.1-pydoop
MAINTAINER Simon Li "spli@dundee.ac.uk"

RUN yum install -y gcc-c++ git swig libtiff-devel fftw-static fftw-devel \
	python-devel python-pip argparse numpy scipy python-matplotlib
RUN pip install git+https://github.com/wnd-charm/wnd-charm.git

#EXPOSE
#CMD

