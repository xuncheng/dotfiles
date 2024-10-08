" This .vimrc file is based on Gary Bernhardt's .vimrc file
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc

autocmd!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-Plug Initialization
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'dstein64/vim-startuptime'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mileszs/ack.vim'
Plug 'mattn/emmet-vim'
Plug 'godlygeek/tabular'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vividchalk'
" Plug 'herrbischoff/cobalt2.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kana/vim-textobj-user'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" themes
Plug 'haishanh/night-owl.vim'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim'
Plug 'jonathanfilip/vim-lucius'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

Plug 'scrooloose/nerdtree',            { 'on':  'NERDTree' }

Plug 'posva/vim-vue',                  { 'for': 'vue' }
Plug 'tpope/vim-jdaddy',               { 'for': 'json' }
Plug 'junegunn/goyo.vim',              { 'for': 'markdown' }
Plug 'elixir-lang/vim-elixir',         { 'for': 'elixir' }
Plug 'kylef/apiblueprint.vim',         { 'for': 'apiblueprint' }
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffeescript' }
Plug 'cakebaker/scss-syntax.vim',      { 'for': ['scss', 'sass'] }
Plug 'dearrrfish/vim-applescript',     { 'for': 'applescript' }
Plug 'dense-analysis/ale',             { 'for': ['js', 'vue'] }

Plug 'tpope/vim-rails',                { 'for': 'ruby' }
Plug 'ngmy/vim-rubocop',               { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }
Plug 'jgdavey/vim-blockle',            { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',           { 'for': 'ruby' }
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }

Plug 'fatih/vim-go',                   { 'do': ':GoUpdateBinaries' }

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable built-in matchit plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime macros/matchit.vim

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITTING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buff. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Don't make backups at all
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" If a file is changed outside of vim, automatically reload it without asking
set autoread
" Enable highlighting for syntax
syntax on
" Enable file type detection
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cident' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Display extra whitespace
set list listchars=tab:»·,trail:·
" Numbers
set nu
set numberwidth=5
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Save on buffer switch
:set autowrite
" True color mode! (Requires a fancy modern terminal, but iTerm works.)
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  " Fix $TERM in tmux
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  set termguicolors
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " For ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  " For API Blueprint, autoindent with four spaces
  autocmd FileType apiblueprint setlocal sw=4 sts=4 et
  autocmd FileType applescript setlocal sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass
  autocmd! BufRead,BufNewFile *.jbuilder setfiletype ruby

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  " *.md is markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set t_Co=256 " 256 colors
:set background=dark
:color grb24bit
:hi CursorLine cterm=none
:hi CursorLineNr cterm=none

if has("gui_running")
  set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
  set linespace=2
  set guifont=Dank\ Mono:h16
  :color cobalt2
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" :set statusline=[%n]\ %<%f\ %m\%y%{fugitive#statusline()}%=%l,%c%V\ %P
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>
" Execute ruby code
nnoremap <leader>r :!ruby %<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', old_name, 'file')
  if new_name != '' && new_name != old_name
    call rename(old_name, new_name)
    exec ':e ' . new_name
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXTRACT VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ExtractVariable()
  let name = input("Variable name: ")
  if name == ''
      return
  endif
  " Enter visual mode (not sure why this is needed since we're already in
  " visual mode anyway)
  normal! gv

  " Replace selected text with the variable name
  exec "normal c" . name
  " Define the variable on the line above
  exec "normal! O" . name . " = "
  " Paste the original selected text to be the variable value
  normal! $p
endfunction
vnoremap <leader>rv :call ExtractVariable()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INLINE VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InlineVariable()
  " Copy the variable under the cursor into the 'a' register
  :let l:tmp_a = @a
  :normal "ayiw
  " Delete variable and equals sign
  :normal 2daW
  " Delete the expression into the 'b' register
  :let l:tmp_b = @b
  :normal "bd$
  " Delete the remnants of the line
  :normal dd
  " Go to the end of the previous line so we can start our search for the
  " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
  " work; I'm not sure why.
  normal k$
  " Find the next occurence of the variable
  exec '/\<' . @a . '\>'
  " Replace that occurence with the text we yanked
  exec ':.s/\<' . @a . '\>/' . escape(@b, "/")
  :let @a = l:tmp_a
  :let @b = l:tmp_b
endfunction
nnoremap <leader>ri :call InlineVariable()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|svn))$'
let g:ctrlp_user_command  = 'find %s -type f'
let g:ctrlp_use_caching   = 0
let g:ctrlp_extensions    = ['funky']
nnoremap <leader>fu :CtrlPFunky<cr>
noremap <leader>fm :CtrlP ./app/models/<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use The Silver Searcher
" https://github.com/ggreer/the_silver_searcher
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  let g:ackprg = 'ag --vimgrep'

  cnoreabbrev ag Ack
  cnoreabbrev aG Ack
  cnoreabbrev Ag Ack
  cnoreabbrev AG Ack

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  nnoremap <Leader>ag :Ack<CR>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags Configuration, exclude Javascript files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RSpec.vim Configuration
" https://github.com/thoughtbot/vim-rspec
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rspec_runner = "os_x_iterm2"
let g:rspec_command = "!bin/rspec {spec}"
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add buffer tabs on top.
" let g:airline#extensions#tabline#enabled = 1
" Use Powerline symbols and replace the separator symbols
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabularize Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>a# :Tabularize/#<CR>
vmap <Leader>a# :Tabularize/#<CR>
nmap <Leader>ah :Tabularize/=><CR>
vmap <Leader>ah :Tabularize/=><CR>
" lolvim: the sequence "\@!" apparently means "zero of the thing I just said"
nmap <Leader>a= :Tabularize/=>\@!<CR>
vmap <Leader>a= :Tabularize/=>\@!<CR>

