FOLDER=$(realpath ${args["folder"]:-$(cliferay home)} --relative-to $(cliferay home))
cd $(cliferay home)
git diff --name-only ${args["--branch"]:-master} $FOLDER | get-module | uniq