# Build caddy jail script

# If starting from scratch, comment this line, otherwise, destroy the old jail first
bastille destroy -y --auto  caddy
sleep 1
bastille destroy -y -f --auto caddy


# Create shared directories for mounting to host
mkdir -p /var/log/jails/caddy
chown -R 80:80 /var/log/jails/caddy

# Build caddy binary with porkbun
pkg install xcaddy

# Module cache - PERSISTENT, lives across builds, not on tmpfs
mkdir -p /root/gomodcache

# Build cache and tmp - ephemeral, tmpfs is fine and appropriate here,
# since these genuinely are pure churn with no reuse value across builds
mkdir -p /root/gobuild
mount -t tmpfs -o size=3g tmpfs /root/gobuild
mkdir -p /root/gobuild/cache /root/gobuild/tmp

env GOCACHE=/root/gobuild/cache GOMODCACHE=/root/gomodcache GOTMPDIR=/root/gobuild/tmp \
    xcaddy build --output usr/local/bin/caddy \
    --with github.com/caddy-dns/porkbun

umount /root/gobuild

# Build the jail
bastille create caddy 15.1-release 10.10.10.10 em0
bastille template caddy /usr/local/bastille/templates/Bastille_templates/www/caddy --arg-file /root/bastille-secrets/caddy.env
bastille rdr caddy tcp 80 8080
bastille rdr caddy tcp 443 8443

# Ensure pkg upgrade never clobbers this binary
bastille pkg -y caddy lock caddy

echo "done."
