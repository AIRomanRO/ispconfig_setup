#!/usr/bin/env bash
#---------------------------------------------------------------------
# install.sh
#
# ISPConfig 3 System installer on Debian 8+
#
# Script:      install.sh
# Version:     2.3
# Author:      Matteo Temporini <temporini.matteo@gmail.com>
# Contributor: Aurel Roman <aur3l.roman@gmail.com>
# Description: This script will install & basic configure all the 
#                 packages needed to install ISPConfig 3 on your server.
#
#---------------------------------------------------------------------

SCRIPT_EXECUTION_START_TIME=$SECONDS

clear
echo "Welcome to ISPConfig Setup Script v.2.3"
echo "This software was initially developed by Temporini Matteo"
echo "with the support of the community."
echo "Starting with version 2.3 it is developed by Aurel Roman and it"
echo "it is focused on Debian 8+ versions. For other versions you can check"
echo "http://www.servisys.it http://www.temporini.net or contact the"
echo "original author with the following information"
echo "contact email/hangout: temporini.matteo@gmail.com"
echo "skype: matteo.temporini"
echo 
echo "========================================="
echo "ISPConfig 3 System installer on Debian 8+"
echo "========================================="
echo
echo "This script will do a nearly unattended intallation of"
echo "all software needed to run ISPConfig 3."
echo "When this script starts running, it'll keep going all the way"
echo
echo "================================================================="
echo "Let's Start and make the unicorn"

echo
echo
echo

#---------------------------------------------------------------------
# Bash Colours
#---------------------------------------------------------------------
red='\033[0;31m'
green='\033[0;32m'
BBlack='\033[1;90m'
BWhite='\033[1;97m'
NC='\033[0m' # No Color

#---------------------------------------------------------------------
#IDENTATION LVLS
#---------------------------------------------------------------------
IDENTATION_LVL_0="${BWhite}===>${NC}"
IDENTATION_LVL_1="   -"
IDENTATION_LVL_2="     *"
IDENTATION_LVL_3="       *"

#Those lines are for logging porpuses
echo -n -e "$IDENTATION_LVL_0 ${BWhite}Setup Logging${NC}"
exec > >(tee -i /var/log/ispconfig_setup.log)
exec 2>&1
PROGRAMS_INSTALL_LOG_FILES=/var/log/ispconfig_setup_programs.log
echo -e " [ ${green}DONE${NC} ] "


#---------------------------------------------------------------------
# Global variables
#---------------------------------------------------------------------
echo -n -e "$IDENTATION_LVL_0 ${BWhite}Setup Global Variable${NC}"
CFG_HOSTNAME_FQDN=`hostname -f`;
WT_BACKTITLE="ISPConfig 3 System Installer from Aurel Roman"
#Saving current directory
PWD=$(pwd);
echo -e " [ ${green}DONE${NC} ] "


echo -e "$IDENTATION_LVL_0 ${BWhite}Checking your system, please wait...${NC}"
#---------------------------------------------------------------------
# Load needed functions
#---------------------------------------------------------------------
source $PWD/functions/01_check_linux.sh
source $PWD/functions/02_check_ipv6.sh
source $PWD/functions/03_check_whiptail.sh
source $PWD/functions/04_measure_duration_and_echo.sh
source $PWD/functions/05_apt_get_commands_wrappers.sh

#---------------------------------------------------------------------
# Basic Checks
#---------------------------------------------------------------------
CheckLinux
CheckIPV6
CheckWhiptailAndInstallIfNeed

echo -e "$IDENTATION_LVL_0 ${BWhite}System Checking [${NC} ${green}COMPLETED${NC} ${BWhite}]${NC} "

echo -n -e "$IDENTATION_LVL_0 ${BWhite}Please give us five seconds before continue ${NC} ... "
sleep 5
echo -e " [${NC} ${green}Thanks !${NC} ${BWhite}] "

MeasureTimeDuration $SCRIPT_EXECUTION_START_TIME

#---------------------------------------------------------------------
# Main program [ main() ]
#    Run the installer
#---------------------------------------------------------------------

echo -e -n "$IDENTATION_LVL_0 ${BWhite}Confirm if we detected the correct Informations:${NC} "

echo
if [ -n "$PRETTY_NAME" ]; then
	echo -n -e "$IDENTATION_LVL_1 Linux Distribution is: ${green}" $PRETTY_NAME "${NC}"
else
	echo -n -e "$IDENTATION_LVL_1 Linux Distribution is: ${green}" $ID-$VERSION_ID "${NC}"
fi

echo
if [ $IPV6_ENABLED == true ]; then
    echo -n -e "$IDENTATION_LVL_1 IPV6 enabled: ${green} YES ${NC}"
	echo
	echo -n -e "$IDENTATION_LVL_1 IPV4: ${green} $CFG_IPV4 ${NC} - is possible to be incorrect - we don't use it anywhere in configuration"
	echo
	echo -n -e "$IDENTATION_LVL_1 IPV6: ${green} $CFG_IPV6 ${NC} - is possible to be incorrect - we don't use it anywhere in configuration"
