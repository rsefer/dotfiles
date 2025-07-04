module.exports = {
	https: (process.env.SSL_KEY_PATH && process.env.SSL_CRT_PATH ? {
		key: process.env.SSL_KEY_PATH,
		cert: process.env.SSL_CRT_PATH
	} : null),
	// files: '**/*', // now handled via the shell script
	reloadDelay: 500,
	reloadDebounce: 500,
	open: false,
	ui: false,
	// server: true, // now handled via the shell script
	watchEvents: ['add', 'change', 'unlink', 'addDir', 'unlinkDir'],
	watch: true,
	notify: {
		styles: {
			pointerEvents: 'none',
			userSelect: 'none',
			opacity: '0.5',
			top: 'auto',
			bottom: '0',
			borderRadius: '5px 0px 0px'
		}
	},
	snippetOptions: {
		rule: {
			match: /<\/body>/i,
			fn: function (snippet, match) {
				return snippet + match;
			}
		}
	}
};
