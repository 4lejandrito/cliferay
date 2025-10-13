.PHONY: all clean

all: bin/cliferay README.md test/ok

DOCKER_TTY := $(if $(CI),,-it)

bin/cliferay: $(shell find src) Makefile
	@docker run --rm $(DOCKER_TTY) --user $$(id -u):$$(id -g) --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.3.2 build --upgrade -r cliferay

README.md: bin/cliferay Makefile
	@perl -0777 -i -pe "s/\`\`\`(.*?)\`\`\`/\`\`\`\n$$(NO_COLOR=1 ./bin/cliferay --help)\n\`\`\`/s" README.md

test/ok: test/*.bats bin/cliferay
	@docker run $(DOCKER_TTY) -v "$$PWD:/code" bats/bats:1.12.0 test
	@touch test/ok

clean:
	@rm -f test/ok
