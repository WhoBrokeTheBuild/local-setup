#!/bin/sh

read -p "Install Atom (y/n)? " choice
case "$choice" in
  y|Y )

    curl -o atom.rpm https://atom.io/download/rpm
    sudo dnf install ./atom.rpm
    /usr/bin/rm -f atom.rpm
    
    apm install \
        language-cmake language-flatbuffers language-lua language-batch \
        language-bison language-cpp14 language-docker language-lex-flex \
        switch-header-source autocomplete-clang build build-make linter-clang \
        less-than-slash pigments minimap
    sudo dnf install -y clang

  ;;
esac


read -p "Install ZSH (y/n)? " choice
case "$choice" in
  y|Y )

    sudo dnf install -y zsh hub
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    /usr/bin/cp -f .zshrc ~/.zshrc

  ;;
esac
