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

COPY . /root/.dotfiles

WORKDIR /root/.dotfiles

RUN ./bootstrap.sh -f

# Install z4h and all its plugins non-interactively, so the first shell in the
# container starts fully configured. On success z4h exec's an interactive zsh
# to warm everything up -- the gitstatus/p10k warnings in the build log are
# expected (no tty during build) and harmless. The check at the end fails the
# build loudly if the download failed. If GitHub is unreachable, pass a proxy:
#   docker build --build-arg HTTP_PROXY=http://host:port --build-arg HTTPS_PROXY=http://host:port .
# (Docker's predefined proxy build args reach curl without persisting in the image.)
RUN Z4H_BOOTSTRAPPING=1 zsh -c '[[ -r $Z4H/zsh4humans/main.zsh ]] || { printf "z4h bootstrap failed\n" >&2; exit 1; }'
