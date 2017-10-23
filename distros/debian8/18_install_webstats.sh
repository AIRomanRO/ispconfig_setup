#---------------------------------------------------------------------
# Function: InstallWebStats
#    Install and configure web stats
#---------------------------------------------------------------------
InstallWebStats() {
  	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing Web Stats${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 Install Needed Components ... "
  	apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  	echo -e " [ ${green}DONE${NC} ] "

  	echo -n -e "$IDENTATION_LVL_1 Enable cron ... "
  	sed -i 's/^/#/' /etc/cron.d/awstats
  	echo -e " [ ${green}DONE${NC} ] "

	MeasureTimeDuration $START_TIME
}

