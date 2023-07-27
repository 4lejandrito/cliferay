cd $(cliferay folder)
gh repo sync $(gh repo view --json nameWithOwner -q ".nameWithOwner")
gh repo sync
git push
