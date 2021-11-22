# init.sh

This script is used to initialize Linux development environment.

Currently, this script does the followings:

- evaluate `direnv`
- initialize bash prompt

## Usage

To initialize development environment in a container,

```bash
curl -sL https://raw.githubusercontent.com/taicaile/init.sh/master/dev-init.sh | sudo bash
```

```text
# TODO

- install docker option

- install mysql option

- install livepath option

- install fail2ban option

- [x] copy all dot files to home directory.

- [x] add init.sh for all users (system-wide)
```

Get product information,

```text
cat /sys/devices/virtual/dmi/id/sys_vendor

cat /sys/devices/virtual/dmi/id/product_name

cat /sys/devices/virtual/dmi/id/product_version

cat /sys/devices/virtual/dmi/id/product_family
```
