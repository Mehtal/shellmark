#!/usr/bin/env zsh 


#Config file path
SM_CFG_DIR="$(dirname "$(realpath "$0")")"
SM_CFG_PATH="$SM_CFG_DIR/config.txt"
mark=""

zle -N goto_mark
zle -N shellmark
zle -N delete_mark
bindkey "^[d" delete_mark
bindkey "^[g" goto_mark 
bindkey "^[m" shellmark
#Making sure the cfg file and dir exist
check_cfg_dir(){
  if [ ! -d "$SM_CFG_DIR" ]; then
    mkdir -p $SM_CFG_DIR
  fi 
  if  [ ! -e "$SM_CFG_PATH" ]; then
    touch "$SM_CFG_PATH"
  fi
  }

#checking if the given value is realdir or not
is_dir() {
  local dir="$1"
  if [ -d "$dir" ]; then
    echo "$dir will be add to the config"
  else
    echo "$dir is not real directory"
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
    echo "the marked dir is : $mark"
  }


#converting the path to absolute ex: Document/  --> /home/username/Document
make_path_absolute(){
  mark="$(realpath "$mark")"
}

#checking if the mark already add to config.txt  if not add it to config
check_if_mark_exist(){
  grep -Fx "$mark" "$SM_CFG_PATH" && echo "the dir : $mark is already marked" || echo "$mark" >> $SM_CFG_PATH
}

#md stand for mark directory,it's the function we call from the sehll 
md() {
  check_cfg_dir
  reading_input
  make_path_absolute
  check_if_mark_exist
  mark=""
}
shellmark(){
  check_cfg_dir
  mark="$(pwd)"
  check_if_mark_exist
  echo "you have add $mark to the mark list"
  mark=""
  zle accept-line
}


goto_mark(){
  selected_mark="$(cat "$SM_CFG_PATH" | fzf --prompt="Select Mark: " --preview 'ls -la {}' --border )"
  cd "$selected_mark"
  zle accept-line
}

delete_mark(){
  selected_mark="$(cat "$SM_CFG_PATH" | fzf --prompt="Select Mark: " --border )"
  sed -i "s|^"$selected_mark"$||" "$SM_CFG_PATH"
  sed -i "/^$/d" "$SM_CFG_PATH"
  zle accept-line
}

