# from parth's prompt: https://github.com/Parth/dotfiles/blob/f5dfdf080ea0e167dfc767dcd1833638cff8c7bd/zsh/prompt.sh

autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {

	PS1="%{$fg[white]%}[%{$reset_color%}"

	# add user@machine on non macs (commented out because this is covered by RPROMPT now)
	#if [[ "$OSTYPE" == darwin* ]]; then
		# do nothing for macOS
	#else
		#PS1+="%{$fg_bold[white]%}%n@%M%{$fg_bold[red]%}:"
	#fi

	PS1+="%{$fg_bold[cyan]%}%{%$(( $COLUMNS - 80 ))<...<%~%<<%}%{$reset_color%}"
	PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	# Git
	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		PS1+=', '
		PS1+="%{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
		if [ $(git status --short | wc -l) -gt 0 ]; then
			PS1+="%{$fg[red]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
		fi
	fi

	# Timer
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	fi

	# Sudo: https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
	if [[ "$OSTYPE" == darwin* ]]; then
		# do nothing for macOS
	else
		CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
		if [ ${CAN_I_RUN_SUDO} -gt 0 ]
		then
			PS1+=', '
			PS1+="%{$fg_bold[red]%}SUDO%{$reset_color%}"
		fi
	fi

	PS1+="%{$fg[white]%}]"
	PS1+=$'\n'
	PS1+="❯ %{$reset_color%}% "

}

precmd_functions+=set_prompt

RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"

preexec () {
	(( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
	_start=$SECONDS
}

precmd () {
	(( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
	_start=-1
}
