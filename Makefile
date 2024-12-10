all: cliferay README.md

cliferay: $(shell find src)
	@sudo docker run --rm -it --user $$(id -u):$$(id -g) --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.2.5 generate --upgrade

README.md: cliferay
	@cat README.md | perl -0777 -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$$(NO_COLOR=1 ./cliferay --help)\n\`\`\`/s" > README.tmp && mv README.tmp README.md