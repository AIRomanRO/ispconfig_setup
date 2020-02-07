#---------------------------------------------------------------------
# Function: InstallQuota
#    Install and configure of disk quota
#---------------------------------------------------------------------
InstallQuota() {
  START_TIME=$SECONDS

  echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing Quota${NC} \n"

  package_install quota quotatool >>$PROGRAMS_INSTALL_LOG_FILES 2>&1

  echo -n -e "$IDENTATION_LVL_1 Initializing Quota (this might take while) ... "

  if ! [ -f /proc/user_beancounters ]; then
    if [ $(cat /etc/fstab | grep ',usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0' | wc -l) -eq 0 ]; then
      sed -i '/tmpfs/!s/errors=remount-ro/errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/' /etc/fstab
    fi

    if [ $(cat /etc/fstab | grep 'defaults' | wc -l) -ne 0 ]; then
      sed -i '/tmpfs/!s/defaults/defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/' /etc/fstab
    fi

    mount -o remount /
    quotacheck -avugm >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
    quotaon -avug >>$PROGRAMS_INSTALL_LOG_FILES 2>&1
  fi

  echo -e " [ ${green}DONE${NC} ] "

  MeasureTimeDuration $START_TIME
}
