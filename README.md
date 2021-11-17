# init.sh

This script is used to initialize Linux development environment.

Currently, this script does the followings:

- evaluate `direnv`
- initialize bash prompt

## Usage

```bash
wget https://raw.githubusercontent.com/taicaile/init.sh/master/init.sh -O  /home/init.sh
```

```bash
# add the following to ~/.bashrc
source /home/init.sh
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
