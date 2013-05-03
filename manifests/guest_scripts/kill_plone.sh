#!/bin/sh

echo "Killing all running Plone instances"
for instance in `ps x | grep Plone | grep -v grep | egrep -o "^ *[0-9]+"`
do
    echo Killing $instance
    kill $instance
done
