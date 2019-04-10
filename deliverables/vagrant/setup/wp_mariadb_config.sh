sudo systemctl enable mariadb;
sudo systemctl start mariadb;

mysql -u root < /home/admin/mariadb_security_config.sql;
mysql -u root < /home/admin/wp_mariadb_config.sql;

sudo systemctl daemon-reload;
sudo systemctl start mariadb;
