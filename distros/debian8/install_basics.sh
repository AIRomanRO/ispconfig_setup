#---------------------------------------------------------------------
# Function: InstallBasics
#    Install basic packages
#---------------------------------------------------------------------
InstallBasics() {
    echo -n " "
    echo -n "Updating apt and upgrading currently installed packages... "
    apt-get -qq update > /dev/null 2>&1
    apt-get -qqy upgrade > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]"
  
	echo -n "Check and install the required Packages: \n"
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
		echo -n -e " - ${BBlack}APT HTTPS Method${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e " - ${BBlack}APT HTTPS Method${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		apt-get -yqq install apt-transport-https > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
	
    echo -n -e "Installing Aditional Selected Software Packages:\n"

    for PACKAGE_NAME in ${CFG_INSTALL_ADITIONAL_SOFTWARE[@]};
    do
        case $PACKAGE_NAME in
            "htop" )
                #Check for htop
	            if [ -f /bin/htop ] || [ -f /usr/bin/htop ]; then
     	            echo -n -e " - ${BBlack}HTOP${NC}: ${green}FOUND${NC}"
                else
	                echo -n -e " - ${BBlack}HTOP${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
                    apt-get -yqq install htop > /dev/null 2>&1
		            echo -e " [ ${green}DONE${NC} ]"
	            fi
		    ;;
            "nano" )
				#Check for nano
				if [ -f /bin/nano ] || [ -f /usr/bin/nano ]; then
					echo -n -e " - ${BBlack}NANO${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}NANO${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install nano > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "ntp" )
				#Check for ntp - disabled for the moment due to > cap_set_proc() failed to drop root privileges < error
				if [ -f /sbin/ntpd ] || [ -f /usr/sbin/ntpd ]; then
					echo -n -e " - ${BBlack}NTP${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}NTP${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install ntp ntpdate > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;            
            "haveged" )
				#Check for haveged
				if [ -f /sbin/haveged ] || [ -f /usr/sbin/haveged ]; then
					echo -n -e " - ${BBlack}HAVEGED${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}HAVEGED${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install haveged > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "ssh" )
				#Check for ssh
				if [ -f /bin/ssh ] || [ -f /usr/bin/ssh ]; then
					echo -n -e " - ${BBlack}SSH${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}SSH${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install ssh > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "openssh-server" )
				#Check for openssh-server
				if ! dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${red}NOT FOUNDED${NC}"
				fi
				
				echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: Try to install the Jessie Version ... "
				apt-get -yqq install openssh-server -t jessie > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]"				
		    ;;
            "openssh-server-stretch" )
				#Check for openssh-server-stretch
				if ! dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${red}NOT FOUNDED${NC}"
				fi
				
				echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: Try to install the Stretch Version ... "
				apt-get -yqq install openssh-server -t stretch > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]"
		    ;;
			"openssl-stable" )
				#Check for openssl
				if ! dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${red}NOT FOUNDED${NC}"
				fi
				
				echo -n -e " - ${BBlack}OpenSSL${NC}: Try to install the Jessie Version ... "
				apt-get -yqq install openssl -t jessie > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]"
		    ;;
            "openssl-stretch" )
				#Check for openssh-server-stretch
				if ! dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC}"
				else
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${red}NOT FOUNDED${NC}"
				fi
				
				echo -n -e " - ${BBlack}OpenSSL${NC}: Try to install the Stretch Version ... "
				apt-get -yqq install openssl -t stretch > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]"
		    ;; 
        esac
    done
	
	
	if [ $CFG_NGINX_VERSION == "custom" ]; then
		echo -n -e "Check and install the needed Packages for build the NGINX with OpenSSL 1.1 \n"
		
		#Check for DPKG DEV
		if ! dpkg --list 2>&1 | grep -qw dpkg-dev; then
			echo -n -e "   - ${BBlack}DPKG DEV{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e "   - ${BBlack}DPKG DEV${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install dpkg-dev > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
		#Check for Debian Keyring
		if ! dpkg --list 2>&1 | grep -qw debian-keyring; then
			echo -n -e "   - ${BBlack}Debian Keyring{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e "   - ${BBlack}Debian Keyring${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install debian-keyring > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
		#Check for Dev Scripts
		if ! dpkg --list 2>&1 | grep -qw debian-keyring; then
			echo -n -e "   - ${BBlack}Dev Scripts{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e "   - ${BBlack}Dev Scripts${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install devscripts > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
	    #Check for Quilt
		if ! dpkg --list 2>&1 | grep -qw quilt; then
		    echo -n -e "   - ${BBlack}Quilt{NC}: ${green}FOUND${NC}\n"
	    else
		    echo -n -e "   - ${BBlack}Quilt${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		    apt-get -yqq install quilt > /dev/null 2>&1
		    echo -e " [ ${green}DONE${NC} ]\n"
	    fi
	fi

    echo -n "Reconfigure dash... "	  
    echo "dash dash/sh boolean false" | debconf-set-selections
    dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1 
    echo -e "[ ${green}DONE${NC} ]\n"

}
