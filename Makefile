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
	install -D -o root -g root -m 0755 scripts/tss__common $(DESTDIR)/$(bindir)/tss__common
	install -D -o root -g root -m 0755 scripts/tss_alsamixerinit $(DESTDIR)/$(bindir)/tss_alsamixerinit
	install -D -o root -g root -m 0755 scripts/tss_bootstrap $(DESTDIR)/$(bindir)/tss_bootstrap
	install -D -o root -g root -m 0755 scripts/tss_client $(DESTDIR)/$(bindir)/tss_client
	install -D -o root -g root -m 0755 scripts/tss_client_direct $(DESTDIR)/$(bindir)/tss_client_direct
	install -D -o root -g root -m 0755 scripts/tss_client_tool $(DESTDIR)/$(bindir)/tss_client_tool
	install -D -o root -g root -m 0755 scripts/tss_dm_start $(DESTDIR)/$(bindir)/tss_dm_start
	install -D -o root -g root -m 0755 scripts/tss_ip_to_mac $(DESTDIR)/$(bindir)/tss_ip_to_mac
	install -D -o root -g root -m 0755 scripts/tss_netmgr $(DESTDIR)/$(bindir)/tss_netmgr
	install -D -o root -g root -m 0755 scripts/tss_push_all $(DESTDIR)/$(bindir)/tss_push_all
	install -D -o root -g root -m 0755 scripts/tt__auto_hal $(DESTDIR)/$(bindir)/tt__auto_hal
	install -D -o root -g root -m 0755 scripts/tt__disk_prompt $(DESTDIR)/$(bindir)/tt__disk_prompt
	install -D -o root -g root -m 0755 scripts/tt__disk_test $(DESTDIR)/$(bindir)/tt__disk_test
	install -D -o root -g root -m 0755 scripts/tt__fix_ntbs_geom $(DESTDIR)/$(bindir)/tt__fix_ntbs_geom
	install -D -o root -g root -m 0755 scripts/tt__get_win_pe_version $(DESTDIR)/$(bindir)/tt__get_win_pe_version
	install -D -o root -g root -m 0755 scripts/tt__intelppm $(DESTDIR)/$(bindir)/tt__intelppm
	install -D -o root -g root -m 0755 scripts/tt_add_win_exe_sums $(DESTDIR)/$(bindir)/tt_add_win_exe_sums
	install -D -o root -g root -m 0755 scripts/tt_autohal $(DESTDIR)/$(bindir)/tt_autohal
	install -D -o root -g root -m 0755 scripts/tt_autoruns $(DESTDIR)/$(bindir)/tt_autoruns
	install -D -o root -g root -m 0755 scripts/tt_backup_cust_data $(DESTDIR)/$(bindir)/tt_backup_cust_data
	install -D -o root -g root -m 0755 scripts/tt_beepsong $(DESTDIR)/$(bindir)/tt_beepsong
	install -D -o root -g root -m 0755 scripts/tt_build_dev_db $(DESTDIR)/$(bindir)/tt_build_dev_db
	install -D -o root -g root -m 0755 scripts/tt_burnin $(DESTDIR)/$(bindir)/tt_burnin
	install -D -o root -g root -m 0755 scripts/tt_cifs $(DESTDIR)/$(bindir)/tt_cifs
	install -D -o root -g root -m 0755 scripts/tt_cleaner $(DESTDIR)/$(bindir)/tt_cleaner
	install -D -o root -g root -m 0755 scripts/tt_collect_comp_data $(DESTDIR)/$(bindir)/tt_collect_comp_data
	install -D -o root -g root -m 0755 scripts/tt_collect_files $(DESTDIR)/$(bindir)/tt_collect_files
	install -D -o root -g root -m 0755 scripts/tt_cputemp $(DESTDIR)/$(bindir)/tt_cputemp
	install -D -o root -g root -m 0755 scripts/tt_drivetest $(DESTDIR)/$(bindir)/tt_drivetest
	install -D -o root -g root -m 0755 scripts/tt_driverdrop $(DESTDIR)/$(bindir)/tt_driverdrop
	install -D -o root -g root -m 0755 scripts/tt_find_base $(DESTDIR)/$(bindir)/tt_find_base
	install -D -o root -g root -m 0755 scripts/tt_find_executables $(DESTDIR)/$(bindir)/tt_find_executables
	install -D -o root -g root -m 0755 scripts/tt_fsinfo $(DESTDIR)/$(bindir)/tt_fsinfo
	install -D -o root -g root -m 0755 scripts/tt_geometry $(DESTDIR)/$(bindir)/tt_geometry
	install -D -o root -g root -m 0755 scripts/tt_guid_copy $(DESTDIR)/$(bindir)/tt_guid_copy
	install -D -o root -g root -m 0755 scripts/tt_imagedrop $(DESTDIR)/$(bindir)/tt_imagedrop
	install -D -o root -g root -m 0755 scripts/tt_instance_finder $(DESTDIR)/$(bindir)/tt_instance_finder
	install -D -o root -g root -m 0755 scripts/tt_mpkg $(DESTDIR)/$(bindir)/tt_mpkg
	install -D -o root -g root -m 0755 scripts/tt_ntfs_mount_fix $(DESTDIR)/$(bindir)/tt_ntfs_mount_fix
	install -D -o root -g root -m 0755 scripts/tt_parallel_diags $(DESTDIR)/$(bindir)/tt_parallel_diags
	install -D -o root -g root -m 0755 scripts/tt_pkg_install $(DESTDIR)/$(bindir)/tt_pkg_install
	install -D -o root -g root -m 0755 scripts/tt_pkg_remove $(DESTDIR)/$(bindir)/tt_pkg_remove
	install -D -o root -g root -m 0755 scripts/tt_scan_mbr $(DESTDIR)/$(bindir)/tt_scan_mbr
	install -D -o root -g root -m 0755 scripts/tt_show_free_mem $(DESTDIR)/$(bindir)/tt_show_free_mem
	install -D -o root -g root -m 0755 scripts/tt_software_drop $(DESTDIR)/$(bindir)/tt_software_drop
	install -D -o root -g root -m 0755 scripts/tt_sysinfo $(DESTDIR)/$(bindir)/tt_sysinfo
	install -D -o root -g root -m 0755 scripts/tt_sysupdate $(DESTDIR)/$(bindir)/tt_sysupdate
	install -D -o root -g root -m 0755 scripts/tt_takeimage $(DESTDIR)/$(bindir)/tt_takeimage
	install -D -o root -g root -m 0755 scripts/tt_trim_entire_ssd $(DESTDIR)/$(bindir)/tt_trim_entire_ssd
	install -D -o root -g root -m 0755 scripts/tt_winver $(DESTDIR)/$(bindir)/tt_winver
	install -D -o root -g root -m 0755 scripts/tt_wipe_delete_here $(DESTDIR)/$(bindir)/tt_wipe_delete_here
	install -D -o root -g root -m 0755 scripts/tt_zero_image $(DESTDIR)/$(bindir)/tt_zero_image
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
