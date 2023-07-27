cd $(liferay folder)
liferay changed-modules | grep -v test | run-stdin $(liferay gw) -a deploy