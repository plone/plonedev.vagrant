#!/bin/sh

AS_VAGRANT="sudo -u vagrant"
SHARED_DIR="/vagrant"

# RUBY_PLATFORM=$1
echo $1 | if grep -q mingw; then
    # Host environment is mingw, aka Windows.
    # Let's set up support for using Putty

    echo Host environment appears to be Windows.
    echo Setting up support for using Putty for ssh.

    if [ ! -f .ssh/id_rsa ]; then
        echo Creating an ssh key, authorizing it, and putting a
        echo Putty-compatible key file in shared directory.
        cd .ssh
        # generate openssh-style key pair
        /usr/bin/ssh-keygen -q -t rsa -N "" -f id_rsa
        # append public key to authorized_keys
        cat id_rsa.pub >> authorized_keys
        # create a putty-compatible key file
        /usr/bin/puttygen id_rsa -O private -o id_rsa.ppk
        # copy putty keyfile into shared directory
        cp id_rsa.ppk ${SHARED_DIR}/insecure_putty_key.ppk
        chmod 400 ${SHARED_DIR}/insecure_putty_key.ppk
        cd ~
    fi

    for script in ${SHARED_DIR}/manifests/windows_host_scripts/*
    do
        target=`basename $script`
        if [ ! -f ${SHARED_DIR}/$target ]; then
            echo Copying `basename $script` ...
            $AS_VAGRANT cp $script ${SHARED_DIR}
        fi
    done
else
    # Host environment is probably something *nix
    for script in ${SHARED_DIR}/manifests/host_scripts/*
    do
        target=`basename $script`
        if [ ! -f ${SHARED_DIR}/$target ]; then
            echo Copying `basename $script` ...
            $AS_VAGRANT cp $script ${SHARED_DIR}
            chmod 755 ${SHARED_DIR}/*.sh
        fi
    done
fi

