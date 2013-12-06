CC=gcc
CFLAGS=-Os -pipe -s
LDFLAGS=-Wl,--hash-style=gnu

prefix=/usr
bindir=${prefix}/bin
mandir=${prefix}/man
datarootdir=${prefix}/share
datadir=${datarootdir}
ver=$(shell grep TRITECH_UTILS_VER tritech_utils.h | sed 's/.* "\([^"]*\)"/\1/')
arch=$(shell uname -m | sed s/_/-/g | sed 's/i[34567]86/i386/')

all: tritech-utils manual test

tritech-utils: read_inf_section suggest_decompressor tss_file_tool tt_beacon

manual:
	gzip -9 < read_inf_section.1 > read_inf_section.1.gz
	gzip -9 < suggest_decompressor.1 > suggest_decompressor.1.gz
	gzip -9 < tss_file_tool.1 > tss_file_tool.1.gz
	gzip -9 < tt_beacon.1 > tt_beacon.1.gz

test:	tritech-utils
	./test.sh

install: tritech-utils manual
	install -D -o root -g root -m 0644 sounds/diags_complete.wav $(DESTDIR)/$(datadir)/sounds/tritech-utils/diags_complete.wav
	install -D -o root -g root -m 0644 sounds/temp_warn.wav $(DESTDIR)/$(datadir)/sounds/tritech-utils/temp_warn.wav
	install -D -o root -g root -m 0755 -s read_inf_section $(DESTDIR)/$(bindir)/read_inf_section
	install -D -o root -g root -m 0755 -s suggest_decompressor $(DESTDIR)/$(bindir)/suggest_decompressor
	install -D -o root -g root -m 0755 -s tss_file_tool $(DESTDIR)/$(bindir)/tss_file_tool
	install -D -o root -g root -m 0755 -s tt_beacon $(DESTDIR)/$(bindir)/tt_beacon

	install -D -o root -g root -m 0644 read_inf_section.1.gz $(DESTDIR)/$(mandir)/man1/read_inf_section.1.gz
	install -D -o root -g root -m 0644 suggest_decompressor.1.gz $(DESTDIR)/$(mandir)/man1/suggest_decompressor.1.gz
	install -D -o root -g root -m 0644 tss_file_tool.1.gz $(DESTDIR)/$(mandir)/man1/tss_file_tool.1.gz
	install -D -o root -g root -m 0644 tt_beacon.1.gz $(DESTDIR)/$(mandir)/man1/tt_beacon.1.gz

	install -D -o root -g root -m 0755 scripts/tss__common $(DESTDIR)/$(bindir)/tss__common
	install -D -o root -g root -m 0755 scripts/tss__functions $(DESTDIR)/$(bindir)/tss__functions
	install -D -o root -g root -m 0755 scripts/tss_alsamixerinit $(DESTDIR)/$(bindir)/tss_alsamixerinit
	install -D -o root -g root -m 0755 scripts/tss_bootstrap $(DESTDIR)/$(bindir)/tss_bootstrap
	install -D -o root -g root -m 0755 scripts/tss_client $(DESTDIR)/$(bindir)/tss_client
	install -D -o root -g root -m 0755 scripts/tss_client_tool $(DESTDIR)/$(bindir)/tss_client_tool
	install -D -o root -g root -m 0755 scripts/tss_dm_start $(DESTDIR)/$(bindir)/tss_dm_start
	install -D -o root -g root -m 0755 scripts/tss_ip_to_mac $(DESTDIR)/$(bindir)/tss_ip_to_mac
	install -D -o root -g root -m 0755 scripts/tss_push_all $(DESTDIR)/$(bindir)/tss_push_all
	install -D -o root -g root -m 0755 scripts/tt__auto_hal $(DESTDIR)/$(bindir)/tt__auto_hal
	install -D -o root -g root -m 0755 scripts/tt__disk_prompt $(DESTDIR)/$(bindir)/tt__disk_prompt
	install -D -o root -g root -m 0755 scripts/tt__disk_test $(DESTDIR)/$(bindir)/tt__disk_test
	install -D -o root -g root -m 0755 scripts/tt__fix_ntbs_geom $(DESTDIR)/$(bindir)/tt__fix_ntbs_geom
	install -D -o root -g root -m 0755 scripts/tt__get_win_pe_version $(DESTDIR)/$(bindir)/tt__get_win_pe_version
	install -D -o root -g root -m 0755 scripts/tt__intelppm $(DESTDIR)/$(bindir)/tt__intelppm
	install -D -o root -g root -m 0755 scripts/tt_add_win_exe_sums $(DESTDIR)/$(bindir)/tt_add_win_exe_sums
	install -D -o root -g root -m 0755 scripts/tt_autohal $(DESTDIR)/$(bindir)/tt_autohal
	install -D -o root -g root -m 0755 scripts/tt_backup_cust_data $(DESTDIR)/$(bindir)/tt_backup_cust_data
	install -D -o root -g root -m 0755 scripts/tt_beepsong $(DESTDIR)/$(bindir)/tt_beepsong
