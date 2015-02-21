"
" Vundle package manager
"
set nocompatible              " be iMproved, required
filetype off                  " required


"
" Hostname for host specific configuration
"
let s:hostname = substitute(system('hostname'), '\n', '', '')


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
" 	Plugin 'asdf/asdf'
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
Plugin 'tpope/vim-git'
Plugin 'gregsexton/gitv'

" Misc
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mbbill/undotree'
Plugin 'kien/tabman.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'tommcdo/vim-exchange'
Plugin 'godlygeek/tabular'
Plugin 'Valloric/ListToggle'
Plugin 'terryma/vim-multiple-cursors'

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
Plugin 'Valloric/YouCompleteMe'

" C++ programming
Plugin 'Kris2k/A.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'

" Work related
if (s:hostname =~ "bp1-dsklin")
	Plugin 'https://bitbucket.org/tresorit/vim-lldb.git'
	Plugin 'https://bitbucket.org/tresorit/vimtresorit.git'
endif

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
let g:unite_source_history_yank_enable = 1
let g:unite_source_grep_max_candidates = 1000
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden'
	let g:unite_source_grep_recursive_opt = ''
	let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
endif
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <C-p> :Unite -start-insert -no-split -auto-preview file_rec/async<cr>
nnoremap <leader>p :Unite -start-insert -no-split -auto-preview file_mru<cr>
nnoremap <silent> <leader>/ :Unite -toggle -auto-resize -silent -buffer-name=ag grep:.<cr>
nnoremap <silent> <leader><leader>/ :Unite -resume -buffer-name=ag grep:.<cr>
nnoremap <silent> <leader>y :Unite history/yank<cr>
nnoremap <silent> <leader>b :Unite -quick-match buffer<cr>


" Fugitive
augroup fugitive
	autocmd!
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup end


" AirLine
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1


" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-s2)
omap t <Plug>(easymotion-t)
omap / <Plug>(easymotion-tn)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" Disabled searching
" map / <Plug>(easymotion-sn)
" map n <Plug>(easymotion-next)
" map N <Plug>(easymotion-prev)


" YouCompleteMe
let g:ycm_extra_conf_globlist = ['~/projects/*','!~/*']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_error_symbol = 'E>'
let g:ycm_warning_symbol = 'W>'
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_invoke_completion = '<C-Space>'
nnoremap <silent> <leader>g :YcmCompleter GoTo<CR>


" UndoTree
nnoremap <silent> <leader>u :UndotreeToggle<CR>


" TabMan
let g:tabman_toggle = '<leader>t'


" Solarized
let g:solarized_termcolors=16
let g:solarized_termtrans=1


" looks at the current line and the lines above and below it and aligns all the
" equals signs; useful for when we have several lines of declarations
nnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a= :Tabularize /=<CR>
nnoremap <Leader>a/ :Tabularize /\/\//l2c1l0<CR>
vnoremap <Leader>a/ :Tabularize /\/\//l2c1l0<CR>
nnoremap <Leader>a, :Tabularize /,/l0r1<CR>
vnoremap <Leader>a, :Tabularize /,/l0r1<CR>


"
" ListToggle
"
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 15


" A.vim
nnoremap <silent> <F4> :A<CR>


" vim-autoformat
noremap <silent> <leader>f :Autoformat<CR>


" TmuxLine
let g:tmuxline_preset={
		\'a':'#S',
		\'win':['#I', '#W'],
		\'cwin':['#I', '#W'],
		\'z':'#H',
		\'options':{'status-justify':'left'}
	\}


" UltiSnip
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"TODO: let g:UltiSnipsSnippetsDir = $HOME . '/dotfiles/vim/UltiSnips'
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


"
" LLDB
"
" Common commands
nnoremap <silent> <F8> :Lcontinue<CR>
nnoremap <silent> <F9> :Lbreakpoint<CR>
nnoremap <silent> <F10> :Lnext<CR>
nnoremap <silent> <F11> :Lstep<CR>
nnoremap <silent> <leader><F11> :Lfinish<CR>
" Start debugging
function! g:StartDebug(program, args)
	exec "Ltarget " . a:program
	exec "Lbreakpoint set --name main"
	exec "Lhide disassembly"
	exec "Lhide registers"
	exec "Lstart " . a:args
endfunction
nnoremap <F5> :call StartDebug(g:GetTresoritCLIPath(), "")<Left><Left>
nnoremap <leader><F5> :call StartDebug(g:GetTresoritTestPath(), "-t " . expand("<cword>" . ""))<Left><Left><Left>


