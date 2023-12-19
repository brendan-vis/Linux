## II. Casser

### 2. Fichier

🌞 Supprimer des fichiers

```
[brendan@localhost /]$ cd boot

[brendan@localhost boot]$ ls

config-5.14.0-284.11.1.el9_2.x86_64
efi
grub2
initramfs-0-rescue-6ba91eb833014f97a908474ac26aa330.img
initramfs-5.14.0-284.11.1.el9_2.x86_64.img
initramfs-5.14.0-284.11.1.el9_2.x86_64kdump.img
loader
symvers-5.14.0-284.11.1.el9_2.x86_64.gz
System.map-5.14.0-284.11.1.el9_2.x86_64
vmlinuz-0-rescue-6ba91eb833014f97a908474ac26aa330
vmlinuz-5.14.0-284.11.1.el9_2.x86_64

[brendan@localhost boot]$ sudo rm vmlinuz-0-rescue-6ba91eb833014f97a908474ac26aa330
[sudo] password for brendan:

[brendan@localhost boot]$ sudo rm vmlinuz-5.14.0-284.11.1.el9_2.x86_64

[brendan@localhost boot]$ sudo reboot
```


### 3. Utilisateurs

🌞 Mots de passe
```
[brendan@localhost ~]$ sudo passwd brendan
```

🌞 Another way ?
```
[brendan@localhost ~]$ sudo chmod a-x /bin/bash
[sudo] password for brendan:

[brendan@localhost ~]$ exit
logout
Connection to 10.1.1.1 closed.

PS C:\Users\brend> ssh brendan@10.1.1.1
brendan@10.1.1.1's password:
Permission denied, please try again.
```

### 4. Disques

🌞 Effacer le contenu du disque dur

```
[brendan@localhost ~]$ df -h
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             4.0M     0  4.0M   0% /dev
tmpfs                386M     0  386M   0% /dev/shm
tmpfs                155M  3.6M  151M   3% /run
/dev/mapper/rl-root  6.2G  1.2G  5.1G  20% /
/dev/sda1           1014M  221M  794M  22% /boot
tmpfs                 78M     0   78M   0% /run/user/1000

[brendan@localhost ~]$ sudo dd if=/dev/zero of=/dev/mapper/rl-root status=progress
6482051584 bytes (6.5 GB, 6.0 GiB) copied, 27 s, 240 MB/s
dd: writing to '/dev/mapper/rl-root': No space left on device
12992513+0 records in
12992512+0 records out
6652166144 bytes (6.7 GB, 6.2 GiB) copied, 27.7479 s, 240 MB/s

[brendan@localhost ~]$ df -h
Segmentation fault
```

### 5. Malware

🌞 Reboot automatique
```
[brendan@localhost ~]$ nano reboot.sh

[brendan@localhost ~]$ echo "echo 'root' | sudo -S bash -c 'reboot'" >> /home/brendan/reboot.sh

[brendan@localhost ~]$ echo "/home/brendan/reboot.sh">>/home/brendan/.bash_profile

[brendan@localhost ~]$ echo "/home/brendan/reboot.sh">>/root/.bash_profile
```

### 6. You own way

🌞 Trouvez 4 autres façons de détuire la machine

```
1.

[brendan@localhost ~]$ sudo rm -r /etc/shadow
[sudo] password for brendan:

[brendan@localhost ~]$ exit
logout
Connection to 10.1.1.1 closed.

PS C:\Users\brend> ssh brendan@10.1.1.1
brendan@10.1.1.1's password:
Permission denied, please try again.


2.

[brendan@localhost bin]$ sudo rm bash
[sudo] password for brendan:

[brendan@localhost bin]$ exit
logout
Connection to 10.1.1.1 closed.

PS C:\Users\brend> ssh brendan@10.1.1.1
brendan@10.1.1.1's password:
Permission denied, please try again.


3.

```

```


4.

```

```