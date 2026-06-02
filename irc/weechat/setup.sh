#!/bin/sh

# create zroot/data
zfs create zroot/jails/weechat
zfs create zroot/jails/weechat/config
zfs create zroot/jails/weechat/local


chown -R 1001:1001 /zroot/jails/weechat
