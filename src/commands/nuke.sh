cd $(cliferay home)
rm -rf ../bundles/elasticsearch* ../bundles/data ../bundles/osgi/war ../bundles/osgi/state $(cliferay tomcat-folder)/work/Catalina
echo "drop database IF EXISTS $(cliferay db-name); create database $(cliferay db-name) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin" | mysql -uroot -proot