FROM phusion/baseimage:0.11
MAINTAINER faker <b09780978@gmail.com>

WORKDIR /root

# Set env.
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV XDG_CONFIG_HOME /root/.config

# Add config file.
ADD .bashrc .
Add .vimrc .
ADD .zshrc .
Add .tmux.conf .

# Use baseimage-docker's init system.
ENTRYPOINT ["/sbin/my_init"]

# Upgrade all package and install gcc, git, python and some often used tools.
RUN apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get install -y \
&& apt-get install -y gcc g++ gdb \
&& apt-get install -y git \
&& apt-get install -y bash-completion \
&& apt-get install -y file \
&& apt-get install -y wget \
&& add-apt-repository ppa:neovim-ppa/stable \
&& apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get install -y python python-pip python-dev \
&& apt-get install -y python3 python3-pip python3-dev

# Update pip and install needed python packages.
RUN python2 -m pip install pip -U \
&&  python3 -m pip install pip -U \
&&  pip2 install ipython \
&&  pip3 install ipython

# Install neovim and update plugins.
RUN apt-get install -y neovim \
&& pip2 install neovim --user \
&& pip3 install neovim --user \
&& curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&& mkdir -p ~/.config/nvim \
&& ln ~/.vimrc ~/.config/nvim/init.vim \
&& nvim +PlugInstall +q +UpdateRemotePlugins +q
    
# Install zsh and tmux.
RUN apt-get install -y zsh \
&& apt-get install -y tmux \
&& git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
&& chsh -s /bin/zsh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
