#---------------------------------------------------------------------
# Function: InstallWebServer Debian 8
#    Install and configure Apache2, php + modules
#---------------------------------------------------------------------
InstallWebServer() {
  	START_TIME=$SECONDS
	  if [ $CFG_WEBSERVER == "apache" ]; then
	  CFG_NGINX=n
	  CFG_APACHE=y
	  echo -n "Installing Apache and Modules... "
		echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
		# - DISABLED DUE TO A BUG IN DBCONFIG - echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
		echo "dbconfig-common dbconfig-common/dbconfig-install boolean false" | debconf-set-selections
		apt-get -yqq install apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libapache2-mod-php5 libapache2-mod-fastcgi libapache2-mod-fcgid apache2-suexec libapache2-mod-passenger libapache2-mod-python libexpat1 ssl-cert libruby >> $PROGRAMS_INSTALL_LOG_FILES 2>&1  
		echo -e "[${green}DONE${NC}]\n"
		echo -n "Installing PHP and Modules... "
		apt-get -yqq install php7.0 php7.0-common php7.0-fpm php7.0-mysql php7.0-curl php7.0-imap php7.0-mcrypt php7.0-mbstring php7.0-sqlite3 php7.0-soap php7.0-xml php7.0-xsl php7.0-zip php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0-snmp php7.0-cli  >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[${green}DONE${NC}]\n"
		echo -n "Installing needed Programs for PHP and Apache... "
		apt-get -yqq install mcrypt imagemagick memcached curl tidy snmp >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e "[${green}DONE${NC}]\n"
		
	  if [ $CFG_PHPMYADMIN == "yes" ]; then
		echo "==========================================================================================="
		echo "Attention: When asked 'Configure database for phpmyadmin with dbconfig-common?' select 'NO'"
		echo "Due to a bug in dbconfig-common, this can't be automated."
		echo "==========================================================================================="
		echo "Press ENTER to continue... "
		read DUMMY
		echo -n "Installing phpMyAdmin... "
		apt-get -y install phpmyadmin
		echo -e "[${green}DONE${NC}]\n"
	  fi
		
	  if [ "$CFG_XCACHE" == "yes" ]; then
		echo -n "Installing XCache... "
		apt-get -yqq install php7.0-xcache >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[${green}DONE${NC}]\n"
	  fi
		
		echo -n "Activating Apache2 Modules... "
		a2enmod suexec >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod rewrite >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod ssl >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod actions >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod include >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod dav_fs >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod dav >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod auth_digest >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod fastcgi >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod alias >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		a2enmod fcgid >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service apache2 restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[${green}DONE${NC}]\n"
		
		echo -n "Installing Lets Encrypt... "	
		apt-get -yqq install python-certbot-apache -t jessie-backports
		certbot &
		echo -e "[${green}DONE${NC}]\n"
	  
	  else
		
	  CFG_NGINX=y
	  CFG_APACHE=n
		echo -n "Installing NGINX and Modules... \n"
		service apache2 stop
		systemctl disable apache2 >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		update-rc.d -f apache2 remove >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		apt-get -yqq remove --purge apache2
		echo -n "Remove of Apache completed... \n"

		apt-get -yqq install nginx nginx-common nginx-full >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		
		if [ ! -d "/etc/nginx/sites-available" ]; then
		   mkdir /etc/nginx/sites-available
		fi
		
		if [ ! -d "/etc/nginx/sites-enabled" ]; then
		   mkdir /etc/nginx/sites-enabled
		fi
		
		#Force install of nginx if no IPV6 enabled
		if [ $IPV6_ENABLED == false ]; then
			sed -i "s/listen \[::\]:80/###-No IPV6### listen [::]:80/" /etc/nginx/sites-available/default
			apt-get -yqq install nginx nginx-common nginx-full >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		fi
		
		service nginx start 
		echo -n "Install of NGINx completed... \n"

		apt-get -yqq install php7.0-fpm php7.0-mysql php7.0-curl php7.0-imap php7.0-mcrypt php7.0-mbstring php7.0-sqlite3 php7.0-soap php7.0-xml php7.0-xsl php7.0-zip php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0-snmp php7.0-cli >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
		sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/7.0/fpm/php.ini
		echo -n "Install of PHP7.0 completed... \n"
		
		echo -n "Installing needed Programs for PHP and NGINX... "
		apt-get -yqq install mcrypt imagemagick memcached curl tidy snmp >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		#sed -i "s/#/;/" /etc/php5/conf.d/ming.ini
		apt-get -yqq install fcgiwrap
		service php7.0-fpm reload
	  
	  if [ $CFG_PHPMYADMIN == "yes" ]; then
		echo "==========================================================================================="
		echo "Attention: When asked 'Configure database for phpmyadmin with dbconfig-common?' select 'NO'"
		echo "Due to a bug in dbconfig-common, this can't be automated."
		echo "==========================================================================================="
		echo "Press ENTER to continue... "
		read DUMMY
		echo -n "Installing phpMyAdmin... "
		apt-get -y install phpmyadmin
		echo -e "[${green}DONE${NC}]\n"
	  fi
	  
		echo -n "Installing Lets Encrypt... "	
		apt-get -yqq install certbot python-certbot -t jessie-backports
		certbot &
		echo -e "[${green}DONE${NC}]\n"
	  
	  fi
	  echo -e "[${green}DONE${NC}]\n"
  
  	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	echo 
	echo -n -e "==> ${green}Completed ON ${NC}"
	echo -e ": ${red} $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
	echo -e "${NC}"	
	echo -n -e " "
	
	exit 1;
}
