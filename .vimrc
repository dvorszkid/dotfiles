"
" Vundle package manager
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
"
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
"
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'bling/vim-airline'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tomtom/tcomment_vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bbchung/clighter'
"
" plugin from http://vim-scripts.org/vim/scripts.html
" 	Plugin 'L9'
" 
" Git plugin not hosted on GitHub
" 	Plugin 'git://git.wincent.com/command-t.git'
"
" git repos on your local machine (i.e. when working on your own plugin)
" 	Plugin 'file:///home/gmarik/path/to/plugin'
" 
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" 	Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 
" Avoid a name conflict with L9
" 	Plugin 'user/L9', {'name': 'newL9'}
"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

"
" Plugin configurations
"

" Unite
let g:unite_prompt='» '
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <C-p> :Unite file_rec/async -start-insert<cr>
nnoremap <C-P> :Unite file_mru -start-insert<cr>
if executable('ag')
	let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
endif
nnoremap <space>/ :Unite grep:.<cr>
let g:unite_source_history_yank_enable = 1
nnoremap <space>y :Unite history/yank<cr>
nnoremap <space>s :Unite -quick-match buffer<cr>

" Semantic highlight
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9]
nnoremap <Leader>S :SemanticHighlightToggle<cr>

" AirLine
let g:airline_theme = 'murmur'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" YouCompleteMe
let g:ycm_extra_conf_globlist = ['~/Projects/*','!~/*']
nnoremap <leader>g :YcmCompleter GoTo<CR>

" Clighter
let g:clighter_libclang_file = '/usr/lib64/libclang.so'
let g:clighter_autostart = 1
let g:ClighterCompileArgs = '["-x", "c++", "-std=c++11", "-I."]'

"
" Put your non-Plugin stuff after this line
"

" indent and tab settings
set autoindent smartindent
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set smarttab

" searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" line numbers
set number
"set relativenumber
set cursorline

" show matching parens
set showmatch

" dark color scheme
syntax on
set background=dark
colorscheme molokai
"let g:molokai_original = 1
let g:rehash256 = 1

" Per project vimrc
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" Status line
set laststatus=2

" Have modified buffers in the background
set hidden

" Trim whitespaces
autocmd FileType c,cpp,python,ruby,java autocmd BufWritePre <buffer> :%s/\s\+$//e

" Buffer switching
noremap <C-h> :bprevious<CR>
noremap <C-l> :bnext<CR>
inoremap <C-h> <Esc>:bprevious<CR>
inoremap <C-l> <Esc>:bnext<CR>

" Remap space to clear highlight
nmap <SPACE> <SPACE>:noh<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <C-w>w :bp <BAR> bd #<CR>

