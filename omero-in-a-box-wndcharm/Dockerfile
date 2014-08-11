FROM omedocker/omero-in-a-box
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN apt-get install -y g++ git swig libtiff-dev libfftw3-dev \
    python-scipy python-matplotlib
RUN pip install git+https://github.com/wnd-charm/wnd-charm.git
RUN git clone https://github.com/ome/omero-wndcharm.git /opt/omero-wndcharm
RUN cd /opt/omero-wndcharm && python setup.py install

ADD ./omero-wndcharm.conf /etc/supervisor/conf.d/
ADD ./omero-wndcharm /omero-wndcharm

# Inherit EXPOSE and CMD
