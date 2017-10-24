#---------------------------------------------------------------------
# Function: InstallWebServer Debian 8
#    Install and configure Apache2 / NGINX
#---------------------------------------------------------------------

source $PWD/distros/$DISTRO/06-1_install_webserver_hhvm.sh

InstallWebServer() { 
  	START_TIME=$SECONDS 
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing WEB Server${NC} \n"	
	echo -n -e "$IDENTATION_LVL_2 Selected web Server: "
	
	if [ $CFG_WEBSERVER == "apache" ]; then
		echo -e "${BBlack} Apache2 ${NC}"
	elif [ $CFG_WEBSERVER == "nginx" ]; then		
		if [ $CFG_NGINX_VERSION == "n-os-default" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} OS Default ${NC}"
		elif [ $CFG_NGINX_VERSION == "n-nginx" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Official - nginx.org ${NC}"
		elif [ $CFG_NGINX_VERSION == "n-dotdeb" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} DotDeb.org - with 'full' HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "n-stretch" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Debian Stretch - with HTTP2 ${NC}"
		elif [ $CFG_NGINX_VERSION == "n-custom" ]; then
			echo -e "${BBlack} NGINX ${NC} "
			echo -e "$IDENTATION_LVL_2 Version: ${green} Custom - With OpenSSL 1.1 and ChaCha20-Poly1305 ${NC}"
		fi
	else
		echo -n -e "${red} None {NC}"
	fi
	
	if [ $CFG_WEBSERVER == "apache" ]; then
		CFG_NGINX=n
		CFG_APACHE=y
		echo -n -e "$IDENTATION_LVL_1 Installing Apache and Modules... "		
		package_install apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libapache2-mod-fastcgi libapache2-mod-fcgid apache2-suexec php-gettext libapache2-mod-passenger libapache2-mod-python libexpat1 ssl-cert libruby
		echo -e "[ ${green}DONE${NC} ]\n"		
	  
		echo -n "$IDENTATION_LVL_1 Activating Apache2 Modules: "

		echo -n -e "$IDENTATION_LVL_2 suexec: "
		a2enmod suexec >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 rewrite: "
		a2enmod rewrite >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 ssl: "
		a2enmod ssl >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 actions: "
		a2enmod actions >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 include: "
		a2enmod include >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 dav_fs: "
		a2enmod dav_fs >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 dav: "
		a2enmod dav >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 auth_digest: "
		a2enmod auth_digest >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 fastcgi: "
		a2enmod fastcgi >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 alias: "
		a2enmod alias >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 fcgid: "
		a2enmod fcgid >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_1 Restart Apache Service... "
		service apache2 restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
	elif [ $CFG_WEBSERVER == "nginx" ]; then
		
	    CFG_NGINX=y
		CFG_APACHE=n
		
		echo -n -e "$IDENTATION_LVL_1 Stop And Remove Apache ... \n"
		
		echo -n -e "$IDENTATION_LVL_2 Stop Apache2 Service: "
		service apache2 stop >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Disable Apache2 Service from ${BBlack}systemctl${NC}: "
		systemctl disable apache2 >> $PROGRAMS_INSTALL_LOG_FILES 2>&1 
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Remove Apache2 Service from ${BBlack}rc.d${NC}: "
		update-rc.d -f apache2 remove >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_2 Remove Apache2 from ${BBlack}apt${NC}: "
		package_purge_remove apache2 >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ]"

		echo -n -e "$IDENTATION_LVL_1 Installing NGINX and Modules... "
		echo
		
		if [ $CFG_NGINX_VERSION == "n-os-default" ]; then
		
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} OS Default ${NC}"
			package_install nginx -t stable
			echo -e "[ ${green}DONE${NC} ]"
			
		elif [ $CFG_NGINX_VERSION == "n-nginx" ]; then
		
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} Official - nginx.org ${NC}"
			package_install nginx
			echo -e "[ ${green}DONE${NC} ]"
			
		elif [ $CFG_NGINX_VERSION == "n-dotdeb" ]; then
		
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} DotDeb.org - with 'full' HTTP2 ${NC}\n"
			
			echo -n -e "$IDENTATION_LVL_3 ${BBlack}Build Dependencies${NC}"
			apt-get -yqq --force-yes build-dep nginx nginx-full -t jessie-nginx-http2 >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_3 ${BBlack}Install ${BWhite}libssl1.0.0${BBlack} from ${BWhite}jessie-backports ${NC}"
			package_install libssl1.0.0/jessie-backports libssl-dev/jessie-backports openssl/jessie-backports
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_3 ${BBlack}Install ${BWhite}nginx${BBlack} & ${BWhite}nginx-full${NC}"
			package_install nginx nginx-full -t jessie-nginx-http2
			echo -e " [ ${green}DONE${NC} ]"
			
		elif [ $CFG_NGINX_VERSION == "n-stretch" ]; then
		
			echo -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green} Debian Stretch - with HTTP2 ${NC}"
			package_install nginx -t stretch
			echo -e " [ ${green}DONE${NC} ]"
			
		elif [ $CFG_NGINX_VERSION == "n-custom" ]; then
			CWD=$(pwd);
			
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version: ${green} Custom - With OpenSSL 1.1 and ChaCha20-Poly1305 ${NC} \n"
			echo -n -e "$IDENTATION_LVL_2 Make the Local src folder "
			mkdir -p /usr/local/src -p && cd /usr/local/src
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Install OpenSSL v1.1"
			package_install openssl libssl-dev -t stretch
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Get NGINX sources"
			apt-get source nginx >> $PROGRAMS_INSTALL_LOG_FILES 2>&1			
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
			debuild -uc -us >> $PROGRAMS_INSTALL_LOG_FILES 2>&1		
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Go to main Nginx Sources folder"
			cd ..		
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Install the builded Version"
			dpkg -i nginx_*.deb >> $PROGRAMS_INSTALL_LOG_FILES 2>&1	
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_2 Go back to previous working directory"
			cd $CWD
			echo -e " [ ${green}DONE${NC} ]"
		fi		
		
		echo -n -e "$IDENTATION_LVL_1 Verify NGINX Available Sites Folder... "
		if [ ! -d "/etc/nginx/sites-available" ]; then
		   mkdir -p /etc/nginx/sites-available >> $PROGRAMS_INSTALL_LOG_FILES 2>&1	
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Verify NGINX Enabled Sites Folder... "
		if [ ! -d "/etc/nginx/sites-enabled" ]; then
		   mkdir -p /etc/nginx/sites-enabled >> $PROGRAMS_INSTALL_LOG_FILES 2>&1	
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Disable Listen on IPV6 if needed... "
		#Force install of nginx if no IPV6 enabled
		if [ $IPV6_ENABLED == false ]; then
			sed -i "s/listen \[::\]:80/###-No IPV6### listen [::]:80/" /etc/nginx/sites-available/default
		fi
		echo -e "[ ${green}DONE${NC} ]"
		
		echo -n -e "$IDENTATION_LVL_1 Restart Nginx Service... "
		service nginx restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e "[ ${green}DONE${NC} ]"
	fi
	
  	MeasureTimeDuration $START_TIME

  	InstallHHVM
}
