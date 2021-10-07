# Kubernetes Rancher Raspberry Pi Cluster

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Original Project](#original-project)
- [Notes](#notes)
  - [**Step 1:** Raspberry Pi Headless Setup](#step-1-raspberry-pi-headless-setup)
  - [**Step 2:** K3s Prep](#step-2-k3s-prep)
  - [**Step 3:** K3s Master Install](#step-3-k3s-master-install)
  - [**Step 4:** K3s Worker Install](#step-4-k3s-worker-install)
  - [**Step 5:** Rancher Install (Optional)](#step-5-rancher-install-optional)
- [Additional Scripts](#additional-scripts)
  - [Hostname Shell Script](#hostname-shell-script)
  - [IPTables Shell Script](#iptables-shell-script)
  - [K3S Worker Node Shell Script](#k3s-worker-node-shell-script)
- [Additional References/Sources](#additional-referencessources)
  - [Twitch Live Stream of Setup](#twitch-live-stream-of-setup)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Original Project

This project was inspired by [Network Chuck](https://www.networkchuck.com/), specifically his [video](https://youtu.be/X9fSMGkjtug) where he created a kubernetes cluster with raspberry Pis.

Thank you **Network Chuck** for making an awesome video and going through all the steps to get it working and really showing the power of kubernetes and raspberry pis.

I reproduced the project during "Hack Week" at my company.  I put some scripts together for some of the "manual" steps Chuck has you do in his guide.  I'm hoping to expand on this project by adding some more automation with ansible playbooks for the next hack week. I'm also hoping to get 6 more raspberry pi 4 model Bs to put in this tower. >.<
## Notes

I reference some of the scripts I created in these notes. Keep in mind that some of these scripts require that you understand how they work and that you need to pass some arguments to them in order for them to automate some of the typing or copy pasting.

**IMPORTANT** : `Change the default password when you first login to each raspberry pi please`.  

- Use a [password manager](https://lastpass.wo8g.net/rx3GG) if you need to remember them. :)

### **Step 1:** Raspberry Pi Headless Setup

In this step, he has you image your SD card, plug it in and let it boot, then unplug it, edit some of the configuration files and then plug it back in.  I found that this back and forth is unnecessary.

As soon as you finish imaging the SD card, you can open the files that need edited and it will be ready to go into the raspberry pi after that.  

With that being said, part of the `ip` parameter that he has you pass multiple params including your gateway ip and hostname doesn't quite seem to work as intended.  It _does_ pick up the IP address you set for the device, but that seems to be about it.  It doesn't update the hostname at all which is why I created the [#hostname.sh](#hostname-shell-script) file to help automate that process a little bit.  It does require that you pass the desired hostname(so make sure you stay organized with your addressing schema to help remember which node you're on) to the execution of this script.

### **Step 2:** K3s Prep

I added a script [iptables.sh](#iptables-shell-script) to make that a little bit easier

### **Step 3:** K3s Master Install

Not much to update here, I could put in a script here just to pull out the node token after K3s master finishes setting up, but honestly it's not that much of an extra step to run a cat on the system to get the node token.

### **Step 4:** K3s Worker Install

I added a [#k3s-worker-setup.sh](#k3s-worker-node-shell-script) file to automate the process of setting up the worker node. You'll need the node-token from step 3 and the ip or hostname of your master node from step 1.

### **Step 5:** Rancher Install (Optional)

This step doesn't work, as far as I can tell, at least in it's current form.  I ended up just following the steps on the rancher website to install the docker version of rancher (2.6.0 as of this writing) and I was able to mostly reproduce everything, but ignored all the rancherd stuff.

For the API edit of the `agentImageOverride`, I just made sure that the rancher agent was using the version I was using near the end of the string. In my case it was `rancher/rancher-agent:v2.6.0-linux-arm64`

Also to reach the API backend in the browser, it was a little different where I had to pull the "UUID" out of the original url and then using it to hit the API.

For example, a URL from my test was `https://rancher-server-ip/dashboard/c/c-m-7l4xnn8v/manager/provisioning.cattle.io.cluster`  I pulled out the part after "c" which would be `c-m-7l4xnn8v`.

I took that and then went to the API backend by directing my browser to `https://rancher-server-ip/v3/clusters/c-m-7l4xnn8v`.  You can see the UUID I pulled from the previous URL is now appended after /clusters/ in this URL.

## Additional Scripts

### Hostname Shell Script

---

[hostname.sh](./hostname.sh)

**Purpose:** Configures Hostname and Network Hostname of the device

**Arguments Required:**
  - hostname

**Example Execution:** `sudo ./changehostname.sh hostname`

**Reboot Required:** Yes
### IPTables Shell Script

---

[iptables.sh](./iptables.sh)

**Purpose:** Configures Legacy IP tables for K3S to use

**Arguments Required:** 
  - None

**Example Execution:** `./iptables.sh`

**Reboot Required:** Yes

### K3S Worker Node Shell Script

---

[k3s-worker-setup.sh](./k3s-worker-setup.sh)

**Purpose:** Configures worker node into your K3S cluster

**Arguments Required:**
  - master-server-name `OR` master-node-ip
  - master-server-node-token (get from master node: `sudo cat /var/lib/rancher/k3s/server/node-token`)

**Example Execution:** `./k3s-worker-setup.sh master-server-name master-server-node-token`

**Reboot Required:** No

## Additional References/Sources

- [RPi cmdline.txt Documentation](https://elinux.org/RPi_cmdline.txt#:~:text=%EE%80%80RPi%20cmdline.txt%EE%80%81.%20This%20file%20is%20for%20passing%20arguments,the%20default%20mac%20adress%20with%20the%20specified%20one.)
- [Raspberry Pi Config Documentation](https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi)
- [Docker Installation](https://docs.docker.com/engine/install/)
- [Rancher Quick Start](https://rancher.com/quick-start/)
- [Building Raspberry Pi Cluster](https://magpi.raspberrypi.org/articles/build-a-raspberry-pi-cluster-computer)

### Twitch Live Stream of Setup

- [Physical Build](https://www.twitch.tv/videos/1168228107)
- [Config and Play](https://www.twitch.tv/videos/1169538073)