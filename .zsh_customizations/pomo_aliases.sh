# Short for docker-machine
pi () {
  pomo incomplete $@
}

pl () {
  pomo list --all
}

pb5 () {
  pomo break 5
}

pb () {
  pomo break $@
}

pa () {
  pomo add $@
}

ps () {
  pomo start $@
}

pc () {
  pomo clear
}
