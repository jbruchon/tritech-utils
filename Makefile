CC := gcc
BUILD_CFLAGS = -std=gnu99 -D_FILE_OFFSET_BITS=64 -fstrict-aliasing
BUILD_CFLAGS += -Wall -Wextra -pedantic -Wcast-align -Wstrict-aliasing -Wstrict-overflow -Wwrite-strings
CFLAGS = -O2 -pipe -g
#CFLAGS = -Og -pipe -g3
#LDFLAGS = -Wl,--hash-style=gnu -s -static-libgcc
LDFLAGS = -static-libgcc

prefix=/usr
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
mandir=${prefix}/man
datarootdir=${prefix}/share
datadir=${datarootdir}
sysconfdir=${prefix}/etc

ver=$(shell grep TRITECH_UTILS_VER version.h | sed 's/.* "\([^"]*\)"/\1/')
libc_arch=$(shell test -e /lib/libc.so.0 && echo -n "uclibc-")
arch=$(shell echo -n "$(libc_arch)"; uname -m | sed 's/_/-/g;s/i[34567]86/i386/')

OBJS += ac_monitor.o format_device_entry.o raid0merge.o 
OBJS += read_inf_section.o suggest_decompressor.o tss_file_tool.o tt_beacon.o

PROGS += ac_monitor format_device_entry raid0merge read_inf_section suggest_decompressor tss_file_tool tt_beacon

.c.o:
	$(CC) -c $(BUILD_CFLAGS) $(CFLAGS) $<

all: tritech-utils manual test

tritech-utils: $(OBJS) $(PROGS)

stripped: tritech-utils
	strip --strip-unneeded $(PROGS)

manual:
	gzip -9 < ac_monitor.1 > ac_monitor.1.gz
	gzip -9 < read_inf_section.1 > read_inf_section.1.gz
	gzip -9 < suggest_decompressor.1 > suggest_decompressor.1.gz
	gzip -9 < tss_file_tool.1 > tss_file_tool.1.gz
	gzip -9 < tt_beacon.1 > tt_beacon.1.gz

test:	tritech-utils
	./test.sh

install: tritech-utils manual
	install -D -o root -g root -m 0644 ac_monitor.1.gz $(DESTDIR)/$(mandir)/man1/ac_monitor.1.gz
	install -D -o root -g root -m 0644 read_inf_section.1.gz $(DESTDIR)/$(mandir)/man1/read_inf_section.1.gz
	install -D -o root -g root -m 0644 suggest_decompressor.1.gz $(DESTDIR)/$(mandir)/man1/suggest_decompressor.1.gz
	install -D -o root -g root -m 0644 tss_file_tool.1.gz $(DESTDIR)/$(mandir)/man1/tss_file_tool.1.gz
	install -D -o root -g root -m 0644 tt_beacon.1.gz $(DESTDIR)/$(mandir)/man1/tt_beacon.1.gz
	install -D -o root -g root -m 0644 sounds/diags_complete.wav $(DESTDIR)/$(datadir)/sounds/tritech-utils/diags_complete.wav
	install -D -o root -g root -m 0644 sounds/temp_warn.wav $(DESTDIR)/$(datadir)/sounds/tritech-utils/temp_warn.wav
	install -D -o root -g root -m 0755 -s ac_monitor $(DESTDIR)/$(bindir)/ac_monitor
	install -D -o root -g root -m 0755 -s format_device_entry $(DESTDIR)/$(bindir)/format_device_entry
	install -D -o root -g root -m 0755 -s raid0merge $(DESTDIR)/$(bindir)/raid0merge
	install -D -o root -g root -m 0755 -s read_inf_section $(DESTDIR)/$(bindir)/read_inf_section
	install -D -o root -g root -m 0755 -s suggest_decompressor $(DESTDIR)/$(bindir)/suggest_decompressor
	install -D -o root -g root -m 0755 -s tss_file_tool $(DESTDIR)/$(bindir)/tss_file_tool
	install -D -o root -g root -m 0755 -s tt_beacon $(DESTDIR)/$(bindir)/tt_beacon
	install -D -o root -g root -m 0755 -t $(DESTDIR)/$(bindir) scripts/*
	mkdir -p $(DESTDIR)/$(datarootdir)/tritech-utils
	cp -a win_svc_templates $(DESTDIR)/$(datarootdir)/tritech-utils/

package: tritech-utils stripped manual test
	-test ! "$(arch)" = "x86-64" && echo "ARCH $(arch) != x86-64, aborting" && exit
	-test -d $(CURDIR)/pkg && rm -rf $(CURDIR)/pkg
	mkdir $(CURDIR)/pkg
	make DESTDIR=$(CURDIR)/pkg install
	tar -C pkg -c usr | xz -e > tritech-utils_$(ver)-$(arch).pkg.tar.xz
	-test -z "$(DO_CHROOT_BUILD)" && ./chroot_build.sh uclibc-x86-64
	-test -z "$(DO_CHROOT_BUILD)" && ./chroot_build.sh uclibc-i386
	-test -z "$(DO_CHROOT_BUILD)" && ./chroot_build.sh i386

clean:
	-rm -rf $(CURDIR)/pkg
	-rm -f ac_monitor format_device_entry raid0merge read_inf_section suggest_decompressor tss_file_tool tt_beacon
	-rm -f *.1.gz *~ scripts/*~ *.o test/ntfs_test

distclean: clean
	-rm -f tritech-utils_*.pkg.tar.xz
