#---------------------------------------------------------------------
# Function: InstallISPConfig
#    Start the ISPConfig3 intallation script
#---------------------------------------------------------------------
InstallISPConfig() {
	START_TIME=$SECONDS
  	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing ISPConfig${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 Download Latest ISPConfig ... "
	#https://sourceforge.net/projects/ispconfig/files/latest/download seems that it have 3.1.2 instead of 3.1.3 
	wget -q -O $PROGRAMS_INSTALL_DOWNLOAD/ISPConfig-3-stable-latest.tar.gz https://ispconfig.org/downloads/ISPConfig-3.1.13.tar.gz >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -e " [ ${green}DONE${NC} ] "

	echo -n -e "$IDENTATION_LVL_1 Untar the downloaded package ... "
	cd $PROGRAMS_INSTALL_DOWNLOAD
	tar xfz $PROGRAMS_INSTALL_DOWNLOAD/ISPConfig-3-stable-latest.tar.gz >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	cd $PWD
	echo -e " [ ${green}DONE${NC} ] "

	AUTO_INSTALL_INI_LOCATION=$PROGRAMS_INSTALL_DOWNLOAD/ispconfig3_install/install
	if [ $CFG_ISPC == "standard" ]; then
		echo -n -e "$IDENTATION_LVL_1 Create the autoinstall file "
		touch $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "[install]" > $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "language=en" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "install_mode=$CFG_ISPC" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "hostname=$CFG_HOSTNAME_FQDN" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		if [ $CFG_MYSQL_VERSION == "8.0" ]; then
			echo "mysql_hostname=127.0.0.1" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		else
			echo "mysql_hostname=localhost" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		fi
		echo "mysql_root_user=root" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_database=dbispconfig" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_port=3306" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_charset=utf8" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini

		if [ $CFG_WEBSERVER == "apache" ]; then
			echo "http_server=apache" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		elif [ $CFG_WEBSERVER == "nginx" ]; then
			echo "http_server=nginx" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		else
			echo "http_server=" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		fi

		echo "ispconfig_port=$CFG_ISPONCFIG_PORT" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ispconfig_admin_password=$CFG_ISPONCFIG_ADMIN_PASS" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ispconfig_use_ssl=y" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "[ssl_cert]" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ssl_cert_country=$SSL_COUNTRY" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "ssl_cert_state=$SSL_STATE" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ssl_cert_locality=$SSL_LOCALITY" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ssl_cert_organisation=$SSL_ORGANIZATION" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ssl_cert_organisation_unit=$SSL_ORGUNIT" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "ssl_cert_common_name=$CFG_HOSTNAME_FQDN" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "[expert]" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_ispconfig_user=ispconfig" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_ispconfig_password=$CFG_ISPCONFIG_DB_PASS" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "join_multiserver_setup=$MULTISERVER" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "mysql_master_hostname=$CFG_MASTER_FQDN" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_master_root_user=root" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_master_root_password=$CFG_MASTER_MYSQL_ROOT_PWD" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_master_database=dbispconfig" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "configure_mail=$CFG_SETUP_MAIL" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini

		if [ $CFG_SETUP_WEB == "y" ]; then
	      echo "configure_jailkit=$CFG_JKIT" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    else
	      echo "configure_jailkit=n" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    fi

	    echo "configure_ftp=$CFG_SETUP_WEB" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "configure_dns=$CFG_SETUP_NS" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "configure_apache=$CFG_APACHE" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "configure_nginx=$CFG_NGINX" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "configure_firewall=y" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "install_ispconfig_web_interface=$CFG_SETUP_MASTER" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "[update]" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "do_backup=yes" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "mysql_master_hostname=$CFG_MASTER_FQDN" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_master_root_user=root" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "mysql_master_root_password=$CFG_MASTER_MYSQL_ROOT_PWD" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "mysql_master_database=dbispconfig" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "reconfigure_permissions_in_master_database=no" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "reconfigure_services=yes" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "apps_vhost_port=$CFG_ISPONCFIG_APPS_PORT" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "ispconfig_port=$CFG_ISPONCFIG_PORT" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
		echo "create_new_ispconfig_ssl_cert=no" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini
	    echo "reconfigure_crontab=yes" >> $AUTO_INSTALL_INI_LOCATION/autoinstall.ini

	    echo -e " [ ${green}DONE${NC} ] "

	    echo -n -e "$IDENTATION_LVL_1 Start the automatic install process "

		cd $AUTO_INSTALL_INI_LOCATION
    	php -q install.php --autoinstall=autoinstall.ini >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		cd $PWD

    	echo -e " [ ${green}DONE${NC} ] "
  	else
  		echo -n -e "$IDENTATION_LVL_1 Start the install. During this you will be asked for serveral questions. Please follow the steps \n "

		cd $AUTO_INSTALL_INI_LOCATION
   		php -q install.php
		cd $PWD
 	fi

  	if [ $CFG_SETUP_WEB == "y" ]; then
  		echo -n -e "$IDENTATION_LVL_1 Restart the webserver "
	    if [ $CFG_WEBSERVER == "nginx" ]; then
	        /etc/init.d/nginx restart
	    else
	        /etc/init.d/apache2 restart
	    fi
	    echo -e " [ ${green}DONE${NC} ] "
  	fi

  	MeasureTimeDuration $START_TIME
}
