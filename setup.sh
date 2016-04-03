#!/bin/sh

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
if [[ "$@" != *"--no-update"* ]]; then
    setup__update
fi

setup__tools()
{
    printf "### Installing Tools ###\n"
    sudo dnf install -y vim jq clang
    printf "\n"
}
if [[ "$@" != *"--no-tools"* ]]; then
    setup__tools
fi

setup__chrome()
{
    printf "### Installing Chrome ###\n"
    sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    printf "\n"
}
if [[ "$@" != *"--no-chrome"* ]]; then
    setup__chrome
fi

setup__rpmfusion()
{
    printf "### Adding RPM-Fusion Repositories ###\n"
    sudo dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-23.noarch.rpm \
        http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-23.noarch.rpm
    printf "\n"
}
if [[ "$@" != *"--no-rpmfusion"* ]]; then
    setup__rpmfusion
fi

setup__vim()
{
    printf "### Installing Vim ###\n"
    sudo dnf install -y vim
    rm -rf ~/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    /usr/bin/cp -rf .vim ~/
    /usr/bin/cp -f .vimrc ~/
    vim +PluginInstall +qall
    printf "\n"
}
if [[ "$@" != *"--no-vim"* ]]; then
    setup__vim
fi

setup__atom()
{
    printf "### Installing Atom ###\n"
    curl -o atom.rpm https://atom.io/download/rpm
    sudo dnf install -y ./atom.rpm
    /usr/bin/rm -f atom.rpm

    apm install \
        language-cmake language-flatbuffers language-lua language-batch \
        language-bison language-cpp14 language-docker language-lex-flex \
        switch-header-source autocomplete-clang build build-make linter-clang \
        less-than-slash pigments minimap emmet-simplified
    sudo dnf install -y clang
    printf "\n"
}
if [[ "$@" != *"--no-atom"* ]]; then
    setup__atom
fi

setup__zsh()
{
    printf "### Installing ZSH ###\n"
    sudo dnf install -y zsh hub
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    /usr/bin/cp -f .zshrc ~/
    printf "\n"
}
if [[ "$@" != *"--no-zsh"* ]]; then
    setup__zsh
fi

setup__shell_extensions()
{
    printf "### Installing Gnome Shell Extensions ###\n"
    sudo dnf install -y gnome-tweak-tool

    GNOME_SHELL_VER=`gnome-shell --version | awk -F' ' '{printf $3}'`

    sh shell-extension-install.sh $GNOME_SHELL_VER 442 # Drop Down Terminal
    sh shell-extension-install.sh $GNOME_SHELL_VER 517 # Caffeine
    sh shell-extension-install.sh $GNOME_SHELL_VER 800 # Remove Dropdown Arrows
    sh shell-extension-install.sh $GNOME_SHELL_VER 906 # Sound Input & Output Device Chooser
    sh shell-extension-install.sh $GNOME_SHELL_VER 277 # Impatience
    sh shell-extension-install.sh $GNOME_SHELL_VER 352 # Quick Close in Overview
    sh shell-extension-install.sh $GNOME_SHELL_VER 234 # Steal My Focus
    printf "\n"
}
if [[ "$@" != *"--no-shell-ext"* ]]; then
    setup__shell_extensions
fi

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
if [[ "$@" != *"--no-git"* ]]; then
    setup__git
fi

setup__playonlinux()
{
    printf "### Installing PlayOnLinux ###\n"
    sudo dnf install -y http://rpm.playonlinux.com/playonlinux-yum-4-1.noarch.rpm
    sudo dnf install -y playonlinux
    printf "\n"
}
if [[ "$@" != *"--no-playonlinux"* ]]; then
    setup__playonlinux
fi

setup__i3()
{
    printf "### Installing i3 ###\n"
    sudo dnf install -y i3 dmenu xbacklight i3status i3lock feh conky xdotool

    /bin/cp -rf .config/i3 ~/.config/
    /bin/cp -rf .config/i3status ~/.config/
    sudo /bin/cp i3-exec-wait /usr/local/bin/
    sudo /bin/cp i3init /usr/local/bin/
    sudo /bin/cp i3.session /usr/share/gnome-session/sessions/i3.session

    /bin/cp bg/i3background.jpg ~/Pictures/i3background.jpg

    printf "\n"
}
if [[ "$@" != *"--no-i3"* ]]; then
    setup__i3
fi
