function up_widget() {
	BUFFER="cd .."
	zle accept-line
}
zle -N up_widget
bindkey "^k" up_widget

function git_prepare() {
	if [ -n "$BUFFER" ];
	then
		BUFFER="git add -A && git commit -S -m \"$BUFFER\" && git push"
	fi
	if [ -z "$BUFFER" ];
	then
		BUFFER="git add -A && git commit -S -v && git push"
	fi
	zle accept-line
}
zle -N git_prepare
bindkey "^g" git_prepare
