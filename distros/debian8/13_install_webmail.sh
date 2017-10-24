#---------------------------------------------------------------------
# Function: InstallWebmail
#    Install the chosen webmail client. Squirrelmail or Roundcube
#---------------------------------------------------------------------
InstallWebmail() {
	START_TIME=$SECONDS

  	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing WebMail Client${NC}\n"	

  	case $CFG_WEBMAIL in
		"roundcube")
			
			echo -n -e "$IDENTATION_LVL_1 Installing ${red} RoundCube ${NC} WebMail Client...\n" 

			echo -n -e "$IDENTATION_LVL_2 Configure Roundcube ... "
			CFG_ROUNDCUBE_PWD=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c16)

			echo "roundcube-core roundcube/dbconfig-install boolean true" | debconf-set-selections
			echo "roundcube-core roundcube/database-type select mysql" | debconf-set-selections
			echo "roundcube-core roundcube/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "roundcube-core roundcube/db/dbname string roundcube" | debconf-set-selections
			echo "roundcube-core roundcube/mysql/app-pass password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
			echo "roundcube-core roundcube/app-password-confirm password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
			echo "roundcube-core roundcube/hosts string localhost" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "

			#backports=$(cat /etc/apt/sources.list | grep jessie-backports | grep -v "#")

			# if [ -z "$backports" ]; then
			# 	echo -e "\n# jessie-backports, previously on backports.debian.org" >> /etc/apt/sources.list
			# 	echo "deb http://http.debian.net/debian/ jessie-backports main contrib non-free" >> /etc/apt/sources.list
			# 	echo "deb-src http://http.debian.net/debian/ jessie-backports main contrib non-free" >> /etc/apt/sources.list
			# fi
			echo -n -e "$IDENTATION_LVL_2 Installing Roundcube ... "
		  	package_update
		  	# apt-get -yqq -t jessie-backports install roundcube roundcube-mysql roundcube-plugins >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		  	package_install -t stretch roundcube roundcube-mysql roundcube-plugins

		  	echo -e " [ ${green}DONE${NC} ] "

		  	echo -n -e "$IDENTATION_LVL_2 Configure RoundCube on WebServer ... " 
		  	if [ $CFG_WEBSERVER == "apache" ]; then
				mv /etc/roundcube/apache.conf /etc/roundcube/apache.conf.default
				cat << "EOF" > /etc/roundcube/apache.conf
<VirtualHost *:80>
	# Those aliases do not work properly with several hosts on your apache server
	# Uncomment them to use it or adapt them to your configuration
	#    Alias /roundcube /var/lib/roundcube
	Alias /webmail /var/lib/roundcube

	<Directory /var/lib/roundcube/>
	  Options +FollowSymLinks
	  # This is needed to parse /var/lib/roundcube/.htaccess. See its
	  # content before setting AllowOverride to None.
	  AllowOverride All
	  <IfVersion >= 2.3>
		Require all granted
	  </IfVersion>
	  <IfVersion < 2.3>
		Order allow,deny
		Allow from all
	  </IfVersion>
	</Directory>

	# Protecting basic directories:
	<Directory /var/lib/roundcube/config>
			Options -FollowSymLinks
			AllowOverride None
	</Directory>

	<Directory /var/lib/roundcube/temp>
			Options -FollowSymLinks
			AllowOverride None
			<IfVersion >= 2.3>
			  Require all denied
			</IfVersion>
			<IfVersion < 2.3>
			  Order allow,deny
			  Deny from all
			</IfVersion>
	</Directory>

	<Directory /var/lib/roundcube/logs>
			Options -FollowSymLinks
			AllowOverride None
			<IfVersion >= 2.3>
			  Require all denied
			</IfVersion>
			<IfVersion < 2.3>
			  Order allow,deny
			  Deny from all
			</IfVersion>
	</Directory>
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
	# Those aliases do not work properly with several hosts on your apache server
	# Uncomment them to use it or adapt them to your configuration
	#    Alias /roundcube /var/lib/roundcube
	Alias /webmail /var/lib/roundcube

	<Directory /var/lib/roundcube/>
	  Options +FollowSymLinks
	  # This is needed to parse /var/lib/roundcube/.htaccess. See its
	  # content before setting AllowOverride to None.
	  AllowOverride All
	  <IfVersion >= 2.3>
		Require all granted
	  </IfVersion>
	  <IfVersion < 2.3>
		Order allow,deny
		Allow from all
	  </IfVersion>
	</Directory>

	# Protecting basic directories:
	<Directory /var/lib/roundcube/config>
			Options -FollowSymLinks
			AllowOverride None
	</Directory>

	<Directory /var/lib/roundcube/temp>
			Options -FollowSymLinks
			AllowOverride None
			<IfVersion >= 2.3>
			  Require all denied
			</IfVersion>
			<IfVersion < 2.3>
			  Order allow,deny
			  Deny from all
			</IfVersion>
	</Directory>

	<Directory /var/lib/roundcube/logs>
			Options -FollowSymLinks
			AllowOverride None
			<IfVersion >= 2.3>
			  Require all denied
			</IfVersion>
			<IfVersion < 2.3>
			  Order allow,deny
			  Deny from all
			</IfVersion>
	</Directory>

	# SSL Configuration
	SSLEngine On
	SSLProtocol All -SSLv2 -SSLv3
	SSLCertificateFile /usr/local/ispconfig/interface/ssl/ispserver.crt
	SSLCertificateKeyFile /usr/local/ispconfig/interface/ssl/ispserver.key
	#SSLCACertificateFile /usr/local/ispconfig/interface/ssl/ispserver.bundle
