cd $(cliferay home)
git add .
git stash
git checkout master
gh repo sync --source liferay/liferay-portal --force
git push --force
