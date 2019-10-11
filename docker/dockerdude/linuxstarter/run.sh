#!/bin/bash

echo "Starting Splunk"
/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
echo "Starting SSH"
/usr/sbin/sshd -D
echo "Done"