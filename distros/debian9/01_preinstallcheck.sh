#---------------------------------------------------------------------
# Function: PreInstallCheck
#    Do some pre-install checks
#---------------------------------------------------------------------
PreInstallCheck() {
	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Check the stuffs before install ${NC} \n"
	
	echo -n -e "$IDENTATION_LVL_1 Check if current user is root"
    # Check if user is root
    if [ $(id -u) != "0" ]; then
        echo -e " [ ${red}Error${NC}: You must be root to run this script, please use the root user to install the software ]"
        exit 1
    fi
	echo -e " [ ${green}OK${NC} ]"

	
    # Check connectivity
    echo -n "$IDENTATION_LVL_1 Check if we can reach the ISPConfig servers ... "	
    ping -q -c 3 www.ispconfig.org >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    if [ ! "$?" -eq 0 ]; then
        echo -e "[ ${red}ERROR ${NC} : Couldn't reach www.ispconfig.org, please check your internet connection ${NC} ]"
        exit 1;
	else
	    echo -e " [ ${green}OK${NC} ]"
    fi


	echo -n "$IDENTATION_LVL_1 Check if a previous version of ISPConfig is installed ... "	
    # Check for already installed ispconfig version
    if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
        echo -e "[ ${red}ERROR ${NC} : ISPConfig is already installed, can't go on${NC} ]"
	    exit 1
	else
		echo -e " [ ${green}OK${NC} ]"
    fi
  
	#echo -n -e "Check for pre-required packages:\n"	
	#echo -n -e "Pre Install Check [ ${green}Completed${NC} ]\n"
	
	MeasureTimeDuration $START_TIME
}
