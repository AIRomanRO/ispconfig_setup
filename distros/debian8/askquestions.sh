#---------------------------------------------------------------------
# Function: AskQuestions Debian 8
#    Ask for all needed user input
#---------------------------------------------------------------------
AskQuestions() {
	CFG_SETUP_WEB=yes #Needed for Multiserver setup compatibility
	CFG_SETUP_MAIL=yes #Needed for Multiserver setup compatibility
	CFG_SETUP_NS=yes #Needed for Multiserver setup compatibility
		  
	while [ "x$CFG_SQLSERVER" == "x" ]
    do
		CFG_SQLSERVER=$(whiptail --title "SQLSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		    "Select SQL Server type" 10 60 3 \
		    "MySQL" "(default)" ON \
		    "MariaDB" "" OFF \
		    "None" "(already installed)" OFF 3>&1 1>&2 2>&3)
    done
		  
	if [ $CFG_SQLSERVER == "MySQL" ]; then
		while [ "x$CFG_MYSQL_VERSION" == "x" ]
        do
			CFG_MYSQL_VERSION=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			    "Select MySQL Version" 10 60 3 \
			    "default" "OS Current Version" ON \
			    "5.6" "MySQL-5.6" OFF \
			    "5.7" "MySQL-5.7" OFF 3>&1 1>&2 2>&3)
        done
	fi
	  
	if [ $CFG_SQLSERVER == "MySQL" ] || [ $CFG_SQLSERVER == "MariaDB" ]; then
	    while [ "x$CFG_MYSQL_ROOT_PWD_AUTO" == "x" ]
        do
            CFG_MYSQL_ROOT_PWD_AUTO=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		        "Auto Generate ROOT PASSWORD?" 10 57 2 \
		        "false" "NO, i have IT OR i want to choose one" ON \
		        "true"  "YES, autogenerate it" OFF 3>&1 1>&2 2>&3)
        done
	else
		CFG_MYSQL_ROOT_PWD_AUTO = false
	fi
	  
	if [ $CFG_MYSQL_ROOT_PWD_AUTO == false ]; then
	    #We should receive a password
	    while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
	    do
	        CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox \
				"Please specify a root password" --nocancel 10 60 3>&1 1>&2 2>&3)
	    done
	else
		#We generate a random 32 Chars Length
		CFG_MYSQL_ROOT_PWD=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-32})
	fi

    while [ "x$CFG_WEBSERVER" == "x" ]
	do
		CFG_WEBSERVER=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select webserver type" 10 60 2 \
		"apache" "(default)" ON \
		"nginx" "" OFF 3>&1 1>&2 2>&3)
	done

	if [ $CFG_WEBSERVER == "nginx" ]; then
	    while [ "x$CFG_NGINX_VERSION" == "x" ]
		do
	        CFG_NGINX_VERSION=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			"Select Nginx Version" 10 60 5 \
			"default" "OS Default" ON \
			"nginx" "NGINX Official - nginx.org" OFF \
			"dotdeb" "DotDeb.org - with 'full' HTTP2" OFF \
			"stretch" "Debian Stretch - with HTTP2" OFF \
            "custom" "With OpenSSL 1.1 and ChaCha20-Poly1305" OFF 3>&1 1>&2 2>&3)
	    done		
	fi
	
	while [ "x$CFG_PHP_VERSION" == "x" ]
	do
		CFG_PHP_VERSION=$(whiptail --title "Choose PHP Version(s)" --backtitle "$WT_BACKTITLE" --nocancel --separate-output --checklist \
		    "Choose PHP Version do you want to install" 25 60 5 \
            "php5.6"    "Latest Available from 5.6" ON \
            "php7.0"    "Latest Available from 7.0" ON \
            "php7.1"    "Latest Available from 7.1" ON \
			"none"      "Not install" OFF \
	    3>&1 1>&2 2>&3)
	done


	while [ "x$CFG_CERTBOT_VERSION" == "x" ]
	do
		CFG_CERTBOT_VERSION=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select CertBot Version" 10 60 3 \
		"none"    "No installation" OFF \
		"default" "from jessie backports" ON \				
		"stretch" "from stretch" OFF 3>&1 1>&2 2>&3)
	done
	
	while [ "x$CFG_HHVM" == "x" ]
    do
        CFG_HHVM=$(whiptail --title "HHVM" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Do you want to install HHVM?" 10 60 2 \
		"no" "(default)" ON \
		"yes" "" OFF 3>&1 1>&2 2>&3)
    done
	
	while [ "x$CFG_XCACHE" == "x" ]
	do
	    CFG_XCACHE=$(whiptail --title "Install XCache" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"You want to install XCache during install? ATTENTION: If XCache is installed, Ioncube Loaders will not work !!" 20 50 2 \
		"yes" "(default)" ON \
		"no" "" OFF 3>&1 1>&2 2>&3)
	done
	
	while [ "x$CFG_PHPMYADMIN" == "x" ]
	do
		CFG_PHPMYADMIN=$(whiptail --title "Install phpMyAdmin" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"You want to install phpMyAdmin during install?" 10 60 2 \
		"yes" "(default)" ON \
		"no" "" OFF 3>&1 1>&2 2>&3)
	done
	  
	if [ $CFG_PHPMYADMIN == "yes" ]; then
        while [ "x$CFG_PHPMYADMIN_VERSION" == "x" ]
	    do
		    CFG_PHPMYADMIN_VERSION=$(whiptail --title "Install phpMyAdmin" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
			"From Where Do you want to install phpMyAdmin?" 10 60 3 \
			"default" "Current OS Version" ON \
			"jessie" "from jessie backports - possible newer" OFF \
			"stretch" "from stretch version - newer" OFF 3>&1 1>&2 2>&3)
	    done
	fi
	  
	while [ "x$CFG_MTA" == "x" ]
	do
		CFG_MTA=$(whiptail --title "Mail Server" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select mailserver type" 10 60 2 \
		"dovecot" "(default)" ON \
		"courier" "" OFF 3>&1 1>&2 2>&3)
	done

	while [ "x$CFG_WEBMAIL" == "x" ]
	do
		CFG_WEBMAIL=$(whiptail --title "Webmail client" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Select which Web Mail client you want" 10 60 3 \
		"roundcube" "(default)" ON \
		"squirrelmail" "" OFF \
		"none" "No Web Mail Client" OFF 3>&1 1>&2 2>&3)
	done

	if ( whiptail --title "Update Freshclam DB" --backtitle "$WT_BACKTITLE" --yesno "You want to update Antivirus Database during install?" 10 60) then
		CFG_AVUPDATE=yes
	else
		CFG_AVUPDATE=no
	fi
	
	if (whiptail --title "Quota" --backtitle "$WT_BACKTITLE" --yesno "Setup user quota?" 10 60) then
		CFG_QUOTA=yes
	else
		CFG_QUOTA=no
	fi
	
	if (whiptail --title "Jailkit" --backtitle "$WT_BACKTITLE" --yesno "Would you like to install Jailkit?" 10 60) then
		CFG_JKIT=yes
	else
		CFG_JKIT=no
	fi
	
	while [ "x$CFG_INSTALL_ADITIONAL_SOFTWARE" == "x" ]
	do
		CFG_INSTALL_ADITIONAL_SOFTWARE=$(whiptail --title "Install Aditional Software" --backtitle "$WT_BACKTITLE" --nocancel --separate-output --checklist \
		    "Choose what programs do you want to install" 25 105 10 \
            "htop"                     "HTOP - interactive process viewer" ON \
            "nano"                     "NANO - text editor" ON \
            "haveged"                  "HAVEGED - A simple entropy daemon" ON \
            "ssh"                      "SSH - Secure Shell" ON \
            "openssh-server"           "OpenSSH Server - collection of tools for control and transfer of data" ON \
			"openssh-server-stretch"   "OpenSSH Server - version from stretch branch - usually newer" ON \
            "openssl-stable"           "OpenSSL - toolkit with full-strength cryptography" ON \
            "openssl-stretch"          "OpenSSL - version from stretch branch - usually newer" ON \
			"none"                     "Not install any thing from the above list" OFF \
	    3>&1 1>&2 2>&3)
	done

	while [ "x$CFG_ISPC" == "x" ]
	do
      	CFG_ISPC=$(whiptail --title "ISPConfig Setup" --backtitle "$WT_BACKTITLE" --nocancel --radiolist \
		"Would you like full unattended setup of expert mode for ISPConfig?" 10 60 2 \
		"standard" "Yes (default)" ON \
		"expert"   "No, i want to configure" OFF 3>&1 1>&2 2>&3)
    done
	
	while [ "x$CFG_ISPONCFIG_PORT" == "x" ]
	do
		CFG_ISPONCFIG_PORT=$(whiptail --title "ISPConfig" --backtitle "$WT_BACKTITLE" --inputbox \
		"Please specify a ISPConfig Port" --nocancel 10 60 3>&1 1>&2 2>&3)
	done
	  
	CFG_ISPCONFIG_DB_PASS=$(whiptail --title "ISPConfig db pass for advanced" --backtitle "$WT_BACKTITLE" --inputbox "ISPConfig db pass for advanced" --nocancel 10 60 3>&1 1>&2 2>&3)
	  
	SSL_COUNTRY=$(whiptail --title "SSL Country Code" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Country Code (2 letter code - ex. EN)" --nocancel 10 60 3>&1 1>&2 2>&3)
    SSL_STATE=$(whiptail --title "SSL State or Province Name" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - STATE or Province Name (full name - ex. Romania)" --nocancel 10 60 3>&1 1>&2 2>&3)
    SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Locality (ex. Craiova)" --nocancel 10 60 3>&1 1>&2 2>&3)
    SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 60 3>&1 1>&2 2>&3)
    SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization Unit (ex. IT)" --nocancel 10 60 3>&1 1>&2 2>&3)
}
