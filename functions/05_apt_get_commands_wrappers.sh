#---------------------------------------------------------------------
# Function: Multiple apt-get wrappers
#    Update / Install / Clean / Upgrade apg-get wrappers
#---------------------------------------------------------------------

LOG_SPACER="               "
LOG_SPACER_SIGNS="======="
LOG_SPACER_SIGNS_END="===================================="
# Install Package(s)
function package_install() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS INSTALL Package(s) $LOG_SPACER_SIGNS\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS INSTALL $@ $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS_END \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

	apt-get -y --force-yes install "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS INSTALL Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Update Package(s)
function package_update() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UPDATE Package(s) $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UPDATE Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Uninstall Package(s)
function package_uninstall() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UNINSTALL Package(s) $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS $@ $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS_END \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq purge  "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UNINSTALL Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Remove Package(s)
function package_remove() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS REMOVE Package(s) $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS $@ \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS_END \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq remove "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS REMOVE Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Remove Package(s)
function package_purge_remove() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS REMOVE Package(s) $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS $@ $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS_END \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq remove --purge "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS REMOVE Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Upgrade(s)
function package_upgrade() {
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UPGRADE Package(s) $LOG_SPACER_SIGNS \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq upgrade >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e "$LOG_SPACER $LOG_SPACER_SIGNS UPGRADE Package(s) COMPLETE $LOG_SPACER_SIGNS \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}
