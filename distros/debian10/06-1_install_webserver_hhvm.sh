#---------------------------------------------------------------------
# Function: InstallHHVM
#    Install and configure HHVM webserver
#---------------------------------------------------------------------

InstallHHVM() {
	START_TIME=$SECONDS 
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing HHVM Server${NC} \n"

  	if [ $CFG_HHVM = "yes" ]; then
	    echo -n -e "$IDENTATION_LVL_1 Add hhvm keys and sources ... "
	    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xB4112585D386EB94 >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	    echo deb http://dl.hhvm.com/debian jessie main | sudo tee /etc/apt/sources.list.d/hhvm.list >> $PROGRAMS_INSTALL_LOG_FILES 2>&1  
	    echo -e "[ ${green}DONE${NC} ] "

	    echo -n -e "$IDENTATION_LVL_1 Update packages list ... "
	    package_update
	    echo -e "[ ${green}DONE${NC} ] "

	    echo -n -e "$IDENTATION_LVL_1 Install HHVM ... "
	    package_install hhvm
	    echo -e "[ ${green}DONE${NC} ] "
	else
		echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
  	fi

  	MeasureTimeDuration $START_TIME
}
