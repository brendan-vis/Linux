## Partie 1


## I. Fichiers

### 1. Find me

🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```
[brendan@localhost ~]$ pwd
/home/brendan
```

🌞 Trouver le chemin du fichier de logs SSH

```
[brendan@localhost log]$ pwd
/var/log

[brendan@localhost log]$ sudo cat secure
```

🌞 Trouver le chemin du fichier de configuration du serveur SSH

```
[brendan@localhost ssh]$ pwd
/etc/ssh
```


## II. Users

### 1. Nouveau user

🌞 Créer un nouvel utilisateur

```
[brendan@localhost ~]$ sudo useradd -m marmotte

[brendan@localhost ~]$ sudo passwd marmotte
```

### 2. Infos enregistrées par le système

🌞 Prouver que cet utilisateur a été créé

```
[brendan@localhost etc]$ cat passwd | grep marmotte
marmotte:x:1001:1001::/home/marmotte:/bin/bash
```

🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[brendan@localhost etc]$ sudo cat shadow | grep marmotte
marmotte:$6$719AQSGwR92qtg1U$tog.H4/L2AUXk41sHIqLSVrezYwB6mNQKb1CyoXNTbbJuq72YAVPw.7FZOQEv3rIQTuQL6C6elawtLHuvSO4A1:19744:0:99999:7:::
```

### 3. Connexion sur le nouvel utilisateur

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
[brendan@localhost ~]$ exit
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
[marmotte@localhost ~]$ cd /

[marmotte@localhost /]$ ls
afs  boot  etc   lib    media  opt   root  sbin  sys  usr
bin  dev   home  lib64  mnt    proc  run   srv   tmp  var

[marmotte@localhost /]$ cd /home

[marmotte@localhost home]$ cd brendan/
-bash: cd: brendan/: Permission denied
```



## Partie 2


## I. Programmes et processus

### 1. Run then kill

🌞 Lancer un processus sleep

```
[marmotte@localhost ~]$ sleep 1000

[brendan@localhost ~]$ ps -ef | grep sleep
marmotte    1688    1661  0 16:36 pts/0    00:00:00 sleep 1000
brendan     1716    1694  0 16:36 pts/1    00:00:00 grep --color=auto sleep
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```
[brendan@localhost ~]$ sudo kill 1688
```

### 2. Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```
[brendan@localhost ~]$ sleep 1000 &
[1] 1728
```

🌞 Visualisez la commande en tâche de fond

```
[brendan@localhost ~]$ jobs
[1]+  Running                 sleep 1000 &

[brendan@localhost ~]$ jobs -p
1728
```


### 3. Find paths

🌞 Trouver le chemin où est stocké le programme sleep

```
[brendan@localhost ~]$ which sleep
/usr/bin/sleep
```

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```
[brendan@localhost /]$ sudo find / -name .bashrc
/etc/skel/.bashrc
/root/.bashrc
/home/brendan/.bashrc
/home/marmotte/.bashrc
```

### 4. La variable PATH

🌞 Vérifier que

```
[brendan@localhost tmp]$ which sleep
/usr/bin/sleep

[brendan@localhost tmp]$ which ssh
/usr/bin/ssh

[brendan@localhost tmp]$ which ping
/usr/bin/ping
```

## II. Paquets

🌞 Installer le paquet firefox

```
[brendan@localhost ~]$ sudo dnf install git
```

🌞 Utiliser une commande pour lancer Firefox

```
[brendan@localhost ~]$ which git
/usr/bin/git
```

🌞 Installer le paquet nginx

```
[brendan@localhost ~]$ sudo dnf install nginx
```

🌞 Déterminer

```
[brendan@localhost ~]$ which nginx
/usr/sbin/nginx
```

🌞 Mais aussi déterminer...

```
[brendan@localhost yum.repos.d]$ grep -rn -E '^mirrorlist'

rocky-addons.repo:13:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever$rltype
[...]
rocky.repo:88:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=CRB-$releasever-source$rltype
```


## Partie 3 : Poupée russe

🌞 Récupérer le fichier meow

```
[brendan@localhost ~]$ sudo dnf install wget

[brendan@localhost ~]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false


[brendan@localhost ~]$ ls
 bin  'meow?inline=false'
[brendan@localhost ~]$ mv meow\?inline\=false    meow

[brendan@localhost ~]$ mv meow  meow.zip

[brendan@localhost ~]$ sudo dnf install unzip

[brendan@localhost ~]$ file meow.zip
meow.zip: Zip archive data, at least v2.0 to extract
[brendan@localhost ~]$ unzip meow.zip
Archive:  meow.zip
  inflating: meow
[brendan@localhost ~]$ file meow
meow: XZ compressed data
```


🌞 Trouver le dossier dawa/

```
#ZIP
[brendan@localhost ~]$ file meow
meow: Zip archive data, at least v2.0 to extract
[brendan@localhost ~]$ mv meow meow.zip
[brendan@localhost ~]$ sudo dnf install unzip
[brendan@localhost ~]$ sudo unzip meow.zip
Archive:  meow.zip
  inflating: meow

# XZ
[brendan@localhost ~]$ file meow
meow: XZ compressed data
[brendan@localhost ~]$ mv meow meow.xz
[brendan@localhost ~]$ sudo unxz meow.xz


#BZIP
[brendan@localhost ~]$ file meow
meow: bzip2 compressed data, block size = 900k
[brendan@localhost ~]$ mv meow meow.bzip2
[brendan@localhost ~]$ sudo dnf install bzip2
[brendan@localhost ~]$ bzip2 -d meow.bzip2


#RAR
[brendan@localhost ~]$ file meow.bz2
meow.bz2: RAR archive data, v5
[brendan@localhost ~]$ mv meow.bz2 meow.rar
[brendan@localhost ~]$ sudo dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
[brendan@localhost ~]$ sudo dnf install unrar
[brendan@localhost ~]$ sudo unrar e meow.rar


#GZIP
[brendan@localhost ~]$ file meow
meow: gzip compressed data, from Unix, original size modulo 2^32 145049600
[brendan@localhost ~]$ mv meow.gzip meow.gz
[brendan@localhost ~]$ sudo gunzip meow.gz


#TAR
[brendan@localhost ~]$ file meow
meow: POSIX tar archive (GNU)
[brendan@localhost ~]$ mv meow meow.tar
[brendan@localhost ~]$ tar -xf meow.tar


[brendan@localhost ~]$ ls
bin  dawa  meow.rar  meow.tar  meow.zip
```