#!/bin/bash

# Test tss_file_tool id correctness

echo -e "\nRunning tritech-utils testsuite...\n"
test ! -x ./tss_file_tool && echo "Build before testing, code monkey!" && exit 1

ERR=0
echo -n "tss_file_tool GPT:       "
if [ "$(./tss_file_tool id test/gpt)" = "gpt" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool NTFS:      "
if [ "$(./tss_file_tool id test/ntfs)" = "ntfs" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool FVEFS:     "
if [ "$(./tss_file_tool id test/fvefs)" = "fvefs" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool LUKS:      "
if [ "$(./tss_file_tool id test/luks)" = "luks" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool HFS+:      "
if [ "$(./tss_file_tool id test/hfsplus)" = "hfsplus" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool winexec:   "
if [ "$(./tss_file_tool id test/winexec)" = "winexec" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool registry:  "
if [ "$(./tss_file_tool id test/registry)" = "registry" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool exfat:     "
if [ "$(./tss_file_tool id test/exfat)" = "exfat" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool apfs:      "
if [ "$(./tss_file_tool id test/apfs)" = "apfs" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "tss_file_tool ntfsgeom:  "
cp test/ntfs test/ntfs_test
./tss_file_tool ntfsgeom test/ntfs_test 66 2>&1 >/dev/null
if cmp -s test/ntfs_test test/ntfs_expected
	then echo "OK"
	else echo "broken" && ERR=1
fi
rm -f test/ntfs_test

echo -n "raid0merge works:        "
RAID0MERGE=0
./raid0merge 512 test/raid0_1 test/raid0_2 test/raid0_3 test/raid0_test 2>&1 >/dev/null || RAID0MERGE=1
if [ $RAID0MERGE -eq 0 ] && cmp -s test/raid0_correct test/raid0_test
	then echo "OK"
	else echo "broken" && ERR=1
fi
rm -f test/raid0_test

echo -n "read_inf_section works:  "
if [ "$(./read_inf_section test/ris section1)" = "foo=bar" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "suggest_decompressor:    "
if [ "$(./suggest_decompressor foo.tar.lzo)" = "lzop" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

echo -n "format_device_entry:     "
if [ "$(echo ',hdaudio\func_01&ven_8086&dev_24c5&subsys_deadbeef&rev_c0' | ./format_device_entry x y z)" = "hdaudio:ven=8086:dev=24c5:subsys=deadbeef:rev=c0:func=01:win=x:dv=y:inf=z" ]
	then echo "OK"
	else echo "broken" && ERR=1
fi

test "$ERR" = "0" && echo "--- All tests passed ---"
test "$ERR" = "1" && echo "-x- Some tests failed -x-"
echo
exit $ERR
