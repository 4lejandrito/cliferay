.PHONY: all clean lint

all: lint bin/cliferay README.md test/ok

DOCKER_TTY := $(if $(CI),,-it)
# Rootless Docker already maps the container root to the host user, and
# passing --user there yields a subordinate uid that cannot write to src.
DOCKER_USER := $(if $(findstring rootless,$(shell docker info -f '{{.SecurityOptions}}' 2>/dev/null)),,--user $$(id -u):$$(id -g))
BASHLY := docker run --rm $(DOCKER_TTY) $(DOCKER_USER) --volume "$$(pwd):/app" -e BASHLY_SETTINGS_PATH=src/settings.yml dannyben/bashly:1.3.3

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
