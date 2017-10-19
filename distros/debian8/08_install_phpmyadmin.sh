#---------------------------------------------------------------------
# Function: InstallPhpMyAdmin Debian 8
#    Install and configure PHPMyAdmin
#---------------------------------------------------------------------
InstallPHPMyAdmin() {
  	START_TIME=$SECONDS
	
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Installing PHPMyAdmin... ${NC}\n"	
	
	echo $CFG_MYSQL_ROOT_PWD
	echo
	
	MeasureTimeDuration $START_TIME
  
	if [ $CFG_PHPMYADMIN == "yes" ]; then
		
		echo -n -e "$IDENTATION_LVL_1 Selected version: ${green}$CFG_PHPMYADMIN_VERSION${NC}\n"
		
		export DEBIAN_FRONTEND=noninteractive
		
		echo -e "==========================================================================================="
		echo -e "Attention: If you will be asked ${green} 'Configure database for phpmyadmin with dbconfig-common?' ${NC} select ${red} 'NO' ${NC}"
		echo -e "Due to a bug in dbconfig-common, it is possible that this can't be automated."
		echo -e "==========================================================================================="
		echo -e "Press ENTER to continue... "
		read DUMMY
		
		echo -n -e "$IDENTATION_LVL_1 Set Reconfigure WebServer on debconf as ${BBlack}$CFG_WEBSERVER${NC} ... "
		if [ $CFG_WEBSERVER == "apache" ]; then
			echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections			
		else
			echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect " | debconf-set-selections
		fi
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Set dbconfig-common to ${BBlack}true${NC} ... "
		echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
		echo "dbconfig-common dbconfig-common/dbconfig-install boolean true" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections	
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Generate phpMyAdmin db password ... "
		APP_DB_PASS=$(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-32})
		echo -e " [ ${green}DONE${NC} ] "
		
		echo -n -e "$IDENTATION_LVL_1 Set passwords ... "	
		echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
		echo "phpmyadmin phpmyadmin/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
		echo -e " [ ${green}DONE${NC} ] "
		
		if [ $CFG_PHPMYADMIN_VERSION == "default" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Default Version ... "
			apt-get -y install phpmyadmin -t stable
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "jessie" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Jessie Backports Version ... "
			apt-get -y install phpmyadmin -t jessie-backports
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "stretch" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Stretch Version ... "
			apt-get -y install phpmyadmin -t stretch
			echo -e " [ ${green}DONE${NC} ] "
		elif [ $CFG_PHPMYADMIN_VERSION == "latest-stable" ]; then
			echo -n -e "$IDENTATION_LVL_1 Install Latest Stable Version ... "
			echo
			
			PMA_VER="`wget -q -O - https://www.phpmyadmin.net/downloads/|grep -m 1 '<h2>phpMyAdmin'|sed -r 's/^[^3-9]*([0-9.]*).*/\1/'`"
			echo -n -e "$IDENTATION_LVL_2 Version Available ${BBlack}$PMA_VER${NC} ... "
			echo
			
			echo -n -e "$IDENTATION_LVL_2 Make temporary directory ... "
			mkdir -p /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			
			echo -n -e "$IDENTATION_LVL_2 Download from PHPMyAdmin ... "
			wget -q -O "/tmp/phpmyadmin/phpMyAdmin-latest.tar.gz" "https://files.phpmyadmin.net/phpMyAdmin/${PMA_VER}/phpMyAdmin-${PMA_VER}-all-languages.tar.gz"
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Extract the downloaded file ... "
			tar zxf /tmp/phpmyadmin/phpMyAdmin-latest.tar.gz -C /tmp/phpmyadmin/
			echo -e " [ ${green}DONE${NC} ] "
		
			echo -n -e "$IDENTATION_LVL_2 Remove the downloaded file ... "
			rm -rf /tmp/phpmyadmin/phpMyAdmin-latest.tar.gz
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Make destination folder ... "
			mkdir -p /usr/local/share/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "

			echo -n -e "$IDENTATION_LVL_2 Ensure that the destination folder is empty ... "
			rm -rf /usr/local/share/phpmyadmin/*
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Copy current phpMyAdmin files to destination folder ... "
			cp -Rpf /tmp/phpmyadmin/*/* /usr/local/share/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Create the phpMyAdmin config file from sample ... "
			cp /usr/local/share/phpmyadmin/{config.sample.inc.php,config.inc.php}
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Remove the temporary folder ... "
			rm -rf /tmp/phpmyadmin
			echo -e " [ ${green}DONE${NC} ] "
			
			echo -n -e "$IDENTATION_LVL_2 Generate random blowfish string ... "

            LENGTH=64
            MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*_=-"
            while [ "${n:=1}" -le $LENGTH ]; do
                BLOWFISH="$BLOWFISH${MATRIX:$(($RANDOM%${#MATRIX})):1}"
                let n+=1
            done

			echo -e " [ ${green}DONE${NC} ] - ${red} $BLOWFISH {$NC}"
			
			echo $(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-64})
			echo $(< /dev/urandom tr -dc 'A-Z-a-z-0-9~!@#$%^&*_=-' | head -c${1:-64})
		fi
		
		unset DEBIAN_FRONTEND	
	else
		echo -n -e "$IDENTATION_LVL_1 SKIP INSTALL - Reason: ${red}Your Choice ${NC}\n"
	fi
  

  	MeasureTimeDuration $START_TIME

	exit 1;
}


