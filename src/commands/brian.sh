PR=${args["pr"]}
echo "Checking out $PR"
gh pr checkout -f $PR
echo "Creating Brian's PR from $PR"
BRANCH=$(git rev-parse --abbrev-ref HEAD)-brian
git branch -D $BRANCH &>/dev/null || true
git checkout -b $BRANCH
git push -f origin $BRANCH
git branch -u origin/$BRANCH
BRIAN_PR=$(gh pr create --title "$(gh pr view $PR --json title --jq .title)" --body "$(gh pr view $PR --json body --jq .body)" -R brianchandotcom/liferay-portal)
sleep 2
gh pr comment $BRIAN_PR --body "ci:reopen"
echo "Closing $PR"
gh pr comment $PR --body "$BRIAN_PR"
gh pr close $PR
echo $BRIAN_PR