else
    echo -n -e "$IDENTATION_LVL_1 IPV6 enabled: ${red} NO ${NC}"
	echo
	echo -n -e "$IDENTATION_LVL_1 IPV4: ${green} $CFG_IPV4 ${NC} - is possible to be incorrect - we don't use it anywhere in configuration"
fi

echo
echo -n -e "$IDENTATION_LVL_1 Host Name FQDN: ${green} $CFG_HOSTNAME_FQDN ${NC}"

echo
echo -n -e "$IDENTATION_LVL_1 DISTRO: ${green} $DISTRO ${NC}"

echo
if [ -n "$DISTRO" ]; then
	echo -e -n "$IDENTATION_LVL_0 ${BWhite}Are this Informations Correct ? ${NC}"
	echo
	echo -e -n "$IDENTATION_LVL_0 ${BWhite}Please answer with y / n: ${NC} "
	read -n 1 RESPONSE
	
	if [[ ! $RESPONSE =~ ^[Yy]$ ]]; then
		echo -e -n "$IDENTATION_LVL_0 Sorry, but you choosed to not continue"
		echo
		echo -e -n "$IDENTATION_LVL_0 If you want to install anyway please, restart the installation and answer ${green} y ${NC} or ${green} Y ${NC}"
		echo
		
		exit 1
	fi
else
	echo -e "${red}"
	echo -e "Sorry but your System is not supported by this script,"
    echo -e "If your system is a 8+ Debian Version please open and issue on https://github.com/a1ur3l/ispconfig_setup"
	echo
	echo -e "Otherwise please check if it is suported at https://github.com/servisys/ispconfig_setup"
	echo -e "if you want your system supported there please open an issue on GitHub: https://github.com/servisys/ispconfig_setup"
	echo -e "${NC}"
	exit 1
fi

echo
echo -n -e "$IDENTATION_LVL_0 ${BWhite}Load needed Modules ${NC} "
#---------------------------------------------------------------------
# Load needed Modules
#---------------------------------------------------------------------
source $PWD/distros/$DISTRO/01_preinstallcheck.sh
source $PWD/distros/$DISTRO/02_askquestions.sh

source $PWD/distros/$DISTRO/03_install_aditional_repos.sh
source $PWD/distros/$DISTRO/04_install_basics.sh
source $PWD/distros/$DISTRO/05_install_mysql.sh
source $PWD/distros/$DISTRO/06-0_install_webserver.sh
source $PWD/distros/$DISTRO/07_install_php.sh
source $PWD/distros/$DISTRO/08_install_phpmyadmin.sh
source $PWD/distros/$DISTRO/09_install_letsencrypt.sh
source $PWD/distros/$DISTRO/10_install_ftp.sh
source $PWD/distros/$DISTRO/11_install_quota.sh
source $PWD/distros/$DISTRO/12_install_jailkit.sh
source $PWD/distros/$DISTRO/13_install_webmail.sh
source $PWD/distros/$DISTRO/14_install_postfix.sh
source $PWD/distros/$DISTRO/15_install_mta.sh
source $PWD/distros/$DISTRO/16_install_antivirus.sh
source $PWD/distros/$DISTRO/17_install_bind.sh
source $PWD/distros/$DISTRO/18_install_webstats.sh
source $PWD/distros/$DISTRO/19_install_fail2ban.sh

source $PWD/distros/$DISTRO/install_ispconfig.sh
source $PWD/distros/$DISTRO/install_fix.sh

source $PWD/distros/$DISTRO/install_basephp.sh #to remove in feature release

echo -e " [ ${green}DONE${NC} ] "


echo -n -e "$IDENTATION_LVL_0 ${BWhite}Gathering the ISPConfig Version which you want and Setup Type ${NC}"
echo
if [ "$DISTRO" == "debian8" ]; then

	echo -n -e "$IDENTATION_LVL_1 ${BBlack}ISPConfig Version${NC}: ${green}Latest Stable${NC}\n"
	
	while [ "x$CFG_MULTISERVER" == "x" ]
	do
		CFG_MULTISERVER=$(whiptail --backtitle "$WT_BACKTITLE" --title "MULTISERVER SETUP" --nocancel --radiolist \
				"Would you like to install ISPConfig in a MultiServer Setup?" 10 50 2 \
				"no" "Single Server" ON \
				"yes" "Multi Server" OFF \
			3>&1 1>&2 2>&3 )
	done
	echo -n -e "$IDENTATION_LVL_1 ${BBlack}MULTISERVER SETUP${NC}: ${green}$CFG_MULTISERVER${NC}\n"
	
else
	CFG_MULTISERVER=no
