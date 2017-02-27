# Short for docker-machine
dm () {
  docker-machine $@
}
# Switch docker pointer to another host (dmenv my_remote_host)
dmenv () {
  eval "$(docker-machine env $1)"
}
# Short for docker
doc () {
  docker $@
}
