cd $(cliferay home)
git add .
git stash
git checkout master
gh repo sync $(gh repo view --json nameWithOwner -q ".nameWithOwner")
gh repo sync
git push
