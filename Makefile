all: bin/cliferay README.md

bin/cliferay: $(shell find src) Makefile
	@docker run --rm -it --user $$(id -u):$$(id -g) --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.2.10 build --upgrade -r cliferay

README.md: bin/cliferay Makefile
	@perl -0777 -i -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$$(NO_COLOR=1 ./bin/cliferay --help)\n\`\`\`/s" README.md