cd $(cliferay folder)
echo "This quarter ${args[emails]} has:"
echo ""
echo "Contributed code for $(cliferay stats tickets $(echo ${args[emails]}) | wc -l) different Jira tickets:"
echo "$(cliferay stats tickets $(echo ${args[emails]}) | sed 's/^/  /')"
echo "With a total of $(cliferay stats commits $(echo ${args[emails]}) | wc -l) commits to master."
echo "Reaching $(cliferay stats years $(echo ${args[emails]}) | awk '{current=$1; if (NR>1) last=current/prev*100; prev=$1} END{print last "%"}') of their total commits from last whole year."
echo "Worked directly or indirectly on XX LPP tickets."