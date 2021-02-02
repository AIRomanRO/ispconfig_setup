#---------------------------------------------------------------------
# Function: PreInstallCheck
#    Do some pre-install checks
#---------------------------------------------------------------------
PreInstallCheck() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Check the stuffs before install ${NC} \n"

  echo -n -e "$IDENTATION_LVL_1 Check if current user is root"
  # Check if user is root
  if [ $(id -u) != "0" ]; then
    echo -e " [ ${red}Error${NC}: You must be root to run this script, please use the root user to install the software ]"
    exit 1
  fi
  echo -e " [ ${green}OK${NC} ]"

  # Check memory
  echo -n -e "$IDENTATION_LVL_1 Check Available RAM Memory"

  TOTAL_PHYSICAL_MEM=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
  TOTAL_SWAP=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)

  if [ "$TOTAL_PHYSICAL_MEM" -lt 524288 ]; then
    TOTAL_RAM_MiB_HUMAN=$(printf "%'d" $(($TOTAL_PHYSICAL_MEM / 1024)))
    TOTAL_RAM_MB_HUMAN=$(printf "%'d" $(((($TOTAL_PHYSICAL_MEM * 1024) / 1000) / 1000)))
    echo "This machine has: $TOTAL_RAM_MiB_HUMAN MiB $TOTAL_RAM_MB_HUMAN MB memory (RAM)."
    echo -e "\n${red}Error: ISPConfig needs more memory to function properly. Please run this script on a machine with at least 512 MiB memory, 1 GiB (1024 MiB) recommended.${NC}" >&2
    exit 1
  fi

  # Check connectivity
  echo -n "$IDENTATION_LVL_1 Check if we can reach the ISPConfig servers ... "
  ping -q -c 3 www.ispconfig.org -4 >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  if [ ! "$?" -eq 0 ]; then
    echo -e "[ ${red}ERROR ${NC} : Couldn't reach www.ispconfig.org, please check your internet connection ${NC} ]"
    exit 1
  else
    echo -e " [ ${green}OK${NC} ]"
  fi

  echo -n "$IDENTATION_LVL_1 Check if a previous version of ISPConfig is installed ... "
  # Check for already installed ispconfig version
  if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
    echo -e "[ ${red}ERROR ${NC} : ISPConfig is already installed, can't go on${NC} ]"
    exit 1
  else
    echo -e " [ ${green}OK${NC} ]"
  fi

  #echo -n -e "Check for pre-required packages:\n"
  #echo -n -e "Pre Install Check [ ${green}Completed${NC} ]\n"

  MeasureTimeDuration $START_TIME
}
