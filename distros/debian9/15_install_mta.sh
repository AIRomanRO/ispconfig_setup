#---------------------------------------------------------------------
# Function: InstallMTA
#    Install chosen MTA. Courier or Dovecot
#---------------------------------------------------------------------
InstallMTA() {
	START_TIME=$SECONDS
  
    echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing MTA ${NC}\n"
    case $CFG_MTA in
		"courier")
		    echo -n -e "$IDENTATION_LVL_1 Installing ${red}Courier ${NC}... \n"

		    echo -n -e "$IDENTATION_LVL_2 Preconfigure ... "
		    echo "courier-base courier-base/webadmin-configmode boolean false" | debconf-set-selections
		    echo "courier-ssl courier-ssl/certnotice note" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "

		    echo -n -e "$IDENTATION_LVL_2 Installing Courier and dependecies... "
		    package_install courier-authdaemon courier-authlib-mysql courier-pop courier-pop-ssl courier-imap courier-imap-ssl libsasl2-2 libsasl2-modules libsasl2-modules-sql sasl2-bin libpam-mysql courier-maildrop opendkim opendkim-tools
		    echo -e " [ ${green}DONE${NC} ] "

		    echo -n -e "$IDENTATION_LVL_2 Config saslauthd... "
		    sed -i 's/START=no/START=yes/' /etc/default/saslauthd
 			echo -e " [ ${green}DONE${NC} ] "

 			echo -n -e "$IDENTATION_LVL_2 Regenerate Certificates... "
		    cd /etc/courier
		    rm -f /etc/courier/imapd.pem
		    rm -f /etc/courier/pop3d.pem
		    rm -f /usr/lib/courier/imapd.pem
		    rm -f /usr/lib/courier/pop3d.pem
		    sed -i "s/CN=localhost/CN=${CFG_HOSTNAME_FQDN}/" /etc/courier/imapd.cnf
		    sed -i "s/CN=localhost/CN=${CFG_HOSTNAME_FQDN}/" /etc/courier/pop3d.cnf
		    mkimapdcert >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    mkpop3dcert >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    ln -s /usr/lib/courier/imapd.pem /etc/courier/imapd.pem
		    ln -s /usr/lib/courier/pop3d.pem /etc/courier/pop3d.pem
		    echo -e " [ ${green}DONE${NC} ] "

		    echo -n -e "$IDENTATION_LVL_2 Restart MTA Services... "
		    service courier-imap-ssl restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    service courier-pop-ssl restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    service courier-authdaemon restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    service saslauthd restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		    echo -e " [ ${green}DONE${NC} ] "
	  	;;
		"dovecot")
			echo -n -e "$IDENTATION_LVL_1 Installing ${red}Dovecot ${NC}... \n"

			echo -n -e "$IDENTATION_LVL_2 Installing Dovecot and dependecies... "
			package_install dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-mysql dovecot-lmtpd opendkim opendkim-tools
			echo -e " [ ${green}DONE${NC} ] "
		;;
    esac

    MeasureTimeDuration $START_TIME
}
