#---------------------------------------------------------------------
# Function: PreInstallCheck
#    Do some pre-install checks
#---------------------------------------------------------------------
PreInstallCheck() {
    # Check if user is root
    if [ $(id -u) != "0" ]; then
        echo -n "Error: You must be root to run this script, please use the root user to install the software."
        exit 1
    fi


    # Check connectivity
    echo -n "Checking internet connection... "
    ping -q -c 3 www.ispconfig.org > /dev/null 2>&1

    if [ ! "$?" -eq 0 ]; then
        echo -e "[ ${red}ERROR ]: Couldn't reach www.ispconfig.org, please check your internet connection${NC}"
        exit 1;
	else
	    echo -e " [ ${green}OK${NC} ]"
    fi


    # Check for already installed ispconfig version
    if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
        echo "ISPConfig is already installed, can't go on."
	    exit 1
    fi
  
	echo -n -e "Check for pre-required packages:\n"

	
	echo -n -e "Pre Install Check [ ${green}Completed${NC} ]\n"
}