</VirtualHost>
</IfModule>
EOF
		  	else
	        cat << "EOF" > /etc/nginx/sites-available/roundcube.vhost
server {
   # SSL configuration
   listen 443 ssl http2;

   ssl on;
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
   ssl_certificate /usr/local/ispconfig/interface/ssl/ispserver.crt;
   ssl_certificate_key /usr/local/ispconfig/interface/ssl/ispserver.key;

   location /roundcube {
      root /var/lib/;
      index index.php index.html index.htm;
      location ~ ^/roundcube/(.+\.php)$ {
        try_files $uri =404;
        root /var/lib/;
        include /etc/nginx/fastcgi_params;
        # To access SquirrelMail, the default user (like www-data on Debian/Ubuntu) must be used
        #fastcgi_pass 127.0.0.1:9000;
        fastcgi_pass unix:/var/lib/php/roundcube-webmail.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 256 4k;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;
      }
      location ~* ^/roundcube/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        root /var/lib/;
      }
      location ~* /.svn/ {
        deny all;
      }
      location ~* /README|INSTALL|LICENSE|SQL|bin|CHANGELOG$ {
        deny all;
      }
   }
   location /webmail {
     rewrite ^/* /roundcube last;
   }
}
EOF
				ln -s /etc/nginx/sites-available/roundcube.vhost /etc/nginx/sites-enabled/roundcube.vhost
	  		fi

	  		echo -e " [ ${green}DONE${NC} ] "

	  		echo -n -e "$IDENTATION_LVL_2 Integrate RoundCube with ISPConfig... " 
			# ISPConfig integration
			cd /tmp
			wget -q --no-check-certificate -O ispconfig3_roundcube.tgz https://github.com/w2c/ispconfig3_roundcube/tarball/master
			tar xzf ispconfig3_roundcube.tgz
			cp -r /tmp/*ispconfig3_roundcube*/ispconfig3_* /usr/share/roundcube/plugins/

			ln -s /usr/share/roundcube/plugins/ispconfig3_account /var/lib/roundcube/plugins/ispconfig3_account
			ln -s /usr/share/roundcube/plugins/ispconfig3_autoreply /var/lib/roundcube/plugins/ispconfig3_autoreply
			ln -s /usr/share/roundcube/plugins/ispconfig3_autoselect /var/lib/roundcube/plugins/ispconfig3_autoselect
			ln -s /usr/share/roundcube/plugins/ispconfig3_fetchmail /var/lib/roundcube/plugins/ispconfig3_fetchmail
			ln -s /usr/share/roundcube/plugins/ispconfig3_filter /var/lib/roundcube/plugins/ispconfig3_filter
			ln -s /usr/share/roundcube/plugins/ispconfig3_forward /var/lib/roundcube/plugins/ispconfig3_forward
			ln -s /usr/share/roundcube/plugins/ispconfig3_pass /var/lib/roundcube/plugins/ispconfig3_pass
			ln -s /usr/share/roundcube/plugins/ispconfig3_spam /var/lib/roundcube/plugins/ispconfig3_spam
			ln -s /usr/share/roundcube/plugins/ispconfig3_wblist /var/lib/roundcube/plugins/ispconfig3_wblist

			sed -i "/'zipdownload',/a 'jqueryui',\n'ispconfig3_account',\n'ispconfig3_autoreply',\n'ispconfig3_pass',\n'ispconfig3_spam',\n'ispconfig3_fetchmail',\n'ispconfig3_filter',\n'ispconfig3_forward'," /etc/roundcube/config.inc.php
			mv /usr/share/roundcube/plugins/ispconfig3_account/config/config.inc.php.dist /usr/share/roundcube/plugins/ispconfig3_account/config/config.inc.php

			sed -i "s/\$rcmail_config\['remote_soap_pass'\] = '.*';/\$rcmail_config\['remote_soap_pass'\] = '$CFG_ROUNDCUBE_PWD';/" /usr/share/roundcube/plugins/ispconfig3_account/config/config.inc.php
			sed -i "s/\$rcmail_config\['soap_url'\] = '.*';/\$rcmail_config['soap_url'] = 'https\:\/\/$CFG_HOSTNAME_FQDN\:$CFG_ISPONCFIG_PORT\/remote\/';/" /usr/share/roundcube/plugins/ispconfig3_account/config/config.inc.php

			mv /usr/share/roundcube/plugins/ispconfig3_pass/config/config.inc.php.dist /usr/share/roundcube/plugins/ispconfig3_pass/config/config.inc.php

			sed -i "s/\$rcmail_config\['password_min_length'\] = 6;/\$rcmail_config\['password_min_length'\] = 8;/" /usr/share/roundcube/plugins/ispconfig3_pass/config/config.inc.php
			sed -i "s/\$rcmail_config\['password_check_symbol'\] = TRUE;/\$rcmail_config\['password_check_symbol'\] = FALSE;/" /usr/share/roundcube/plugins/ispconfig3_pass/config/config.inc.php
			echo -e " [ ${green}DONE${NC} ] "
	    ;;
		"squirrelmail")
			echo -n -e "$IDENTATION_LVL_1 Installing ${red} SquirrelMail ${NC} WebMail Client ... " 

			echo -n -e "$IDENTATION_LVL_2 Installing SquirrelMail ... " 
			echo "dictionaries-common dictionaries-common/default-wordlist select american (American English)" | debconf-set-selections
	    	package_install squirrelmail wamerican >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		  	if [ $CFG_WEBSERVER == "apache" ]; then
		    	ln -s /etc/squirrelmail/apache.conf /etc/apache2/conf-available/squirrelmail.conf
		    	a2enconf squirrelmail
		    	sed -i 1d /etc/squirrelmail/apache.conf
		   		sed -i '1iAlias /webmail /usr/share/squirrelmail' /etc/squirrelmail/apache.conf
		   	fi
		   	echo -e " [ ${green}DONE${NC} ] "

		   	echo -n -e "$IDENTATION_LVL_2 Configure ... " 
	    	case $CFG_MTA in
			  	"courier")				
					echo '$imap_server_type       = "courier";' >> /etc/squirrelmail/config_local.php
					echo '$optional_delimiter     = ".";'       >> /etc/squirrelmail/config_local.php
					echo '$default_folder_prefix  = "INBOX.";'  >> /etc/squirrelmail/config_local.php
					echo '$trash_folder           = "Trash";'   >> /etc/squirrelmail/config_local.php
					echo '$sent_folder            = "Sent";'    >> /etc/squirrelmail/config_local.php
					echo '$draft_folder           = "Drafts";'  >> /etc/squirrelmail/config_local.php
					echo '$default_sub_of_inbox   = "false";'   >> /etc/squirrelmail/config_local.php
					echo '$delete_folder          = "true";'    >> /etc/squirrelmail/config_local.php
			  	;;
			  	"dovecot")
					echo '$imap_server_type       = "dovecot";' >> /etc/squirrelmail/config_local.php
					echo '$trash_folder           = "Trash";'   >> /etc/squirrelmail/config_local.php
					echo '$sent_folder            = "Sent";'    >> /etc/squirrelmail/config_local.php
					echo '$draft_folder           = "Drafts";'  >> /etc/squirrelmail/config_local.php
					echo '$default_sub_of_inbox   = "false";'   >> /etc/squirrelmail/config_local.php
					echo '$delete_folder          = "true";'    >> /etc/squirrelmail/config_local.php
			  	;;
	    	esac
		  	echo -e " [ ${green}DONE${NC} ] "	

		  	echo -n -e "$IDENTATION_LVL_2  Create temporary directory for squirrelmail ... " 
	    	mkdir /var/lib/squirrelmail/tmp
			chown www-data /var/lib/squirrelmail/tmp
			echo -e " [ ${green}DONE${NC} ] "	
		;;
  	esac

	if [ $CFG_WEBSERVER == "apache" ]; then
	  	service apache2 restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	else
	  	service nginx restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi

  	MeasureTimeDuration $START_TIME
}
