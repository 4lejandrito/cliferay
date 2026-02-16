(cliferay sync)
if [[ ${args["--force"]} = 1 ]]; then
    cd $(cliferay home) && git clean -fdx
fi
if [[ ${args["--brian"]} = 1 ]]; then
    cd $(cliferay home)
    git remote add brian git@github.com:brianchandotcom/liferay-portal.git 2>/dev/null || true
    git fetch brian master
    git checkout brian/master
fi
(cliferay build)
(cliferay ij)
if [[ ${args["--no-nuke"]} != 1 ]]; then
    (cliferay nuke)
fi
(cliferay run)
