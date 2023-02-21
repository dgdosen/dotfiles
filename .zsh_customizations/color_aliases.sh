al () {
  appearance_light
}

appearance_light () {
  export APPEARANCE='light'
  ln -sfv /Users/dgdosen/.dotfiles/.config/alacritty/alacritty-colors-light.yml /Users/dgdosen/.config/alacritty/alacritty-colors.yml
}

ad () {
  appearance_dark
}

appearance_dark () {
  export APPEARANCE='dark'
  ln -sfv /Users/dgdosen/.dotfiles/.config/alacritty/alacritty-colors-dark.yml /Users/dgdosen/.config/alacritty/alacritty-colors.yml
}
