InstallFix(){
	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Make some Fixes on Install ${NC}\n"


	if [ $CFG_CERTBOT_VERSION == "default" ] || [ $CFG_CERTBOT_VERSION == "stretch" ]; then
		echo -n -e "$IDENTATION_LVL_1 ${BWhite}Generate LetsEncrypt SSL for $CFG_HOSTNAME_FQDN ${NC}"
  		
  		certbot certonly --webroot -w /var/www/html/ -d $CFG_HOSTNAME_FQDN -n --text --agree-tos --rsa-key-size 4096 --email $CFG_INSTALL_EMAIL_ADR >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
  		
  		if [ -f /etc/letsencrypt/live/$CFG_HOSTNAME_FQDN/fullchain.pem ]; then
			cd /usr/local/ispconfig/interface/ssl/ >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			mv ispserver.crt ispserver.crt-$(date +"%y%m%d%H%M%S").bak >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			mv ispserver.key ispserver.key-$(date +"%y%m%d%H%M%S").bak >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

			ln -s /etc/letsencrypt/live/$CFG_HOSTNAME_FQDN/fullchain.pem ispserver.crt >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
			ln -s /etc/letsencrypt/live/$CFG_HOSTNAME_FQDN/privkey.pem ispserver.key >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		fi

  		echo -e " [ ${green}DONE${NC} ] "
  	fi

	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Fix Amavis Integration ${NC}"
	MYNET=`cat /etc/postfix/main.cf | grep "mynetworks =" | sed 's/mynetworks = //'`
	echo "@mynetworks = qw( $MYNET );" >> /etc/amavis/conf.d/20-debian_defaults
	if [ -f /etc/init.d/amavisd-new ]; then
		service amavisd-new restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	else
		service amavis restart >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi
	echo -e " [ ${green}DONE${NC} ] "

	#Make Additional PHP versions available on ISPConfig
	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Add Additional PHP versions on ISPConfig [ on System > Additional PHP Versions tab] ${NC}"
	SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=false
	echo -e -n "#Temp SQL for additional php versions \n" > tmpSQL.sql
	for INSTALLED_PHP_VERSION in ${CFG_PHP_VERSION[@]};
    do
        case $INSTALLED_PHP_VERSION in
            "php7.0" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.0 ... "
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
            	echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.0', '/usr/bin/php-cgi7.0', '/etc/php/7.0/cgi/', '/etc/init.d/php7.0-fpm', '/etc/php/7.0/fpm/', '/etc/php/7.0/fpm/pool.d/'); " >> tmpSQL.sql
            	echo -e " [ ${green}DONE${NC} ] "
		    ;;
            "php7.1" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.1 ... "
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
				echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.1', '/usr/bin/php-cgi7.1', '/etc/php/7.1/cgi/', '/etc/init.d/php7.1-fpm', '/etc/php/7.1/fpm/', '/etc/php/7.1/fpm/pool.d/'); " >> tmpSQL.sql
				echo -e " [ ${green}DONE${NC} ] "
			;;
		    "php7.2" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.2"
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
				echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.2', '/usr/bin/php-cgi7.2', '/etc/php/7.2/cgi/', '/etc/init.d/php7.2-fpm', '/etc/php/7.2/fpm/', '/etc/php/7.2/fpm/pool.d/'); " >> tmpSQL.sql
				echo -e " [ ${green}DONE${NC} ] "
		    ;;
        esac
    done	

    if [ SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS == true ];
	then
		echo -n -e "$IDENTATION_LVL_2 Insert generated SQL ... "
        mysql -uroot -p$CFG_MYSQL_ROOT_PWD dbispconfig < tmpSQL.sql >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
        echo -e " [ ${green}DONE${NC} ] "
    fi

    rm -f tmpSQL.sql
	echo -e " [ ${green}DONE${NC} ] "


	if [ $CFG_WEBMAIL == "roundcube" ]; then
		echo -n -e "$IDENTATION_LVL_1 ${BWhite}Fix RoundCube Integration ${NC}"

		echo -e -n "#Temp SQL for RoundCube Integration \n" > tmpSQL.sql
		echo "INSERT INTO remote_user (remote_userid, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, remote_username, remote_password, remote_functions) VALUES (1, 1, 1, 'riud', 'riud', '', 'roundcube', MD5('$CFG_ROUNDCUBE_PWD'), 'server_get,get_function_list,client_templates_get_all,server_get_serverid_by_ip,server_ip_get,server_ip_add,server_ip_update,server_ip_delete;client_get_all,client_get,client_add,client_update,client_delete,client_get_sites_by_user,client_get_by_username,client_change_password,client_get_id,client_delete_everything;mail_user_get,mail_user_add,mail_user_update,mail_user_delete;mail_alias_get,mail_alias_add,mail_alias_update,mail_alias_delete;mail_spamfilter_user_get,mail_spamfilter_user_add,mail_spamfilter_user_update,mail_spamfilter_user_delete;mail_policy_get,mail_policy_add,mail_policy_update,mail_policy_delete;mail_fetchmail_get,mail_fetchmail_add,mail_fetchmail_update,mail_fetchmail_delete;mail_spamfilter_whitelist_get,mail_spamfilter_whitelist_add,mail_spamfilter_whitelist_update,mail_spamfilter_whitelist_delete;mail_spamfilter_blacklist_get,mail_spamfilter_blacklist_add,mail_spamfilter_blacklist_update,mail_spamfilter_blacklist_delete;mail_user_filter_get,mail_user_filter_add,mail_user_filter_update,mail_user_filter_delete');" >> tmpSQL.sql
		mysql -uroot -p$CFG_MYSQL_ROOT_PWD dbispconfig < tmpSQL.sql >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		rm -f tmpSQL.sql

		ln -s /usr/local/ispconfig/interface/ssl/ispserver.crt /usr/local/share/ca-certificates/ispserver.crt

		update-ca-certificates >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		if [ -f /etc/php/7.0/apache2/php.ini ]; then
			sed -i 's/;openssl.cafile=/openssl.cafile=\/etc\/ssl\/certs\/ca-certificates.crt/' /etc/php/7.0/apache2/php.ini
		fi

		if [ -f /etc/php/7.0/fpm/php.ini ]; then
			sed -i 's/;openssl.cafile=/openssl.cafile=\/etc\/ssl\/certs\/ca-certificates.crt/' /etc/php/7.0/fpm/php.ini
		fi
		
		echo -e " [ ${green}DONE${NC} ] "
	fi

	if [ $CFG_WEBSERVER == "apache" ]; then
		service apache2 reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php5-fpm reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	else
		service nginx force-reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php5-fpm force-reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi

	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Cleanup APT-GET ${NC}"
	apt-get autoremove >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -e " [ ${green}DONE${NC} ] "
	
  	MeasureTimeDuration $START_TIME
}
