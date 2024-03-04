sd#!/bin/bash
# brendan
# 23/02/2024


if [[ $(id -un) != 'root' ]] ; then
  echo "You should run this script as root. Exiting."
  exit 1
fi


machine_name=$(hostnamectl | grep Static | cut -d' ' -f4)
echo "Machine name: ${machine_name}"

os=$(cat /etc/os-release | grep NAME | head -n 1 | cut -d'"' -f2)
version=$(uname -r)
echo "OS = ${os} and kernel version is ${version}"

ip=$(ip a | grep enp0s3 | tail -n 1 | cut -d' ' -f6)
echo "IP = $ip"

ramav=$(free -h |grep Mem | tr -s ' ' | cut -d' ' -f7)
ramtot=$(free -h |grep Mem | tr -s ' ' | cut -d' ' -f2)
echo "RAM = ${ramav} memory available on ${ramtot} total memory"

disk=$(df -h | grep root | cut -d' ' -f7)
echo "Disk = ${disk} space left"

echo "Top 5 processes by RAM usage :"
processes=$(ps -eo command= --sort=-%mem  | head -n5 | cut -d' ' -f1)
while read process
do
  process_name=$(basename $process)
  echo "  - ${process_name}"
done <<< ${processes}

echo "Listening ports"
while read brendan
do
  port="$(echo $brendan | cut -d' ' -f5 | cut -d':' -f2)"
  proto="$(echo $brendan | tr -s ' ' | cut -d' ' -f1)"
  program="$(echo $brendan | tr -s ' ' | cut -d'"' -f2)"

  echo "  - $port $proto : $program"
done <<< "$(ss -lntu4Hp)"

echo "PATH directories"
while read chemin
do
  echo " - $chemin"
done <<< "$(echo $PATH | tr -s ':' '\n')"

cat=$(curl -s https://api.thecatapi.com/v1/images/search | cut -d'"' -f8)
echo "Here is your random cat (jpg file) : $cat"