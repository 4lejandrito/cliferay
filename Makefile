.PHONY: all clean lint

all: lint bin/cliferay README.md test/ok

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

lint:
	@if grep -rnE '^[^#]*sed +-i' src/; then \
		echo ""; \
		echo "ERROR: plain 'sed -i' is not portable. BSD sed (macOS) requires a"; \
		echo "backup suffix argument, GNU sed does not, POSIX defines no -i at all."; \
		echo "Call ensure-gnu-sed (src/lib/functions.sh) and go through \$$SED:"; \
		echo ""; \
		echo "    ensure-gnu-sed"; \
		echo "    \$$SED -i 's/foo/bar/' \"the-file\""; \
		echo ""; \
		exit 1; \
	fi

clean:
	@rm -f test/ok
