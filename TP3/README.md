## I. Service SSH

### 1. Analyse du service

🌞 S'assurer que le service sshd est démarré

```
[brendan@node1 ~]$ sudo systemctl list-units -t service -a | grep sshd
  sshd-keygen@ecdsa.service              loaded    inactive dead    OpenSSH ecdsa Server Key Generation
  sshd-keygen@ed25519.service            loaded    inactive dead    OpenSSH ed25519 Server Key Generation
  sshd-keygen@rsa.service                loaded    inactive dead    OpenSSH rsa Server Key Generation
  sshd.service                           loaded    active   running OpenSSH server daemon
```

🌞 Analyser les processus liés au service SSH

```
[brendan@node1 ~]$ ps -ef | grep sshd
root         693       1  0 14:30 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1516     693  0 14:41 ?        00:00:00 sshd: brendan [priv]
brendan     1520    1516  0 14:41 ?        00:00:00 sshd: brendan@pts/0
brendan     1567    1521  0 14:56 pts/0    00:00:00 grep --color=auto sshd
```

🌞 Déterminer le port sur lequel écoute le service SSH

```
[brendan@node1 ~]$ ss -alt | grep ssh
LISTEN 0      128          0.0.0.0:ssh       0.0.0.0:*
LISTEN 0      128             [::]:ssh          [::]:*
```

🌞 Consulter les logs du service SSH

```
[brendan@node1 ~]$ journalctl | grep ssh
Jan 29 14:30:01 localhost systemd[1]: Created slice Slice /system/sshd-keygen.
Jan 29 14:30:02 localhost systemd[1]: Reached target sshd-keygen.target.
Jan 29 14:30:03 localhost sshd[693]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 14:30:03 localhost sshd[693]: Server listening on 0.0.0.0 port 22.
Jan 29 14:30:03 localhost sshd[693]: Server listening on :: port 22.
Jan 29 14:41:01 node1.tp2.b1 sshd[1516]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 14:41:07 node1.tp2.b1 sshd[1516]: Accepted password for brendan from 10.2.1.10 port 57449 ssh2
Jan 29 14:41:07 node1.tp2.b1 sshd[1516]: pam_unix(sshd:session): session opened for user brendan(uid=1000) by (uid=0)


[brendan@node1 log]$ tail dnf.log
2024-01-29T14:15:56+0100 DDEBUG Command: dnf makecache --timer
2024-01-29T14:15:56+0100 DDEBUG Installroot: /
2024-01-29T14:15:56+0100 DDEBUG Releasever: 9
2024-01-29T14:15:56+0100 DEBUG cachedir: /var/cache/dnf
2024-01-29T14:15:56+0100 DDEBUG Base command: makecache
2024-01-29T14:15:56+0100 DDEBUG Extra commands: ['makecache', '--timer']
2024-01-29T14:15:56+0100 DEBUG Making cache files for all metadata files.
2024-01-29T14:15:56+0100 INFO Metadata timer caching disabled when running on a battery.
2024-01-29T14:15:56+0100 DDEBUG Cleaning up.
2024-01-29T14:15:56+0100 DDEBUG Plugins were unloaded.
```

### 2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH

```
[brendan@node1 ssh]$ cat ssh_config
```

🌞 Modifier le fichier de conf

```
[brendan@node1 ssh]$ sudo cat sshd_config
```

🌞 Modifier le fichier de conf

```
[brendan@node1 ~]$ echo $RANDOM
32437

[brendan@node1 ssh]$ sudo nano sshd_config

[brendan@node1 ssh]$ sudo cat sshd_config | grep Port
[sudo] password for brendan:
Port 32437

[brendan@node1 ssh]$ sudo firewall-cmd --add-port=32437/tcp --permanent

[brendan@node1 ssh]$ sudo firewall-cmd --remove-service ssh --permanent

[brendan@node1 ~]$ sudo systemctl restart NetworkManager

[brendan@node1 ~]$ systemctl status sshd

[brendan@node1 ~]$ ss -alnpt
State             Recv-Q            Send-Q                       Local Address:Port                         Peer Address:Port            Process
LISTEN            0                 128                                0.0.0.0:32437                             0.0.0.0:*
LISTEN            0                 128                                   [::]:32437                                [::]:*
```

🌞 Redémarrer le service

```
systemctl restart
```

🌞 Effectuer une connexion SSH sur le nouveau port

```
PS C:\Users\brend> ssh brendan@10.2.1.11 -p 32437
```


## II. Service HTTP

🌞 Installer le serveur NGINX

```
[brendan@node1 ~]$ sudo dnf install nginx
```

🌞 Démarrer le service NGINX

```
[brendan@node1 ~]$ sudo systemctl enable nginx

[brendan@node1 ~]$ sudo systemctl start nginx
```


🌞 Déterminer sur quel port tourne NGINX

```
[brendan@node1 ~]$ ss -al | grep http
tcp   LISTEN 0      511                                       0.0.0.0:http                     0.0.0.0:*
tcp   LISTEN 0      511                                          [::]:http                        [::]:*


[brendan@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[brendan@node1 ~]$ sudo firewall-cmd --reload
success
[brendan@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client
  ports: 32437/tcp 80/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

🌞 Déterminer les processus liés au service NGINX

```
[brendan@node1 ~]$ ps -ef | grep nginx
root       11391       1  0 16:36 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11392   11391  0 16:36 ?        00:00:00 nginx: worker process
brendan    11420    1450  0 16:45 pts/0    00:00:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```
[brendan@node1 ~]$ cat /etc/passwd | grep nginx
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```

🌞 Test !

