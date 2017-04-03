#---------------------------------------------------------------------
# Function: InstallPHP Debian 8
#    Install and configure php
#---------------------------------------------------------------------
InstallPHP() {
  	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 Installing PHP... \n"	
	echo -n -e "$IDENTATION_LVL_2 Selected Versions: ${green}"$CFG_PHP_VERSION"${NC}\n"
	
	echo -n -e "$IDENTATION_LVL_1 Build PHP modules raw list ... "
	PHP_RAW_MODULES="PHP_SELECTED_VERSION-mysql PHP_SELECTED_VERSION-curl PHP_SELECTED_VERSION-mcrypt PHP_SELECTED_VERSION-mbstring PHP_SELECTED_VERSION-sqlite3 PHP_SELECTED_VERSION-soap"
	PHP_RAW_MODULES="$PHP_RAW_MODULES PHP_SELECTED_VERSION-xml PHP_SELECTED_VERSION-cgi	PHP_SELECTED_VERSION-xsl PHP_SELECTED_VERSION-zip PHP_SELECTED_VERSION-recode"
	PHP_RAW_MODULES="$PHP_RAW_MODULES PHP_SELECTED_VERSION-pspell PHP_SELECTED_VERSION-tidy PHP_SELECTED_VERSION-xmlrpc PHP_SELECTED_VERSION-snmp PHP_SELECTED_VERSION-mysqlnd"
	PHP_RAW_MODULES="$PHP_RAW_MODULES PHP_SELECTED_VERSION-gd PHP_SELECTED_VERSION-imap PHP_SELECTED_VERSION-cli PHP_SELECTED_VERSION-intl PHP_SELECTED_VERSION-opcache"
	PHP_RAW_MODULES="$PHP_RAW_MODULES PHP_SELECTED_VERSION-readline PHP_SELECTED_VERSION-bz2"
	echo -e " [ ${green}DONE${NC} ]"

	
	echo -n -e "$IDENTATION_LVL_1 Build aditional programs raw list ... "
	RAW_ADITIONAL_PROGRAMS="fcgiwrap php-pear php-auth php-gd php-apcu php-redis redis-server memcached php-memcache php-imagick php-gettext mcrypt imagemagick libruby curl snmp tidy"
	echo -e " [ ${green}DONE${NC} ] "
	
	
	echo -n -e "$IDENTATION_LVL_1 Add PHP according with selected web server ... "
	if [ $CFG_WEBSERVER == "apache" ]; then
		PHP_RAW_MODULES="PHP_SELECTED_VERSION libapache2-mod-PHP_SELECTED_VERSION $PHP_RAW_MODULES "
	elif [ $CFG_WEBSERVER == "nginx" ]; then
		PHP_RAW_MODULES="PHP_SELECTED_VERSION-fpm $PHP_RAW_MODULES"
	fi
	echo -e " [ ${green}DONE${NC} ] "

	
	ANY_VERSION_INSTALLED=false
	for PHP_VERSION_ENABLED in ${CFG_PHP_VERSION[@]};
    do
        case $PHP_VERSION_ENABLED in
            "php5.6" )
				echo -n -e "$IDENTATION_LVL_1 Install PHP version ${BBlack} 5.6 ${NC}:"
				echo
				echo -n -e "$IDENTATION_LVL_2 Prepare PHP Modules list ... "
				PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/$PHP_VERSION_ENABLED}"
				echo -e " [ ${green}DONE${NC} ] "

				echo -n -e "$IDENTATION_LVL_2 Install PHP Modules list ... "
				apt-get -yqq --force-yes install $PARSED_PHP_MODULE_LIST >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
				sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
				sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/5.6/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				ANY_VERSION_INSTALLED=true
		    ;;
            "php7.0" )
				echo -n -e "$IDENTATION_LVL_1 Install PHP version ${BBlack} 7.0 ${NC}:"
				echo
				echo -n -e "$IDENTATION_LVL_2 Prepare PHP Modules list ... "
				PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/$PHP_VERSION_ENABLED}"
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Install PHP Modules list ... "
				apt-get -yqq --force-yes install $PARSED_PHP_MODULE_LIST >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
				sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
				sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/7.0/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				ANY_VERSION_INSTALLED=true
		    ;;
            "php7.1" )
				echo -n -e "$IDENTATION_LVL_1 Install PHP version ${BBlack} 7.1 ${NC}:"
				echo
				echo -n -e "$IDENTATION_LVL_2 Prepare PHP Modules list ... "
				PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/$PHP_VERSION_ENABLED}"
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Install PHP Modules list ... "
				apt-get -yqq --force-yes install $PARSED_PHP_MODULE_LIST >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
				sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
				sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/7.1/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "
				
				ANY_VERSION_INSTALLED=true
		    ;;            
            "none" )
				if [ $ANY_VERSION_INSTALLED == false ]; then
					echo -n "$IDENTATION_LVL_1 Installing basic php modules for ispconfig ... "
					if [ $CFG_WEBSERVER == "apache" ]; then
						apt-get -yqq install php7.0 libapache2-mod-php7.0 php7.0-cli php7.0-mysql php7.0-mcrypt >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					elif [ $CFG_WEBSERVER == "nginx" ]; then
						apt-get -yqq install php7.0-fpm php7.0-cli php7.0-mysql php7.0-mcrypt >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					fi
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
        esac
    done

	
	echo -n "$IDENTATION_LVL_1 Install needed Programs for PHP and Web Server ... "
	apt-get -yqq install --force-yes $RAW_ADITIONAL_PROGRAMS >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -e " [ ${green}DONE${NC} ]"
  
  
	echo -n -e "$IDENTATION_LVL_1 Restart Web Server and PHP ... "
	echo
	if [ $CFG_WEBSERVER == "apache" ]; then
	
		echo -n -e "$IDENTATION_LVL_2 Restart Apache2 Web Server ... "
		service apache2 restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1		
		echo -e " [ ${green}DONE${NC} ] "
		
	elif [ $CFG_WEBSERVER == "nginx" ]; then
	
		echo -n -e "$IDENTATION_LVL_2 Restart NGINX Web Server ... "
		service nginx restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_2 Restart PHP-FPM ... "
		service php5.6-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php7.0-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php7.1-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ] "
		
	fi
	
  	MeasureTimeDuration $START_TIME
}
