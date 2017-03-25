#---------------------------------------------------------------------
# Function: InstallBasics
#    Install basic packages
#---------------------------------------------------------------------
InstallBasics() {
  echo -n "Updating apt and upgrading currently installed packages... "
  apt-get -qq update > /dev/null 2>&1
  apt-get -qqy upgrade > /dev/null 2>&1
  echo -e "[${green}DONE${NC}]\n"
  
    echo -n -e "Installing Aditional Selected Software Packages:\n"

    for PACKAGE_NAME in ${$CFG_INSTALL_ADITIONAL_SOFTWARE[@]};
    do
        case PACKAGE_NAME in
            "htop" )
                #Check for htop
	            if [ -f /bin/htop ] || [ -f /usr/bin/htop ]; then
     	            echo -n -e " - ${BBlack}HTOP${NC}: ${green}FOUND${NC}\n"
                else
	                echo -n -e " - ${BBlack}HTOP${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
                    apt-get -yqq install htop > /dev/null 2>&1
		            echo -e " [ ${green}DONE${NC} ]\n"
	            fi
		    ;;
            "nano" )
				#Check for nano
				if [ -f /bin/nano ] || [ -f /usr/bin/nano ]; then
					echo -n -e " - ${BBlack}NANO${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}NANO${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install nano > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]\n"
				fi
		    ;;
            "ntp" )
				#Check for ntp - disabled for the moment due to > cap_set_proc() failed to drop root privileges < error
				if [ -f /sbin/ntpd ] || [ -f /usr/sbin/ntpd ]; then
					echo -n -e " - ${BBlack}NTP${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}NTP${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install ntp ntpdate > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]\n"
				fi
		    ;;            
            "haveged" )
				#Check for haveged
				if [ -f /sbin/haveged ] || [ -f /usr/sbin/haveged ]; then
					echo -n -e " - ${BBlack}HAVEGED${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}HAVEGED${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install haveged > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]\n"
				fi
		    ;;
            "ssh" )
				#Check for ssh
				if [ -f /bin/ssh ] || [ -f /usr/bin/ssh ]; then
					echo -n -e " - ${BBlack}SSH${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}SSH${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
					apt-get -yqq install ssh > /dev/null 2>&1
					echo -e " [ ${green}DONE${NC} ]\n"
				fi
		    ;;
            "openssh-server" )
				#Check for openssh-server
				if ! dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${red}NOT FOUNDED${NC}\n"
				fi
				
				echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: Try to install the Jessie Version ... "
				apt-get -yqq install openssh-server -t jessie > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]\n"				
		    ;;
            "openssh-server-stretch" )
				#Check for openssh-server-stretch
				if ! dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: ${red}NOT FOUNDED${NC}\n"					
				fi
				
				echo -n -e " - ${BBlack}OPENSSH-SERVER${NC}: Try to install the Stretch Version ... "
				apt-get -yqq install openssh-server -t stretch > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]\n"
		    ;;
			"openssl-stable" )
				#Check for openssl
				if ! dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${red}NOT FOUNDED${NC}\n"
				fi
				
				echo -n -e " - ${BBlack}OpenSSL${NC}: Try to install the Jessie Version ... "
				apt-get -yqq install openssl -t jessie > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]\n"				
		    ;;
            "openssl-stretch" )
				#Check for openssh-server-stretch
				if ! dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC}\n"
				else
					echo -n -e " - ${BBlack}OpenSSL${NC}: ${red}NOT FOUNDED${NC}\n"					
				fi
				
				echo -n -e " - ${BBlack}OpenSSL${NC}: Try to install the Stretch Version ... "
				apt-get -yqq install openssl -t stretch > /dev/null 2>&1
				echo -e " [ ${green}DONE${NC} ]\n"
		    ;; 
        esac
    done
	
	
	if [ $CFG_NGINX_VERSION == "custom" ]; then
		echo -n -e "Check and install the needed Packages for build the NGINX with OpenSSL 1.1"
		
		#Check for DPKG DEV
		if ! dpkg --list 2>&1 | grep -qw dpkg-dev; then
			echo -n -e " - ${BBlack}DPKG DEV{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e " - ${BBlack}DPKG DEV${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install dpkg-dev > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
		#Check for Debian Keyring
		if ! dpkg --list 2>&1 | grep -qw debian-keyring; then
			echo -n -e " - ${BBlack}Debian Keyring{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e " - ${BBlack}Debian Keyring${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install debian-keyring > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
		#Check for Dev Scripts
		if ! dpkg --list 2>&1 | grep -qw debian-keyring; then
			echo -n -e " - ${BBlack}Dev Scripts{NC}: ${green}FOUND${NC}\n"
		else
			echo -n -e " - ${BBlack}Dev Scripts${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
			apt-get -yqq install devscripts > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ]\n"
		fi
	
	    #Check for Quilt
		if ! dpkg --list 2>&1 | grep -qw quilt; then
		    echo -n -e " - ${BBlack}Quilt{NC}: ${green}FOUND${NC}\n"
	    else
		    echo -n -e " - ${BBlack}Quilt${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
		    apt-get -yqq install quilt > /dev/null 2>&1
		    echo -e " [ ${green}DONE${NC} ]\n"
	    fi
		
		
        echo "##### Prevent NGINX from being updated because it is custom builded #####
Package: nginx
Pin: version
Pin-Priority: 1001
##### Prevent NGINX from being updated because it is custom builded #####" >> /etc/apt/preferences

	fi

    echo -n "Reconfigure dash... "	  
    echo "dash dash/sh boolean false" | debconf-set-selections
    dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1 
    echo -e " [ ${green}DONE${NC} ]\n"
  
  exit 1
}
