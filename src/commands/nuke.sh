cd $(cliferay folder)
rm -rf ../bundles/elasticsearch7 ../bundles/data ../bundles/osgi/state ../bundles/tomcat-9.0.75/work/Catalina
echo "drop database lportal; create database lportal CHARACTER SET utf8mb4 COLLATE utf8mb4_bin" | mysql -uroot -proot