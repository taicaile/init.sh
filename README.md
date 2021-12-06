# init.sh

This script is used to initialize Linux development environment.

Currently, this script does the followings:

- evaluate `direnv`
- initialize bash prompt

## Usage

To initialize development environment for a container,

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
