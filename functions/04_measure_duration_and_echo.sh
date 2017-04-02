#---------------------------------------------------------------------
# Function: MeasureTimeDuration
#    Calculate the duration and display it
#---------------------------------------------------------------------

MeasureTimeDuration() {
	if [ -z "$1" ]                           # Is parameter #1 zero length?
		then
		echo "-Parameter #1 is zero length."  # Or no parameter passed.
	else
		ELAPSED_TIME=$(($SECONDS - $1))
		echo 
		echo -n -e "$IDENTATION_LVL_0 ${green}Completed ON ${NC}"
		echo -e ": ${red} $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
		echo -e "${NC}"	
		echo -n -e " "
	fi	
}

