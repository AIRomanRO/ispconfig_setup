#---------------------------------------------------------------------
# Function: CheckLinux
#    Check Installed Linux Version
#---------------------------------------------------------------------

CheckLinux() {

  #Extract information on system
  . /etc/os-release

  # Set DISTRO variable to null
  DISTRO=''

  if echo "$ID" | grep -iq "debian"; then

    #---------------------------------------------------------------------
    #	Debian 7 Wheezy
    #---------------------------------------------------------------------

    if echo "$VERSION_ID" | grep -iq "7"; then
      DISTRO=debian7

    #---------------------------------------------------------------------
    #	Debian 8 Jessie
    #---------------------------------------------------------------------

    elif echo "$VERSION_ID" | grep -iq "8"; then
      DISTRO=debian8

    #---------------------------------------------------------------------
    #	Debian 9 Stretch
    #---------------------------------------------------------------------

    elif echo "$VERSION_ID" | grep -iq "9"; then
      DISTRO=debian9

    #---------------------------------------------------------------------
    #	Debian 10 Buster
    #---------------------------------------------------------------------

    elif echo "$VERSION_ID" | grep -iq "10"; then
      DISTRO=debian10
    fi

  fi

}
