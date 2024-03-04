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