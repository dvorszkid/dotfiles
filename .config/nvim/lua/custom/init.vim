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
let g:vim_json_conceal=0 " Disable quote concealing in JSON files


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
set wildoptions=pum     " to show completions in a popup (since vim9)
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
set updatetime=300		" check for changes in every second
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
set undodir=~/.vim/undo
set undofile


""
" GUI settings
""
if has('gui_running')
	set guioptions-=T  " no toolbar
	set guifont=FiraCode\ Nerd\ Font\ 9
endif


""
" Per project vimrc
""
" set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files


" Paste mode
set pastetoggle=<F3>
noremap <silent> <leader>p :set paste<CR>p:set nopaste<CR>
noremap <silent> <leader>P :set paste<CR>P:set nopaste<CR>


" Share X windows clipboard
if has('unnamedplus')
	set clipboard^=unnamed,unnamedplus
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


" More natural line positioning on wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk


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


" DISPLAY update function and command (similar to .zshrc)
function! s:update_display_env(force)
    if !exists('$TMUX')
        return
    endif
    let l:new_display = system("tmux show-environment DISPLAY")
    if v:shell_error
        return
    endif
    let l:new_display = split(split(l:new_display, '\n')[0], '=')[1]
    if !a:force && $DISPLAY == l:new_display
        return
    endif

    let $DISPLAY=l:new_display
    xrestore
endfunction
command! DISPLAY :call s:update_display_env(1)


" My custom autocmds
augroup my_commands
	" Clear commands first for multiple vimrc reloads
	autocmd!

	" Trim whitespaces
	autocmd FileType c,cpp,cs,python,ruby,java,proto,lua,php,gn,rust autocmd BufWritePre <buffer> :%s/\s\+$//e

	" Fix tab settings for python
	autocmd FileType python setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4

	" Re-adjust windows on window resize
	autocmd VimResized * wincmd =

	" Try to update $DISPLAY when window is resized, which usually happens
	" when attaching from local or over ssh.
	autocmd VimResized * silent! call s:update_display_env(0)

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


" Quickfix list files to arg list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
