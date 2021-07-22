"
" Required for package manager
"
set nocompatible              " be iMproved, required
filetype off                  " required


"
" Hostname for host specific configuration
"
let s:hostname = substitute(system('hostname'), '\n', '', '')
let s:is_devel = s:hostname =~ "bp1-dsklin"


"
" Plugin list (using VimPlug)
"
let vimplug_path = '~/.vim/autoload/plug.vim'
if empty(glob(vimplug_path))
    silent execute '!curl -fLo ' . vimplug_path . ' --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" For Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv', {'on': 'Gitv'}
Plug 'airblade/vim-gitgutter'

" Theme
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lifepillar/vim-solarized8' " too blue
Plug 'rakr/vim-one' " too purple, bad TODO highlight, bad comment readability
Plug 'sainnhe/sonokai' " too red, bad TODO highlight
Plug 'morhetz/gruvbox' " too retro
Plug 'dvorszkid/tender.vim'

" Misc
Plug 'liuchengxu/vim-which-key'
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
Plug 'machakann/vim-highlightedyank'
Plug 'vim-scripts/PushPop.vim'
Plug 'vim-scripts/genutils' " for PushPop

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
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
"Plug 'dense-analysis/ale'

" Language Server Protocol
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
if executable('cargo')
    Plug 'tsufeki/asyncomplete-fuzzy-match', { 'do': 'cargo build --release' }
endif
"Plug 'jackguo380/vim-lsp-cxx-highlight' " clangd is only supported via coc.nvim, actually inconsistent (comment in lambda in macro is not colored as other comments)

" Lua programming
Plug 'tbastos/vim-lua', {'for': ['lua']}

" C++ programming
Plug 'derekwyatt/vim-fswitch', {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
Plug 'peterhoeg/vim-qml', {'for': ['qml']}

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
"nmap <silent> <C-p> <leader>;f
nmap <silent> <C-t> <leader>st


" Yoink + FZF + vim-multiple-cursors
map <expr> <C-p> yoink#isSwapping() ? '<plug>(YoinkPostPasteSwapForward)' : '<leader>sf'
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
"let g:airline_theme = '' " automatic
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


" Vim Which Key
highlight default link WhichKeyGroup Operator
nnoremap <silent> <leader> :silent WhichKey '\'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '\'<CR>
let g:which_key_vertical = 1
let g:which_key_use_floating_win = 1
let g:which_key_map = {}
let g:which_key_map.a = {
      \ 'name' : '+admin' ,
      \ }
let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ '/' : [':FzfHistory/'     , 'history'],
      \ ';' : [':FzfCommands'     , 'commands'],
      \ 'a' : [':FzfAg'           , 'text Ag'],
      \ 'l' : [':FzfLines'        , 'lines'] ,
      \ 'h' : [':FzfHistory'      , 'file history'],
      \ 'b' : [':FzfBuffers'      , 'open buffers'],
      \ 'w' : [':FzfWindows'      , 'search windows'],
      \ 'f' : [':FzfFiles'        , 'files'],
      \ 'g' : [':FzfGFiles'       , 'git files'],
      \ 'G' : [':FzfGFiles?'      , 'modified git files'],
      \ 'H' : [':FzfHelptags'     , 'help tags'] ,
      \ 'm' : [':FzfMaps'         , 'normal maps'] ,
      \ 'M' : [':FzfMarks'        , 'marks'] ,
      \ 'c' : [':FzfColors'       , 'color schemes'],
      \ 't' : [':FzfBTags'        , 'buffer tags'],
      \ 'T' : [':FzfTags'         , 'project tags'],
      \ 'y' : [':FzfFiletypes'    , 'file types'],
      \ }
call which_key#register('\', "g:which_key_map")

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


" VSnip
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" ALE
" lint on save, insert leave
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_linters_explicit = 1

let g:ale_linters = {'javascript': ['eslint'], 'typescript': ['eslint']}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'javascript': ['eslint'],
            \   'typescript': ['eslint'],
            \}


" LSP
"let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server']
let g:lsp_settings = {
            \ 'clangd': {
            \     'cmd': [
            \         'clangd',
            \         '--background-index',
            \         '--clang-tidy-checks=-*',
            \         '--header-insertion=never',
            \     ],
            \ },
            \ }
if executable('ccls-disabled')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'ccls',
                \ 'cmd': {server_info->['ccls']},
                \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
                \ 'initialization_options': {
                \   'highlight': { 'lsRanges' : v:true },
                \ },
                \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
                \ })
endif

let g:lsp_work_done_progress_enabled = 1
let g:lsp_diagnostics_float_cursor = 1

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> pd <plug>(lsp-peek-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> pi <plug>(lsp-peek-implementation)
    nmap <buffer> gy <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    "nnoremap <buffer><silent> <F4> :LspDocumentSwitchSourceHeader<CR> " does not work
    inoremap <buffer><silent> <F4> <Esc>:LspDocumentSwitchSourceHeader<CR>
    nnoremap <buffer><silent> <leader>ld :LspDocumentDiagnostics<CR>
    nnoremap <buffer><silent> <leader>la :LspCodeAction<CR>
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    "let g:lsp_format_sync_timeout = 1000
    "autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" AsyncComplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <C-Space> <Plug>(asyncomplete_force_refresh)
"let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
" Preview window
" allow modifying the completeopt variable, or it will be overridden all the time
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


" UndoTree
nnoremap <silent> <leader>u :UndotreeToggle<CR>


" EasyGrep
let g:EasyGrepCommand=1
nnoremap <leader>/ :FzfAg
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
" disable auto update when colors change
let g:airline#extensions#tmuxline#enabled = 0

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
set timeoutlen=400      " also used by vim-which-key plugin
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
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
syntax on
set background=dark
let g:load_doxygen_syntax = 1
let g:sonokai_disable_italic_comment = 1
let g:gruvbox_italicize_comments = 0
let g:gruvbox_contrast_dark = "hard"
colorscheme tender


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
	set clipboard^=unnamed,unnamedplus
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


" Admin features
nnoremap <Plug>(open-vimrc) :tabedit $MYVIMRC<CR>
nmap <leader>ae <Plug>(open-vimrc)
nnoremap <Plug>(reload-vimrc) :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nmap <leader>ar <Plug>(reload-vimrc)
nnoremap <Plug>(plugin-install) :PlugClean<CR>:PlugInstall<CR>
nmap <leader>ap <Plug>(plugin-install)


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

