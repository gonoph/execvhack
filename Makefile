.PHONY: all install clean dist

PROJECT:=execvhack
MY_VERSION:=1.0.0
DIST_DIR:=$(PROJECT)-$(MY_VERSION)
DIST_TARGET:=$(DIST_DIR).tgz

DIST_FILES:=Copying Makefile README.md execvhack.c execvhack.so.2 execvhack.spec mycode.c mycode.sh sample.c secret.sh

INSTALL_ROOT:=$(DESTDIR)/usr/local

CFLAGS:=-Wall -fPIC -DPIC -ldl -ggdb
LDFLAGS:=-ldl

all: execvhack.so secret

execvhack.o: execvhack.c

execvhack.so: execvhack.o
	$(CC) $(LDFLAGS) -shared -o $@ execvhack.o

secret.sh.x: secret.sh
	shc -r -f secret.sh

secret: secret.sh.x
	ln -f secret.sh.x secret

install: execvhack.so secret.sh.x execvhack.so.2
	install -m 755 execvhack.so -D $(INSTALL_ROOT)/lib/execvhack.so
	install -m 644 execvhack.so.2 -D $(INSTALL_ROOT)/man/man2/execvhack.so.2

clean: dist-clean
	rm -f execvhack.[aso] execvhack.so secret.sh.x secret.sh.x.c secret $(DIST_TARGET)

dist: dist-clean
	mkdir $(DIST_DIR) && cp $(DIST_FILES) $(DIST_DIR) && tar -cvzf $(DIST_TARGET) $(DIST_DIR)

dist-clean:
	rm -rf $(DIST_DIR)
