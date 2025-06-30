.PHONY: all compile install clean dist test test-secret test-mycode

PROJECT:=execvhack
MY_VERSION:=1.0.1
DIST_DIR:=$(PROJECT)-$(MY_VERSION)
DIST_TARGET:=$(DIST_DIR).tgz

DIST_FILES:=LICENSE Copying Makefile README.md execvhack.c execvhack.so.2 execvhack.spec mycode.c mycode.template.bash secret.template

INSTALL_ROOT:=$(DESTDIR)/usr/local

CFLAGS:=-Wall -fPIC -DPIC -ldl -ggdb
LDFLAGS:=-ldl

all: compile test

compile: execvhack.so secret

execvhack.o: execvhack.c

execvhack.so: execvhack.o
	$(CC) $(LDFLAGS) -shared -o $@ execvhack.o

mycode.bash: mycode.template.bash
	./mycode.template.bash > /dev/null

secret.bash: secret.template mycode.template.bash
	./mycode.template.bash > $@
	chmod +x $@

mycode.template.bash: mycode.c

secret.bash.x: secret.bash
	shc -r -f secret.bash

secret: secret.bash.x
	ln -f secret.bash.x secret

install: execvhack.so secret.bash.x execvhack.so.2
	install -m 755 execvhack.so -D $(INSTALL_ROOT)/lib/execvhack.so
	install -m 644 execvhack.so.2 -D $(INSTALL_ROOT)/man/man2/execvhack.so.2

clean: dist-clean
	rm -f execvhack.[aso] execvhack.so secret.bash.x secret.bash.x.c secret secret.bash mycode.bash $(DIST_TARGET)

dist: dist-clean
	mkdir $(DIST_DIR) && cp $(DIST_FILES) $(DIST_DIR) && tar -cvzf $(DIST_TARGET) $(DIST_DIR)

dist-clean:
	rm -rf $(DIST_DIR)

test: test-secret test-mycode

test-secret: CHK1=$(shell echo | LD_PRELOAD=./execvhack.so  ./secret 2>&1 > /dev/null | sed -n '/#!\/bin\/bash$$/,/]]/p' | sed 's,^.*\(#!/bin/bash\)$$,\1,' | head -n -1 | sha256sum)
test-secret: CHK2=$(shell sha256sum secret.bash)
test-secret: WHAT=secret.bash

test-mycode: CHK1=$(shell ./secret --check 2>/dev/null)
test-mycode: CHK2=$(shell sha256sum mycode.bash)
test-mycode: WHAT=mycode.bash

test-secret test-mycode:
	@echo "Checking sha256 checksum for $(WHAT)"
	@echo $(CHK1)
	@echo $(CHK2)
	@set $(CHK1) && CHK1=$$1 && set $(CHK2) && CHK2=$$1 && \
		echo test "$$CHK1" == "$$CHK2" && \
		test "$$CHK1" == "$$CHK2"
