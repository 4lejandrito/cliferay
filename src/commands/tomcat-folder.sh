cd $(cliferay folder)/../bundles
ls -d "$PWD/"** | grep tomcat | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -n 1