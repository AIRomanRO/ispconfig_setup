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
  
  #Add Debian backports - Required for Letsencrypt
  echo "###############################################################
# Debian backports - Required for Letsencrypt
deb http://ftp.debian.org/debian jessie-backports main
###############################################################" >> /etc/apt/sources.list.d/jessie-backports.list
  echo -e "${green} Added Debian backports - Required for Letsencrypt${NC}\n"
  
  #Add dotdeb repo for php
  echo "###############################################################
#php  7
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb-PHP7.0.list
  wget https://www.dotdeb.org/dotdeb.gpg && sudo apt-key add dotdeb.gpg
  
  echo -e "${green} Added PHP 7.0 - DotDeb repo${NC}\n"
  
  #Add latest nginx version
  echo "###############################################################
#latest nginx version
deb http://nginx.org/packages/mainline/debian/ jessie nginx

deb-src http://nginx.org/packages/mainline/debian/ jessie nginx
###############################################################" >> /etc/apt/sources.list.d/nginx-latest-official.list
  wget https://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
  echo -e "${green} Added latest nginx version repo${NC}\n"
  
  mkdir temp && cd temp/
  wget https://repo.mysql.com//mysql-apt-config_0.8.1-1_all.deb && dpkg -i mysql-apt-config_0.8.1-1_all.deb
  cd ../
  
  echo -e "${green} OK${NC}\n"
}


