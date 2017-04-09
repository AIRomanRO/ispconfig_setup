#---------------------------------------------------------------------
# Function: AskQuestions Debian 8
#    Ask for all needed user input
#---------------------------------------------------------------------
AskQuestions() {
	START_TIME=$SECONDS
	CFG_SETUP_WEB=yes #Needed for Multiserver setup compatibility
	CFG_SETUP_MAIL=yes #Needed for Multiserver setup compatibility
	CFG_SETUP_NS=yes #Needed for Multiserver setup compatibility
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Gathering informations about softwares and versions:${NC} "
	echo
	
	while [ "x$CFG_SQLSERVER" == "x" ]
    do
		CFG_SQLSERVER=$(whiptail --title "Install SQL Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		    "Select SQL Server type" 10 60 3 \
		    "MySQL"   "MySQL (default)" ON \
		    "MariaDB" "MariaDB" OFF \
		    "None"    "(already installed)" OFF 3>&1 1>&2 2>&3)
    done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}SQL Server${NC}: ${green}$CFG_SQLSERVER${NC} "
	echo
	
	if [ $CFG_SQLSERVER == "MySQL" ]; then
		while [ "x$CFG_MYSQL_VERSION" == "x" ]
        do
			CFG_MYSQL_VERSION=$(whiptail --title "MySQL Version" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			    "Select MySQL Version" 10 60 3 \
			    "default"  "OS Current Version" ON \
			    "5.6"      "MySQL-5.6" OFF \
			    "5.7"      "MySQL-5.7" OFF 3>&1 1>&2 2>&3)
        done
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green}$CFG_MYSQL_VERSION${NC} "
	    echo
	fi

	if [ $CFG_SQLSERVER == "MySQL" ] || [ $CFG_SQLSERVER == "MariaDB" ]; then
	    while [ "x$CFG_MYSQL_ROOT_PWD_AUTO" == "x" ]
        do
            CFG_MYSQL_ROOT_PWD_AUTO=$(whiptail --title "MySQL Root Password" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		        "Auto Generate ROOT PASSWORD?" 10 57 2 \
		        "false" "NO, i have IT OR i want to choose one" OFF \
		        "true"  "YES, autogenerate it" ON 3>&1 1>&2 2>&3)
        done
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}Generate PASSWORD${NC}: ${green}$CFG_MYSQL_ROOT_PWD_AUTO${NC} "
	    echo
	else
		CFG_MYSQL_ROOT_PWD_AUTO=false
	fi

	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Retrieve PASSWORD${NC}: "
	if [ $CFG_MYSQL_ROOT_PWD_AUTO == false ]; then
	    #We should receive a password
	    while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
	    do
	        CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL Root Password" --backtitle "$WT_BACKTITLE" --nocancel --inputbox \
				"Please specify a root password" 10 60 3>&1 1>&2 2>&3)
	    done
	else
		#We generate a random 32 Chars Length
		CFG_MYSQL_ROOT_PWD=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-32})
	fi
	echo -e " [ ${green}DONE${NC} ] "
		
    while [ "x$CFG_WEBSERVER" == "x" ]
	do
		CFG_WEBSERVER=$(whiptail --title "Install Web Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select which web server you want to install" 15 60 3 \
		"apache" "Apache" OFF \
		"nginx"  "Nginx (default)" ON \
		"none"   "No Install" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Web Server${NC}: ${green}$CFG_WEBSERVER${NC} "
	echo
	
	if [ $CFG_WEBSERVER == "nginx" ]; then
	    while [ "x$CFG_NGINX_VERSION" == "x" ]
		do
	        CFG_NGINX_VERSION=$(whiptail --title "Nginx Web Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			"Select which Nginx Version you want to install" 15 65 5 \
			"n-os-default" "OS Default" ON \
			"n-nginx"      "NGINX Official - nginx.org" OFF \
			"n-dotdeb"     "DotDeb.org - with full HTTP2" OFF \
			"n-stretch"    "Debian Stretch - with HTTP2" OFF \
            "n-custom"     "With OpenSSL 1.1 and ChaCha20-Poly1305" OFF 3>&1 1>&2 2>&3)
	    done
		
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}Nginx Version${NC}: ${green}" $CFG_NGINX_VERSION "${NC} "
	    echo
	fi
	
	while [ "x$CFG_PHP_VERSION" == "x" ]
	do
		CFG_PHP_VERSION=$(whiptail --title "Choose PHP Version(s)" --backtitle "$WT_BACKTITLE" --nocancel --separate-output --checklist \
		    "Choose PHP Version do you want to install" 20 75 5 \
            "php5.6"    "Latest Available from 5.6" ON \
            "php7.0"    "Latest Available from 7.0" ON \
            "php7.1"    "Latest Available from 7.1" ON \
			"none"      "No install" OFF 3>&1 1>&2 2>&3)
	done 
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}PHP Version(s)${NC}: ${green}" $CFG_PHP_VERSION "${NC} "
	echo

	while [ "x$CFG_CERTBOT_VERSION" == "x" ]
	do
		CFG_CERTBOT_VERSION=$(whiptail --title "Install CertBot" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select CertBot Version" 10 60 3 \
		"none"    "No installation" OFF \
		"default" "Yes, from jessie backports" ON \
		"stretch" "Yes, from stretch backports" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}CertBot Version${NC}: ${green}$CFG_CERTBOT_VERSION${NC} "
	echo
		
	while [ "x$CFG_HHVM" == "x" ]
    do
        CFG_HHVM=$(whiptail --title "HHVM" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Do you want to install HHVM?" 10 60 2 \
		"no" "(default)" ON \
		"yes" "" OFF 3>&1 1>&2 2>&3)
    done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install HHVM${NC}: ${green}$CFG_HHVM${NC} "
	echo
	
	while [ "x$CFG_XCACHE" == "x" ]
	do
	    CFG_XCACHE=$(whiptail --title "Install XCache" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"You want to install XCache during install? ATTENTION: If XCache is installed, Ioncube Loaders will not work !!" 10 50 2 \
		"yes" "" OFF \
		"no"  "(default)" ON 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install XCACHE${NC}: ${green}$CFG_XCACHE${NC} "
	echo
		
	while [ "x$CFG_PHPMYADMIN" == "x" ]
	do
		CFG_PHPMYADMIN=$(whiptail --title "Install phpMyAdmin" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"You want to install phpMyAdmin during install?" 10 60 2 \
		"yes" "(default)" ON \
		"no" "" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install PhpMyAdmin${NC}: ${green}$CFG_PHPMYADMIN${NC} "
	echo
	  
	if [ $CFG_PHPMYADMIN == "yes" ]; then
        while [ "x$CFG_PHPMYADMIN_VERSION" == "x" ]
	    do
		    CFG_PHPMYADMIN_VERSION=$(whiptail --title "phpMyAdmin Version" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			"What version of phpMyAdmin do you want to install?" 15 75 4 \
			"default"         "Current OS Version" ON \
			"jessie"          "from jessie backports - possible newer" OFF \
			"stretch"         "from stretch version - newer" OFF \
			"latest-stable"   "from phpMyAdmin.net" OFF 3>&1 1>&2 2>&3)
	    done
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green}$CFG_PHPMYADMIN_VERSION${NC} "
	    echo
	fi
	  
	while [ "x$CFG_MTA" == "x" ]
	do
		CFG_MTA=$(whiptail --title "Mail Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select mailserver type" 10 60 2 \
		"dovecot" "(default)" ON \
		"courier" "" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Mail Server${NC}: ${green}$CFG_MTA${NC} "
	echo
	
	while [ "x$CFG_WEBMAIL" == "x" ]
	do
		CFG_WEBMAIL=$(whiptail --title "Webmail client" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select which Web Mail client you want" 10 60 3 \
		"roundcube" "(default)" ON \
		"squirrelmail" "" OFF \
		"none" "No Web Mail Client" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}WebMail client${NC}: ${green}$CFG_WEBMAIL${NC} "
	echo
	
	if ( whiptail --title "Update Freshclam DB" --backtitle "$WT_BACKTITLE" --yesno "You want to update Antivirus Database during install?" 10 60) then
		CFG_AVUPDATE=yes
	else
		CFG_AVUPDATE=no
	fi
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Update Antivirus Database${NC}: ${green}$CFG_AVUPDATE${NC} "
	echo
	
	if (whiptail --title "Quota" --backtitle "$WT_BACKTITLE" --yesno "Setup user quota?" 10 60) then
		CFG_QUOTA=yes
	else
		CFG_QUOTA=no
	fi
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Setup Quota${NC}: ${green}$CFG_QUOTA${NC} "
	echo
	
	if (whiptail --title "Jailkit" --backtitle "$WT_BACKTITLE" --yesno "Would you like to install Jailkit?" 10 60) then
		CFG_JKIT=yes
	else
		CFG_JKIT=no
	fi
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install Jailkit${NC}: ${green}$CFG_JKIT${NC} "
	echo
	
	while [ "x$CFG_INSTALL_ADITIONAL_SOFTWARE" == "x" ]
	do
		CFG_INSTALL_ADITIONAL_SOFTWARE=$(whiptail --title "Install Aditional Software" --backtitle "$WT_BACKTITLE" --nocancel --separate-output --checklist \
		    "Choose what programs do you want to install" 25 105 10 \
            "htop"                     "HTOP - interactive process viewer" ON \
            "nano"                     "NANO - text editor" ON \
            "haveged"                  "HAVEGED - A simple entropy daemon" ON \
            "ssh"                      "SSH - Secure Shell" ON \
			"openssl-stable"           "OpenSSL - toolkit with full-strength cryptography" OFF \
            "openssl-stretch"          "OpenSSL - version from stretch branch - usually newer" ON \
            "openssh-server"           "OpenSSH Server - collection of tools for control and transfer of data" OFF \
			"openssh-server-stretch"   "OpenSSH Server - version from stretch branch - usually newer" ON \
			"none"                     "Not install any thing from the above list" OFF \
	    3>&1 1>&2 2>&3)
	done 
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install Aditional Software(s)${NC}: ${green}"$CFG_INSTALL_ADITIONAL_SOFTWARE"${NC} "
	echo
	
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}ISPConfig Configuration: ${NC}"
	echo
	while [ "x$CFG_ISPC" == "x" ]
	do
      	CFG_ISPC=$(whiptail --title "ISPConfig Setup" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Would you like full unattended setup of expert mode for ISPConfig?" 10 60 2 \
		"standard" "Yes (default)" ON \
		"expert"   "No, i want to configure" OFF 3>&1 1>&2 2>&3)
    done
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Install Mode${NC}: ${green}" $CFG_ISPC "${NC} "
	echo
	
	# while [ "x$CFG_ISPONCFIG_PORT" == "x" ]
	# do
		CFG_ISPONCFIG_PORT=$(whiptail --title "ISPConfig" --backtitle "$WT_BACKTITLE" --inputbox \
		"Please specify a ISPConfig Port (leave empty for use 8081 port)" --nocancel 10 60 3>&1 1>&2 2>&3)
	# done
	
	if [[ -z $CFG_ISPONCFIG_PORT ]]; then
		CFG_ISPONCFIG_PORT=8081
	fi
	
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Port${NC}: ${green}" $CFG_ISPONCFIG_PORT "${NC} "
	echo	
	
	while [ "x$CFG_ISPCONFIG_DB_PASS_AUTO" == "x" ]
	do
		CFG_ISPCONFIG_DB_PASS_AUTO=$(whiptail --title "Auto Generate ISPConfig DB pass for Advanced" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			"Auto Generate ISPConfig DB pass for Advanced?" 10 57 2 \
			"false" "NO, i have IT OR i want to choose one" OFF \
			"true"  "YES, autogenerate it" ON 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Auto Generate DB pass for advanced${NC}: ${green}$CFG_ISPCONFIG_DB_PASS_AUTO${NC} "
	echo	

	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Retrieve DB pass for advanced${NC}: "
	if [ $CFG_ISPCONFIG_DB_PASS_AUTO == false ]; then
	    #We should receive a password
	    while [ "x$CFG_ISPCONFIG_DB_PASS" == "x" ]
	    do
			CFG_ISPCONFIG_DB_PASS=$(whiptail --title "ISPConfig DB pass for advanced" --backtitle "$WT_BACKTITLE" --nocancel --inputbox \
				"Please specify a password for ISPConfig db used on advanced" 10 60 3>&1 1>&2 2>&3)
	    done
	else
		#We generate a random 32 Chars Length
		CFG_ISPCONFIG_DB_PASS=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-32})
	fi	
	echo -e " [ ${green}DONE${NC} ] "

	echo -n -e "$IDENTATION_LVL_1 ${BBlack}SSL Configuration:${NC} "
	echo
	
	SSL_COUNTRY=$(whiptail --title "SSL Country Code" --backtitle "$WT_BACKTITLE" \
	                --inputbox "SSL Configuration - Country Code (2 letter code - ex. EN)" --nocancel 10 60 3>&1 1>&2 2>&3)
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Country${NC}: ${green}" $SSL_COUNTRY "${NC} "
	echo
	
    SSL_STATE=$(whiptail --title "SSL State or Province Name" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - STATE or Province Name (full name - ex. Romania)" --nocancel 10 60 3>&1 1>&2 2>&3)
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}State${NC}: ${green}" $SSL_STATE "${NC} "
	echo
	
    SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Locality (ex. Craiova)" --nocancel 10 60 3>&1 1>&2 2>&3)
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Locality${NC}: ${green}" $SSL_LOCALITY "${NC} "
	echo
	
    SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 60 3>&1 1>&2 2>&3)
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Organization${NC}: ${green}" $SSL_ORGANIZATION "${NC} "
	echo
	
    SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Organization Unit (ex. IT)" --nocancel 10 60 3>&1 1>&2 2>&3)
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Unit${NC}: ${green}" $SSL_ORGUNIT "${NC} "
	echo

	MeasureTimeDuration $START_TIME
}