# config-db.php - /etc/phpMyAdmin
# <?php
# ##
# ## database access settings in php format
# ## automatically generated from /etc/dbconfig-common/phpmyadmin.conf
# ## by /usr/sbin/dbconfig-generate-include
# ## Wed, 05 Apr 2017 03:31:40 +0300
# ##
# ## by default this file is managed via ucf, so you shouldn't have to
# ## worry about manual changes being silently discarded.  *however*,
# ## you'll probably also want to edit the configuration file mentioned
# ## above too.
# ##
# $dbuser='phpmyadmin';
# $dbpass='12345';
# $basepath='';
# $dbname='phpmyadmin';
# $dbserver='';
# $dbport='';
# $dbtype='mysql';


#/etc/phpmyadmin/config.inc.php
# <?php
# /**
 # * Debian local configuration file
 # *
 # * This file overrides the settings made by phpMyAdmin interactive setup
 # * utility.
 # *
 # * For example configuration see
 # *   /usr/share/doc/phpmyadmin/examples/config.sample.inc.php
 # * or
 # *   /usr/share/doc/phpmyadmin/examples/config.manyhosts.inc.php
 # *
 # * NOTE: do not add security sensitive data to this file (like passwords)
 # * unless you really know what you're doing. If you do, any user that can
 # * run PHP or CGI on your webserver will be able to read them. If you still
 # * want to do this, make sure to properly secure the access to this file
 # * (also on the filesystem level).
 # */

# if (!function_exists('check_file_access')) {
    # function check_file_access($path)
    # {
        # if (is_readable($path)) {
            # return true;
        # } else {
            # error_log(
                # 'phpmyadmin: Failed to load ' . $path
                # . ' Check group www-data has read access and open_basedir restrictions.'
            # );
            # return false;
        # }
    # }
# }

# // Load secret generated on postinst
# if (check_file_access('/var/lib/phpmyadmin/blowfish_secret.inc.php')) {
    # require('/var/lib/phpmyadmin/blowfish_secret.inc.php');
# }

# // Load autoconf local config
# if (check_file_access('/var/lib/phpmyadmin/config.inc.php')) {
    # require('/var/lib/phpmyadmin/config.inc.php');
# }

# /**
 # * Server(s) configuration
 # */
# $i = 0;
# // The $cfg['Servers'] array starts with $cfg['Servers'][1].  Do not use $cfg['Servers'][0].
# // You can disable a server config entry by setting host to ''.
# $i++;

# /**
 # * Read configuration from dbconfig-common
 # * You can regenerate it using: dpkg-reconfigure -plow phpmyadmin
 # */
# if (check_file_access('/etc/phpmyadmin/config-db.php')) {
    # require('/etc/phpmyadmin/config-db.php');
# }

