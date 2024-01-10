cliferay sync
cliferay build
cliferay ij
if [[ ${args["--no-nuke"]} != 1 ]]; then
    cliferay nuke
fi
cliferay run
