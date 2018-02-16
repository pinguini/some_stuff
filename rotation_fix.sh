#!/bin/bash

mkdir -p /opt/citeck/scripts/


cat << EOF > /opt/citeck/scripts/gzip_remove.sh
cd /opt/alfresco*/

#gzipping old logs
find ./ -maxdepth 1 -iname "*.log.*" -not -iname "*.gz" -ctime +1 -exec gzip {} \;
#remove old logs
find ./ -maxdepth 1 -iname "*.log.*" -not -iname "*.gz" -ctime +14 -exec rm -f {} \;

cd ./tomcat/logs/
find ./ -maxdepth 1 -not -iname "*.gz" -ctime +1 -exec gzip {} \;
find ./ -maxdepth 1 -not -iname "*.gz" -ctime +14 -exec rm -f {} \;
EOF


chmod +x /opt/citeck/scripts/gzip_remove.sh
echo -e "\n\n10 *	* * *	root /opt/citeck/scripts/gzip_remove.sh > /dev/null 2>/dev/null\n\n" >> /etc/crontab


echo -e "/opt/alfresco*/tomcat/logs/catalina.out {\n   copytruncate\n   daily\n   rotate 3\n   compress\n   missingok\n}\n" > /etc/logrotate.d/tomcat-catalina





