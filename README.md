## dot-files

Will's Linux environment. Nothing very special.

On new machine:
````
git clone git@github.com:willmoffat/dot-files.git
mv dot-files .dotfiles
./dotfiles/link.sh
````
Note that an SSH clone required for ssh ForwardAgent to work.

### Files
~/bin
* fileserver - Go based static file server with trivial logging. Should be a faster version of `python -m SimpleHTTPServer`.

### TODO

* Consider adding these files:
  ~/.config/git/ignore
* Script to compile, download my ~/bin.
* ~/.xinputrc
  # Note(wdm) Capslock as Control
  setxkbmap -option ctrl:nocaps
* `ln -s ~/.dotfiles/i3-wm-config ~/.i3/config`
TODO: ./ssh/config
