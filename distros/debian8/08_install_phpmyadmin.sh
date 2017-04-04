#---------------------------------------------------------------------
# Function: InstallPhpMyAdmin Debian 8
#    Install and configure PHPMyAdmin
#---------------------------------------------------------------------
InstallPHPMyAdmin() {
  	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing PHPMyAdmin... ${NC}\n"	
	
	echo $CFG_MYSQL_ROOT_PWD
	echo
	
	MeasureTimeDuration $START_TIME
 
  
	if [ $CFG_PHPMYADMIN == "yes" ]; then
		
		echo -n -e "$IDENTATION_LVL_1 Selected version: ${italic}${green}$CFG_PHPMYADMIN_VERSION${NC}\n"
		
		export DEBIAN_FRONTEND=noninteractive
		
		echo "==========================================================================================="
		echo "Attention: When asked 'Configure database for phpmyadmin with dbconfig-common?' select 'NO'"
		echo "Due to a bug in dbconfig-common, this can't be automated."
		echo "==========================================================================================="
		echo "Press ENTER to continue... "
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
		
		APP_DB_PASS=1234
		
		echo -n -e "$IDENTATION_LVL_1 Set passwords ... "	
		echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo -e " [ ${green}DONE${NC} ] "
		
		if [ $CFG_PHPMYADMIN_VERSION == "default" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Default Version ... "
			apt-get -y install phpmyadmin -t stable
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "jessie" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Jessie Backports Version ... "
			apt-get -y install phpmyadmin -t jessie-backports
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "stretch" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Stretch Version ... "
			apt-get -y install phpmyadmin -t stretch
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "latest-stable" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Latest Stable Version ... "
			
			PMA_VER="`wget -q -O - https://www.phpmyadmin.net/downloads/|grep -m 1 '<h2>phpMyAdmin'|sed -r 's/^[^3-9]*([0-9.]*).*/\1/'`"
			echo -n -e "$IDENTATION_LVL_2 Version Available ${BBlack}$PMA_VER${NC} ... "
			
			echo -n -e "$IDENTATION_LVL_2 Make temporary directory ... "
			mkdir /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			
			echo -n -e "$IDENTATION_LVL_2 Download from PHPMyAdmin ... "
			wget -O "/tmp/phpmyadmin/phpMyAdmin-latest.tar.gz" "https://files.phpmyadmin.net/phpMyAdmin/${PMA_VER}/phpMyAdmin-${PMA_VER}-all-languages.tar.gz"
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Download from PHPMyAdmin ... "
			tar zxf "/tmp/phpmyadmin/phpMyAdmin-latest.tar.gz" -C /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
		
		fi
		
		unset DEBIAN_FRONTEND	
	else
		echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
	fi
  

  	MeasureTimeDuration $START_TIME

	exit 1;
}
