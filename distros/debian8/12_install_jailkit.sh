#---------------------------------------------------------------------
# Function: InstallJailkit
#    Install Jailkit
#---------------------------------------------------------------------

#Program Versions
JKV="2.19"  #Jailkit Version -> Maybe this can be automated

InstallJailkit() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing JailKit${NC}\n" 

  echo -n -e "$IDENTATION_LVL_1 Try to detect current version ... "
  DETECTED_VER="`wget -q -O - http://olivier.sessink.nl/jailkit/|grep -m 1 'jailkit-.*\.tar\.gz'|sed -r 's/.*jailkit\-([0-9.]*)\..*/\1/g'`"
  echo -n -e "${red} $DETECTED_VER ${NC}"
  echo -e " [ ${green}DONE${NC} ] "

  if [ $JKV \< $DETECTED_VER ]; then
    JKV=$DETECTED_VER
  fi

  echo -n -e "$IDENTATION_LVL_1 We will install version $JKV \n"

  echo -n -e "$IDENTATION_LVL_1 Install needed tools"
  package_install build-essential autoconf automake libtool flex bison debhelper binutils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Download and make JailKit Version: $JKV "
  cd /tmp
  wget -q http://olivier.sessink.nl/jailkit/jailkit-$JKV.tar.gz
  tar xfz jailkit-$JKV.tar.gz
  cd jailkit-$JKV
  ./debian/rules binary >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Install JailKit"
  cd ..
  dpkg -i jailkit_$JKV-1_*.deb >> $PROGRAMS_INSTALL_LOG_FILES 2>&1  
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 Cleanup ... "
  rm -rf jailkit-$JKV
  rm -f /tmp/jailkit-$JKV.tar.gz
  rm -rf /tmp/jailkit-$JKV
  rm -f /tmp/jailkit_$JKV-1_*.deb
  echo -e " [ ${green}DONE${NC} ] "

  MeasureTimeDuration $START_TIME
}
