#!/usr/bin/env bash
#---------------------------------------------------------------------
# install.sh
#
# ISPConfig 3 system installer
#
# Script: install.sh
# Version: 2.2.2
# Author: Matteo Temporini <temporini.matteo@gmail.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------

#Those lines are for logging porpuses
exec > >(tee -i /var/log/ispconfig_setup.log)
exec 2>&1

#---------------------------------------------------------------------
# Global variables
#---------------------------------------------------------------------
CFG_HOSTNAME_FQDN=`hostname -f`;
WT_BACKTITLE="ISPConfig 3 System Installer from Temporini Matteo"

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
BBlack='\033[1;30m'
NC='\033[0m' # No Color


#Saving current directory
PWD=$(pwd);

#---------------------------------------------------------------------
# Load needed functions
#---------------------------------------------------------------------

source $PWD/functions/01_check_linux.sh
source $PWD/functions/02_check_ipv6.sh
source $PWD/functions/03_check_whiptail.sh

echo "Checking your system, please wait..."
CheckLinux
CheckIPV6
CheckWhiptailAndInstallIfNeed

#---------------------------------------------------------------------
# Load needed Modules
#---------------------------------------------------------------------

source $PWD/distros/$DISTRO/01_preinstallcheck.sh
source $PWD/distros/$DISTRO/02_askquestions.sh

source $PWD/distros/$DISTRO/03_install_aditional_repos.sh
source $PWD/distros/$DISTRO/04_install_basics.sh
source $PWD/distros/$DISTRO/05_install_mysql.sh
source $PWD/distros/$DISTRO/install_postfix.sh
source $PWD/distros/$DISTRO/install_mta.sh
source $PWD/distros/$DISTRO/install_antivirus.sh
source $PWD/distros/$DISTRO/install_webserver.sh
source $PWD/distros/$DISTRO/install_hhvm.sh
source $PWD/distros/$DISTRO/install_ftp.sh
source $PWD/distros/$DISTRO/install_quota.sh
source $PWD/distros/$DISTRO/install_bind.sh
source $PWD/distros/$DISTRO/install_webstats.sh
source $PWD/distros/$DISTRO/install_jailkit.sh
source $PWD/distros/$DISTRO/install_fail2ban.sh
source $PWD/distros/$DISTRO/install_webmail.sh
#source $PWD/distros/$DISTRO/install_metronom.sh
source $PWD/distros/$DISTRO/install_ispconfig.sh
source $PWD/distros/$DISTRO/install_fix.sh

source $PWD/distros/$DISTRO/install_basephp.sh #to remove in feature release
#---------------------------------------------------------------------
# Main program [ main() ]
#    Run the installer
#---------------------------------------------------------------------
clear
echo "Welcome to ISPConfig Setup Script v.2.3"
echo "This software is developed by Temporini Matteo"
echo "with the support of the community."
echo "You can visit my website at the followings URLS"
echo "http://www.servisys.it http://www.temporini.net"
echo "and contact me with the following information"
echo "contact email/hangout: temporini.matteo@gmail.com"
echo "skype: matteo.temporini"
echo "========================================="
echo "ISPConfig 3 System installer"
echo "========================================="
echo
echo "This script will do a nearly unattended intallation of"
echo "all software needed to run ISPConfig 3."
echo "When this script starts running, it'll keep going all the way"
echo "So before you continue, please make sure the following checklist is ok:"
echo
echo "- This is a clean standard clean installation for supported systems";
echo "- Internet connection is working properly";
echo
echo

if [ -n "$PRETTY_NAME" ]; then
	echo -e "The detected Linux Distribution is: " $PRETTY_NAME
else
	echo -e "The detected Linux Distribution is: " $ID-$VERSION_ID
fi
echo 

if [ $IPV6_ENABLED == true ]; then
    echo -e "IPV6 enabled: ${green} YES ${NC}"
else
    echo -e "IPV6 enabled: ${red} NO ${NC}"
fi
echo

if [ -n "$DISTRO" ]; then
	read -p "Is this correct ($DISTRO) ? (y/n)" -n 1 -r
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
		exit 1
	fi
else
	echo -e "Sorry but your System is not supported by this script, if you want your system supported "
	echo -e "open an issue on GitHub: https://github.com/servisys/ispconfig_setup"
	exit 1
fi


