BRACKETSTART="\r\n[ "
BRACKETEND=" ] "
LINEEND="\n"
COLOREND=$'\e[0m'
COLORRED=$'\e[31m'
COLORGREEN=$'\e[32m'
COLORYELLOW=$'\e[33m'
COLORBLUE=$'\e[34m'

message () {
	printf "${BRACKETSTART}$3$2${COLOREND}${BRACKETEND}$1${LINEEND}"
}

plus () {
  message "$1" "++" $COLORGREEN
}

success () {
	message "$1" "OK" $COLORGREEN
}

minus () {
  message "$1" "--" $COLORRED
}

fail () {
	message "$1" "XX" $COLORRED
}

info () {
  message "$1" ".." $COLORBLUE
}

user () {
  message "$1" "??" $COLORYELLOW
}

readyn () {
	user "$1"
  read -n 1 -r
	echo "\n"
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
