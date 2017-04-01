#---------------------------------------------------------------------
# Function: ChooseWhiptailOrDialog
#    Check if Whiptail or Dialog is supported by the OS
#---------------------------------------------------------------------

ChooseWhiptailOrDialog() {

    # Set INTERFACE_GENERATOR variable to null
    INTERFACE_GENERATOR=''

    # check whether whiptail or dialog is installed
    # (choosing the first command found)
    read INTERFACE_GENERATOR <<< "$(which whiptail dialog 2> /dev/null)"

	# notify if none found
	if [[ -z "${INTERFACE_GENERATOR// }" ]]; then		
		INTERFACE_GENERATOR='none'
	fi  
}

