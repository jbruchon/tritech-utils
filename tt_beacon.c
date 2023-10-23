/*
 * TSS UDP beacon utility
 * Copyright (C) by Jody Bruchon <jody@jodybruchon.com>
 * Broadcasts a "beacon" string by UDP at regular intervals
 */

#if defined _WIN32 || defined __MINGW32__
 #ifndef ON_WINDOWS
  #define ON_WINDOWS 1
 #endif
 #ifndef WIN32_LEAN_AND_MEAN
  #define WIN32_LEAN_AND_MEAN
 #endif
 #include <windows.h>
 #include <winsock2.h>
 #include <ws2tcpip.h>
#else
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <netdb.h>
#endif /* Win32 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include "version.h"

int main(int argc, char **argv)
{
	int sockfd;
	int initial = 2;
	char *address;
	unsigned int port;
	unsigned int interval;
	char *beacon_str;
	union {
		struct sockaddr sa;
		struct sockaddr_in sa_in;
	} dest_addr;
#ifdef ON_WINDOWS
	WSADATA wsaData;
	int ws_result;
	char broadcast = 1;
#else
	int broadcast = 1;
#endif

	fprintf(stderr, "Tritech Service System UDP beacon utility %s (%s)\n", TRITECH_UTILS_VER, TRITECH_UTILS_DATE);
	if (argc != 5) {
		fprintf(stderr, "Usage: %s broadcast_addr port interval \"beacon text string\"\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	address = argv[1];
	port = atoi(argv[2]);
	interval = atoi(argv[3]);
	beacon_str = argv[4];

#ifdef ON_WINDOWS
	ws_result = WSAStartup(MAKEWORD(2,2), &wsaData);
	if (ws_result != 0) {
		fprintf(stderr, "WSAStartup failed: %d\n", ws_result);
		goto fail_exit;
	}
#endif

	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
		perror("socket");
		goto fail_exit;
	}

	dest_addr.sa_in.sin_family = AF_INET;
	dest_addr.sa_in.sin_port = htons(port);
	if (inet_pton(AF_INET, address, &(dest_addr.sa_in.sin_addr)) != 1) {
		perror("inet_pton");
		goto fail_exit;
	}

	setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof broadcast);

	fprintf(stderr, "Sending \"%s\" to addr %s port %d every %d seconds.\n", beacon_str, address, port, interval);

	while (1) {
		if (sendto(sockfd, beacon_str, strlen(beacon_str), MSG_DONTROUTE,
				&(dest_addr.sa), sizeof dest_addr.sa) == -1) {
			/* Only error out on the first packet sending attempt */
			if (initial == 2) {
				perror("sendto");
				goto fail_exit;
			}
			/* Warn user if sending fails (but only once for each set of failures) */
			if (initial == 0) {
				fprintf(stderr, "warning: packet failed to send; will keep trying.\n");
				initial = 1;
			}
			/* Throttle send attempts while they're failing */
			sleep(interval << 2);
			continue;
		}
		/* On successful send, reset warnings and sleep normally */
		initial = 0;
		sleep(interval);
	}

	close(sockfd);
	exit(EXIT_SUCCESS);

fail_exit:
#ifdef ON_WINDOWS
	WSACleanup();
#endif
	exit(EXIT_FAILURE);
}
