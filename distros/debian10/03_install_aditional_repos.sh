#---------------------------------------------------------------------
# Function: InstallBasics
#    Install basic packages
#---------------------------------------------------------------------
InstallAditionalRepos() {
  START_TIME=$SECONDS
  LSB_RELEASE=$(lsb_release -sc)

  echo -n -e "$IDENTATION_LVL_0 ${BWhite} Start Adding additional repositories ${NC} \n"

  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Update Packages Before we start ${NC} ... "
  package_update
  echo -e " [ ${green}DONE${NC} ]"

  #Check for apt-transport-https
  if [ -f /usr/lib/apt/methods/https ]; then
    echo -n -e "$IDENTATION_LVL_1 ${BBlack}APT HTTPS Method${NC}: ${green}Already Installed${NC}\n"
  else
    echo -n -e "$IDENTATION_LVL_1 ${BBlack}APT HTTPS Method${NC}: ${red}NOT FOUND${NC} - try to install it ... "
    package_install apt-transport-https
    echo -e " [ ${green}DONE${NC} ]"
  fi

  #Add Debian backports - Required for Letsencrypt
  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Debian $LSB_RELEASE backports${NC} ... "
  echo "##################  Debian $LSB_RELEASE Backports  ##################

deb http://ftp.debian.org/debian/ $LSB_RELEASE-backports main contrib non-free
deb-src http://ftp.debian.org/debian/ $LSB_RELEASE-backports main contrib non-free

###############################################################" >/etc/apt/sources.list.d/buster-backports.list
  echo -e " [ ${green}DONE${NC} ]"

  #Add the debian-Buster sources
  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Debian $LSB_RELEASE Repository${NC} ... "
  echo "#################  Debian $LSB_RELEASE Repository  #################

deb http://ftp.debian.org/debian/ $LSB_RELEASE main contrib non-free
deb-src http://ftp.debian.org/debian/ $LSB_RELEASE main contrib non-free

deb http://security.debian.org/ $LSB_RELEASE/updates main contrib non-free
deb-src http://security.debian.org/ $LSB_RELEASE/updates main contrib non-free

deb http://ftp.debian.org/debian/ $LSB_RELEASE-updates main contrib non-free
deb-src http://ftp.debian.org/debian/ $LSB_RELEASE-updates main contrib non-free

###############################################################" >/etc/apt/sources.list.d/buster-full.list
  echo -e " [ ${green}DONE${NC} ]"

  #Add Deb.Sury repo for php
  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Deb Sury PHP - $LSB_RELEASE [ packages.sury.org ] Repository${NC} ... "
  echo "##################  Deb Sury PHP Repository  ##################" >/etc/apt/sources.list.d/php-deb-sury.list
  echo "" >>/etc/apt/sources.list.d/php-deb-sury.list
  echo "deb https://packages.sury.org/php/ $LSB_RELEASE main" >>/etc/apt/sources.list.d/php-deb-sury.list
  echo "" >>/etc/apt/sources.list.d/php-deb-sury.list
  echo "###############################################################" >>/etc/apt/sources.list.d/php-deb-sury.list
  echo -e " [ ${green}DONE${NC} ]"

  mkdir -p /etc/apt/trusted.custom.d >>$PROGRAMS_INSTALL_LOG_FILES 2>&1

  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Deb Sury PHP [ packages.sury.org ] Repository GnuPG Key${NC} ... "
  wget -q -O /etc/apt/trusted.custom.d/php-packages-sury-org.gpg https://packages.sury.org/php/apt.gpg >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  sudo apt-key add /etc/apt/trusted.custom.d/php-packages-sury-org.gpg >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ]"

  #Add latest nginx version
  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Official Nginx [ nginx.org ] Repository${NC}"
  echo "#################  Official Nginx Repository  #################

#latest Official Nginx version
deb https://nginx.org/packages/mainline/debian/ $LSB_RELEASE nginx
deb-src https://nginx.org/packages/mainline/debian/ $LSB_RELEASE nginx

###############################################################" >/etc/apt/sources.list.d/nginx-latest-official.list
  echo -e " [ ${green}DONE${NC} ]"

  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Official Nginx [ nginx.org ] Repository GnuPG Key${NC} ... "
  wget -q -O /etc/apt/trusted.custom.d/nginx_signing.key https://nginx.org/keys/nginx_signing.key >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  sudo apt-key add /etc/apt/trusted.custom.d/nginx_signing.key >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ]"


  echo -n -e "$IDENTATION_LVL_1 Configure ${BBlack}sources priorities via PIN${NC}"
  echo "##############################
Package: *
Pin: release n=$LSB_RELEASE
Pin-Priority: 900

Package: *
Pin: release a=$LSB_RELEASE-backports
Pin-Priority: 400

####################################" >/etc/apt/preferences
  echo -e "Package: *\nPin: origin packages.sury.org\nPin-Priority: 100" > /etc/apt/preferences.d/deb-sury-org

  echo -e " [ ${green}DONE${NC} ]"

  echo -n -e "$IDENTATION_LVL_1 ${BBlack}Update Packages Before at the final${NC} ... "
  package_update
  echo -e " [ ${green}DONE${NC} ]"

  MeasureTimeDuration $START_TIME
}
