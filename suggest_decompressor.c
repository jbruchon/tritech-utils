/*
 * Returns the stream decompressor for an archive based on its extension
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tritech_utils.h"

int main(int argc, char **argv) {
	unsigned char *ext;
	struct ext_t {
		const char *ext;
		const char *decomp;
	};
	struct ext_t ext_table[] = {
		{ "lzo", "lzop" },
		{ "tlz", "lzop" },
		{ "tlzo", "lzop" },
		{ "7z", "7za" },
		{ "xz", "xz" },
		{ "txz", "xz" },
		{ "lzm", "xz" },
		{ "lzma", "xz" },
		{ "gz", "gzip" },
		{ "tgz", "gzip" },
		{ "bz2", "bzip2" },
		{ "tbz", "bzip2" },
		{ "tbz2", "bzip2" },
		{ "tz", "gzip" },
		{ "Z", "gzip" },
		{ "z", "gzip" },
		{ "lz", "lzip" },
		{ "lzip", "lzip" },
		{ "lz4", "lz4" },
		{ NULL, 0 }
	};
	struct ext_t *p;

	if(argc < 2) {
		fprintf(stderr, "Tritech compression extension helper %s (%s)", TRITECH_UTILS_VER, TRITECH_UTILS_DATE);
		fprintf(stderr, "Suggests a decompressor for a given file name\n", argv[0]);
		fprintf(stderr, "Usage: %s compressed_file.ext\n", argv[0]);
		exit(1);
	}
	ext = strrchr(argv[1], '.');
	if(!ext) {
		fprintf(stderr, "File name does not have an extension.\n");
		exit(1);
	}
	ext++;

	for (p = ext_table; p->ext != NULL; ++p) {
		if (strcmp(p->ext, ext) == 0) {
			printf("%s\n", p->decomp);
			exit(0);
		}
	}
	fprintf(stderr, "No decompressor known for extension \"%s\".\n", ext);
	exit(1);
}