#	install -D -o root -g root -m 0755 scripts/tt_beacon $(DESTDIR)/$(bindir)/tt_beacon
	install -D -o root -g root -m 0755 scripts/tt_build_dev_db $(DESTDIR)/$(bindir)/tt_build_dev_db
	install -D -o root -g root -m 0755 scripts/tt_burnin $(DESTDIR)/$(bindir)/tt_burnin
	install -D -o root -g root -m 0755 scripts/tt_cifs $(DESTDIR)/$(bindir)/tt_cifs
	install -D -o root -g root -m 0755 scripts/tt_cleaner $(DESTDIR)/$(bindir)/tt_cleaner
	install -D -o root -g root -m 0755 scripts/tt_collect_comp_data $(DESTDIR)/$(bindir)/tt_collect_comp_data
	install -D -o root -g root -m 0755 scripts/tt_collect_files $(DESTDIR)/$(bindir)/tt_collect_files
	install -D -o root -g root -m 0755 scripts/tt_drivetest $(DESTDIR)/$(bindir)/tt_drivetest
	install -D -o root -g root -m 0755 scripts/tt_driverdrop $(DESTDIR)/$(bindir)/tt_driverdrop
	install -D -o root -g root -m 0755 scripts/tt_find_executables $(DESTDIR)/$(bindir)/tt_find_executables
	install -D -o root -g root -m 0755 scripts/tt_fsinfo $(DESTDIR)/$(bindir)/tt_fsinfo
	install -D -o root -g root -m 0755 scripts/tt_geometry $(DESTDIR)/$(bindir)/tt_geometry
	install -D -o root -g root -m 0755 scripts/tt_imagedrop $(DESTDIR)/$(bindir)/tt_imagedrop
	install -D -o root -g root -m 0755 scripts/tt_instance_finder $(DESTDIR)/$(bindir)/tt_instance_finder
	install -D -o root -g root -m 0755 scripts/tt_mpkg $(DESTDIR)/$(bindir)/tt_mpkg
	install -D -o root -g root -m 0755 scripts/tt_parallel_diags $(DESTDIR)/$(bindir)/tt_parallel_diags
	install -D -o root -g root -m 0755 scripts/tt_pkg_install $(DESTDIR)/$(bindir)/tt_pkg_install
	install -D -o root -g root -m 0755 scripts/tt_pkg_remove $(DESTDIR)/$(bindir)/tt_pkg_remove
	install -D -o root -g root -m 0755 scripts/tt_scan_mbr $(DESTDIR)/$(bindir)/tt_scan_mbr
	install -D -o root -g root -m 0755 scripts/tt_show_free_mem $(DESTDIR)/$(bindir)/tt_show_free_mem
	install -D -o root -g root -m 0755 scripts/tt_sysinfo $(DESTDIR)/$(bindir)/tt_sysinfo
	install -D -o root -g root -m 0755 scripts/tt_sysupdate $(DESTDIR)/$(bindir)/tt_sysupdate
	install -D -o root -g root -m 0755 scripts/tt_takeimage $(DESTDIR)/$(bindir)/tt_takeimage
	install -D -o root -g root -m 0755 scripts/tt_wifi $(DESTDIR)/$(bindir)/tt_wifi
	install -D -o root -g root -m 0755 scripts/tt_winver $(DESTDIR)/$(bindir)/tt_winver
	install -D -o root -g root -m 0755 scripts/tt_zero_image $(DESTDIR)/$(bindir)/tt_zero_image

package: tritech-utils manual test
	-test -d $(CURDIR)/pkg && rm -rf $(CURDIR)/pkg
	mkdir $(CURDIR)/pkg
	make DESTDIR=$(CURDIR)/pkg install
	tar -C pkg -c usr | xz -e > tritech-utils_$(ver)-$(arch).pkg.tar.xz
	-./build-i386.sh

clean:
	-rm -rf $(CURDIR)/pkg
	-rm -f read_inf_section suggest_decompressor tss_file_tool tt_beacon
	-rm -f *.1.gz test/ntfs_test

distclean: clean
	-rm -f tritech-utils_*.pkg.tar.xz
