#---------------------------------------------------------------------
# Function: InstallFTP
#    Install and configure PureFTPd
#---------------------------------------------------------------------
InstallFTP() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing PureFTPd${NC}\n" 

  if [ $CFG_FTP == "none" ]; then
    echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
  else
    echo -n -e "$IDENTATION_LVL_1 Set Virtual Chroot to ${BBlack}true${NC} ... "
    echo "pure-ftpd-common pure-ftpd/virtualchroot boolean true" | debconf-set-selections
    echo -e " [ ${green}DONE${NC} ] "
    
    echo -n -e "$IDENTATION_LVL_1 Install PureFTPd ... "
    apt-get -yqq install pure-ftpd-common pure-ftpd-mysql >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    sed -i 's/ftp/\#ftp/' /etc/inetd.conf >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    echo -e " [ ${green}DONE${NC} ] "

    echo -n -e "$IDENTATION_LVL_1 Configure PureFTPd to accept"
    if [ $CFG_FTP == "onlyFTP" ]; then
      echo -n -e " ${red} Only FTP ${NC}"
      echo 0 > /etc/pure-ftpd/conf/TLS
    elif [ $CFG_FTP == "onlyTLS" ]; then
      echo -n -e " ${red} Only TLS ${NC}"
      echo 2 > /etc/pure-ftpd/conf/TLS
    else
      echo -n -e " ${red} Both FTP and TLS ${NC}"
      echo 1 > /etc/pure-ftpd/conf/TLS
    fi
    echo -e "connections [ ${green}DONE${NC} ] "

    echo -n -e "$IDENTATION_LVL_1 Generate And Install SSL Certificate for FTP Server ... "
    mkdir -p /etc/ssl/private/ >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    openssl req -x509 -nodes -days 7300 -newkey rsa:4096 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/OU=$SSL_ORGUNIT/CN=$CFG_HOSTNAME_FQDN" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    chmod 600 /etc/ssl/private/pure-ftpd.pem >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    echo -e " [ ${green}DONE${NC} ] "

    echo -n -e "$IDENTATION_LVL_1 Restart FTP Server ... "
    service openbsd-inetd restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    service pure-ftpd-mysql restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    echo -e " [ ${green}DONE${NC} ] "
  fi

  MeasureTimeDuration $START_TIME
}

