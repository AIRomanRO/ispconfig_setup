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
        echo -e "${red}ERROR: Couldn't reach www.ispconfig.org, please check your internet connection${NC}"
        exit 1;
  fi
  
  # Check for already installed ispconfig version
  if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
    echo "ISPConfig is already installed, can't go on."
	exit 1
  fi
  
  echo -e "Start install ${green}nano, whiptail & debconf-utils${NC}\n"
  
  apt-get -y install nano whiptail debconf-utils > /dev/null 2>&1
  
  touch /etc/inetd.conf
  
  #Add Debian backports - Required for Letsencrypt
  echo "###############################################################
# Debian backports - Required for Letsencrypt
deb http://ftp.debian.org/debian jessie-backports main
###############################################################" >> /etc/apt/sources.list.d/jessie-backports.list
  echo -e "\n${green} Added Debian backports - Required for Letsencrypt${NC}\n"
  
  #Add dotdeb repo for php
  echo "###############################################################
#php  7
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb-PHP7.0.list
  wget -q https://www.dotdeb.org/dotdeb.gpg && sudo apt-key add dotdeb.gpg
  
  echo -e "${green} Added PHP 7.0 - DotDeb repo${NC}\n"
  
  #Add latest nginx version
  echo "###############################################################
#latest nginx version
deb http://nginx.org/packages/mainline/debian/ jessie nginx

deb-src http://nginx.org/packages/mainline/debian/ jessie nginx
###############################################################" >> /etc/apt/sources.list.d/nginx-latest-official.list
  wget -q https://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
  echo -e "${green} Added latest nginx version repo${NC}\n"

  echo "###############################################################
deb http://httpredir.debian.org/debian/ stretch main contrib non-free
deb-src http://httpredir.debian.org/debian/ stretch main contrib non-free

deb http://security.debian.org/ stretch/updates main contrib non-free
deb-src http://security.debian.org/ stretch/updates main contrib non-free

# stretch-updates, previously known as 'volatile'
deb http://httpredir.debian.org/debian/ stretch-updates main contrib non-free
deb-src http://httpredir.debian.org/debian/ stretch-updates main contrib non-free
###############################################################" >> /etc/apt/sources.list.d/debian-stretch.list

echo "##############################
Package: *
Pin: release n=jessie
Pin-Priority: 900

Package: * 
Pin: release a=jessie-backports
Pin-Priority: 500

Package: *
Pin: release n=stretch
Pin-Priority: 100
####################################" >> /etc/apt/preferences

  echo -e "${green} OK${NC}\n"
}


