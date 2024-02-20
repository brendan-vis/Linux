## Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM

```
[brendan@storage ~]$ lsblk

NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0    8G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    7G  0 part
  ├─rl-root 253:0    0  6.2G  0 lvm  /
  └─rl-swap 253:1    0  820M  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sdc           8:32   0    2G  0 disk
sr0          11:0    1 1024M  0 rom


[brendan@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for brendan:
  Physical volume "/dev/sdb" successfully created.
[brendan@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.


[brendan@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBd8200c4d-d0f5c9a4 PVID i5YsHaf3nvLTfQlLCWkcl6em5HJfvDaX last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
  /dev/sdc      lvm2 ---  2.00g 2.00g


[brendan@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created

[brendan@storage ~]$ sudo vgextend storage /dev/sdc
  Volume group "storage" successfully extended

[brendan@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBd8200c4d-d0f5c9a4 PVID i5YsHaf3nvLTfQlLCWkcl6em5HJfvDaX last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g

[brendan@storage ~]$ sudo lvcreate -L 3.99G storage -n data
  Rounding up size to full physical extent 3.99 GiB
  Logical volume "data" created.
```


🌞 Formater la partition

```
[brendan@storage ~]$ sudo mkfs -t ext4 /dev/storage/data
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 037bf322-a25d-484e-b2e4-ac0e2dea91fa
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition

```
[brendan@storage ~]$ sudo mkdir /mnt/data1

[brendan@storage home]$ sudo mount /dev/storage/data /mnt/data1

[brendan@storage ~]$ df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     386M     0  386M   0% /dev/shm
tmpfs                     155M  3.6M  151M   3% /run
/dev/mapper/rl-root       6.2G  1.2G  5.1G  20% /
/dev/sda1                1014M  221M  794M  22% /boot
tmpfs                      78M     0   78M   0% /run/user/1000
/dev/mapper/storage-data  3.9G   24K  3.7G   1% /mnt/data1

[brendan@storage ~]$ df -h | grep data
/dev/mapper/storage-data  3.9G   24K  3.7G   1% /mnt/data1

[brendan@storage mapper]$ ls -al storage-data
lrwxrwxrwx. 1 root root 7 Feb 19 15:51 storage-data -> ../dm-2

[brendan@storage ~]$ sudo nano /etc/fstab

[brendan@storage ~]$ sudo cat /etc/fstab | grep storage
/dev/storage/data /mnt/data1 ext4 defaults 0 0


[brendan@storage ~]$ sudo umount /mnt/data1

