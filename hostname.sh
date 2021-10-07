#!/bin/bash

servername=$1

sed -i 's/raspberrypi/'${servername}'/g' /etc/hosts
sed -i 's/raspberrypi/'${servername}'/g' /etc/hostname

sudo reboot