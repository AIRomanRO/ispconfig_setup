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


	#Check for whiptail
	if [ -f /bin/whiptail ] || [ -f /usr/bin/whiptail ]; then
     	echo -n -e " - ${BBlack}Whiptail${NC}: ${green}FOUND${NC}\n"
    else
	    echo -n -e " - ${BBlack}Whiptail${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install whiptail > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi


	#Check for debconf-utils
	if [ -f /bin/debconf ] || [ -f /usr/bin/debconf ]; then
     	echo -n -e " - ${BBlack}debconf-utils${NC}: ${green}FOUND${NC}\n"
    else
	    echo -n -e " - ${BBlack}debconf-utils${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install debconf-utils > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
	
    touch /etc/inetd.conf


	#Check for binutils
	if [ -f /bin/ld ] || [ -f /usr/bin/ld ]; then
		echo -n -e " - ${BBlack}BINUTILS${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e " - ${BBlack}BINUTILS${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		apt-get -yqq install binutils > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi


	#Check for sudo
	if [ -f /bin/sudo ] || [ -f /usr/bin/sudo ]; then
		echo -n -e " - ${BBlack}SUDO${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e " - ${BBlack}SUDO${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		apt-get -yqq install sudo > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi


	#Check for lsb-release
	if [ -f /bin/lsb_release ] || [ -f /usr/bin/lsb_release ]; then
		echo -n -e " - ${BBlack}LSB-RELEASE${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e " - ${BBlack}LSB-RELEASE${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		apt-get -yqq install lsb-release > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
  
  
	#Check for apt-transport-https
	if [ -f /usr/lib/apt/methods/https ]; then
		echo -n -e " - ${BBlack}APT HTTPS Method{NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e " - ${BBlack}APT HTTPS Method${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		apt-get -yqq install apt-transport-https > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
	
	echo -n -e "Pre Install Check - [ ${green}Completed${NC} ]\n"
}


