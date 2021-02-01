#---------------------------------------------------------------------
# Function: InstallPHP Debian 8
#    Install and configure php
#---------------------------------------------------------------------
InstallPHP() {
  	START_TIME=$SECONDS

	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing PHP${NC}\n"
	echo -n -e "$IDENTATION_LVL_2 Selected Versions: ${green}"$CFG_PHP_VERSION"${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 Build PHP modules raw list ... "
	PHP_RAW_MODULES="phpPHP_SELECTED_VERSION-curl phpPHP_SELECTED_VERSION-common phpPHP_SELECTED_VERSION-mcrypt phpPHP_SELECTED_VERSION-mbstring phpPHP_SELECTED_VERSION-sqlite3 phpPHP_SELECTED_VERSION-soap"
	PHP_RAW_MODULES="$PHP_RAW_MODULES phpPHP_SELECTED_VERSION-xml phpPHP_SELECTED_VERSION-cgi	phpPHP_SELECTED_VERSION-xsl phpPHP_SELECTED_VERSION-zip"
	PHP_RAW_MODULES="$PHP_RAW_MODULES phpPHP_SELECTED_VERSION-pspell phpPHP_SELECTED_VERSION-tidy phpPHP_SELECTED_VERSION-snmp phpPHP_SELECTED_VERSION-mysqlnd"
	PHP_RAW_MODULES="$PHP_RAW_MODULES phpPHP_SELECTED_VERSION-gd phpPHP_SELECTED_VERSION-imap phpPHP_SELECTED_VERSION-cli"
	PHP_RAW_MODULES="$PHP_RAW_MODULES phpPHP_SELECTED_VERSION-readline phpPHP_SELECTED_VERSION-bz2 phpPHP_SELECTED_VERSION-xmlrpc "
	echo -e " [ ${green}DONE${NC} ]"


	echo -n -e "$IDENTATION_LVL_1 Build aditional programs raw list ... "
	RAW_ADITIONAL_PROGRAMS="fcgiwrap php-tcpdf php-pear php-gd php-apcu php-redis redis-server memcached php-memcached imagemagick php-imagick mcrypt libruby curl snmp tidy"
	echo -e " [ ${green}DONE${NC} ] "


	echo -n -e "$IDENTATION_LVL_1 Add PHP according with selected web server ... "
	if [ $CFG_WEBSERVER == "apache" ]; then
		PHP_RAW_MODULES="phpPHP_SELECTED_VERSION libapache2-mod-PHP_SELECTED_VERSION $PHP_RAW_MODULES "
	elif [ $CFG_WEBSERVER == "nginx" ]; then
		PHP_RAW_MODULES="phpPHP_SELECTED_VERSION-fpm $PHP_RAW_MODULES"
	fi
	echo -e " [ ${green}DONE${NC} ] "


	# echo -n -e "$IDENTATION_LVL_1 Install current distro php5 version (${red}needed by ISPConfig${NC}) \n"

	# echo -n -e "$IDENTATION_LVL_2 Prepare PHP5 Modules list ... "
	# PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/php5}"
	# #php5-soap will be installed as php-soap
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-soap/}"
	# #php5-xml will be installed as php-xml
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-xml/}"
	# #php5-zip will be installed as php-zip
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-zip/}"
	# #php5-bz2 will be installed as php-bz2
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-bz2/}"
	# #php5-mbstring will be installed as php-mbstring
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-mbstring/php-mbstring}"
	# #php5-sqlite3 will be installed as php-sqlite3
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST//php5-sqlite3/php-sqlite3}"
	# #fix php5-xmlrpc wrong rename
	# PARSED_PHP_MODULE_LIST="${PARSED_PHP_MODULE_LIST// rpc / php5-xmlrpc }"
	# echo -e " [ ${green}DONE${NC} ] "

	# echo -n -e "$IDENTATION_LVL_2 Install PHP5 Modules list [ ${green}$PARSED_PHP_MODULE_LIST${NC} ] ... "
	# package_install $PARSED_PHP_MODULE_LIST
	# echo -e " [ ${green}DONE${NC} ] "

	# echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
	# sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	# echo -e " [ ${green}DONE${NC} ] "

	# echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
	# sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php5/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	# echo -e " [ ${green}DONE${NC} ] "


	ANY_VERSION_INSTALLED=false
	for PHP_VERSION_ENABLED in "${CFG_PHP_VERSION[@]}";
    do
        case $PHP_VERSION_ENABLED in
             "5.6" )
				 echo -n -e "$IDENTATION_LVL_1 Install PHP version ${BBlack} 5.6 ${NC}:"
				 echo
				 echo -n -e "$IDENTATION_LVL_2 Prepare PHP5.6 Modules list ... "
				 PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/$PHP_VERSION_ENABLED}"
				 echo -e " [ ${green}DONE${NC} ] "

				 echo -n -e "$IDENTATION_LVL_2 Install PHP5.6 Modules list ... "
				 package_install $PARSED_PHP_MODULE_LIST
				 echo -e " [ ${green}DONE${NC} ] "

				 echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
				 sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				 echo -e " [ ${green}DONE${NC} ] "

				 echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
				 sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/5.6/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				 echo -e " [ ${green}DONE${NC} ] "

				 ANY_VERSION_INSTALLED=true
		     ;;
            "7.0" | "7.1" | "7.2" | "7.3" | "7.4" | "8.0" )
				echo -n -e "$IDENTATION_LVL_1 Install PHP version ${BBlack} $PHP_VERSION_ENABLED ${NC}:"
				echo
				echo -n -e "$IDENTATION_LVL_2 Prepare PHP $PHP_VERSION_ENABLED Modules list ... "
				PARSED_PHP_MODULE_LIST="${PHP_RAW_MODULES//PHP_SELECTED_VERSION/$PHP_VERSION_ENABLED}"
				echo -e " [ ${green}DONE${NC} ] "

				echo -n -e "$IDENTATION_LVL_2 Install PHP $PHP_VERSION_ENABLED Modules list [ ${green}$PARSED_PHP_MODULE_LIST${NC} ] ... "
				package_install $PARSED_PHP_MODULE_LIST
				echo -e " [ ${green}DONE${NC} ] "

				echo -n -e "$IDENTATION_LVL_2 Fix CGI PathInfo ... "
				sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/{$PHP_VERSION_ENABLED}/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "

				echo -n -e "$IDENTATION_LVL_2 Set Time Zone to Europe/Bucharest ... "
				sed -i "s/;date.timezone =/date.timezone=\"Europe\/Bucharest\"/" /etc/php/{$PHP_VERSION_ENABLED}/fpm/php.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "

				ANY_VERSION_INSTALLED=true
		    ;;
            "none" )
				if [ $ANY_VERSION_INSTALLED == false ]; then
					echo -n "$IDENTATION_LVL_1 Installing basic php modules for ispconfig ... "
					if [ $CFG_WEBSERVER == "apache" ]; then
						package_install php7.3 libapache2-mod-php7.3 php7.3-cli php7.3-mysql php7.3-mcrypt
						package_install php7.3-fpm php7.3-cli php7.3-mysql php7.3-mcrypt
					fi
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
        esac
    done

	echo -n -e "$IDENTATION_LVL_1 Set Default PHP Cli version to ${green} $CFG_PHP_CLI_VERSION ${NC} ... "
	if [ $CFG_PHP_CLI_VERSION != "ignore" ] && [ $CFG_PHP_CLI_VERSION != "latest" ];
	then
		update-alternatives --set php "/usr/bin/php$CFG_PHP_CLI_VERSION" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi

	echo -n "$IDENTATION_LVL_1 Install needed Programs for PHP and Web Server ... "
	package_install $RAW_ADITIONAL_PROGRAMS
	echo -e " [ ${green}DONE${NC} ]"


	echo -n -e "$IDENTATION_LVL_1 Restart Web Server and PHP ... "
	echo
	if [ $CFG_WEBSERVER == "apache" ];
	then
		echo -n -e "$IDENTATION_LVL_2 Restart Apache2 Web Server ... "
		service apache2 restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ] "
	elif [ $CFG_WEBSERVER == "nginx" ];
	then
		echo -n -e "$IDENTATION_LVL_2 Restart NGINX Web Server ... "
		service nginx restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ] "

		echo -n -e "$IDENTATION_LVL_2 Restart PHP-FPM ... "

		# service php5-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		for PHP_VERSION_ENABLED in "${CFG_PHP_VERSION[@]}";
    	do
			case $PHP_VERSION_ENABLED in
        "7.0" )
					service php7.0-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;

        "7.1" )
					service php7.1-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;

        "7.2" )
					service php7.2-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;

				"7.3" )
					service php7.3-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;

		    "7.4" )
					service php7.4-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;

		    "8.0" )
					service php7.4-fpm restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				;;
	        esac
        done

		echo -e " [ ${green}DONE${NC} ] "

	fi

  	MeasureTimeDuration $START_TIME
}