nmap <Leader>a; :Tabularize/;<CR>
vmap <Leader>a; :Tabularize/;<CR>
nmap <Leader>a{ :Tabularize/{<CR>:Tabularize/}<CR>
vmap <Leader>a{ :Tabularize/{<CR>:Tabularize/}<CR>

" NOTES:
" * \zs is basically a zero-width lookbehind assertion;
"   it eats spaces before the comma/colon/whatever.
"   See: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
" * l0c1 is a format specifier that says
"   "left, then zero spaces, then [delimiter], then 1 space"
"   See: https://raw.github.com/godlygeek/tabular/master/doc/Tabular.txt
nmap <Leader>a: :Tabularize/:\zs /l0c0<CR>
vmap <Leader>a: :Tabularize/:\zs /l0c0<CR>
nmap <Leader>a, :Tabularize/,\zs/l0c1<CR>
vmap <Leader>a, :Tabularize/,\zs/l0c1<CR>
nmap <Leader>ato :Tabularize/).to\(_not\)\?<CR>:Tabularize/expect(<CR>
vmap <Leader>ato :Tabularize/).to\(_not\)\?<CR>:Tabularize/expect(<CR>
nmap <Leader>a( :Tabularize/(\zs/l0c1<CR>:Tabularize/)/l1c0<CR>
vmap <Leader>a( :Tabularize/(\zs/l0c1<CR>:Tabularize/)/l1c0<CR>
nmap <Leader>a[ :Tabularize/[\zs/l0c1<CR>:Tabularize/]/l1c0<CR>
vmap <Leader>a[ :Tabularize/[\zs/l0c1<CR>:Tabularize/]/l1c0<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" InsertTime COMMAND
" Insert the current time
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RemoveFancyCharacters COMMAND
" Remove smart quotes, etc.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add the pry debug line with \bp (or <Space>bp, if you did: map <Space> <Leader> )
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>vbp o<%= require'pry';binding.pry %><esc>:w<cr>
map <Leader>bp orequire'pry';binding.pry<esc>:w<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE Configuration
" https://github.com/dense-analysis/ale
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_fix_on_save = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand("find " . a:path . "/* -type f", "", ":e")
endfunction

nnoremap <leader>f :call SelectaFile(".")<cr>
nnoremap <leader>ga :call SelectaFile("api")<cr>
nnoremap <leader>gv :call SelectaFile("app/views")<cr>
nnoremap <leader>gc :call SelectaFile("app/controllers")<cr>
nnoremap <leader>gm :call SelectaFile("app/models")<cr>
nnoremap <leader>gh :call SelectaFile("app/helpers")<cr>
nnoremap <leader>gs :call SelectaFile("app/services")<cr>
nnoremap <leader>gj :call SelectaFile("app/frontend/javascripts")<cr>
nnoremap <leader>gw :call SelectaFile("app/jobs app/workers")<cr>
nnoremap <leader>gl :call SelectaFile("lib")<cr>
nnoremap <leader>gt :call SelectaFile("spec")<cr>
nnoremap <leader>gp :call SelectaFile("app/policies")<cr>
nnoremap <leader>gf :call SelectaFile("features")<cr>
nnoremap <leader>gr :call SelectaFile("config")<cr>

"Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rails.vim Configuration, https://github.com/tpope/vim-rails
"
" Add :Eservice command for app/services/*.rb
" Add :Eserializer command for app/serializers/*.rb
" Add :Equery command for app/queries/*.rb
" Add :Efactory command for spec/factories/*.rb
" Add :Epresenter command for app/presenters/*.rb
" Add :Epolicy command for app/policies/*.rb
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rails_projections = {
  \  "app/services/*_service.rb": {
  \    "command":   "service",
  \    "alertnate": "spec/services/%i_spec.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/services/%i_spec.rb",
  \    "template":  "class %SService\nend",
  \    "keywords":  "service sequence"
  \  },
  \  "app/serializers/*_serializer.rb": {
  \    "command":   "serializer",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/serializers/%i_spec.rb",
  \    "template":  "class %SSerializer < ActiveModel::Serializer\nend",
  \    "keywords":  "serializer sequence"
  \  },
  \  "app/queries/*_query.rb": {
  \    "command":   "query",
  \    "alertnate": "spec/queries/%i_spec.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/queries/%i_spec.rb",
  \    "template":  "class %SQuery\nend",
  \    "keywords":  "query sequence"
  \  },
  \  "spec/factories/*.rb": {
  \    "command":   "factory",
  \    "affinity":  "collection",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/models/%i_spec.rb",
  \    "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
  \    "keywords":  "factory sequence"
  \  },
  \  "spec/factories.rb": {"command": "factory"},
  \  "app/presenters/*_presenter.rb": {
  \    "command":   "presenter",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/presenters/%i_spec.rb",
  \    "template":  "class %SPresenter < BasePresenter\n  presents :%i\nend",
  \    "keywords":  "presenter sequence"
  \  },
  \  "app/presenters/application_presenter.rb": {"command": "presenter"}}
