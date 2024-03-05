#!/bin/bash
# brendan
# 05/03/2024

_youtube_dl=/usr/local/bin/youtube-dl

URL="$1"
TITLE=$($_youtube_dl --get-title "${URL}")
date=$(date '+[%y/%m/%d %H:%M:%S]')

path="/srv/yt/downloads/${TITLE}/${TITLE}.mp4"

mkdir "/srv/yt/downloads/${TITLE}"

$_youtube_dl -o "${path}" --format mp4 "${URL}" > /dev/null
$_youtube_dl --get-description "${URL}" > "/srv/yt/downloads/${TITLE}/description"


echo "${date} video ${URL} was downloaded. File path : ${path}" >> /var/log/yt/download.log
