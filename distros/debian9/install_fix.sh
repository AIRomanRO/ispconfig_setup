InstallFix(){
	START_TIME=$SECONDS
	echo -n -e "$IDENTATION_LVL_0 ${BWhite}Make some Fixes on Install ${NC}\n"


	if [ $CFG_CERTBOT_VERSION == "default" ] || [ $CFG_CERTBOT_VERSION == "stretch" ]; then
		echo -n -e "$IDENTATION_LVL_1 ${BWhite}Generate LetsEncrypt SSL for $CFG_HOSTNAME_FQDN ${NC}"

		CERTBOOT_DOMAINS="-d $CFG_HOSTNAME_FQDN"
		if [ $CFG_WEBMAIL != "none" ];
		then
			CERTBOOT_DOMAINS="$CERTBOOT_DOMAINS -d webmail.$CFG_HOSTNAME_FQDN"
		fi

		if [ $CFG_WEBSERVER != "none" ];
		then
			CERTBOOT_DOMAINS="$CERTBOOT_DOMAINS -d apps.$CFG_HOSTNAME_FQDN -d manage.$CFG_HOSTNAME_FQDN"
		fi

  		certbot certonly --webroot -w /var/www/html/ $CERTBOOT_DOMAINS -n --text --agree-tos --rsa-key-size 4096 --email $CFG_INSTALL_EMAIL_ADR >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

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
	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Add Additional PHP versions on ISPConfig [ on System > Additional PHP Versions tab] ${NC} \n"
	SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=false
	SQL_FILE_NAME=$PROGRAMS_INSTALL_SQLS/addAdditionalPhpVersionsToISPConfig.sql
	echo -e -n "#Temp SQL for additional php versions \n" > $SQL_FILE_NAME
	for INSTALLED_PHP_VERSION in ${CFG_PHP_VERSION[@]};
    do
        case $INSTALLED_PHP_VERSION in
            "php7.0" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.0 ... "
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
            	echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.0', '/usr/bin/php-cgi7.0', '/etc/php/7.0/cgi/', '/etc/init.d/php7.0-fpm', '/etc/php/7.0/fpm/', '/etc/php/7.0/fpm/pool.d/'); " >> $SQL_FILE_NAME
            	echo -e " [ ${green}DONE${NC} ] "
		    ;;
            "php7.1" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.1 ... "
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
				echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.1', '/usr/bin/php-cgi7.1', '/etc/php/7.1/cgi/', '/etc/init.d/php7.1-fpm', '/etc/php/7.1/fpm/', '/etc/php/7.1/fpm/pool.d/'); " >> $SQL_FILE_NAME
				echo -e " [ ${green}DONE${NC} ] "
			;;
		    "php7.2" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.2"
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
				echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.2', '/usr/bin/php-cgi7.2', '/etc/php/7.2/cgi/', '/etc/init.d/php7.2-fpm', '/etc/php/7.2/fpm/', '/etc/php/7.2/fpm/pool.d/'); " >> $SQL_FILE_NAME
				echo -e " [ ${green}DONE${NC} ] "
		    ;;
			"php7.3" )
				echo -n -e "$IDENTATION_LVL_2 Generate SQL for php7.3"
				SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS=true
				echo "INSERT INTO server_php (server_php_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, server_id, client_id, name, php_fastcgi_binary, php_fastcgi_ini_dir, php_fpm_init_script, php_fpm_ini_dir, php_fpm_pool_dir) VALUES (NULL, '1', '1', 'riud', 'riud', NULL, '1', '0', 'PHP 7.3', '/usr/bin/php-cgi7.3', '/etc/php/7.3/cgi/', '/etc/init.d/php7.2-fpm', '/etc/php/7.3/fpm/', '/etc/php/7.3/fpm/pool.d/'); " >> $SQL_FILE_NAME
				echo -e " [ ${green}DONE${NC} ] "
		    ;;
        esac
    done

    if getTrueFalseFormatComparationEqual $SHOULD_INSERT_ADDITIONAL_PHP_VERSIONS true;
	then
		echo -n -e "$IDENTATION_LVL_2 Insert generated SQL ... "
        mysql -uroot -p$CFG_MYSQL_ROOT_PWD dbispconfig < $SQL_FILE_NAME >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
        echo -e " [ ${green}DONE${NC} ] "
    fi

	if getTrueFalseFormatComparationEqual $CFG_WEBMAIL "roundcube"; then
		echo -n -e "$IDENTATION_LVL_1 ${BWhite}Fix RoundCube Integration ${NC}"

		SQL_FILE_NAME=$PROGRAMS_INSTALL_SQLS/addRouncubeRemoteUserOnISPConfig.sql

		echo -e -n "#Temp SQL for RoundCube Integration \n" > $SQL_FILE_NAME
		echo "INSERT INTO remote_user (remote_userid, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, remote_username, remote_password, remote_functions) VALUES (1, 1, 1, 'riud', 'riud', '', 'roundcube', MD5('$CFG_ROUNDCUBE_PWD'), 'server_get,get_function_list,client_templates_get_all,server_get_serverid_by_ip,server_ip_get,server_ip_add,server_ip_update,server_ip_delete;client_get_all,client_get,client_add,client_update,client_delete,client_get_sites_by_user,client_get_by_username,client_change_password,client_get_id,client_delete_everything;mail_user_get,mail_user_add,mail_user_update,mail_user_delete;mail_alias_get,mail_alias_add,mail_alias_update,mail_alias_delete;mail_spamfilter_user_get,mail_spamfilter_user_add,mail_spamfilter_user_update,mail_spamfilter_user_delete;mail_policy_get,mail_policy_add,mail_policy_update,mail_policy_delete;mail_fetchmail_get,mail_fetchmail_add,mail_fetchmail_update,mail_fetchmail_delete;mail_spamfilter_whitelist_get,mail_spamfilter_whitelist_add,mail_spamfilter_whitelist_update,mail_spamfilter_whitelist_delete;mail_spamfilter_blacklist_get,mail_spamfilter_blacklist_add,mail_spamfilter_blacklist_update,mail_spamfilter_blacklist_delete;mail_user_filter_get,mail_user_filter_add,mail_user_filter_update,mail_user_filter_delete');" >> tmpSQL.sql
		mysql -uroot -p$CFG_MYSQL_ROOT_PWD dbispconfig < $SQL_FILE_NAME >> $PROGRAMS_INSTALL_LOG_FILES 2>&1		

		ln -s /usr/local/ispconfig/interface/ssl/ispserver.crt /usr/local/share/ca-certificates/ispserver.crt

		update-ca-certificates >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		if [ -f /etc/php/7.0/apache2/php.ini ]; then
			sed -i 's/;openssl.cafile=/openssl.cafile=\/etc\/ssl\/certs\/ca-certificates.crt/' /etc/php/7.0/apache2/php.ini
		fi

		if [ -f /etc/php/7.0/fpm/php.ini ]; then
			sed -i 's/;openssl.cafile=/openssl.cafile=\/etc\/ssl\/certs\/ca-certificates.crt/' /etc/php/7.0/fpm/php.ini
		fi

		sed -i 's/###//g' /etc/nginx/sites-available/webmail-roundcube.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/listen 80/###listen 80/g' /etc/nginx/sites-available/webmail-roundcube.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		echo -e " [ ${green}DONE${NC} ] "
	fi

	if getTrueFalseFormatComparationNotEqual $CFG_WEBSERVER "none";
	then
		sed -i 's/listen $CFG_ISPONCFIG_PORT;/listen $CFG_ISPONCFIG_PORT http2 ssl;/' /etc/nginx/sites-available/ispconfig.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/listen [::]:$CFG_ISPONCFIG_PORT ipv6only=on;/listen [::]:$CFG_ISPONCFIG_PORT ipv6only=on http2 ssl;/' /etc/nginx/sites-available/ispconfig.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/ssl_protocols TLSv1 TLSv1.1 TLSv1.2;/ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3/' /etc/nginx/sites-available/ispconfig.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/server_name _;/server_name manage.$CFG_HOSTNAME_FQDN;/' /etc/nginx/sites-available/ispconfig.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1

		sed -i 's/listen $CFG_ISPONCFIG_APPS_PORT;/listen $CFG_ISPONCFIG_APPS_PORT http2 ssl;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/listen [::]:$CFG_ISPONCFIG_APPS_PORT ipv6only=on;/listen [::]:$CFG_ISPONCFIG_APPS_PORT ipv6only=on http2 ssl;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/listen 8081;/listen $CFG_ISPONCFIG_APPS_PORT http2 ssl;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/listen [::]:8081 ipv6only=on;/listen [::]:$CFG_ISPONCFIG_APPS_PORT ipv6only=on http2 ssl;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/error_page 497 https:\/\/\$host:1002\$request_uri;/error_page 497 https:\/\/\$host:$CFG_ISPONCFIG_APPS_PORT\$request_uri;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/ssl off;/#ssl off;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/#ssl_protocols/ssl_protocols/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/#ssl_certificate/ssl_certificate/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/#ssl_certificate_key/ssl_certificate_key/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		sed -i 's/server_name _;/server_name apps.$CFG_HOSTNAME_FQDN;/' /etc/nginx/sites-available/apps.vhost >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi

	if [ $CFG_WEBSERVER == "apache" ]; then
		service apache2 reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php5-fpm reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	else
		service nginx force-reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
		service php7.0-fpm force-reload >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	fi

	echo -n -e "$IDENTATION_LVL_1 ${BWhite}Cleanup APT-GET ${NC}"
	apt-get autoremove >> $PROGRAMS_INSTALL_LOG_FILES 2>&1
	echo -e " [ ${green}DONE${NC} ] "

  	MeasureTimeDuration $START_TIME
}
