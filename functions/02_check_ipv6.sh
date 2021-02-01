#---------------------------------------------------------------------
# Function: CheckIPV6
#    Check Installed If IPV6 is supported by the OS
#---------------------------------------------------------------------

CheckIPV6() {

	# Set IPV6_ENABLED variable to null
	IPV6_ENABLED=false
	CFG_IPV4=$(ip route get 8.8.8.8 > /dev/null | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | awk '{print $1}')

	if [ -f /proc/net/if_inet6 ]; then
		CFG_IPV6=$(ip route get 2001:4860:4860::8888 > /dev/null | grep -E -i -w 'error|unreachable')
		if [ -z $CFG_IPV6 ]; then
			CFG_IPV6=$(ip route get 2001:4860:4860::8888 > /dev/null | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | awk 'NR==1 {print $(NF-2)}')
			IPV6_ENABLED=true
		else
			IPV6_ENABLED=false
			CFG_IPV6=''
		fi
	else
		CFG_IPV6=''
		IPV6_ENABLED=false
	fi
  
}