"
" VimTresorit
"
" Makefile variables
nnoremap <silent> <leader>mh :ToggleMakeHost<CR>
nnoremap <silent> <leader>mc :ToggleMakeCompiler<CR>
nnoremap <silent> <leader>md :ToggleMakeDebug<CR>
nnoremap <silent> <leader>mt :ToggleMakeTests<CR>
nnoremap <silent> <leader>mi :PrintMakeInformation<CR>
" Building the source
let g:buildcmd = ":Make -j5 "
let g:buildbackgroundcmd = ":Make! -j5 "
nnoremap <silent> <leader>bf :exec g:buildcmd . g:GetBuildFileParams(@%)<CR>
nnoremap <silent> <leader>bp :exec g:buildcmd . g:GetBuildProjectParams(@%)<CR>
nnoremap <silent> <leader>ba :exec g:buildcmd . g:GetBuildAllParams(@%)<CR>
nnoremap <silent> <leader>bbf :exec g:buildbackgroundcmd . g:GetBuildFileParams(@%)<CR>
nnoremap <silent> <leader>bbp :exec g:buildbackgroundcmd . g:GetBuildProjectParams(@%)<CR>
nnoremap <silent> <leader>bba :exec g:buildbackgroundcmd . g:GetBuildAllParams(@%)<CR>

"
" Put your non-Plugin stuff after this line
"

""
" Indent and tab settings
""
set autoindent smartindent
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set smarttab
let g:leave_my_textwidth_alone = 1 " to ignore gentoo specific global vimrc


""
" Searching
""
set ignorecase	" ignore case when searching
set smartcase	" ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch	" highlight search terms
set incsearch	" show search matches as you type
set gdefault	" use /g by default search and replace


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
set t_ts=]0;			" title string begin for rxvt-unicode + tmux
set t_fs=				" title string end for rxvt-unicode + tmux
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
set noswapfile			" no .swp files
set ttyfast				" smoother changes
set diffopt+=vertical	" vertical diff
set listchars=tab:▸\ ,eol:¬	" This changes the default display of tab and CR chars in list mode
set foldlevelstart=99	" all folds open by default
set spelllang=en		" mostly the only needed
set nospell				" and its on


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
set background=dark
let g:load_doxygen_syntax=1
let g:solarized_termcolors=16
let g:solarized_termtrans=0
call togglebg#map("<Leader>bg")
colorscheme solarized


""
" Per project vimrc
""
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" Paste mode
set pastetoggle=<F3>


" Share X windows clipboard
if has('unnamedplus')
	set clipboard=unnamedplus
endif


" Buffer switching
nnoremap <F1> :bp<CR>
nnoremap <F2> :bn<CR>
inoremap <F1> <Esc>:bp<CR>
inoremap <F2> <Esc>:bn<CR>


" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk


" Insert whitespaces without entering insert mode
nnoremap <silent> <leader><Space> i<Space><Esc>


" Clear highlight
nnoremap <silent> <Space> <Space>:noh<CR>


" Closing buffers
nnoremap <silent> <leader>c :bp <BAR> bd #<CR>
nnoremap <silent> <leader>C :1,1000bd<CR>


" Scroll slightly faster
noremap <c-e> <c-e><c-e><c-e>
noremap <c-y> <c-y><c-y><c-y>


" Keep visual selection after indenting
vnoremap > >gv
vnoremap < <gv


" Visually select the text that was last edited/pasted
nmap gV `[v`]


" With this map, we can select some text in visual mode and by invoking the map,
" have the selection automatically filled in as the search text and the cursor
" placed in the position for typing the replacement text. Also, this will ask
" for confirmation before it replaces any instance of the search text in the
" file.
vnoremap <C-r> "hy:%s/<C-r>h//c<left><left>


" Better regex syntax
nnoremap / /\v
vnoremap / /\v


" Faster Escape
inoremap jj <ESC>


" <leader>v brings up .vimrc
" <leader>V reloads it and makes all changes active (file has to be saved first)
noremap <leader>v :tabedit $MYVIMRC<CR>
noremap <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>


" Save as root
cmap w!! w !sudo tee % >/dev/null


" Now we don't have to move our fingers so far when we want to scroll through
" the command history; also, don't forget the q: command (see :h q: for more
" info)
cnoremap <c-j> <down>
cnoremap <c-k> <up>


" In normal mode, we use : much more often than ; so lets swap them.
" WARNING: this will cause any "ordinary" map command without the "nore" prefix
" that uses ":" to fail. For instance, "map <f2> :w" would fail, since vim will
" read ":w" as ";w" because of the below remappings. Use "noremap"s in such
" situations and you'll be fine.
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;


" If you are still getting used to Vim and want to force yourself to stop using the arrow keys, add this
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>


" My custom autocmds
augroup my_commands
	" Clear commands first for multiple vimrc reloads
	autocmd!

	" Trim whitespaces
	autocmd FileType c,cpp,python,ruby,java,proto,lua,php autocmd BufWritePre <buffer> :%s/\s\+$//e

	" Fix tab settings for python
	autocmd FileType python setlocal tabstop=4 softtabstop=0 noexpandtab shiftwidth=4

	" Re-adjust windows on window resize
	autocmd VimResized * wincmd =
augroup end


" Search and Replace
if executable('ag')
	function! s:ReplaceInFiles(search, replace)
		exec "!ag -l " . a:search . " | xargs sed -i 's@" . a:search . "@" . a:replace . "@g'"
	endfunction
	command! -nargs=+ ReplaceInFiles call s:ReplaceInFiles(<f-args>)
endif

