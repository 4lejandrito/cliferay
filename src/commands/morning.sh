cliferay sync
if [[ ${args["--force"]} = 1 ]]; then
    cd $(cliferay folder) && git clean -fdx
fi
cliferay build
cliferay ij
if [[ ${args["--no-nuke"]} != 1 ]]; then
    cliferay nuke
fi
cliferay playwright install
cliferay run