[brendan@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/data1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/mnt/data1               : successfully mounted
```


## Partie 2 : Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```
[brendan@storage ~]$ sudo dnf install nfs-utils

[brendan@storage /]$ cd mnt/data1/

[brendan@storage data1]$ sudo mkdir -p storage/site_web_1

[brendan@storage data1]$ sudo mkdir -p storage/site_web_2

[brendan@storage data1]$ ls -dl storage/site_web_1
drwxr-xr-x. 2 root root 40 Feb 20 14:19 storage/site_web_1

[brendan@storage data1]$ ls -dl storage/site_web_2
drwxr-xr-x. 2 nobody root 40 Feb 20 14:42 storage/site_web_2

[brendan@storage data1]$ sudo chown nobody storage/storage/site_web_1

[brendan@storage data1]$ sudo chown nobody storage/site_web_2

[brendan@storage ~]$ sudo dnf install nano

[brendan@storage ~]$ sudo nano /etc/exports

[brendan@storage storage]$ cat /etc/exports
/mnt/data1/storage/site_web_1    10.2.1.11(rw,sync,no_root_squash,no_subtree_check)
/mnt/data1/storage/site_web_2    10.2.1.11(rw,sync,no_root_squash,no_subtree_check)

[brendan@storage ~]$ sudo systemctl enable nfs-server

[brendan@storage ~]$ sudo systemctl start nfs-server

[brendan@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; p>
     Active: active (exited) since Mon 2024-02-19 16:49:20 CET; 29s ago
   Main PID: 14774 (code=exited, status=0/SUCCESS)
        CPU: 20ms

Feb 19 16:49:19 storage systemd[1]: Starting NFS server and services...
Feb 19 16:49:19 storage exportfs[14754]: exportfs: /etc/exports:1: unknown >
Feb 19 16:49:20 storage systemd[1]: Finished NFS server and services.

[brendan@storage ~]$ sudo firewall-cmd --permanent --list-all | grep service
s
  services: cockpit dhcpv6-client ssh


[brendan@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success

[brendan@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success

[brendan@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success

[brendan@storage ~]$ sudo firewall-cmd --reload
success

[brendan@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh


[brendan@storage data1]$ sudo touch /mnt/data1/storage/site_web_1/test

[brendan@storage data1]$ sudo touch /mnt/data1/storage/site_web_2/test2
```

🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```
[brendan@web ~]$ sudo dnf install nfs-utils

[brendan@web var]$ sudo mkdir -p /www/site_web_1

[brendan@web var]$ sudo mkdir -p /www/site_web_2

[brendan@web ~]$ sudo mount 10.2.1.12:mnt/data1/storage/site_web_1 /var/www/site_web_1

[brendan@web ~]$ sudo mount 10.2.1.12:mnt/data1/storage/site_web_2 /var/www/site_web_2

[brendan@web ~]$ df -h | grep data
df: /nfs/general: Stale file handle
10.2.1.12:/mnt/data1/storage/site_web_1  3.9G     0  3.7G   0% /var/www/site_web_1
10.2.1.12:/mnt/data1/storage/site_web_2  3.9G     0  3.7G   0% /var/www/site_web_2

[brendan@web ~]$ ls -l /var/www/site_web_1
total 0
-rw-r--r--. 1 root root 0 Feb 20 15:42 test

[brendan@web ~]$ ls -l /var/www/site_web_2
total 0
-rw-r--r--. 1 root root 0 Feb 20 15:46 test
-rw-r--r--. 1 root root 0 Feb 20 15:53 test2

[brendan@web ~]$ sudo nano /etc/fstab

[brendan@web ~]$ sudo cat /etc/fstab

/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=a9443959-4763-44f3-a87a-a9453e8a7aa4 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0


10.2.1.12:/mnt/data1/storage/site_web_1    /var/www/site_web_1   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.2.1.12:/mnt/data1/storage/site_web_2    /var/www/site_web_2   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0







[brendan@web ~]$ sudo umount /var/www/site_web_2
[sudo] password for brendan:

[brendan@web ~]$ sudo umount /var/www/site_web_1

[brendan@web ~]$ df -h
df: /nfs/general: Stale file handle
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             4.0M     0  4.0M   0% /dev
tmpfs                386M     0  386M   0% /dev/shm
tmpfs                155M  3.7M  151M   3% /run
/dev/mapper/rl-root  6.2G  1.2G  5.0G  20% /
/dev/sda1           1014M  221M  794M  22% /boot
tmpfs                 78M     0   78M   0% /run/user/1000
```

## Partie 3 : Serveur web

### 2. Install

🌞 Installez NGINX

```
[brendan@web ~]$ sudo dnf install nginx
```

### 3. Analyse

🌞 Analysez le service NGINX

```
[brendan@web ~]$ ps -ef | grep nginx
root        2029       1  0 16:14 ?        00:00:00 nginx: master process /usr/sbin/nginx

[brendan@web ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=2105,fd=6),("nginx",pid=2104,fd=6))
LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=2105,fd=7),("nginx",pid=2104,fd=7))

[brendan@web nginx]$ sudo cat nginx.conf | grep root
root         /usr/share/nginx/html;

[brendan@web nginx]$ ls -al
total 4
drwxr-xr-x.  4 root root   33 Feb 20 16:12 .
drwxr-xr-x. 84 root root 4096 Feb 20 16:12 ..
drwxr-xr-x.  3 root root  143 Feb 20 16:12 html
drwxr-xr-x.  2 root root    6 Oct 16 20:00 modules
```

### 4. Visite du service web

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```
[brendan@web nginx]$ sudo firewall-cmd --add-port=80/tcp --permanent
success

[brendan@web nginx]$ sudo firewall-cmd --reload
success

[brendan@web nginx]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 80/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

🌞 Accéder au site web

```
[brendan@web nginx]$ curl 10.2.1.11
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

[.....]

      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```

🌞 Vérifier les logs d'accès

```
[brendan@web nginx]$ sudo cat access.log | tail -n 3
10.2.1.10 - - [20/Feb/2024:16:33:18 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.2.1.11/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
10.2.1.11 - - [20/Feb/2024:16:33:53 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.2.1.11 - - [20/Feb/2024:16:35:51 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```

### 5. Modif de la conf du serveur web

🌞 Changer le port d'écoute

```
[brendan@web nginx]$ sudo nano nginx.conf

[brendan@web nginx]$ sudo cat nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;

[brendan@web nginx]$ sudo systemctl restart nginx

[brendan@web nginx]$ systemctl status nginx

[brendan@web nginx]$ sudo ss -alpnt | grep nginx
LISTEN 0      511          0.0.0.0:8080       0.0.0.0:*    users:(("nginx",pid=2246,fd=6),("nginx",pid=2245,fd=6))
LISTEN 0      511             [::]:8080          [::]:*    users:(("nginx",pid=2246,fd=7),("nginx",pid=2245,fd=7))

[brendan@web nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[brendan@web nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[brendan@web nginx]$ sudo firewall-cmd --reload
success

[brendan@web nginx]$ curl 10.2.1.11:8080
```

🌞 Changer l'utilisateur qui lance le service

```
[brendan@web ~]$ sudo useradd -m  web2

[brendan@web ~]$ sudo passwd web2

[brendan@web ~]$ su - web2

[brendan@web nginx]$ sudo cat nginx.conf | grep user
user web2;

[brendan@web nginx]$ sudo systemctl restart nginx

[brendan@web nginx]$ ps -ef | grep nginx
root        2530       1  0 17:15 ?        00:00:00 nginx: master process /usr/sbin/nginx
web2        2531    2530  0 17:15 ?        00:00:00 nginx: worker process
brendan     2533    2477  0 17:16 pts/0    00:00:00 grep --color=auto nginx

[brendan@web site_web_1]$ sudo nano index.html

[brendan@web site_web_1]$ sudo cat index.html
yolo

[brendan@web nginx]$ sudo nano nginx.conf

[brendan@web nginx]$ sudo cat nginx.conf | grep root
        root         /var/www/site_web_1;

[brendan@storage storage]$ curl 10.2.1.11:8080
yolo
```

### 6. Deux sites web sur un seul serveur

🌞 Repérez dans le fichier de conf

```
[brendan@web nginx]$ sudo cat nginx.conf | grep include
include /etc/nginx/conf.d/*.conf;
```

🌞 Créez le fichier de configuration pour le premier site

```
[brendan@web conf.d]$ sudo nano 8080.conf

[brendan@web conf.d]$ sudo cat 8080.conf
server {
    listen       8080;
    root         /var/www/site_web_1;
}
```

🌞 Créez le fichier de configuration pour le deuxième site

```
[brendan@web conf.d]$ sudo nano 8888.conf

[brendan@web conf.d]$ sudo cat 8888.conf
server {
    listen       8888;
    root         /var/www/site_web_2;
}
```

🌞 Prouvez que les deux sites sont disponibles

```
[brendan@web conf.d]$ cat /var/www/site_web_1/index.html
yolo

[brendan@web conf.d]$ sudo cat /var/www/site_web_2/index.html
[sudo] password for brendan:
yo b rendan
```