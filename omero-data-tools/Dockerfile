FROM openmicroscopy/omero-conda
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

ENV OMERO_VERSION 5.1
USER root

RUN apt-get update && apt-get -y install git
RUN /opt/anaconda/bin/conda install pandas && \
    /opt/anaconda/bin/pip install \
        https://github.com/ome/omego/archive/master.zip

USER omero

RUN /opt/anaconda/bin/omego download --release $OMERO_VERSION && \
    ln -s OMERO.py-* OMERO.py
RUN git clone https://github.com/manics/omero-features --branch metadata_features
RUN git clone https://github.com/manics/idr-data-munging
RUN echo 'export PYTHONPATH=$HOME/omero-features:$PYTHONPATH' >> .bashrc

