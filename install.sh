sudo pacman -Syu yay 
yay -S xmonad xmonad-contrib xterm nitrogen dmenu alacritty picom-jonaburg-git xmobar rofi
nitrogen --set-auto night.jpg

mkdir -p $HOME/.xmonad
mkdir -p $HOME/.config/picom
mkdir -p $HOME/.config/xmobar
mkdir -p $HOME/.config/rofi
cp -rf .xmonad/* $HOME/.xmonad/
cp -rf picom/* $HOME/.config/picom/
cp -rf xmobar/* $HOME/.config/xmobar/
cp -rf rofi/* $HOME/.config/rofi/
sudo locale-gen