# /* Configure according to dbconfig-common if enabled */
# if (!empty($dbname)) {
    # /* Authentication type */
    # $cfg['Servers'][$i]['auth_type'] = 'cookie';
    # /* Server parameters */
    # if (empty($dbserver)) $dbserver = 'localhost';
    # $cfg['Servers'][$i]['host'] = $dbserver;

    # if (!empty($dbport) || $dbserver != 'localhost') {
        # $cfg['Servers'][$i]['connect_type'] = 'tcp';
        # $cfg['Servers'][$i]['port'] = $dbport;
    # }
    # //$cfg['Servers'][$i]['compress'] = false;
    # /* Select mysqli if your server has it */
    # $cfg['Servers'][$i]['extension'] = 'mysqli';
    # /* Optional: User for advanced features */

 # /* Optional: User for advanced features */
    # $cfg['Servers'][$i]['controluser'] = $dbuser;
    # $cfg['Servers'][$i]['controlpass'] = $dbpass;
    # /* Optional: Advanced phpMyAdmin features */
    # $cfg['Servers'][$i]['pmadb'] = $dbname;
    # $cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
    # $cfg['Servers'][$i]['relation'] = 'pma__relation';
    # $cfg['Servers'][$i]['table_info'] = 'pma__table_info';
    # $cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
    # $cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
    # $cfg['Servers'][$i]['column_info'] = 'pma__column_info';
    # $cfg['Servers'][$i]['history'] = 'pma__history';
    # $cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
    # $cfg['Servers'][$i]['tracking'] = 'pma__tracking';
    # $cfg['Servers'][$i]['designer_coords'] = 'pma__designer_coords';
    # $cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
    # $cfg['Servers'][$i]['recent'] = 'pma__recent';
    # $cfg['Servers'][$i]['favorite'] = 'pma__favorite';
    # $cfg['Servers'][$i]['users'] = 'pma__users';
    # $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
    # $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
 # $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
    # $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
    # $cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';

    # /* Uncomment the following to enable logging in to passwordless accounts,
     # * after taking note of the associated security risks. */
    # // $cfg['Servers'][$i]['AllowNoPassword'] = TRUE;

    # /* Advance to next server for rest of config */
    # $i++;
# }

# /* Authentication type */
# //$cfg['Servers'][$i]['auth_type'] = 'cookie';
# /* Server parameters */
# //$cfg['Servers'][$i]['host'] = 'localhost';
# //$cfg['Servers'][$i]['connect_type'] = 'tcp';
# //$cfg['Servers'][$i]['compress'] = false;
# /* Select mysqli if your server has it */
# //$cfg['Servers'][$i]['extension'] = 'mysql';
# /* Optional: User for advanced features */
# // $cfg['Servers'][$i]['controluser'] = 'pma';
# // $cfg['Servers'][$i]['controlpass'] = 'pmapass';

# /* Storage database and tables */
# // $cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
# // $cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
# // $cfg['Servers'][$i]['relation'] = 'pma__relation';
# // $cfg['Servers'][$i]['table_info'] = 'pma__table_info';
# // $cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
# // $cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
# // $cfg['Servers'][$i]['column_info'] = 'pma__column_info';
# // $cfg['Servers'][$i]['history'] = 'pma__history';
# // $cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
# // $cfg['Servers'][$i]['tracking'] = 'pma__tracking';
# // $cfg['Servers'][$i]['designer_coords'] = 'pma__designer_coords';
# // $cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
# // $cfg['Servers'][$i]['recent'] = 'pma__recent';
# // $cfg['Servers'][$i]['favorite'] = 'pma__favorite';
# // $cfg['Servers'][$i]['recent'] = 'pma__recent';
# // $cfg['Servers'][$i]['favorite'] = 'pma__favorite';
# // $cfg['Servers'][$i]['users'] = 'pma__users';
# // $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
# // $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
# // $cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
# /* Uncomment the following to enable logging in to passwordless accounts,
 # * after taking note of the associated security risks. */
# // $cfg['Servers'][$i]['AllowNoPassword'] = TRUE;

# /*
 # * End of servers configuration
 # */

# /*
 # * Directories for saving/loading files from server
 # */
# $cfg['UploadDir'] = '';
# $cfg['SaveDir'] = '';

# /* Support additional configurations */
# foreach (glob('/etc/phpmyadmin/conf.d/*.php') as $filename)
# {
    # include($filename);
# }



