CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -I./include -fsanitize=address,undefined

CHAPTER_SRCS = \
    chapter01/basic_algorithms \
    chapter02/arrays \
    chapter03/search \
    chapter04/stack_queue \
    chapter05/recursion \
    chapter06/sort \
    chapter07/strings \
    chapter08/linked_list \
    chapter09/tree

.PHONY: all test clean

all: test

test:
	@for src in $(CHAPTER_SRCS); do \
	    name=$$(basename $$src); \
	    echo "=== Testing $$src ==="; \
	    $(CC) $(CFLAGS) -o /tmp/test_$$name $${src}_test.c $${src}.c && \
	    /tmp/test_$$name && rm -f /tmp/test_$$name; \
	done
	@echo "All tests passed."

clean:
	@rm -f /tmp/test_chapter*