fi
echo -n -e "$IDENTATION_LVL_0 ${BWhite}Gathering ISPConfig Version & Setup Type [${NC} ${green}DONE${NC} ${BWhite}]${NC} "
echo

if [ -f /etc/debian_version ]; then
    PreInstallCheck

    CFG_INSTALL_EMAIL_ADR=$(whiptail --title "Your Email" --backtitle "$WT_BACKTITLE" --inputbox \
	"Please Enter your Email Address. We will use it for: 
- Generate ISPConfig LetsEncrypt ssl ( if you choosed to install LetsEncrypt and ISPConfig interface)
- Send you the logs of this setup. \n
!Important! If you will let it empty we will use postmaster@$CFG_HOSTNAME_FQDN" --nocancel 15 90 3>&1 1>&2 2>&3)

    if [[ -z $CFG_INSTALL_EMAIL_ADR ]]; then
        CFG_INSTALL_EMAIL_ADR="postmaster@$CFG_HOSTNAME_FQDN"
	fi

    if [ "$CFG_MULTISERVER" == "no" ]; then
	    AskQuestions
    else
        source $PWD/distros/$DISTRO/02_askquestions_multiserver.sh
	    AskQuestionsMultiserver
    fi

	InstallAditionalRepos
    InstallBasics 
    InstallSQLServer 

    if [ "$CFG_SETUP_WEB" == "yes" ] || [ "$CFG_MULTISERVER" == "no" ];
	then
        InstallWebServer
		
		InstallPHP
		
		InstallPHPMyAdmin

		InstallLetsEncrypt

        InstallFTP 
		
        if [ "$CFG_QUOTA" == "yes" ]; 
		then
    	    InstallQuota 
        fi
		
        if [ "$CFG_JKIT" == "yes" ]; 
		then
    	    InstallJailkit 
        fi
				
        InstallWebmail 
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

	if [ "$CFG_PHP_VERSION" == "none" ]; then
        InstallBasePhp
    fi

    InstallISPConfig
    InstallFix
	
    echo -e "${green}Well done ISPConfig seems installed and configured correctly :D ${NC}"
	echo
    echo "You can visit my GitHub profile at https://github.com/a1ur3l/ispconfig_setup"
    echo '-----------------------------------------------------------------------------'
    echo "Original version of this script can be found on GitHub at	https://github.com/servisys/ispconfig_setup/"
    echo

	if [ "$CFG_WEBMAIL" == "roundcube" ]; then
        if [ "$DISTRO" != "debian8" ]; then
		    echo -e "${red}You had to edit user/pass /var/lib/roundcube/plugins/ispconfig3_account/config/config.inc.php of roundcube user, as the one you inserted in ISPconfig ${NC}"
	    fi
    fi

    echo
	echo "Now you can connect to your ISPConfig installation at https://$CFG_HOSTNAME_FQDN:$CFG_ISPONCFIG_PORT or https://$CFG_IPV4:$CFG_ISPONCFIG_PORT"

    if [ "$CFG_WEBSERVER" == "nginx" ]; then
  	    if [ "$CFG_PHPMYADMIN" == "yes" ]; then
  		    echo "Phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://$CFG_IPV4:8081/phpmyadmin";
	    fi

	    if [ "$DISTRO" == "debian8" ] && [ "$CFG_WEBMAIL" == "roundcube" ]; then
		    echo "Webmail is accessibile at  https://$CFG_HOSTNAME_FQDN/webmail or https://$CFG_IPV4/webmail";
	    else
		    echo "Webmail is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/webmail or http://$CFG_IPV4:8081/webmail";
	    fi
    fi

    if [ "$DISTRO" == "debian8" ]; then

    	if [ $CFG_MYSQL_ROOT_PWD_AUTO == true ] || [ $CFG_ISPCONFIG_DB_PASS_AUTO == true ]; then
    		echo -n -e "You Have choosed to autogenerate the following PASSWORDS \n"
		    echo -n -e "Please copy (Only ${red}red text${NC}) and keep them safe \n"
		fi

	    if [ $CFG_MYSQL_ROOT_PWD_AUTO == true ]; then		    
		    echo -n -e "MySQL ROOT: ${red}$CFG_MYSQL_ROOT_PWD${NC}\n"
		fi

		if [ $CFG_ISPCONFIG_DB_PASS_AUTO == true ]; then
		    echo -n -e "ISPConfig DB: ${red}$CFG_ISPCONFIG_DB_PASS${NC}\n"
		fi

		echo -n -e "ISPConfig Admin PAsswprd: $red$CFG_ISPONCFIG_ADMIN_PASS$NC\n"
	fi

else 

	echo "${red}Unsupported linux distribution.${NC} \n"
	echo -n -e "For other distributions please visit the ${red}Original version of this script${NC}"
	echo -n -e " which can be found on GitHub at ${red}https://github.com/servisys/ispconfig_setup/${NC}"
	echo -n -e "Thanks"
	
fi

exit 0

