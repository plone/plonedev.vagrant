#!/bin/sh

if [ ! -f .ssh/id_rsa ]; then
    cd .ssh
    # generate openssh-style key pair
    /usr/bin/ssh-keygen -q -t rsa -N "" -f id_rsa
    # append public key to authorized_keys
    cat id_rsa.pub >> authorized_keys
    # create a putty-compatible key file
    /usr/bin/puttygen id_rsa -O private -o id_rsa.ppk
    # copy putty keyfile into shared directory
    cp id_rsa.ppk /vagrant/insecure_putty_key.ppk
    cd ~
fi