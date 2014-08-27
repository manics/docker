FROM omero-build-from-scratch
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN pip install omego
RUN useradd omero
RUN mkdir /build && chown omero /build

USER omero

RUN cd /build && \
	git clone --recursive git://git.openmicroscopy.org/ome.git \
		openmicroscopy
#	omego download source --branch OMERO-5.0-latest

CMD ["/bin/bash", "-l"]
