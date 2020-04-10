"
" Required for package manager
"
set nocompatible              " be iMproved, required
filetype off                  " required


"
" Hostname for host specific configuration
"
let s:hostname = substitute(system('hostname'), '\n', '', '')
let s:is_devel = s:hostname =~ "basestar" || s:hostname =~ "bp1-dsklin"


"
" Plugin list (using VimPlug)
"
call plug#begin('~/.vim/plugged')

" For Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv', {'on': 'Gitv'}
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
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'

" Org Mode
Plug 'tpope/vim-speeddating'
Plug 'jceb/vim-orgmode'

" For file opening
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'vifm/vifm.vim'
Plug 'justinmk/vim-dirvish'

" Tmux
if !has("gui_running")
	Plug 'tmux-plugins/vim-tmux'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'edkolev/tmuxline.vim'
endif

" General programming
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-dispatch'
Plug 'Chiel92/vim-autoformat'
if s:is_devel
	Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-boost --system-libclang', 'for': ['c', 'cpp', 'python']}
endif

" Lua programming
Plug 'tbastos/vim-lua', {'for': ['lua']}

" C++ programming
Plug 'derekwyatt/vim-fswitch', {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}

" Work related
if s:is_devel
	Plug 'ngg/vim-gn'
	Plug 'uarun/vim-protobuf'
	Plug 'git@bitbucket.org:tresorit/vimtresorit.git'
endif

" Automatically executes 'filetype plugin indent on' and 'syntax enable'
call plug#end()


"
" Plugin configurations
"

" Yoink
let g:yoinkMaxItems = 100
let g:yoinkIncludeDeleteOperations = 1
nnoremap <silent> <leader>;y :Yanks<cr>
nmap <C-n> <plug>(YoinkPostPasteSwapBack)
"nmap <C-p> <plug>(YoinkPostPasteSwapForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)


" Subversive
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)


" FZF
let g:fzf_command_prefix = 'Fzf'
nnoremap <silent> <leader>;f :FzfFiles<cr>
nnoremap <silent> <leader>;F :FzfHistory<cr>
nnoremap <silent> <leader>;g :FzfGFiles<cr>
nnoremap <silent> <leader>;G :FzfGFiles?<cr>
nnoremap <silent> <leader>;b :FzfBuffers<cr>
nnoremap <silent> <leader>;t :FzfBTags<cr>
nnoremap <silent> <leader>;T :FzfTags<cr>
nnoremap <silent> <leader>;<leader> :FzfAg<cr>
"nmap <silent> <C-p> <leader>;f
nmap <silent> <C-t> <leader>;t


" Yoink + FZF + vim-multiple-cursors
map <expr> <C-p> yoink#isSwapping() ? '<plug>(YoinkPostPasteSwapForward)' : '<leader>;f'
map <expr> <C-n> yoink#isSwapping() ? '<plug>(YoinkPostPasteSwapForward)' : ':MultipleCursorsFind <C-R>/<CR>'


" Fugitive
augroup fugitive
	autocmd!
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup end


" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 5000
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)


" AirLine
let g:airline_theme = 'solarized'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#ycm#enabled = 1
" AirLine - custom functions
if s:is_devel
	function! AirlineCustomInit()
		function! GetGnTarget()
			return "[" . g:gn_target . "]"
		endfunction
		call airline#parts#define_function('gn_target', 'GetGnTarget')
		call airline#parts#define_condition('gn_target', 'g:in_tresorit_source == 1')
		let g:airline_section_b = g:airline_section_b . airline#section#create_left(['gn_target'])
	endfunction
	augroup airline_init
		autocmd User AirlineAfterInit call AirlineCustomInit()
	augroup END
endif


" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap S <Plug>(easymotion-s2)
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


" ViFM
noremap <Leader>fm :Vifm<CR>


"
" ListToggle
"
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<F9>'
let g:lt_height = 15


" FSwitch
noremap <silent> <F4> :FSHere<CR>
inoremap <silent> <F4> <Esc>:FSHere<CR>


