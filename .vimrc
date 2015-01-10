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
"	Plugin 'asdf/asdf'
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

" For Git
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'

" Misc
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mbbill/undotree'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'

" For file opening
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'

" Tmux
Plugin 'tmux-plugins/vim-tmux'
Plugin 'christoomey/vim-tmux-navigator'

" General programming
Plugin 'tomtom/tcomment_vim'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-dispatch'

" C++ programming
Plugin 'Valloric/YouCompleteMe'
" Plugin 'bbchung/clighter'
Plugin 'Kris2k/A.vim'

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
nnoremap <space>b :Unite -quick-match buffer<cr>

" AirLine
let g:airline_theme = 'solarized'
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

" UndoTree
nnoremap \u :UndotreeToggle<CR>

" Solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1

" A.vim
nnoremap <F4> :A<CR>

" UltiSnip
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"
" Put your non-Plugin stuff after this line
"

" indent and tab settings
set autoindent smartindent
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set smarttab

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" searching
set ignorecase	" ignore case when searching
set smartcase	" ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch	" highlight search terms
set incsearch	" show search matches as you type

" line numbers
set number
" set relativenumber
set cursorline

set wildmenu	" for better completion
set ch=1		" command line height
set mouse=a		" enable mouse scrolling
set t_Co=256	" colorful
set so=7
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

" show matching parens
set showmatch

" save undo history
set undodir=~/.vim/undohistory
set undofile

" dark color scheme
syntax on
set background=dark
colorscheme solarized

" Per project vimrc
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" Status line
set laststatus=2
set noshowmode		" hide default mode text

" Have modified buffers in the background
set hidden

" Trim whitespaces
autocmd FileType c,cpp,python,ruby,java autocmd BufWritePre <buffer> :%s/\s\+$//e

" Buffer switching
" noremap <C-[> :bprevious<CR>
" noremap <C-]> :bnext<CR>
" inoremap <C-[> <Esc>:bprevious<CR>
" inoremap <C-]> <Esc>:bnext<CR>

" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk

" Insert newlines without entering normal mode
nmap <CR> o<Esc>

" Clear highlight
nmap <silent> <Space> <Space>:noh<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <C-w>w :bp <BAR> bd #<CR>

" Shorter commands
nnoremap ; :

" Build solution
map <F7> :wa<CR>:Make -j8<CR>

" Save as root
cmap w!! w !sudo tee % >/dev/null

" Paste mode
set pastetoggle=<F2>

" If you are still getting used to Vim and want to force yourself to stop using the arrow keys, add this
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>
