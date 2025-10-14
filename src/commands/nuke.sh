cd $(cliferay home)
rm -rf ../bundles/elasticsearch7 ../bundles/data ../bundles/osgi/war ../bundles/osgi/state ../bundles2 $(cliferay tomcat-folder)/work/Catalina
echo "drop database IF EXISTS $(cliferay db-name); create database $(cliferay db-name) CHARACTER SET utf8 COLLATE utf8_general_ci" | mysql -uroot -proot