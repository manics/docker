GridFTP server
=============

This docker container runs a Globus GridFTP server in sshftp mode.
You should specify a `PASSWORD` for the `gridftp` account:

    docker run -v /data-dir:/home/gridftp -e PASSWORD=password gridftp

On the client connect to `gridftp@hostname`:

    # Check ssh is working with `PASSWORD`
    ssh gridftp@hostname
    globus-url-copy -list sshftp://gridftp@hostname/home/gridftp
    globus-url-copy -v -vb -fast -p 4 file:/path/to/file sshftp://gridftp@hostname/home/gridftp/
    # Slashes are important, destination dir must exist
    globus-url-copy -v -vb -fast -p 4 -r -sync file:/path/to/dir/ sshftp://gridftp@hostname/home/gridftp/dir/


Client mode
-----------

To use this as an interactive client it is safer to run as a non-root user:

    docker run -it -u gridftp -v /volume:/home/gridftp/data gridftp bash

