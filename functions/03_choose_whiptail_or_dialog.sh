#---------------------------------------------------------------------
# Function: CheckIPV6
#    Check Installed If IPV6 is supported by the OS
#---------------------------------------------------------------------

ChooseWhiptailOrDialog() {

    # Set IPV6_ENABLED variable to null
    INTERFACE_GENERATOR=''

    # check whether whiptail or dialog is installed
    # (choosing the first command found)
    read INTERFACE_GENERATOR <<< "$(which whiptail dialog 2> /dev/null)"

	# exit if none found
	[[ "$INTERFACE_GENERATOR" ]] {
		echo -n -e '${red} Interface Generator Error${BBlack}: Either whiptail nor dialog found${NC}'
		INTERFACE_GENERATOR='none'
	} else {
		echo -n -e '${green} Interface Generator${BBlack}: $INTERFACE_GENERATOR ${NC}'
	}
  
}

