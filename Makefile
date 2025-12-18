.PHONY: all clean

all: bin/cliferay README.md test/ok

DOCKER_TTY := $(if $(CI),,-it)
BASHLY := docker run --rm $(DOCKER_TTY) --user $$(id -u):$$(id -g) --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.3.3

bin/cliferay: $(shell find src) Makefile
	@$(BASHLY) build --upgrade -r cliferay

README.md: bin/cliferay README.sh Makefile
	@rm -rf docs
	@$(BASHLY) render :markdown_github docs
	@./README.sh > README.md

test/ok: test/*.bats bin/cliferay
	@docker run $(DOCKER_TTY) -v "$$PWD:/code" bats/bats:1.12.0 test
	@touch test/ok

clean:
	@rm -f test/ok
