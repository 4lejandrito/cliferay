cd $(cliferay home)
get_current_period
echo "This period (${since%%T*} - ${until%%T*}) ${args[user]} has:"
echo ""
echo "Contributed code for $(cliferay stats tickets $(echo ${args[user]}) | wc -l) different Jira tickets:"
echo "$(cliferay stats tickets $(echo ${args[user]}) | sed 's/^/  /')"
echo "With a total of $(cliferay stats commits $(echo ${args[user]}) | wc -l) commits to master."
echo "On average it took $(git log $(get_git_log_period) $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') --pretty=format:'%ad %cd' --date=unix | awk '{print ($2 - $1)/86400}' | awk '{ total += $1; count++ } END { print total/count }') days from commit to master."
echo "Affecting these areas of the code:"
echo "$(cliferay stats folders $(echo ${args[user]}) | sed 's/^/  /')"
LPPS=$(cliferay stats assigned ${args[user]} | grep LPP)
echo "Worked directly or indirectly on $(echo "$LPPS" | wc -l) LPPs:"
echo "$LPPS" | sed 's/^/  /'