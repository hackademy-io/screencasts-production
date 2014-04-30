set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'wavded/vim-stylus'
Bundle 'othree/html5.vim'
Bundle 'ngmy/vim-rubocop'

" original repos on github
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'

" Language Additions
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-haml'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-rails'
Bundle 'slim-template/vim-slim'
Bundle 'groenewege/vim-less'
Bundle 'uarun/vim-protobuf'

" Snippets
Bundle "SirVer/ultisnips"
Bundle "honza/vim-snippets"

" Libraries
Bundle 'L9'
Bundle 'tpope/vim-repeat'

" Colors
" Bundle 'altercation/vim-colors-solarized'

" ...

filetype plugin indent on     " required! 
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" ---------------
" Backups
" ---------------
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" ---------------
" UI
" ---------------
set ruler " Ruler on
set nu " Line numbers on
" set nowrap " Line wrapping off
set laststatus=2 " Always show the statusline
set cmdheight=2
set showcmd
set list!
set listchars=trail:◃,nbsp:•,tab: ➙

" ---------------
" Text Format
" ---------------
set tabstop=2
set backspace=2 " Delete everything with backspace
set shiftwidth=2 " Tabs under smart indent
set cindent
set autoindent
set smarttab
set expandtab
set backspace=2

" ---------------
" Behaviors
" ---------------
syntax enable
set hidden
set history=1000
set title
set scrolloff=3
set foldlevel=99
set modeline
set modelines=5

" ---------------
" Searching
" ---------------
set ignorecase " Case insensitive search
set smartcase " Non-case sensitive search
set incsearch
set hlsearch

" ---------------
" Visual
" ---------------
set showmatch " Show matching brackets.
set matchtime=2 " How many tenths of a second to blink

" ---------------
" Sounds
" ---------------
set noerrorbells
set novisualbell
set t_vb=


" ---------------
" Mouse
" ---------------
set mousehide " Hide mouse after chars typed
set mouse=a " Mouse in all modes


" ----------------------------------------
" Bindings
" ----------------------------------------
map <F3> :setlocal spell spelllang=fr_fr

let mapleader = ","

map <F1> <Esc>
imap <F1> <Esc>

" ---------------
" NERDTree
" ---------------
map <F2> :NERDTreeToggle<CR>
nmap <silent><C-n> :NERDTree<CR>
nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nc :NERDTreeClose<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2 " Change the NERDTree directory to the root node

" --------------
" CTRL P
" --------------

set wildignore+=*.so,*.swp,*.zip,*.tar,*.tar.gz,*.tgz,*.o,*.bin

let g:ctrlp_map = '<leader>o'
let g:ctrlp_max_height = 4
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
let g:ctrlp_working_path_mode = 'ra'

" ---------------
" status.vim
" ---------------
let g:statusline_fugitive=1
let g:statusline_fullpath=0
" Everything must be after Right Separator for BufStat
let g:statusline_order=[
      \ 'Filename',
      \ 'Encoding',
      \ 'Help',
      \ 'Filetype',
      \ 'Modified',
      \ 'Fugitive',
      \ 'RVM',
      \ 'TabWarning',
      \ 'Syntastic',
      \ 'Paste',
      \ 'ReadOnly',
      \ 'RightSeperator',
      \ 'CurrentHighlight',
      \ 'CursorColumn',
      \ 'LineAndTotal',
      \ 'FilePercent']

" ---------------
" Ack
" ---------------

map <leader>a :Ack -w <cword><CR>

if has("gui_running")
  colorscheme railscasts
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
else
  set t_Co=256
  set term=screen-256color
  colorscheme railscasts_console
endif


set rtp+=/usr/share/vim/addons
set rtp+=$GOROOT/misc/vim

" -------
" Airline
" -------

let g:airline_powerline_fonts = 1


noremap "+p :call setreg("\"", system("xclip -o -selection clipboard"))<CR>""p
noremap "+P :call setreg("\"", system("xclip -o -selection clipboard"))<CR>""P
vnoremap "+y y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