```
http://10.2.1.11:80

[brendan@node1 ~]$ curl 10.2.1.11 | head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  1860k      0 --:--:-- --:--:-- --:--:-- 1860k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
```


### 2. Analyser la conf de NGINX

🌞 Déterminer le path du fichier de configuration de NGINX

```
[brendan@node1 /]$ cd /etc

[brendan@node1 etc]$ cd nginx

[brendan@node1 nginx]$ ls -al nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 nginx.conf
```

🌞 Trouver dans le fichier de conf

```
[brendan@node1 nginx]$ cat nginx.conf | grep server -A 100
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }


[brendan@node1 nginx]$ cat nginx.conf | grep include -A 100
include /etc/nginx/default.d/*.conf;
```


## 3. Déployer un nouveau site web

🌞 Créer un site web

```
[brendan@node1 var]$ sudo chown nginx /var/www/tp3_linux

[brendan@node1 www]$ ll
total 0
drwxr-xr-x. 2 nginx root 24 Jan 30 14:16 tp3_linux
```

🌞 Adapter la conf NGINX

```
[brendan@node1 conf.d]$ sudo nano brendan.conf

[brendan@node1 conf.d]$ cat brendan.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 10573;

  root /var/www/tp3_linux;
}

[brendan@node1 conf.d]$ sudo systemctl restart nginx

[brendan@node1 conf.d]$ sudo firewall-cmd --add-port=10573/tcp --perman
ent
success
[brendan@node1 conf.d]$ sudo firewall-cmd --reload
success
```

🌞 Visitez votre super site web

```
[brendan@node1 conf.d]$ curl localhost:10573
<h1>MEOW mon premier serveur web</h1>
```


## III. Your own services

### 2. Analyse des services existants

🌞 Afficher le fichier de service SSH

```
[brendan@node1 conf.d]$ systemctl status sshd


[brendan@node1 conf.d]$ cat /usr/lib/systemd/system/sshd.service
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.target
Wants=sshd-keygen.target

[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
[brendan@node1 conf.d]$ sshd
sshd re-exec requires execution with an absolute path
```

🌞 Afficher le fichier de service NGINX

```
[brendan@node1 conf.d]$ systemctl status nginx


[brendan@node1 conf.d]$ cat /usr/lib/systemd/system/nginx.service
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=mixed
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```


### 3. Création de service

🌞 Créez le fichier /etc/systemd/system/tp3_nc.service

```
[brendan@node1 system]$ sudo nano tp3_nc.service

[brendan@node1 system]$ cat tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 21823 -k
```

🌞 Indiquer au système qu'on a modifié les fichiers de service

```
[brendan@node1 system]$ sudo systemctl daemon-reload
```

🌞 Démarrer notre service de ouf

```
[brendan@node1 system]$ sudo systemctl start tp3_nc.service
```

🌞 Vérifier que ça fonctionne

```
[brendan@node1 system]$ systemctl status tp3_nc.service
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 15:49:52 CET; 3min>
   Main PID: 1864 (nc)
      Tasks: 1 (limit: 4672)
     Memory: 796.0K
        CPU: 6ms
     CGroup: /system.slice/tp3_nc.service
             └─1864 /usr/bin/nc -l 21823 -k

Jan 30 15:49:52 node1.tp2.b1 systemd[1]: Started Super netcat tout fo>
lines 1-11/11 (END)


[brendan@node1 system]$ sudo ss -alntp | grep nc
LISTEN  0       10               0.0.0.0:21823          0.0.0.0:*      users:(("nc",pid=1864,fd=4))



[brendan@node2 ~]$ nc 10.2.1.11 21823
fkhkl

```

🌞 Les logs de votre service

```
[brendan@node1 ~]$ sudo journalctl -xe -u tp3_nc -f
Jan 30 16:29:30 node1.tp2.b1 nc[1864]: fkhkl


- [brendan@node1 ~]$ sudo journalctl -xe -u tp3_nc -f | grep start job
Subject: A start job for unit tp3_nc.service has finished successfully

- [brendan@node1 ~]$ sudo journalctl -xe -u tp3_nc -f | grep fkhkl
  Jan 30 16:29:30 node1.tp2.b1 nc[1864]: fkhkl

- [brendan@node1 ~]$ sudo journalctl -xe -u tp3_nc -f | grep stop job
  Subject: A stop job for unit tp3_nc.service has begun execution
```

🌞 S'amuser à kill le processus

```
[brendan@node1 ~]$ ps -ef | grep nc
dbus         682       1  0 13:40 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root        2116       1  0 17:02 ?        00:00:00 /usr/bin/nc -l 21823 -k
brendan     2118    1918  0 17:02 pts/0    00:00:00 grep --color=auto nc

[brendan@node1 ~]$ sudo kill 2116


```

🌞 Affiner la définition du service

```
[brendan@node1 /]$ cd /etc/systemd/system

[brendan@node1 system]$ sudo nano tp3_nc.service

[brendan@node1 system]$ cat tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 21823 -k
Restart=always

[brendan@node1 system]$ sudo systemctl daemon-reload

[brendan@node1 system]$ sudo systemctl start tp3_nc.service

[brendan@node1 system]$ ps -ef | grep nc
dbus         682       1  0 13:40 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root        2171       1  0 17:08 ?        00:00:00 /usr/bin/nc -l 21823 -k
brendan     2173    1918  0 17:08 pts/0    00:00:00 grep --color=autonc

[brendan@node1 system]$ sudo kill 2171

[brendan@node1 system]$ ps -ef | grep nc
dbus         682       1  0 13:40 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root        2177       1  0 17:08 ?        00:00:00 /usr/bin/nc -l 21823 -k
brendan     2179    1918  0 17:08 pts/0    00:00:00 grep --color=auto nc
```