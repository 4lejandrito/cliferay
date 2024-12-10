all: bin/cliferay README.md

bin/cliferay: $(shell find src)
	@docker run --rm -it --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.2.5 generate --upgrade

README.md: bin/cliferay
	@cat README.md | perl -0777 -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$$(NO_COLOR=1 ./bin/cliferay --help)\n\`\`\`/s" > README.tmp && mv README.tmp README.md