cd $(cliferay folder)
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter 'sed -r "s/(LPS-([0-9]*) )|^/'${args["lps"]}' /g"' ${args["--branch"]:-master}..HEAD
