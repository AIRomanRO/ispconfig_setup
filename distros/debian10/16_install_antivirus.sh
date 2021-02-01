#---------------------------------------------------------------------
# Function: InstallAntiVirus
#    Install Amavisd, Spamassassin, ClamAV
#---------------------------------------------------------------------
InstallAntiVirus() {
  START_TIME=$SECONDS
  
  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing AntiVirus${NC}\n"

  echo -n -e "$IDENTATION_LVL_1 Installing AntiVirus utilities (This take some time. Don't abort it! ) ... "
  package_install amavisd-new spamassassin clamav clamav-daemon unzip bzip2 arj nomarch lzop cabextract p7zip p7zip-full unrar lrzip apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl libdbd-mysql-perl postgrey unrar-free unp lz4 liblz4-tool unp
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Configure AntiVirus ... "
  sed -i "s/AllowSupplementaryGroups false/AllowSupplementaryGroups true/" /etc/clamav/clamd.conf
  echo "use strict;" > /etc/amavis/conf.d/05-node_id
  echo "chomp(\$myhostname = \`hostname --fqdn\`);" >> /etc/amavis/conf.d/05-node_id
  echo "\$myhostname = \"$CFG_HOSTNAME_FQDN\";" >> /etc/amavis/conf.d/05-node_id
  echo "1;" >> /etc/amavis/conf.d/05-node_id
  echo "$CFG_HOSTNAME_FQDN" > /etc/mailname
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Stopping Spamassassin ... "
  systemctl  stop spamassassin  >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
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
  systemctl restart clamav-daemon restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e "[${green}DONE${NC}]\n"

  MeasureTimeDuration $START_TIME
}
