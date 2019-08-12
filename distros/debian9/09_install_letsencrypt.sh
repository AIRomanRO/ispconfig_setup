#---------------------------------------------------------------------
# Function: InstallLetsEncrypt Debian 8
#    Install and configure Let's Encrypt
#---------------------------------------------------------------------
InstallLetsEncrypt() {
  	START_TIME=$SECONDS

	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing LetsEncrypt Certbot${NC}\n"

	if [ $CFG_CERTBOT_VERSION == "default" ]; then
		if [ $CFG_WEBSERVER == "apache" ]; then
			echo -n -e "$IDENTATION_LVL_1 Installing certbot for Apache "
			package_install python-certbot-apache
			certbot --apache >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_WEBSERVER == "nginx" ]; then
			echo -n -e "$IDENTATION_LVL_1 Installing certbot for Nginx "
			package_install certbot
			echo -e " [ ${green}DONE${NC} ] "
		fi
	elif [ $CFG_CERTBOT_VERSION == "stretch" ]; then
		if [ $CFG_WEBSERVER == "apache" ]; then
			echo -n -e "$IDENTATION_LVL_1 Installing certbot for Apache "
			package_install python-certbot-apache -t stretch-backports
			certbot --apache >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_WEBSERVER == "nginx" ]; then
			echo -n -e "$IDENTATION_LVL_1 Installing certbot for Nginx "
			package_install certbot -t stretch-backports
			echo -e " [ ${green}DONE${NC} ] "
		fi
  	else
		echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
	fi

  	MeasureTimeDuration $START_TIME
}
