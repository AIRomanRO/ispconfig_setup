#---------------------------------------------------------------------
# Function: InstallWebStats
#    Install and configure web stats
#---------------------------------------------------------------------
InstallWebStats() {
  	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing Web Stats${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 Install Needed Components ... "
  	package_install vlogger geoip-database libclass-dbi-mysql-perl
  	echo -e " [ ${green}DONE${NC} ] "

    if [ $CFG_WEBSTATS == "yes" ]; then
        echo -n -e "$IDENTATION_LVL_1 Install Webalizer... "
      	package_install webalizer
      	echo -e " [ ${green}DONE${NC} ] "

        echo -n -e "$IDENTATION_LVL_1 Install AWStats... "
        package_install awstats
        echo -e " [ ${green}DONE${NC} ] "

        echo -n -e "$IDENTATION_LVL_1 Install Additional packages... "
        package_install geoip-database libclass-dbi-mysql-perl libtimedate-perl
        echo -e " [ ${green}DONE${NC} ] "

      	echo -n -e "$IDENTATION_LVL_1 Enable cron ... "
      	sed -i 's/^/#/' /etc/cron.d/awstats
      	echo -e " [ ${green}DONE${NC} ] "
    fi

	MeasureTimeDuration $START_TIME
}
