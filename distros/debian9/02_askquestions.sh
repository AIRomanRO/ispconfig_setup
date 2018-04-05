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
			    "Select MySQL Version" 10 60 4 \
			    "default"  "OS Current Version" ON \
			    "5.6"      "MySQL-5.6" OFF \
			    "5.7"      "MySQL-5.7" OFF \
			    "8.0"      "MySQL-8.0" OFF 3>&1 1>&2 2>&3)
        done
		echo -n -e "$IDENTATION_LVL_2 ${BBlack}Version${NC}: ${green}$CFG_MYSQL_VERSION${NC} "
	    echo
	fi


	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Retrieve MySQL Root PASSWORD${NC}: "
	CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL Root Password" --backtitle "$WT_BACKTITLE" --inputbox \
	"Please specify the MySQL Root Password (leave empty for autogenerate)" --nocancel 10 60 3>&1 1>&2 2>&3)

	if [[ -z $CFG_MYSQL_ROOT_PWD ]]; then
		CFG_MYSQL_ROOT_PWD_AUTO=true
		#We generate a random 32 Chars Length
		CFG_MYSQL_ROOT_PWD=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#^*_=-' | head -c${1:-16})
	else
		CFG_MYSQL_ROOT_PWD_AUTO=false
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
    else
    	CFG_NGINX_VERSION='none'
	fi
	
	while [ "x$CFG_PHP_VERSION" == "x" ]
	do
		CFG_PHP_VERSION=$(whiptail --title "Choose PHP Version(s)" --backtitle "$WT_BACKTITLE" --nocancel --separate-output --checklist \
		    "Choose PHP Version do you want to install" 20 75 5 \
            "php7.0"    "Latest Available from 7.0" ON \
            "php7.1"    "Latest Available from 7.1" OFF \
            "php7.2"    "Latest Available from 7.2" OFF \
			"none"      "No install" OFF 3>&1 1>&2 2>&3)
	done 
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}PHP Version(s)${NC}: ${green}" $CFG_PHP_VERSION "${NC} "
	echo

	while [ "x$CFG_CERTBOT_VERSION" == "x" ]
	do
		CFG_CERTBOT_VERSION=$(whiptail --title "Install LetsEncrypt CertBot" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select CertBot Version" 10 60 3 \
		"none"    "No installation" OFF \
		"default" "Yes, from jessie backports" ON \
		"stretch" "Yes, from stretch backports" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}LetsEncrypt CertBot Version${NC}: ${green}$CFG_CERTBOT_VERSION${NC} "
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
    else
    	CFG_PHPMYADMIN_VERSION='none'
	fi
	  
  	while [ "x$CFG_FTP" == "x" ]
	do
		CFG_FTP=$(whiptail --title "FTP Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Install and configure FTP SERVER ?" 10 60 4 \
		"onlyFTP" "Yes, only with FTP" OFF \
		"onlyTLS" "Yes, only with TLS" ON \
		"FTPandTLS" "Yes, with FTP and TLS" OFF \
		"none" "No, don't install it" OFF 3>&1 1>&2 2>&3)
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}Install and Configure FTP Server${NC}: ${green}$CFG_FTP${NC} "
	echo

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
	

	CFG_ISPONCFIG_PORT=$(whiptail --title "ISPConfig" --backtitle "$WT_BACKTITLE" --inputbox \
	"Please specify a ISPConfig Port (leave empty for use 8080 port)" --nocancel 10 60 3>&1 1>&2 2>&3)

	if [[ -z $CFG_ISPONCFIG_PORT ]]; then
		CFG_ISPONCFIG_PORT=8080
	fi
	
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Port${NC}: ${green}" $CFG_ISPONCFIG_PORT "${NC} "
	echo	

	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Retrieve ISPConfig Admin password${NC}: "
	CFG_ISPONCFIG_ADMIN_PASS=$(whiptail --title "ISPConfig" --backtitle "$WT_BACKTITLE" --inputbox \
	"Please specify a ISPConfig Admin Password (leave empty for autogenerate)" --nocancel 10 60 3>&1 1>&2 2>&3)

	if [[ -z $CFG_ISPONCFIG_ADMIN_PASS ]]; then
		CFG_ISPONCFIG_ADMIN_PASS=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9' | head -c${1:-12})
	fi
	echo -e " [ ${green}DONE${NC} ] "
	
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Retrieve ISPConfig DB password${NC}: "
	CFG_ISPCONFIG_DB_PASS=$(whiptail --title "ISPConfig DB Password" --backtitle "$WT_BACKTITLE" --inputbox \
	"Please specify a ISPConfig DB Password (leave empty for autogenerate)" --nocancel 10 60 3>&1 1>&2 2>&3)

	if [[ -z $CFG_ISPONCFIG_ADMIN_PASS ]]; then
		CFG_ISPCONFIG_DB_PASS_AUTO=true
		CFG_ISPCONFIG_DB_PASS=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#^*_=-' | head -c${1:-16})
	else
		CFG_ISPCONFIG_DB_PASS_AUTO=false
	fi
	echo -e " [ ${green}DONE${NC} ] "


	echo -n -e "$IDENTATION_LVL_1 ${BBlack}SSL Configuration:${NC} "
	echo
	
	SSL_COUNTRY=$(whiptail --title "SSL Country Code" --backtitle "$WT_BACKTITLE" \
	                --inputbox "SSL Configuration - Country Code (2 letter code - ex. RO)" --nocancel 10 60 3>&1 1>&2 2>&3)
    if [[ -z $SSL_COUNTRY ]]; then
    	SSL_COUNTRY="RO"
    fi
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Country${NC}: ${green}" $SSL_COUNTRY "${NC} "
	echo
	
    SSL_STATE=$(whiptail --title "SSL State or Province Name" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - STATE or Province Name (full name - ex. Romania)" --nocancel 10 60 3>&1 1>&2 2>&3)
    if [[ -z $SSL_STATE ]]; then
    	SSL_STATE="Romania"
    fi
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}State${NC}: ${green}" $SSL_STATE "${NC} "
	echo
	
    SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Locality (ex. Craiova)" --nocancel 10 60 3>&1 1>&2 2>&3)
    if [[ -z $SSL_LOCALITY ]]; then
    	SSL_LOCALITY="Craiova"
    fi
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Locality${NC}: ${green}" $SSL_LOCALITY "${NC} "
	echo
	
    SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 60 3>&1 1>&2 2>&3)
    if [[ -z $SSL_ORGANIZATION ]]; then
    	SSL_ORGANIZATION="$CFG_HOSTNAME_FQDN"
    fi
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Organization${NC}: ${green}" $SSL_ORGANIZATION "${NC} "
	echo
	
    SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" \
                    --inputbox "SSL Configuration - Organization Unit (ex. IT)" --nocancel 10 60 3>&1 1>&2 2>&3)
 	if [[ -z $SSL_ORGUNIT ]]; then
    	SSL_ORGUNIT="IT"
    fi
	echo -n -e "$IDENTATION_LVL_2 ${BBlack}Unit${NC}: ${green}" $SSL_ORGUNIT "${NC} "
	echo

	MeasureTimeDuration $START_TIME
}
