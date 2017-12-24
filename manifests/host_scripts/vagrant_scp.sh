#!/bin/sh

# convenience wrapper for scp;
# supplies port and key;
# prevents storage of vbox key in ssh's known host file.
#
# e.g.,
# ./vagrant_scp README.rst ubuntu@localhost:.
# copies the readme from the host to the guest.

PORT=2222
PRIVATE_KEY=`vagrant ssh-config | grep IdentityFile | sed 's; *IdentityFile "\(.*\)";\1;'`

scp -P $PORT -i $PRIVATE_KEY -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" $@
