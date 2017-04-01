#---------------------------------------------------------------------
# Function: InstallSQLServer
#    Install and configure SQL Server
#---------------------------------------------------------------------
InstallSQLServer() {
	START_TIME=$SECONDS
	if [ $CFG_SQLSERVER == "MySQL" ]; then
		echo -n -e "Installing MySQL... \n"	
		echo -n -e "   --- Selected version: ${BBlack}$CFG_MYSQL_VERSION${NC}\n"
		
		if [ $CFG_MYSQL_VERSION == "default" ]; then
		
			echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			apt-get -y install mysql-client mysql-server > /dev/null 2>&1
			sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/my.cnf	
			echo "
	* This is neccesary for ISPConfig installation
	[mysqld]
	sql-mode='NO_ENGINE_SUBSTITUTION'
	" >> /etc/mysql/conf.d/mysqld_sql_mode.cnf

		elif [ $CFG_MYSQL_VERSION == "5.6" ]; then
		
			echo -n -e "   --- Downloading the MySQL APT Config [${BBlack}Version 0.8.3.1${NC}] ... "
			wget -q -O "mysql-apt-config-all.deb" "https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb"
			echo -e " [ ${green}DONE${NC} ] "
			
			export DEBIAN_FRONTEND=noninteractive
			
			echo -n -e "   --- Set Selections on debconf ... "
			#echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-tools select  Enabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.6" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "

			#wget https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb && dpkg -i mysql-apt-config_0.8.3-1_all.deb > /dev/null		
			#apt-get -qq update > /dev/null 2>&1
			
			echo -n -e "   --- Run the MySql APT Config ... "
			dpkg -i mysql-apt-config-all.deb > /dev/null 2>&1	
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "   --- Update the Packages List ... "
			apt-get -qq update > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ] "		
			
			echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			
			echo -n -e "   --- Install MySQL Server & Client ... "
			apt-get -qq install mysql-server mysql-client > /dev/null
			echo -e " [ ${green}DONE${NC} ] "
			
			echo "[mysqld]
	sql-mode='NO_ENGINE_SUBSTITUTION'
	" >> /etc/mysql/conf.d/mysqld_sql_mode.cnf

			unset DEBIAN_FRONTEND
			
		elif [ $CFG_MYSQL_VERSION == "5.7" ]; then
		
			echo -n -e "   --- Downloading the MySQL APT Config [${BBlack}Version 0.8.3.1${NC}] ... "
			wget -q -O "mysql-apt-config-all.deb" "https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb"
			echo -e " [ ${green}DONE${NC} ] "
			
			export DEBIAN_FRONTEND=noninteractive
			
			echo -n -e "   --- Set Selections on debconf ... "
			echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-tools select  Enabled" | debconf-set-selections
			echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
			#echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "   --- Run the MySql APT Config ... "
			dpkg -i mysql-apt-config-all.deb > /dev/null 2>&1	
			echo -e " [ ${green}DONE${NC} ]"
			
			echo -n -e "   --- Update the Packages List ... "
			apt-get -qq update > /dev/null 2>&1
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "   --- Set the selected MySQL Password to MySQL Installer ... "
			echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "   --- Install MySQL Server & Client ... "
			apt-get -yqq install mysql-server mysql-client > /dev/null
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "   --- Change the SQL MODE ... "
			echo 'sql-mode="NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/mysql.conf.d/mysqld.cnf
			echo -e " [ ${green}DONE${NC} ] "
			
			unset DEBIAN_FRONTEND
			
		else
			echo -n "MySQL version NOT SUPPORTED"
			exit 1
		fi
		
		echo -n -e "   --- Restart the MySQL Service ... "
		service mysql restart > /dev/null
		echo -e "[${green}DONE${NC}] "
  
    elif [ $CFG_SQLSERVER == "MariaDB" ]; then
  
		echo -n "Installing MariaDB... "
		echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		apt-get -y install mariadb-client mariadb-server > /dev/null 2>&1
		sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/my.cnf
		service mysql restart /dev/null 2>&1
		echo -e "[${green}DONE${NC}]\n"
	
    else
  
		echo -n "${red}No installation of DB server... ${NC}"

	fi
  
	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	echo ""
  	echo -n -e "${green}MySQL Installation Completed${NC}"
	echo -e " - DURATION: ${red} $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
	echo -e "${NC}"
	
	echo -n -e " "
	
	exit 1;
}
