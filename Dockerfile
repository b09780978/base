FROM phusion/baseimage:0.11
MAINTAINER faker <b09780978@gmail.com>

WORKDIR /root

ENV TERM xterm-256color

# Use baseimage-docker's init system.
ENTRYPOINT ["/sbin/my_init"]

# Upgrade all package.
RUN apt-get update &&\
    apt-get dist-upgrade -y &&\
    apt-get install -y gcc g++ gdb &&\
    apt-get install -y wget &&\
    apt-get install -y python python-pip &&\
    apt-get install -y python3 python3-pip &&\
    pip install ipython &&\
    pip3 install ipython

# Install vim, git, bash, zsh and tmux.
RUN apt-get install -y vim-gui-common vim-runtime &&\
    apt-get install -y git &&\
    apt-get install -y bash-completion &&\
    apt-get install -y zsh &&\
    apt-get install -y tmux &&\
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    chsh -s /bin/zsh &&\
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&\
    vim +PlugInstall +q +UpdateRemotePlugins +q

ADD .bashrc .
Add .vimrc .
ADD .zshrc .
Add .tmux.conf .

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
