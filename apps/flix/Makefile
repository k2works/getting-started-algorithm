FLIX := java -jar flix.jar

.PHONY: all build test check format format-check doc run clean

all: check

build:
	$(FLIX) build

test:
	$(FLIX) test

check:
	$(FLIX) check

format:
	$(FLIX) format

format-check:
	@set -eu; \
	temp_dir=$$(mktemp -d); \
	trap 'rm -rf "$$temp_dir"' EXIT; \
	project_dir=$$(pwd); \
	cp -R src test flix.toml "$$temp_dir/"; \
	cd "$$temp_dir"; \
	java -jar "$$project_dir/flix.jar" format; \
	diff -ru "$$project_dir/src" "$$temp_dir/src"; \
	diff -ru "$$project_dir/test" "$$temp_dir/test"

doc:
	$(FLIX) doc

run:
	$(FLIX) run

clean:
	$(FLIX) clean
