## TP 5 : We do a little scripting

### Partie 1 : Script carte d'identité

🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```
[brendan@TP5 idcard]$ sudo ./idcard.sh 
[sudo] password for brendan: 
./idcard.sh: line 1: sd#!/bin/bash: No such file or directory
Machine name: TP5
OS = Rocky Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP = 10.2.1.11/24
RAM = 307Mi memory available on 771Mi total memory
Disk = 4.7G space left
Top 5 processes by RAM usage :
  - node
  - node
  - node
  - python3
  - NetworkManager
Listening ports
  - 323 udp : chronyd
  - 22 tcp : sshd
  - 45681 tcp : node
PATH directories
 - /sbin
 - /bin
 - /usr/sbin
 - /usr/bin
Here is your random cat (jpg file) : https://cdn2.thecatapi.com/images/acp.jpg
```

## II. Script youtube-dl

### 1. Premier script youtube-dl

### B. Rendu attendu

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie

```
[brendan@TP5 yt]$ ./yt.sh https://www.youtube.com/watch?v=s8927HywobY


[brendan@TP5 yt]$ cat download.log
[24/03/05 16:57:53] video https://www.youtube.com/watch?v=2yJgwwDcgV8 was downloaded. File path : Nyan Cat! [Official]
[24/03/05 17:04:00] video https://www.youtube.com/watch?v=O_HUXxSHkO8 was downloaded. File path : Francky Vincent - Tu veux mon zizi (Clip Officiel)
[24/03/05 17:07:28] video https://www.youtube.com/watch?v=x70rr6aU-xQ was downloaded. File path : La mort ou tchichi
[24/03/05 17:10:08] video https://www.youtube.com/watch?v=s8927HywobY was downloaded. File path : C’est qui le patron ! C’est moi
```