if [ "$DISTRO" == "debian8" ]; then

	while [ "x$CFG_ISPCVERSION" == "x" ]
	do
		CFG_ISPCVERSION=$(whiptail --backtitle "$WT_BACKTITLE" --title "ISPConfig Version" --nocancel --radiolist \
				"Select ISPConfig Version you want to install" 10 50 2 \
				"Stable" "Latest Stable" ON \
				"Beta"   "Beta Version" OFF \
			3>&1 1>&2 2>&3 )
	done
	echo -n -e "   - ${BBlack}ISPConfig Version${NC}: ${green}$CFG_ISPCVERSION${NC}\n"
	
	while [ "x$CFG_MULTISERVER" == "x" ]
	do
		CFG_MULTISERVER=$(whiptail --backtitle "$WT_BACKTITLE" --title "MULTISERVER SETUP" --nocancel --radiolist \
				"Would you like to install ISPConfig in a MultiServer Setup?" 10 50 2 \
				"no" "Single Server" ON \
				"yes" "Multi Server" OFF \
			3>&1 1>&2 2>&3 )
	done
	echo -n -e "   - ${BBlack}MULTISERVER SETUP${NC}: ${green}$CFG_MULTISERVER${NC}\n"
	
else
	CFG_MULTISERVER=no
fi

if [ -f /etc/debian_version ]; then
    PreInstallCheck

    if [ "$CFG_MULTISERVER" == "no" ]; then
	    AskQuestions
    else
        source $PWD/distros/$DISTRO/02_askquestions_multiserver.sh
	    AskQuestionsMultiserver
    fi
	
	InstallAditionalRepos
    InstallBasics 
    InstallSQLServer 
	
    if [ "$CFG_SETUP_WEB" == "yes" ] || [ "$CFG_MULTISERVER" == "no" ]; then
        InstallWebServer
        InstallFTP 
		
        if [ "$CFG_QUOTA" == "yes" ]; then
    	    InstallQuota 
        fi
		
        if [ "$CFG_JKIT" == "yes" ]; then
    	    InstallJailkit 
        fi
		
        if [ "$CFG_HHVM" == "yes" ]; then
    	    InstallHHVM
        fi
		
        if [ "$CFG_METRONOM" == "yes" ]; then
    	    InstallMetronom 
        fi
		
        InstallWebmail 
    fi
	
	if [ "$CFG_PHP_VERSION" == "none"]; then
        InstallBasePhp
    fi  
	
    if [ "$CFG_SETUP_MAIL" == "yes" ] || [ "$CFG_MULTISERVER" == "no" ]; then
        InstallPostfix 
        InstallMTA 
        InstallAntiVirus 
    fi  
 
    if [ "$CFG_SETUP_NS" == "yes" ] || [ "$CFG_MULTISERVER" == "no" ]; then
        InstallBind 
    fi
	
	InstallWebStats
    InstallFail2ban
	
    if [ "$CFG_ISPCVERSION" == "Beta" ]; then
		source $PWD/distros/$DISTRO/install_ispconfigbeta.sh
		InstallISPConfigBeta
    fi
	
    InstallISPConfig
    InstallFix
	
    echo -e "${green}Well done ISPConfig installed and configured correctly :D ${NC}"
    echo
	
	echo "Now you can connect to your ISPConfig installation at https://$CFG_HOSTNAME_FQDN:$CFG_ISPONCFIG_PORT or https://IP_ADDRESS:$CFG_ISPONCFIG_PORT"
	echo
	
    echo "You can visit my GitHub profile at https://github.com/a1ur3l/ispconfig_setup"
    echo "Original version of this script can be found on GitHub at	https://github.com/servisys/ispconfig_setup/"
    echo
	
	if [ "$CFG_WEBMAIL" == "roundcube" ]; then
        if [ "$DISTRO" != "debian8" ]; then
		    echo -e "${red}You had to edit user/pass /var/lib/roundcube/plugins/ispconfig3_account/config/config.inc.php of roudcube user, as the one you inserted in ISPconfig ${NC}"
	    fi
    fi
	
    if [ "$CFG_WEBSERVER" == "nginx" ]; then
  	    if [ "$CFG_PHPMYADMIN" == "yes" ]; then
  		    echo "Phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://IP_ADDRESS:8081/phpmyadmin";
	    fi
		
	    if [ "$DISTRO" == "debian8" ] && [ "$CFG_WEBMAIL" == "roundcube" ]; then
		    echo "Webmail is accessibile at  https://$CFG_HOSTNAME_FQDN/webmail or https://IP_ADDRESS/webmail";
	    else
		    echo "Webmail is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/webmail or http://IP_ADDRESS:8081/webmail";
	    fi
    fi
	
    if [ "$DISTRO" == "debian8" ] && [ $CFG_MYSQL_ROOT_PWD_AUTO == true ]; then
		echo "You Have choosed to autogenerate the MySQL ROOT PASSWORD \n"
		echo "Please copy and keep it safe \n"
		echo -e "MySQL GENERATED PASS (Copy only ${red}red text${NC}): ${red}$CFG_MYSQL_ROOT_PWD${NC} \n"
	fi
	
else 
	echo "${red}Unsupported linux distribution.${NC} \n"
	echo -n -e "For other distributions please visit the ${red}Original version of this script${NC}"
	echo -n -e " which can be found on GitHub at ${red}https://github.com/servisys/ispconfig_setup/${NC}"
	echo -n -e "Thanks"
	
fi

exit 0

