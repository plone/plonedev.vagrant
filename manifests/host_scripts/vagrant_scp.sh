#!/bin sh

# convenience wrapper for scp;
# supplies port and key;
# prevents storage of vbox key in ssh's known host file.

PORT=2222
PRIVATE_KEY= ~/.vagrant.d/insecure_private_key

scp -P $PORT -i $PRIVATE_KEY -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $1 $2 $3 $4 $5 $6