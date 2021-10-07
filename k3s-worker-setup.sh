#!/bin/bash

K3S_MASTER=$1
K3S_TOKEN=$2

curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN K3S_URL="https://"$K3S_MASTER":6443" K3S_NODE_NAME=$HOSTNAME sh -