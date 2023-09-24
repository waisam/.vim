" ==================== Editor behavior =====================
set nocompatible
set backspace=indent,eol,start
set t_Co=256
syntax enable
filetype plugin indent on
set nu
set rnu
set shiftwidth=2
set tabstop=2
set softtabstop=2
set showcmd
set laststatus=2
set scrolloff=5
set wildmenu
set wildmode=list:longest
set encoding=utf-8
set spelllang=en_us,cjk
" ==================== Stauts Line ======================
set statusline=2
set statusline=                          " left align
set statusline+=%2*\                     " blank char
set statusline+=%2*\%{StatuslineMode()}
set statusline+=%2*\ 
set statusline+=%1*\ <<
set statusline+=%1*\ %f                  " short filename
set statusline+=%1*\ >>
set statusline+=%1*\ 
set statusline+=%1*\%h%m%r               " file flags (help, read-only, modified)
set statusline+=%=                       " right align
set statusline+=%*
set statusline+=%4*\%{b:gitbranch}       " include git branch
set statusline+=%3*\ 
set statusline+=%3*\%.25F                " long filename (trimmed to 25 chars)
set statusline+=%3*\::
set statusline+=%3*\%l/%L\\|             " line count
set statusline+=%3*\%y                   " file type
hi User1 ctermbg=BLACK ctermfg=GREY guibg=BLACK guifg=GREY
hi User2 ctermbg=GREEN ctermfg=BLACK guibg=GREEN guifg=BLACK
hi User3 ctermbg=BLACK ctermfg=LIGHTGREEN guibg=BLACK guifg=LIGHTGREEN
hi User4 ctermbg=MAGENTA ctermfg=BLACK guibg=BLACK guifg=LIGHTGREEN

" Get current mode
function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#'n'
        return 'NORMAL'
    elseif l:mode==?'v'
        return 'VISUAL'
    elseif l:mode==#'i'
        return 'INSERT'
    elseif l:mode==#'R'
        return 'REPLACE'
    endif
endfunction

function! Get_branch_name()
  let b:gitbranch=''
  if &modifiable
    try
      lcd %:p:h
    catch
      return
    endtry
    let l:gitrevparse=system('git branch --show-current')
    lcd-
    if l:gitrevparse!~'.git'
      let b:gitbranch='['.substitute(l:gitrevparse, '\n', '', 'g').']'
    endif
  endif
endfunction

augroup GetBranch
  autocmd!
  autocmd BufEnter * call Get_branch_name()
augroup END
" ==================== Basic Mappings ======================
" Set mapleader from backslash  to space
" let mapleader = " "
" nnoremap Q :q<CR>
" nnoremap W :w<CR>
" Copy to system clipboard
vnoremap Y "+y
" mapping leader+o to open floding
nnoremap <LEADER>o za
" Open the file under the cursor
nnoremap gf :tabe <cfile><CR>
" 随时编辑vim配置<LEADER> is backslash
nnoremap <LEADER>rc :e $MYVIMRC<CR>
augroup sorc 
	autocmd!
	" auto source vim config
	autocmd BufWritePost *{vim,ex}{rc,} exec ':so %'
augroup END
" 取消搜索结果高亮
noremap <LEADER><CR> :set hlsearch!<CR>
" insert a pair of {} and go to the next line
inoremap <C-y> <ESC>A {}<ESC>i<CR><ESC>O
" Spelling Check with <space>sc
nnoremap <LEADER>sc :set spell!<CR>

" ==================== Use System Commands ======================
" run specified system command and read result into current buffer
" nnoremap <c-r> :r!
" read figlet out into current buffer
nnoremap fig :r!figlet 

" ==================== Cursor Movement =====================
" 修改搜索时n键的行为
nnoremap = n
nnoremap - N

" ==================== Tab management ===================
noremap te :tabe<CR>
noremap tf :tabf <cfile><CR>
noremap th :-tabnext<CR>
noremap tl :+tabnext<CR>
if has('terminal')
	noremap tt :tab term<CR>
endif

" ==================== Window management ===================
" 使用\ + h,j,k,l来切换窗口
noremap <LEADER>w <C-w>w
noremap <LEADER>h <C-w>h
noremap <LEADER>j <C-w>j
noremap <LEADER>k <C-w>k
noremap <LEADER>l <C-w>l
" \ + c关闭窗口
noremap <LEADER>c <C-w>o
" 禁用s键的默认行为
noremap s <Nop>
" 向上(水平)、向下(水平)、、向左(垂直)、向右(垂直)分割窗口
noremap sk :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sj :set splitbelow<CR>:split<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>
" 使用方向键调整当前窗口大小
noremap <Up> :res +5<CR>
noremap <Down> :res -5<CR>
noremap <Left> :vertical resize-5<CR>
noremap <Right> :vertical resize+5<CR>

" ==================== Run =====================
autocmd BufWinEnter *.c,*.py,*.java nnoremap <silent>r :w<CR>:call Run()<CR>
func! Run()
	" 保存文件
	exec "w"
	if &filetype == 'c'
		set splitbelow
		term ++shell gcc %:p -o %:p:r && %:p:r
	elseif &filetype == 'python'
		set splitbelow
		term python %:p
	elseif &filetype == 'java'
		set splitbelow
		let l:package = substitute(getline(search('package')), '^\s*package\s\+\(.*\);\s*$', '\1', '')
		exec 'term ++shell javac -d %:p:h %:p && java -cp %:p:h '.l:package .'.'.'%<'
	endif
endfunc

" ==================== Debug =====================
autocmd BufWinEnter *.c,*.py noremap <silent><F5> :w<CR>:term python -m pdb %:p<CR>

" ==================== ternimal scroll =====================
" CTRL-W,N后正常使用hjkl
" Go to Terminal-Normal mode
tnoremap <C-n> <C-w>N

" ==================== Check/Install Vim-Plug ====================
if empty(glob($HOME.'/.vim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sysnc | source $MYVIMRC
endif

" ==================== Install Plugins with Vim-Plug ====================
call plug#begin('~/.vim/plugged/')

" File navigation
Plug 'francoiscabrol/ranger.vim'

" 给光标单词加下划线、高亮
Plug 'itchyny/vim-cursorword'

" 状态栏

" Git
" Plug 'tpope/vim-fugitive'

" 自动补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Java

"Kotlin
Plug 'udalov/kotlin-vim'

" Python

" Markdown

call plug#end()

" ==================== GDB Support =============
packadd termdebug
let g:termdebug_config={
	\'wide':1,
\}
nnoremap dbg :Termdebug<CR>

" ==================== File Navigation =============
" choose one of the follow navigation
" Use Netrw
" source $HOME/.vim/configuration/netrw.vim

" Use rangerr.vim
source $HOME/.vim/configuration/ranger.vim

" ==================== coc.nvim ====================
let g:coc_global_extensions = [
			\ 'coc-diagnostic', 
			\ 'coc-git',
			\ 'coc-gitignore', 
			\ 'coc-java', 
			\ 'coc-json', 
			\ 'coc-prettier', 
			\ 'coc-pyright', 
			\ 'coc-snippets', 
			\ 'coc-sql', 
			\ 'coc-syntax', 
			\ 'coc-translator',
			\ 'coc-vimlsp', 
			\ 'coc-yaml',
			\ 'coc-yank'
			\]

" coc configuration
source $HOME/.vim/configuration/coc.vim

