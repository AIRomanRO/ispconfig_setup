#---------------------------------------------------------------------
# Function: InstallSQLServer
#    Install and configure SQL Server
#---------------------------------------------------------------------
InstallSQLServer() {
  if [ $CFG_SQLSERVER == "MySQL" ]; then
    echo -n "Installing MySQL... \n"	
	echo -n "Selected version: $CFG_MYSQL_VERSION\n"
	
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
	
		export DEBIAN_FRONTEND=noninteractive
		
		echo "mysql-apt-config mysql-apt-config/select-product select Apply" | debconf-set-selections
		echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.6" | debconf-set-selections
		echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
		
		wget https://repo.mysql.com/mysql-apt-config_0.8.3-1_all.deb && dpkg -i mysql-apt-config_0.8.3-1_all.deb > /dev/null		
		apt-get -qq update > /dev/null 2>&1
		
		echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		
		apt-get -qq install mysql-server mysql-client > /dev/null
		
		echo "[mysqld]
sql-mode='NO_ENGINE_SUBSTITUTION'
" >> /etc/mysql/conf.d/mysqld_sql_mode.cnf

		unset DEBIAN_FRONTEND
		
	elif [ $CFG_MYSQL_VERSION == "5.7" ]; then
	
		export DEBIAN_FRONTEND=noninteractive
		
		echo "mysql-apt-config mysql-apt-config/select-product select Apply" | debconf-set-selections
		echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
		echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
		
		wget https://repo.mysql.com/mysql-apt-config_0.8.1-1_all.deb && dpkg -i mysql-apt-config_0.8.1-1_all.deb > /dev/null		
		apt-get -qq update > /dev/null 2>&1
		
		echo "mysql-community-server mysql-community-server/root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo "mysql-community-server mysql-community-server/re-root-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		
		apt-get -qq install mysql-server mysql-client > /dev/null
		
		echo 'sql-mode="NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/mysql.conf.d/mysqld.cnf
		unset DEBIAN_FRONTEND
		
	else
		echo -n "MySQL version NOT SUPPORTED"
		exit 1
	fi
	
    service mysql restart > /dev/null
    echo -e "[${green}DONE${NC}]\n"
  
  elif [ $CFG_SQLSERVER == "MariaDB" ]; then
  
    echo -n "Installing MariaDB... "
    echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    apt-get -y install mariadb-client mariadb-server > /dev/null 2>&1
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/my.cnf
    service mysql restart /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"
	
  else
  
	echo -n "No installation of DB server... "

  fi
  
  	echo -e "[${green}DONE${NC}]\n"
}
