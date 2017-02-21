#! /bin/bash

set -eu

cd
git clone https://github.com/willmoffat/dot-files.git .dotfiles
.dotfiles/link.sh

# TODO(wdm) Check fingerprint
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

git config --global user.name "Will Moffat"
git config --global user.email "will@muuselabs.com"
git config --global color.ui auto
