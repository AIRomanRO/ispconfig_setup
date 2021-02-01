#---------------------------------------------------------------------
# Function: InstallMTA
#    Install chosen MTA. Courier or Dovecot
#---------------------------------------------------------------------
InstallMTA() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing MTA ${NC}\n"

  echo -n -e "$IDENTATION_LVL_1 Installing ${red}Dovecot ${NC}... \n"

  echo -n -e "$IDENTATION_LVL_2 Installing Dovecot and dependencies... "
  package_install dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-mysql dovecot-lmtpd opendkim opendkim-tools sudo
  echo -e " [ ${green}DONE${NC} ] "

  MeasureTimeDuration $START_TIME
}
