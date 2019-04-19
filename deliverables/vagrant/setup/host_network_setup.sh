#!/bin/bash

# NAT network variables
declare network_name="sys_net_prov"
declare networkadd=192.168.254.0
declare vmname = "acit_4640_pxe"

# Uncomment this line to delete the nat network
# vboxmanage natnetwork remove --netname ${network_name}

#Create the NAT NETWORK
Vboxmanage natnetwork add \
				--netname ${network_name} \
				--network ${networkadd} \
				--dhcp off
				
#Modify NAT Table

Vboxmanage natnetwork modify \
	--netname ${network_name} \
	--port-forward-4 "http_wp:tcp:[]:50080:[192.168.254.10]:80"
	

Vboxmanage natnetwork modify \
	--netname ${network_name} \
	--port-forward-4 "ssh_wp:tcp:[]:50022:[192.168.254.10]:22"

Vboxmanage natnetwork modify \
	--netname ${network_name} \
	--port-forward-4 "ssl_wp:tcp:[]:50443:[192.168.254.10]:443"

Vboxmanage natnetwork modify \
	--netname ${network_name} \
	--port-forward-4 "pxe_wp:tcp:[]:50222:[192.168.254.5]:22"

Vboxmanage list natnetworks

#Import OVA PXE Server

Vboxmanage import ../../acit_4640_pxe.ova 

Vboxmanage modifyvm ${vm_name}\
--nat-network1 "${network_name}"