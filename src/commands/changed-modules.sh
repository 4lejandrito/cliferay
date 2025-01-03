FOLDER=$(realpath ${args["folder"]:-$(cliferay folder)} --relative-to $(cliferay folder))
cd $(cliferay folder)
git diff --name-only ${args["--branch"]:-master} $FOLDER | get-module | uniq