#---------------------------------------------------------------------
# Function: CheckIPV6
#    Check Installed If IPV6 is supported by the OS
#---------------------------------------------------------------------

CheckIPV6() {

  # Set IPV6_ENABLED variable to null
  IPV6_ENABLED=''

  if [ -f /proc/net/if_inet6 ]; then
    IPV6_ENABLED=true
  else
    IPV6_ENABLED=false
  fi
  
}

