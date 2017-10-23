#---------------------------------------------------------------------
# Function: InstallBind
#    Install bind DNS server
#---------------------------------------------------------------------
InstallBind() {
	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing Bind DNS Server${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 Installing Bind9... ";
	apt-get -y install bind9 dnsutils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -e " [ ${green}DONE${NC} ] "

	echo -n -e "$IDENTATION_LVL_1 Secure Bind9 ... ";
	sed -i '0,/};/{s/\};/\}; \n\n        \/\/Settings added by ispconfig_install script\n        fetch-glue no; \n        recursion no; \n        allow-query-cache { none; }; \n        version "[Not Available]"; /}' /etc/bind/named.conf.options
	echo -e " [ ${green}DONE${NC} ] "

	echo -n -e "$IDENTATION_LVL_1 Enable Logging for Bind9... ";
	mkdir -p /var/log/named >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	chown bind /var/log/named  >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

	cat << "EOF" >> /etc/bind/named.conf.options
#Enable Logging
logging {
  channel security_file {
        file "/var/log/named/security.log" versions 3 size 30m;
        severity dynamic;
        print-time yes;
  };
  category security {
        security_file;
 };
};

EOF

	echo -e " [ ${green}DONE${NC} ] "

	MeasureTimeDuration $START_TIME
}
