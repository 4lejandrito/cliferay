sudo docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly:1.2.5 generate --upgrade
cat README.md | perl -0777 -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$(NO_COLOR=1 ./cliferay --help)\n\`\`\`/s" > README.md
