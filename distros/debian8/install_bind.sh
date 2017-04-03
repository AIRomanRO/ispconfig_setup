#---------------------------------------------------------------------
# Function: InstallBind
#    Install bind DNS server
#---------------------------------------------------------------------
InstallBind() {
  echo -n "Installing Bind9... ";
  apt-get -y install bind9 dnsutils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e "[${green}DONE${NC}]\n"
}
