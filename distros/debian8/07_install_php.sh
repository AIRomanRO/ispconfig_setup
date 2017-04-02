#---------------------------------------------------------------------
# Function: InstallWebServer Debian 8
#    Install and configure Apache2, php + modules
#---------------------------------------------------------------------
InstallPHP() {
  	START_TIME=$SECONDS
	  if [ $CFG_WEBSERVER == "apache" ]; then
	  CFG_NGINX=n
	  CFG_APACHE=y
	  echo -n "Installing Apache and Modules... "
		echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
		# - DISABLED DUE TO A BUG IN DBCONFIG - echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
		echo "dbconfig-common dbconfig-common/dbconfig-install boolean false" | debconf-set-selections
		apt-get -yqq install apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libapache2-mod-php5 libapache2-mod-fastcgi libapache2-mod-fcgid apache2-suexec libapache2-mod-passenger libapache2-mod-python libexpat1 ssl-cert libruby > /dev/null 2>&1  
		echo -e "[${green}DONE${NC}]\n"
		echo -n "Installing PHP and Modules... "
		apt-get -yqq install php7.0 php7.0-common php7.0-fpm php7.0-mysql php7.0-curl php7.0-imap php7.0-mcrypt php7.0-mbstring php7.0-sqlite3 php7.0-soap php7.0-xml php7.0-xsl php7.0-zip php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0-snmp php7.0-cli  > /dev/null 2>&1
		echo -e "[${green}DONE${NC}]\n"
		echo -n "Installing needed Programs for PHP and Apache... "
		apt-get -yqq install mcrypt imagemagick memcached curl tidy snmp > /dev/null 2>&1
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
		apt-get -yqq install php7.0-xcache > /dev/null 2>&1
		echo -e "[${green}DONE${NC}]\n"
	  fi
		
		echo -n "Activating Apache2 Modules... "
		a2enmod suexec > /dev/null 2>&1
		a2enmod rewrite > /dev/null 2>&1
		a2enmod ssl > /dev/null 2>&1
		a2enmod actions > /dev/null 2>&1
		a2enmod include > /dev/null 2>&1
		a2enmod dav_fs > /dev/null 2>&1
		a2enmod dav > /dev/null 2>&1
		a2enmod auth_digest > /dev/null 2>&1
		a2enmod fastcgi > /dev/null 2>&1
		a2enmod alias > /dev/null 2>&1
		a2enmod fcgid > /dev/null 2>&1
		service apache2 restart > /dev/null 2>&1
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
		systemctl disable apache2 > /dev/null 2>&1
		update-rc.d -f apache2 remove > /dev/null 2>&1
		apt-get -yqq remove --purge apache2
		echo -n "Remove of Apache completed... \n"

		apt-get -yqq install nginx nginx-common nginx-full > /dev/null 2>&1
		
		if [ ! -d "/etc/nginx/sites-available" ]; then
		   mkdir /etc/nginx/sites-available
		fi
		
		if [ ! -d "/etc/nginx/sites-enabled" ]; then
		   mkdir /etc/nginx/sites-enabled
		fi
		
		#Force install of nginx if no IPV6 enabled
		if [ $IPV6_ENABLED == false ]; then
			sed -i "s/listen \[::\]:80/###-No IPV6### listen [::]:80/" /etc/nginx/sites-available/default
			apt-get -yqq install nginx nginx-common nginx-full > /dev/null 2>&1
		fi
		
		service nginx start 
		echo -n "Install of NGINx completed... \n"

		apt-get -yqq install php7.0-fpm php7.0-mysql php7.0-curl php7.0-imap php7.0-mcrypt php7.0-mbstring php7.0-sqlite3 php7.0-soap php7.0-xml php7.0-xsl php7.0-zip php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0-snmp php7.0-cli > /dev/null 2>&1
		sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
		sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/7.0/fpm/php.ini
		echo -n "Install of PHP7.0 completed... \n"
		
		echo -n "Installing needed Programs for PHP and NGINX... "
		apt-get -yqq install mcrypt imagemagick memcached curl tidy snmp > /dev/null 2>&1
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