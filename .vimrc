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
Plugin 'kien/tabman.vim'

" For file opening
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'

" Tmux
Plugin 'tmux-plugins/vim-tmux'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'edkolev/tmuxline.vim'

" General programming
Plugin 'tomtom/tcomment_vim'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-dispatch'
Plugin 'Chiel92/vim-autoformat'

" C++ programming
Plugin 'Valloric/YouCompleteMe'
Plugin 'Kris2k/A.vim'
Plugin 'vim-scripts/Conque-GDB'
Plugin 'https://bitbucket.org/tresorit/vimtresorit.git'

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
nnoremap <leader>p :Unite file_mru -start-insert<cr>
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden --ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
	let g:unite_source_grep_recursive_opt = ''
	"let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
endif
nnoremap <silent> <leader>/ :Unite grep:.<cr>
let g:unite_source_history_yank_enable = 1
nnoremap <silent> <leader>y :Unite history/yank<cr>
nnoremap <silent> <leader>b :Unite -quick-match buffer<cr>


" AirLine
let g:airline_theme = 'murmur'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1


" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Bi-directional find motion
" `s{char}{char}{label}` (need one more keystroke, but on average, it may be more comfortable)
nmap s <Plug>(easymotion-s2)
" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


" YouCompleteMe
let g:ycm_extra_conf_globlist = ['~/projects/*','!~/*']
nnoremap <silent> <leader>g :YcmCompleter GoTo<CR>


" UndoTree
nnoremap <silent> <leader>u :UndotreeToggle<CR>


" TabMan
let g:tabman_toggle = '<F3>'


" Solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1


" A.vim
nnoremap <silent> <F4> :A<CR>


" vim-autoformat
noremap <silent> <leader>f :Autoformat<CR>


" UltiSnip
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" ConqueGDB
let g:ConqueGdb_Leader = '<Leader><Leader>'


" VimTresorit
nnoremap <silent> <leader>mh :ToggleMakeHost<CR>
nnoremap <silent> <leader>mc :ToggleMakeCompiler<CR>
nnoremap <silent> <leader>md :ToggleMakeDebug<CR>
nnoremap <silent> <leader>mt :ToggleMakeTests<CR>


"
" Put your non-Plugin stuff after this line
"

""
" Indent and tab settings
""
set autoindent smartindent
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set smarttab


""
" Searching
""
set ignorecase	" ignore case when searching
set smartcase	" ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch	" highlight search terms
set incsearch	" show search matches as you type


""
" Misc
""
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
set number				" line numbers
" set relativenumber	" relative line numbers
set cursorline			" highlight cursor line
set wildmenu			" for better completion
set ch=1				" command line height
set mouse=a				" enable mouse scrolling
set scrolloff=8			" show more lines before and after cursor
set wildignore=*.swp,*.bak,*.pyc,*.class
set title				" change the terminal's title
set visualbell			" don't beep
set noerrorbells		" don't beep
set showmatch			" show matching parens
set laststatus=2		" always show status line
set noshowmode			" hide default mode text
set hidden				" dave modified buffers in the background
set autoread			" auto-reload modified files (with no local changes)
set lazyredraw			" no redraws in macros
set confirm				" dialog when :q, :w, :x, :wq fails
set nostartofline		" don't move cursor when switching buffers/files
set nobackup			" that's what git is for
set ttyfast				" smoother changes


""
" Undo and history
""
set history=1000		" remember more commands and search history
set undolevels=1000		" use many muchos levels of undo
set undodir=~/.vim/undohistory
set undofile


""
" Color scheme
""
syntax on
set t_Co=256
set background=dark
colorscheme solarized


""
" Per project vimrc
""
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" Trim whitespaces
autocmd FileType c,cpp,python,ruby,java autocmd BufWritePre <buffer> :%s/\s\+$//e


" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk


" Insert whitespaces without entering insert mode
nmap <silent> <leader>o o<Esc>
nmap <silent> <leader>O O<Esc>
nmap <silent> <leader><Space> i<Space><Esc>


" Clear highlight
nmap <silent> <Space> <Space>:noh<CR>


" Buffer switching
nmap <silent> <leader><F5> :bp <BAR> bd #<CR>
nmap <silent> <F5> :bp<CR>
nmap <silent> <F6> :bn<CR>
imap <silent> <F5> <Esc>:bp<CR>
imap <silent> <F6> <Esc>:bn<CR>


" Scroll slightly faster
noremap <c-e> <c-e><c-e><c-e>
noremap <c-y> <c-y><c-y><c-y>


" Indent with tab, unindent with shift-tab
nnoremap <tab> >>
vnoremap <tab> >
nnoremap <s-tab> <<
vnoremap <s-tab> <


" Shorter commands
nnoremap ; :


" Build solution
map <silent> <F7> :wa<CR>:Make -j8<CR>


" Save as root
cmap w!! w !sudo tee % >/dev/null


" Paste mode
set pastetoggle=<F2>


" Share X windows clipboard
if has('unnamedplus')
	set clipboard=unnamedplus
endif


" If you are still getting used to Vim and want to force yourself to stop using the arrow keys, add this
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


" Re-adjust windows on window resize
autocmd VimResized * wincmd =

