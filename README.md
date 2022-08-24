# init.sh

This script is used to initialize Linux development environment.

Currently, this script does the followings:

- evaluate `direnv`
- initialize bash prompt

## Usage

To create swap file for Linux automatically,

```bash
curl -sL https://raw.githubusercontent.com/taicaile/init.sh/master/setup-swap.sh | bash
```

To initialize development environment,

```bash
curl -sL https://raw.githubusercontent.com/taicaile/init.sh/master/setup-dev.sh | bash
```

To update bash prompt and setup timezone,

```bash
curl -sL https://raw.githubusercontent.com/taicaile/init.sh/master/setup-init.sh | sudo bash
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
