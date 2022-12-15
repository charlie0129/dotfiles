# dotfiles

I am migrating all my scripts, system init scripts, and conf files into this repo. Everything will be added slowly.

It will be a long process, since I don't have much stimulation to migrate when my system is running fine :p.
Most of these files are added during my OS reinstalls.

## Try

You can use Docker to try out these dotfiles in a container without installing them into your system. Note that it is expected to be some display issues with the prompt.

```bash
# We need some source to build the container
git clone --recurse-submodules --shallow-submodules https://github.com/charlie0129/dotfiles
cd dotfiles
# Build the container. Just installs some packages, copies the dotfiles, bootstaps dotfiles, and that's it.
docker build -t dotfiles .
# Run it!
docker run -it --rm dotfiles /bin/zsh
```

## Install

```bash
# Clone this repo to ~/dotfiles.
git clone --recurse-submodules --shallow-submodules https://github.com/charlie0129/dotfiles ~/dotfiles
cd ~/dotfiles
# Install the dotfiles. (If necessary, use -f to overwrite any existing files.)
./bootstrap.sh
```

You can put custom commands and bin in `alias/custom.sh`, `bin/custom/`, and `env/custom.sh`. (TODO: write some documentations.)

## Overview

- `alias`: shell aliases
- `bin`: scripts
- `conf`: system configurations
- `cron`: cron jobs
- `env`: environment variables, like PATH
- `font`: fonts

Note: `conf` and `fonts` will not be installed during bootstrap.