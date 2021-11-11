" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'

call vundle#end()

" Config
filetype plugin indent on

syntax on

set path+=**

set confirm

" Find options (via :edit)
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

autocmd FileType markdown setlocal spell

set splitbelow splitright

set noruler
set number
set showcmd
set noshowmode
set cursorline
set mouse=a

set tabstop=2
set softtabstop=0 noexpandtab
set shiftwidth=2

set wildmenu
set lazyredraw
set showmatch

set incsearch
set hlsearch

set foldenable
set foldlevelstart=10
set foldmethod=indent

set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

:iabbrev <// </<C-X><C-O>
:imap <C-Space> <C-X><C-O>

" autocmd BufReadPost,FileReadPost,BufNewFile * call system("printf '\033]2;%s\033\\' '" . expand("%") ."'")
" autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

let g:currentmode={
    \ 'n'      : '',
    \ 'no'     : 'N·Operator Pending',
    \ 'v'      : 'VISUAL',
    \ 'V'      : 'V·Line',
    \ '\<C-V>' : 'V·Block',
    \ 's'      : 'Select',
    \ 'S'      : 'S·Line',
    \ '\<C-S>' : 'S·Block',
    \ 'i'      : 'INSERT',
    \ 'R'      : 'R',
    \ 'Rv'     : 'V·Replace',
    \ 'c'      : 'Command',
    \ 'cv'     : 'Vim Ex',
    \ 'ce'     : 'Ex',
    \ 'r'      : 'Prompt',
    \ 'rm'     : 'More',
    \ 'r?'     : 'Confirm',
    \ '!'      : 'Shell',
    \ 't'      : 'Terminal'
    \}

set laststatus=2

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
" git
set statusline+=%{StatuslineGit()}
" modified flag
set statusline+=%2*%m%*
" path (f for relative, F for full)
set statusline+=%1*\ %<%f%*
" left/right divider
set statusline+=%1*\ %=
" current line #
set statusline+=%1*%5l%*
" total lines
set statusline+=%1*/%L%*
" (virtual) column #
set statusline+=%1*%4v\ %*
" mode
set statusline+=%1*\ [%{toupper(g:currentmode[mode()])}]

" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

hi CursorLineNR cterm=bold ctermfg=White ctermbg=DarkGrey
augroup CLNRSet
	autocmd! ColorScheme * hi CursorLineNR cterm=bold
augroup END

hi User1 ctermfg=white ctermbg=8
hi User2 ctermfg=white ctermbg=green
