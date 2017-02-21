#! /bin/bash
set -eu

mkdir "$HOME/.i3"
pushd "$HOME/.i3"
ln -si ~/.dotfiles/i3/config
popd

pushd "$HOME"
FILES=$(find .dotfiles -maxdepth 1 -not -name '*.git' -iwholename '.dotfiles/.*' -print)
for FILE in "$FILES"; do
  ln -si "$FILE" "$HOME"
done
popd

echo "Remember to manually copy files in machines/"
