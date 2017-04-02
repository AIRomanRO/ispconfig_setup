#---------------------------------------------------------------------
# Function: CheckWhiptailAndInstallIfNeed
#    Check if Whiptail is installed and install if it isn't
#---------------------------------------------------------------------

CheckWhiptailAndInstallIfNeed() {

	#Check for whiptail
	if [ -f /bin/whiptail ] || [ -f /usr/bin/whiptail ]; then
     	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Whiptail${NC}: ${green}FOUND${NC}\n"
    else
	    echo -n -e "$IDENTATION_LVL_1 ${BBlack}Whiptail${NC}: ${red}NOT FOUND${NC} - start and install it ... "
        apt-get -yqq install whiptail > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
	
}

