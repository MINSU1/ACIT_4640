# login: student passwd: Password
# ip addr show
# cd /etc/sysconfig/network-scripts
# vi ifcfg-enp0s3
# 	ADDR=192.168.254.10
# 	NETMASK=255.255.255.0
# 	GATEWAY=192.168.254.1
# 	BOOTPROTO=none
# 	ONBOOT=yes
# cd /
service network restart

# sudo vi /etc/resolv.conf
# 	search ad.bcit.ca snp.acit

hostnamectl set-hostname wp.snp.acit

# adduser admin
# passwd admin
#     P@ssw0rd
usermod -a -G wheel admin

su admin
cd home/admin

mkdir .ssh/
cd .ssh/
vi authorized_keys
wget --user student --password w1nt3r2019 https://4640.acit.site/code/ssh_setup/acit_admin_id_rsa.pub
mv acit_admin_id_rsa.pub authorized_keys

setenforce 0
sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config


yum install @core epel-release vim git tcpdump nmap-ncat curl
yum update

sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
