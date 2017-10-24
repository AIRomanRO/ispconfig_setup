#---------------------------------------------------------------------
# Function: Multiple apt-get wrappers
#    Update / Install / Clean / Upgrade apg-get wrappers
#---------------------------------------------------------------------

# Install Package(s)
function package_install() {
	echo -n -e " ===== INSTALL Package(s) \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== $@ \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ======================== \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

	apt-get -y --force-yes install "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== INSTALL Package(s) COMPLETE ========= \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Update Package(s)
function package_update() {
	echo -n -e " ===== UPDATE Package(s) \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== UPDATE Package(s) COMPLETE ========= \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Uninstall Package(s)
function package_uninstall() {
	echo -n -e " ===== UNINSTALL Package(s) \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== $@ \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ======================== \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq purge  "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== UNINSTALL Package(s) COMPLETE ========= \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Remove Package(s)
function package_remove() {
	echo -n -e " ===== REMOVE Package(s) \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== $@ \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ======================== \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq remove "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== REMOVE Package(s) COMPLETE ========= \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

# Remove Package(s)
function package_purge_remove() {
	echo -n -e " ===== REMOVE Package(s) \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== $@ \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ======================== \n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	apt-get -yqq remove --purge "$@" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -n -e " ===== REMOVE Package(s) COMPLETE ========= \n\n" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}
