---
- hosts: wp
  tasks:
   - name: Repository stuff
     yum: state=present name={{ item }}
     with_items:
     - php
     - php-fpm
     - php-mysql
     - nginx
     - mariadb-server
     - mariadb
     - mysql
     - rsync
     become: true
   - name: https firewall 
     firewalld:
       service: https
       immediate: yes
       permanent: true
       state: enabled
     become: true
   - name: http firewall 
     firewalld:
       service: http
       immediate: yes
       permanent: true
       state: enabled
     become: true

   - name: files getting moved
     copy: src=wp_setup_files/{{ item.0 }} dest={{ item.1 }} owner={{ ansible_user_id }} group={{ ansible_user_id }}
     with_together:
       - ['nginx.conf', 'www.conf', 'mariadb_security_config.sql', 'wp_mariadb_config.sql']
       - ['/etc/nginx/nginx.conf','/etc/php-fpm.d/www.conf','/home/admin/mariadb_security_config.sql','/home/admin/wp_mariadb_config.sql']
     become: true

   - name: Configuring mariadb stuff
     service:
       name: mariadb.service
       state: restarted
     become: true

   - name: tryna get into mysql
     shell: mysql -u root < /home/admin/mariadb_security_config.sql
     become: true

   - name: Configuring more mariadb
     service:
       name: mariadb
       state: restarted
     become: true

   - name: mariadb config stuff
     shell: mysql -u root -pP@ssw0rd < /home/admin/wp_mariadb_config.sql
     become: true

   - name: Configuring nginx
     service:
       name: nginx
       state: restarted
     become: true

   - name: php-fpm getting configured
     service:
       name: php-fpm
       state: restarted
     become: true

   - name: more mariadb config
     service:
       name: mariadb
       state: restarted
     become: true

   - name: extracting wordpress
     unarchive:
       src: http://wordpress.org/latest.tar.gz
       dest: /home/admin
       remote_src: yes
     become: true

   - name: Change me to anything
     copy: src=wp_setup_files/wp-config.php dest=/home/admin/wordpress/wp-config.php owner={{ ansible_user_id }} group={{ ansible_user_id }}
     become: true

   - name: rsyncing stuff
     command: rsync -avP /home/admin/wordpress/ /usr/share/nginx/html/
     become: true

   - name: making directory
     command: mkdir -p /usr/share/nginx/html/wp-content/uploads
     become: true

   - name: Changing ownership
     command: chown -R admin:nginx /usr/share/nginx/html
     become: true

   - name: nginx configuring
     service:
       name: nginx
       state: restarted
     become: true