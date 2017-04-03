#---------------------------------------------------------------------
# Function: InstallPhpMyAdmin Debian 8
#    Install and configure PHPMyAdmin
#---------------------------------------------------------------------
InstallPhpMyAdmin() {
  	START_TIME=$SECONDS
	
	echo "STARTMYADMIN"
	echo $CFG_MYSQL_ROOT_PWD
	echo
	
	MeasureTimeDuration $START_TIME
	
  exit 1;
  
	# if [ $CFG_PHPMYADMIN == "yes" ]; then
        # while [ "x$CFG_PHPMYADMIN_VERSION" == "x" ]
	    # do
		    # CFG_PHPMYADMIN_VERSION=$(whiptail --title "Install phpMyAdmin" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			# "From Where Do you want to install phpMyAdmin?" 10 60 3 \
			# "default" "Current OS Version" ON \
			# "jessie"  "from jessie backports - possible newer" OFF \
			# "stretch" "from stretch version - newer" OFF 3>&1 1>&2 2>&3)
	    # done
		# echo -n -e "$IDENTATION_LVL_1 ${BBlack}PhpMyAdmin Version${NC}: ${green}$CFG_PHPMYADMIN_VERSION${NC}\n"
	# fi
	
	  if [ $CFG_WEBSERVER == "apache" ]; then

		echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
		# - DISABLED DUE TO A BUG IN DBCONFIG - echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
		echo "dbconfig-common dbconfig-common/dbconfig-install boolean false" | debconf-set-selections
		fi
				
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
	  
  

  	MeasureTimeDuration $START_TIME
		
	exit 1;
}
