#!/bin/sh

# the lines bellow fixes docker-compose up issues inside WSL
# see https://github.com/microsoft/WSL/issues/7174#issuecomment-940163080
parentof() {
    pid=$(ps -p ${1:-$$} -o ppid=;)
    echo ${pid// /}
}
interop_pid=$$
while true ; do
    [[ -e /run/WSL/${interop_pid}_interop ]] && break
    interop_pid=$(parentof ${interop_pid})
    [[ ${interop_pid} == 1 ]] && break
done
if [[ ${interop_pid} == 1 ]] ; then
    echo "Failed to find a parent process with a working interop socket.  Interop is broken."
else
    export WSL_INTEROP=/run/WSL/${interop_pid}_interop
fi

# Windows IP
export HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')

# Port comes from Qv2ray.Preferences.InboundSettings.SOCKSSettings.Port
# For windows define environment variables bellow in uppercase
# see https://stackoverflow.com/a/41570055
# export http_proxy=socks5://$HOST_IP:10089
# export http_proxy=http://$HOST_IP:8889
# export http_proxy=$HOST_IP:2081
# export https_proxy=$http_proxy
# export ftp_proxy=$http_proxy
# export all_proxy=$http_proxy
# export HTTP_PROXY=$http_proxy
# export HTTPS_PROXY=$http_proxy
# export FTP_PROXY=$http_proxy
# export ALL_PROXY=$http_proxy

#echo "socks5 $HOST_IP 10089" > /etc

# npm config set proxy $all_proxy
# npm config set https-proxy $all_proxy

# yarn config set proxy $all_proxy
# yarn config set https-proxy $all_proxy

# set DISPLAY variable to the IP automatically assigned to WSL2
# export DISPLAY=$HOST_IP:0.0
# export LIBGL_ALWAYS_INDIRECT=1

sudo /etc/init.d/dbus start &> /dev/null

# Rust needs that
# export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc



# How to use arvancloud mirrors for docker?
# - Open `C:\Users\2rajp\.docker\daemon.json`:
# - Append these couple of lines:
#    "insecure-registries" : ["https://docker.arvancloud.ir"],
#    "registry-mirrors": ["https://docker.arvancloud.ir"]

