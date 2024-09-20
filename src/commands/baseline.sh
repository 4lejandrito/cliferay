if [[ "$PWD" = */portal-kernel || "$PWD" = */portal-impl ]]; then
    cliferay ant -Dbaseline.jar.report.level=persist clean jar
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw baseline
fi