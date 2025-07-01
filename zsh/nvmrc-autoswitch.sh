autoload -U add-zsh-hook
load-nvmrc() {
	local node_version nvmrc_path nvmrc_node_version
	node_version="$(nvm version)"
	nvmrc_path="$(nvm_find_nvmrc)"
	if [ -n "$nvmrc_path" ]; then
		nvmrc_node_version="$(cat "${nvmrc_path}")"
		if [ -n "$nvmrc_node_version" ]; then
			nvmrc_node_version=$(nvm version "$nvmrc_node_version")
			if [ "$nvmrc_node_version" = "N/A" ]; then
				nvm install
			elif [ "$nvmrc_node_version" != "$node_version" ]; then
				nvm use
			fi
		fi
	elif [ "$node_version" != "$(nvm version default)" ]; then
		echo "Reverting to nvm default version"
		nvm use default
	fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