" tcomment_vim
let g:tcomment#options = {'whitespace': 'no'}
let g:tcomment#filetype#guess_gn = 'python'


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

"
" VimTresorit
"

" Building the source
let g:buildcmd = ":Make "
let g:buildbackgroundcmd = ":Make! -k 0 "
let g:buildcmd_proxy = "run-and-notify"
nnoremap [tbuild] <Nop>
nmap <leader>b [tbuild]
nnoremap <silent> [tbuild]s :AbortDispatch<CR>
nnoremap [tbuild]c :CreateOutDir<space>
nnoremap [tbuild]e :Gn args<CR>
nnoremap <silent> [tbuild]o :GnOut<CR>
nnoremap <silent> [tbuild]t :GnTarget<CR>
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
set tabstop=4 softtabstop=0 expandtab shiftwidth=4
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
set display+=lastline   " try to show as much as possible of the last line in the window (rather than a column of "@")


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
let g:solarized_termtrans=1
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
	set clipboard=unnamed,unnamedplus
endif


" TermDebug
if (exists("g:start_termdebug"))
	packadd termdebug
	let g:termdebug_wide = 1

	noremap <silent> <leader>p :Evaluate<CR>:messages<CR>

	nnoremap <silent> <leader><F5> :Run<CR>
	tnoremap <silent> <leader><F5> <C-w>:Run<CR>
	nnoremap <silent> <F5> :Continue<CR>
	tnoremap <silent> <F5> <C-w>:Continue<CR>

	nnoremap <silent> <F6> :Gdb<CR>
	tnoremap <silent> <F6> <C-w>:Gdb<CR>
	nnoremap <silent> <F7> :Program<CR>
	tnoremap <silent> <F7> <C-w>:Program<CR>
	nnoremap <silent> <F8> :Source<CR>
	tnoremap <silent> <F8> <C-w>:Source<CR>

	nnoremap <silent> <F9> :Break<CR>
	nnoremap <silent> <leader><F9> :Clear<CR>

	nnoremap <silent> <F10> :Over<CR>
	tnoremap <silent> <F10> <C-w>:Over<CR>
	nnoremap <silent> <F11> :Step<CR>
	tnoremap <silent> <F11> <C-w>:Step<CR>
	nnoremap <silent> <leader><F11> :Finish<CR>
	tnoremap <silent> <leader><F11> <C-w>:Finish<CR>

	nnoremap <silent> <leader><F8> :qa!<CR>
	tnoremap <silent> <leader><F8> <C-w>:qa!<CR>
else
	function! s:StartTermdebug(cmd)
		silent execute "!tmux new-window -n termdebug
			\ vim " . @% . " +" . line(".") . "
				\ --cmd 'let g:start_termdebug = 1'
				\ -c ':cd " . g:gn_out_dir . "'
				\ -c ':silent TermdebugCommand " . substitute(a:cmd, '*', '\\*', '') . "'
				\ -c ':cd -'"
		silent redraw!
	endfunction
	command! -nargs=1 Debug call s:StartTermdebug('<args>')
	noremap <F5> :Debug 
endif


" Maximize toggle
function! MaximizeToggle()
	if exists("s:maximize_session")
		exec "source " . s:maximize_session
		call delete(s:maximize_session)
		unlet s:maximize_session
		let &hidden=s:maximize_hidden_save
		unlet s:maximize_hidden_save
	else
		let s:maximize_hidden_save = &hidden
		let s:maximize_session = tempname()
		set hidden
		exec "mksession! " . s:maximize_session
		only
		tabonly
	endif
endfunction
nnoremap <C-W>z :call MaximizeToggle()<CR>


" Buffer switching
nnoremap <silent> <F1> :bp<CR>
nnoremap <silent> <F2> :bn<CR>
inoremap <silent> <F1> <Esc>:bp<CR>
inoremap <silent> <F2> <Esc>:bn<CR>


" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk


" Clear highlight
nnoremap <silent> <Space> <Space>:noh<CR>


" Closing buffers
nnoremap <silent> <leader>c :bd<CR>
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
	autocmd FileType python setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4

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

