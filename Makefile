all: bin/cliferay README.md

bin/cliferay: $(shell find src)
	@docker run --rm -it --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.2.5 generate --upgrade -r cliferay

README.md: bin/cliferay
	@perl -0777 -i -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$$(NO_COLOR=1 ./bin/cliferay --help)\n\`\`\`/s" README.md