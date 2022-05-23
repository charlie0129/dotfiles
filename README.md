# dotfiles

I am migrating all my scripts, system init scripts, and conf files into this repo. Everything will be added slowly.

It will be a long process, since I don't have much stimulation to migrate when my system is running fine :p.
Most of these files are added during my OS reinstalls.

## Bootstrap

Run `./bootstrap.sh -f` to install these dotfiles.

You can put custom commands and bin in `alias/custom.sh`, `bin/custom/`, and `env/custom.sh`

## Overview

- `alias`: shell aliases
- `bin`: scripts
- `conf`: system configurations
- `cron`: cron jobs
- `env`: environment variables, like PATH
- `font`: fonts

Note: `conf` and `fonts` will not be installed during bootstrap.