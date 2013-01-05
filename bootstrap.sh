#!/usr/bin/env sh

endpath="$HOME/.myvim"

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

lnif() {
    if [ ! -e $2 ] ; then
        ln -s $1 $2
    fi
    if [ -L $2 ] ; then
        ln -sf $1 $2
    fi
}

echo "Thanks for installing spf13-vim"

# Backup existing .vim stuff
echo "backing up current vim config"
today=`date +%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc; do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today; done


if [ ! -e $endpath/.git ]; then
    echo "cloning spf13-vim\n"
    git clone --recursive -b 3.0 http://github.com/yiyangest/.vim.git $endpath
else
    echo "updating vim\n"
    cd $endpath && git pull
fi


echo "setting up symlinks"
lnif $endpath/.vimrc $HOME/.vimrc
lnif $endpath/.vimrc.fork $HOME/.vimrc.fork
lnif $endpath/.vimrc.bundles $HOME/.vimrc.bundles
lnif $endpath/.vimrc.bundles.fork $HOME/.vimrc.bundles.fork
lnif $endpath/.vim $HOME/.vim
if [ ! -d $endpath/.vim/bundle ]; then
    mkdir -p $endpath/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

echo "update/install plugins using Vundle"
system_shell=$SHELL
export SHELL="/bin/sh"
vim -u $endpath/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell
