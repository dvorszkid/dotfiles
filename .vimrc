"
" Required for package manager
"
set nocompatible              " be iMproved, required
filetype off                  " required


"
" Hostname for host specific configuration
"
let s:hostname = substitute(system('hostname'), '\n', '', '')


"
" Plugin list (using VimPlug)
"
call plug#begin('~/.vim/plugged')

" For Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'

" Misc
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'Lokaltog/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'kien/tabman.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/ListToggle'
Plug 'terryma/vim-multiple-cursors'
Plug 'dkprice/vim-easygrep'
Plug 'tpope/vim-surround'
Plug 'qwertologe/nextval.vim'
Plug 'osyo-manga/vim-anzu'

" For file opening
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" Tmux
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'
if !has("gui_running")
	Plug 'edkolev/tmuxline.vim'
endif

" General programming
Plug 'tomtom/tcomment_vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/unite-outline'
if !(s:hostname =~ "raider")
	Plug 'Valloric/YouCompleteMe', {'do': 'LD_LIBRARY_PATH=/usr/lib/llvm/5/lib64 ./install.py --clang-completer --system-boost --system-libclang', 'for': ['c', 'cpp', 'python']}
endif

" Lua programming
Plug 'tbastos/vim-lua', {'for': ['lua']}

" C++ programming
Plug 'derekwyatt/vim-fswitch'
Plug 'octol/vim-cpp-enhanced-highlight'

" Work related
if !(s:hostname =~ "raider")
	Plug 'ngg/vim-gn'
	Plug 'ngg/vim-protobuf'
	Plug 'git@bitbucket.org:tresorit/vimtresorit.git'
endif

" Automatically executes 'filetype plugin indent on' and 'syntax enable'
call plug#end()


"
" Plugin configurations
"

" VimPlug
nnoremap <silent> <leader><leader>ps :PlugStatus<CR>
nnoremap <silent> <leader><leader>pu :PlugUpdate<CR>
nnoremap <silent> <leader><leader>pU :PlugUpgrade<CR>
nnoremap <silent> <leader><leader>pc :PlugClean<CR>

" Unite
let g:unite_prompt='» '
let g:unite_source_history_yank_enable = 1
let g:unite_source_grep_max_candidates = 1000
if executable('rg')
	let g:unite_source_grep_command = 'rg'
	let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
	let g:unite_source_grep_recursive_opt = ''
	let g:unite_source_rec_async_command = ['rg', '--files', '--follow', '--hidden']
elseif executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden'
	let g:unite_source_grep_recursive_opt = ''
	let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
endif
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])
nnoremap <silent> <C-p> :Unite -start-insert -no-split file_rec/async<cr>
nnoremap <silent> <leader><leader>m :Unite -start-insert -no-split neomru/file<cr>
nnoremap <silent> <C-g> :Unite -start-insert -no-split -auto-preview line<cr>
nnoremap <silent> <C-t> :Unite -start-insert -no-split -auto-preview outline<cr>
nnoremap <silent> <leader><leader>y :Unite history/yank<cr>
nnoremap <silent> <leader><leader>b :Unite -quick-match buffer<cr>


" Fugitive
augroup fugitive
	autocmd!
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup end


" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 5000
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
nmap <leader>hs <Plug>GitGutterStageHunk
nmap <leader>hr <Plug>GitGutterUndoHunk
nmap <leader>hp <Plug>GitGutterPreviewHunk


" AirLine
let g:airline_theme = 'solarized'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
" AirLine - custom functions
function! AirlineCustomInit()
	function! GetGnTarget()
		return "[" . g:gn_target . "]"
	endfunction
	call airline#parts#define_function('gn_target', 'GetGnTarget')
	call airline#parts#define_condition('gn_target', 'g:in_tresorit_source == 1')
	function! GetAsyncrunStatus()
		return g:asyncrun_status
	endfunction
	call airline#parts#define_function('asyncrun_status', 'GetAsyncrunStatus')
	call airline#parts#define_condition('asyncrun_status', 'strlen(g:asyncrun_status) > 0')
	let g:airline_section_b = g:airline_section_b . airline#section#create_left(['gn_target'])
	let g:airline_section_error = g:airline_section_error . airline#section#create_right(['asyncrun_status'])
endfunction
augroup airline_init
	autocmd User AirlineAfterInit call AirlineCustomInit()
augroup END


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
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_error_symbol = 'E>'
let g:ycm_warning_symbol = 'W>'
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_invoke_completion = '<C-Space>'
nnoremap <silent> <leader>yg :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>yf :YcmCompleter FixIt<CR>


" UndoTree
nnoremap <silent> <leader>u :UndotreeToggle<CR>


" EasyGrep
let g:EasyGrepCommand=1
nnoremap <leader>/ :Grep<space>
nnoremap <leader>r :Replace<space>


" TabMan
let g:tabman_toggle = '<leader>t'


" Solarized
let g:solarized_termcolors=16
let g:solarized_termtrans=1


" NERDTree
noremap <Leader>n :NERDTreeToggle<CR>


"
" ListToggle
"
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 15


" FSwitch
noremap <silent> <F4> :FSHere<CR>
inoremap <silent> <F4> <Esc>:FSHere<CR>


" vim-autoformat
noremap <silent> <leader>ff :Autoformat<CR>


" nextval
nmap <silent> + <Plug>nextvalInc
nmap <silent> - <Plug>nextvalDec

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" TmuxLine
let g:tmuxline_preset={
		\'a':'#S',
		\'win':['#I', '#W'],
		\'cwin':['#I', '#W'],
		\'z':'#H',
		\'options':{'status-justify':'left'}
	\}

" AsyncRun
let g:asyncrun_bell = 1
let g:asyncrun_exit = "silent call system(\"notify-send \\\"vim asyncrun\\\" \\\"Returned \" . g:asyncrun_code . \" (\" . g:asyncrun_status . \")\\\"\")"
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
augroup asyncrun
	autocmd User AsyncRunStart call asyncrun#quickfix_toggle(5, 1)
	autocmd User AsyncRunStop if (g:asyncrun_code == 0) | call asyncrun#quickfix_toggle(5, 0) | AirlineRefresh | endif
augroup END
nnoremap <silent> <F9> :call asyncrun#quickfix_toggle(15)<CR>

"
" VimTresorit
"

" Building the source
let g:buildcmd = ":Make "
let g:buildbackgroundcmd = ":Make -k 0 "
nnoremap [tbuild] <Nop>
nmap <leader>b [tbuild]
nnoremap <silent> [tbuild]s :AsyncStop<CR>
nnoremap [tbuild]c :CreateOutDir<space>
nnoremap [tbuild]e :EditCurrentOutDir<CR>
nnoremap <silent> [tbuild]o :Unite -start-insert -no-split gn_out<CR>
nnoremap <silent> [tbuild]t :Unite -start-insert -no-split gn_target<CR>
nnoremap <silent> [tbuild]f :wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>
nnoremap <silent> [tbuild]p :wa<CR>:exec g:buildcmd . g:GetBuildProjectParams(@%)<CR>
nnoremap <silent> [tbuild]a :wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>
nnoremap <silent> [tbuild]bf :wa<CR>:exec g:buildbackgroundcmd . g:GetBuildFileParams(@%)<CR>
nnoremap <silent> [tbuild]bp :wa<CR>:exec g:buildbackgroundcmd . g:GetBuildProjectParams(@%)<CR>
nnoremap <silent> [tbuild]ba :wa<CR>:exec g:buildbackgroundcmd . g:GetBuildAllParams(@%)<CR>
nmap <silent> <F7> [tbuild]a
nmap <silent> <F8> [tbuild]f

" Code formatting
noremap <silent> <leader>ft :ToggleAutoFormatCode<CR>


"
" Put your non-plugin stuff after this line
"

""
" Unicode support
""
scriptencoding utf-8
set encoding=utf-8


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
set updatetime=1000		" check for changes in every second
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
set ttimeoutlen=0       " timeout of keycode sequences - faster Esc in insert mode


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
" GUI settings
""
if has('gui_running')
	set guioptions-=T  " no toolbar
	set guifont=Source\ Code\ Pro\ for\ Powerline\ 10
endif


""
" Per project vimrc
""
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" Paste mode
set pastetoggle=<F3>
noremap <silent> <leader>p :set paste<CR>p:set nopaste<CR>
noremap <silent> <leader>P :set paste<CR>P:set nopaste<CR>


" Share X windows clipboard
if has('unnamedplus')
	set clipboard=unnamedplus
endif


" Buffer switching
nnoremap <silent> <F1> :bp<CR>
nnoremap <silent> <F2> :bn<CR>
inoremap <silent> <F1> <Esc>:bp<CR>
inoremap <silent> <F2> <Esc>:bn<CR>


" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk


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
" nnoremap / /\v
" vnoremap / /\v


" <leader>v brings up .vimrc
" <leader>V reloads it and makes all changes active (file has to be saved first)
noremap <leader>v :tabedit $MYVIMRC<CR>
noremap <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>


" Save as root
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! Wq :execute ':W' | :q
command! WQ :execute ':Wq'


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


" C++ shortcuts
nmap <leader>sm ysiw)istd::move<Esc>
nnoremap <silent> <leader>fe :botright copen 15<CR>/error:<CR>
nnoremap <silent> <leader>fw :botright copen 15<CR>/warning:<CR>


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

	" Auto-detect file changes
	autocmd CursorHold,CursorHoldI,WinEnter,BufWinEnter * silent! checktime

	" Handle '//' comments better
	autocmd FileType c,cpp,objc,objcpp setlocal comments-=:// comments+=f://
augroup end


" Search and Replace
if executable("rg")
	set grepprg=rg\ --vimgrep\ --no-heading\ --hidden
	set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif

