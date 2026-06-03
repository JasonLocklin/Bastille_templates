#!/bin/sh

# create zroot/data
zfs create zroot/jails/weechat
zfs create zroot/jails/weechat/config
zfs create zroot/jails/weechat/local


chown -R 1001:1001 /zroot/jails/weechat


bastille create weechat 15.0-RELEASE 10.10.10.3 em0

bastille template weechat /usr/local/bastille/templates/Bastille_templates/irc/weechat

