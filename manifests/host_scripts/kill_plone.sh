#!/bin/sh

echo "Killing running Plone scripts and instances in virtual box"
vagrant ssh -c "./kill_plone.sh"
