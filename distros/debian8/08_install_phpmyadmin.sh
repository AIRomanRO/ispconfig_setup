#---------------------------------------------------------------------
# Function: InstallPhpMyAdmin Debian 8
#    Install and configure PHPMyAdmin
#---------------------------------------------------------------------
InstallPHPMyAdmin() {
  	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing PHPMyAdmin... ${NC}\n"	
  
	if [ $CFG_PHPMYADMIN == "yes" ]; then
		
		echo -n -e "$IDENTATION_LVL_1 Selected version: ${green}$CFG_PHPMYADMIN_VERSION${NC}\n"
		
		export DEBIAN_FRONTEND=noninteractive
		
		echo -e "==========================================================================================="
		echo -e "Attention: If you will be asked ${green} 'Configure database for phpmyadmin with dbconfig-common?' ${NC} select ${red} 'NO' ${NC}"
		echo -e "Due to a bug in dbconfig-common, it is possible that this can't be automated."
		echo -e "==========================================================================================="
		echo -e "Press ENTER to continue... "
		read DUMMY
		
		echo -n -e "$IDENTATION_LVL_1 Set Reconfigure WebServer on debconf as ${BBlack}$CFG_WEBSERVER${NC} ... "
		if [ $CFG_WEBSERVER == "apache" ]; then
			echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections			
		else
			echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect " | debconf-set-selections
		fi
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Set dbconfig-common to ${BBlack}true${NC} ... "
		echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
		echo "dbconfig-common dbconfig-common/dbconfig-install boolean true" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections	
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Generate phpMyAdmin db password ... "
		APP_DB_PASS=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-32})
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Set passwords ... "	
		echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_DB_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo -e " [ ${green}DONE${NC} ] "
		
		if [ $CFG_PHPMYADMIN_VERSION == "default" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Default Version ... "
			apt-get -y install phpmyadmin -t stable >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "jessie" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Jessie Backports Version ... "
			apt-get -y install phpmyadmin -t jessie-backports >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "stretch" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Stretch Version ... "
			apt-get -y install phpmyadmin -t stretch >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "latest-stable" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Latest Stable Version ... "
			echo
			
			PMA_VER="`wget -q -O - https://www.phpmyadmin.net/downloads/|grep -m 1 '<h2>phpMyAdmin'|sed -r 's/^[^3-9]*([0-9.]*).*/\1/'`"
			echo -n -e "$IDENTATION_LVL_2 Version Available ${BBlack}$PMA_VER${NC} ... "
			echo
			
			echo -n -e "$IDENTATION_LVL_2 Make temporary directory ... "
			mkdir -p /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			
			echo -n -e "$IDENTATION_LVL_2 Download from PHPMyAdmin ... "
			wget -q -O "/tmp/phpmyadmin/phpMyAdmin-latest.tar.gz" "https://files.phpmyadmin.net/phpMyAdmin/${PMA_VER}/phpMyAdmin-${PMA_VER}-all-languages.tar.gz"
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Extract the downloaded file ... "
			tar zxf /tmp/phpmyadmin/phpMyAdmin-latest.tar.gz -C /tmp/phpmyadmin/
			echo -e " [ ${green}DONE${NC} ] "
		
			echo -n -e "$IDENTATION_LVL_2 Remove the downloaded file ... "
			rm -rf /tmp/phpmyadmin/phpMyAdmin-latest.tar.gz
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Make destination folder ... "
			mkdir -p /usr/share/phpmyadmin
			mkdir -p /etc/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "

			echo -n -e "$IDENTATION_LVL_2 Ensure that the destination folder is empty ... "
			rm -rf /usr/share/phpmyadmin/*
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Copy current phpMyAdmin files to destination folder ... "
			cp -Rpf /tmp/phpmyadmin/*/* /usr/share/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Create the phpMyAdmin config file from sample ... "
			cp /usr/share/phpmyadmin/config.sample.inc.php /etc/phpmyadmin/config.inc.php
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Remove the temporary folder ... "
		    rm -rf /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Generate phpMyAdmin tables ... "
		    mysql -u root -p$CFG_MYSQL_ROOT_PWD < /usr/share/phpmyadmin/sql/create_tables.sql >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "

			echo -n -e "$IDENTATION_LVL_2 Insert phpMyAdmin user and password ... "
		    echo "CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '"$APP_DB_PASS"';" > tmpSQL.sql
            echo "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'phpmyadmin'@'localhost';" >> tmpSQL.sql
            echo "FLUSH PRIVILEGES;" >> tmpSQL.sql
            mysql -u root -p$CFG_MYSQL_ROOT_PWD < tmpSQL.sql >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
            rm -f tmpSQL.sql
			echo -e " [ ${green}DONE${NC} ] -->"$APP_DB_PASS

			echo -n -e "$IDENTATION_LVL_2 Generate and set random blowfish string ... "
			BLOWFISH=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9' | head -c${1:-64})
			sed -i "s/blowfish_secret'] = ''/blowfish_secret'] = '$BLOWFISH'/" /etc/phpmyadmin/config.inc.php
			echo -e " [ ${green}DONE${NC} ] "

			echo -n -e "$IDENTATION_LVL_2 Update configs ... "
			sed -i "s/define('CONFIG_DIR', '')/define('CONFIG_DIR', '\/etc\/phpmyadmin\/')/"  /usr/share/phpmyadmin/libraries/vendor_config.php

			sed  -i "/controluser/c\$cfg['Servers'][\$i]['controluser']='phpmyadmin'/" /etc/phpmyadmin/config.inc.php;
			sed  -i "/controlpass/c\$cfg['Servers'][\$i]['controlpass']='$APP_DB_PASS'/" /etc/phpmyadmin/config.inc.php;

			sed  -i "/^\/\/.*'pmadb'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'bookmarktable'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'relation'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'table_info'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'table_coords'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'pdf_pages'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'column_info'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'history'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'table_uiprefs'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'tracking'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'userconfig'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'recent'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'favorite'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'users'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'usergroups'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'navigationhiding'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'savedsearches'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'central_columns'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'designer_settings'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			sed  -i "/^\/\/.*'export_templates'/s/^\/\///g" /etc/phpmyadmin/config.inc.php;
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Remove the test folder ... "
			rm -rf /usr/share/phpmyadmin/test
			echo -e " [ ${green}DONE${NC} ] "

			echo -n -e "$IDENTATION_LVL_2 Remove the setup folder ... "
			rm -rf /usr/share/phpmyadmin/setup
			echo -e " [ ${green}DONE${NC} ] "
			
		fi
		
		unset DEBIAN_FRONTEND	
	else
		echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
	fi
  

  	MeasureTimeDuration $START_TIME
}
