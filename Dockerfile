FROM phusion/baseimage:master-amd64
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
ADD .p10k.zsh .

# Install tools which I usually used
RUN add-apt-repository ppa:neovim-ppa/stable \
&& apt update \
&& apt upgrade -y \
&& apt install -y gcc g++ gdb file \
&& apt install -y bash-completion \
&& apt install -y wget curl \
&& apt install -y nodejs npm \
&& apt install -y git neovim\
&& apt update \
&& apt dist-upgrade -y \
&& apt install -y python python-dev \
&& apt install -y python3 python3-dev

# Update pip and install needed python packages.
RUN cd /tmp \
&& wget https://bootstrap.pypa.io/get-pip.py \
&& python3 get-pip.py \
&& python3 -m pip install pip -U \
&& pip3 install ipython requests pyquery aiohttp cchardet aiodns

# Install neovim and update plugins.
RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&& mkdir -p ~/.config/nvim \
&& ln ~/.vimrc ~/.config/nvim/init.vim \
&& nvim +PlugInstall +q +UpdateRemotePlugins +q

# Install zsh, tmux and used plugins
RUN apt install -y zsh \
&& apt install -y tmux \
&& git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm \
&& wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS NF Regular.ttf" \
&& mkdir -p ~/.fonts/ \
&& mv "MesloLGS NF Regular.ttf" ~/.fonts/ \
&& zsh -ic "source ~/.zshrc" \
&& chsh -s /bin/zsh

# Clean up APT  cache when done.
RUN apt autoremove -y \
&& apt autoclean -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
