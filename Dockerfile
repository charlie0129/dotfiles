FROM debian:unstable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&                          \
    apt-get install -y --no-install-recommends \
        apt-transport-https                    \
        ca-certificates

# Use Debian mirrors in China. If you have a good network connection, you probably don't need this.
# RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free" > /etc/apt/sources.list

RUN apt-get install -y --no-install-recommends \
    zsh    \
    vim    \
    tmux   \
    neovim \
    git    \
    curl

RUN chsh -s /bin/zsh

COPY . /root/dotfiles

WORKDIR /root

RUN ./bootstrap.sh -f
