cd $(cliferay folder)
if [ ! -d "../liferay-intellij" ]; then
    gh repo clone holatuwol/liferay-intellij "../liferay-intellij"
fi
(cd ../liferay-intellij; git pull)
../liferay-intellij/intellij
