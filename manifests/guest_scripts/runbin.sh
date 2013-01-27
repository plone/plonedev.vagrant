#!/bin/sh

if [ "X$1" != "X" ]; then
    CWD=`pwd`
    cd /home/vagrant/Plone/zinstance
    bin/$1 $2 $3 $4 $5 $6
    cd $CWD
else
    echo "Usage $0 instance|buildout"
fi