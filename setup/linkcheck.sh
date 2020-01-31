if [ -d "/Users/ddosen/.dotfiles" ]
then
  echo "dotfiles exists"
else
  echo "dotfiles does not exist"
fi

[ -d "$HOME/.dotfiles" ] && echo "inline dotfiles exists" || echo "inline dotfiles does not exist"


if [ -d "/Users/ddosen/.dotfilesfoo" ]
then
  echo "dotfilesfoo exists"
else
  echo "dotfilesfoo does not exist"
fi

[ -d "/Users/ddosen/.dotfilesfoo" ] && echo "inline dotfilesfoo exists" || echo "inline dotfilesfoo does not exist"

if [ -d "/Users/ddosen/.vim" ]
then
  echo "vim exists"
else
  echo "vim does not exist"
fi

if [ ! -L "$HOME/.vim" ]
then
  echo "vim link does not exists"
else
  echo "vim link does not not exist"
fi

if [ -L "/Users/ddosen/Downloads" ]
then
  echo "downloads link exists"
else
  echo "downloads link  does not exist"
fi
