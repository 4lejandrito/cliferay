cd $(cliferay home)
git add .
git stash
git checkout master
gh repo sync $(gh repo view --json nameWithOwner -q ".nameWithOwner") --force
gh repo sync --force
git push
