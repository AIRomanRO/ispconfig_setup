#---------------------------------------------------------------------
# Function: InstallAntiVirus
#    Install Amavisd, Spamassassin, ClamAV
#---------------------------------------------------------------------
InstallAntiVirus() {
  START_TIME=$SECONDS
  
  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing AntiVirus${NC}\n"

  echo -n -e "$IDENTATION_LVL_1 Installing AntiVirus utilities (This take some time. Don't abort it! ) ... "
  apt-get -yqq install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl rkhunter systemd unrar-free p7zip rpm2cpio tnef >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Configure AntiVirus ... "
  sed -i "s/AllowSupplementaryGroups false/AllowSupplementaryGroups true/" /etc/clamav/clamd.conf
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Stopping Spamassassin ... "
  service spamassassin stop  >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Disable Spamassassin ... "
  systemctl disable spamassassin >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  if [ $CFG_AVUPDATE == "yes" ]; then
    echo -n -e "$IDENTATION_LVL_1 Updating ClamAV. ( Please Wait. Don't abort it! ) ... "
    freshclam >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
    echo -e " [ ${green}DONE${NC} ] "
  fi

  echo -n -e "$IDENTATION_LVL_1 Restarting ClamAV ... "
  service clamav-daemon restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e "[${green}DONE${NC}]\n"

  MeasureTimeDuration $START_TIME
}
