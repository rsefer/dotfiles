BRACKETSTART="\r\n[ "
BRACKETEND=" ] "
LINEEND="\n"
COLOREND=$'\e[0m'
COLORRED=$'\e[1;31m'
COLORGREEN=$'\e[1;32m'
COLORYELLOW=$'\e[1;33m'
COLORBLUE=$'\e[1;34m'

plus () {
  printf "${BRACKETSTART}${COLORGREEN}++${COLOREND}${BRACKETEND}$1${LINEEND}"
}

success () {
  printf "${BRACKETSTART}${COLORGREEN}OK${COLOREND}${BRACKETEND}$1${LINEEND}"
}

minus () {
  printf "${BRACKETSTART}${COLORRED}--${COLOREND}${BRACKETEND}$1${LINEEND}"
}

fail () {
  printf "${BRACKETSTART}${COLORRED}XX${COLOREND}${BRACKETEND}$1${LINEEND}"
}

info () {
  printf "${BRACKETSTART}${COLORBLUE}..${COLOREND}${BRACKETEND}$1${LINEEND}"
}

user () {
  printf "${BRACKETSTART}${COLORYELLOW}??${COLOREND}${BRACKETEND}$1${LINEEND}"
}

readyn () {
  read -p "$(printf "${BRACKETSTART}${COLORYELLOW}??${COLOREND}${BRACKETEND}") $1" -n 1 -r
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}
