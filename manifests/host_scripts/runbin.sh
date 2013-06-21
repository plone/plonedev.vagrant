#!/bin/sh

if [ "X$1" != "X" ]; then
    vagrant ssh -c "./runbin.sh $1 $2 $3 $4 $5 $6"
else
    echo
    echo "$0 runs a Plone instance buildout.coredev/bin command line"
    echo "in the virtual box."
    echo
    echo usage: "$0 instance|buildout|test|... arguments"
    echo
fi