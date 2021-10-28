GUIDE/WALKTHROUGH

What do you need?
TIMESTAMP: 2:38

REQUIRED
-Raspberry Pi: https://geni.us/aBeqAL

CRAZY CLUSTER: 
4 Pi Cluster: https://geni.us/pbB8

8 Pi Cluster: https://geni.us/v0Jt5

Network Switch: https://geni.us/rLQE

USB Power Hub: https://geni.us/TfeK



STEP 1 - Raspberry Pi Headless Setup
TIMESTAMP: 11:53

Image the SD card using the Raspberry Pi Imager.
Raspberry Pi Imager: https://www.raspberrypi.org/software/
Install "Raspberry Pi OS Lite"
Insert the SD card into the Raspberry Pi and allow it to boot (3-4 minutes)
Remove the SD card and plug it back into your computer
Open the SD card location and open the file "cmdline.txt"
Add the following to the end of the line of text:
cgroup_memory=1 cgroup_enable=memory
ip=192.168.1.43::192.168.1.1:255.255.255.0:rpiname:eth0:off
Use this for reference(ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>)
Open the file "config.txt"
Add this line of config to the end of the file:
add arm_64bit=1
Enable SSH
Windows
Open powershell and change directories to the SD card (ex. I:)
type this command and hit enter: 
new-item ssh
Put the SD card back in your raspberry pi and boot. (make sure you plug in your ethernet cable!)


STEP 2 - K3s Prep
TIMESTAMP: 19:07

SSH into your raspberry pi
Configure legacy IP tables
sudo iptables -F sudo update-alternatives --set iptables /usr/sbin/iptables-legacy sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy sudo reboot
Reboot


STEP 3 - K3s Install
TIMESTAMP: 20:43

Become root
sudo su -
Install K3s (master setup)
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -
Get the node token from the master
sudo cat /var/lib/rancher/k3s/server/node-token


STEP 4 - K3s Install (node setup)
TIMESTAMP: 23:12

Run this command on your other Raspberry Pi nodes
curl -sfL https://get.k3s.io | K3S_TOKEN="YOURTOKEN" K3S_URL="https://[your server]:6443" K3S_NODE_NAME="servername" sh -


STEP 5 - Rancher Install (optional)
TIMESTAMP: 26:32

*Requires a separate Ubuntu 18.04 VM



Create a config file
Make a few directories
mkdir /etc/rancher
mkdir /etc/rancher/rke2
Create the config file
nano config.yaml

Save the file
Install Rancher
curl -sfL https://get.rancher.io | sh - 
Verify installation:
rancherd --help
Enable the Rancher service
systemctl enable rancherd-server.service
systemctl start rancherd-server.service
journalctl -eu rancherd-server -f
Reset the admin password
rancherd reset-admin
Log into the Web UI and import the cluster
Edit the cluster API file 

rancher/rancher-agent:v2.5.8-linux-arm64


STEP 6 - Deploy your 1st APP in k3s!!
TIMESTAMP: 33:51

Create a new file on the master: harrypotter.yaml (check downloads)
Deploy the app
kubectl apply -f harrypotter.yaml
kubectl get pods
STEP 7 - Expose your App with Node Port
Create a new file on the master: harrypotter_nodeport.yaml (check downloads)
kubectl apply -f harrypotter_nodeport.yaml
kubectl get services
