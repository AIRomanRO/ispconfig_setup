function getYNFormat()
{
    local arg1=$1
    local shouldReturn
    echo -n -e "GetYNFormat($arg1)" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

    if [ $arg1 != "" ]; 
    then
        if [ $arg1 == true || $arg1 == "true" || $arg1 == "yes" || $arg1 == yes || $arg1 == "y" || $arg1 == y ];
        then 
            shouldReturn="y"
        else
            shouldReturn="n"
        fi
    else
        shouldReturn="n"
    fi

    echo -e "=> $shouldReturn" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

function getTrueFalseFormat()
{
    local arg1=$1
    local shouldReturn
    echo -n -e "getTrueFalseFormat($arg1)" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

    if [ $arg1 != "" ]; 
    then
        if [ $arg1 == true || $arg1 == "true" || $arg1 == "yes" || $arg1 == yes || $arg1 == "y" || $arg1 == y ];
        then 
            shouldReturn=true
        else
            shouldReturn=false
        fi
    else
        shouldReturn=false
    fi

    echo -e "=> $shouldReturn" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

function getTrueFalseFormatComparationEqual() {
    local arg1=$1
    local arg2=$2
    local shouldReturn
    echo -n -e "getTrueFalseFormatComparationEqual($arg1, $arg2)" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

    if [[ $arg1 == $arg2 ]]; then
        shouldReturn=true
    else
        shouldReturn=false
    fi

    echo -e "=> $shouldReturn" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}

function getTrueFalseFormatComparationNotEqual() {
    local arg1=$1
    local arg2=$2
    local shouldReturn
    echo -n -e "getTrueFalseFormatComparationNotEqual($arg1, $arg2)" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

    if [[ $arg1 != $arg2 ]]; then
        shouldReturn=true
    else
        shouldReturn=false
    fi

    echo -e "=> $shouldReturn" >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
}