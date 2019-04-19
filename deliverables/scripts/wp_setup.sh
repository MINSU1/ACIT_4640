service network restart

usermod -a -G wheel admin

network --bootproto=dhcp

# nmtui
setenforce 0
sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config

yum install @core epel-release vim git tcpdump nmap-ncat curl
yum update

sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-service=tftp-client

sudo firewall-cmd --reload
sudo firewall-cmd --zone=$zone --list-all

yum install epel-release
yum install nginx
systemctl restart nginx
systemctl status nginx
curl localhost:80

yum install mariadb-server
systemctl start mariadb

systemctl status mariadb

systemctl enable mariadb

yum install php php-mysql php-fpm

sed -i '763 s/;//' /etc/php.ini
sed -i '763 s/0/1/' /etc/php.ini

sed -n 763p /etc/php.ini

sed -i '12 s|127.0.0.1:9000|/var/run/php-fpm/php-fpm.sock|' /etc/php-fpm.d/www.conf
sed -i '31 s/;//' /etc/php-fpm.d/www.conf
sed -i '32 s/;//' /etc/php-fpm.d/www.conf
sed -i '39 s/apache/nginx/' /etc/php-fpm.d/www.conf
sed -i '41 s/apache/nginx/' /etc/php-fpm.d/www.conf

systemctl start php-fpm
systemctl enable php-fpm

systemctl restart nginx
systemctl status nginx
systemctl enable nginx

wget https://wordpress.org/latest.tar.gz
tar -xzvf /home/latest.tar.gz

cp /home/wordpress/wp-config-sample.php /home/wordpress/wp-config.php

sed -i "23 s/database_name_here/wordpress/" /home/wordpress/wp-config.php
sed -i "26 s/username_here/wordpress_user/" /home/wordpress/wp-config.php
sed -i "29 s/password_here/P@ssw0rd/" /home/wordpress/wp-config.php

sudo rsync -avP /home/wordpress/ /usr/share/nginx/html/
sudo mkdir /usr/share/nginx/html/wp-content/uploads
sudo chown -R admin:nginx /usr/share/nginx/html/

yum -y install kernel-devel kernel-headers dkms gcc gcc-c++ kexec-tools
mkdir vbox_cd
mount /dev/cdrom ./vbox_cd
./vbox_cd/VBoxLinuxAdditions.run
umount ./vbox_cd
rmdir ./vbox_cd