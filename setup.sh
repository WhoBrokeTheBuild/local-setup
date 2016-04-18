#!/bin/sh

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [[ "$@" == "--help" ]]; then
    printf "  --no-update      Skip package update/upgrade\n"
    printf "  --no-tools       Skip installing Tools\n"
    printf "  --no-chrome      Skip installing Google Chrome\n"
    printf "  --no-rpmfusion   Skip adding RPM-Fusion Repositories\n"
    printf "  --no-vim         Skip installing Vim\n"
    printf "  --no-atom        Skip installing Atom\n"
    printf "  --no-zsh         Skip installing ZSH\n"
    printf "  --no-shell-ext   Skip installing Gnome Shell Extensions\n"
    printf "  --no-git         Skip installing/configuring Git\n"
    printf "  --no-playonlinux Skip installing PlayOnLinux\n"
    printf "  --no-i3          Skip installing i3\n"
    exit
fi

setup__update()
{
    printf "### Updating Fedora ###\n"
    sudo dnf update -y && sudo dnf upgrade -y
    printf "\n"
}

setup__tools()
{
    printf "### Installing Tools ###\n"
    sudo dnf install -y vim jq clang cmake
    printf "\n"
}

setup__chrome()
{
    printf "### Installing Chrome ###\n"
    sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    printf "\n"
}

setup__rpmfusion()
{
    printf "### Adding RPM-Fusion Repositories ###\n"
    sudo dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-23.noarch.rpm \
        http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-23.noarch.rpm
    printf "\n"
}

setup__vim()
{
    printf "### Installing Vim ###\n"
    sudo dnf install -y vim cmake clang python-devel
    rm -rf ~/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    /usr/bin/cp -rf vim/home/ ~/
    vim +PluginInstall +qall

    cd ~/.vim/bundle/youcompleteme && ./install.py --clang-completer
    cd $DIR

    printf "\n"
}

setup__atom()
{
    printf "### Installing Atom ###\n"
    curl -o /tmp/atom.rpm https://atom.io/download/rpm
    sudo dnf install -y /tmp/atom.rpm

    apm install \
        language-cmake language-flatbuffers language-lua language-batch \
        language-bison language-cpp14 language-docker language-lex-flex \
        switch-header-source autocomplete-clang build build-make linter-clang \
        less-than-slash pigments minimap emmet-simplified merge-conflicts

    sudo dnf install -y clang

    printf "\n"
}

setup__zsh()
{
    printf "### Installing ZSH ###\n"
    sudo dnf install -y zsh hub

    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    chsh -s $(grep /zsh$ /etc/shells | tail -1)

    shopt -s dotglob

    /usr/bin/cp -f zsh/home/* ~/

    shopt -u dotglob

    printf "\n"
}

setup__git()
{
    printf "### Installing / Configuring Git ###\n"
    sudo dnf install -y git
    git config --global user.name "Stephen Lane-Walsh"
    git config --global user.email "sdl.slane@gmail.com"
    git config --global core.editor /usr/bin/vim
    git config --global push.default simple
    printf "\n"
}

setup__playonlinux()
{
    printf "### Installing PlayOnLinux ###\n"
    sudo dnf install -y http://rpm.playonlinux.com/playonlinux-yum-4-1.noarch.rpm
    sudo dnf install -y playonlinux
    printf "\n"
}

setup__i3()
{
    printf "### Installing i3 ###\n"
    sudo dnf install -y i3 dmenu xbacklight i3status i3lock feh conky xdotool

    shopt -s dotglob

    /bin/cp -rf i3/home/* ~/
    sudo /bin/cp -rf i3/bin/* /usr/local/bin/
    sudo /bin/cp i3/i3.session /usr/share/gnome-session/sessions/i3.session

    shopt -u dotglob

    git clone git://github.com/vivien/i3blocks /tmp/i3blocks
    cd /tmp/i3blocks
    make clean all && sudo make install
    cd $DIR

    git clone git://github.com/chjj/compton /tmp/compton
    cd /tmp/compton
    make && sudo make install
    cd $DIR

    pkill compton
    compton --config ~/.i3/compton.conf -CGb

    printf "\n"
}

main()
{
    if [[ "$@" != *"--no-update"* ]]; then
        setup__update
    fi
    if [[ "$@" != *"--no-tools"* ]]; then
        setup__tools
    fi
    if [[ "$@" != *"--no-chrome"* ]]; then
        setup__chrome
    fi
    if [[ "$@" != *"--no-rpmfusion"* ]]; then
        setup__rpmfusion
    fi
    if [[ "$@" != *"--no-vim"* ]]; then
        setup__vim
    fi
    if [[ "$@" != *"--no-atom"* ]]; then
        setup__atom
    fi
    if [[ "$@" != *"--no-zsh"* ]]; then
        setup__zsh
    fi
    if [[ "$@" != *"--no-git"* ]]; then
        setup__git
    fi
    if [[ "$@" != *"--no-playonlinux"* ]]; then
        setup__playonlinux
    fi
    if [[ "$@" != *"--no-i3"* ]]; then
        setup__i3
    fi
}

main $@
