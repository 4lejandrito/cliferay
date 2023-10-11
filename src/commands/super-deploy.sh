cd $(cliferay folder)
cliferay changed-modules --branch ${args["--branch"]:-master} | run-stdin cliferay deploy
cliferay changed-modules --branch ${args["--branch"]:-master} | run-stdin cliferay deploy