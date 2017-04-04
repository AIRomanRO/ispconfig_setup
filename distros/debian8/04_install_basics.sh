#---------------------------------------------------------------------
# Function: InstallBasics
#    Install basic packages
#---------------------------------------------------------------------
InstallBasics() {
	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Start Install Basic Packages: ${NC} \n"
	echo -n -e "$IDENTATION_LVL_1 Check and install the required Packages: \n"
	
	#Check for debconf-utils
	if [ -f /bin/debconf ] || [ -f /usr/bin/debconf ]; then
     	echo -n -e "$IDENTATION_LVL_2 ${BBlack}debconf-utils${NC}: ${green}FOUND${NC}\n"
    else
	    echo -n -e "$IDENTATION_LVL_2 ${BBlack}debconf-utils${NC}: ${red}NOT FOUND${NC} - try to install it ... "
        apt-get -yqq install debconf-utils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
	
    touch /etc/inetd.conf


	#Check for binutils
	if [ -f /bin/ld ] || [ -f /usr/bin/ld ]; then
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}BINUTILS${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}BINUTILS${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		apt-get -yqq install binutils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi


	#Check for sudo
	if [ -f /bin/sudo ] || [ -f /usr/bin/sudo ]; then
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}SUDO${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}SUDO${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		apt-get -yqq install sudo >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi


	#Check for lsb-release
	if [ -f /bin/lsb_release ] || [ -f /usr/bin/lsb_release ]; then
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}LSB-RELEASE${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}LSB-RELEASE${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		apt-get -yqq install lsb-release >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]\n"
	fi
  
  
	#Check for apt-transport-https
	if [ -f /usr/lib/apt/methods/https ]; then
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}APT HTTPS Method${NC}: ${green}FOUND${NC}\n"
	else
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}APT HTTPS Method${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		apt-get -yqq install apt-transport-https >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
	
	echo -n -e "$IDENTATION_LVL_1 Updating apt and upgrading currently installed packages... "
    apt-get -qq update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    apt-get -qqy upgrade >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    echo -e "[${green}DONE${NC}]"
  
  
    echo -n -e "$IDENTATION_LVL_1 Installing Aditional Selected Software Packages:\n"
    for PACKAGE_NAME in ${CFG_INSTALL_ADITIONAL_SOFTWARE[@]};
    do
        case $PACKAGE_NAME in
            "htop" )
                #Check for htop
	            if [ -f /bin/htop ] || [ -f /usr/bin/htop ]; then
     	            echo -n -e "$IDENTATION_LVL_2 ${BBlack}HTOP${NC}: ${green}FOUND${NC} \n"
                else
	                echo -n -e "$IDENTATION_LVL_2 ${BBlack}HTOP${NC}: ${red}NOT FOUND${NC} - try to install it ... "
                    apt-get -yqq install htop >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		            echo -e " [ ${green}DONE${NC} ]"
	            fi
		    ;;
            "nano" )
				#Check for nano
				if [ -f /bin/nano ] || [ -f /usr/bin/nano ]; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}NANO${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}NANO${NC}: ${red}NOT FOUND${NC} - try to install it ... "
					apt-get -yqq install nano >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "ntp" )
				#Check for ntp - disabled for the moment due to > cap_set_proc() failed to drop root privileges < error
				if [ -f /sbin/ntpd ] || [ -f /usr/sbin/ntpd ]; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}NTP${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}NTP${NC}: ${red}NOT FOUND${NC} - try to install it ... "
					apt-get -yqq install ntp ntpdate >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;            
            "haveged" )
				#Check for haveged
				if [ -f /sbin/haveged ] || [ -f /usr/sbin/haveged ]; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}HAVEGED${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}HAVEGED${NC}: ${red}NOT FOUND${NC} - try to install it ... "
					apt-get -yqq install haveged >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "ssh" )
				#Check for ssh
				if [ -f /bin/ssh ] || [ -f /usr/bin/ssh ]; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}SSH${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}SSH${NC}: ${red}NOT FOUND${NC} - try to install it ... "
					apt-get -o Dpkg::Options::="--force-confnew" -q -y install ssh >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
					echo -e " [ ${green}DONE${NC} ]"
				fi
		    ;;
            "openssh-server" )
				#Check for openssh-server
				if dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC}  \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: ${red} NOT FOUND ${NC} \n"
				fi
				
				echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: Try to install the Jessie Version ... "
				apt-get -o Dpkg::Options::="--force-confnew"  -q -y install openssh-server -t jessie >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ] "				
		    ;;
            "openssh-server-stretch" )
				#Check for openssh-server-stretch
				if dpkg --list 2>&1 | grep -qw openssh-server; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: ${red}NOT FOUND${NC} \n"
				fi
				
				echo -n -e "$IDENTATION_LVL_2 ${BBlack}OPENSSH-SERVER${NC}: Try to install the Stretch Version ... "
				
				# export DEBIAN_FRONTEND=noninteractive			
			    # echo "ucf     ucf/changeprompt        select  install_new" | debconf-set-selections    #keep_current				
				# apt-get -o Dpkg::Options::="--force-confnew"  -q -y install openssh-server -t stretch >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				# unset DEBIAN_FRONTEND
				
				# Disabled for the moment because it install a clean version, so analyze and see if replace or not the original conf and see how can improve the new one
				#UCF_FORCE_CONFFNEW=yes LANG=C DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew"  -q -y install openssh-server -t stretch >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${red}SKIPPED / DISABLED ${NC} - ${green} Disabled by Author | Reason: need more research for proper configuration ${NC} ]"
		    ;;
			"openssl-stable" )
				#Check for openssl
				if dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: ${red}NOT FOUND${NC} \n"
				fi
				
				echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: Try to install the Jessie Version ... "
				apt-get -o Dpkg::Options::="--force-confnew"  -q -y install openssl -t jessie >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ]"
		    ;;
            "openssl-stretch" )
				#Check for openssh-server-stretch
				if dpkg --list 2>&1 | grep -qw openssl; then
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: ${green}Already Installed${NC} \n"
				else
					echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: ${red}NOT FOUND${NC} \n"
				fi
				
				echo -n -e "$IDENTATION_LVL_2 ${BBlack}OpenSSL${NC}: Try to install the Stretch Version ... "
				apt-get -o Dpkg::Options::="--force-confnew"  -q -y install openssl -t stretch >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
				echo -e " [ ${green}DONE${NC} ]"
		    ;; 
        esac
    done
	
	
	if [ $CFG_NGINX_VERSION == "custom" ]; then
		echo -n -e "$IDENTATION_LVL_1 Check and install the needed Packages for build the NGINX with OpenSSL 1.1 \n"
		
		#Check for DPKG DEV
		if dpkg --list 2>&1 | grep -qw dpkg-dev; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}DPKG DEV${NC}: ${green}FOUND${NC} \n"
		else
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}DPKG DEV${NC}: ${red}NOT FOUND${NC} - try to install it ... "
			apt-get -yqq install dpkg-dev >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ]"
		fi
	
		#Check for Debian Keyring
		if dpkg --list 2>&1 | grep -qw debian-keyring; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Debian Keyring${NC}: ${green}FOUND${NC} \n"
		else
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Debian Keyring${NC}: ${red}NOT FOUND${NC} - try to install it ... "
			apt-get -yqq install debian-keyring >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ]"
		fi
	
		#Check for Dev Scripts
		if dpkg --list 2>&1 | grep -qw devscripts; then
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Dev Scripts${NC}: ${green}FOUND${NC} \n"
		else
			echo -n -e "$IDENTATION_LVL_2 ${BBlack}Dev Scripts${NC}: ${red}NOT FOUND${NC} - try to install it ... "
			apt-get -yqq install devscripts >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ]"
		fi
	
	    #Check for Quilt
		if dpkg --list 2>&1 | grep -qw quilt; then
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Quilt${NC}: ${green}FOUND${NC} \n"
	    else
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Quilt${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		    apt-get -yqq install quilt >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    echo -e " [ ${green}DONE${NC} ]"
	    fi
		
		#Check for Lib PCRE3 Dev
		if dpkg --list 2>&1 | grep -qw libpcre3-dev; then
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Lib PCRE3 Dev${NC}: ${green}FOUND${NC} \n"
	    else
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Lib PCRE3 Dev${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		    apt-get -yqq --force-yes install libpcre3-dev >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    echo -e " [ ${green}DONE${NC} ]"
	    fi
		
		#Check for Lib Zlib 1g Dev
		if dpkg --list 2>&1 | grep -qw zlib1g-dev; then
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Lib Zlib 1g Dev${NC}: ${green}FOUND${NC} \n"
	    else
		    echo -n -e "$IDENTATION_LVL_2 ${BBlack}Lib Zlib 1g Dev${NC}: ${red}NOT FOUND${NC} - try to install it ... "
		    apt-get -yqq --force-yes install zlib1g-dev >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    echo -e " [ ${green}DONE${NC} ]"
	    fi
	fi

    echo -n "$IDENTATION_LVL_1 Reconfigure dash... "	  
    echo "dash dash/sh boolean false" | debconf-set-selections
    dpkg-reconfigure -f noninteractive dash >> $PROGRAMS_INSTALL_LOG_FILES 2>&1 
    echo -e "[ ${green}DONE${NC} ]"
	
	MeasureTimeDuration $START_TIME

}
