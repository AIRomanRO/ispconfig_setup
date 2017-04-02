#---------------------------------------------------------------------
# Function: InstallWebServer Debian 8
#    Install and configure Apache2, php + modules
#---------------------------------------------------------------------
InstallWebServer() {
  	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 Installing WEB Server... \n"	
	echo -n -e "$IDENTATION_LVL_2 Selected web Server: "
	
	if [ $CFG_WEBSERVER == "apache" ]; then
		echo -e "${BBlack} Apache2 ${NC}"
	elif [ $CFG_WEBSERVER == "nginx" ]; then		
		if [ $CFG_NGINX_VERSION == "default" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} OS Default ${NC}"
		elif [ $CFG_NGINX_VERSION == "nginx" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Official - nginx.org ${NC}"
		elif [ $CFG_NGINX_VERSION == "dotdeb" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} DotDeb.org - with 'full' HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "stretch" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Debian Stretch - with HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "custom" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Custom - With OpenSSL 1.1 and ChaCha20-Poly1305 ${NC}"
		fi
	else
		echo -e "${BBlack} NGINX {NC}"
	fi
	
	if [ $CFG_WEBSERVER == "apache" ]; then
		CFG_NGINX=n
		CFG_APACHE=y
		echo -n -e "$IDENTATION_LVL_1 Installing Apache and Modules... "		
		apt-get -yqq install apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libapache2-mod-php5 libapache2-mod-fastcgi libapache2-mod-fcgid apache2-suexec libapache2-mod-passenger libapache2-mod-python libexpat1 ssl-cert libruby > /dev/null 2>&1  
		echo -e "[ ${green}DONE${NC} ]\n"		
	  
		echo -n "$IDENTATION_LVL_1 Activating Apache2 Modules: "

		echo -n -e "$IDENTATION_LVL_2 suexec: "
		a2enmod suexec > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 rewrite: "
		a2enmod rewrite > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 ssl: "
		a2enmod ssl > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 actions: "
		a2enmod actions > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 include: "
		a2enmod include > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 dav_fs: "
		a2enmod dav_fs > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 dav: "
		a2enmod dav > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 auth_digest: "
		a2enmod auth_digest > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 fastcgi: "
		a2enmod fastcgi > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 alias: "
		a2enmod alias > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 fcgid: "
		a2enmod fcgid > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_1 Restart Apache Service... "
		service apache2 restart > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
	else
		
	    CFG_NGINX=y
		CFG_APACHE=n
		
		echo -n -e "$IDENTATION_LVL_1 Stop And Remove Apache ... \n"
		
		echo -n -e "$IDENTATION_LVL_2 Stop Apache2 Service: "
		service apache2 stop > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Disable Apache2 Service from ${BBlack}systemctl${NC}: "
		systemctl disable apache2 > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Remove Apache2 Service from ${BBlack}rc.d${NC}: "
		update-rc.d -f apache2 remove > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Remove Apache2 via ${BBlack}apt${NC}: "
		apt-get -yqq remove --purge apache2 > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"

		echo -n -e "$IDENTATION_LVL_1 Installing NGINX and Modules... \n "
		
		if [ $CFG_NGINX_VERSION == "default" ]; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} OS Default ${NC}"
			apt-get -yqq --force-yes install nginx -t stable > /dev/null 2>&1
			echo -e "[ ${green}DONE${NC} ]"
		elif [ $CFG_NGINX_VERSION == "nginx" ]; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} Official - nginx.org ${NC}"
			echo -e "[ ${green}DONE${NC} ]"
		elif [ $CFG_NGINX_VERSION == "dotdeb" ]; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} DotDeb.org - with 'full' HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "stretch" ]; then
			echo -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} Debian Stretch - with HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "custom" ]; then
			CWD=$(pwd);
			
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version: ${green} Custom - With OpenSSL 1.1 and ChaCha20-Poly1305 ${NC} \n"
			echo -n -e "$IDENTATION_LVL_2 Make the Local src folder "
			mkdir /usr/local/src -p && cd /usr/local/src
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Install OpenSSL v1.1"
			apt-get -yqq --force-yes install openssl libssl-dev -t stretch > /dev/null 2>&1			
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Get NGINX sources"
			apt-get source nginx > /dev/null 2>&1			
			echo -e "[ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Untar Nginx Sources"
			tar xf nginx*.gz			
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Go to Nginx Sources"
			cd nginx*			
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Untar Nginx Sources"
			tar xf ../nginx*.xz			
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Debuild Nginx Sources"
			debuild -uc -us > /dev/null 2>&1		
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Go to main Nginx Sources folder"
			cd ..		
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Install the builded Version"
			dpkg -i nginx_*.deb > /dev/null 2>&1	
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Go back to previous working directory"
			cd $CWD
			echo -e " [ ${green}DONE${NC} ]"
		fi		
		
		echo -n -e "$IDENTATION_LVL_1 Verify NGINX Available Sites Folder... "
		if [ ! -d "/etc/nginx/sites-available" ]; then
		   mkdir /etc/nginx/sites-available
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Verify NGINX Enabled Sites Folder... "
		if [ ! -d "/etc/nginx/sites-enabled" ]; then
		   mkdir /etc/nginx/sites-enabled
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Disable Listen on IPV6 if needed... "
		#Force install of nginx if no IPV6 enabled
		if [ $IPV6_ENABLED == false ]; then
			sed -i "s/listen \[::\]:80/###-No IPV6### listen [::]:80/" /etc/nginx/sites-available/default
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Restart Nginx Service... "
		service nginx restart > /dev/null 2>&1
		echo -e "[ ${green}DONE${NC} ]"
	fi
	
  	MeasureTimeDuration $START_TIME
}
