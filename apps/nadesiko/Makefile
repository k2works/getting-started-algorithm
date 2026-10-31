GONAKO ?= gonako
SOURCES := $(wildcard src/*.nako3) $(wildcard test/*.nako3)

.PHONY: all test lint format format-check check

all: check

test:
	@pass=0; fail=0; \
	for f in test/*_test.nako3; do \
		echo == $$f; \
		if $(GONAKO) run $$f; then pass=$$((pass + 1)); else fail=$$((fail + 1)); fi; \
	done; \
	echo テストファイル: $$pass 件成功、$$fail 件失敗; \
	test $$fail -eq 0

lint:
	@for f in $(SOURCES); do \
		$(GONAKO) lint "$$f" > /dev/null || exit 1; \
	done
	@echo "lint: OK"

format:
	@for f in $(SOURCES); do $(GONAKO) format -f "$$f" > /dev/null; done

format-check:
	@for f in $(SOURCES); do \
		$(GONAKO) format "$$f" | diff -u "$$f" - || exit 1; \
	done
	@echo "format: OK"

check: lint format-check test
