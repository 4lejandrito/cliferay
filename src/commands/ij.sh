cd $(cliferay home)
if [ ! -d "../liferay-intellij" ]; then
    git clone https://github.com/holatuwol/liferay-intellij.git "../liferay-intellij"
fi
(cd ../liferay-intellij; git pull)
../liferay-intellij/intellij
