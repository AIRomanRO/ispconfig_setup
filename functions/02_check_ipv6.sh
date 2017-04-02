#---------------------------------------------------------------------
# Function: CheckIPV6
#    Check Installed If IPV6 is supported by the OS
#---------------------------------------------------------------------

CheckIPV6() {

	# Set IPV6_ENABLED variable to null
	IPV6_ENABLED=''
	CFG_IPV4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

	if [ -f /proc/net/if_inet6 ]; then
		CFG_IPV6=$(ip route get 2001:4860:4860::8888 | awk 'NR==1 {print $(NF-2)}')
		IPV6_ENABLED=true
	else
		CFG_IPV6=''
		IPV6_ENABLED=false
	fi
  
}

