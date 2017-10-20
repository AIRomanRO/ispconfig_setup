#---------------------------------------------------------------------
# Function: InstallSQLServer
#    Install and configure SQL Server
#---------------------------------------------------------------------
InstallSQLServer() {
	START_TIME=$SECONDS
	if [ $CFG_SQLSERVER == "MySQL" ]; then
		echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing MySQL${NC}\n"	
		echo -n -e "$IDENTATION_LVL_1 Selected version: ${BBlack}$CFG_MYSQL_VERSION${NC}\n"
		
		if [ $CFG_MYSQL_VERSION == "default" ]; then
		
			echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			apt-get -y install mysql-client mysql-server >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/my.cnf	
			echo "
	* This is neccesary for ISPConfig installation
	[mysqld]
	sql-mode='NO_ENGINE_SUBSTITUTION'
	" >> /etc/mysql/conf.d/mysqld_sql_mode.cnf

		elif [ $CFG_MYSQL_VERSION == "5.6" ]; then
		
			echo -n -e "$IDENTATION_LVL_1 Downloading the MySQL APT Config [ ${BBlack}Version 0.8.3.1 ${NC}] ... "
			wget -q -O "mysql-apt-config-all.deb" "https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb"
			echo -e " [ ${green}DONE${NC} ] "
			
			export DEBIAN_FRONTEND=noninteractive
			
			echo -n -e "$IDENTATION_LVL_1 Set Selections on debconf ... "
			#echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-tools select  Enabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.6" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "

			#wget https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb && dpkg -i mysql-apt-config_0.8.3-1_all.deb >> $PROGRAMS_INSTALL_LOG_FILES		
			#apt-get -qq update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			
			echo -n -e "$IDENTATION_LVL_1 Run the MySql APT Config ... "
			dpkg -i mysql-apt-config-all.deb >> $PROGRAMS_INSTALL_LOG_FILES 2>&1	
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_1 Update the Packages List ... "
			apt-get -qq update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "		
			
			echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			
			echo -n -e "$IDENTATION_LVL_1 Install MySQL Server & Client ... "
			apt-get -qq install mysql-server mysql-client >> $PROGRAMS_INSTALL_LOG_FILES
			echo -e " [ ${green}DONE${NC} ] "
			
			echo "[mysqld]
	sql-mode='NO_ENGINE_SUBSTITUTION'
	" >> /etc/mysql/conf.d/mysqld_sql_mode.cnf

			unset DEBIAN_FRONTEND
			
		elif [ $CFG_MYSQL_VERSION == "5.7" ] || [ $CFG_MYSQL_VERSION == "8.0" ];  then
		
			MYSQLAPTVER="`wget -q -O - https://repo.mysql.com/|grep -E -o 'mysql-apt-config_([0-9]|[\.-])+_all\.deb' | tail -1`"

			echo -n -e "$IDENTATION_LVL_1 Downloading the MySQL APT Config [ ${BBlack}Version $MYSQLAPTVER ${NC}] ... "
			wget -q -O "mysql-apt-config-all.deb" "https://repo.mysql.com/$MYSQLAPTVER"

			echo -e " [ ${green}DONE${NC} ] "
			
			export DEBIAN_FRONTEND=noninteractive
			
			echo -n -e "$IDENTATION_LVL_1 Set Selections on debconf ... "
			echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-tools select  Enabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-server select mysql-$CFG_MYSQL_VERSION" | debconf-set-selections
			#echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_1 Run the MySql APT Config ... "
			dpkg -i mysql-apt-config-all.deb >> $PROGRAMS_INSTALL_LOG_FILES 2>&1	
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "$IDENTATION_LVL_1 Update the Packages List ... "
			apt-get -qq update >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_1 Set the selected MySQL Password to MySQL Installer ... "
			echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_1 Install MySQL Server & Client ... "
			apt-get -yqq install mysql-server mysql-client >> $PROGRAMS_INSTALL_LOG_FILES
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_1 Change the SQL MODE ... "
			echo 'sql-mode="NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/mysql.conf.d/mysqld.cnf
			echo -e " [ ${green}DONE${NC} ] "
			
			unset DEBIAN_FRONTEND
			
		else
			echo -n "$IDENTATION_LVL_0 MySQL version NOT SUPPORTED"
		fi
		
		echo -n -e "$IDENTATION_LVL_1 Restart the MySQL Service ... "
		service mysql restart >> $PROGRAMS_INSTALL_LOG_FILES
		echo -e "[${green}DONE${NC}] "
  
    elif [ $CFG_SQLSERVER == "MariaDB" ]; then
  
		echo -n "$IDENTATION_LVL_0 Installing MariaDB... "
		echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		apt-get -y install mariadb-client mariadb-server >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/my.cnf
		service mysql restart /dev/null 2>&1
		echo -e "[${green}DONE${NC}]\n"
	
    else
  
		echo -n "${red}No installation of DB server... ${NC}"

	fi
  
	MeasureTimeDuration $START_TIME
}
