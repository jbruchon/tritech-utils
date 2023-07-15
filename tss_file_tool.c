/*
 * Tritech Service System miscellaneous file tool
 * Copyright (C) by Jody Bruchon <jody@jodybruchon.com>
 * This tool handles simple file/device operations that are
 * too clumsy to handle in shell scripts without making the
 * author look really silly ;-)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "version.h"

#define CHECK_IF_NTFS(a)    !strncmp((char *)(a + 3), "NTFS", 4)
#define CHECK_IF_EXFAT(a)   !strncmp((char *)(a + 3), "EXFAT   ", 8)
#define CHECK_IF_FVEFS(a)   !strncmp((char *)(a + 3), "-FVE-FS-", 8)
#define CHECK_IF_HFSPLUS(a) !strncmp((char *)(a + 1032), "HFSJ", 4)
#define CHECK_IF_APFS(a) !strncmp((char *)(a + 32), "NXSB", 4)
#define CHECK_IF_LUKS(a)   !strncmp((char *)a, "LUKS", 4)
#define CHECK_IF_REG(a)     !strncmp((char *)a, "regf", 4)

static inline int change_ntfs_geometry(FILE *fp, uint8_t * const restrict bp, const uint8_t heads)
{
	*(bp + 26) = heads;
	fseek(fp, 0, SEEK_SET);
	fwrite(bp, 512, 1, fp);
	if (ferror(fp) != 0) return 1;
	else return 0;
}

int main(const int argc, const char **argv)
{
	FILE *fp;
	uint8_t buffer[4096];
	uint8_t heads;

	if (argc < 3 || argc > 4) goto usage;

	fp = fopen(argv[2], "r+");
	if (!fp) {
		fprintf(stderr, "Can't open %s\n",argv[2]);
		return EXIT_FAILURE;
	}

	fread(buffer, 4096, 1, fp);
	if (ferror(fp) != 0) {
		fprintf(stderr, "Error reading first 4096 bytes of %s\n",argv[1]);
		return EXIT_FAILURE;
	}

	if (!strcmp(argv[1], "id")) {
		if (CHECK_IF_FVEFS(buffer)) { printf("fvefs\n"); goto finished; }
		if (CHECK_IF_LUKS(buffer)) { printf("luks\n"); goto finished; }
		if (CHECK_IF_NTFS(buffer)) { printf("ntfs\n"); goto finished; }
		if (CHECK_IF_REG(buffer)) { printf("registry\n"); goto finished; }
		if (CHECK_IF_HFSPLUS(buffer)) { printf("hfsplus\n"); goto finished; }
		if (CHECK_IF_APFS(buffer)) { printf("apfs\n"); goto finished; }
		if (CHECK_IF_EXFAT(buffer)) { printf("exfat\n"); goto finished; }
		if (buffer[450] == 0xEE) { printf("gpt\n"); goto finished; }
		if (buffer[0] == 0x4D && buffer[1] == 0x5A) { printf("winexec\n"); goto finished; }
		/* Fall through */
		printf("unknown\n");
		goto finished;
	}
	if (!strcmp(argv[1], "ntfsgeom")) {
		if (argc != 4) goto usage;
		/* Convert heads from command line and verify validity */
		if (strlen(argv[3]) != 2) goto usage;
		heads = strtol(argv[3], NULL, 16);
		if (!heads) {
			fprintf(stderr, "Invalid head count specified: %s\n", argv[3]);
			return EXIT_FAILURE;
		}
		if (!CHECK_IF_NTFS(buffer)) {
			fprintf(stderr, "%s is not an NTFS filesystem.\n", argv[2]);
			return EXIT_FAILURE;
		}
		if (change_ntfs_geometry(fp, buffer, heads)) {
			fprintf(stderr, "Error writing to %s\n", argv[2]);
			return EXIT_FAILURE;
		} else {
			printf("Geometry change for %s: %d heads\n", argv[2], heads);
			goto finished;
		}
	}
	printf("Unknown command %s\n", argv[1]);
	fclose(fp);
	return EXIT_FAILURE;
finished:
	fclose(fp);
	return EXIT_SUCCESS;

usage:
	fprintf(stderr, "Tritech Service System miscellaneous file tool %s (%s)\n", TRITECH_UTILS_VER, TRITECH_UTILS_DATE);
	fprintf(stderr, "Usage: %s command dev/device|/path/to/file [hex-head-count]\n\n", argv[0]);
	fprintf(stderr, "Commands:\n");
	fprintf(stderr, "id          Identifies the filesystem or format of the target\n");
	fprintf(stderr, "            Recognizes: gpt ntfs fvefs winexec registry hfsplus exfat apfs\n");
	fprintf(stderr, "ntfsgeom    Change NTFS partition head count; requires two-digit hex head count\n");
	return EXIT_FAILURE;
}

