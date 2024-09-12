#!/usr/bin/env zsh 

#set cfg path if it's not already set
: ${SM_CFG_PATH:=${XDG_CONFIG_HOME:-$HOME/.config}/zsh-shellmark/config.txt}

#Crating CFG FILE on Script start if it doesnt exist
[ -e "$(dirname "$SM_CFG_PATH")" ] || mkdir -p "$(dirname "$SM_CFG_PATH")"
[ -e "$SM_CFG_PATH" ] || touch "$SM_CFG_PATH"

mark=""

#checking if the given value is realdir or not
is_dir() {
  local dir="$1"
  if [ -d "$dir" ]; then
    printf "\033[1;32m\n - $dir will be add to the config \n \033[0m"
  else
    printf "\033[1;31m\n - $dir is not real directory\n \033[0m"
  fi
  }

#setting the mark value to the user input
reading_input() {
  echo "enter the full path to the dir you want marked leave empty if the dir you want added is the currend dir"
  vared -p "add mark: " -c mark
  if [ -z "$mark" ]; then
    mark="$(pwd)"
  else
    is_dir "$mark" || reading_input
  fi
  }



#checking if the mark already add to config.txt  if not add it to config
check_if_mark_exist(){
  grep -Fx "$mark" "$SM_CFG_PATH" && printf "\033[1;32m\n - the dir : $mark is already marked\n \033[0m" || echo "$mark" >> $SM_CFG_PATH && 
  printf "\033[1;32m \n - you have add $mark to the mark list\n \033[0m"
}

#md stand for mark directory,it's the function we call from the sehll 
md() {
  reading_input
  mark=${mark:A} # changing path to absolute
  check_if_mark_exist
  mark=""
  sed -i "/^$/d" "$SM_CFG_PATH"
}

shellmark(){
  mark="$(pwd)"
  check_if_mark_exist
  mark=""
  sed -i "/^$/d" "$SM_CFG_PATH" #removing empty line if exist
  zle -I
}


goto_mark(){
  selected_mark="$(cat "$SM_CFG_PATH" | fzf --prompt="Select Mark: " --border )"
  cd "$selected_mark"
  sed -i "/^$/d" "$SM_CFG_PATH" 
  zle accept-line
}

delete_mark(){
  selected_mark="$(cat "$SM_CFG_PATH" | fzf --prompt="Select Mark: " --border )"
  sed -i "s|^"$selected_mark"$||" "$SM_CFG_PATH" && printf "\033[1;031m\n - $selected_mark has been removed \n \033[0m"
  sed -i "/^$/d" "$SM_CFG_PATH" #removing empty line if exist
  zle -I
  zle accept-line
}

zle -N goto_mark
zle -N shellmark
zle -N delete_mark

#keybinds
bindkey "^[d" delete_mark
bindkey "^[g" goto_mark 
bindkey "^[m" shellmark
