#---------------------------------------------------------------------
# Function: CheckWhiptailAndInstallIfNeed
#    Check if Whiptail is installed and install if it isn't
#---------------------------------------------------------------------

CheckWhiptailAndInstallIfNeed() {

	#Check for whiptail
	if [ -f /bin/whiptail ] || [ -f /usr/bin/whiptail ]; then
     	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Whiptail${NC}: ${green}FOUND${NC}"
		echo "Whiptail Found-> Let's Start" 1 > $PROGRAMS_INSTALL_LOG_FILES
    else
	    echo -n -e "$IDENTATION_LVL_1 ${BBlack}Whiptail${NC}: ${red}NOT FOUND${NC} - start and install it ... "
        apt-get -yqq --force-yes install whiptail > $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
}

