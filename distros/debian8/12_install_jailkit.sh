#---------------------------------------------------------------------
# Function: InstallJailkit
#    Install Jailkit
#---------------------------------------------------------------------

#Program Versions
JKV="2.19"  #Jailkit Version -> Maybe this can be automated

InstallJailkit() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing JailKit ... ${NC}\n" 

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}Try to detect current version ... ${NC}"
  DETECTED_VER="`wget -q -O - http://olivier.sessink.nl/jailkit/|grep -m 1 'jailkit-.*\.tar\.gz'|sed -r 's/.*jailkit\-([0-9.]*)\..*/\1/g'`"
  echo -n -e "${red} $DETECTED_VER ${NC}"
  echo -e " [ ${green}DONE${NC} ] "

  if [ $JKV \< $DETECTED_VER ]; then
    JKV=$DETECTED_VER
  fi

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}We will install version $JKV ${NC} \n"

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}Install needed tools ${NC}"
  apt-get -y install build-essential autoconf automake libtool flex bison debhelper binutils >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}Download and make JailKit Version: $JKV ${NC}"
  cd /tmp
  wget -q http://olivier.sessink.nl/jailkit/jailkit-$JKV.tar.gz
  tar xfz jailkit-$JKV.tar.gz
  cd jailkit-$JKV
  ./debian/rules binary >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}Install JailKit ${NC}"
  cd ..
  dpkg -i jailkit_$JKV-1_*.deb >> $PROGRAMS_INSTALL_LOG_FILES 2>&1  
  echo -e " [ ${green}DONE${NC} ] "

  echo -n -e "$IDENTATION_LVL_1 ${BWhite}Cleanup ... ${NC}"
  rm -rf jailkit-$JKV
<<<<<<< HEAD
  rm -f /tmp/jailkit-$JKV.tar.gz
  rm -rf /tmp/jailkit-$JKV
  echo -e " [ ${green}DONE${NC} ] "

  MeasureTimeDuration $START_TIME

=======
  echo -e " [ ${green}DONE${NC} ] "

>>>>>>> e5f4063952cf0f34decf706e334304934a1d4486
  exit 1;
}
