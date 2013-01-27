#!/bin/sh

vagrant ssh -c "./runbin.sh buildout -c develop.cfg $1 $2 $3 $4 $5 $6"
