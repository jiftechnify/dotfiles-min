#!/usr/bin/env bash
set -ue

echo "backuping old dotfiles..."
if [ ! -d "$HOME/.dotbackup" ];then
  echo "$HOME/.dotbackup not found. Auto Make it"
  mkdir "$HOME/.dotbackup"
fi

dotdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd -P)"

if [[ "$HOME" != "$dotdir" ]];then
  for f in $dotdir/.??*; do
    [[ `basename $f` == ".git" ]] && continue
    
    echo `basename $f`
    if [[ -L "$HOME/`basename $f`" ]];then
      rm -f "$HOME/`basename $f`"
    fi
    if [[ -e "$HOME/`basename $f`" ]];then
      mv "$HOME/`basename $f`" "$HOME/.dotbackup"
    fi

    ln -snf $f $HOME
  done
else
  echo "same install src dest"
fi

echo "dotfiles installed!"
