cd $(cliferay folder)
HOSTNAME=localhost cliferay ant -f build-test.xml run-selenium-test -Dtest.class=${args["test"]}