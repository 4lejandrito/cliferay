cd $(cliferay folder)
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter 'sed -r "1 s/(^([A-Z]+)-([0-9]*) )|^/'${args["ticket"]}' /"' ${args["--branch"]:-master}..HEAD
