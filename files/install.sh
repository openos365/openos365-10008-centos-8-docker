#!/usr/bin/env bash
set -x

export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
export TERM=xterm-256color
echo $PROJECT_NAME
cd $CMD_PATH
env

whoami
pwd

sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
yum makecache

yum update -y
yum install epel-release -y
yum install dnf -y

dnf --assumeyes update

dnf --assumeyes install perl 
dnf --assumeyes install rsync

rsync -avzP ./root/ /


dnf clean all
dnf makecache

dnf --assumeyes install epel-release dnf-plugins-core
dnf --assumeyes upgrade epel-release

sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!https\?://download\.fedoraproject\.org/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' \
    -e 's!https\?://download\.example/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' \
    -i /etc/yum.repos.d/epel*.repo
yum makecache

crb enable

dnf --assumeyes install kiwi 
dnf --assumeyes install sudo
dnf --assumeyes update
dnf --assumeyes install qemu-img
dnf --assumeyes install dosfstools

cd ~
if [ -d versions ];then
    rm -rf versions
fi
mkdir versions
cd versions
dnf list installed > dnf.list.installed.txt
dnf list > dnf.list.txt

sed -i '1,2d' dnf.list.installed.txt
sed -i '1d' dnf.list.txt


