Bastille template to bootstrap Caddy

Reverse proxies Readeck, Miniflux, Kavita, and WebDAV under `${DOMAIN}`,
runs as the unprivileged `www` user, and terminates 80/443 via host-side
`bastille rdr` NAT rather than binding privileged ports directly.

## Prerequisites

### Create the arg file

This template uses Bastille's `ARG`/`RENDER` mechanism to inject secrets
and per-service details into the Caddyfile at apply time. None of these
values live in the template itself. Create an env-style file (kept outside
the template directory - e.g. `/root/bastille-secrets/caddy.env`) with one `NAME=value` per
line:

```
DOMAIN=mydomain.com
PORKBUN_API_KEY=...
PORKBUN_API_SECRET_KEY=...

READECK_TOKEN_HOST=...
READECK_IP=...
READECK_PATH=...        # bare path segment, no leading/trailing slash

MINIFLUX_TOKEN_HOST=...
MINIFLUX_IP=...
MINIFLUX_PATH=...       # bare path segment, no leading/trailing slash

KAVITA_TOKEN_HOST=...
KAVITA_IP=...

WEBDAV_TOKEN_HOST=...
WEBDAV_IP=...
```

## Usage

```shell
./build.sh
```

## Re-applying after changes

Editing the Caddyfile or `caddy.env` requires re-running the template to
re-render and pick up changes:

```shell
bastille template caddy www/caddy --arg-file /root/caddy.env
bastille service caddy caddy restart
```

Note that lets encrypt keys are not conserved, so repeated running build.sh will eventually get you rate-limited.
