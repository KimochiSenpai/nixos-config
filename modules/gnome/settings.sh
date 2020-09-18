#!/bin/sh
set -x

gsettings set org.gnome.desktop.background picture-uri 'file:///run/current-system/sw/share/backgrounds/gnome/adwaita-night.jpg'
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Numix'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling autorun-never true
gsettings set org.gnome.desktop.notifications show-in-lock-screen false
gsettings set org.gnome.desktop.peripherals.mouse speed 0.375
gsettings set org.gnome.desktop.privacy recent-files-max-age 30
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
gsettings set org.gnome.settings-daemon.plugins.media-keys logout '[]'

echo 'window.ssd headerbar.titlebar { padding-top: 2px; padding-bottom: 2px; }' > ~/.config/gtk-3.0/gtk.css
