function git_prepare() {
	if [ -n "$BUFFER" ];
	then
		BUFFER="git add -A && git commit -m \"$BUFFER\" && git push"
	fi
	if [ -z "$BUFFER" ];
	then
		BUFFER="git add -A && git commit -v && git push"
	fi
	zle accept-line
}
zle -N git_prepare
bindkey "^g" git_prepare
