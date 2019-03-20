declare network_name="sys_net_prov"

VBoxManage natnetwork add --netname ${network_name} --network '192.168.254.0/24' --dhcp off 

VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "http_wp:tcp:[]:50080:[192.168.254.10]:80"
VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "ssh_wp:tcp:[]:50022:[192.168.254.10]:22"
VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "ssl_wp:tcp:[]:50443:[192.168.254.10]:443"
VBoxManage natnetwork modify --netname ${network_name} --port-forward-4 "pxessh:tcp:[]:50222:[192.168.254.5]:22"

VBoxManage list natnetworks

# VBoxManage natnetwork remove --netname 'sys_net_prov'