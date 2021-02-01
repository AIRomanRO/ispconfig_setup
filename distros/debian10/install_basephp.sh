#---------------------------------------------------------------------
# Function: InstallBasePhp Debian 8
#    Install Basic php need to run ispconfig
#---------------------------------------------------------------------
InstallBasePhp(){
  	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing basic php modules for ispconfig${NC}\n"

	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Installing needed components (php7.3) ${NC}\n"
  	package_install php-cli php-mysql php-mcrypt mcrypt php-mbstring
  	echo -e " [ ${green}DONE${NC} ] "

	MeasureTimeDuration $START_TIME
}
